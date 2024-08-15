Return-Path: <kvm+bounces-24312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66A9595387D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88DFD1C20CF4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50B71BA86F;
	Thu, 15 Aug 2024 16:44:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8783E1B9B57
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723740251; cv=none; b=pyWwlmf6Zn73O6+t8rMov0iGsjjELTXZ07S6Ns6a5TX61X1IZUf0FRM65PC9hsKyeZ4/j8Yd/EfXmc3jOXi9wQ6ajh6k633E7a5VWCsC2VwOcwLtOUZkSfLElH06eDA32072VG97jYSgJTh530uJ8cBa06CjVCPrbS/4vYsJxaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723740251; c=relaxed/simple;
	bh=EOFWgsSo+wF/rLte8Ffy1d6rJFb6vDlFBhKywhtfso0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q024GzKSxBnoLvC/z3bxWj0QYBIqEEZ5BNbq4yJ2RLMQw6/K0oI7hsmZQqVOwZOODvqgaCLvLLi4IeWwWC0JIeXhOZ9CknrelR+8+iYw2fsCpep/pg+L1dtJR4qP5JLdNvhd1zC6MjJMR8GhZvCzN2yZRBcvHw++oPG13jd2LJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA3D114BF;
	Thu, 15 Aug 2024 09:44:33 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76EE03F6A8;
	Thu, 15 Aug 2024 09:44:05 -0700 (PDT)
Date: Thu, 15 Aug 2024 17:44:02 +0100
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
Message-ID: <Zr4wUj5mpKkwMyCq@raptor>
References: <20240813100540.1955263-1-maz@kernel.org>
 <20240813100540.1955263-15-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813100540.1955263-15-maz@kernel.org>

Hi Marc,

On Tue, Aug 13, 2024 at 11:05:36AM +0100, Marc Zyngier wrote:
> In order to plug the brokenness of our current AT implementation,
> we need a SW walker that is going to... err.. walk the S1 tables
> and tell us what it finds.
> 
> Of course, it builds on top of our S2 walker, and share similar
> concepts. The beauty of it is that since it uses kvm_read_guest(),
> it is able to bring back pages that have been otherwise evicted.
> 
> This is then plugged in the two AT S1 emulation functions as
> a "slow path" fallback. I'm not sure it is that slow, but hey.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 607 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 605 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 9865d29b3149..6d5555e98557 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -4,9 +4,405 @@
>   * Author: Jintack Lim <jintack.lim@linaro.org>
>   */
>  
> +#include <linux/kvm_host.h>
> +
> +#include <asm/esr.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> +enum trans_regime {
> +	TR_EL10,
> +	TR_EL20,
> +	TR_EL2,
> +};
> +
> +struct s1_walk_info {
> +	u64	     		baddr;
> +	enum trans_regime	regime;
> +	unsigned int		max_oa_bits;
> +	unsigned int		pgshift;
> +	unsigned int		txsz;
> +	int 	     		sl;
> +	bool	     		hpd;
> +	bool	     		be;
> +	bool	     		s2;
> +};
> +
> +struct s1_walk_result {
> +	union {
> +		struct {
> +			u64	desc;
> +			u64	pa;
> +			s8	level;
> +			u8	APTable;
> +			bool	UXNTable;
> +			bool	PXNTable;
> +		};
> +		struct {
> +			u8	fst;
> +			bool	ptw;
> +			bool	s2;
> +		};
> +	};
> +	bool	failed;
> +};
> +
> +static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
> +{
> +	wr->fst		= fst;
> +	wr->ptw		= ptw;
> +	wr->s2		= s2;
> +	wr->failed	= true;
> +}
> +
> +#define S1_MMU_DISABLED		(-127)
> +
> +static int get_ia_size(struct s1_walk_info *wi)
> +{
> +	return 64 - wi->txsz;
> +}
> +
> +/* Return true if the IPA is out of the OA range */
> +static bool check_output_size(u64 ipa, struct s1_walk_info *wi)
> +{
> +	return wi->max_oa_bits < 48 && (ipa & GENMASK_ULL(47, wi->max_oa_bits));
> +}
> +
> +/* Return the translation regime that applies to an AT instruction */
> +static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 op)
> +{
> +	/*
> +	 * We only get here from guest EL2, so the translation
> +	 * regime AT applies to is solely defined by {E2H,TGE}.
> +	 */
> +	switch (op) {
> +	case OP_AT_S1E2R:
> +	case OP_AT_S1E2W:
> +		return vcpu_el2_e2h_is_set(vcpu) ? TR_EL20 : TR_EL2;
> +		break;
> +	default:
> +		return (vcpu_el2_e2h_is_set(vcpu) &&
> +			vcpu_el2_tge_is_set(vcpu)) ? TR_EL20 : TR_EL10;
> +	}
> +}
> +
> +static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
> +			 struct s1_walk_result *wr, u64 va)
> +{
> +	u64 sctlr, tcr, tg, ps, ia_bits, ttbr;
> +	unsigned int stride, x;
> +	bool va55, tbi, lva, as_el0;
> +
> +	wi->regime = compute_translation_regime(vcpu, op);
> +	as_el0 = (op == OP_AT_S1E0R || op == OP_AT_S1E0W);
> +
> +	va55 = va & BIT(55);
> +
> +	if (wi->regime == TR_EL2 && va55)
> +		goto addrsz;
> +
> +	wi->s2 = (wi->regime == TR_EL10 &&
> +		  (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)));

This could be written on one line if there were a local variable for the HCR_EL2
register (which is already read multiple times in the function).

> +
> +	switch (wi->regime) {
> +	case TR_EL10:
> +		sctlr	= vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		tcr	= vcpu_read_sys_reg(vcpu, TCR_EL1);
> +		ttbr	= (va55 ?
> +			   vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
> +			   vcpu_read_sys_reg(vcpu, TTBR0_EL1));
> +		break;
> +	case TR_EL2:
> +	case TR_EL20:
> +		sctlr	= vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +		tcr	= vcpu_read_sys_reg(vcpu, TCR_EL2);
> +		ttbr	= (va55 ?
> +			   vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
> +			   vcpu_read_sys_reg(vcpu, TTBR0_EL2));
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	tbi = (wi->regime == TR_EL2 ?
> +	       FIELD_GET(TCR_EL2_TBI, tcr) :
> +	       (va55 ?
> +		FIELD_GET(TCR_TBI1, tcr) :
> +		FIELD_GET(TCR_TBI0, tcr)));
> +
> +	if (!tbi && (u64)sign_extend64(va, 55) != va)
> +		goto addrsz;
> +
> +	va = (u64)sign_extend64(va, 55);
> +
> +	/* Let's put the MMU disabled case aside immediately */
> +	switch (wi->regime) {
> +	case TR_EL10:
> +		/*
> +		 * If dealing with the EL1&0 translation regime, 3 things
> +		 * can disable the S1 translation:
> +		 *
> +		 * - HCR_EL2.DC = 1
> +		 * - HCR_EL2.{E2H,TGE} = {0,1}
> +		 * - SCTLR_EL1.M = 0
> +		 *
> +		 * The TGE part is interesting. If we have decided that this
> +		 * is EL1&0, then it means that either {E2H,TGE} == {1,0} or
> +		 * {0,x}, and we only need to test for TGE == 1.
> +		 */
> +		if (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_DC | HCR_TGE))
> +			wr->level = S1_MMU_DISABLED;

There's no need to fallthrough and check SCTLR_ELx.M if the MMU disabled check
here is true.

> +		fallthrough;
> +	case TR_EL2:
> +	case TR_EL20:
> +		if (!(sctlr & SCTLR_ELx_M))
> +			wr->level = S1_MMU_DISABLED;
> +		break;
> +	}
> +
> +	if (wr->level == S1_MMU_DISABLED) {
> +		if (va >= BIT(kvm_get_pa_bits(vcpu->kvm)))
> +			goto addrsz;
> +
> +		wr->pa = va;
> +		return 0;
> +	}
> +
> +	wi->be = sctlr & SCTLR_ELx_EE;
> +
> +	wi->hpd  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HPDS, IMP);
> +	wi->hpd &= (wi->regime == TR_EL2 ?
> +		    FIELD_GET(TCR_EL2_HPD, tcr) :
> +		    (va55 ?
> +		     FIELD_GET(TCR_HPD1, tcr) :
> +		     FIELD_GET(TCR_HPD0, tcr)));
> +
> +	/* Someone was silly enough to encode TG0/TG1 differently */
> +	if (va55) {
> +		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
> +		tg = FIELD_GET(TCR_TG1_MASK, tcr);
> +
> +		switch (tg << TCR_TG1_SHIFT) {
> +		case TCR_TG1_4K:
> +			wi->pgshift = 12;	 break;
> +		case TCR_TG1_16K:
> +			wi->pgshift = 14;	 break;
> +		case TCR_TG1_64K:
> +		default:	    /* IMPDEF: treat any other value as 64k */
> +			wi->pgshift = 16;	 break;
> +		}

Just a thought, wi->pgshift is used in several places to identify the guest page
size, might be useful to have something like PAGE_SHIFT_{4K,16K,64K}. That would
also make its usage consistent, because in some places wi->pgshift is compared
directly to 12, 14 or 16, in other places the page size is computed from
wi->pgshift and compared to SZ_4K, SZ_16K or SZ_64K.

> +	} else {
> +		wi->txsz = FIELD_GET(TCR_T0SZ_MASK, tcr);
> +		tg = FIELD_GET(TCR_TG0_MASK, tcr);
> +
> +		switch (tg << TCR_TG0_SHIFT) {
> +		case TCR_TG0_4K:
> +			wi->pgshift = 12;	 break;
> +		case TCR_TG0_16K:
> +			wi->pgshift = 14;	 break;
> +		case TCR_TG0_64K:
> +		default:	    /* IMPDEF: treat any other value as 64k */
> +			wi->pgshift = 16;	 break;
> +		}
> +	}
> +
> +	/* R_PLCGL, R_YXNYW */
> +	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47)) {
> +		if (wi->txsz > 39)
> +			goto transfault_l0;
> +	} else {
> +		if (wi->txsz > 48 || (wi->pgshift == 16 && wi->txsz > 47))
> +			goto transfault_l0;
> +	}
> +
> +	/* R_GTJBY, R_SXWGM */
> +	switch (BIT(wi->pgshift)) {
> +	case SZ_4K:
> +		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT);
> +		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
> +		break;
> +	case SZ_16K:
> +		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT);
> +		lva &= tcr & (wi->regime == TR_EL2 ? TCR_EL2_DS : TCR_DS);
> +		break;
> +	case SZ_64K:
> +		lva = kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, VARange, 52);
> +		break;
> +	}
> +
> +	if ((lva && wi->txsz < 12) || wi->txsz < 16)
> +		goto transfault_l0;

Let's assume lva = true, wi->txsz greater than 12, but smaller than 16, which is
architecturally allowed according to R_GTJBY and AArch64.S1MinTxSZ().

(lva && wi->txsz < 12) = false
wi->txsz < 16 = true

KVM treats it as a fault.

> +
> +	ia_bits = get_ia_size(wi);
> +
> +	/* R_YYVYV, I_THCZK */
> +	if ((!va55 && va > GENMASK(ia_bits - 1, 0)) ||
> +	    (va55 && va < GENMASK(63, ia_bits)))
> +		goto transfault_l0;
> +
> +	/* I_ZFSYQ */
> +	if (wi->regime != TR_EL2 &&
> +	    (tcr & ((va55) ? TCR_EPD1_MASK : TCR_EPD0_MASK)))
> +		goto transfault_l0;

Extra paranthesis around va55?

> +
> +	/* R_BNDVG and following statements */
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, E0PD, IMP) &&
> +	    as_el0 && (tcr & ((va55) ? TCR_E0PD1 : TCR_E0PD0)))
> +		goto transfault_l0;

Same here with the extra paranthesis around va55.

> +
> +	/* AArch64.S1StartLevel() */
> +	stride = wi->pgshift - 3;
> +	wi->sl = 3 - (((ia_bits - 1) - wi->pgshift) / stride);
> +
> +	ps = (wi->regime == TR_EL2 ?
> +	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_IPS_MASK, tcr));
> +
> +	wi->max_oa_bits = min(get_kvm_ipa_limit(), ps_to_output_size(ps));
> +
> +	/* Compute minimal alignment */
> +	x = 3 + ia_bits - ((3 - wi->sl) * stride + wi->pgshift);
> +
> +	wi->baddr = ttbr & TTBRx_EL1_BADDR;
> +
> +	/* R_VPBBF */
> +	if (check_output_size(wi->baddr, wi))
> +		goto transfault_l0;

I think R_VPBBF says that an Address size fault is generated here, not a
translation fault.

> +
> +	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
> +
> +	return 0;
> +
> +addrsz:				/* Address Size Fault level 0 */
> +	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(0), false, false);
> +	return -EFAULT;
> +
> +transfault_l0:			/* Translation Fault level 0 */
> +	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(0), false, false);
> +	return -EFAULT;
> +}

[..]

> +static bool par_check_s1_perm_fault(u64 par)
> +{
> +	u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> +
> +	return  ((fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM &&
> +		 !(par & SYS_PAR_EL1_S));

ESR_ELx_FSC_PERM = 0x0c is a permission fault, level 0, which Arm ARM says can
only happen when FEAT_LPA2. I think the code should check that the value for
PAR_EL1.FST is in the interval (ESR_ELx_FSC_PERM_L(0), ESR_ELx_FSC_PERM_L(3)].

With the remaining minor issues fixed:

Reviewed-by: Alexandru Elisei <alexandru.elisei@Arm.com>

Thanks,
Alex

> +}
> +
>  void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  {
>  	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
>  
> +	/*
> +	 * If PAR_EL1 reports that AT failed on a S1 permission fault, we
> +	 * know for sure that the PTW was able to walk the S1 tables and
> +	 * there's nothing else to do.
> +	 *
> +	 * If AT failed for any other reason, then we must walk the guest S1
> +	 * to emulate the instruction.
> +	 */
> +	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
> +		par = handle_at_slow(vcpu, op, vaddr);
> +
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
>  }
>  
> @@ -407,6 +1006,10 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  		isb();
>  	}
>  
> +	/* We failed the translation, let's replay it in slow motion */
> +	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
> +		par = handle_at_slow(vcpu, op, vaddr);
> +
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
>  }
>  
> @@ -463,7 +1066,7 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	/* Check the access permission */
>  	if (!out.esr &&
>  	    ((!write && !out.readable) || (write && !out.writable)))
> -		out.esr = ESR_ELx_FSC_PERM | (out.level & 0x3);
> +		out.esr = ESR_ELx_FSC_PERM_L(out.level & 0x3);
>  
>  	par = compute_par_s12(vcpu, par, &out);
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
> -- 
> 2.39.2
> 

