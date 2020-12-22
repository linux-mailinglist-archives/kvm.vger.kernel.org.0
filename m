Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72AB2E0D22
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 17:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgLVQPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 11:15:08 -0500
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:47919
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727080AbgLVQPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 11:15:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+NDlXvHthk8Y8KJzoBgs7xlJ6xpDu9c1n67dMLKyYcpT+j2TM3x6SaFw9fkD8TZ8PhnRw9+fgPdiXyMy8ICHs37siNmqOl6KzNSee2ePH1D+U7LY/mdXNRnPx+xKUSYmrTXANnuYlWZ7fNEVx0Ft1bA8kizcZdWmxVVLwFBTfaB6gWfZWSBTN56SVOi/IlfyO4CFTgFGLnlib9Hee/KGEow48kBdcThmF8zKMgkbZvuUAqqGnEzyeEdUWYru0r9iBBam1xzFa35J2ONC1e8YaEHOoPCEE9a+wfUF4UVk3CwQWDaGfSm1uMGNCzWZ5iI+3qebYKpejWsgt+7a+ngww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYQSff93bh+yp3YDYRPSfPgfkpPOpfnV/lZkV+4b1OM=;
 b=SHXsVXJ/yBbtBkM1KfycvsLWv3P9n6yzuoT2yJu9zotgGAr5flk1o2CZ8BkY1GJ8buJyyT5PcvO8LAKc7sYmGY1LCKAhVUDn6bjK9aQqT8lnF4TvhRvj5VYjQJj7ZC6/uQSvnJd1ngrgHxjiDXG23wEHa5h9nE9lociLTxWeMUwqhUt8VllusFDW134BiblGJEgHSviUH3DeSFop/X9ajUMMk0rQLiro7+OofcQc/XT5uYaBtv6Fs9zWQj6kqrKCGmJp7xXk3Zd8mMnKXIy7KISTiG0uUlWSwxJxa8mErcm4THUaMI/d6sYiWrghSy1B9bVEdPwZ7LZ/xU+JPHAN7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYQSff93bh+yp3YDYRPSfPgfkpPOpfnV/lZkV+4b1OM=;
 b=dfvRp33FT8CfK3XOb1YQBt78SGc6CHy//gkHdaHLFW32oUpDeInB7aUPS+Shjbl7G92ZA7LXtSJSq2XM8oOWd83lS9VYBwTtK6CU+7F7hvt1k5rIklX7Yiea5dxDb15jlb+FIRQK1AFQpFcy9TwTwnh9yYJq/CcjO5/17P05du8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2559.namprd12.prod.outlook.com (2603:10b6:802:29::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Tue, 22 Dec
 2020 16:14:15 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 16:14:15 +0000
From:   Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        kyung.min.park@intel.com, LKML <linux-kernel@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>, mgross@linux.intel.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kim.phillips@amd.com,
        wei.huang2@amd.com
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
 <160738067970.28590.1275116532320186155.stgit@bmoger-ubuntu>
 <CALMp9eRSvWemdiBygMJ18yP9T0UzL0nNbpD__bRis7M5LqOK+g@mail.gmail.com>
Message-ID: <491ec523-3076-aa51-c94d-a36ca08f42ca@amd.com>
Date:   Tue, 22 Dec 2020 10:14:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eRSvWemdiBygMJ18yP9T0UzL0nNbpD__bRis7M5LqOK+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0193.namprd13.prod.outlook.com
 (2603:10b6:806:26::18) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA9PR13CA0193.namprd13.prod.outlook.com (2603:10b6:806:26::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.22 via Frontend Transport; Tue, 22 Dec 2020 16:14:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c94fcd1-1fbd-49f9-4a63-08d8a694a0df
X-MS-TrafficTypeDiagnostic: SN1PR12MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2559AE792C7D20397A7C671A95DF0@SN1PR12MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WnVqeXrfOHEnziXzQCPj+Mg4ch9t7LZZ6sTGGUnjGWimwGtVJk0Zq7pjA3hLCs5pTdiM10GVtcWHkjnF7sXDZQ0u7eeYAWX5AjPuV2r1bNVYfuyLicSLpYk1/XB60/QapcJR98k7ljjg0/jv8dJNmNEUI6D72RlSXzZhwrjP/prr8xJ2ENEDlt1UQl3qcun0xLjO1Xi5WQUnT3Bkxwma5jyVeZ0Ah1Y5J0y/AOf2vw7nf7e54Fw7p52qdVqjeIgCY95ejg6IqA5QO9sZ0EnQFH2X4f3MVVIFXIK7OtHgCWi6vXcqsSQu2HtvEoPV/Musy0V7uAfQMG9g0vsn/S4mm3Lk5/gMHPy31+tzO9KNGUUMwKCFWtU8WzGBAaBFPuO4ZswkR619Nl+loCJrwZ+toOpgihuaQwOQ1B2Hw4MyK/ilyDxLGeO7AOnioRytDQiX/gIkaml3Ip6fY+yBJIQqerj3dL3U9fvZtyAKue7V7urX9LGm0X5PcisoP3PvDDeD3Z6RHPeFeKLXn3FBamMwxmgrdibdyeZXAI1XgvyNG9y7hsc0UOK7gN+v2n2X2xyE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(31696002)(2616005)(52116002)(31686004)(53546011)(54906003)(478600001)(66946007)(966005)(16576012)(86362001)(316002)(956004)(8936002)(4326008)(8676002)(66476007)(7416002)(6486002)(26005)(44832011)(5660300002)(2906002)(16526019)(6916009)(186003)(36756003)(66556008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?alpRMmowNXM4TlRwanpJbjJVMVFlc1dDdFVaR0o3NEdUWUd0dU5qb2ZVYzNL?=
 =?utf-8?B?VnN3OG9WL013UHphSkNBQXZOaEhwZVNzL3IzWGpzUUxFVWJPMzlDQ1c2ekxm?=
 =?utf-8?B?RTRFdnZuUWg3Z3BjQkM5cVlzZW5nenhsQ3RpZFh6Y1QrUWYydWliTW8xRkVu?=
 =?utf-8?B?K0tRQVBObWZuc1pqQlhySFRDVGRBYjg2R3JsYmErUllLTWhrUVpPYTVHN1B5?=
 =?utf-8?B?ZS9GUitnK1JmSVNnR3h1QTZvdVNPdTc2eDdFQWxKUEg2SnU3SFZWaGJkVkhM?=
 =?utf-8?B?R3cyTHQySllJZjJSVVVWcitJUWRsQ0pQMkZGVEd3N2JjcDNIRWZYOU1RbkFu?=
 =?utf-8?B?QWhGMjU4Z1Q5cHRlbnhyV0lpcDB3dUhrU3dVSXdrNW5zWDRXVGVVNWtBN2ky?=
 =?utf-8?B?bHhCbi80MDRyKzRXVFdCNVhCUWVUSnFyUmVnNXhzZ2VnRng0enlaSVUvNEwx?=
 =?utf-8?B?dTQrU3hhK3dkZWhiNEU2VHFKSmVBZ3c3NnFPdmw3dDA4RkJlUTR0NCtURDhv?=
 =?utf-8?B?Q092dmoxOVAvVFZmTGQ5UW5XVkpqR1FkS0N3Z3VYaE5vUTg4SjI3ellyWkp3?=
 =?utf-8?B?UmNQZjdZVDdTOTFYV2FqY1ZKSzdKbXhKMlBkWkNwNDZQOXNHSURWWjVRUU02?=
 =?utf-8?B?ZHMvMDZTbmVKcVZrd0E4bjFFNE11aEtyUVRNdG5ZRDM3czNRc21VYVVGeDBp?=
 =?utf-8?B?ODU1Zk5sNDRRTEY3OFJUbG9qOVNXazRaRVkyYlVTbDJxK1NMZHVON1QwK0sz?=
 =?utf-8?B?SzdzM3c2cSt3Q1BLcXM5OFAvcTBndFlpTWtFV2lXTDhkYkpwRi81a245QjVC?=
 =?utf-8?B?ZTNOZDRGQ0hnMkpTUGFtdmlaendNWVZ2eGhYUWErZWNtaVhHc2VHUFBaSFhB?=
 =?utf-8?B?ZjMwMm9ORk92eWE4S01lbi9CSEt5TzZkNitGZk5JWFozRm1wRzVyc2M4NTZO?=
 =?utf-8?B?Uy91UjVsU3dtV0RNRFo3VjZ2c0dpTkk4RXJYNjk5eUpOd25hNGtNZGpiRE5u?=
 =?utf-8?B?SEJPaWlPWEFXWXNMdjFETDVZVEZKTG5iOWNCQjJnTmd3d1pzcU9FdnFVZlkz?=
 =?utf-8?B?UFlEMUgvNnZ6a09FeUlnNHVSSGlzdkNLVU9sVjYwbURjQ1BhSWpnUGJEMG9T?=
 =?utf-8?B?L0RqWDlFSDhiNTFNYmZqSXpzaTV4Nk15Vmg0WTlENlRmVjhPendUbEEveDg3?=
 =?utf-8?B?a2cySGdkRHU5TGFpSzdNWHlMaitqT01LK1U2dUVDZVk3NXh2WkNzQkI1eWFQ?=
 =?utf-8?B?LzdVditPSkpZU0pnRDBKZFJlNGRNQ3N4MWM3TmdITTJNLzNmdFp0Z3FIK25W?=
 =?utf-8?Q?dvQUXk27vjOcBIDSrViGTBM88Xu7KYaKNn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 16:14:15.5005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c94fcd1-1fbd-49f9-4a63-08d8a694a0df
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n2FcFf9W/5+/4OXqLpB0CSYWyUPWYTb6FuN8jqFbK2UYmtReE/3Ge5IHiPd3IBs4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2559
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/20 5:06 PM, Jim Mattson wrote:
> On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>> Newer AMD processors have a feature to virtualize the use of the
>> SPEC_CTRL MSR. When supported, the SPEC_CTRL MSR is automatically
>> virtualized and no longer requires hypervisor intervention.
>>
>> This feature is detected via CPUID function 0x8000000A_EDX[20]:
>> GuestSpecCtrl.
>>
>> Hypervisors are not required to enable this feature since it is
>> automatically enabled on processors that support it.
>>
>> When this feature is enabled, the hypervisor no longer has to
>> intercept the usage of the SPEC_CTRL MSR and no longer is required to
>> save and restore the guest SPEC_CTRL setting when switching
>> hypervisor/guest modes.  The effective SPEC_CTRL setting is the guest
>> SPEC_CTRL setting or'ed with the hypervisor SPEC_CTRL setting. This
>> allows the hypervisor to ensure a minimum SPEC_CTRL if desired.
>>
>> This support also fixes an issue where a guest may sometimes see an
>> inconsistent value for the SPEC_CTRL MSR on processors that support
>> this feature. With the current SPEC_CTRL support, the first write to
>> SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
>> MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
>> will be 0x0, instead of the actual expected value. There isn’t a
>> security concern here, because the host SPEC_CTRL value is or’ed with
>> the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
>> KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
>> MSR just before the VMRUN, so it will always have the actual value
>> even though it doesn’t appear that way in the guest. The guest will
>> only see the proper value for the SPEC_CTRL register if the guest was
>> to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
>> support, the MSR interception of SPEC_CTRL is disabled during
>> vmcb_init, so this will no longer be an issue.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> Shouldn't there be some code to initialize a new "guest SPEC_CTRL"
> value in the VMCB, both at vCPU creation, and at virtual processor
> reset?
> 
>>  arch/x86/kvm/svm/svm.c |   17 ++++++++++++++---
>>  1 file changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 79b3a564f1c9..3d73ec0cdb87 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1230,6 +1230,14 @@ static void init_vmcb(struct vcpu_svm *svm)
>>
>>         svm_check_invpcid(svm);
>>
>> +       /*
>> +        * If the host supports V_SPEC_CTRL then disable the interception
>> +        * of MSR_IA32_SPEC_CTRL.
>> +        */
>> +       if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +               set_msr_interception(&svm->vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL,
>> +                                    1, 1);
>> +
>>         if (kvm_vcpu_apicv_active(&svm->vcpu))
>>                 avic_init_vmcb(svm);
>>
>> @@ -3590,7 +3598,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>          * is no need to worry about the conditional branch over the wrmsr
>>          * being speculatively taken.
>>          */
>> -       x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
>> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +               x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
> 
> Is this correct for the nested case? Presumably, there is now a "guest
> SPEC_CTRL" value somewhere in the VMCB. If L1 does not intercept this
> MSR, then we need to transfer the "guest SPEC_CTRL" value from the
> vmcb01 to the vmcb02, don't we?
> 
>>         svm_vcpu_enter_exit(vcpu, svm);
>>
>> @@ -3609,12 +3618,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>          * If the L02 MSR bitmap does not intercept the MSR, then we need to
>>          * save it.
>>          */
>> -       if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
>> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
>> +           unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
>>                 svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> 
> Is this correct for the nested case? If L1 does not intercept this
> MSR, then it might have changed while L2 is running. Presumably, the
> hardware has stored the new value somewhere in the vmcb02 at #VMEXIT,
> but now we need to move that value into the vmcb01, don't we?
> 
>>         reload_tss(vcpu);
>>
>> -       x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>> +       if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>> +               x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
>>
>>         vcpu->arch.cr2 = svm->vmcb->save.cr2;
>>         vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
>>
> 
> It would be great if you could add some tests to kvm-unit-tests.
> 

Posted the kvm unit tests. Let me know the feedback.
https://lore.kernel.org/kvm/160865324865.19910.5159218511905134908.stgit@bmoger-ubuntu/

Thanks
Babu
