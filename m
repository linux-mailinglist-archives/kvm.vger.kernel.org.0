Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1152D9FD3
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 20:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440683AbgLNTBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 14:01:37 -0500
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:56001
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2440664AbgLNTBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 14:01:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFC2QijOMnYTqDeW7cj0Nk90iIv91zpmt9PM5k9dFeb7cx+UzqEL3MWmZ+gqha2rXc3WVjId92dkAp79ZvXqFpeIC3nsE+8ENk6aG2wC5tYhLCOQ0j8eEpBfv7DypgAtvKiaWuaEvXvSCsGuObztWKMVIXAQDFL990t8OGYMFn3Jonmo7R1H6g2CyEs+gSqQepAJ2mD2q/0yzcSCKMGwDfiAx1mK8a5qawGY+KxXaJ8ak9yTpfVL21ggOab0CqkEfWvmDKTmGpRxu2yTgCdsDor8PPRhFfJEHaNUKMiPqfZPbdznP535/y04vA01UCta9tx1Ax7wDncatMSMHrcWlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vADiUBEFUi3esH7PMh0PWiI8vfCcNXDQL9/ymVJjpU4=;
 b=ny4qyWiss0zWo8c4xon6EeATilsSEiYK0kkAaMU945ZWv5p9ODrTS9dWJr6Ox0avxnezipbcKoIl1c/cms/UkGlPsKF/zExENHT10b77wDw0P6zENmdWReSwjZ+LgrSjbU9dYqknwkEgOWOlXepTZ/+cFg6giXAxe/PctHXipYnw/q9UcmLpKeegB+GqbrCBkGGTGh1Pe9OYAOubOlE9BbFXmE40YN42voH6XEteU1tVwhJ842XMOU2u35khbfvu14xkeBnrGELkaalioARZFvDlEKPplmgwnKCrkHgAY5/taOwtveiy31t2U+JksPgEaauqH8unilIM4hNB8gIknQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vADiUBEFUi3esH7PMh0PWiI8vfCcNXDQL9/ymVJjpU4=;
 b=h63sCoN3s4r+1XIqzb/T8jOWefkpOeK4iQL5H4udE+KfnbNYQ42UkUxQ7uDM/48fmF08VjzITj5moTSqPSm92RHu9YJPqI8aAh9YC9uR4yU7LakTk+iz5Upl+beSw165BZH0ya8SODaysAocrRVGPsConEEQkniPloSJ57k3T1g=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Mon, 14 Dec 2020 19:00:38 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:00:38 +0000
Subject: Re: [PATCH v5 07/34] KVM: SVM: Add required changes to support
 intercepts under SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <eb73a31713e8ddc324b61c4d4425f27cbf5eae50.1607620209.git.thomas.lendacky@amd.com>
 <68d996e8-8f08-559c-c626-53f1daaff187@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <eefcfba6-686a-535f-adb4-e4518d03b7e5@amd.com>
Date:   Mon, 14 Dec 2020 13:00:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <68d996e8-8f08-559c-c626-53f1daaff187@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:610:b3::10) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH0PR03CA0035.namprd03.prod.outlook.com (2603:10b6:610:b3::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.18 via Frontend Transport; Mon, 14 Dec 2020 19:00:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6d044ca-9e66-4a69-fbcd-08d8a0628b9c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4124271F2BFB9B27422416C6ECC70@DM6PR12MB4124.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubCg+CUwZsBttpkbEbdKWIZihMDytTpWAUCYHcYAHxNjV7W44E6XfvFzTlazSqyi6PYG/4M7Hg/5pkV6fCkT5gmEOCnuRX+GYfSKWSpMf4c7lYa5pfl7QGjsfEj99RnCy1Hg+iBXYNFNkaHN8IqmJpGNz4iCxyhY+aQV8RcpfVlju8Z+4MtdSQg1Z7I6pknWKgddbBQ4onqAEMZRg2fxwtr+yHlNs1QlldnnWWPilM5MvZBL9a2xpFf93hx83xzRUyIj1mBHNf3S4VYlhpMe7wYnzfKW3Wz5PQ4ThuYYGe6eb1789oW3Hn7d/riLxXO+iiHtD58JrtMB5YdThkutUDt86Jv7rLR0GU3zZjdNlkSCaaYnk8YwU9EhohGadKtmvNH/qLKcD4HYGWjYujCwt4XcyOiW5FvZetAenZeFtW8HotVKk3oCGlbkPEDsFKe+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(2616005)(31686004)(5660300002)(53546011)(16576012)(31696002)(26005)(66946007)(186003)(2906002)(4326008)(34490700003)(956004)(16526019)(36756003)(66556008)(6486002)(8936002)(83380400001)(86362001)(66476007)(508600001)(7416002)(8676002)(54906003)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?azBpeEJnODl0b21KRHcyd29kTmhnS2ZUY29ycFd2dHRzYm5NMEhiUUJlZmZU?=
 =?utf-8?B?OXlyZlRzeEEzekJ0UVN6V2gwS2k4ZkdpdFQ2TGJCWnJWNTFSVTEwU0VYUHpW?=
 =?utf-8?B?eitOcXNQUGQ3SUpiamNWVjB5V3VSTGFBMm1QZzNWYXRkc1ZSSnJSOVVaR1ND?=
 =?utf-8?B?WDNRcFhabkdNMml6STYwNmRiRnJnUlB2TEZ1bkpDRnQ0aEx4dHNlQnYzTFJu?=
 =?utf-8?B?bmV4YUZHc3VmRXFJYTJiUm11eWlrTFJhYnpJdVIvMGVRSURTMC9lMlBCT2Jk?=
 =?utf-8?B?UytlTHI4OXk2NVVINmdXbVBGZEhIaGZnM3hLZnJzRFNqUjkvNDhBNktVazVq?=
 =?utf-8?B?dkRGZVdJYlVTd21Ea1p1d1RSUUxqLzdtTzBLQzF4US9RVmVQZFZkMCtiaC9a?=
 =?utf-8?B?Qm9uV1YrYWNnWG9MQ0lES2g3ZGs4SVhpSnZITFVkaXNUOWdTMW9xZE9MZUdN?=
 =?utf-8?B?Slh2NTJkNGZUWWE1WlhOaTROUUY1bWtGU3JRVmZ4elFVVElaVTBZWTVuWEd4?=
 =?utf-8?B?bTRJYkZlc21mT3RvaEtBaWNUK29CSm53NkZ2R0JaTUMzTDdLeHJiUG4wVlZ6?=
 =?utf-8?B?Ny9LQk8yTHovRkFOTyt4SU1vMGNQWWNNMkNHd1N3bi9tWXQ5UE1yTGpnVTFG?=
 =?utf-8?B?aTZ4UjFyNktzMytYMnd5Z3VMRGhiZHdmODFMaXpYRDlDMGluSlVWa3lwYVVu?=
 =?utf-8?B?d2c3c2I0SW85SGNjWFJXcnFKRWdyQXNDZldVNU1seTZlVzhaMnVWdUkxc2pE?=
 =?utf-8?B?RGRpWmRBbjNtcGdjOFl0ZG84Ly80V3VxUTRkR09QRmRFOHRpZCtnTG94NzhK?=
 =?utf-8?B?ekxSNTdtYXZpTzg1dGhuUi92L1hZN0ZTK1Q0alpVUFVSS2QrQmxBMlJJSWE3?=
 =?utf-8?B?Tlk2Vkhqa09MNnBjTy9VNkJpODJWcDcyV2lxK0ZiSE11ZEpIWmZ2RHZFMWVm?=
 =?utf-8?B?YW5ZNDVaSVN5alpyLzhieGFqUHVGWUoyaUZBU3lKajQ2R0dDdm1PQjA1VWR5?=
 =?utf-8?B?V05sNTBnYko3QXdLazA3UmY3YTl0RnRTM3czaGFZT1pWWTRSTEszRGI3UnQ3?=
 =?utf-8?B?TmgzSGFaZlBybWlPSlZvY003MzZiN1Q2cWZmWnZialNUbjZmKy93YW8zVDFQ?=
 =?utf-8?B?OGx0ME5LTVNMclpPUmhuSlYxeXJ5NVNjaFMxRU5VWWVwbUx6TEpUTGdoUlky?=
 =?utf-8?B?OUNETkNsS3Fqc3lYM2JhclpUSkdvcVQyazhBK25IcW85cm5hRVQzNDZMSmtM?=
 =?utf-8?B?VjhFOGRmZ0tONUo5c2xSdjI2dy9YcHJVbHRsMXU0R3hTSE1HOStPRjQvSE1H?=
 =?utf-8?Q?m6h123mw9QUwjnk+9hYTo3kwjYMoq17S3Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 19:00:38.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d044ca-9e66-4a69-fbcd-08d8a0628b9c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jII1yYLUt8VlomgQdBa0KdU3TPJ3nyG+nOmYAlfZSPrX0CgIAmToL8//oR+2h7dO4n1yIfRYMjSHrarXJhQHZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 9:33 AM, Paolo Bonzini wrote:
> On 10/12/20 18:09, Tom Lendacky wrote:
>> @@ -2797,7 +2838,27 @@ static int svm_set_msr(struct kvm_vcpu *vcpu,
>> struct msr_data *msr)
>>     static int wrmsr_interception(struct vcpu_svm *svm)
>>   {
>> -    return kvm_emulate_wrmsr(&svm->vcpu);
>> +    u32 ecx;
>> +    u64 data;
>> +
>> +    if (!sev_es_guest(svm->vcpu.kvm))
>> +        return kvm_emulate_wrmsr(&svm->vcpu);
>> +
>> +    ecx = kvm_rcx_read(&svm->vcpu);
>> +    data = kvm_read_edx_eax(&svm->vcpu);
>> +    if (kvm_set_msr(&svm->vcpu, ecx, data)) {
>> +        trace_kvm_msr_write_ex(ecx, data);
>> +        ghcb_set_sw_exit_info_1(svm->ghcb, 1);
>> +        ghcb_set_sw_exit_info_2(svm->ghcb,
>> +                    X86_TRAP_GP |
>> +                    SVM_EVTINJ_TYPE_EXEPT |
>> +                    SVM_EVTINJ_VALID);
>> +        return 1;
>> +    }
>> +
>> +    trace_kvm_msr_write(ecx, data);
>> +
>> +    return kvm_skip_emulated_instruction(&svm->vcpu);
>>   }
>>     static int msr_interception(struct vcpu_svm *svm)
> 
> This code duplication is ugly, and does not work with userspace MSR
> filters too.

Agree and I missed that the userspace MSR support went in.

> 
> But we can instead trap the completion of the MSR read/write to use
> ghcb_set_sw_exit_info_1 instead of kvm_inject_gp, with a callback like
> 
> static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
> {
>         if (!sev_es_guest(svm->vcpu.kvm) || !err)
>                 return kvm_complete_insn_gp(&svm->vcpu, err);
> 
>         ghcb_set_sw_exit_info_1(svm->ghcb, 1);
>         ghcb_set_sw_exit_info_2(svm->ghcb,
>                                 X86_TRAP_GP |
>                                 SVM_EVTINJ_TYPE_EXEPT |
>                                 SVM_EVTINJ_VALID);
>         return 1;
> }

If we use the kvm_complete_insn_gp() we lose the tracing and it needs to
be able to deal with read completion setting the registers. It also needs
to deal with both kvm_emulate_rdmsr/wrmsr() when not bouncing to
userspace. Let me take a shot at covering all the cases and see what I can
come up with.

I noticed that the userspace completion path doesn't have tracing
invocations, trace_kvm_msr_read/write_ex() or trace_kvm_msr_read/write(),
is that by design?

> 
> 
> ...
>     .complete_emulated_msr = svm_complete_emulated_msr,
> 
>> @@ -2827,7 +2888,14 @@ static int interrupt_window_interception(struct
>> vcpu_svm *svm)
>>   static int pause_interception(struct vcpu_svm *svm)
>>   {
>>       struct kvm_vcpu *vcpu = &svm->vcpu;
>> -    bool in_kernel = (svm_get_cpl(vcpu) == 0);
>> +    bool in_kernel;
>> +
>> +    /*
>> +     * CPL is not made available for an SEV-ES guest, so just set
>> in_kernel
>> +     * to true.
>> +     */
>> +    in_kernel = (sev_es_guest(svm->vcpu.kvm)) ? true
>> +                          : (svm_get_cpl(vcpu) == 0);
>>         if (!kvm_pause_in_guest(vcpu->kvm))
>>           grow_ple_window(vcpu);
> 
> See below.
> 
>> @@ -3273,6 +3351,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>>       struct vcpu_svm *svm = to_svm(vcpu);
>>       struct vmcb *vmcb = svm->vmcb;
>>   +    /*
>> +     * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
>> +     * bit to determine the state of the IF flag.
>> +     */
>> +    if (sev_es_guest(svm->vcpu.kvm))
>> +        return !(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
> 
> This seems wrong, you have to take into account SVM_INTERRUPT_SHADOW_MASK
> as well.  Also, even though GIF is not really used by SEV-ES guests, I
> think it's nicer to put this check afterwards.
> 
> That is:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4372e45c8f06..2dd9c9698480 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3247,7 +3247,14 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>      if (!gif_set(svm))
>          return true;
> 
> -    if (is_guest_mode(vcpu)) {
> +    if (sev_es_guest(svm->vcpu.kvm)) {
> +        /*
> +         * SEV-ES guests to not expose RFLAGS. Use the VMCB interrupt mask
> +         * bit to determine the state of the IF flag.
> +         */
> +        if (!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK))
> +            return true;
> +    } else if (is_guest_mode(vcpu)) {
>          /* As long as interrupts are being delivered...  */
>          if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
>              ? !(svm->nested.hsave->save.rflags & X86_EFLAGS_IF)
> 
> 

Yup, I'll make that change.

> 
>>       if (!gif_set(svm))
>>           return true;
>>   @@ -3458,6 +3543,12 @@ static void svm_complete_interrupts(struct
>> vcpu_svm *svm)
>>           svm->vcpu.arch.nmi_injected = true;
>>           break;
>>       case SVM_EXITINTINFO_TYPE_EXEPT:
>> +        /*
>> +         * Never re-inject a #VC exception.
>> +         */
>> +        if (vector == X86_TRAP_VC)
>> +            break;
>> +
>>           /*
>>            * In case of software exceptions, do not reinject the vector,
>>            * but re-execute the instruction instead. Rewind RIP first
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index a3fdc16cfd6f..b6809a2851d2 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4018,7 +4018,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>>   {
>>       int idx;
>>   -    if (vcpu->preempted)
>> +    if (vcpu->preempted && !vcpu->arch.guest_state_protected)
>>           vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
> 
> This has to be true, otherwise no directed yield will be done at all:
> 
>     if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
>         !kvm_arch_vcpu_in_kernel(vcpu))
>         continue;
> 
> Or more easily, just use in_kernel == false in pause_interception, like
> 
> +    /*
> +     * CPL is not made available for an SEV-ES guest, therefore
> +     * vcpu->arch.preempted_in_kernel can never be true.  Just
> +     * set in_kernel to false as well.
> +     */
> +    in_kernel = !sev_es_guest(svm->vcpu.kvm) && svm_get_cpl(vcpu) == 0;

Sounds good, I'll make that change.

> 
>>         /*
>> @@ -8161,7 +8161,9 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
>>   {
>>       struct kvm_run *kvm_run = vcpu->run;
>>   -    kvm_run->if_flag = (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
>> +    kvm_run->if_flag = (vcpu->arch.guest_state_protected)
>> +        ? kvm_arch_interrupt_allowed(vcpu)
>> +        : (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
> 
> Here indeed you only want the interrupt allowed bit, not the interrupt
> window.  But we can just be bold and always set it to true.
> 
> - for userspace irqchip, kvm_run->ready_for_interrupt_injection is set
> just below and it will always be false if kvm_arch_interrupt_allowed is false
> 
> - for in-kernel APIC, if_flag is documented to be invalid (though it
> actually is valid).  For split irqchip, they can just use
> kvm_run->ready_for_interrupt_injection; for entirely in-kernel interrupt
> handling, userspace does not need if_flag at all.

Ok, I'll make that change.

Thanks,
Tom

> 
> Paolo
> 
>>       kvm_run->flags = is_smm(vcpu) ? KVM_RUN_X86_SMM : 0;
>>       kvm_run->cr8 = kvm_get_cr8(vcpu);
>>       kvm_run->apic_base = kvm_get_apic_base(vcpu);
>>
> 
> 
