Return-Path: <kvm+bounces-24372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E87B5954552
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83F7C28422A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA1013D89D;
	Fri, 16 Aug 2024 09:22:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C3213D504
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 09:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723800173; cv=none; b=so2XQ1wvEzAagf5ozX731Lwux99G/sqylt57opqiUgeVleee3dO7s9+EpeD91qpxLWkRM3FB1JbOCPLB51YYnRArkoRvtwbERhks49tUef85icOmfIA4YtowMjsAxpswZcuFEU1TBE2C9ZKkmzdaitNBzeDcgU7C+dcQxtGRhJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723800173; c=relaxed/simple;
	bh=NT7Eov3UZcQdiLqOVT/EaW1jIf0VWRjFqRfDNKR9zx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJyHGgO/+RhzvkmMeLXKWEFOoPGGUGu2ZFrlr+GX73ZAd+QfBwujmPgvRwIQ4PoJZWDSgNbpRYlB1u3WDVHOoNqYhF1tlKyzDLwhwlqCQwwOXDN4SjAyg7trRFHOveZg8ud2Pr2vkbhV2cJnpNd83IkGhz25jcK9zaW+E5m6eME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B69B143D;
	Fri, 16 Aug 2024 02:23:15 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF7CE3F58B;
	Fri, 16 Aug 2024 02:22:46 -0700 (PDT)
Date: Fri, 16 Aug 2024 10:22:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: Re: [PATCH v3 14/18] KVM: arm64: nv: Add SW walker for AT S1
 emulation
Message-ID: <Zr8aYymB_2xSqIQp@raptor>
References: <20240813100540.1955263-1-maz@kernel.org>
 <20240813100540.1955263-15-maz@kernel.org>
 <Zr4wUj5mpKkwMyCq@raptor>
 <86msldzlly.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86msldzlly.wl-maz@kernel.org>

Hi Marc,

On Thu, Aug 15, 2024 at 07:28:41PM +0100, Marc Zyngier wrote:
> 
> Hi Alex,
> 
> On Thu, 15 Aug 2024 17:44:02 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> [..]
> 
> > > +static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
> > > +			 struct s1_walk_result *wr, u64 va)
> > > +{
> > > +	u64 sctlr, tcr, tg, ps, ia_bits, ttbr;
> > > +	unsigned int stride, x;
> > > +	bool va55, tbi, lva, as_el0;
> > > +
> > > +	wi->regime = compute_translation_regime(vcpu, op);
> > > +	as_el0 = (op == OP_AT_S1E0R || op == OP_AT_S1E0W);
> > > +
> > > +	va55 = va & BIT(55);
> > > +
> > > +	if (wi->regime == TR_EL2 && va55)
> > > +		goto addrsz;
> > > +
> > > +	wi->s2 = (wi->regime == TR_EL10 &&
> > > +		  (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)));
> > 
> > This could be written on one line if there were a local variable for the HCR_EL2
> > register (which is already read multiple times in the function).
> 
> Sure thing.
> 
> [...]
> 
> > > +	/* Let's put the MMU disabled case aside immediately */
> > > +	switch (wi->regime) {
> > > +	case TR_EL10:
> > > +		/*
> > > +		 * If dealing with the EL1&0 translation regime, 3 things
> > > +		 * can disable the S1 translation:
> > > +		 *
> > > +		 * - HCR_EL2.DC = 1
> > > +		 * - HCR_EL2.{E2H,TGE} = {0,1}
> > > +		 * - SCTLR_EL1.M = 0
> > > +		 *
> > > +		 * The TGE part is interesting. If we have decided that this
> > > +		 * is EL1&0, then it means that either {E2H,TGE} == {1,0} or
> > > +		 * {0,x}, and we only need to test for TGE == 1.
> > > +		 */
> > > +		if (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_DC | HCR_TGE))
> > > +			wr->level = S1_MMU_DISABLED;
> > 
> > There's no need to fallthrough and check SCTLR_ELx.M if the MMU disabled check
> > here is true.
> 
> I'm not sure it makes the code more readable. But if you do, why not.
> 
> [...]
> 
> > > +	/* Someone was silly enough to encode TG0/TG1 differently */
> > > +	if (va55) {
> > > +		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
> > > +		tg = FIELD_GET(TCR_TG1_MASK, tcr);
> > > +
> > > +		switch (tg << TCR_TG1_SHIFT) {
> > > +		case TCR_TG1_4K:
> > > +			wi->pgshift = 12;	 break;
> > > +		case TCR_TG1_16K:
> > > +			wi->pgshift = 14;	 break;
> > > +		case TCR_TG1_64K:
> > > +		default:	    /* IMPDEF: treat any other value as 64k */
> > > +			wi->pgshift = 16;	 break;
> > > +		}
> > 
> > Just a thought, wi->pgshift is used in several places to identify the guest page
> > size, might be useful to have something like PAGE_SHIFT_{4K,16K,64K}. That would
> > also make its usage consistent, because in some places wi->pgshift is compared
> > directly to 12, 14 or 16, in other places the page size is computed from
> > wi->pgshift and compared to SZ_4K, SZ_16K or SZ_64K.
> 
> I only found a single place where we compare wi->pgshift to a
> non-symbolic integer (as part of the R_YXNYW handling). Everywhere
> else, we use BIT(wi->pgshift) and compare it to SZ_*K. We moved away
> from the various PAGE_SHIFT_* macros some years ago, and I don't think
> we want them back.

Oh, I wasn't aware of that bit of history. No need to change the current code
then, it's readable enough.

> 
> What I can do is to convert the places where we init pgshift to use an
> explicit size using const_ilog2():
> 
> @@ -185,12 +188,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  
>  		switch (tg << TCR_TG1_SHIFT) {
>  		case TCR_TG1_4K:
> -			wi->pgshift = 12;	 break;
> +			wi->pgshift = const_ilog2(SZ_4K);	 break;
>  		case TCR_TG1_16K:
> -			wi->pgshift = 14;	 break;
> +			wi->pgshift = const_ilog2(SZ_16K);	 break;
>  		case TCR_TG1_64K:
>  		default:	    /* IMPDEF: treat any other value as 64k */
> -			wi->pgshift = 16;	 break;
> +			wi->pgshift = const_ilog2(SZ_64K);	 break;
>  		}
>  	} else {
>  		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
> @@ -198,12 +201,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  
>  		switch (tg << TCR_TG0_SHIFT) {
>  		case TCR_TG0_4K:
> -			wi->pgshift = 12;	 break;
> +			wi->pgshift = const_ilog2(SZ_4K);	 break;
>  		case TCR_TG0_16K:
> -			wi->pgshift = 14;	 break;
> +			wi->pgshift = const_ilog2(SZ_16K);	 break;
>  		case TCR_TG0_64K:
>  		default:	    /* IMPDEF: treat any other value as 64k */
> -			wi->pgshift = 16;	 break;
> +			wi->pgshift = const_ilog2(SZ_64K);	 break;
>  		}
>  	}
>  
> @@ -212,7 +215,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  		if (wi->txsz > 39)
>  			goto transfault_l0;
>  	} else {
> -		if (wi->txsz > 48 || (wi->pgshift == 16 && wi->txsz > 47))
> +		if (wi->txsz > 48 || (BIT(wi->pgshift) == SZ_64K && wi->txsz > 47))
>  			goto transfault_l0;
>  	}
> 
> 
> > 
> > > +	} else {
> > > +		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
> > > +		tg = FIELD_GET(TCR_TG0_MASK, tcr);
> > > +
> > > +		switch (tg << TCR_TG0_SHIFT) {
> > > +		case TCR_TG0_4K:
> > > +			wi->pgshift = 12;	 break;
> > > +		case TCR_TG0_16K:
> > > +			wi->pgshift = 14;	 break;
> > > +		case TCR_TG0_64K:
> > > +		default:	    /* IMPDEF: treat any other value as 64k */
> > > +			wi->pgshift = 16;	 break;
> > > +		}
> > > +	}
> > > +
> > > +	/* R_PLCGL, R_YXNYW */
> > > +	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47)) {
> > > +		if (wi->txsz > 39)
> > > +			goto transfault_l0;
> > > +	} else {
> > > +		if (wi->txsz > 48 || (wi->pgshift == 16 && wi->txsz > 47))
> > > +			goto transfault_l0;
> > > +	}
> > > +
> > > +	/* R_GTJBY, R_SXWGM */
> > > +	switch (BIT(wi->pgshift)) {
> > > +	case SZ_4K:
> > > +		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT);
> > > +		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
> > > +		break;
> > > +	case SZ_16K:
> > > +		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT);
> > > +		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
> > > +		break;
> > > +	case SZ_64K:
> > > +		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, VARange, 52);
> > > +		break;
> > > +	}
> > > +
> > > +	if ((lva && wi->txsz < 12) || wi->txsz < 16)
> > > +		goto transfault_l0;
> > 
> > Let's assume lva = true, wi->txsz greater than 12, but smaller than 16, which is
> > architecturally allowed according to R_GTJBY and AArch64.S1MinTxSZ().
> > 
> > (lva && wi->txsz < 12) = false
> > wi->txsz < 16 = true
> > 
> > KVM treats it as a fault.
> 
> Gah... Fixed with:
> 
> @@ -231,7 +234,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  		break;
>  	}
>  
> -	if ((lva && wi->txsz < 12) || wi->txsz < 16)
> +	if ((lva && wi->txsz < 12) || (!lva && wi->txsz < 16))
>  		goto transfault_l0;
>  
>  	ia_bits = get_ia_size(wi);
> 
> Not that it has an impact yet, given that we don't support any of the
> 52bit stuff yet, but thanks for spotting this!

The change looks correct to me.

> 
> [...]
> 
> > > +	/* R_VPBBF */
> > > +	if (check_output_size(wi->baddr, wi))
> > > +		goto transfault_l0;
> > 
> > I think R_VPBBF says that an Address size fault is generated here, not a
> > translation fault.
> 
> Indeed, another one fixed.
> 
> > 
> > > +
> > > +	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
> > > +
> > > +	return 0;
> > > +
> > > +addrsz:				/* Address Size Fault level 0 */
> > > +	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(0), false, false);
> > > +	return -EFAULT;
> > > +
> > > +transfault_l0:			/* Translation Fault level 0 */
> > > +	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(0), false, false);
> > > +	return -EFAULT;
> > > +}
> > 
> > [..]
> > 
> > > +static bool par_check_s1_perm_fault(u64 par)
> > > +{
> > > +	u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> > > +
> > > +	return  ((fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM &&
> > > +		 !(par & SYS_PAR_EL1_S));
> > 
> > ESR_ELx_FSC_PERM = 0x0c is a permission fault, level 0, which Arm ARM says can
> > only happen when FEAT_LPA2. I think the code should check that the value for
> > PAR_EL1.FST is in the interval (ESR_ELx_FSC_PERM_L(0), ESR_ELx_FSC_PERM_L(3)].
> 
> I honestly don't want to second-guess the HW. If it reports something
> that is the wrong level, why should we trust the FSC at all?

Sorry, I should have been clearer.

It's not about the hardware reporting a fault on level 0 of the translation
tables, it's about the function returning false if the hardware reports a
permission fault on levels 1, 2 or 3 of the translation tables.

For example, on a permssion fault on level 3, PAR_EL1. FST = 0b001111 = 0x0F,
which means that the condition:

(fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM (which is 0x0C) is false and KVM
will fall back to the software walker.

Does that make sense to you?

Thanks,
Alex

