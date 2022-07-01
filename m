Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E370563C9B
	for <lists+kvm@lfdr.de>; Sat,  2 Jul 2022 00:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiGAWzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 18:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiGAWy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 18:54:59 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2094198D
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 15:54:58 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id w3-20020a4ab6c3000000b0041c1e737283so691245ooo.12
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 15:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bz5B0xsxU+73iD4WjJyZEms/7rCOpLm3Hnpz65WzTXY=;
        b=ATTARdUKy47egfufdbPyC4D2FJ1yXf4Z9lgFfNQ4uvQ1T8so6MofoXks0BBs5rKNGN
         m5W+k7TApJtPQXqpSD+a8ab8ki0bRZS8VuoY7l180mH4coRCcTYJtqM18ANqlvlo47UQ
         efTQYG0DmiOG8CZOE21WPNz/c59IYjBKiIAfmFX2WPCZgbyIUZQfOQJkQ9/tALy6sME+
         X+6je9912kHi2LM/W3lJFbjJ/5bzLKpBJFuANDGW2VUCEQXOGeJa7yo2T6jXOjBMAzfB
         lyNF/lmw+MTjdxDc5MLJ/ip5hZ8diBuEm4sGgqXb3CRmrCYX24cIqT/46M+1C390DFHs
         pW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bz5B0xsxU+73iD4WjJyZEms/7rCOpLm3Hnpz65WzTXY=;
        b=agOUPShrgiMNytd+WFwU0N3fUmyV6DRQcpeydVJL19SMu2HHwSo1YJ/dmqsWnsafXz
         W5qgFylwbqSQ9RRTnA/Vn3T+8zF1eRBzQXZP+0D2iwX5NUEiM1tpFoCpdL3e1TkNAOHu
         aS9mvE1idkek4eKf4kM0Dbt2Fz9X6Lx9VfOrYO8AQXAZnMJDF4t8uhdyeO2THXMDlR7O
         mdP+DAHO7y+tEPk8Mc3hHe/AXK68N2XPGCH2BWFAUGXTMmvtgWE9+PQRUNFRxkLgxsFB
         IaT6N0JQBdEcsutNR8vcPWW00g3qQ+NqP4gwUsOwYz852UbzuasQGbN//Mzc2+mS5Ixc
         1YlA==
X-Gm-Message-State: AJIora/Vj45Q8Az0XIGs15BxXsj9K/OiI4UyQMXCQyoJ+YOLQkpgIdi0
        ItmEKhHb/qeyAqWB0QK6oIOPnSxLD0NgQFpd1snurw==
X-Google-Smtp-Source: AGRyM1t97TXRZL1L53FBOD1m+b9p+02/pyHIOGmXh2mbVOLXrSqZj+YuNTtpRRr128jWY76KxHUZKe1ISpRVcO53nmU=
X-Received: by 2002:a4a:e82b:0:b0:330:cee9:4a8a with SMTP id
 d11-20020a4ae82b000000b00330cee94a8amr7127923ood.31.1656716097462; Fri, 01
 Jul 2022 15:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-25-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-25-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Jul 2022 15:54:46 -0700
Message-ID: <CALMp9eSMmeGu3yikQ+6vp2+TL6LmQLenqEjF7+AiH+fAZW6rfA@mail.gmail.com>
Subject: Re: [PATCH v2 24/28] KVM: nVMX: Use sanitized allowed-1 bits for VMX
 control MSRs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
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
>  arch/x86/kvm/vmx/nested.c | 34 ++++++++++++++++------------------
>  arch/x86/kvm/vmx/nested.h |  2 +-
>  arch/x86/kvm/vmx/vmx.c    |  5 ++---
>  3 files changed, 19 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 88625965f7b7..e5b19b5e6cab 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6565,8 +6565,13 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
>   * bit in the high half is on if the corresponding bit in the control field
>   * may be on. See also vmx_control_verify().
>   */
> -void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
> +void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>  {
> +       struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
> +
> +       /* Take the allowed-1 bits from KVM's sanitized VMCS configuration. */
> +       u32 ignore_high;
> +

Giving this object a name seems gauche.

>         /*
>          * Note that as a general rule, the high half of the MSRs (bits in
>          * the control fields which may be 1) should be initialized by the
> @@ -6583,11 +6588,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>          */
>
>         /* pin-based controls */
> -       rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
> -               msrs->pinbased_ctls_low,
> -               msrs->pinbased_ctls_high);
> +       rdmsr(MSR_IA32_VMX_PINBASED_CTLS, msrs->pinbased_ctls_low, ignore_high);

Perhaps "(u32){0}" rather than "ignore_high"?

>         msrs->pinbased_ctls_low |=
>                 PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;

NYC, but why is this one '|=', and the rest just '='? Does there exist
a CPU that requires more than PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR?

> +
> +       msrs->pinbased_ctls_high = vmcs_conf->pin_based_exec_ctrl;
>         msrs->pinbased_ctls_high &=
>                 PIN_BASED_EXT_INTR_MASK |
>                 PIN_BASED_NMI_EXITING |
> @@ -6598,12 +6603,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>                 PIN_BASED_VMX_PREEMPTION_TIMER;
>
>         /* exit controls */
> -       rdmsr(MSR_IA32_VMX_EXIT_CTLS,
> -               msrs->exit_ctls_low,
> -               msrs->exit_ctls_high);
>         msrs->exit_ctls_low =
>                 VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
>
> +       msrs->exit_ctls_high = vmcs_conf->vmexit_ctrl;
>         msrs->exit_ctls_high &=
>  #ifdef CONFIG_X86_64
>                 VM_EXIT_HOST_ADDR_SPACE_SIZE |
> @@ -6619,11 +6622,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>         msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
>
>         /* entry controls */
> -       rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
> -               msrs->entry_ctls_low,
> -               msrs->entry_ctls_high);
>         msrs->entry_ctls_low =
>                 VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
> +
> +       msrs->entry_ctls_high = vmcs_conf->vmentry_ctrl;
>         msrs->entry_ctls_high &=
>  #ifdef CONFIG_X86_64
>                 VM_ENTRY_IA32E_MODE |
> @@ -6637,11 +6639,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>         msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
>
>         /* cpu-based controls */
> -       rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
> -               msrs->procbased_ctls_low,
> -               msrs->procbased_ctls_high);
>         msrs->procbased_ctls_low =
>                 CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
> +
> +       msrs->procbased_ctls_high = vmcs_conf->cpu_based_exec_ctrl;
>         msrs->procbased_ctls_high &=
>                 CPU_BASED_INTR_WINDOW_EXITING |
>                 CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETTING |
> @@ -6675,12 +6676,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>          * depend on CPUID bits, they are added later by
>          * vmx_vcpu_after_set_cpuid.
>          */
> -       if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
> -               rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
> -                     msrs->secondary_ctls_low,
> -                     msrs->secondary_ctls_high);
> -
>         msrs->secondary_ctls_low = 0;
> +
> +       msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
>         msrs->secondary_ctls_high &=
>                 SECONDARY_EXEC_DESC |
>                 SECONDARY_EXEC_ENABLE_RDTSCP |
> diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> index c92cea0b8ccc..fae047c6204b 100644
> --- a/arch/x86/kvm/vmx/nested.h
> +++ b/arch/x86/kvm/vmx/nested.h
> @@ -17,7 +17,7 @@ enum nvmx_vmentry_status {
>  };
>
>  void vmx_leave_nested(struct kvm_vcpu *vcpu);
> -void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
> +void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps);
>  void nested_vmx_hardware_unsetup(void);
>  __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
>  void nested_vmx_set_vmcs_shadowing_bitmap(void);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5f7ef1f8d2c6..5d4158b7421c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7310,7 +7310,7 @@ static int __init vmx_check_processor_compat(void)
>         if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
>                 return -EIO;
>         if (nested)
> -               nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
> +               nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
>         if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
>                 printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
>                                 smp_processor_id());
> @@ -8285,8 +8285,7 @@ static __init int hardware_setup(void)
>         setup_default_sgx_lepubkeyhash();
>
>         if (nested) {
> -               nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
> -                                          vmx_capability.ept);
> +               nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
>
>                 r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
>                 if (r)
> --
> 2.35.3
>
