Return-Path: <kvm+bounces-23953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1880950114
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 11:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BB781F221E3
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 09:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902A0170A24;
	Tue, 13 Aug 2024 09:17:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04F0339A1
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 09:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723540654; cv=none; b=WfpjhsUEXWFh3EHVHJCrNOtFxl94yHoHdTc+sHAeF/FobsUWqA7wYO9vnivc9Olsl2Ba/Tl8y+AcucajcjIJrxe6PwJhXoPUvrlSFDOI+vGwiUlFhOF+OgIggYiglZ/TQmpwDUG89b8UZB1OnN917PrSU36b4Wxj2C2xynqNEHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723540654; c=relaxed/simple;
	bh=ZqjwqbtEbJdz0EI/ONsVhvlf8aUL8C4HoEu8grOYelU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6kxo/pb/aOj3yvVPfU7jke8aG7Fhts+P7VUWi8sb8fLzu50Slmbh9OLXbHjffTJR9vHkFflES+DAlaAo4+oSwFlfWaAHa57+9lgwkUj/lvQBO0bJxJ09wPOoCdmZ76K4mMwmAxqF4CIFBbmUIUAkAvSMY0Rl9HvMeud8d33FcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B9C212FC;
	Tue, 13 Aug 2024 02:17:57 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BCAA3F73B;
	Tue, 13 Aug 2024 02:17:29 -0700 (PDT)
Date: Tue, 13 Aug 2024 10:17:26 +0100
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
Message-ID: <ZrskpqmkoLNVE2H4@raptor>
References: <20240731194030.1991237-1-maz@kernel.org>
 <20240731194030.1991237-14-maz@kernel.org>
 <ZrYO9SK52rHhGvEd@arm.com>
 <867cco1y4w.wl-maz@kernel.org>
 <ZromBtfbjaHbcjT7@arm.com>
 <8634n91v3z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634n91v3z.wl-maz@kernel.org>

Hi Marc,

On Mon, Aug 12, 2024 at 06:58:24PM +0100, Marc Zyngier wrote:
> Hi Alex,
> 
> On Mon, 12 Aug 2024 16:11:02 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Sat, Aug 10, 2024 at 11:16:15AM +0100, Marc Zyngier wrote:
> > > Hi Alex,
> > > 
> > > @@ -136,12 +137,22 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
> > >  	va = (u64)sign_extend64(va, 55);
> > >  
> > >  	/* Let's put the MMU disabled case aside immediately */
> > > -	if (!(sctlr & SCTLR_ELx_M) ||
> > > -	    (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)) {
> > > +	switch (wi->regime) {
> > > +	case TR_EL10:
> > > +		if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)
> > > +			wr->level = S1_MMU_DISABLED;
> > 
> > In compute_translation_regime(), for AT instructions other than AT S1E2*, when
> > {E2H,TGE} = {0,1}, regime is Regime_EL10. As far as I can tell, when regime is
> > Regime_EL10 and TGE is set, stage 1 is disabled, according to
> > AArch64.S1Enabled() and the decription of the TGE bit.
> 
> Grmbl... I really dislike E2H=0. May it die a painful death. How about
> this on top?
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 10017d990bc3..870e77266f80 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -139,7 +139,19 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  	/* Let's put the MMU disabled case aside immediately */
>  	switch (wi->regime) {
>  	case TR_EL10:
> -		if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_DC)
> +		/*
> +		 * If dealing with the EL1&0 translation regime, 3 things
> +		 * can disable the S1 translation:
> +		 *
> +		 * - HCR_EL2.DC = 0
> +		 * - HCR_EL2.{E2H,TGE} = {0,1}
> +		 * - SCTLR_EL1.M = 0
> +		 *
> +		 * The TGE part is interesting. If we have decided that this
> +		 * is EL1&0, then it means that either {E2H,TGE} == {1,0} or
> +		 * {0,x}, and we only need to test for TGE == 1.
> +		 */
> +		if (__vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_DC | HCR_TGE))
>  			wr->level = S1_MMU_DISABLED;

The condition looks good now.

>  		fallthrough;
>  	case TR_EL2:
> 
> [...]
> 
> >
> > 	switch (desc & GENMASK_ULL(1, 0)) {
> > 	case 0b00:
> > 	case 0b10:
> > 		goto transfault;
> > 	case 0b01:
> > 		/* Block mapping */
> > 		break;
> > 	default:
> > 		if (level == 3)
> > 			break;
> > 	}
> > 
> > Is this better? Perhaps slightly easier to match against the descriptor layouts,
> > but I'm not sure it's an improvement over your suggestion. Up to you, no point
> > in bikeshedding over it.
> 
> I think I'll leave it as is for now. I'm getting sick of this code...

Agreed!

Thanks,
Alex

