Return-Path: <kvm+bounces-23865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2089D94F164
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 17:12:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44E4F1C20C9F
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB9C18309C;
	Mon, 12 Aug 2024 15:12:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162FA17C7CB
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723475535; cv=none; b=E+FbiS4GnFJzwKfiePRrgtaHY6YmT0ouDzylSUgYzW9TaudCs4ey6ghK9fEsakym3qvxNDeFqXUIS53xNmoilZLAQNF/AwS5GJRggRLua38cLvERfnbNDYbmpE8LDgk6ZNoE4yfL06Dn0JxtvoHKoMpnwWTkhBUdQ8nmT/yL5a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723475535; c=relaxed/simple;
	bh=puwWw5jZut/dIysUQ2xBxm3sMPNpJ5ygbVfyqWXiqeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7/HUe8CHum/pX1rmpGCmDpL+3qm0WWwGwQq683HChdT1mWg0JI01a/n0szq3xyCv0ptIhNcb3xRdcnKDPR2X7akaYGdnbmq239fyP/ABM5TjUy3ty1ukUp1eSMT8DiymQEYDWVy3XdzRsekNlnevs5isXAHMb3i1u/FCt7p9Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 351B9FEC;
	Mon, 12 Aug 2024 08:12:37 -0700 (PDT)
Received: from arm.com (unknown [10.57.67.196])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B200F3F6A8;
	Mon, 12 Aug 2024 08:11:33 -0700 (PDT)
Date: Mon, 12 Aug 2024 16:11:02 +0100
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
Message-ID: <ZromBtfbjaHbcjT7@arm.com>
References: <20240731194030.1991237-1-maz@kernel.org>
 <20240731194030.1991237-14-maz@kernel.org>
 <ZrYO9SK52rHhGvEd@arm.com>
 <867cco1y4w.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867cco1y4w.wl-maz@kernel.org>

Hi Marc,

On Sat, Aug 10, 2024 at 11:16:15AM +0100, Marc Zyngier wrote:
> Hi Alex,
> 
> On Fri, 09 Aug 2024 13:43:33 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > Finally managed to go through the patch. Bunch of nitpicks from me (can be
> > safely ignored), and some corner cases where KVM deviates from the spec.
> 
> Thanks for taking the time to go through this mess.
> 
> [...]
> 
> > > +		break;
> > > +	default:
> > > +		return (vcpu_el2_e2h_is_set(vcpu) &&
> > > +			vcpu_el2_tge_is_set(vcpu)) ? TR_EL20 : TR_EL10;
> > 
> > This also looks correct to me. Following the pseudocode was not trivial, so I'm
> > leaving this here in case I made a mistake somewhere.
> > 
> > For the S1E0* variants: AArch64.AT(el_in=EL0) => TranslationRegime(el=EL0) =>
> > ELIsInHost(el=EL0); ELIsInHost(el=EL0) is true if {E2H,TGE} = {1,1}, and in this
> > case TranslationRegime(el=EL0) returns Regime_EL20, otherwise Regime_EL10.
> > 
> > For the S1E1* variants: AArch64.AT(el_in=EL1), where:
> > 
> > - if ELIsInHost(el=EL0) is true, then 'el' is changed to EL2, where
> >   ELIsInHost(el=EL0) is true if {E2H,TGE} = {1,1}. In this case,
> >   TranslationRegime(el=EL2) will return Regime_EL20.
> > 
> > - if ELIsInHost(el=EL0) is false, then 'el' remains EL1, and
> >   TranslationRegime(el=EL1) returns Regime_EL10.
> 
> Yup. Somehow, the C version is far easier to understand!
> 
> > 
> > > +	}
> > > +}
> > > +
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
> > > +	wi->s2 = wi->regime == TR_EL10 && (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_VM);
> > 
> > According to AArch64.NSS2TTWParams(), stage 2 is enabled if HCR_EL2.VM or
> > HCR_EL2.DC.
> > 
> > From the description of HCR_EL2.DC, when the bit is set:
> > 
> > 'The PE behaves as if the value of the HCR_EL2.VM field is 1 for all purposes
> > other than returning the value of a direct read of HCR_EL2.'
> 
> Yup, good point. And as you noticed further down, the HCR_EL2.DC
> handling is currently a mess.
> 
> [...]
> 
> > > +	/* Let's put the MMU disabled case aside immediately */
> > > +	if (!(sctlr & SCTLR_ELx_M) ||
> > > +	    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> > 
> > I think the condition doesn't match AArch64.S1Enabled():
> > 
> > - if regime is Regime_EL20 or Regime_EL2, then S1 is disabled if and only if
> >   SCTLR_EL2.M is not set; it doesn't matter if HCR_EL2.DC is set, because "[..]
> >   this field has no effect on the EL2, EL2&0, and EL3 translation regimes."
> >   (HCR_EL2.DC bit field description).
> > 
> > - if regime is Regime_EL10, then S1 is disabled if SCTLR_EL1.M == 0 or
> >   HCR_EL2.TGE = 0 or the effective value of HCR_EL2.DC* is 0.
> > 
> > From the description of HCR_EL2.TGE, when the bit is set:
> > 
> > 'If EL1 is using AArch64, the SCTLR_EL1.M field is treated as being 0 for all
> > purposes other than returning the result of a direct read of SCTLR_EL1.'
> > 
> > From the description of HCR_EL2.DC, when the bit is set:
> > 
> > 'When EL1 is using AArch64, the PE behaves as if the value of the SCTLR_EL1.M
> > field is 0 for all purposes other than returning the value of a direct read of
> > SCTLR_EL1.'
> > 
> > *The description of HCR_EL2.DC states:
> > 
> > 'When the Effective value of HCR_EL2.{E2H,TGE} is {1,1}, this field behaves as
> > 0 for all purposes other than a direct read of the value of this field.'
> > 
> > But if {E2H,TGE} = {1,1} then the regime is Regime_EL20, which ignores the DC
> > bit.  If we're looking at the DC bit, then that means that the regime is EL10,
> > ({E2H,TGE} != {1,1} in compute_translation_regime()) and the effective value of
> > HCR_EL2.DC is the same as the DC bit.
> 
> Yup. That's what I've stashed on top:
> 
> @@ -136,12 +137,22 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  	va = (u64)sign_extend64(va, 55);
>  
>  	/* Let's put the MMU disabled case aside immediately */
> -	if (!(sctlr & SCTLR_ELx_M) ||
> -	    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> +	switch (wi->regime) {
> +	case TR_EL10:
> +		if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)
> +			wr->level = S1_MMU_DISABLED;

In compute_translation_regime(), for AT instructions other than AT S1E2*, when
{E2H,TGE} = {0,1}, regime is Regime_EL10. As far as I can tell, when regime is
Regime_EL10 and TGE is set, stage 1 is disabled, according to
AArch64.S1Enabled() and the decription of the TGE bit.

> +		fallthrough;
> +	case TR_EL2:
> +	case TR_EL20:
> +		if (!(sctlr & SCTLR_ELx_M))
> +			wr->level = S1_MMU_DISABLED;
> +		break;
> +	}
> +
> +	if (wr->level == S1_MMU_DISABLED) {
>  		if (va >= BIT(kvm_get_pa_bits(vcpu->kvm)))
>  			goto addrsz;
>  
> -		wr->level = S1_MMU_DISABLED;
>  		wr->pa = va;
>  		return 0;
>  	}
> 
> [...]
> 
> > > +	/* R_PLCGL, R_YXNYW */
> > > +	if ((!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47) &&
> > > +	     wi->txsz > 39) ||
> > > +	    (wi->pgshift == 16 && wi->txsz > 47) || wi->txsz > 48)
> > > +		goto transfault_l0;
> > 
> > It's probably just me, but I find this hard to parse. There are three cases when
> > the condition (!FEAT_TTST && TxSZ > 39) evaluates to false. But the other two
> > conditions make sense to check only if !FEAT_TTST is false and wi->txsz > 39 is
> > true.
> > 
> > I find this easier to read:
> > 
> > 	if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR2_EL1, ST, 48_47)) {
> > 		if (wi->txsz > 39)
> > 			goto transfault_l0;
> > 	} else {
> > 		if (wi->txsz > 48 || (wi->pgshift == 16 && wi->txsz > 47))
> > 			goto transfault_l0;
> > 	}
> > 
> > What do you think?
> 
> Sure, happy to rewrite it like this if it helps.

Cool, thanks.

> 
> [...]
> 
> > > +	/* R_YYVYV, I_THCZK */
> > > +	if ((!va55 && va > GENMASK(ia_bits - 1, 0)) ||
> > > +	    (va55 && va < GENMASK(63, ia_bits)))
> > > +		goto transfault_l0;
> > > +
> > > +	/* R_ZFSYQ */
> > 
> > This is rather pedantic, but I think that should be I_ZFSYQ.
> 
> Well, these references are supposed to help. If they are incorrect,
> they serve no purpose. Thanks for spotting this.
> 
> [...]
> 
> > > +		if (!(desc & 1) || ((desc & 3) == 1 && level == 3))
> > > +			goto transfault;
> > 
> > The check for block mapping at level 3 is replicated below, when the level of
> > the block is checked for correctnes.
> > 
> > Also, would you consider rewriting the valid descriptor check to
> > (desc & BIT(0)), to match the block level check?
> > 
> > > +
> > > +		/* We found a leaf, handle that */
> > > +		if ((desc & 3) == 1 || level == 3)
> > > +			break;
> > 
> > Here we know that (desc & 1), do you think rewriting the check to !(desc &
> > BIT(1)), again matching the block level check, would be a good idea?
> 
> Other that the BIT() stuff, I'm not completely clear what you are
> asking for. Are you objecting to the fact that the code is slightly
> redundant? If so, I may be able to clean things up for you:

Yes, I was referring to the fact that the code is slightly redundant.

> 
> @@ -309,13 +323,19 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  		else
>  			desc = le64_to_cpu((__force __le64)desc);
>  
> -		if (!(desc & 1) || ((desc & 3) == 1 && level == 3))
> +		/* Invalid descriptor */
> +		if (!(desc & BIT(0)))
>  			goto transfault;
>  
> -		/* We found a leaf, handle that */
> -		if ((desc & 3) == 1 || level == 3)
> +		/* Block mapping, check validity down the line */
> +		if (!(desc & BIT(1)))
> +			break;
> +
> +		/* Page mapping */
> +		if (level == 3)
>  			break;
>  
> +		/* Table handling */
>  		if (!wi->hpd) {
>  			wr->APTable  |= FIELD_GET(S1_TABLE_AP, desc);
>  			wr->UXNTable |= FIELD_GET(PMD_TABLE_UXN, desc);
> 
> Do you like this one better? Each bit only gets tested once.

	switch (desc & GENMASK_ULL(1, 0)) {
	case 0b00:
	case 0b10:
		goto transfault;
	case 0b01:
		/* Block mapping */
		break;
	default:
		if (level == 3)
			break;
	}

Is this better? Perhaps slightly easier to match against the descriptor layouts,
but I'm not sure it's an improvement over your suggestion. Up to you, no point
in bikeshedding over it.

> 
> [...]
> 
> > > +
> > > +	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
> > > +		goto addrsz;
> > > +
> > > +	wr->failed = false;
> > > +	wr->level = level;
> > > +	wr->desc = desc;
> > > +	wr->pa = desc & GENMASK(47, va_bottom);
> > > +	if (va_bottom > 12)
> > > +		wr->pa |= va & GENMASK_ULL(va_bottom - 1, 12);
> > 
> > I'm looking at StageOA(), and I don't think this matches what happens when the
> > contiguous bit is set and the contiguous OA isn't aligned as per Table D8-98.
> > Yes, I know, that's something super niche and unlikely to happen in practice.
> > 
> > Let's assume 4K pages, level = 3 (so va_bottom = 12), the first page in the
> > contiguous OA range is 0x23_000 (so not aligned to 64K), and the input address
> > that maps to the first page from the contiguous OA range is 0xf0_000 (aligned to
> > 64K).
> > 
> > According to the present code:
> > 
> > wr->pa = 0x23_000
> > 
> > According to StageOA():
> > 
> > tsize  = 12
> > csize  = 4
> > oa     = 0x23_000 & GENMASK_ULL(47, 16) | 0xf0_000 & GENMASK_ULL(15, 0) = 0x20_000
> > wr->pa = oa & ~GENMASK_ULL(11, 0) = 0x20_000
> > 
> > If the stage 1 is correctly programmed and the OA aligned to the required
> > alignment, the two outputs match
> 
> Huh, that's another nice catch. I had the (dumb) idea that if we
> didn't use the Contiguous bit as a TLB hint, we didn't need to do
> anything special when it came to the alignment of the OA.
> 
> But clearly, the spec says that this alignment must be honoured, and
> there is no way out of it. Which means that the S2 walker also has a
> bit of a problem on that front.
> 
> > On a different topic, but still regarding wr->pa. I guess the code aligns wr->pa
> > to 4K because that's how the OA in PAR_EL1 is reported.
> > 
> > Would it make more sense to have wr->pa represent the real output address, i.e,
> > also contain the 12 least significant bits of the input address?  It wouldn't
> > change how PAR_EL1 is computed (bits 11:0 are already masked out), but it would
> > make wr->pa consistent with what the output address of a given input address
> > should be (according to StageOA()).
> 
> Yup. That'd be consistent with the way wr->pa is reported when S1 is disabled.
> 
> I ended-up with this (untested):
> 
> @@ -354,12 +374,24 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>  	if (check_output_size(desc & GENMASK(47, va_bottom), wi))
>  		goto addrsz;
>  
> +	if (desc & PTE_CONT) {
> +		switch (BIT(wi->pgshift)) {
> +		case SZ_4K:
> +			va_bottom += 4;
> +			break;
> +		case SZ_16K:
> +			va_bottom += level == 2 ? 5 : 7;
> +			break;
> +		case SZ_64K:
> +			va_bottom += 5;
> +		}
> +	}
> +

Matches ContiguousSize().

>  	wr->failed = false;
>  	wr->level = level;
>  	wr->desc = desc;
>  	wr->pa = desc & GENMASK(47, va_bottom);
> -	if (va_bottom > 12)
> -		wr->pa |= va & GENMASK_ULL(va_bottom - 1, 12);
> +	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);

Matches StageOA().

>  
>  	return 0;
>  
> 
> Note that I'm still checking for the address size before the
> contiguous bit alignment, as per R_JHQPP.

Nicely spotted.

> 
> [...]
> 
> > > +		if (!(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> > > +			par |= FIELD_PREP(SYS_PAR_EL1_ATTR, 0); /* nGnRnE */
> > > +			par |= FIELD_PREP(SYS_PAR_EL1_SH, 0b10); /* OS */
> > 
> > s/0b10/ATTR_OSH ?
> > 
> > > +		} else {
> > > +			par |= FIELD_PREP(SYS_PAR_EL1_ATTR,
> > > +					  MEMATTR(WbRaWa, WbRaWa));
> > > +			par |= FIELD_PREP(SYS_PAR_EL1_SH, 0b00); /* NS */
> > 
> > s/0b00/ATTR_NSH ?
> > 
> > > +		}
> > 
> > HCR_EL2.DC applies only to Regime_EL10, I think the bit should be ignored for
> > the EL2 and EL20 regimes.
> 
> Yup, now fixed.
> 
> > 
> > > +	} else {
> > > +		u64 mair, sctlr;
> > > +		u8 sh;
> > > +
> > > +		mair = (regime == TR_EL10 ?
> > > +			vcpu_read_sys_reg(vcpu, MAIR_EL1) :
> > > +			vcpu_read_sys_reg(vcpu, MAIR_EL2));
> > > +
> > > +		mair >>= FIELD_GET(PTE_ATTRINDX_MASK, wr->desc) * 8;
> > > +		mair &= 0xff;
> > > +
> > > +		sctlr = (regime == TR_EL10 ?
> > > +			 vcpu_read_sys_reg(vcpu, SCTLR_EL1) :
> > > +			 vcpu_read_sys_reg(vcpu, SCTLR_EL2));
> > > +
> > > +		/* Force NC for memory if SCTLR_ELx.C is clear */
> > > +		if (!(sctlr & SCTLR_EL1_C) && !MEMATTR_IS_DEVICE(mair))
> > > +			mair = MEMATTR(NC, NC);
> > > +
> > > +		par  = FIELD_PREP(SYS_PAR_EL1_ATTR, mair);
> > > +		par |= wr->pa & GENMASK_ULL(47, 12);
> > > +
> > > +		sh = compute_sh(mair, wr->desc);
> > > +		par |= FIELD_PREP(SYS_PAR_EL1_SH, sh);
> > > +	}
> > 
> > When PAR_EL1.F = 0 and !FEAT_RME, bit 11 (NSE) is RES1, according to the
> > description of the register and EncodePAR().
> 
> Fixed.
> 
> [...]
> 
> > >  void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> > >  {
> > >  	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
> > >  
> > > +	/*
> > > +	 * If we see a permission fault at S1, then the fast path
> > > +	 * succeedded. By failing. Otherwise, take a walk on the wild
> > > +	 * side.
> > 
> > This is rather ambiguous. Maybe something along the lines would be more helpful:
> > 
> > 'If PAR_EL1 encodes a permission fault, we know for sure that the hardware
> > translation table walker was able to walk the stage 1 tables and there's nothing
> > else that KVM needs to do. On the other hand, if the AT instruction failed for
> > any other reason, then KVM must walk the guest stage 1 tables (and possibly the
> > virtual stage 2 tables) to emulate the instruction.'
> 
> Sure. I've adopted a slightly less verbose version of this:
> 
> @@ -930,9 +966,12 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
>  	u64 par = __kvm_at_s1e01_fast(vcpu, op, vaddr);
>  
>  	/*
> -	 * If we see a permission fault at S1, then the fast path
> -	 * succeedded. By failing. Otherwise, take a walk on the wild
> -	 * side.
> +	 * If PAR_EL1 reports that AT failed on a S1 permission fault, we
> +	 * know for sure that the PTW was able to walk the S1 tables and
> +	 * there's nothing else to do.
> +	 *
> +	 * If AT failed for any other reason, then we must walk the guest S1
> +	 * to emulate the instruction.

Looks good.

Thanks,
Alex

>  	 */
>  	if ((par & SYS_PAR_EL1_F) && !par_check_s1_perm_fault(par))
>  		par = handle_at_slow(vcpu, op, vaddr);
> 
> 
> I'll retest things over the weekend and post a new version early next
> week.
> 
> Thanks again for your review, this is awesome work!
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

