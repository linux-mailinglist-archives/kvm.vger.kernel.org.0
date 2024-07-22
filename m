Return-Path: <kvm+bounces-22041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BB2938D8E
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 12:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00B9E1C212F1
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 10:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0DAD20328;
	Mon, 22 Jul 2024 10:33:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FF7A3234
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 10:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721644435; cv=none; b=bzVmKhOn6kX4TT+w6MkyQ9MsHZMwHPbUd/JEOnqSxx4qU4Afehdw/NFt0m5lvlote9ddl0SrYz/SI3g18HUROk1fG6RDdsxYlkFCfe15gIK1jkLywmmiutvs2gkCgh/qdlBh+X4GONq4Rne9+kSFkLUGc0fKXWOISHTAUPCQI94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721644435; c=relaxed/simple;
	bh=YHxUCRUsk85K0ieiDXFCb61wvJ4brkmrpbD4amGp3JY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n0nla+ksp1ytQD1XmQQ5LQtEuMvBRYEwXtAiLJkrbs+bprWFZkWL78HERl/MwqaBrNWpG3sfobaHl3iz5k+2eaDMEne1P4A0pYSnZhHYBTNZCcFyE8SD5tldBtEOc1yXUo70w/R0oYxUwpk7cW+rZmJfjE4RQdtxqY3I/XCZIwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5658FEC;
	Mon, 22 Jul 2024 03:34:17 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF3B43F73F;
	Mon, 22 Jul 2024 03:33:50 -0700 (PDT)
Date: Mon, 22 Jul 2024 11:33:47 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 08/12] KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
Message-ID: <Zp41i__E3X_cFRqp@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <20240625133508.259829-9-maz@kernel.org>
 <ZpkwXFrhcFB1x0nD@raptor>
 <878qxw5r6e.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qxw5r6e.wl-maz@kernel.org>

Hi,

On Sat, Jul 20, 2024 at 10:49:29AM +0100, Marc Zyngier wrote:
> On Thu, 18 Jul 2024 16:10:20 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > On Tue, Jun 25, 2024 at 02:35:07PM +0100, Marc Zyngier wrote:
> > > On the face of it, AT S12E{0,1}{R,W} is pretty simple. It is the
> > > combination of AT S1E{0,1}{R,W}, followed by an extra S2 walk.
> > > 
> > > However, there is a great deal of complexity coming from combining
> > > the S1 and S2 attributes to report something consistent in PAR_EL1.
> > > 
> > > This is an absolute mine field, and I have a splitting headache.
> > > 
> > > [..]
> > > +static u8 compute_sh(u8 attr, u64 desc)
> > > +{
> > > +	/* Any form of device, as well as NC has SH[1:0]=0b10 */
> > > +	if (MEMATTR_IS_DEVICE(attr) || attr == MEMATTR(NC, NC))
> > > +		return 0b10;
> > > +
> > > +	return FIELD_GET(PTE_SHARED, desc) == 0b11 ? 0b11 : 0b10;
> > 
> > If shareability is 0b00 (non-shareable), the PAR_EL1.SH field will be 0b10
> > (outer-shareable), which seems to be contradicting PAREncodeShareability().
> 
> Yup, well caught.
> 
> > > +	par |= FIELD_PREP(SYS_PAR_EL1_SH,
> > > +			  compute_sh(final_attr, tr->desc));
> > > +
> > > +	return par;
> > >
> > 
> > It seems that the code doesn't combine shareability attributes, as per rule
> > RGDTNP and S2CombineS1MemAttrs() or S2ApplyFWBMemAttrs(), which both end up
> > calling S2CombineS1Shareability().
> 
> That as well. See below what I'm stashing on top.
> 
> Thanks,
> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index e66c97fc1fd3..28c4344d1c34 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -459,13 +459,34 @@ static u8 combine_s1_s2_attr(u8 s1, u8 s2)
>  	return final;
>  }
>  
> +#define ATTR_NSH	0b00
> +#define ATTR_RSV	0b01
> +#define ATTR_OSH	0b10
> +#define ATTR_ISH	0b11

Matches Table D8-89 from DDI 0487K.a.

> +
>  static u8 compute_sh(u8 attr, u64 desc)
>  {
> +	u8 sh;
> +
>  	/* Any form of device, as well as NC has SH[1:0]=0b10 */
>  	if (MEMATTR_IS_DEVICE(attr) || attr == MEMATTR(NC, NC))
> -		return 0b10;
> +		return ATTR_OSH;
> +
> +	sh = FIELD_GET(PTE_SHARED, desc);
> +	if (sh == ATTR_RSV)		/* Reserved, mapped to NSH */
> +		sh = ATTR_NSH;
> +
> +	return sh;
> +}

Matches PAREncodeShareability().

> +
> +static u8 combine_sh(u8 s1_sh, u8 s2_sh)
> +{
> +	if (s1_sh == ATTR_OSH || s2_sh == ATTR_OSH)
> +		return ATTR_OSH;
> +	if (s1_sh == ATTR_ISH || s2_sh == ATTR_ISH)
> +		return ATTR_ISH;
>  
> -	return FIELD_GET(PTE_SHARED, desc) == 0b11 ? 0b11 : 0b10;
> +	return ATTR_NSH;
>  }

Matches S2CombineS1Shareability().

>  
>  static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
> @@ -540,7 +561,8 @@ static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
>  	par  = FIELD_PREP(SYS_PAR_EL1_ATTR, final_attr);
>  	par |= tr->output & GENMASK(47, 12);
>  	par |= FIELD_PREP(SYS_PAR_EL1_SH,
> -			  compute_sh(final_attr, tr->desc));
> +			  combine_sh(FIELD_GET(SYS_PAR_EL1_SH, s1_par),
> +				     compute_sh(final_attr, tr->desc)));

Looks good.

Thanks,
Alex

>  
>  	return par;
>  }
> 
> -- 
> Without deviation from the norm, progress is not possible.

