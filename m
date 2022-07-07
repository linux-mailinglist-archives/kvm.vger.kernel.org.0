Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D28A56A1F6
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 14:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiGGMad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 08:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiGGMab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 08:30:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4A3918B2C
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 05:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657197028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7taFVEbaeBa5qKeQW2zkf18xKccNfBkJ+gfCJ/fDRBM=;
        b=A5yTOdFUvyVHHnzpqwaNnYf+UkYWY1ETu59Fp0yRZjUInr9aV2btx08mRBVsLhBRuHveJ3
        ouaNv5Ag+0aQKMx+k1GTB0znf33H4NRFyUtGD8FqnmmbiWEfWH4MCi8jcP4ngOcGAp5bBQ
        n+r6fbD5YhW6m1ahxZp9dF0wtS6Ut0o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-TEjczYxxM4y6G2HDkcPUNQ-1; Thu, 07 Jul 2022 08:30:27 -0400
X-MC-Unique: TEjczYxxM4y6G2HDkcPUNQ-1
Received: by mail-wm1-f71.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so9526154wmj.0
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 05:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7taFVEbaeBa5qKeQW2zkf18xKccNfBkJ+gfCJ/fDRBM=;
        b=AEV3g2iuXrU4BeqbMYj4GL2BzUBHedD+IQusBARZ+id1NgRWlPimcYytpZFA0sAtd1
         okkbQyMYRvf7PToQ56/+NZTHn7TE30HQag4uFHV+atkRSg/mW3a8ZXi5RkMCd2i0QTqb
         /eyAZnQ+9UeMtUl+7xIMIhaMoxaD54wxYj+1X1bcOlYXVG7byPjYOWLy1PX3Vhlw49+k
         ev2W2rsJ0Hh6h5zk5TBouLBPF061/MBEJ2JV3TWgZ9g6e7AhABGfAZViOjcrCY2chT/U
         ++WGSda7rrmh/ttf6e5tWoFAKlx+HwAFCgO/e1z7sQn/edEvRE4vh1t8bea5QAkci2he
         fiVQ==
X-Gm-Message-State: AJIora8GyNRyC9tud1MQNhUAv90iyShQwO8dpvU8rwAON/upFhcyGzar
        s1/2pcauoT+KO8HRNfA+O89iAKociqbfACDs9v8aAxFN02GMLdArsfdQAYwQaHwIiro9GRyTBj0
        6ZZAF/gholLGq
X-Received: by 2002:a05:600c:3d10:b0:3a0:4956:9a84 with SMTP id bh16-20020a05600c3d1000b003a049569a84mr4247278wmb.133.1657197026599;
        Thu, 07 Jul 2022 05:30:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uiSck9WVUOW79a1dSEHk78gYfNc0MGtO45DsRvsDAaZk8to7uO7dAh1MpB0tqfwrORav/4Mw==
X-Received: by 2002:a05:600c:3d10:b0:3a0:4956:9a84 with SMTP id bh16-20020a05600c3d1000b003a049569a84mr4247233wmb.133.1657197026292;
        Thu, 07 Jul 2022 05:30:26 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m1-20020a056000008100b0021d7ff34df7sm3824536wrx.117.2022.07.07.05.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 05:30:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 24/28] KVM: nVMX: Use sanitized allowed-1 bits for
 VMX control MSRs
In-Reply-To: <CALMp9eSMmeGu3yikQ+6vp2+TL6LmQLenqEjF7+AiH+fAZW6rfA@mail.gmail.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-25-vkuznets@redhat.com>
 <CALMp9eSMmeGu3yikQ+6vp2+TL6LmQLenqEjF7+AiH+fAZW6rfA@mail.gmail.com>
Date:   Thu, 07 Jul 2022 14:30:24 +0200
Message-ID: <87zghlp0kf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Using raw host MSR values for setting up nested VMX control MSRs is
>> incorrect as some features need to disabled, e.g. when KVM runs as
>> a nested hypervisor on Hyper-V and uses Enlightened VMCS or when a
>> workaround for IA32_PERF_GLOBAL_CTRL is applied. For non-nested VMX, this
>> is done in setup_vmcs_config() and the result is stored in vmcs_config.
>> Use it for setting up allowed-1 bits in nested VMX MSRs too.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 34 ++++++++++++++++------------------
>>  arch/x86/kvm/vmx/nested.h |  2 +-
>>  arch/x86/kvm/vmx/vmx.c    |  5 ++---
>>  3 files changed, 19 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 88625965f7b7..e5b19b5e6cab 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6565,8 +6565,13 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
>>   * bit in the high half is on if the corresponding bit in the control field
>>   * may be on. See also vmx_control_verify().
>>   */
>> -void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>> +void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>>  {
>> +       struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
>> +
>> +       /* Take the allowed-1 bits from KVM's sanitized VMCS configuration. */
>> +       u32 ignore_high;
>> +
>
> Giving this object a name seems gauche.
>
>>         /*
>>          * Note that as a general rule, the high half of the MSRs (bits in
>>          * the control fields which may be 1) should be initialized by the
>> @@ -6583,11 +6588,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>          */
>>
>>         /* pin-based controls */
>> -       rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
>> -               msrs->pinbased_ctls_low,
>> -               msrs->pinbased_ctls_high);
>> +       rdmsr(MSR_IA32_VMX_PINBASED_CTLS, msrs->pinbased_ctls_low, ignore_high);
>
> Perhaps "(u32){0}" rather than "ignore_high"?
>

While this certainly looks like a cool trick (thanks!), both rdmsr() and
'ignore_high' are gone later in the series. I will, however, adopt the
change, even if just to show off)

>>         msrs->pinbased_ctls_low |=
>>                 PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
>
> NYC, but why is this one '|=', and the rest just '='? Does there exist
> a CPU that requires more than PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR?
>

Looking at the commit which introduced this,

commit eabeaaccfca0ed61b8e00a09b8cfa703c4f11b59
Author: Jan Kiszka <jan.kiszka@siemens.com>
Date:   Wed Mar 13 11:30:50 2013 +0100

    KVM: nVMX: Clean up and fix pin-based execution controls

I don't think '|=' is needed. It is, of course, possible that when KVM is
running nested, required-1 bits are mangled by the underlying hypervisor
but this is a) unlikely b) will only be observed by KVM's L1 (which
means we're talking about 3-level nesting here).

Let's be brave and 'fix' '|=' here.

>> +
>> +       msrs->pinbased_ctls_high = vmcs_conf->pin_based_exec_ctrl;
>>         msrs->pinbased_ctls_high &=
>>                 PIN_BASED_EXT_INTR_MASK |
>>                 PIN_BASED_NMI_EXITING |
>> @@ -6598,12 +6603,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>                 PIN_BASED_VMX_PREEMPTION_TIMER;
>>
>>         /* exit controls */
>> -       rdmsr(MSR_IA32_VMX_EXIT_CTLS,
>> -               msrs->exit_ctls_low,
>> -               msrs->exit_ctls_high);
>>         msrs->exit_ctls_low =
>>                 VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
>>
>> +       msrs->exit_ctls_high = vmcs_conf->vmexit_ctrl;
>>         msrs->exit_ctls_high &=
>>  #ifdef CONFIG_X86_64
>>                 VM_EXIT_HOST_ADDR_SPACE_SIZE |
>> @@ -6619,11 +6622,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>         msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
>>
>>         /* entry controls */
>> -       rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
>> -               msrs->entry_ctls_low,
>> -               msrs->entry_ctls_high);
>>         msrs->entry_ctls_low =
>>                 VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
>> +
>> +       msrs->entry_ctls_high = vmcs_conf->vmentry_ctrl;
>>         msrs->entry_ctls_high &=
>>  #ifdef CONFIG_X86_64
>>                 VM_ENTRY_IA32E_MODE |
>> @@ -6637,11 +6639,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>         msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
>>
>>         /* cpu-based controls */
>> -       rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
>> -               msrs->procbased_ctls_low,
>> -               msrs->procbased_ctls_high);
>>         msrs->procbased_ctls_low =
>>                 CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
>> +
>> +       msrs->procbased_ctls_high = vmcs_conf->cpu_based_exec_ctrl;
>>         msrs->procbased_ctls_high &=
>>                 CPU_BASED_INTR_WINDOW_EXITING |
>>                 CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETTING |
>> @@ -6675,12 +6676,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>>          * depend on CPUID bits, they are added later by
>>          * vmx_vcpu_after_set_cpuid.
>>          */
>> -       if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
>> -               rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
>> -                     msrs->secondary_ctls_low,
>> -                     msrs->secondary_ctls_high);
>> -
>>         msrs->secondary_ctls_low = 0;
>> +
>> +       msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
>>         msrs->secondary_ctls_high &=
>>                 SECONDARY_EXEC_DESC |
>>                 SECONDARY_EXEC_ENABLE_RDTSCP |
>> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
>> index c92cea0b8ccc..fae047c6204b 100644
>> --- a/arch/x86/kvm/vmx/nested.h
>> +++ b/arch/x86/kvm/vmx/nested.h
>> @@ -17,7 +17,7 @@ enum nvmx_vmentry_status {
>>  };
>>
>>  void vmx_leave_nested(struct kvm_vcpu *vcpu);
>> -void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
>> +void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps);
>>  void nested_vmx_hardware_unsetup(void);
>>  __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
>>  void nested_vmx_set_vmcs_shadowing_bitmap(void);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 5f7ef1f8d2c6..5d4158b7421c 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7310,7 +7310,7 @@ static int __init vmx_check_processor_compat(void)
>>         if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
>>                 return -EIO;
>>         if (nested)
>> -               nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
>> +               nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
>>         if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
>>                 printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
>>                                 smp_processor_id());
>> @@ -8285,8 +8285,7 @@ static __init int hardware_setup(void)
>>         setup_default_sgx_lepubkeyhash();
>>
>>         if (nested) {
>> -               nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
>> -                                          vmx_capability.ept);
>> +               nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
>>
>>                 r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
>>                 if (r)
>> --
>> 2.35.3
>>
>

-- 
Vitaly

