Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D692ED3C0
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 16:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbhAGPsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 10:48:50 -0500
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:43585
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728165AbhAGPsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 10:48:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWQbGBwzk/vCLFmd3PcxBvjZmefqukXya5Nh50MfXC5uQVL/90HCgx762zC8bWdTBWePoebkm51eQZjwA7qyb529DDgDD/bcua7vLsiVyzD4xozW2SYJjmY4wJ/HLaJQiKcl4yqMUYPf2sCswqPDSY//6XL4I1fIo6k37wqS5ahABcW7Cmrfd/SNpuvS4WzEu0DtJ3eaBNIM9Tx65F0iJGoBUb+zwSID/VOmb8q7rL2NvUohbP7yBHBDhFvDO5pHxA11NtGs8R1IpqShQJ9YNb4fC3W0yWPvQ8X2SYHMgpubdPVSlk0fDlKkSC5eVLu++oOElG1LMacDvGryWU5M8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRB7p0brH27KUWp+ZVkg32C/7XgbAyYRyQ72r9acgSE=;
 b=Wmve/ukCCbQYXrFY8Pf6xUAVYVMmKFHNFdiZ/gUjpLi0l6Y2SrxWTyzurBJTNkk438nYFlFdxuKda2c84VDx1zoX4zSHWCeqJYnJA63jRrOGQIftx36WWBtXwIKhFwEYQSR+qOmIwQQt2DJNO+lTdtzXBg00pXMT0Y40BZzCCxKleG516Jvx0XupDBnYUw+R+eGeJ5ogoUDmsujZhEzGdVaz1vqZAPl9knyfnI0OPBLVZTnz50djLXe8ssCJhDmxUvW+hQ38Uo1/9EfT3Cru69FvxnG+0urkm8jgk+f9l87/hXqFRBUG+pRvqNHtjpYLNcocddfZsWrJza4CMds26A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRB7p0brH27KUWp+ZVkg32C/7XgbAyYRyQ72r9acgSE=;
 b=3dbc8VruOeZzvoI7md7l34ov+0kSTRXQg/yEnmy2RuY3bM1nk1b8IUbP2EdnIRAn/sJlzHk8EtEx7PZRXLQyYfrlbMFXZybVqGj68ygLAyk8Sen+0kIgkUZSpOPyv0xnDeZ79PsHKVJ3kqVHCRSQqnNqOvc1+C53JuJ8FPPIkaE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3721.20; Thu, 7 Jan 2021 15:47:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 15:47:55 +0000
Subject: Re: [PATCH v3 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210105143749.557054-1-michael.roth@amd.com>
 <20210105143749.557054-2-michael.roth@amd.com> <X/Sfw15OWarseivB@google.com>
 <b04bf56d-c6ef-3636-020f-ce107cffbe59@amd.com>
Message-ID: <1e5284fd-c426-649a-becb-dcff3e2afe57@amd.com>
Date:   Thu, 7 Jan 2021 09:47:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b04bf56d-c6ef-3636-020f-ce107cffbe59@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:806:21::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0030.namprd13.prod.outlook.com (2603:10b6:806:21::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2 via Frontend Transport; Thu, 7 Jan 2021 15:47:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c1d181b-ab8e-49a3-42df-08d8b32399a3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4153CD15B676B8F7F6339B43ECAF0@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adihWRnxLq60oUbtyHtcN4htFgAWGK6Fhq0q1jxIqGeMl4B1y0O1g0JrVD0FVl7Nx7hAzUJYZ6t14mdTvq7PUtnOBGl9j+KBKTjd5ER/1gnD2Egqa4md92ITASWN+5eZVNRfNYpwDmae54tHIseoFIbpPrZEMAbm6lwS7WtckHyWOgJyHwIMKbmm6qbXawFbWO3qb9RakPhrFPMdJtTV7Rl0iTJ+o4P66VPKuRGuHfA/mknvIuZONCMNW8glT5mRQvYv30BRisbJR5vHhOmIBybEevFzA7MD+J6Ieq15lOFDSTpPx0dmkZ/ejr4Ssx/AYtn1VwkflEHhTFU+soilQFJX8ybKADiKDCXTWzAvbvSN1yfkZbi2n/o4LCh5nVGDPAMX7OIWALheZ6HyQbIBW6pMGdQTGeUuOXF2A5CHxWguGsX+LJSNsNij/pn3FOYCprjFQNC6oHGDcEdS8OCfo3sMneKRHXgE2g80C5IdcKYQsm4cRWQbywOvqi5DaxsayeAB1lkUiXTNRrRNRxlh3gpNuoZDKZqYkxWQ1ULYqKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(186003)(26005)(45080400002)(31696002)(16526019)(8936002)(7416002)(478600001)(86362001)(66946007)(66476007)(52116002)(66556008)(6506007)(8676002)(956004)(2616005)(316002)(54906003)(53546011)(110136005)(2906002)(6636002)(5660300002)(36756003)(966005)(6486002)(83380400001)(6512007)(4326008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVNMRGZnR243Mmd1bjdTUzNVN1g5MC9JRjJ5Nlc5bTJaSlU3elFLQ00wUkJj?=
 =?utf-8?B?bGp0eDErVjFCdHhYa3Ywbk5kSkRDZmFNUmhnUWQzbnBENVJYSFFZR0dFd1BM?=
 =?utf-8?B?QzhjZlNzV2ttRlp2L0dEeXdHMlFSYkVxTURORnRJTjF3U0NjSHdha3lqOUhL?=
 =?utf-8?B?NHlnU1k0eVJyT0c2NnM2SVJLR3VkcDFZVGdQekpDV3AvdCtZMmJJamRUdi9T?=
 =?utf-8?B?eksveWdVSGphT2FxWDVCa0JOcWcvUmU0ZEFGTVRTZkYvK1hLMWkvUkRGUTBw?=
 =?utf-8?B?dWNsdVpoNXRTdHE2N0pKSmEzYm1KY2NpVzJneXM3cmxCWXZsUFpVQjFGYUk2?=
 =?utf-8?B?VDRTc0MwbjkxNjhIRkhiZy9vdm0xS3R3WTFwaWF6dm9MSFJoenI2b1VkN2ly?=
 =?utf-8?B?UDdoMFhRVlNod1dUbTM5cjNaajJGVnNrbVhITFd1WG51VFdCcWJlSU5hYUxQ?=
 =?utf-8?B?NG13S2x6d3FRUFl6VCs1SStBcitQbnV5aWJCcUFIQ3lFSmNUYTFMSnVEcUN3?=
 =?utf-8?B?YkNkQlVoYkNSRW5oRGd1aHpUS3lWRi9kUWJUcTFIazgxWVFyZlJTaVNTMFNG?=
 =?utf-8?B?L1J2Q0VWZC9NQ2JEWEVZcHcxc0RCL09QOUhpT095MExFS1pFS1V2anh6eGlo?=
 =?utf-8?B?UGdNN1lpVTBlUVdrYmxmNitma0VrUFZCUTZTeTIvK2NMKzh3aTlFaXVnVy9Y?=
 =?utf-8?B?NVcySnYzSTErVFVycE8rcmIxVmROTDA0emdRM1FoQ2NKeDBnY214UURFUGlG?=
 =?utf-8?B?VzQrR2ordHk1Ym4zSC81dkRNcEhsQ2pPbnRYaHl2TTMvMmRuT0hVZTJ5Nk84?=
 =?utf-8?B?L2pTUW9NWHZHeXVCK29ycHFpYnVkZ2lsa29UTlp6NDdib1lGb0hYNUprb000?=
 =?utf-8?B?bHJKSTd3MDlMa04xYjNpRUpWZlZTcnBzbU1hNGhJd3NTTjFORmh0MWYrbm1X?=
 =?utf-8?B?RjBtVjBpZnI0cXpoWUp0MzNhVWdEK0N4UzltVEhTY0lwTVhYalVzVW1Uc3px?=
 =?utf-8?B?TEphMm5SRjRrK1FYTjg5c1VMU2VDVStncjhjMDJqV2xBakRrM1l0bkZTa0xt?=
 =?utf-8?B?ZVBNMUliSDhLb0lOcjdIZmsydnZCTzltRFgraWYvZHBVRjIxSkpJQ24vVmlC?=
 =?utf-8?B?UEQyZHFlNCtwN2dyWGY3OS9UUjVHM054TzYrM25DcWcxTUhzQ1FLUHIyWkVC?=
 =?utf-8?B?Y1BHU29ucEs0TFhTVFBxcmdTbjhrcVBQK0QwMXRGSXRXZGVGMHZQYVdTSUpV?=
 =?utf-8?B?ZTdIdG1GOVR3cUluQ2VVMXNldUhQUDdNMjZUOWxjVTVHb3grN1NlS054Y2pL?=
 =?utf-8?Q?r5iSBLHHTEoWVZlhm+sD9FVGEZLtcfQXNk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2021 15:47:55.4106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1d181b-ab8e-49a3-42df-08d8b32399a3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrfVNvlENO8fJXvQ5UahK6GI5E6ByVPiEZJRwdpavc+FmZSHmyRq71+4ozVteZ5OqPbyJrDFc96gEZDfo67UYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/7/21 9:32 AM, Tom Lendacky wrote:
> On 1/5/21 11:20 AM, Sean Christopherson wrote:
>> On Tue, Jan 05, 2021, Michael Roth wrote:
>>> @@ -3703,16 +3688,9 @@ static noinstr void svm_vcpu_enter_exit(struct 
>>> kvm_vcpu *vcpu,
>>>       if (sev_es_guest(svm->vcpu.kvm)) {
>>>           __svm_sev_es_vcpu_run(svm->vmcb_pa);
>>>       } else {
>>> -        __svm_vcpu_run(svm->vmcb_pa, (unsigned long 
>>> *)&svm->vcpu.arch.regs);
>>> -
>>> -#ifdef CONFIG_X86_64
>>> -        native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
>>> -#else
>>> -        loadsegment(fs, svm->host.fs);
>>> -#ifndef CONFIG_X86_32_LAZY_GS
>>> -        loadsegment(gs, svm->host.gs);
>>> -#endif
>>> -#endif
>>> +        __svm_vcpu_run(svm->vmcb_pa, (unsigned long 
>>> *)&svm->vcpu.arch.regs,
>>> +                   page_to_phys(per_cpu(svm_data,
>>> +                            vcpu->cpu)->save_area));
>>
>> Does this need to use __sme_page_pa()?
> 
> Yes, it should now. The SEV-ES support added the SME encryption bit to the 
> MSR_VM_HSAVE_PA MSR, so we need to be consistent in how the data is read 
> and written.

Oh, and also in svm_vcpu_load().

Thanks,
Tom

>  > Thanks,
> Tom
> 
>>
>>>       }
>>>       /*
>>
>> ...
>>
>>> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
>>> index 6feb8c08f45a..89f4e8e7bf0e 100644
>>> --- a/arch/x86/kvm/svm/vmenter.S
>>> +++ b/arch/x86/kvm/svm/vmenter.S
>>> @@ -33,6 +33,7 @@
>>>    * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
>>>    * @vmcb_pa:    unsigned long
>>>    * @regs:    unsigned long * (to guest registers)
>>> + * @hostsa_pa:    unsigned long
>>>    */
>>>   SYM_FUNC_START(__svm_vcpu_run)
>>>       push %_ASM_BP
>>> @@ -47,6 +48,9 @@ SYM_FUNC_START(__svm_vcpu_run)
>>>   #endif
>>>       push %_ASM_BX
>>> +    /* Save @hostsa_pa */
>>> +    push %_ASM_ARG3
>>> +
>>>       /* Save @regs. */
>>>       push %_ASM_ARG2
>>> @@ -154,6 +158,12 @@ SYM_FUNC_START(__svm_vcpu_run)
>>>       xor %r15d, %r15d
>>>   #endif
>>> +    /* "POP" @hostsa_pa to RAX. */
>>> +    pop %_ASM_AX
>>> +
>>> +    /* Restore host user state and FS/GS base */
>>> +    vmload %_ASM_AX
>>
>> This VMLOAD needs the "handle fault on reboot" goo.  Seeing the code, I 
>> think
>> I'd prefer to handle this in C code, especially if Paolo takes the 
>> svm_ops.h
>> patch[*].  Actually, I think with that patch it'd make sense to move the
>> existing VMSAVE+VMLOAD for the guest into svm.c, too.  And completely 
>> unrelated,
>> the fault handling in svm/vmenter.S can be cleaned up a smidge to 
>> eliminate the
>> JMPs.
>>
>> Paolo, what do you think about me folding these patches into my series 
>> to do the
>> above cleanups?  And maybe sending a pull request for the end result?  
>> (I'd also
>> like to add on a patch to use the user return MSR mechanism for 
>> MSR_TSC_AUX).
>>
>> [*] 
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20201231002702.2223707-8-seanjc%40google.com&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7Ca130e2c4b40442b8532108d8b321a57b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637456304409010405%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=6vWmBbFFP0aOaZr31I7WDhpmzL4A%2FY%2BuzvvZrmDHpWI%3D&amp;reserved=0 
>>
>>
>>> +
>>>       pop %_ASM_BX
>>>   #ifdef CONFIG_X86_64
>>> -- 
>>> 2.25.1
>>>
