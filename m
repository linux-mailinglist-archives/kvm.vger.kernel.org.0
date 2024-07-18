Return-Path: <kvm+bounces-21850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11AF6934FAC
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 17:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 429231C2176C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 15:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAB9143C57;
	Thu, 18 Jul 2024 15:10:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1202A8FE
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 15:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721315426; cv=none; b=eBMxiLKFoYyK0wShOZwrN3XHUdnjj8vfRDwsDKA2IH+9vw49aSNHmRa7m/GiIhyx/7z28CLv11L14kQLokIgniYjMLWerWSh2Quae+gyCQ47xgVaNoXzt+qWKo5F3dJEbL8YcN0BXmWnqKHUE6Dofo5/MAVpFxFvz8g9vrhjOcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721315426; c=relaxed/simple;
	bh=WGYNHPXWp7bNCl/NKAUw10+3Y1i3zunxegYKvpUtx0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEOCEDs8vbCbLNxdGNn8ODzhLzRZUoek6NknG6MikcSWhokTlJXmpGEHn3oAc0MxpWzlIBY6nU4GQyZbDVs1R/7UJQx719GFRQgbIKgeeWG4gSAoYx+9kuBdoVcatgUugIyfAT3ufbz7gzyhmRUifx5TvzEDChSksPgzGGTkI9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C52061063;
	Thu, 18 Jul 2024 08:10:49 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 140533F762;
	Thu, 18 Jul 2024 08:10:22 -0700 (PDT)
Date: Thu, 18 Jul 2024 16:10:20 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 08/12] KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
Message-ID: <ZpkwXFrhcFB1x0nD@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240625133508.259829-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625133508.259829-9-maz@kernel.org>

Hi,

On Tue, Jun 25, 2024 at 02:35:07PM +0100, Marc Zyngier wrote:
> On the face of it, AT S12E{0,1}{R,W} is pretty simple. It is the
> combination of AT S1E{0,1}{R,W}, followed by an extra S2 walk.
> 
> However, there is a great deal of complexity coming from combining
> the S1 and S2 attributes to report something consistent in PAR_EL1.
> 
> This is an absolute mine field, and I have a splitting headache.
> 
> [..]
> +static u8 compute_sh(u8 attr, u64 desc)
> +{
> +	/* Any form of device, as well as NC has SH[1:0]=0b10 */
> +	if (MEMATTR_IS_DEVICE(attr) || attr == MEMATTR(NC, NC))
> +		return 0b10;
> +
> +	return FIELD_GET(PTE_SHARED, desc) == 0b11 ? 0b11 : 0b10;

If shareability is 0b00 (non-shareable), the PAR_EL1.SH field will be 0b10
(outer-shareable), which seems to be contradicting PAREncodeShareability().

> +}
> +
> +static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
> +			   struct kvm_s2_trans *tr)
> +{
> +	u8 s1_parattr, s2_memattr, final_attr;
> +	u64 par;
> +
> +	/* If S2 has failed to translate, report the damage */
> +	if (tr->esr) {
> +		par = SYS_PAR_EL1_RES1;
> +		par |= SYS_PAR_EL1_F;
> +		par |= SYS_PAR_EL1_S;
> +		par |= FIELD_PREP(SYS_PAR_EL1_FST, tr->esr);
> +		return par;
> +	}
> +
> +	s1_parattr = FIELD_GET(SYS_PAR_EL1_ATTR, s1_par);
> +	s2_memattr = FIELD_GET(GENMASK(5, 2), tr->desc);
> +
> +	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_FWB) {
> +		if (!kvm_has_feat(vcpu->kvm, ID_AA64PFR2_EL1, MTEPERM, IMP))
> +			s2_memattr &= ~BIT(3);
> +
> +		/* Combination of R_VRJSW and R_RHWZM */
> +		switch (s2_memattr) {
> +		case 0b0101:
> +			if (MEMATTR_IS_DEVICE(s1_parattr))
> +				final_attr = s1_parattr;
> +			else
> +				final_attr = MEMATTR(NC, NC);
> +			break;
> +		case 0b0110:
> +		case 0b1110:
> +			final_attr = MEMATTR(WbRaWa, WbRaWa);
> +			break;
> +		case 0b0111:
> +		case 0b1111:
> +			/* Preserve S1 attribute */
> +			final_attr = s1_parattr;
> +			break;
> +		case 0b0100:
> +		case 0b1100:
> +		case 0b1101:
> +			/* Reserved, do something non-silly */
> +			final_attr = s1_parattr;
> +			break;
> +		default:
> +			/* MemAttr[2]=0, Device from S2 */
> +			final_attr = s2_memattr & GENMASK(1,0) << 2;
> +		}
> +	} else {
> +		/* Combination of R_HMNDG, R_TNHFM and R_GQFSF */
> +		u8 s2_parattr = s2_memattr_to_attr(s2_memattr);
> +
> +		if (MEMATTR_IS_DEVICE(s1_parattr) ||
> +		    MEMATTR_IS_DEVICE(s2_parattr)) {
> +			final_attr = min(s1_parattr, s2_parattr);
> +		} else {
> +			/* At this stage, this is memory vs memory */
> +			final_attr  = combine_s1_s2_attr(s1_parattr & 0xf,
> +							 s2_parattr & 0xf);
> +			final_attr |= combine_s1_s2_attr(s1_parattr >> 4,
> +							 s2_parattr >> 4) << 4;
> +		}
> +	}
> +
> +	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_CD) &&
> +	    !MEMATTR_IS_DEVICE(final_attr))
> +		final_attr = MEMATTR(NC, NC);
> +
> +	par  = FIELD_PREP(SYS_PAR_EL1_ATTR, final_attr);
> +	par |= tr->output & GENMASK(47, 12);
> +	par |= FIELD_PREP(SYS_PAR_EL1_SH,
> +			  compute_sh(final_attr, tr->desc));
> +
> +	return par;
>

It seems that the code doesn't combine shareability attributes, as per rule
RGDTNP and S2CombineS1MemAttrs() or S2ApplyFWBMemAttrs(), which both end up
calling S2CombineS1Shareability().

Thanks,
Alex

