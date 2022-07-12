Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F0C571981
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiGLMLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiGLMLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:11:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82C4F599E5
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657627889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1d1EI4RPv3WfZytQuTN6gTWHuo0sJr7AFWE0PA+Qos=;
        b=H5CSMwHDPbKLaRHFszmEjycFCTbFGfSteWvR1/Asu0yigMQvs54+LSMATUW/eVIDBHx2H+
        jPA1FEbICDbwQB+Km8NAgFxhOVQGAGPbt8qNfjrqbwdH6UmUYem60KdtKIXd52rjWfr/JN
        UiBzc+TcXLez8RTf+BA7oYHY37HxUr4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-7ZbqxXERNca0nBXufmT69g-1; Tue, 12 Jul 2022 08:11:28 -0400
X-MC-Unique: 7ZbqxXERNca0nBXufmT69g-1
Received: by mail-qk1-f198.google.com with SMTP id az32-20020a05620a172000b006b58ce94435so4070682qkb.1
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=z1d1EI4RPv3WfZytQuTN6gTWHuo0sJr7AFWE0PA+Qos=;
        b=AQ2XkeKkBEatapTHdjsFQJb3wrl8uW/G/U+I7r7lCubAlZdkoDIWt/+LvkDgpSsle8
         jDREXJz42zVSLTGBQVcmtTrgLGLa+1b2ngmb7yKnnwU9o4mg2GZ7doJbduYGBwl8gcm/
         ZsGsPkvUp8MFDD6L7CW195/xU4UXJfI52w7O7wtWGp20h6HHJ1qMO+wLizjprAuSRzd6
         O6qY5XKFNRyGBqcaRkw4/qPdZRchvQ8vGjcZXmy0VTcXDmdttZaj0eoCG68IFL0CefC9
         LuT3Ty5AXvWdu4hM1G4HXjLPVl8pOs0FO61H4XC0tL0NZYPsU2wPfN8HjXfZoAYEYrQV
         9z0w==
X-Gm-Message-State: AJIora9hBD+m+I26HHi7Sx7nu+6DZDAgUCGwy+4RgxH4OadEUHu4fVBO
        664MC4OU4R5iaITe3Frpm8CwiMRz+oN7fLPtFrFzq+f+NdacwWDNg3aiVJ8Fm8H5Kk72neWzXlH
        3DweHoSo5RfaM
X-Received: by 2002:a05:620a:28cc:b0:6b2:1baa:4aa3 with SMTP id l12-20020a05620a28cc00b006b21baa4aa3mr14859718qkp.461.1657627887934;
        Tue, 12 Jul 2022 05:11:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v2dft7Ct2toOJxAojsYmuaA9UTV25aFGUAmHsh4bCGh1VhkUbMn//M3O/M8SYPO+NCgOsWgw==
X-Received: by 2002:a05:620a:28cc:b0:6b2:1baa:4aa3 with SMTP id l12-20020a05620a28cc00b006b21baa4aa3mr14859692qkp.461.1657627887606;
        Tue, 12 Jul 2022 05:11:27 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id k18-20020a05620a415200b006b5905999easm4647391qko.121.2022.07.12.05.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:11:27 -0700 (PDT)
Message-ID: <b9523b41105fb3405f770b428921bfc932ad6fef.camel@redhat.com>
Subject: Re: [PATCH v3 23/25] KVM: nVMX: Use sanitized allowed-1 bits for
 VMX control MSRs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 15:11:23 +0300
In-Reply-To: <20220708144223.610080-24-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-24-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> Using raw host MSR values for setting up nested VMX control MSRs is
> incorrect as some features need to disabled, e.g. when KVM runs as
> a nested hypervisor on Hyper-V and uses Enlightened VMCS or when a
> workaround for IA32_PERF_GLOBAL_CTRL is applied. For non-nested VMX, this
> is done in setup_vmcs_config() and the result is stored in vmcs_config.
> Use it for setting up allowed-1 bits in nested VMX MSRs too.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 30 ++++++++++++------------------
>  arch/x86/kvm/vmx/nested.h |  2 +-
>  arch/x86/kvm/vmx/vmx.c    |  5 ++---
>  3 files changed, 15 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 09654d5c2144..3d386c663fac 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6565,8 +6565,10 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
>   * bit in the high half is on if the corresponding bit in the control field
>   * may be on. See also vmx_control_verify().
>   */
> -void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> +void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>  {
> +       struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
> +
>         /*
>          * Note that as a general rule, the high half of the MSRs (bits in
>          * the control fields which may be 1) should be initialized by the
> @@ -6583,11 +6585,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>          */
>  
>         /* pin-based controls */
> -       rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
> -               msrs->pinbased_ctls_low,
> -               msrs->pinbased_ctls_high);
>         msrs->pinbased_ctls_low =
>                 PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
> +
> +       msrs->pinbased_ctls_high = vmcs_conf->pin_based_exec_ctrl;
>         msrs->pinbased_ctls_high &=
>                 PIN_BASED_EXT_INTR_MASK |
>                 PIN_BASED_NMI_EXITING |
> @@ -6598,12 +6599,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>                 PIN_BASED_VMX_PREEMPTION_TIMER;
>  
>         /* exit controls */
> -       rdmsr(MSR_IA32_VMX_EXIT_CTLS,
> -               msrs->exit_ctls_low,
> -               msrs->exit_ctls_high);
>         msrs->exit_ctls_low =
>                 VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
>  
> +       msrs->exit_ctls_high = vmcs_conf->vmexit_ctrl;
>         msrs->exit_ctls_high &=
>  #ifdef CONFIG_X86_64
>                 VM_EXIT_HOST_ADDR_SPACE_SIZE |
> @@ -6619,11 +6618,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>         msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
>  
>         /* entry controls */
> -       rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
> -               msrs->entry_ctls_low,
> -               msrs->entry_ctls_high);
>         msrs->entry_ctls_low =
>                 VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
> +
> +       msrs->entry_ctls_high = vmcs_conf->vmentry_ctrl;
>         msrs->entry_ctls_high &=
>  #ifdef CONFIG_X86_64
>                 VM_ENTRY_IA32E_MODE |
> @@ -6637,11 +6635,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>         msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
>  
>         /* cpu-based controls */
> -       rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
> -               msrs->procbased_ctls_low,
> -               msrs->procbased_ctls_high);
>         msrs->procbased_ctls_low =
>                 CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
> +
> +       msrs->procbased_ctls_high = vmcs_conf->cpu_based_exec_ctrl;
>         msrs->procbased_ctls_high &=
>                 CPU_BASED_INTR_WINDOW_EXITING |
>                 CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETTING |
> @@ -6675,12 +6672,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>          * depend on CPUID bits, they are added later by
>          * vmx_vcpu_after_set_cpuid.
>          */
> -       if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
> -               rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
> -                     msrs->secondary_ctls_low,
> -                     msrs->secondary_ctls_high);
> -
>         msrs->secondary_ctls_low = 0;
> +
> +       msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
>         msrs->secondary_ctls_high &=
>                 SECONDARY_EXEC_DESC |
>                 SECONDARY_EXEC_ENABLE_RDTSCP |
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index c92cea0b8ccc..fae047c6204b 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -17,7 +17,7 @@ enum nvmx_vmentry_status {
>  };
>  
>  void vmx_leave_nested(struct kvm_vcpu *vcpu);
> -void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
> +void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps);
>  void nested_vmx_hardware_unsetup(void);
>  __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
>  void nested_vmx_set_vmcs_shadowing_bitmap(void);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e462e5b9c0a1..35285109856f 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7306,7 +7306,7 @@ static int __init vmx_check_processor_compat(void)
>         if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
>                 return -EIO;
>         if (nested)
> -               nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
> +               nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
>         if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
>                 printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
>                                 smp_processor_id());
> @@ -8281,8 +8281,7 @@ static __init int hardware_setup(void)
>         setup_default_sgx_lepubkeyhash();
>  
>         if (nested) {
> -               nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
> -                                          vmx_capability.ept);
> +               nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
>  
>                 r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
>                 if (r)


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

