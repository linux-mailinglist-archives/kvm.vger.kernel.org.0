Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A95569211
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 20:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbiGFSo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 14:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiGFSoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 14:44:54 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2484626105
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 11:44:52 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r22so7782160pgr.2
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 11:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sq6qcos9XNbTRumjT46X79ghULTNnNg9dBEgItaotRg=;
        b=UiM407N8Ln1qohMz5R08dtWO1lpCPUaHlBkxBwsRUs3WY2BJLH3d2iXtUZ7jBHtfFH
         COL5eqVAz9+PBz4XepDF5fWW5Kq+gd00vYE37UwqJrpYMxLqtzBNmvVgVtDuUFXAM/tI
         r8JDpaZwE0dnfsR3kyP6p2bXAC8fjZ3kjy2/OIpmXfctqjTEqbNlsxrS1S1fJr1hN1Rz
         eYPilgvjTpA4DD6ius19pGlyky5Z5+PhU5yKehg2UMPrivnvBjNz2ydKvwrg3w4a+eCZ
         PVcSErKmW8h87YuBkoDCnf62jhu6CPzQUx0pkQTV7jt6aNdlll/Yp7E86+kfmDO9QNZm
         BAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sq6qcos9XNbTRumjT46X79ghULTNnNg9dBEgItaotRg=;
        b=PrJ4DX4aF2Dko7XMH4Fk+8RnkdfHUi+vGNgMrugH8kDZvDx3IxKKjjtE7qW2cYvqYb
         REci8NBPcIZHmhQRAw+ZNnCw94zq640Dc1Y9NMB8w/BS3FQ+yNWV/z5dYQk1ZDvqSTno
         NNzwzOmS8l3EcjoMy+bufx6I8A1QJQNLm+dQgnqlYgPD9BusFczzC/KOu/ruJZPwd7bF
         Y3Tw5M+Id5huEUB/m0qsX3TxxjrP8OCj2gyCvOo9ITWVp+nESpATnTQwTp+FWJZVvCwB
         U74V7FLjo1cS0JweyXWVWB8Z1eVlc3rJbxBIMPKFU4EPMPElKqtPwUKsvKEjqW56Ph7t
         a0Xg==
X-Gm-Message-State: AJIora/1A5JFEUEDIIgpfGg6Q8h/8Gdf1WX25/WQV1IYwb+vacC4ae2M
        5v36s2KoObl4SmbNBmrCrUCgDwu8FQT3hQ==
X-Google-Smtp-Source: AGRyM1u3p5z/7I2/9J4cfRGN7XazRx99bmivFsfVOoZ7Ho+YDb5U8qfRpc1ZHvSjssvvBUq/9S0cMg==
X-Received: by 2002:a65:4d45:0:b0:411:83dc:9625 with SMTP id j5-20020a654d45000000b0041183dc9625mr34831547pgt.359.1657133091569;
        Wed, 06 Jul 2022 11:44:51 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id v16-20020a170902e8d000b0015e8d4eb24fsm25884936plg.153.2022.07.06.11.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 11:44:51 -0700 (PDT)
Date:   Wed, 6 Jul 2022 18:44:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/28] KVM: VMX: Check
 CPU_BASED_{INTR,NMI}_WINDOW_EXITING in setup_vmcs_config()
Message-ID: <YsXYH43clik02kZ9@google.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-16-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629150625.238286-16-vkuznets@redhat.com>
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

On Wed, Jun 29, 2022, Vitaly Kuznetsov wrote:
> CPU_BASED_{INTR,NMI}_WINDOW_EXITING controls are toggled dynamically by
> vmx_enable_{irq,nmi}_window, handle_interrupt_window(), handle_nmi_window()
> but setup_vmcs_config() doesn't check their existence. Add the check and
> filter the controls out in vmx_exec_control().
> 
> No (real) functional change intended as all existing CPUs supporting
> VMX are supposed to have these controls.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index da8bbba38d0e..89a3bbafa5af 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2487,7 +2487,9 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	      CPU_BASED_MWAIT_EXITING |
>  	      CPU_BASED_MONITOR_EXITING |
>  	      CPU_BASED_INVLPG_EXITING |
> -	      CPU_BASED_RDPMC_EXITING;
> +	      CPU_BASED_RDPMC_EXITING |
> +	      CPU_BASED_INTR_WINDOW_EXITING |
> +	      CPU_BASED_NMI_WINDOW_EXITING;

Requiring NMI_WINDOW_EXITING is wrong, KVM doesn't use NMI_WINDOW_EXITING if
enable_vnmi == false:

	if (!enable_vnmi ||
	    vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & GUEST_INTR_STATE_STI) {
		vmx_enable_irq_window(vcpu);
		return;
	}

	exec_controls_setbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);

And enable_vnmi is cleared if PIN_BASED_VIRTUAL_NMIS are unsupported:

	if (!cpu_has_virtual_nmis())
		enable_vnmi = 0;

I suspect CPUs that don't support VIRTUAL_NMIS also don't support NMI_WINDOW_EXITING,
and KVM explicitly supports such CPUs.  See commit 8a1b43922d0d ("kvm: vmx: Reinstate
support for CPUs without virtual NMI").

Making NMI_WINDOW_EXITING optional and then adding it to cpu_has_virtual_nmis()
seems like the correct approach.

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 069d8d298e1d..c34890e9fc2a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -82,7 +82,8 @@ static inline bool cpu_has_vmx_basic_inout(void)

 static inline bool cpu_has_virtual_nmis(void)
 {
-       return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS;
+       return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
+              vmcs_config.cpu_based_exec_ctrl & CPU_BASED_NMI_WINDOW_EXITING;
 }

 static inline bool cpu_has_vmx_preemption_timer(void)


>  	opt = CPU_BASED_TPR_SHADOW |
>  	      CPU_BASED_USE_MSR_BITMAPS |
> @@ -4300,6 +4302,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  {
>  	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
>  
> +	/* INTR_WINDOW_EXITING and NMI_WINDOW_EXITING are toggled dynamically */
> +	exec_control &= ~(CPU_BASED_INTR_WINDOW_EXITING |
> +			  CPU_BASED_NMI_WINDOW_EXITING);
> +
>  	if (vmx->vcpu.arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
>  		exec_control &= ~CPU_BASED_MOV_DR_EXITING;
>  
> -- 
> 2.35.3
> 
