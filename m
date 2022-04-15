Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E40502B61
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 15:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354213AbiDON7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 09:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354209AbiDON7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 09:59:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC467BD88F;
        Fri, 15 Apr 2022 06:57:04 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id q8so4760567wmc.0;
        Fri, 15 Apr 2022 06:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Maz5xoTaFvagiEiYVNsdjFdtdhjySTzdO4J3MDS0ljg=;
        b=PQhI5XhtbWgspkqUQV96x6HMNR8jL0F2cARfxur1DpmHsehj0+9gQSIsjRezZKvZOt
         B1EMBjfexEJXhTG0TiUZBxFAmxbWRRIy0+iy6HhGtM/0P2Ghu2dLCr3Sh3g33Zl413o5
         AM+eZUbLCRvk1tS3DxCYl9DxlHbz4UJbJ5OuAiyZdWbhvXfvqW11R+t2bCho9i3LR5gm
         Cno2QDqWMtNyl4DzE7Um4A2A6032kcpXrVnx2RlO6j9R2faUHEKHzma7WbwpMTmAbYwX
         zq2ehLfJ7PUKatDoRWgxR4eyda38hMa4NBi5fY6nDhlzykiY7iK+kJun9sr6ZEQiVV7v
         7MIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Maz5xoTaFvagiEiYVNsdjFdtdhjySTzdO4J3MDS0ljg=;
        b=J/nmTgHp6Qe74Q1oXzo187z4BI9NyWv9ehouErm7Ejug75WLW7yw7IAyUNUheP0v8G
         kSp6dmcFTrJK7M4TUjKW/SsPm03T34hq8B4pIOPUDNUnvcMfNdVH30xneM/Msk9d4egQ
         3g2Sp1cwGLF7r3OtryO6twmiBZYj36LHyUZHqgm0MGofTCavuYe9sP4H/h4RsglHPNM0
         I92yYcu5FwoyiXzOBBe0LETzvYWKcX0aGhme/PLpU0mO/DB3av+rWfBKqr9FsBIqStxa
         3LNNS518OlCJrLZTE/DnJmhAQ4Jf5NTIbcCSgd1uOLcUzsonKQd3CrbhBEl6362YsFtm
         EMeg==
X-Gm-Message-State: AOAM533xmIVRYNdr04GN6f90L6aR/QMLP4nEVWixMH0nqA4y3rBnd/S+
        b6u7ttQBYT8gIKWdxdAYMwg=
X-Google-Smtp-Source: ABdhPJzctoYrkubqpHYNepUtNtdLD3U9dEsw3LzHBLrRK1N58BbqqInXs0AGzmC9mLR76e4JlpO/Cg==
X-Received: by 2002:a05:600c:2306:b0:38e:bf1a:a669 with SMTP id 6-20020a05600c230600b0038ebf1aa669mr3400805wmo.11.1650031023261;
        Fri, 15 Apr 2022 06:57:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id 100-20020adf806d000000b00205ba671b25sm4089214wrk.56.2022.04.15.06.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 06:57:02 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a9043bd0-1467-e922-20f3-243db5e30183@redhat.com>
Date:   Fri, 15 Apr 2022 15:56:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 065/104] KVM: TDX: vcpu_run: save/restore host
 state(host kernel gs)
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <47bfde64180fc00ed236a2e13b25423c984a0eef.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <47bfde64180fc00ed236a2e13b25423c984a0eef.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> On entering/exiting TDX vcpu, Preserved or clobbered CPU state is different
> from VMX case.  Add TDX hooks to save/restore host/guest CPU state.
> Save/restore kernel GS base MSR.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 28 +++++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 39 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h     |  4 ++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   4 files changed, 73 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 2e5a7a72d560..f9d43f2de145 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -89,6 +89,30 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	return vmx_vcpu_reset(vcpu, init_event);
>   }
>   
> +static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * All host state is saved/restored across SEAMCALL/SEAMRET, and the
> +	 * guest state of a TD is obviously off limits.  Deferring MSRs and DRs
> +	 * is pointless because the TDX module needs to load *something* so as
> +	 * not to expose guest state.
> +	 */
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_prepare_switch_to_guest(vcpu);
> +		return;
> +	}
> +
> +	vmx_prepare_switch_to_guest(vcpu);
> +}
> +
> +static void vt_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_vcpu_put(vcpu);
> +
> +	return vmx_vcpu_put(vcpu);
> +}
> +
>   static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -174,9 +198,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_free = vt_vcpu_free,
>   	.vcpu_reset = vt_vcpu_reset,
>   
> -	.prepare_guest_switch = vmx_prepare_switch_to_guest,
> +	.prepare_guest_switch = vt_prepare_switch_to_guest,
>   	.vcpu_load = vmx_vcpu_load,
> -	.vcpu_put = vmx_vcpu_put,
> +	.vcpu_put = vt_vcpu_put,
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
>   	.get_msr_feature = vmx_get_msr_feature,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ebe4f9bf19e7..7a288aae03ba 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1,5 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <linux/cpu.h>
> +#include <linux/mmu_context.h>
>   
>   #include <asm/tdx.h>
>   
> @@ -407,6 +408,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.guest_state_protected =
>   		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
>   
> +	tdx->host_state_need_save = true;
> +	tdx->host_state_need_restore = false;
> +
>   	return 0;
>   
>   free_tdvpx:
> @@ -420,6 +424,39 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	return ret;
>   }
>   
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (!tdx->host_state_need_save)
> +		return;
> +
> +	if (likely(is_64bit_mm(current->mm)))
> +		tdx->msr_host_kernel_gs_base = current->thread.gsbase;
> +	else
> +		tdx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> +
> +	tdx->host_state_need_save = false;
> +}
> +
> +static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	tdx->host_state_need_save = true;
> +	if (!tdx->host_state_need_restore)
> +		return;
> +
> +	wrmsrl(MSR_KERNEL_GS_BASE, tdx->msr_host_kernel_gs_base);
> +	tdx->host_state_need_restore = false;
> +}
> +
> +void tdx_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	vmx_vcpu_pi_put(vcpu);
> +	tdx_prepare_switch_to_host(vcpu);
> +}
> +
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -535,6 +572,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(vcpu, tdx);
>   
> +	tdx->host_state_need_restore = true;
> +
>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>   
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index e950404ce5de..8b1cf9c158e3 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -84,6 +84,10 @@ struct vcpu_tdx {
>   	union tdx_exit_reason exit_reason;
>   
>   	bool initialized;
> +
> +	bool host_state_need_save;
> +	bool host_state_need_restore;
> +	u64 msr_host_kernel_gs_base;
>   };
>   
>   static inline bool is_td(struct kvm *kvm)
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 44404dd25737..8b871c5f52cf 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -141,6 +141,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> @@ -162,6 +164,8 @@ static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>   static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
> +static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
