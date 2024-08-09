Return-Path: <kvm+bounces-23688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB42094D067
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 14:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8171F21FC3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 12:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266B5194A48;
	Fri,  9 Aug 2024 12:43:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78265194089
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 12:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723207420; cv=none; b=JTXV1ukgNGXlaLqDnZUum6HGBiuvpR7vIahq1CLnzs1760sVL/U9Q1ljetqbOIepNg2a2jGbfYDwVLiKNwcmbB5VBCKIKbqPQlEDcu7W0Lyp4zhyCuqeTCKV+y7mN2kTi3blgyh9LQ5hE6dGOQFYNFRSv9zANlXFLVgXOD/jlOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723207420; c=relaxed/simple;
	bh=LK2K7P5A5W/mh34KEAAK/PaFGXe6pzAMVj7ZNDgBFjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fr0MvRG9tFvd1w6Wj7i2pTR1ZJlc+4Y+642oGuScG9KkuoesV/wTHDyYz7pI+PpkHywROaQ6R6BKQrxHeSz+6m74KAeIe69aLNIRpH2jCrNR8L0HfKhz2ptgHsmwiP0U5XAZqmm4eOgw7zTxlJ152dAZ6xuXHT65oe3qjZr90f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4F8B13D5;
	Fri,  9 Aug 2024 05:44:03 -0700 (PDT)
Received: from arm.com (e121798.manchester.arm.com [10.32.101.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56E023F6A8;
	Fri,  9 Aug 2024 05:43:36 -0700 (PDT)
Date: Fri, 9 Aug 2024 13:43:33 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: Re: [PATCH v2 13/17] KVM: arm64: nv: Add SW walker for AT S1
 emulation
Message-ID: <ZrYO9SK52rHhGvEd@arm.com>
References: <20240731194030.1991237-1-maz@kernel.org>
 <20240731194030.1991237-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240731194030.1991237-14-maz@kernel.org>

Hi Marc,

Finally managed to go through the patch. Bunch of nitpicks from me (can be
safely ignored), and some corner cases where KVM deviates from the spec.

On Wed, Jul 31, 2024 at 08:40:26PM +0100, Marc Zyngier wrote:
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
>  arch/arm64/kvm/at.c | 567 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 565 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 9865d29b3149..8e1f0837e309 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -4,9 +4,372 @@
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
> +/* return true of the IPA is out of the OA range */

*R*eturn true *if* the IPA is out of the OA range?

> +static bool check_output_size(u64 ipa, struct s1_walk_info *wi)
> +{
> +	return wi->max_oa_bits < 48 && (ipa & GENMASK_ULL(47, wi->max_oa_bits));
> +}

Matches AArch64.OAOutOfRange(), where KVM supports a maximum oasize of 48 bits,
and AArch64.PAMax() is get_kvm_ipa_limit().

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

This matches the pseudocode for the instructions, which calls
AArch64.AT(el_in=EL2). AT(el_in=EL2) calls TranslationRegime(el=EL2), which
returns Regime_EL20 if E2H is set (in ELIsInHost(el=EL2)), otherwise Regime_EL2.


> +		break;
> +	default:
> +		return (vcpu_el2_e2h_is_set(vcpu) &&
> +			vcpu_el2_tge_is_set(vcpu)) ? TR_EL20 : TR_EL10;

This also looks correct to me. Following the pseudocode was not trivial, so I'm
leaving this here in case I made a mistake somewhere.

For the S1E0* variants: AArch64.AT(el_in=EL0) => TranslationRegime(el=EL0) =>
ELIsInHost(el=EL0); ELIsInHost(el=EL0) is true if {E2H,TGE} = {1,1}, and in this
case TranslationRegime(el=EL0) returns Regime_EL20, otherwise Regime_EL10.

For the S1E1* variants: AArch64.AT(el_in=EL1), where:

- if ELIsInHost(el=EL0) is true, then 'el' is changed to EL2, where
  ELIsInHost(el=EL0) is true if {E2H,TGE} = {1,1}. In this case,
  TranslationRegime(el=EL2) will return Regime_EL20.

- if ELIsInHost(el=EL0) is false, then 'el' remains EL1, and
  TranslationRegime(el=EL1) returns Regime_EL10.

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
> +	wi->s2 = wi->regime == TR_EL10 && (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_VM);

According to AArch64.NSS2TTWParams(), stage 2 is enabled if HCR_EL2.VM or
HCR_EL2.DC.

From the description of HCR_EL2.DC, when the bit is set:

'The PE behaves as if the value of the HCR_EL2.VM field is 1 for all purposes
other than returning the value of a direct read of HCR_EL2.'

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
> +	if (!(sctlr & SCTLR_ELx_M) ||
> +	    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {

I think the condition doesn't match AArch64.S1Enabled():

- if regime is Regime_EL20 or Regime_EL2, then S1 is disabled if and only if
  SCTLR_EL2.M is not set; it doesn't matter if HCR_EL2.DC is set, because "[..]
  this field has no effect on the EL2, EL2&0, and EL3 translation regimes."
  (HCR_EL2.DC bit field description).

- if regime is Regime_EL10, then S1 is disabled if SCTLR_EL1.M == 0 or
  HCR_EL2.TGE = 0 or the effective value of HCR_EL2.DC* is 0.

From the description of HCR_EL2.TGE, when the bit is set:

'If EL1 is using AArch64, the SCTLR_EL1.M field is treated as being 0 for all
purposes other than returning the result of a direct read of SCTLR_EL1.'

From the description of HCR_EL2.DC, when the bit is set:

'When EL1 is using AArch64, the PE behaves as if the value of the SCTLR_EL1.M
field is 0 for all purposes other than returning the value of a direct read of
SCTLR_EL1.'

*The description of HCR_EL2.DC states:

'When the Effective value of HCR_EL2.{E2H,TGE} is {1,1}, this field behaves as
0 for all purposes other than a direct read of the value of this field.'

But if {E2H,TGE} = {1,1} then the regime is Regime_EL20, which ignores the DC
bit.  If we're looking at the DC bit, then that means that the regime is EL10,
({E2H,TGE} != {1,1} in compute_translation_regime()) and the effective value of
HCR_EL2.DC is the same as the DC bit.

> +		if (va >= BIT(kvm_get_pa_bits(vcpu->kvm)))
> +			goto addrsz;
> +
> +		wr->level = S1_MMU_DISABLED;
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
> +	if ((!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47) &&
> +	     wi->txsz > 39) ||
> +	    (wi->pgshift == 16 && wi->txsz > 47) || wi->txsz > 48)
> +		goto transfault_l0;

It's probably just me, but I find this hard to parse. There are three cases when
the condition (!FEAT_TTST && TxSZ > 39) evaluates to false. But the other two
conditions make sense to check only if !FEAT_TTST is false and wi->txsz > 39 is
true.

I find this easier to read:

	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47)) {
		if (wi->txsz > 39)
			goto transfault_l0;
	} else {
		if (wi->txsz > 48 || (wi->pgshift == 16 && wi->txsz > 47))
			goto transfault_l0;
	}

What do you think?

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
> +
> +	ia_bits = get_ia_size(wi);
> +
> +	/* R_YYVYV, I_THCZK */
> +	if ((!va55 && va > GENMASK(ia_bits - 1, 0)) ||
> +	    (va55 && va < GENMASK(63, ia_bits)))
> +		goto transfault_l0;
> +
> +	/* R_ZFSYQ */

This is rather pedantic, but I think that should be I_ZFSYQ.

> +	if (wi->regime != TR_EL2 &&
> +	    (tcr & ((va55) ? TCR_EPD1_MASK : TCR_EPD0_MASK)))
> +		goto transfault_l0;
> +
> +	/* R_BNDVG and following statements */
> +	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, E0PD, IMP) &&
> +	    as_el0 && (tcr & ((va55) ? TCR_E0PD1 : TCR_E0PD0)))
> +		goto transfault_l0;
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
> +				fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level),
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
> +		if (!(desc & 1) || ((desc & 3) == 1 && level == 3))
> +			goto transfault;

The check for block mapping at level 3 is replicated below, when the level of
the block is checked for correctnes.

Also, would you consider rewriting the valid descriptor check to
(desc & BIT(0)), to match the block level check?

> +
> +		/* We found a leaf, handle that */
> +		if ((desc & 3) == 1 || level == 3)
> +			break;

Here we know that (desc & 1), do you think rewriting the check to !(desc &
BIT(1)), again matching the block level check, would be a good idea?

> +
> +		if (!wi->hpd) {
> +			wr->APTable  |= FIELD_GET(S1_TABLE_AP, desc);
> +			wr->UXNTable |= FIELD_GET(PMD_TABLE_UXN, desc);
> +			wr->PXNTable |= FIELD_GET(PMD_TABLE_PXN, desc);
> +		}
> +
> +		baddr = desc & GENMASK_ULL(47, wi->pgshift);
> +
> +		/* Check for out-of-range OA */
> +		if (check_output_size(baddr, wi))
> +			goto addrsz;
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
> +		if (!valid_block)
> +			goto transfault;
> +	}

Matches AArch64.BlockDescSupported(), with the caveat that KVM doesn't yet
support 52 bit PAs.

> +
> +	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
> +		goto addrsz;
> +
> +	wr->failed = false;
> +	wr->level = level;
> +	wr->desc = desc;
> +	wr->pa = desc & GENMASK(47, va_bottom);
> +	if (va_bottom > 12)
> +		wr->pa |= va & GENMASK_ULL(va_bottom - 1, 12);

I'm looking at StageOA(), and I don't think this matches what happens when the
contiguous bit is set and the contiguous OA isn't aligned as per Table D8-98.
Yes, I know, that's something super niche and unlikely to happen in practice.

Let's assume 4K pages, level = 3 (so va_bottom = 12), the first page in the
contiguous OA range is 0x23_000 (so not aligned to 64K), and the input address
that maps to the first page from the contiguous OA range is 0xf0_000 (aligned to
64K).

According to the present code:

wr->pa = 0x23_000

According to StageOA():

tsize  = 12
csize  = 4
oa     = 0x23_000 & GENMASK_ULL(47, 16) | 0xf0_000 & GENMASK_ULL(15, 0) = 0x20_000
wr->pa = oa & ~GENMASK_ULL(11, 0) = 0x20_000

If the stage 1 is correctly programmed and the OA aligned to the required
alignment, the two outputs match

On a different topic, but still regarding wr->pa. I guess the code aligns wr->pa
to 4K because that's how the OA in PAR_EL1 is reported.

Would it make more sense to have wr->pa represent the real output address, i.e,
also contain the 12 least significant bits of the input address?  It wouldn't
change how PAR_EL1 is computed (bits 11:0 are already masked out), but it would
make wr->pa consistent with what the output address of a given input address
should be (according to StageOA()).

> +
> +	return 0;
> +
> +addrsz:
> +	fail_s1_walk(wr, ESR_ELx_FSC_ADDRSZ_L(level), true, false);
> +	return -EINVAL;
> +transfault:
> +	fail_s1_walk(wr, ESR_ELx_FSC_FAULT_L(level), true, false);
> +	return -ENOENT;
> +}
> +
>  struct mmu_config {
>  	u64	ttbr0;
>  	u64	ttbr1;
> @@ -188,6 +551,16 @@ static u8 compute_sh(u8 attr, u64 desc)
>  	return sh;
>  }
>  
> +static u8 combine_sh(u8 s1_sh, u8 s2_sh)
> +{
> +	if (s1_sh == ATTR_OSH || s2_sh == ATTR_OSH)
> +		return ATTR_OSH;
> +	if (s1_sh == ATTR_ISH || s2_sh == ATTR_ISH)
> +		return ATTR_ISH;
> +
> +	return ATTR_NSH;
> +}
> +
>  static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
>  			   struct kvm_s2_trans *tr)
>  {
> @@ -260,11 +633,181 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
>  	par  = FIELD_PREP(SYS_PAR_EL1_ATTR, final_attr);
>  	par |= tr->output & GENMASK(47, 12);
>  	par |= FIELD_PREP(SYS_PAR_EL1_SH,
> -			  compute_sh(final_attr, tr->desc));
> +			  combine_sh(FIELD_GET(SYS_PAR_EL1_SH, s1_par),
> +				     compute_sh(final_attr, tr->desc)));
>  
>  	return par;
>  }
>  
> +static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
> +			  enum trans_regime regime)
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

s/0b10/ATTR_OSH ?

> +		} else {
> +			par |= FIELD_PREP(SYS_PAR_EL1_ATTR,
> +					  MEMATTR(WbRaWa, WbRaWa));
> +			par |= FIELD_PREP(SYS_PAR_EL1_SH, 0b00); /* NS */

s/0b00/ATTR_NSH ?

> +		}

HCR_EL2.DC applies only to Regime_EL10, I think the bit should be ignored for
the EL2 and EL20 regimes.

> +	} else {
> +		u64 mair, sctlr;
> +		u8 sh;
> +
> +		mair = (regime == TR_EL10 ?
> +			vcpu_read_sys_reg(vcpu, MAIR_EL1) :
> +			vcpu_read_sys_reg(vcpu, MAIR_EL2));
> +
> +		mair >>= FIELD_GET(PTE_ATTRINDX_MASK, wr->desc) * 8;
> +		mair &= 0xff;
> +
> +		sctlr = (regime == TR_EL10 ?
> +			 vcpu_read_sys_reg(vcpu, SCTLR_EL1) :
> +			 vcpu_read_sys_reg(vcpu, SCTLR_EL2));
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

When PAR_EL1.F = 0 and !FEAT_RME, bit 11 (NSE) is RES1, according to the
description of the register and EncodePAR().

> +
> +	return par;
> +}
> +
> +static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +{
> +	bool perm_fail, ur, uw, ux, pr, pw, px;
> +	struct s1_walk_result wr = {};
> +	struct s1_walk_info wi = {};
> +	int ret, idx;
> +
> +	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
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
> +	/* AArch64.S1DirectBasePermissions() */
> +	if (wi.regime != TR_EL2) {
> +		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr.desc)) {
> +		case 0b00:
> +			pr = pw = true;
> +			ur = uw = false;
> +			break;
> +		case 0b01:
> +			pr = pw = ur = uw = true;
> +			break;
> +		case 0b10:
> +			pr = true;
> +			pw = ur = uw = false;
> +			break;
> +		case 0b11:
> +			pr = ur = true;
> +			pw = uw = false;
> +			break;
> +		}
> +
> +		switch (wr.APTable) {
> +		case 0b00:
> +			break;
> +		case 0b01:
> +			ur = uw = false;
> +			break;
> +		case 0b10:
> +			pw = uw = false;
> +			break;
> +		case 0b11:
> +			pw = ur = uw = false;
> +			break;
> +		}
> +
> +		/* We don't use px for anything yet, but hey... */
> +		px = !((wr.desc & PTE_PXN) || wr.PXNTable || pw);
> +		ux = !((wr.desc & PTE_UXN) || wr.UXNTable);
> +
> +		if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
> +			bool pan;
> +
> +			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
> +			pan &= ur || uw;
> +			pw &= !pan;
> +			pr &= !pan;
> +		}
> +	} else {
> +		ur = uw = ux = false;
> +
> +		if (!(wr.desc & PTE_RDONLY)) {
> +			pr = pw = true;
> +		} else {
> +			pr = true;
> +			pw = false;
> +		}
> +
> +		if (wr.APTable & BIT(1))
> +			pw = false;
> +
> +		/* XN maps to UXN */
> +		px = !((wr.desc & PTE_UXN) || wr.UXNTable);
> +	}
> +
> +	perm_fail = false;
> +
> +	switch (op) {
> +	case OP_AT_S1E1RP:
> +	case OP_AT_S1E1R:
> +	case OP_AT_S1E2R:
> +		perm_fail = !pr;
> +		break;
> +	case OP_AT_S1E1WP:
> +	case OP_AT_S1E1W:
> +	case OP_AT_S1E2W:
> +		perm_fail = !pw;
> +		break;
> +	case OP_AT_S1E0R:
> +		perm_fail = !ur;
> +		break;
> +	case OP_AT_S1E0W:
> +		perm_fail = !uw;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	if (perm_fail)
> +		fail_s1_walk(&wr, ESR_ELx_FSC_PERM_L(wr.level), false, false);
> +
> +compute_par:
> +	return compute_par_s1(vcpu, &wr, wi.regime);
> +}
> +
>  /*
>   * Return the PAR_EL1 value as the result of a valid translation.
>   *
> @@ -352,10 +895,26 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	return par;
>  }
>  
> +static bool par_check_s1_perm_fault(u64 par)
> +{
> +	u8 fst = FIELD_GET(SYS_PAR_EL1_FST, par);
> +
> +	return  ((fst & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_PERM &&
> +		 !(par & SYS_PAR_EL1_S));
> +}
> +
>  void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  {
>  	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
>  
> +	/*
> +	 * If we see a permission fault at S1, then the fast path
> +	 * succeedded. By failing. Otherwise, take a walk on the wild
> +	 * side.

This is rather ambiguous. Maybe something along the lines would be more helpful:

'If PAR_EL1 encodes a permission fault, we know for sure that the hardware
translation table walker was able to walk the stage 1 tables and there's nothing
else that KVM needs to do. On the other hand, if the AT instruction failed for
any other reason, then KVM must walk the guest stage 1 tables (and possibly the
virtual stage 2 tables) to emulate the instruction.'

Thanks,
Alex

> +	 */
> +	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
> +		par = handle_at_slow(vcpu, op, vaddr);
> +
>  	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
>  }
>  
> @@ -407,6 +966,10 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
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
> @@ -463,7 +1026,7 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
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

