Import-Module $env:SyncroModule

<#
.SYNOPSIS
  Installs the AutoElevate agent using information from PSA.
.NOTES
  Because there really isn't fields for "location" and it is required by the MSI
  installer, so instead I am using contact information associated with the device
  as the contact.  If there is no contact information associated with the device,
  it defaults to "Main Office".  To default everything to "Main Office", change
  "do_not_use_contacts" to "true" (you can also change "Main Office" to anything
  you want using the variables below).
  
  If there is no company name, the name defaults to "Consumer Customers".  You can
  change that default below in "default_company_name" if you wish.
  
.DIRECTIONS
  Insert your license key below.  Change the default agent mode if you desire,
  it is currently set to AutoElevate's recommended default for onboarding clients
  which only audits the customer's environemnt without making any experience
  changes.  After you have a baseline, you are able to change the agent mode to
  "live" to fully utilize AutoElevate.
#>

$license_key = "YOUR LICENSE KEY HERE"

$agent_mode = "audit"
$do_not_use_contacts = "false"
$default_location_name = "Main Office"
$default_company_name = "Consumer Customers"

# You shouldn't need to update anything below here.



<#
  Need to get initials for a required msi switch.  Split the company name by
  spaces, select the first character from each resulting array object, and add it
  to the blank placeholder for company_initials.
#>

$use_company_name = $company_name

if ($company_name -eq "") {
    $use_company_name = $default_company_name   
}

$use_location_name = $location_name
$use_location_id = $location_id

if ($do_not_use_contacts -eq "true") {
    $use_location_name = $default_location_name
    $use_location_id = $company_id
}

if ($location_name -eq "") {
    $use_location_name = $default_location_name
    $use_location_id = $company_id
}

$namesplit = $company_name.split(' ')
$company_initials = ""
echo $namesplit | ForEach-Object -Process {
    if ($_ -ne "") {
        $company_initials += $_.Substring(0, 1)
    }
}


# Run the install
msiexec /i C:\AESetup.msi /quiet LICENSE_KEY=""""$license_key"""" COMPANY_ID=""""$company_id"""" COMPANY_NAME=""""$use_company_name"""" COMPANY_INITIALS=""""$company_initials"""" LOCATION_ID=""""$use_location_id"""" LOCATION_NAME=""""$use_location_name"""" AGENT_MODE=""""$agent_mode""""
