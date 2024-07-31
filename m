Return-Path: <kvm+bounces-22767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6439B943211
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 16:33:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4D72810E9
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 14:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C4F1BBBC5;
	Wed, 31 Jul 2024 14:33:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41271AE85E
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722436413; cv=none; b=lBi6LlbxtTrXfBd0Jpg7A5ATApQNwmLlSDTK8dvjum2qvPuYmmFMpd9qP7zDYw+3qG320PYNLS+p0TLsBAMQmMpzRN0oESUTEG5T45vG/NFH7c0RJY8Cj8x9zzPJANRUNu+xFAvbaudCI1EKMgAbZdKx76DzCjrwFzyIx2GEo+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722436413; c=relaxed/simple;
	bh=dINS3B7KJu5+HgRt1UzRxa93VFVtmznSckCKxIyWCS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7sgK+y6rCIGtshGYb78ot84jn8aCpujiJV1a1ytdc7pxa1Knc4SXWyw2N3mKDOgNr1OI0zg3apcIRAWJ5h+tc27QPGAYBcw8f+8AsrMlWNCKvNNwrpnUtlLpfDEW62j81IPUaetdmrAnMkcl7wXXy6Z2w21tqytGiPJ9XJGX4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDE211007;
	Wed, 31 Jul 2024 07:33:55 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F31F3F5A1;
	Wed, 31 Jul 2024 07:33:28 -0700 (PDT)
Date: Wed, 31 Jul 2024 15:33:25 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 10/12] KVM: arm64: nv: Add SW walker for AT S1 emulation
Message-ID: <ZqpLNT8bVFDB6oWJ@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240708165800.1220065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708165800.1220065-1-maz@kernel.org>

Hi Marc,

On Mon, Jul 08, 2024 at 05:57:58PM +0100, Marc Zyngier wrote:
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
>  arch/arm64/kvm/at.c | 538 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 520 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 71e3390b43b4c..8452273cbff6d 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -4,9 +4,305 @@
>   * Author: Jintack Lim <jintack.lim@linaro.org>
>   */
>  
> +#include <linux/kvm_host.h>
> +
> +#include <asm/esr.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> +struct s1_walk_info {
> +	u64	     baddr;
> +	unsigned int max_oa_bits;
> +	unsigned int pgshift;
> +	unsigned int txsz;
> +	int 	     sl;
> +	bool	     hpd;
> +	bool	     be;
> +	bool	     nvhe;
> +	bool	     s2;
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
> +static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> +			 struct s1_walk_result *wr, const u64 va, const int el)
> +{
> +	u64 sctlr, tcr, tg, ps, ia_bits, ttbr;
> +	unsigned int stride, x;
> +	bool va55, tbi;
> +
> +	wi->nvhe = el == 2 && !vcpu_el2_e2h_is_set(vcpu);
> +
> +	va55 = va & BIT(55);
> +
> +	if (wi->nvhe && va55)
> +		goto addrsz;
> +
> +	wi->s2 = el < 2 && (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_VM);
> +
> +	switch (el) {
> +	case 1:
> +		sctlr	= vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		tcr	= vcpu_read_sys_reg(vcpu, TCR_EL1);
> +		ttbr	= (va55 ?
> +			   vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
> +			   vcpu_read_sys_reg(vcpu, TTBR0_EL1));
> +		break;
> +	case 2:
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
> +	/* Let's put the MMU disabled case aside immediately */
> +	if (!(sctlr & SCTLR_ELx_M) ||
> +	    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> +		if (va >= BIT(kvm_get_pa_bits(vcpu->kvm)))

As far as I can tell, if TBI, the pseudocode ignores bits 63:56 when checking
for out-of-bounds VA for the MMU disabled case (above) and the MMU enabled case
(below). That also matches the description of TBIx bits in the TCR_ELx
registers.

Thanks,
Alex

> +			goto addrsz;
> +
> +		wr->level = S1_MMU_DISABLED;
> +		wr->desc = va;
> +		return 0;
> +	}
> +
> +	wi->be = sctlr & SCTLR_ELx_EE;
> +
> +	wi->hpd  = kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HPDS, IMP);
> +	wi->hpd &= (wi->nvhe ?
> +		    FIELD_GET(TCR_EL2_HPD, tcr) :
> +		    (va55 ?
> +		     FIELD_GET(TCR_HPD1, tcr) :
> +		     FIELD_GET(TCR_HPD0, tcr)));
> +
> +	tbi = (wi->nvhe ?
> +	       FIELD_GET(TCR_EL2_TBI, tcr) :
> +	       (va55 ?
> +		FIELD_GET(TCR_TBI1, tcr) :
> +		FIELD_GET(TCR_TBI0, tcr)));
> +
> +	if (!tbi && sign_extend64(va, 55) != (s64)va)
> +		goto addrsz;
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
> +	ia_bits = 64 - wi->txsz;
> +
> +	/* AArch64.S1StartLevel() */
> +	stride = wi->pgshift - 3;
> +	wi->sl = 3 - (((ia_bits - 1) - wi->pgshift) / stride);
> +
> +	/* Check for SL mandating LPA2 (which we don't support yet) */
> +	switch (BIT(wi->pgshift)) {
> +	case SZ_4K:
> +		if (wi->sl == -1 &&
> +		    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT))
> +			goto addrsz;
> +		break;
> +	case SZ_16K:
> +		if (wi->sl == 0 &&
> +		    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT))
> +			goto addrsz;
> +		break;
> +	}
> +
> +	ps = (wi->nvhe ?
> +	      FIELD_GET(TCR_EL2_PS_MASK, tcr) : FIELD_GET(TCR_IPS_MASK, tcr));
> +
> +	wi->max_oa_bits = min(get_kvm_ipa_limit(), ps_to_output_size(ps));
> +
> +	/* Compute minimal alignment */
> +	x = 3 + ia_bits - ((3 - wi->sl) * stride + wi->pgshift);
> +
> +	wi->baddr = ttbr & TTBRx_EL1_BADDR;
> +	wi->baddr &= GENMASK_ULL(wi->max_oa_bits - 1, x);
> +
> +	return 0;
> +
> +addrsz:	/* Address Size Fault level 0 */
> +	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ, false, false);
> +
> +	return -EFAULT;
> +}
> +
> +static int get_ia_size(struct s1_walk_info *wi)
> +{
> +	return 64 - wi->txsz;
> +}
> +
> +static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
> +		   struct s1_walk_result *wr, u64 va)
> +{
> +	u64 va_top, va_bottom, baddr, desc;
> +	int level, stride, ret;
> +
> +	level = wi->sl;
> +	stride = wi->pgshift - 3;
> +	baddr = wi->baddr;
> +
> +	va_top = get_ia_size(wi) - 1;
> +
> +	while (1) {
> +		u64 index, ipa;
> +
> +		va_bottom = (3 - level) * stride + wi->pgshift;
> +		index = (va & GENMASK_ULL(va_top, va_bottom)) >> (va_bottom - 3);
> +
> +		ipa = baddr | index;
> +
> +		if (wi->s2) {
> +			struct kvm_s2_trans s2_trans = {};
> +
> +			ret = kvm_walk_nested_s2(vcpu, ipa, &s2_trans);
> +			if (ret) {
> +				fail_s1_walk(wr,
> +					     (s2_trans.esr & ~ESR_ELx_FSC_LEVEL) | level,
> +					     true, true);
> +				return ret;
> +			}
> +
> +			if (!kvm_s2_trans_readable(&s2_trans)) {
> +				fail_s1_walk(wr, ESR_ELx_FSC_PERM | level,
> +					     true, true);
> +
> +				return -EPERM;
> +			}
> +
> +			ipa = kvm_s2_trans_output(&s2_trans);
> +		}
> +
> +		ret = kvm_read_guest(vcpu->kvm, ipa, &desc, sizeof(desc));
> +		if (ret) {
> +			fail_s1_walk(wr, ESR_ELx_FSC_SEA_TTW(level),
> +				     true, false);
> +			return ret;
> +		}
> +
> +		if (wi->be)
> +			desc = be64_to_cpu((__force __be64)desc);
> +		else
> +			desc = le64_to_cpu((__force __le64)desc);
> +
> +		if (!(desc & 1) || ((desc & 3) == 1 && level == 3)) {
> +			fail_s1_walk(wr, ESR_ELx_FSC_FAULT | level,
> +				     true, false);
> +			return -ENOENT;
> +		}
> +
> +		/* We found a leaf, handle that */
> +		if ((desc & 3) == 1 || level == 3)
> +			break;
> +
> +		if (!wi->hpd) {
> +			wr->APTable  |= FIELD_GET(PMD_TABLE_AP, desc);
> +			wr->UXNTable |= FIELD_GET(PMD_TABLE_UXN, desc);
> +			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, desc);
> +		}
> +
> +		baddr = GENMASK_ULL(47, wi->pgshift);
> +
> +		/* Check for out-of-range OA */
> +		if (wi->max_oa_bits < 48 &&
> +		    (baddr & GENMASK_ULL(47, wi->max_oa_bits))) {
> +			fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ | level,
> +				     true, false);
> +			return -EINVAL;
> +		}
> +
> +		/* Prepare for next round */
> +		va_top = va_bottom - 1;
> +		level++;
> +	}
> +
> +	/* Block mapping, check the validity of the level */
> +	if (!(desc & BIT(1))) {
> +		bool valid_block = false;
> +
> +		switch (BIT(wi->pgshift)) {
> +		case SZ_4K:
> +			valid_block = level == 1 || level == 2;
> +			break;
> +		case SZ_16K:
> +		case SZ_64K:
> +			valid_block = level == 2;
> +			break;
> +		}
> +
> +		if (!valid_block) {
> +			fail_s1_walk(wr, ESR_ELx_FSC_FAULT | level,
> +				     true, false);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	wr->failed = false;
> +	wr->level = level;
> +	wr->desc = desc;
> +	wr->pa = desc & GENMASK(47, va_bottom);
> +	if (va_bottom > 12)
> +		wr->pa |= va & GENMASK_ULL(va_bottom - 1, 12);
> +
> +	return 0;
> +}
> +
>  struct mmu_config {
>  	u64	ttbr0;
>  	u64	ttbr1;
> @@ -234,6 +530,177 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
>  	return par;
>  }
>  
> +static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr)
> +{
> +	u64 par;
> +
> +	if (wr->failed) {
> +		par = SYS_PAR_EL1_RES1;
> +		par |= SYS_PAR_EL1_F;
> +		par |= FIELD_PREP(SYS_PAR_EL1_FST, wr->fst);
> +		par |= wr->ptw ? SYS_PAR_EL1_PTW : 0;
> +		par |= wr->s2 ? SYS_PAR_EL1_S : 0;
> +	} else if (wr->level == S1_MMU_DISABLED) {
> +		/* MMU off or HCR_EL2.DC == 1 */
> +		par = wr->pa & GENMASK_ULL(47, 12);
> +
> +		if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> +			par |= FIELD_PREP(SYS_PAR_EL1_ATTR, 0); /* nGnRnE */
> +			par |= FIELD_PREP(SYS_PAR_EL1_SH, 0b10); /* OS */
> +		} else {
> +			par |= FIELD_PREP(SYS_PAR_EL1_ATTR,
> +					  MEMATTR(WbRaWa, WbRaWa));
> +			par |= FIELD_PREP(SYS_PAR_EL1_SH, 0b00); /* NS */
> +		}
> +	} else {
> +		u64 mair, sctlr;
> +		int el;
> +		u8 sh;
> +
> +		el = (vcpu_el2_e2h_is_set(vcpu) &&
> +		      vcpu_el2_tge_is_set(vcpu)) ? 2 : 1;
> +
> +		mair = ((el == 2) ?
> +			vcpu_read_sys_reg(vcpu, MAIR_EL2) :
> +			vcpu_read_sys_reg(vcpu, MAIR_EL1));
> +
> +		mair >>= FIELD_GET(PTE_ATTRINDX_MASK, wr->desc) * 8;
> +		mair &= 0xff;
> +
> +		sctlr = ((el == 2) ?
> +			vcpu_read_sys_reg(vcpu, SCTLR_EL2) :
> +			vcpu_read_sys_reg(vcpu, SCTLR_EL1));
> +
> +		/* Force NC for memory if SCTLR_ELx.C is clear */
> +		if (!(sctlr & SCTLR_EL1_C) && !MEMATTR_IS_DEVICE(mair))
> +			mair = MEMATTR(NC, NC);
> +
> +		par  = FIELD_PREP(SYS_PAR_EL1_ATTR, mair);
> +		par |= wr->pa & GENMASK_ULL(47, 12);
> +
> +		sh = compute_sh(mair, wr->desc);
> +		par |= FIELD_PREP(SYS_PAR_EL1_SH, sh);
> +	}
> +
> +	return par;
> +}
> +
> +static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +{
> +	bool perm_fail, ur, uw, ux, pr, pw, pan;
> +	struct s1_walk_result wr = {};
> +	struct s1_walk_info wi = {};
> +	int ret, idx, el;
> +
> +	/*
> +	 * We only get here from guest EL2, so the translation regime
> +	 * AT applies to is solely defined by {E2H,TGE}.
> +	 */
> +	el = (vcpu_el2_e2h_is_set(vcpu) &&
> +	      vcpu_el2_tge_is_set(vcpu)) ? 2 : 1;
> +
> +	ret = setup_s1_walk(vcpu, &wi, &wr, vaddr, el);
> +	if (ret)
> +		goto compute_par;
> +
> +	if (wr.level == S1_MMU_DISABLED)
> +		goto compute_par;
> +
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +	ret = walk_s1(vcpu, &wi, &wr, vaddr);
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +
> +	if (ret)
> +		goto compute_par;
> +
> +	/* FIXME: revisit when adding indirect permission support */
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3) &&
> +	    !wi.nvhe) {
> +		u64 sctlr;
> +
> +		if (el == 1)
> +			sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +		else
> +			sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> +
> +		ux = (sctlr & SCTLR_EL1_EPAN) && !(wr.desc & PTE_UXN);
> +	} else {
> +		ux = false;
> +	}
> +
> +	pw = !(wr.desc & PTE_RDONLY);
> +
> +	if (wi.nvhe) {
> +		ur = uw = false;
> +		pr = true;
> +	} else {
> +		if (wr.desc & PTE_USER) {
> +			ur = pr = true;
> +			uw = pw;
> +		} else {
> +			ur = uw = false;
> +			pr = true;
> +		}
> +	}
> +
> +	/* Apply the Hierarchical Permission madness */
> +	if (wi.nvhe) {
> +		wr.APTable &= BIT(1);
> +		wr.PXNTable = wr.UXNTable;
> +	}
> +
> +	ur &= !(wr.APTable & BIT(0));
> +	uw &= !(wr.APTable != 0);
> +	ux &= !wr.UXNTable;
> +
> +	pw &= !(wr.APTable & BIT(1));
> +
> +	pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
> +
> +	perm_fail = false;
> +
> +	switch (op) {
> +	case OP_AT_S1E1RP:
> +		perm_fail |= pan && (ur || uw || ux);
> +		fallthrough;
> +	case OP_AT_S1E1R:
> +	case OP_AT_S1E2R:
> +		perm_fail |= !pr;
> +		break;
> +	case OP_AT_S1E1WP:
> +		perm_fail |= pan && (ur || uw || ux);
> +		fallthrough;
> +	case OP_AT_S1E1W:
> +	case OP_AT_S1E2W:
> +		perm_fail |= !pw;
> +		break;
> +	case OP_AT_S1E0R:
> +		perm_fail |= !ur;
> +		break;
> +	case OP_AT_S1E0W:
> +		perm_fail |= !uw;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	if (perm_fail) {
> +		struct s1_walk_result tmp;
> +
> +		tmp.failed = true;
> +		tmp.fst = ESR_ELx_FSC_PERM | wr.level;
> +		tmp.s2 = false;
> +		tmp.ptw = false;
> +
> +		wr = tmp;
> +	}
> +
> +compute_par:
> +	return compute_par_s1(vcpu, &wr);
> +}
> +
>  static bool check_at_pan(struct kvm_vcpu *vcpu, u64 vaddr, u64 *res)
>  {
>  	u64 par_e0;
> @@ -266,9 +733,11 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	struct mmu_config config;
>  	struct kvm_s2_mmu *mmu;
>  	unsigned long flags;
> -	bool fail;
> +	bool fail, retry_slow;
>  	u64 par;
>  
> +	retry_slow = false;
> +
>  	write_lock(&vcpu->kvm->mmu_lock);
>  
>  	/*
> @@ -288,14 +757,15 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  		goto skip_mmu_switch;
>  
>  	/*
> -	 * FIXME: Obtaining the S2 MMU for a L2 is horribly racy, and
> -	 * we may not find it (recycled by another vcpu, for example).
> -	 * See the other FIXME comment below about the need for a SW
> -	 * PTW in this case.
> +	 * Obtaining the S2 MMU for a L2 is horribly racy, and we may not
> +	 * find it (recycled by another vcpu, for example). When this
> +	 * happens, use the SW (slow) path.
>  	 */
>  	mmu = lookup_s2_mmu(vcpu);
> -	if (WARN_ON(!mmu))
> +	if (!mmu) {
> +		retry_slow = true;
>  		goto out;
> +	}
>  
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR0_EL1),	SYS_TTBR0);
>  	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR1_EL1),	SYS_TTBR1);
> @@ -331,18 +801,17 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	}
>  
>  	if (!fail)
> -		par = read_sysreg(par_el1);
> +		par = read_sysreg_par();
>  	else
>  		par = SYS_PAR_EL1_F;
>  
> +	retry_slow = !fail;
> +
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
>  
>  	/*
> -	 * Failed? let's leave the building now.
> -	 *
> -	 * FIXME: how about a failed translation because the shadow S2
> -	 * wasn't populated? We may need to perform a SW PTW,
> -	 * populating our shadow S2 and retry the instruction.
> +	 * Failed? let's leave the building now, unless we retry on
> +	 * the slow path.
>  	 */
>  	if (par & SYS_PAR_EL1_F)
>  		goto nopan;
> @@ -354,29 +823,58 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	switch (op) {
>  	case OP_AT_S1E1RP:
>  	case OP_AT_S1E1WP:
> +		retry_slow = false;
>  		fail = check_at_pan(vcpu, vaddr, &par);
>  		break;
>  	default:
>  		goto nopan;
>  	}
>  
> +	if (fail) {
> +		vcpu_write_sys_reg(vcpu, SYS_PAR_EL1_F, PAR_EL1);
> +		goto nopan;
> +	}
> +
>  	/*
>  	 * If the EL0 translation has succeeded, we need to pretend
>  	 * the AT operation has failed, as the PAN setting forbids
>  	 * such a translation.
> -	 *
> -	 * FIXME: we hardcode a Level-3 permission fault. We really
> -	 * should return the real fault level.
>  	 */
> -	if (fail || !(par & SYS_PAR_EL1_F))
> -		vcpu_write_sys_reg(vcpu, (0xf << 1) | SYS_PAR_EL1_F, PAR_EL1);
> -
> +	if (par & SYS_PAR_EL1_F) {
> +		u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> +
> +		/*
> +		 * If we get something other than a permission fault, we
> +		 * need to retry, as we're likely to have missed in the PTs.
> +		 */
> +		if ((fst & ESR_ELx_FSC_TYPE) != ESR_ELx_FSC_PERM)
> +			retry_slow = true;
> +	} else {
> +		/*
> +		 * The EL0 access succeded, but we don't have the full
> +		 * syndrom information to synthetize the failure. Go slow.
> +		 */
> +		retry_slow = true;
> +	}
>  nopan:
>  	__mmu_config_restore(&config);
>  out:
>  	local_irq_restore(flags);
>  
>  	write_unlock(&vcpu->kvm->mmu_lock);
> +
> +	/*
> +	 * If retry_slow is true, then we either are missing shadow S2
> +	 * entries, have paged out guest S1, or something is inconsistent.
> +	 *
> +	 * Either way, we need to walk the PTs by hand so that we can either
> +	 * fault things back, in or record accurate fault information along
> +	 * the way.
> +	 */
> +	if (retry_slow) {
> +		par = handle_at_slow(vcpu, op, vaddr);
> +		vcpu_write_sys_reg(vcpu, par, PAR_EL1);
> +	}
>  }
>  
>  void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> @@ -433,6 +931,10 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  
> +	/* We failed the translation, let's replay it in slow motion */
> +	if (!fail && (par & SYS_PAR_EL1_F))
> +		par = handle_at_slow(vcpu, op, vaddr);
> +
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
>  }
>  
> -- 
> 2.39.2
> 
> 

