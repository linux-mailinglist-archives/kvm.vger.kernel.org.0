Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E26C7A0F44
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 22:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjINUsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 16:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjINUst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 16:48:49 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6632698;
        Thu, 14 Sep 2023 13:48:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sbul43BYOxz/PDTCrrLSTQLd9senMZ5PMCMjyUCcolZ8V5v306X7Hy3+2AWBWTglKN02BcB5ZjjI4cUgO11Qnyl6PEkPg+v/maGjIeJ0MZSrlyau094FIiCRpiUO33E52cEet1l56dYennBwZrEvXfAaKeQVaeiXUOV99rGkHZVR5eIxIg1ZvW7Uh9NebtZkc9s/RZiL5h85tmdkFvmQlZAPPm+kUiRK2H2P2jJ4iWYqOTKA9GSNHVK2xnV+eUkM8/5t1sLKbo8//mR7Rg67FwRVHKMXJJUx761dMPa55XG4M0TruZWXPW2AsElCWkvwETrpBr+uSgQ73eAOmI+u/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylOz7uclU1zKDMBW8dkjBcZHCAXO4P85sxLIHQ4mYOM=;
 b=C4ysvoaI5watObiJjnRWN78VUVaQRhTDqPaEZdmll4lZLiRM3/pn3hYexkY7Fbr1ILrFKEYP50rUYQpQ1cmYJ5UNb/uua8HjPoBqxEl1BOjF4AuzPhtG4guSeH99SkmV1zPTyojQPJYillm0WTEZXBiaO7A4Bu0OO+yNCZ39Mr+6Ke+ZmmRFz1cDVuiKtRVypTm3y45qBUTmsIKf8wkTd2fJeHy8EaTHYxu92lMxyz6O8I3jwQQ4bpWLFUC+tcTw6d4HOnbYe+1uphHwplTbQenGYRebCX5gYWkZJhjWjFbmZakG3sW/j14gYmCTTv4bohvyg6nhONbtgmxYsETblA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylOz7uclU1zKDMBW8dkjBcZHCAXO4P85sxLIHQ4mYOM=;
 b=peqm+UoY+RNrc0bu2RavSqywZnfPGFsU7CqXFH96PTMtEZGI254zsdaa/nzTgy6QHtDMW+/ChhFCV/ZKX1HLJux+atAm8ElzOBa6wvNkg4TPNlkm7PUWnFq45w9t/tqxjq3wYbPkdBcn0GIyxHQbHssUenmBnfdf5PDp7+GpfU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB6668.namprd12.prod.outlook.com (2603:10b6:510:1aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Thu, 14 Sep
 2023 20:48:42 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6792.020; Thu, 14 Sep 2023
 20:48:42 +0000
Message-ID: <f2c0907c-9e30-e01b-7d65-a20e6be4bf49@amd.com>
Date:   Thu, 14 Sep 2023 15:48:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
References: <cover.1694721045.git.thomas.lendacky@amd.com>
 <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
 <ZQNs7uo8F62XQawJ@google.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZQNs7uo8F62XQawJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0044.namprd12.prod.outlook.com
 (2603:10b6:802:20::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB6668:EE_
X-MS-Office365-Filtering-Correlation-Id: f143f31e-7e96-4bf4-03ae-08dbb563faf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yVQme40ewFTXUkgQ67zFFidy6LgYn2iYLD/a5FTdeYRvL8MWAtHglKr5v/NveRD8CShyjV62zPRSwNCy/HPRswhs3UFcTb4goI6b484gVtgeiGcjs2ts6Z3m7xPxqRQmPMb2EAgfVQfPOZ/jTn5/3MpsROOthQLbI87NGF5hWHjr6Hm1dV+Pef/ysBUAEY6Y9e5QkwgFJ9IoT8VqNWtO3QfzResy5YvvMiVhzus6xUdQMSuugAJ0K0oBKKW0hch4rLcSAN/MmDZNzeQ/v9XtSC6w+/9tTeR2HFHnLDaRXOPxbP3/rsYjyOd5tt2WYp97t3Tf5Z/A0OLfiJ7POBexY5MHtpUu2mTEdpwKiWGfyFeTOakEDZsKnEwT+kYUt5VrIUgFjYKb2tMJEjOqdX+gmc+Wcr0zWeDFbIa/wDcWDHkiHRh4u8s0nku8Szhe66KlU7ihOyaSwIU5ctr9YDe0i6zGauVXNNpwbzJm4g8ePFauNRB2+Uqh3aNvSUVvqXThXB6pSS6hv3FiBS8Y2pk9aKIcAV6V48Fd3PXXMRoOlWA9CNjR7SzufTjNjlaFcdKzp2aUd9ol5xXZVOhGRgyt12/XUMuvf0xzHsbliBt1KNy3KR4+6MEcwSw3ntRPP+BOH33Bq2hfLPHOAxDPG8Nqug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(376002)(396003)(366004)(186009)(1800799009)(451199024)(8676002)(316002)(6916009)(54906003)(66946007)(36756003)(66556008)(66476007)(26005)(6506007)(6486002)(83380400001)(53546011)(86362001)(6512007)(38100700002)(2616005)(31696002)(478600001)(2906002)(31686004)(5660300002)(41300700001)(8936002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zkk2K3FsTCtlTDk2RnNFRHo2Rjh6VE43Z3lwMVBLbzBNeDlYTXh3ZXdnLzVo?=
 =?utf-8?B?b28wWjJsMWpiRTJKbVVtZUliekJPWmlmdXFIbnBsMDU3dXQ2K3hBUCtiTk9p?=
 =?utf-8?B?b2Y3V3dLU3cvUlNFUUVxQXBKVUZnV1oyQVJodWJBUzRHWklrT1FFcFQ2NkJl?=
 =?utf-8?B?T256Qk93R0xLMUFDc0FHQTlUOFdtUWJZWmUxeUZidWtHcU5aQjZXQ2RCMkE5?=
 =?utf-8?B?NkxNWlExVFE1ZDA5ajJpeURkb1NvZlpGc25YWjVqSUduZnMrVElXYTJpQkc4?=
 =?utf-8?B?MUtCcW1LS2hDUzhkWTdHN2JyT0JKMGdKTHY2MlJBdUd6L0NKTno2SFlGWmR6?=
 =?utf-8?B?Zm83STFsK1hkdE5XZnp1MHFxbHhGMGkyYzhFUzQzSWZGK2VJcWlkdStDL3l2?=
 =?utf-8?B?V1RBRklYQlk0S3c0eExGdXVjMlVKbVZ4bi9sanNmdmlEOTNRSTV4cDNwcmh2?=
 =?utf-8?B?ajBWR3ErbHc4MHA4RmphWmh0M1NSZDZtV2pBcmc2dmhGZ1pnSlZyYS9kdXd6?=
 =?utf-8?B?dG5hZEdiTjlsb29WUlgzMTFvYURLTmZ5ZFEzakx6dzlSK293MFFXejNBTnp4?=
 =?utf-8?B?Vk5qdy9Bb0c1RE1GTVFkZVQweUJEU1ByaTNQTUVWREVmZVl0QllqVjMyZjEz?=
 =?utf-8?B?ZXJwZTFBRHowdHZKamlncjBJUTFtSnIyWERvSXlNOEpBOTVFaXB2OUhNL3Zj?=
 =?utf-8?B?VnFxM0pyN2N3V1BGdXdDZ01HYlB6TXl5MDNoVlQxV2FheUpWYXpIbUkwN0tC?=
 =?utf-8?B?RkticC9PMTJlNFlJRnI5ZG11Mlh2RE0rK0JtZ1ZzU1I2NWhqamdrWlNuSGg2?=
 =?utf-8?B?NlVCUDdTa2dQcjVibzNJa3hSbnBIRU5PbU9uc1MxUnczOVZ5V0hNbDFhSGNM?=
 =?utf-8?B?QUdGa3JFOTNLMFRSRXBTRTViU09keEZJbWR5cXdOaGVZUkwyVzk0WmxDazFW?=
 =?utf-8?B?SUR2OENQSTJZWnhiNVhGcVVLZVB6eDUwa3d4QWhxc0hNK2lBaWxoZzV5eWQ3?=
 =?utf-8?B?cDErUkY4bnBncWhhMlJKVVZpRTg0aTloM2gwU25TSzVvc3lwL09sZ1pRd0dy?=
 =?utf-8?B?NlQ5MmFyR3YrTkFRODRmWnJkUFNaODNSbExKOUFCZzhZbGx2Njl0WXM0V2l1?=
 =?utf-8?B?YWw1R3pXS0pvQ2ZzZWtCc0xFaFovVXc5WmFqWkx0Mno0YUFhZFM2SnlrTGRp?=
 =?utf-8?B?d0N3czE0NUM4MzFONlBOSUNnNnRSbytYU2xnZlNacVQyTmxLWWZYT1plQVlu?=
 =?utf-8?B?ZmRRRWFKNEJqejk3Tm9QcUtsbThWZGtqNlBhbG85Q1lkd1BmMFRKTk43OVlV?=
 =?utf-8?B?YmNQcFc5SWt5VTB3WUF0d09zRFlBOUFVU2pxSXpYN3pBWFBsait3R2YxYWUz?=
 =?utf-8?B?YXl5d0tLN2NmRnlsMW00L2NmdmxaMkp2ZlNubkdZaFArOThaR244RFp5K09z?=
 =?utf-8?B?RXJNSU9hbUpNei9zdGtHRlk1dTN5bC8yK2NQWjI3Z0VvdFlqeFZOYW14QlB5?=
 =?utf-8?B?QmNHZVdLZ2lQSXQzckpQRVJSaFhNb3pIK1lPenZ2cldHOVlwSlMxM0NldCtk?=
 =?utf-8?B?ODhlOEhub1NFTEU2UkdHVElyV2NPc0t0RWx6WVJwZ2lTRDRFWit0L1J4WVF6?=
 =?utf-8?B?Qithby8wSmRKRUo1WityWS9qdy9CbXRuTGFsUFgvVXhaYVZnbGJlR2dSd1FF?=
 =?utf-8?B?bEtnS21lcGlaVW9IeFJMRkMwRGMyVDI0NjFOQmNtZThqUTRILzZubXJVbEpJ?=
 =?utf-8?B?dk5ySUtMZFU3WWFVZDBzbm8wbGgwd05ySkpiVVdSMG5GQVQ1S1Z6MDNROGp4?=
 =?utf-8?B?MG4vcmRucEFDdXpNRnhOdTl2ZVRpRUViLzRXc3pIVlV3SXczRVVPU3FQTlNz?=
 =?utf-8?B?T2g1WGJhZE44NnJoY3BkaUZNSXB2djJWYmNEQTdvNkpySjNyMjYvcm93YkRH?=
 =?utf-8?B?RGtJSlBHb0tUbnhlcVp3ME54aGZlMGgvbGRVSHFoWUZmQlhlMVZvaE40UXpr?=
 =?utf-8?B?TzRuUFZqUWRyRkM3d1dxTUFiemxTOUkxYWRPV0ViMDdZbEduMzB0WUlYL0tZ?=
 =?utf-8?B?WDVabmd0dk5LRzg1SFE0WGJpQXdLYmdrUlRPTnNIeFEzSTNFTUsyUnN3SXBh?=
 =?utf-8?Q?JyrTEGN6JAX/oD0o2BLQXx/L8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f143f31e-7e96-4bf4-03ae-08dbb563faf6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 20:48:42.1186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/M0rvNYcDwdZIhGkRNHfKuotSobm4mUNeTRD3951Mo3g49feNMBw4CNylDvkIr03bfhlW2VlBB1gWDy6gr9Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6668
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/23 15:28, Sean Christopherson wrote:
> On Thu, Sep 14, 2023, Tom Lendacky wrote:
>> The checks for virtualizing TSC_AUX occur during the vCPU reset processing
>> path. However, at the time of initial vCPU reset processing, when the vCPU
>> is first created, not all of the guest CPUID information has been set. In
>> this case the RDTSCP and RDPID feature support for the guest is not in
>> place and so TSC_AUX virtualization is not established.
>>
>> This continues for each vCPU created for the guest. On the first boot of
>> an AP, vCPU reset processing is executed as a result of an APIC INIT
>> event, this time with all of the guest CPUID information set, resulting
>> in TSC_AUX virtualization being enabled, but only for the APs. The BSP
>> always sees a TSC_AUX value of 0 which probably went unnoticed because,
>> at least for Linux, the BSP TSC_AUX value is 0.
>>
>> Move the TSC_AUX virtualization enablement into the vcpu_after_set_cpuid()
>> path to allow for proper initialization of the support after the guest
>> CPUID information has been set.
>>
>> Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++--------
>>   arch/x86/kvm/svm/svm.c |  3 +++
>>   arch/x86/kvm/svm/svm.h |  1 +
>>   3 files changed, 23 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index b9a0a939d59f..565c9de87c6d 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -2962,6 +2962,25 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>>   				    count, in);
>>   }
>>   
>> +static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
> 
> I would rather name this sev_es_after_set_cpuid() and call it directly from
> svm_vcpu_after_set_cpuid().  Or I suppose bounce through sev_after_set_cpuid(),
> but that seems gratuitous.

There is a sev_guest() check in svm_vcpu_after_set_cpuid(), so I can move 
that into sev_vcpu_after_set_cpuid() and keep the separate 
sev_es_vcpu_after_set_cpuid(). And it looks like you would prefer to not 
have "vcpu" in the function name? Might be better search-wise if vcpu 
remains part of the name?

> 
> AFAICT, there's no point in calling this from init_vmcb(); guest_cpuid_has() is
> guaranteed to be false when called during vCPU creation and so the intercept
> behavior will be correct, and even if SEV-ES called init_vmcb() from
> shutdown_interception(), which it doesn't, guest_cpuid_has() wouldn't change,
> i.e. the intercepts wouldn't need to be changed.

Ok, I thought that's how it worked, but wasn't 100% sure. I'll move it out 
of the init_vmcb() path.

> 
> init_vmcb_after_set_cpuid() is a special snowflake because it handles both SVM's
> true defaults *and* guest CPUID updates.
> 
>> +{
>> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>> +
>> +	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
>> +	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
>> +	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
>> +		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
> 
> This needs to toggled interception back on if RDTSCP and RDPID are hidden from
> the guest.  KVM's wonderful ABI doesn't disallow multiple calls to KVM_SET_CPUID2
> before KVM_RUN.

Do you want that as a separate patch with the first patch purely 
addressing the current issue? Or combine them?

> 
>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>> +			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> 
> Same thing here.

Will do.

Thanks,
Tom

> 
>> +	}
>> +}
