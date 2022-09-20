Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33455BE0AF
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiITIsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiITIsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:48:20 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124D060504
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 01:48:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7zr9wMizo8Ec1zWpf/UOigoD1oGbLSVo9lWPHuELdf9Gpa9mbze+m42QJr7H8ETxY7nnj7lISjKljo4UR3EUltfP/fygiW5AYY5o+0Q8IbeqaHIvWVpqYkmRaTh2FrTd/MzESz9sL5djYQJhWzlUZAg9QE64SYFsA1i+mWE/A1rAL479M01dkqz96sZPsK4smnj4URckM/sx+Sa39X0gNZzJg9lbFMW72UVNHScdv39P+YH3wk9cyBhwTvIDhKZJEDLZKHC+8AfKzVtiFVqkqHl994kzmznlmzvPF3I47b1b57oT+kWuAcFH7WHVSt3E1SMPrGhNVnIj0bCbSRC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCU68CVb3WmAg6dHjMLr5PN0U6NpW6Kc9K41XqFiNFo=;
 b=A1/RhXjmCGDIyeZJ9Q9ChOdNDOw1ZfyF4sK/6tyS/6i6BjSTkO1gWIYfxH/AbXz1PVCPfu6xeB6SkoUYz+GveNZxgCQkPb2FJBIWtiHHqGi7WTrxRsWWxMlQECjMw2uw3EnnzGtC8YFHHEAs8MscE5z70XxWVESG/HLFe3Q8MLSVr8XQ03Ff2H2zYrb6W3jf48t+sKWE/BR7Lz7bfqcVEaOnqddg5F3eAh0GPzLnlb/k1KoE5RGa47/tSwdY5CGJ2Q8ubg6o3JLIeB/lLMIne31s/go5MmAArHPPdhwFReFlvylTRlUH2Y2gn1C6B7VLWvq/JnnYzoDW1czm/r+ujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCU68CVb3WmAg6dHjMLr5PN0U6NpW6Kc9K41XqFiNFo=;
 b=gMyi2wx8GWwt1McTvUpUpREUJAlBEEpbmqWYlTdNHyvBnvL/AAXvOTg+8ezkN94VdMEWGV3OPSDAcJW7F4CCBV6Zxk8ia/3OhpYAjDtDJaN2ttVJ62U7T3Ot5/JMIOWRZoY2t7AT7cuvX6hU5JsPtfxjZhD2y0HSCUF2ZB+W2gY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 BL1PR12MB5922.namprd12.prod.outlook.com (2603:10b6:208:399::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Tue, 20 Sep 2022 08:48:16 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::3406:3c9:8fac:5cfa]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::3406:3c9:8fac:5cfa%6]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 08:48:16 +0000
Message-ID: <1b766883-23a9-72e6-b7ee-f7473bf6b096@amd.com>
Date:   Tue, 20 Sep 2022 18:48:07 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH kernel] KVM: SVM: Fix function name in comment
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Nikunj A. Dadhania" <nikunj@amd.com>
References: <20220912075219.70379-1-aik@amd.com> <Yx79ugW49M3FT/Zp@google.com>
 <699404b6-dfa7-f286-8e66-6d9cadd10250@amd.com> <YyAlVrrSpqTxrRlM@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <YyAlVrrSpqTxrRlM@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY2PR01CA0039.ausprd01.prod.outlook.com
 (2603:10c6:1:15::27) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|BL1PR12MB5922:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b29652-afc9-4821-12f2-08da9ae4dbc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N60wUAi9n+GnWFQYzUk7Qc+p7AaUEGhUjOqxM9b3G9tFIfN0N38iKO9DRtmTJMc6NUoWHgFI7naqHKkX5HCnRsLlz8YVpq46iZhh/S2vVmhdDrLKgfHSofwvCLoNBDxB1iqqPCOuog8wQvxjUOVDAPDIyRYjhAR3hx0L2+7rMCzr9/qJX/kcWvW0m0UkTyYiPhGYJV9RIb+TRsbkf4Qq/NgFP2jZua0IkUinAa3GPa/bKUQ7uod0rnDLu3qAUvgHT+OqOVAi+D6BAK/gfbzdes0vhpKak9/2JZLiYsMRiW790b5h+OIkufZi2FcPiSPlMd5l7aDEBE0go8CGxxXXB+73fpS0uJft86gXxekum4ThLwAeju4ze/neH9C9SdG6nDJUrVhJZghl2/ndepbCrQDt01A1E/uoFP5mq7zFJfP8mtfKWAf2ylDsCU7yhUCYV40d2E0ewBcFpVcq1N0KnKyyhPzU+g4abJXq6XuCAeAvYNBkPnS8uMI/4qXkMjF5zZhSMyTcUUKv56M/LjSLm6u2C0uRbKdruGL6m8F6UxmX1f5NR9BSy77j6d210SOJVyVNMGKpQx7bJ9W1BswbkX0fK0MgQ0uyVbY0YnYF9sH51LGn/BreKafkDanbS6cmgGYOWTsa8WS34m2G0gDiaN3jeBz41xgkz/Zy37ouchecBnyvdsMMq/E/RRI/IfYcVPMxKOjVuAnu5oycsVSuipbhMmip3Xsrqjx3FBgAGulNsBS/gHh52RBhM5mRQYpLjbaQwhhN5JJ1lT8Gglup69ttAduarC1iSIvXrDH78b4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199015)(31686004)(5660300002)(6486002)(8936002)(478600001)(6666004)(2906002)(2616005)(41300700001)(4326008)(53546011)(8676002)(66476007)(66556008)(66946007)(83380400001)(6506007)(36756003)(26005)(6512007)(6916009)(31696002)(38100700002)(54906003)(186003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Skd6czlxcCs2UTZkRjVCV0M4UW04Y3pOMzlVcXBhWlVtVHNaT2ZaOFZxT3RR?=
 =?utf-8?B?dHRWWGJzTE9KdEN5UXpVWlFzZy9OcEs1UzFFMXRCbkQybGZvYW4zY3draVU4?=
 =?utf-8?B?T1hPU2FmZXJNRkhObFppSFN2NVl4bW4zZzBHR3hoVkhQVmt2VU9YM0M5Wkc0?=
 =?utf-8?B?V1grL2NkS0FDRTJvYVZXZTkwcEJRMHJnUENTc2dmcmFib3QralVTaEZOa2sv?=
 =?utf-8?B?cE9iRHlNTzVVcGFnTzVyWW5wVTVibVVVdUpqZmI5enBQTVhaNXI1dTBDb1Z5?=
 =?utf-8?B?d1VNNVl1ejFBdHlBOElmaW4ydDNPYS9hNVpCclpXd2xHSFZQVElORjFVUjZy?=
 =?utf-8?B?SVZUVTZoTk1ndm16dHd4VWRNSWIyY0J3bmxhanFDSlVDMjN3aDNRekkyN3h2?=
 =?utf-8?B?bC9oK0FaZWZoWDBYNmx2eXZXVnYzVHlQSUhYbUd5RlJySkJ1WGVlZDliQURB?=
 =?utf-8?B?N1JGc1BicFpjdUJJR3hmSm5JNktLNE1VQnZueGc3cWFxOUkyM0RQcW9mS1Vz?=
 =?utf-8?B?U2JRWGhlQ0NrNU5UK0MxQSt6Vm5RSjladzlmRm4zcjlhQThRWlY3bVN4K0ta?=
 =?utf-8?B?MHpZZFY4cmU5WVpmYnMyTUVPaG4yczJyWVdmc3cyYmE2TzVLR3E1dzlpbXA0?=
 =?utf-8?B?MURCckxDWkNWQnFJTjJtWWNkRzVwRDlHOXJTNTN2TXVpU084L0tlQkphRDV1?=
 =?utf-8?B?dHAxZUlXVmZTRFNmMmJLcEZBWW5saUY5QTlFVVhhM1FGYjhmZTVEa3g2eGxm?=
 =?utf-8?B?dHdocUpCL0szdDlrRFZ0OHdKTkZwSmFPWU1tQ2tLUGtiZWgwZ0RXRUVuZStZ?=
 =?utf-8?B?VkpiV1RnY0hWdEp2N0tPSEVpYmg3MXpFRit3dkNZanlWeTBqZ3JYL1A5T0Q0?=
 =?utf-8?B?V1YyUFlkQUVpV3dYcGZSR1ZVR2U5VFpJSGdmRmVIMVFvRHZzS0l0b1phZnFR?=
 =?utf-8?B?Nk5MVW5SMlpSREpVbFlneXFkL09XNldTTGJvUDFvYmVraEFXdmpNbTVwbFNV?=
 =?utf-8?B?eEZkT2hERlN3VlByVkUwRDFoV3gyQ2Z5QUdXWFplekt3b0RMY21PSE9JUys1?=
 =?utf-8?B?UHc5dFFhMmtFR3lnN2N3VFpGTDJsYVE4NXZkZDFReWpucXNZbkJSdGEzcFVz?=
 =?utf-8?B?R3dtN2Jqb3JzMTB1aGJHNkNXQTVwb2xucUxlUUltaGJRUXRaU1RIVDhjdE1t?=
 =?utf-8?B?bUJlMkZnNTVXTkNHZjZvTlNUeCtiNW83RHhDMXZRU3lzSE8zbHlDTG9xbHVZ?=
 =?utf-8?B?ZWtYSzg4b2tnQjFMMzJSS3NDZGZLWjIzdDRUbEQwTHFsZ3h1RitkUzAvdm5Y?=
 =?utf-8?B?amdPbzFUWVZWdjBVTmF0WmIyYkJOUkF3d3hnQXpLblc1b1NOd2ttMlNCaUFE?=
 =?utf-8?B?Z3ZVYVJmRkNvMFZRZDZhRVI3NEV0TS9TMlpDS3JWQzBhVDN0NFBFdTZ1U01U?=
 =?utf-8?B?NUJybTVuUWx6OEF5Q2FmTUF2NjcvTXV2bHMzQy9rTXA3S2RieGR5SU9mT25I?=
 =?utf-8?B?anFVejJvQVhDUXM4cEhPVUZMbHpxUE5KZmRXZC96NHlSakZ4UWJGYm1KNE5E?=
 =?utf-8?B?TzFJQ1NXVjA2L2NPZitXcGdoNUZHS1VJU2hlNkw1QXZjWjVwdVdQbERsVGlB?=
 =?utf-8?B?S2VQRExpbXVYQXZWMmxoaDRvTUxocGtLL1pIZXpQQ08wUFRSVU4vemY4Si9o?=
 =?utf-8?B?QjdLS1hORHpQNkNPN1ByNmZaR1B4ZVJmVU5yR2dKWmE0UWhGSFdqTFRkc1ZO?=
 =?utf-8?B?V2FCT05lUndoQzNxMUp0c09FOUxVSUN6U2lYMWJtN3hrTk16cVI2Tmw0bEtx?=
 =?utf-8?B?TVhKaFRKZ3JGa0Z5Q2xqeWVPbFppalpIaWNHRkxhdVM0aG1VSUFGOEhsN0V5?=
 =?utf-8?B?QjNTemJzR0EyaURPNXVMWUJtell6OTZUNWFFNFNXb1ZSUnZWaVgxaVY2ZUpu?=
 =?utf-8?B?R2N4dk8waDc3YUwzUC9acldvN1RiRGVkMk40WkptUVptRXlEMHE0MXE1YXdv?=
 =?utf-8?B?RVFBQVJ0NklaTjdkcGdISWJwcWQ5eXhVd0NERlpSbWFvR2dxcG5JWkVRSTBm?=
 =?utf-8?B?dzhSQkRjd05WaTFyNnZWdWw1Um5JZFRkTUJiN1BGVlNYUHQzdko2KzdlbCtO?=
 =?utf-8?Q?xttnSimiJvGLGGUq4K0RIizGj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b29652-afc9-4821-12f2-08da9ae4dbc4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 08:48:15.9752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxrVNRPI4NTHysJflkGqqEohQmcSvaMJKSHGqFza8B+VHilw9ejqvTUh1xPhcujyzX5dmMvrs4PO2l5fM0yp4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5922
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding Nikunj for his opinion on the reworking (at the very bottom of 
this mail).


On 13/9/22 16:38, Sean Christopherson wrote:
> On Tue, Sep 13, 2022, Alexey Kardashevskiy wrote:
>> On 12/9/22 19:36, Sean Christopherson wrote:
>>> On Mon, Sep 12, 2022, Alexey Kardashevskiy wrote:
>>>> A recent renaming patch missed 1 spot, fix it.
>>>>
>>>> This should cause no behavioural change.
>>>>
>>>> Fixes: 23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
>>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>>> ---
>>>>    arch/x86/kvm/svm/sev.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 28064060413a..3b99a690b60d 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -3015,7 +3015,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>>>    	/*
>>>>    	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
>>>>    	 * of which one step is to perform a VMLOAD.  KVM performs the
>>>> -	 * corresponding VMSAVE in svm_prepare_guest_switch for both
>>>> +	 * corresponding VMSAVE in svm_prepare_switch_to_guest for both
>>>>    	 * traditional and SEV-ES guests.
>>>>    	 */
>>>
>>> Rather than match the rename, what about tweaking the wording to not tie the comment
>>> to the function name, e.g. "VMSAVE in common SVM code".
>>
>> Although I kinda like the pointer to the caller, it is not that useful with
>> a single caller and working cscope :)
> 
> Yeah, having exact function names is nice, but we always seem to end up with goofs
> like this where a comment gets left behind and then they become stale and confusing.
> 
>>> Even better, This would be a good opportunity to reword this comment to make it more
>>> clear why SEV-ES needs a hook, and to absorb the somewhat useless comments below.
>>>
>>> Would something like this be accurate?  Please modify and/or add details as necessary.
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 3b99a690b60d..c50c6851aedb 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -3013,19 +3013,14 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>>>    void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>>    {
>>>           /*
>>> -        * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
>>> -        * of which one step is to perform a VMLOAD.  KVM performs the
>>> -        * corresponding VMSAVE in svm_prepare_switch_to_guest for both
>>> -        * traditional and SEV-ES guests.
>>> +        * Manually save host state that is automatically loaded by hardware on
>>> +        * VM-Exit from SEV-ES guests, but that is not saved by VMSAVE (which is
>>> +        * performed by common SVM code).  Hardware unconditionally restores
>>> +        * host state, and so KVM skips manually restoring this state in common
>>> +        * code.
>>
>> I am new to this arch so not sure :) The AMD spec calls these three "Type B
>> swaps" from the VMSA's "Table B-3. Swap Types" so may be just say:
>>
>> ===
>> These are Type B swaps which are not saved by VMSAVE (performed by common
>> SVM code) but restored by VMEXIT unconditionally.
> 
> Weird consistency nit: KVM refers to VM-Exit as an event and not a thing/action,
> whereas the APM tends to refer to VMEXIT as a thing, thus the "on VM-Exit" stylization
> versus "by VMEXIT".  Similarly, when talking about the broader event of entering
> the guest, KVM uses "VM-Enter".
> 
> VMRUN and VMSAVE on the other hand are instructions and so are "things" in KVM's world.
> 
> Using the VM-Enter/VM-Exit terminology consistently throughout KVM x86 makes it easy
> to talk about KVM x86 behavior that is common to both SVM and VMX without getting
> tripped up on naming differences between the two.  So even though it's a little odd
> odd when looking only at SVM code, using "on VM-Exit" instead of "by VMEXIT" is
> preferred.
> 
>> ===
> 
> I want to avoid relying on the APM's arbitrary "Type B" classification.  Having to
> dig up and look at a manual to understand something that's conceptually quite simple
> is frustrating.  Providing references to "Type B" and the table in the changelog is
> definitely welcome, e.g. so that someone who wants more details/background can easily
> find that info via  via git blame.  But for a comment, providing all the information
> in the comment itself is usually preferable.
> 
> How about this?
> 
>    Save state that is loaded unconditionally by hardware on VM-Exit for SEV-ES
>    guests, but is not saved via VMRUN or VMSAVE (performed by common SVM code).

-- 
Alexey
