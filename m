Return-Path: <kvm+bounces-29645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2697D9AE710
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D77502825E9
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271AB1DDA16;
	Thu, 24 Oct 2024 13:59:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404CF50285
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729778371; cv=none; b=e+aOWdyn0P98vaN4o6RSEuKKfDBn8Gep28X0QlRPZRcWtuLtJgFs4Qms5Kb8UNhXM79847BJg73+WrT6s7n8+yGwBSRSfqEm7hLtYNcOqdpXBnVtevC39rGOLlrP06ZcDyxcO/Lemg5hNmPP79IEMjB3KbtzKVo6lhnmoUG7aHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729778371; c=relaxed/simple;
	bh=ZCs8NZrG1PZqGSMXOAAbIBT/deWX0tKVAmSjgBE8wU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kx9QkzQ4rkrR1DDZcrehmmeVFA4VHfrrxsp5atlWb+98H6RtY3dnbBCUF1xv4KCU+I3X6ROmILmdpceVtj3HX3rVvj7XR5p2gA+oduNGteGV8On18G59BX6gg56EJs3jcCQLxUxDDD9Zpf2g0n3YbyxRT5SPA6m/N4bjPLi+Qjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EBA2339;
	Thu, 24 Oct 2024 06:59:58 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72FAB3F528;
	Thu, 24 Oct 2024 06:59:27 -0700 (PDT)
Date: Thu, 24 Oct 2024 14:59:25 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 21/37] KVM: arm64: Implement AT S1PIE support
Message-ID: <20241024135925.GB1403933@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-22-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-22-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:29PM +0100, Marc Zyngier wrote:
> It doesn't take much effort to implement S1PIE support in AT.
> 
> It is only a matter of using the AArch64.S1IndirectBasePermissions()
> encodings for the permission, ignoring GCS which has no impact on AT,
> and enforce FEAT_PAN3 being enabled as this is a requirement of
> FEAT_S1PIE.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 117 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 116 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index f5bd750288ff5..3d93ed1795603 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -781,6 +781,9 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
>  		return false;
>  
> +	if (s1pie_enabled(vcpu, regime))
> +		return true;
> +
>  	if (regime == TR_EL10)
>  		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>  	else
> @@ -862,11 +865,123 @@ static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +#define perm_idx(v, r, i)	((vcpu_read_sys_reg((v), (r)) >> ((i) * 4)) & 0xf)
> +
> +#define set_priv_perms(wr, r, w, x)	\
> +	do {				\
> +		(wr)->pr = (r);		\
> +		(wr)->pw = (w);		\
> +		(wr)->px = (x);		\
> +	} while (0)
> +
> +#define set_unpriv_perms(wr, r, w, x)	\
> +	do {				\
> +		(wr)->ur = (r);		\
> +		(wr)->uw = (w);		\
> +		(wr)->ux = (x);		\
> +	} while (0)
> +
> +/* Similar to AArch64.S1IndirectBasePermissions(), without GCS  */
> +#define set_perms(w, wr, ip)						\
> +	do {								\
> +		/* R_LLZDZ */						\
> +		switch ((ip)) {						\
> +		case 0b0000:						\
> +			set_ ## w ## _perms((wr), false, false, false);	\
> +			break;						\
> +		case 0b0001:						\
> +			set_ ## w ## _perms((wr), true , false, false);	\
> +			break;						\
> +		case 0b0010:						\
> +			set_ ## w ## _perms((wr), false, false, true );	\
> +			break;						\
> +		case 0b0011:						\
> +			set_ ## w ## _perms((wr), true , false, true );	\
> +			break;						\
> +		case 0b0100:						\
> +			set_ ## w ## _perms((wr), false, false, false);	\
> +			break;						\
> +		case 0b0101:						\
> +			set_ ## w ## _perms((wr), true , true , false);	\
> +			break;						\
> +		case 0b0110:						\
> +			set_ ## w ## _perms((wr), true , true , true );	\
> +			break;						\
> +		case 0b0111:						\
> +			set_ ## w ## _perms((wr), true , true , true );	\
> +			break;						\
> +		case 0b1000:						\
> +			set_ ## w ## _perms((wr), true , false, false);	\
> +			break;						\
> +		case 0b1001:						\
> +			set_ ## w ## _perms((wr), true , false, false);	\
> +			break;						\
> +		case 0b1010:						\
> +			set_ ## w ## _perms((wr), true , false, true );	\
> +			break;						\
> +		case 0b1011:						\
> +			set_ ## w ## _perms((wr), false, false, false);	\
> +			break;						\
> +		case 0b1100:						\
> +			set_ ## w ## _perms((wr), true , true , false);	\
> +			break;						\
> +		case 0b1101:						\
> +			set_ ## w ## _perms((wr), false, false, false);	\
> +			break;						\
> +		case 0b1110:						\
> +			set_ ## w ## _perms((wr), true , true , true );	\
> +			break;						\
> +		case 0b1111:						\
> +			set_ ## w ## _perms((wr), false, false, false);	\
> +			break;						\
> +		}							\
> +	} while (0)
> +
> +static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
> +					    struct s1_walk_info *wi,
> +					    struct s1_walk_result *wr)
> +{
> +	u8 up, pp, idx;
> +
> +	idx = pte_pi_index(wr->desc);
> +
> +	switch (wi->regime) {
> +	case TR_EL10:
> +		pp = perm_idx(vcpu, PIR_EL1, idx);
> +		up = perm_idx(vcpu, PIRE0_EL1, idx);
> +		break;
> +	case TR_EL20:
> +		pp = perm_idx(vcpu, PIR_EL2, idx);
> +		up = perm_idx(vcpu, PIRE0_EL2, idx);
> +		break;
> +	case TR_EL2:
> +		pp = perm_idx(vcpu, PIR_EL2, idx);
> +		up = 0;
> +		break;
> +	}

There seems to be inconsistent use of

default:
	BUG();

when switching on wi->regime.

> +
> +	set_perms(priv, wr, pp);
> +
> +	if (wi->regime != TR_EL2)
> +		set_perms(unpriv, wr, up);
> +	else
> +		set_unpriv_perms(wr, false, false, false);

When regime == TR_EL2, up == 0, so the if/else should do the same thing? Maybe
you've done that intentionally to be more explicit.

Either way:

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> +
> +	/* R_VFPJF */
> +	if (wr->px && wr->uw) {
> +		set_priv_perms(wr, false, false, false);
> +		set_unpriv_perms(wr, false, false, false);
> +	}
> +}
> +
>  static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
>  				   struct s1_walk_info *wi,
>  				   struct s1_walk_result *wr)
>  {
> -	compute_s1_direct_permissions(vcpu, wi, wr);
> +	if (!s1pie_enabled(vcpu, wi->regime))
> +		compute_s1_direct_permissions(vcpu, wi, wr);
> +	else
> +		compute_s1_indirect_permissions(vcpu, wi, wr);
>  
>  	if (!wi->hpd)
>  		compute_s1_hierarchical_permissions(vcpu, wi, wr);

Thanks,
Joey

