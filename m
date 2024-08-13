Return-Path: <kvm+bounces-23997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B75099506B7
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78ADE28A3D4
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 13:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D9419CCED;
	Tue, 13 Aug 2024 13:38:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFE319B5A3
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 13:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723556289; cv=none; b=mXhnVx3XxSOb+puAB6AsdsIxt2rioW0QcwE5EBeV7+NueJbdwIbBhriInpZvSLaHOm7wxOGFUj36kl9c6JEgvV2RVKl5LLugBkH/353M4uiNiVhUsri4WidsSl+NgX/WO9iYzKQywsKSn2pog2Vtb5H4EspQ42Kk5olhbZNmeL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723556289; c=relaxed/simple;
	bh=kVnKTGUyx186WH53rJ1bkIhT8F/92+Amrllr42j6lFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9AdGCeNxUUAImT1hL74K3OSIve0COHCLsr+psFHZcL7rxGZ8g8w5qOVVTjyuF0pgkkMm/KVitUXPA286mMbsE8fnIPnOyVFRQHFUQV3+xBBFITd0IPNZ9mhcZNdWKWDVR9uE/iRxCKoCqXv5Jg8Ccs59mwJkiGXT6pypqYmGW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E28112FC;
	Tue, 13 Aug 2024 06:38:33 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 234A93F6A8;
	Tue, 13 Aug 2024 06:38:06 -0700 (PDT)
Date: Tue, 13 Aug 2024 14:38:01 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 8/8] KVM: arm64: Expose ID_AA64PFR2_EL1 to userspace
 and guests
Message-ID: <20240813133801.GA3180143@e124191.cambridge.arm.com>
References: <20240813104400.1956132-1-maz@kernel.org>
 <20240813104400.1956132-9-maz@kernel.org>
 <20240813105710.GA3154421@e124191.cambridge.arm.com>
 <86y150zj0r.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y150zj0r.wl-maz@kernel.org>

On Tue, Aug 13, 2024 at 01:47:48PM +0100, Marc Zyngier wrote:
> On Tue, 13 Aug 2024 11:57:10 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > Hello!
> > 
> > On Tue, Aug 13, 2024 at 11:44:00AM +0100, Marc Zyngier wrote:
> > > Everything is now in place for a guest to "enjoy" FP8 support.
> > > Expose ID_AA64PFR2_EL1 to both userspace and guests, with the
> > > explicit restriction of only being able to clear FPMR.
> > > 
> > > All other features (MTE* at the time of writing) are hidden
> > > and not writable.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c | 16 +++++++++++++++-
> > >  1 file changed, 15 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 51627add0a72..da6d017f24a1 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -1722,6 +1722,15 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > >  	return val;
> > >  }
> > >  
> > > +static u64 read_sanitised_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
> > > +					  const struct sys_reg_desc *rd)
> > > +{
> > > +	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR2_EL1);
> > > +
> > > +	/* We only expose FPMR */
> > > +	return val & ID_AA64PFR2_EL1_FPMR;
> > > +}
> > 
> > Wondering why you're adding this function instead of extending __kvm_read_sanitised_id_reg()?
> >
> > > +
> > >  #define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
> > >  ({									       \
> > >  	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
> > > @@ -2381,7 +2390,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
> > >  		   ID_AA64PFR0_EL1_AdvSIMD |
> > >  		   ID_AA64PFR0_EL1_FP), },
> > >  	ID_SANITISED(ID_AA64PFR1_EL1),
> > > -	ID_UNALLOCATED(4,2),
> > > +	{ SYS_DESC(SYS_ID_AA64PFR2_EL1),
> > > +	  .access	= access_id_reg,
> > > +	  .get_user	= get_id_reg,
> > > +	  .set_user	= set_id_reg,
> > > +	  .reset	= read_sanitised_id_aa64pfr2_el1,
> > > +	  .val		= ID_AA64PFR2_EL1_FPMR, },
> > 
> > Then I think this would just be ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR).
> 
> Yeah, that's an interesting point. I'm afraid I have lost track of the
> many helpers that have been added over time.
> 
> Something like this?

LGTM!

> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index da6d017f24a1..2d1e45178422 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1539,6 +1539,10 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
>  
>  		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
>  		break;
> +	case SYS_ID_AA64PFR2_EL1:
> +		/* We only expose FPMR */
> +		val &= ID_AA64PFR2_EL1_FPMR;
> +		break;
>  	case SYS_ID_AA64ISAR1_EL1:
>  		if (!vcpu_has_ptrauth(vcpu))
>  			val &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA) |
> @@ -1722,15 +1726,6 @@ static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	return val;
>  }
>  
> -static u64 read_sanitised_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
> -					  const struct sys_reg_desc *rd)
> -{
> -	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR2_EL1);
> -
> -	/* We only expose FPMR */
> -	return val & ID_AA64PFR2_EL1_FPMR;
> -}
> -
>  #define ID_REG_LIMIT_FIELD_ENUM(val, reg, field, limit)			       \
>  ({									       \
>  	u64 __f_val = FIELD_GET(reg##_##field##_MASK, val);		       \
> @@ -2390,12 +2385,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  		   ID_AA64PFR0_EL1_AdvSIMD |
>  		   ID_AA64PFR0_EL1_FP), },
>  	ID_SANITISED(ID_AA64PFR1_EL1),
> -	{ SYS_DESC(SYS_ID_AA64PFR2_EL1),
> -	  .access	= access_id_reg,
> -	  .get_user	= get_id_reg,
> -	  .set_user	= set_id_reg,
> -	  .reset	= read_sanitised_id_aa64pfr2_el1,
> -	  .val		= ID_AA64PFR2_EL1_FPMR, },
> +	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
>  	ID_UNALLOCATED(4,3),
>  	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
>  	ID_HIDDEN(ID_AA64SMFR0_EL1),
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

