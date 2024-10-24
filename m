Return-Path: <kvm+bounces-29623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC0C9AE2C2
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD4562830F3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 10:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76251C4A0D;
	Thu, 24 Oct 2024 10:38:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6751A0BD6
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729766312; cv=none; b=aocZwI8TD1O+XQDxbXZdx1ZbcNkBo7849AQ3T+itu9VAT9L4eLh+jMGcqVayhdnRxALaPrdTpQZgMj8hE6JewH7MFV9gP/QMOHPmifJ27p6yaZwSEcybL1eiAQOO8+ddvC3ls/y9G5A5R2lJ6Z8qH4n0SyeHEPHOiNiAvIVDwQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729766312; c=relaxed/simple;
	bh=8P3PZop4XsKv0OgdyvV2UsAKkiUmHrZxtJjnquzGlMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnIczJKa+C8nV0yQ2fCPBAVRRxVJ2ffrXAUZmo0stPAZjT1fR7Ykax0fbg0zEx9ZthGTNjNmoWORGs3nhJlKSNn84nQjFlHuw1N6tJZIv1faAkERkkqejXO6db4YQSmpuKotWMrtyge+Lq23kQFTKpyKcgPBJ5Kbz7OW7TAYtCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2DF4339;
	Thu, 24 Oct 2024 03:38:58 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E5A483F71E;
	Thu, 24 Oct 2024 03:38:27 -0700 (PDT)
Date: Thu, 24 Oct 2024 11:38:25 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 09/37] KVM: arm64: Extend masking facility to
 arbitrary registers
Message-ID: <20241024103825.GC1382116@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-10-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:17PM +0100, Marc Zyngier wrote:
> We currently only use the masking (RES0/RES1) facility for VNCR
> registers, as they are memory-based and thus easy to sanitise.
> 
> But we could apply the same thing to other registers if we:
> 
> - split the sanitisation from __VNCR_START__
> - apply the sanitisation when reading from a HW register
> 
> This involves a new "marker" in the vcpu_sysreg enum, which
> defines the point at which the sanitisation applies (the VNCR
> registers being of course after this marker).
> 
> Whle we are at it, rename kvm_vcpu_sanitise_vncr_reg() to
> kvm_vcpu_apply_reg_masks(), which is vaguely more explicit,
> and harden set_sysreg_masks() against setting masks for
> random registers...
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++------
>  arch/arm64/kvm/nested.c           | 12 ++++++++----
>  arch/arm64/kvm/sys_regs.c         |  3 +++
>  3 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1adf68971bb17..7f409dfc5cd4a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -367,7 +367,7 @@ struct kvm_arch {
>  
>  	u64 ctr_el0;
>  
> -	/* Masks for VNCR-baked sysregs */
> +	/* Masks for VNCR-backed and general EL2 sysregs */
>  	struct kvm_sysreg_masks	*sysreg_masks;
>  
>  	/*
> @@ -401,6 +401,9 @@ struct kvm_vcpu_fault_info {
>  	r = __VNCR_START__ + ((VNCR_ ## r) / 8),	\
>  	__after_##r = __MAX__(__before_##r - 1, r)
>  
> +#define MARKER(m)				\
> +	m, __after_##m = m - 1
> +
>  enum vcpu_sysreg {
>  	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
>  	MPIDR_EL1,	/* MultiProcessor Affinity Register */
> @@ -487,7 +490,11 @@ enum vcpu_sysreg {
>  	CNTHV_CTL_EL2,
>  	CNTHV_CVAL_EL2,
>  
> -	__VNCR_START__,	/* Any VNCR-capable reg goes after this point */
> +	/* Anything from this can be RES0/RES1 sanitised */
> +	MARKER(__SANITISED_REG_START__),
> +
> +	/* Any VNCR-capable reg goes after this point */
> +	MARKER(__VNCR_START__),
>  
>  	VNCR(SCTLR_EL1),/* System Control Register */
>  	VNCR(ACTLR_EL1),/* Auxiliary Control Register */
> @@ -547,7 +554,7 @@ struct kvm_sysreg_masks {
>  	struct {
>  		u64	res0;
>  		u64	res1;
> -	} mask[NR_SYS_REGS - __VNCR_START__];
> +	} mask[NR_SYS_REGS - __SANITISED_REG_START__];
>  };
>  
>  struct kvm_cpu_context {
> @@ -995,13 +1002,13 @@ static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
>  
>  #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
>  
> -u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
> +u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
>  #define __vcpu_sys_reg(v,r)						\
>  	(*({								\
>  		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
>  		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
> -		if (vcpu_has_nv((v)) && (r) >= __VNCR_START__)		\
> -			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
> +		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
> +			*__r = kvm_vcpu_apply_reg_masks((v), (r), *__r);\
>  		__r;							\
>  	}))
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index f9e30dd34c7a1..b20b3bfb9caec 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -908,15 +908,15 @@ static void limit_nv_id_regs(struct kvm *kvm)
>  	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
>  }
>  
> -u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
> +u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
> +			     enum vcpu_sysreg sr, u64 v)
>  {
> -	u64 v = ctxt_sys_reg(&vcpu->arch.ctxt, sr);
>  	struct kvm_sysreg_masks *masks;
>  
>  	masks = vcpu->kvm->arch.sysreg_masks;
>  
>  	if (masks) {
> -		sr -= __VNCR_START__;
> +		sr -= __SANITISED_REG_START__;
>  
>  		v &= ~masks->mask[sr].res0;
>  		v |= masks->mask[sr].res1;
> @@ -927,7 +927,11 @@ u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
>  
>  static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
>  {
> -	int i = sr - __VNCR_START__;
> +	int i = sr - __SANITISED_REG_START__;
> +
> +	BUILD_BUG_ON(!__builtin_constant_p(sr));
> +	BUILD_BUG_ON(sr < __SANITISED_REG_START__);
> +	BUILD_BUG_ON(sr >= NR_SYS_REGS);
>  
>  	kvm->arch.sysreg_masks->mask[i].res0 = res0;
>  	kvm->arch.sysreg_masks->mask[i].res1 = res1;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 932d2fb7a52a0..d9c20563cae93 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -189,6 +189,9 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>  
>  		/* Get the current version of the EL1 counterpart. */
>  		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
> +		if (reg >= __SANITISED_REG_START__)
> +			val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
> +
>  		return val;
>  	}
>  

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

