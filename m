Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB5E38836A
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 02:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240636AbhESAGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 20:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbhESAGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 20:06:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63DBC06175F
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 17:05:13 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g24so6382258pji.4
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 17:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GwaBtp7bifJLAHNGxvtcxZEF1Q5oQ1KIalOg6glg2uQ=;
        b=PO0eQTjgHcYkiMAg7WJ0lIsJ54x8p6BPhJkX5FWObU8/KlXnQtl92ahLI/12hrRYcY
         hUapxPhFEcaAQyxi4OB/3zOeN3CwRz22hpOQmKUhrtp58cwyF3SXsXHayueLvyGzGVml
         GLpUZXZcrZSlZmku6ZfqLnIhIqUnJiarpuO3SrdHQUbp7uiXrdSCQwWlfHyaTr+2CVHj
         wbnZqMZwyN58ZuKD4jJvHWk7HSs2R/T8BvfLwTTZbyhccc9DlYQtdkt5aUqwY764D4mE
         blE/PJqv/AL+Lot2XXlF2OV5sblKKaoPsrO6XW1L9LLXPxlV2zBAqUhuOOt+F2Suwp1z
         tKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GwaBtp7bifJLAHNGxvtcxZEF1Q5oQ1KIalOg6glg2uQ=;
        b=f2jmx2CJ04yXpTqi0Vj1sZMLC0oKr9vJje2FK/eFz9aAo494QITxqplmppQRQb/bTo
         rvwbi0tkKqV6wgMOLr3TI/EwefMytrjyrKVziZGYaVbldfpkbLPGMuWSkZbZMTu/0Hae
         s+yr8roUUwrByo7Rt3VT0kV7wQbZPGoMgKJ3il/7nnEQOUrXqrXfyEMehfp52b6af9LV
         seGtyFr8061wRY4uRqoopFk9LaAggb4io5bFiWO/A7Yf3+7jFDUHphQTtPtmoywx0xhn
         +8RmCu1KY3S2x04Dhq39wH+iV5qJ0Dl8ox+yuMUXn5TCHhurD+nIq/AkahRvwEimaGgN
         bdDQ==
X-Gm-Message-State: AOAM532R3dL60gj+yMYASu12oAwU002OsPYUdhpic6nCg0pvKVrx50If
        qHvygdzD6MWx3NCnEMXWFOgmvA==
X-Google-Smtp-Source: ABdhPJyKbwBoFDkYIksAffjufhTy/7NZDbUjhHDtYDx9vcrqTvmiEauoRXlJgxBp8jGHjj+Mms7HWw==
X-Received: by 2002:a17:902:a40e:b029:e9:7253:8198 with SMTP id p14-20020a170902a40eb02900e972538198mr7379061plq.82.1621382713123;
        Tue, 18 May 2021 17:05:13 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o10sm25233pfh.67.2021.05.18.17.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 17:05:12 -0700 (PDT)
Date:   Wed, 19 May 2021 00:05:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ilias Stamatis <ilstam@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        zamsden@gmail.com, mtosatti@redhat.com, dwmw@amazon.co.uk
Subject: Re: [PATCH v2 07/10] KVM: X86: Move write_l1_tsc_offset() logic to
 common code and rename it
Message-ID: <YKRWNaqzo4GVDxHP@google.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
 <20210512150945.4591-8-ilstam@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512150945.4591-8-ilstam@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Ilias Stamatis wrote:
> The write_l1_tsc_offset() callback has a misleading name. It does not
> set L1's TSC offset, it rather updates the current TSC offset which
> might be different if a nested guest is executing. Additionally, both
> the vmx and svm implementations use the same logic for calculating the
> current TSC before writing it to hardware.

I don't disagree, but the current name as the advantage of clarifying (well,
hinting) that the offset is L1's offset.  That hint is lost in this refactoring.
Maybe rename "u64 offset" to "u64 l1_tsc_offset"?

> This patch renames the function and moves the common logic to the

Use imperative mood instead of "This patch.  From 
Documentation/process/submitting-patches.rst:

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.

> caller. The vmx/svm-specific code now merely sets the given offset to
> the corresponding hardware structure.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>  arch/x86/include/asm/kvm_host.h    |  3 +--
>  arch/x86/kvm/svm/svm.c             | 21 ++++-----------------
>  arch/x86/kvm/vmx/vmx.c             | 23 +++--------------------
>  arch/x86/kvm/x86.c                 | 17 ++++++++++++++++-
>  5 files changed, 25 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 2063616fba1c..029c9615378f 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -89,7 +89,7 @@ KVM_X86_OP(load_mmu_pgd)
>  KVM_X86_OP_NULL(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> -KVM_X86_OP(write_l1_tsc_offset)
> +KVM_X86_OP(write_tsc_offset)
>  KVM_X86_OP(get_exit_info)
>  KVM_X86_OP(check_intercept)
>  KVM_X86_OP(handle_exit_irqoff)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 57a25d8e8b0f..61cf201c001a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1307,8 +1307,7 @@ struct kvm_x86_ops {
>  
>  	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
>  	u64 (*get_l2_tsc_multiplier)(struct kvm_vcpu *vcpu);
> -	/* Returns actual tsc_offset set in active VMCS */
> -	u64 (*write_l1_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
> +	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
>  
>  	/*
>  	 * Retrieve somewhat arbitrary exit information.  Intended to be used
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 679b2fc1a3f9..b18f60463073 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1094,26 +1094,13 @@ static u64 svm_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
>  	return kvm_default_tsc_scaling_ratio;
>  }
>  
> -static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> +static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> -	u64 g_tsc_offset = 0;
> -
> -	if (is_guest_mode(vcpu)) {
> -		/* Write L1's TSC offset.  */
> -		g_tsc_offset = svm->vmcb->control.tsc_offset -
> -			       svm->vmcb01.ptr->control.tsc_offset;
> -		svm->vmcb01.ptr->control.tsc_offset = offset;
> -	}
> -
> -	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> -				   svm->vmcb->control.tsc_offset - g_tsc_offset,
> -				   offset);
> -
> -	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
>  
> +	svm->vmcb01.ptr->control.tsc_offset = vcpu->arch.l1_tsc_offset;
> +	svm->vmcb->control.tsc_offset = offset;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> -	return svm->vmcb->control.tsc_offset;
>  }
>  
>  /* Evaluate instruction intercepts that depend on guest CPUID features. */
> @@ -4540,7 +4527,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  
>  	.get_l2_tsc_offset = svm_get_l2_tsc_offset,
>  	.get_l2_tsc_multiplier = svm_get_l2_tsc_multiplier,
> -	.write_l1_tsc_offset = svm_write_l1_tsc_offset,
> +	.write_tsc_offset = svm_write_tsc_offset,
>  
>  	.load_mmu_pgd = svm_load_mmu_pgd,
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 575e13bddda8..3c4eb14a1e86 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1810,26 +1810,9 @@ static u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
>  	return multiplier;
>  }
>  
> -static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> +static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
> -	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> -	u64 g_tsc_offset = 0;
> -
> -	/*
> -	 * We're here if L1 chose not to trap WRMSR to TSC. According
> -	 * to the spec, this should set L1's TSC; The offset that L1
> -	 * set for L2 remains unchanged, and still needs to be added
> -	 * to the newly set TSC to get L2's TSC.
> -	 */
> -	if (is_guest_mode(vcpu) &&
> -	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
> -		g_tsc_offset = vmcs12->tsc_offset;
> -
> -	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> -				   vcpu->arch.tsc_offset - g_tsc_offset,
> -				   offset);
> -	vmcs_write64(TSC_OFFSET, offset + g_tsc_offset);
> -	return offset + g_tsc_offset;
> +	vmcs_write64(TSC_OFFSET, offset);
>  }
>  
>  /*
> @@ -7725,7 +7708,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
>  	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
> -	.write_l1_tsc_offset = vmx_write_l1_tsc_offset,
> +	.write_tsc_offset = vmx_write_tsc_offset,
>  
>  	.load_mmu_pgd = vmx_load_mmu_pgd,
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1db6cfc2079f..f3ba1be4d5b9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2377,8 +2377,23 @@ EXPORT_SYMBOL_GPL(kvm_set_02_tsc_multiplier);
>  
>  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
> +	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
> +				   vcpu->arch.l1_tsc_offset,
> +				   offset);
> +
>  	vcpu->arch.l1_tsc_offset = offset;
> -	vcpu->arch.tsc_offset = static_call(kvm_x86_write_l1_tsc_offset)(vcpu, offset);
> +	vcpu->arch.tsc_offset = offset;
> +
> +	if (is_guest_mode(vcpu)) {

Unnecessary curly braces.

> +		/*
> +		 * We're here if L1 chose not to trap WRMSR to TSC and
> +		 * according to the spec this should set L1's TSC (as opposed
> +		 * to setting L1's offset for L2).
> +		 */

While we're shuffling code, can we improve this comment?  It works for the WRMSR
case, but makes no sense in the context of host TSC adjustments.  It's not at all
clear to me that it's even correct or relevant in those cases.

> +		kvm_set_02_tsc_offset(vcpu);

I really dislike that kvm_set_02_tsc_offset() consumes a bunch of variables
_and_ sets arch.tsc_offset, e.g. it's not at all obvious that moving this call
around will break L2.  Even more bizarre is that arch.tsc_offset is conditionally
consumed.  Oh, and kvm_set_02_tsc_offset() is not idempotent since it can do a
RMW on arch.tsc_offset.

The below static_call() dependency doesn't appear to be easily solved, but we
can at least strongly hint that vcpu->arch.tsc_offset is set.  For everything
else, I think we can clean things up by doing this (with the vendor calls
providing the L2 variables directly):

void kvm_set_l2_tsc_offset(struct kvm_vcpu *vcpu, u64 l2_offset,
			   u64 l2_multiplier)
{
	u64 l1_offset = vcpu->arch.l1_tsc_offset;

	if (l2_multiplier != kvm_default_tsc_scaling_ratio)
		l2_offset += mul_s64_u64_shr((s64)l1_tsc_offset, l2_multiplier,
					     kvm_tsc_scaling_ratio_frac_bits);

	vcpu->arch.tsc_offset = l2_offset;
}
EXPORT_SYMBOL_GPL(kvm_get_l2_tsc_offset);

static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
{
	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
				   vcpu->arch.l1_tsc_offset,
				   offset);

	vcpu->arch.l1_tsc_offset = offset;

	if (is_guest_mode(vcpu))
		kvm_set_l2_tsc_offset(vcpu,
				      static_call(kvm_x86_get_l2_tsc_offset)(vcpu),
				      static_call(kvm_x86_get_l2_tsc_multiplier)(vcpu));
	else
		vcpu->arch.tsc_offset = offset;

	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
}


An alternative would be to explicitly track L1 and L2, and _never_ track the
current TSC values.  I.e. always compute the correct value on the fly.  I think
the only hot path is the TSC deadline timer, and AFAICT that always runs with
L1's timer.  Speaking of which, at the end of this series, vmx_set_hv_timer()
uses L1's TSC but the current scaling ratio; that can't be right.

> +	}
> +
> +	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
>  }
>  
>  static inline bool kvm_check_tsc_unstable(void)
> -- 
> 2.17.1
> 
