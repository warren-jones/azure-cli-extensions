# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

# >>>>> Temporary dev setup
# az account set -s 677fc922-91d0-4bf6-9b06-4274d319a0fa
# az quantum workspace set -l eastus -g rg-v-wjones2 -w v-wjones-qw2
# <<<<<

az quantum execute --target-id ionq.simulator -o table | Out-File -Encoding "UTF8" -FilePath .\execute-console-output.txt
$foundFirstLine = $false
$foundSecondLine = $false
foreach ($line in Get-Content .\execute-console-output.txt) {
    # if ((-not $foundFirstLine) -and ($line -match "Building project...")) {
    if ((-not $foundFirstLine) -and ($line -eq "Building project...")) {
        Write-Host "Found the first progress message: $line"
        $foundFirstLine = $true
    }
    else {
        if ($foundFirstLine) {
            if ($line -eq "Submitting job...") {
                Write-Host "Found the second progress message: $line"
                $foundSecondLine = $true
            } 
            break
        }
    }
}

if ($foundFirstLine -and $foundSecondLine) {
    Write-Host "The progress messages were valid"
    return $true
}
else {
    throw("Error: The progress messages were not as expected")
}
