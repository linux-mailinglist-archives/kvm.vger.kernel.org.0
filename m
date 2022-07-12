Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3E3571983
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiGLMLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiGLMLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:11:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9252DA43A1
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657627903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KxkRNjVAjatwXPv+UIMylyk02a+HHkIvk4qnPTELJFI=;
        b=BoUvMo8GPFVIN+FpdRD4+in8r8L73NvfT0lAB4DgykOE0yoQj7r69cqiglF6LHG1vlyx5a
        eKrIwjJWEoGXI904Mwue8A1RdiwcoyMM1NdoSmHHlPB3ZH/4P4A30btFyvT6ryrVUVVJM7
        +RTM6eCY6mvbQ1wzmLknTMuFnfaUsWc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-Z4r_qsKgPum3TrznW43gug-1; Tue, 12 Jul 2022 08:11:42 -0400
X-MC-Unique: Z4r_qsKgPum3TrznW43gug-1
Received: by mail-qv1-f71.google.com with SMTP id q16-20020a0ce210000000b00472f361d6b1so1706799qvl.21
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KxkRNjVAjatwXPv+UIMylyk02a+HHkIvk4qnPTELJFI=;
        b=Pxw0uvlQElQPdNRC/W2AImE1tRjZT3q9ZBmEc0LAZdDoLSweYI6Qp+pOTP9bsIp8eg
         fjDMcP0TuFaGlQrRdaavinhqGAe84MKdEGanbt2sQpsHETzrhT3CSE4O1QMNZgeN7wNm
         +aEkm9zQI26d8X+8RRMfsuxXn/fIg7d8HEah+uTyZzoDm5CTgr8NzpjLJDlNqyNPkAWl
         kbTPoEJpR8AMd023Pu9pXdwfdiuIdge4/XpbYej1hMC/PI7T/mj/RLVDstrMRKpwOn13
         paWg+Y0lbrDij48bsqYgF2B8muvpJGHUTTqJrYrLkZVuw1Qrh/7NzYPVlQJhmFa28hHJ
         z1ZQ==
X-Gm-Message-State: AJIora8d8OJy9bhd7n9GbrFPXQR2glugKcRHY+5ZQzdcF4Ue6GMD8N48
        o8Y0NelUBTWeCQM005IdHxRCDAZPpEcPAmF0U6byAiVCHYN9XBGOue1Qgib/8hCKgWhTXj9Nt4d
        CIh/5yXqIf2/x
X-Received: by 2002:a05:620a:24c1:b0:6b5:a89b:3e51 with SMTP id m1-20020a05620a24c100b006b5a89b3e51mr942925qkn.695.1657627902144;
        Tue, 12 Jul 2022 05:11:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sI414FR0ZXnlhTZw7HGaKjRFwJqCGk7LAC7/+TdDjAnsZUCV8o6C/C8Ymekecd8iWpggE/Vw==
X-Received: by 2002:a05:620a:24c1:b0:6b5:a89b:3e51 with SMTP id m1-20020a05620a24c100b006b5a89b3e51mr942904qkn.695.1657627901920;
        Tue, 12 Jul 2022 05:11:41 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id q27-20020a37f71b000000b006b249cc505fsm8750924qkj.82.2022.07.12.05.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:11:41 -0700 (PDT)
Message-ID: <eabcfde4303971335727a132a568e3bf2cb5c3a4.camel@redhat.com>
Subject: Re: [PATCH v3 24/25] KVM: VMX: Cache MSR_IA32_VMX_MISC in
 vmcs_config
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 15:11:38 +0300
In-Reply-To: <20220708144223.610080-25-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-25-vkuznets@redhat.com>
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
> Like other host VMX control MSRs, MSR_IA32_VMX_MISC can be cached in
> vmcs_config to avoid the need to re-read it later, e.g. from
> cpu_has_vmx_intel_pt() or cpu_has_vmx_shadow_vmcs().
> 
> No (real) functional change intended.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/capabilities.h | 11 +++--------
>  arch/x86/kvm/vmx/vmx.c          |  8 +++++---
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 07e7492fe72a..07f7a9534211 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -65,6 +65,7 @@ struct vmcs_config {
>         u64 cpu_based_3rd_exec_ctrl;
>         u32 vmexit_ctrl;
>         u32 vmentry_ctrl;
> +       u64 misc;
>         struct nested_vmx_msrs nested;
>  };
>  extern struct vmcs_config vmcs_config;
> @@ -225,11 +226,8 @@ static inline bool cpu_has_vmx_vmfunc(void)
>  
>  static inline bool cpu_has_vmx_shadow_vmcs(void)
>  {
> -       u64 vmx_msr;
> -
>         /* check if the cpu supports writing r/o exit information fields */
> -       rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
> -       if (!(vmx_msr & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
> +       if (!(vmcs_config.misc & MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS))
>                 return false;
>  
>         return vmcs_config.cpu_based_2nd_exec_ctrl &
> @@ -371,10 +369,7 @@ static inline bool cpu_has_vmx_invvpid_global(void)
>  
>  static inline bool cpu_has_vmx_intel_pt(void)
>  {
> -       u64 vmx_msr;
> -
> -       rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
> -       return (vmx_msr & MSR_IA32_VMX_MISC_INTEL_PT) &&
> +       return (vmcs_config.misc & MSR_IA32_VMX_MISC_INTEL_PT) &&
>                 (vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
>                 (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 35285109856f..ab091758c437 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2479,6 +2479,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>         u64 _cpu_based_3rd_exec_control = 0;
>         u32 _vmexit_control = 0;
>         u32 _vmentry_control = 0;
> +       u64 misc_msr;
>         int i;
>  
>         /*
> @@ -2613,6 +2614,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>         if (((vmx_msr_high >> 18) & 15) != 6)
>                 return -EIO;
>  
> +       rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
> +
>         vmcs_conf->size = vmx_msr_high & 0x1fff;
>         vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
>  
> @@ -2624,6 +2627,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>         vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
>         vmcs_conf->vmexit_ctrl         = _vmexit_control;
>         vmcs_conf->vmentry_ctrl        = _vmentry_control;
> +       vmcs_conf->misc = misc_msr;
>  
>         return 0;
>  }
> @@ -8241,11 +8245,9 @@ static __init int hardware_setup(void)
>  
>         if (enable_preemption_timer) {
>                 u64 use_timer_freq = 5000ULL * 1000 * 1000;
> -               u64 vmx_msr;
>  
> -               rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
>                 cpu_preemption_timer_multi =
> -                       vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> +                       vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
>  
>                 if (tsc_khz)
>                         use_timer_freq = (u64)tsc_khz * 1000;


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

