Return-Path: <kvm+bounces-32443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 192009D87AF
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCDD128973F
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1CC61B4F02;
	Mon, 25 Nov 2024 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ru+WjxgV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207F1B4150
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732543984; cv=none; b=OmDRTUOYMLgtIUd0yTH1Ce0a7stblTYfizCrtvGWSTiZm7S/L7mqajGnQn9dIjzV899Q+r6mvDL1+r4P1PJMGQeLaDPxAbyyjsrybChLpDM5GV7N2/sU1xMoCmmFdfKb/hAtdw2IkisQIQUMhR0mvvIbCNJXN1eas8qhhDm2rUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732543984; c=relaxed/simple;
	bh=jfivhIg7aUto2oGlQ04H/B4B10ZNuvrOJRK8G5h3zWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hcoKfgZ0rMyeQYTAa8HLAicxegGiLtCZ3n5C5lT/Y3s6GkGnRaRb9N5ngP1n8YTyACklBjVsWUM9oqEkLjcglSuHyYXthC6VcW6c5pmR2r1j7XNXZECIJ8aEXVdFpD/qW1klCgXx9/VOM0VRwZ/sD6GTapIsZK/S3sXHoyH0jg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ru+WjxgV; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-382588b7a5cso2878290f8f.3
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 06:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732543978; x=1733148778; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4gVz440njote0niyNGPo4UZALl9cC2Mqnw/NUgHXwIo=;
        b=Ru+WjxgVFLk/60rYqDt5UJbhUuJEeN0/zw41Pl3e3ZAq9Xp19Ie+fQlcnTu2sRwjPG
         Dl98l7uxgJhtan8JtszLdGi+DH2Fl/t+lWGk74EaB9qE2thKVau1PCv/CAYIhufCvEBc
         lGYHobFApCz3eXpBLUEIz2QZAl6n/ebXqQdXuBNfiqln3WhKH2MxlUI5RT6E6DDctIJU
         oJxojEjwJChXaFRf5up2GjX0iWXhJbth21i9g9iusZ911B03SVlhLw2vXZcX1MRzeMt5
         3I1L0FP85Yy+MPPCPSo5kFBDEVzZ9Bg02A2ocvnfURANVaW19AwYRHOOJCGSfP8BlM6D
         K77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732543978; x=1733148778;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4gVz440njote0niyNGPo4UZALl9cC2Mqnw/NUgHXwIo=;
        b=GYIU4Yw+pWIiK2X6yBbHIXSz9dTYv9aG1wsY3IVbbSEhQ9DgG0QkTQ5TM7rYJVI/l3
         32Tyg8uG8jbjj3KzNJRVjXA+9xL3/iRMGYudm42WK61GQyvo4U9U5NDNpTn8dLRM4S33
         ZWT7bQboW9aWwAf9trFrNbhUnLAUMMPTNSWJO3QiZ+6Xg5+f0DsH20RmUAhoE+VMLWYr
         QIzMSdBu6ZbMj4GuShPtmmAGObRwR7XuU04XnElVqBespjTLBCfDT2yq3CdgW4s4Q+68
         UOWKMGLcyMwHcZNvnVFVDU4g928niNiCWvAwWuDP7lkIk/62CFxA5JA/uaWZFKn+/Kiw
         FQdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6Hjb40SdXIn/04U4S/B9m5LFLI4S0hnNAobJcZzBPg9TJXZHMehWmRvkU2/23FUIOHDA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr7RqdN02tNmmlnfyj66++9k6cWONnOLriYtjrMmhkQF9/tZo4
	osWKi4OruU2QyS1lKmLXMtNsurD+JEHIXoZouE/VRkR8arJNIn+SaOtVPvHe/nCvyRNe8WDw3oH
	s
X-Gm-Gg: ASbGncvDiHz8lVbipThAwkmfYrMQMjSvxIH9zSlf8S6cLpMVHLK+SNHdNu1qtc5B4IO
	nMJLRZuxYMqrgbgiXWPF8ZvT/Bkoo0Fej61DYIDqetL0YQX8rk5gm1kyL1VPFyGCSdhpzpFy00P
	bZyE+6CFkRsI4ZJYKXbuU9cQFIJOtUjkbdWISDZIWny53LGMx47JAyZvyx0jvqjZq6RRaR58qc7
	pdOG6TQ1Sdn6FoWYUI44GYI2ZwuUQpPtRoY+JK76I/fvaF8AVvuoNv+vHRkndwtBJ4oMtcRzuI=
X-Google-Smtp-Source: AGHT+IFYMLA5XQgTlnnz8NosU5dYI/WPFCJbbn7S4jK0rulXGq98bpUipCFpTtepERr+h7Ptckqy+A==
X-Received: by 2002:adf:e18c:0:b0:382:5aae:87ac with SMTP id ffacd0b85a97d-38260b8966dmr10776215f8f.32.1732543978557;
        Mon, 25 Nov 2024 06:12:58 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.217.62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fad6441sm10756656f8f.4.2024.11.25.06.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 06:12:58 -0800 (PST)
Message-ID: <657c5837-2b65-4f56-afa3-3fad2cd47c5e@suse.com>
Date: Mon, 25 Nov 2024 16:12:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] KVM: TDX: vcpu_run: save/restore host state(host
 kernel gs)
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-4-adrian.hunter@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20241121201448.36170-4-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 21.11.24 г. 22:14 ч., Adrian Hunter wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> On entering/exiting TDX vcpu, preserved or clobbered CPU state is different
> from the VMX case. Add TDX hooks to save/restore host/guest CPU state.
> Save/restore kernel GS base MSR.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> TD vcpu enter/exit v1:
>   - Clarify comment (Binbin)
>   - Use lower case preserved and add the for VMX in log (Tony)
>   - Fix bisectability issue with includes (Kai)
> ---
>   arch/x86/kvm/vmx/main.c    | 24 ++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx.c     | 46 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h     |  4 ++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   4 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 44ec6005a448..3a8ffc199be2 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -129,6 +129,26 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	vmx_vcpu_load(vcpu, cpu);
>   }
>   
> +static void vt_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
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
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_vcpu_put(vcpu);
> +		return;
> +	}
> +
> +	vmx_vcpu_put(vcpu);
> +}
> +
>   static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
>   {
>   	if (is_td_vcpu(vcpu))
> @@ -250,9 +270,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_free = vt_vcpu_free,
>   	.vcpu_reset = vt_vcpu_reset,
>   
> -	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
> +	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
>   	.vcpu_load = vt_vcpu_load,
> -	.vcpu_put = vmx_vcpu_put,
> +	.vcpu_put = vt_vcpu_put,
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
>   	.get_feature_msr = vmx_get_feature_msr,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 5fa5b65b9588..6e4ea2d420bc 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1,6 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <linux/cleanup.h>
>   #include <linux/cpu.h>
> +#include <linux/mmu_context.h>
>   #include <asm/tdx.h>
>   #include "capabilities.h"
>   #include "mmu.h"
> @@ -9,6 +10,7 @@
>   #include "vmx.h"
>   #include "mmu/spte.h"
>   #include "common.h"
> +#include "posted_intr.h"
>   
>   #include <trace/events/kvm.h>
>   #include "trace.h"
> @@ -605,6 +607,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
>   		vcpu->arch.xfd_no_write_intercept = true;
>   
> +	tdx->host_state_need_save = true;
> +	tdx->host_state_need_restore = false;

nit: Rather than have 2 separate values which actually work in tandem, 
why not define a u8 or even u32 and have a mask of the valid flags.

So you can have something like:

#define SAVE_HOST BIT(0)
#define RESTORE_HOST BIT(1)

tdx->state_flags = SAVE_HOST

I don't know what are the plans for the future but there might be cases 
where you can have more complex flags composed of more simple ones.

>   	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
>   
>   	return 0;
> @@ -631,6 +636,45 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   	local_irq_enable();
>   }
>   
> +/*
> + * Compared to vmx_prepare_switch_to_guest(), there is not much to do
> + * as SEAMCALL/SEAMRET calls take care of most of save and restore.
> + */
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	if (!tdx->host_state_need_save)
if (!(tdx->state_flags & SAVE_HOST))
> +		return;
> +
> +	if (likely(is_64bit_mm(current->mm)))
> +		tdx->msr_host_kernel_gs_base = current->thread.gsbase;
> +	else
> +		tdx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
> +
> +	tdx->host_state_need_save = false;

tdx->state &= ~SAVE_HOST
> +}
> +
> +static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	tdx->host_state_need_save = true;
> +	if (!tdx->host_state_need_restore)
if (!(tdx->state_flags & RESTORE_HOST)

> +		return;
> +
> +	++vcpu->stat.host_state_reload;
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
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -732,6 +776,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   
>   	tdx_vcpu_enter_exit(vcpu);
>   
> +	tdx->host_state_need_restore = true;

tdx->state_flags |= RESTORE_HOST

> +
>   	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>   	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>   
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index ebee1049b08b..48cf0a1abfcc 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -54,6 +54,10 @@ struct vcpu_tdx {
>   	u64 vp_enter_ret;
>   
>   	enum vcpu_tdx_state state;
> +
> +	bool host_state_need_save;
> +	bool host_state_need_restore;

this would save having a discrete member for those boolean checks.

> +	u64 msr_host_kernel_gs_base;
>   };
>   
>   void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 3d292a677b92..5bd45a720007 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -130,6 +130,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
> +void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
> +void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   
> @@ -161,6 +163,8 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
>   {
>   	return EXIT_FASTPATH_NONE;
>   }
> +static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
> +static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   


