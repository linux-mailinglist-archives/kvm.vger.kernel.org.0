Return-Path: <kvm+bounces-66002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49020CBF788
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33C97301AD3F
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC8E328B61;
	Mon, 15 Dec 2025 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CQvyUyYu"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F231A552
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 18:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765824685; cv=none; b=Vfz0alMWa8RbAbbkb/S9n47m6DiSGU7kMWK5YNtaa49393h5h330jxsomVxUUH1LcElVbepgoQHyjc8JHAD6Z/AlsW2aoHcoTdBxad0lPwHIa0f92X9JGmlBy7M1a5eKTwcFnUBdjlGDmZHy+fByQCf3str0yCiarWHk0bttm18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765824685; c=relaxed/simple;
	bh=VZ+JFhKY+Xu/XFcqXByZHGhajSRgZPwT1nz/hbY53g4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DtXkMmdktIbIznBxUuyoRcZHW0CxOFKxlSlmuA601pP0DGWAU5Y6H0KRzgj3viDBhn33EEktX+D6GSgsCS2FZq3wm2qERrR5JYGdhRnYaFx42tqiF4YbkZLgnEYrYTU45dY5ySA/vxilWCYp3OgyciquMPhFblRiGKwhXVFVlA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CQvyUyYu; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Dec 2025 18:51:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765824668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yn4BKQz0h3wCFltMTJSjKHBsuoO6ogWplBXnI2U41z8=;
	b=CQvyUyYuLZncozYwi/rSx8X4IwrkXIrKAfRntu+BjQSfuX+v1FeMLVufhYdDy//erDXVL9
	LjNgl6+9SwD94vwdSZNR6Prwc5D/vVwK/Oy4B89aHGM+RLTiB+lBlv1HYHjvN8Zy1e5xCy
	vZR3OSW9ioPc7Bk0tDS6VxKjTnSldAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kevin Cheng <chengkev@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: SVM: Don't allow L1 intercepts for instructions
 not advertised
Message-ID: <s2he4kulkeylkrv5n7r5vb7uyr72lvv7yajh5ln67d3zjwrnai@e4stv2pkh7c4>
References: <20251215160710.1768474-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215160710.1768474-1-chengkev@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 15, 2025 at 04:07:10PM +0000, Kevin Cheng wrote:
> If a feature is not advertised in the guest's CPUID, prevent L1 from
> intercepting the unsupported instructions by clearing the corresponding
> intercept in KVM's cached vmcb12.
> 
> When an L2 guest executes an instruction that is not advertised to L1,
> we expect a #UD exception to be injected by L0. However, the nested svm
> exit handler first checks if the instruction intercept is set in vmcb12,
> and if so, synthesizes an exit from L2 to L1 instead of a #UD exception.
> If a feature is not advertised, the L1 intercept should be ignored.
> 
> While creating KVM's cached vmcb12, sanitize the intercepts for
> instructions that are not advertised in the guest CPUID. This
> effectively ignores the L1 intercept on nested vm exit handling.

Nit: It also ignores the L1 intercept when computing the intercepts in
VMCB02, so if L0 (for some reason) does not intercept the instruction,
KVM won't intercept it at all.

I don't think this should happen because KVM should always intercept
unsupported instructions to inject a #UD, unless they are not supported
by HW, in which case I believe the HW will inject the #UD for us.

> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>

Maybe also this since Sean contributed code to the patch in his last
review?

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>

Otherwise looks good to me, FWIW:
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
> v1 -> v2:
>   - Removed nested_intercept_mask which was a bit mask for nested
>     intercepts to ignore.
>   - Now sanitizing intercepts every time cached vmcb12 is created
>   - New wrappers for vmcb set/clear intercept functions
>   - Added macro functions for vmcb12 intercept sanitizing
>   - All changes suggested by Sean. Thanks!
>   - https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@google.com/
> 
>  arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++++
>  arch/x86/kvm/svm/svm.h    | 35 +++++++++++++++++++++++++++--------
>  2 files changed, 46 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c81005b245222..5ffc12a315ec7 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -403,6 +403,19 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
>  	return __nested_vmcb_check_controls(vcpu, ctl);
>  }
> 
> +/*
> + * If a feature is not advertised to L1, clear the corresponding vmcb12
> + * intercept.
> + */
> +#define __nested_svm_sanitize_intercept(__vcpu, __control, fname, iname)	\
> +do {										\
> +	if (!guest_cpu_cap_has(__vcpu, X86_FEATURE_##fname))			\
> +		vmcb12_clr_intercept(__control, INTERCEPT_##iname);		\
> +} while (0)
> +
> +#define nested_svm_sanitize_intercept(__vcpu, __control, name)			\
> +	__nested_svm_sanitize_intercept(__vcpu, __control, name, name)
> +
>  static
>  void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  					 struct vmcb_ctrl_area_cached *to,
> @@ -413,6 +426,12 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
>  	for (i = 0; i < MAX_INTERCEPT; i++)
>  		to->intercepts[i] = from->intercepts[i];
> 
> +	__nested_svm_sanitize_intercept(vcpu, to, XSAVE, XSETBV);
> +	nested_svm_sanitize_intercept(vcpu, to, INVPCID);
> +	nested_svm_sanitize_intercept(vcpu, to, RDTSCP);
> +	nested_svm_sanitize_intercept(vcpu, to, SKINIT);
> +	nested_svm_sanitize_intercept(vcpu, to, RDPRU);
> +
>  	to->iopm_base_pa        = from->iopm_base_pa;
>  	to->msrpm_base_pa       = from->msrpm_base_pa;
>  	to->tsc_offset          = from->tsc_offset;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9e151dbdef25d..7a8c92c4de2fb 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -434,28 +434,47 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>   */
>  #define SVM_REGS_LAZY_LOAD_SET	(1 << VCPU_EXREG_PDPTR)
> 
> -static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
> +static inline void __vmcb_set_intercept(unsigned long *intercepts, u32 bit)
>  {
>  	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
> -	__set_bit(bit, (unsigned long *)&control->intercepts);
> +	__set_bit(bit, intercepts);
>  }
> 
> -static inline void vmcb_clr_intercept(struct vmcb_control_area *control, u32 bit)
> +static inline void __vmcb_clr_intercept(unsigned long *intercepts, u32 bit)
>  {
>  	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
> -	__clear_bit(bit, (unsigned long *)&control->intercepts);
> +	__clear_bit(bit, intercepts);
>  }
> 
> -static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
> +static inline bool __vmcb_is_intercept(unsigned long *intercepts, u32 bit)
>  {
>  	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
> -	return test_bit(bit, (unsigned long *)&control->intercepts);
> +	return test_bit(bit, intercepts);
> +}
> +
> +static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
> +{
> +	__vmcb_set_intercept((unsigned long *)&control->intercepts, bit);
> +}
> +
> +static inline void vmcb_clr_intercept(struct vmcb_control_area *control, u32 bit)
> +{
> +	__vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
> +}
> +
> +static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
> +{
> +	return __vmcb_is_intercept((unsigned long *)&control->intercepts, bit);
> +}
> +
> +static inline void vmcb12_clr_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
> +{
> +	__vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
>  }
> 
>  static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
>  {
> -	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
> -	return test_bit(bit, (unsigned long *)&control->intercepts);
> +	return __vmcb_is_intercept((unsigned long *)&control->intercepts, bit);
>  }
> 
>  static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
> --
> 2.52.0.239.gd5f0c6e74e-goog
> 

