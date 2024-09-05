Return-Path: <kvm+bounces-25956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2631496DAF7
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 15:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 449E51C24902
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 13:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E6319DF5B;
	Thu,  5 Sep 2024 13:58:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A76019C579
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725544709; cv=none; b=SHEm+3nDI40AM0k/tDb3DxtW+pWtHjdJksIeS17vlGmEJAesrhflSAFGdyDocoTr5sEd9x5sgZwRU3/iHqgGvaPnW/u9FwbQXpVWhq/t1vHwf8u9vFX6pV09IeBEnd8DoRppoQVBsZHiC/oaY8gpKPagmCQPCCxUFxXTS59MBMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725544709; c=relaxed/simple;
	bh=a5Kk3x/Tvcg3X5Q0R0DgBGxKuFTS9FJU13+dfqvRM+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMNZ7Da6MYb25PZs7w3F/7BCtfE0M5vPL+EUrpgpa36Yd891ziKq9K5ozBLrzfkm83ofd/scKztcE08wzIz9wBDxdAR2lOiVQ0pJ0rtVoDCiwTET3gYgc3+V/kAI7EO63Y8eGZ9QGPLX//2ZQYe733zV1DBV1K0UUXXXEnnP4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61916FEC;
	Thu,  5 Sep 2024 06:58:53 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CAF53F73F;
	Thu,  5 Sep 2024 06:58:25 -0700 (PDT)
Date: Thu, 5 Sep 2024 14:58:20 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 12/16] KVM: arm64: Implement AT S1PIE support
Message-ID: <20240905135820.GA4142389@e124191.cambridge.arm.com>
References: <20240903153834.1909472-1-maz@kernel.org>
 <20240903153834.1909472-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903153834.1909472-13-maz@kernel.org>

Hello Marc!

On Tue, Sep 03, 2024 at 04:38:30PM +0100, Marc Zyngier wrote:
> It doesn't take much effort to imple,emt S1PIE support in AT.
> This is only a matter of using the AArch64.S1IndirectBasePermissions()
> encodings for the permission, ignoring GCS which has no impact on AT,
> and enforce FEAT_PAN3 being enabled as this is a requirement of
> FEAT_S1PIE.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 136 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 135 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 68f5b89598ec..bd7e1b32b049 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -736,6 +736,23 @@ static u64 compute_par_s1(struct kvm_vcpu *vcpu, struct s1_walk_result *wr,
>  	return par;
>  }
>  
> +static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
> +{
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> +		return false;
> +
> +	switch (regime) {
> +	case TR_EL2:
> +	case TR_EL20:
> +		return __vcpu_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
> +	case TR_EL10:
> +		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
> +			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1x_PIE);
> +	default:
> +		BUG();
> +	}
> +}
> +
>  static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  {
>  	u64 sctlr;
> @@ -743,6 +760,9 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
>  		return false;
>  
> +	if (s1pie_enabled(vcpu, regime))
> +		return true;
> +
>  	if (regime == TR_EL10)
>  		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>  	else
> @@ -826,12 +846,126 @@ static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +#define pi_idx(v, r, i)	((__vcpu_sys_reg((v), (r)) >> ((i) * 4)) & 0xf)
> +
> +#define set_priv_perms(p, r, w, x)	\
> +	do {				\
> +		(p)->pr = (r);		\
> +		(p)->pw = (w);		\
> +		(p)->px = (x);		\
> +	} while (0)
> +
> +#define set_unpriv_perms(p, r, w, x)	\
> +	do {				\
> +		(p)->ur = (r);		\
> +		(p)->uw = (w);		\
> +		(p)->ux = (x);		\
> +	} while (0)
> +
> +/* Similar to AArch64.S1IndirectBasePermissions(), without GCS  */
> +#define set_perms(w, p, ip)						\
> +	do {								\
> +		switch ((ip)) {						\
> +		case 0b0000:						\
> +			set_ ## w ## _perms((p), false, false, false);	\
> +			break;						\
> +		case 0b0001:						\
> +			set_ ## w ## _perms((p), true , false, false);	\
> +			break;						\
> +		case 0b0010:						\
> +			set_ ## w ## _perms((p), false, false, true );	\
> +			break;						\
> +		case 0b0011:						\
> +			set_ ## w ## _perms((p), true , false, true );	\
> +			break;						\
> +		case 0b0100:						\
> +			set_ ## w ## _perms((p), false, false, false);	\
> +			break;						\
> +		case 0b0101:						\
> +			set_ ## w ## _perms((p), true , true , false);	\
> +			break;						\
> +		case 0b0110:						\
> +			set_ ## w ## _perms((p), true , true , true );	\
> +			break;						\
> +		case 0b0111:						\
> +			set_ ## w ## _perms((p), true , true , true );	\
> +			break;						\
> +		case 0b1000:						\
> +			set_ ## w ## _perms((p), true , false, false);	\
> +			break;						\
> +		case 0b1001:						\
> +			set_ ## w ## _perms((p), true , false, false);	\
> +			break;						\
> +		case 0b1010:						\
> +			set_ ## w ## _perms((p), true , false, true );	\
> +			break;						\
> +		case 0b1011:						\
> +			set_ ## w ## _perms((p), false, false, false);	\
> +			break;						\
> +		case 0b1100:						\
> +			set_ ## w ## _perms((p), true , true , false);	\
> +			break;						\
> +		case 0b1101:						\
> +			set_ ## w ## _perms((p), false, false, false);	\
> +			break;						\
> +		case 0b1110:						\
> +			set_ ## w ## _perms((p), true , true , true );	\
> +			break;						\
> +		case 0b1111:						\
> +			set_ ## w ## _perms((p), false, false, false);	\
> +			break;						\
> +		}							\
> +	} while (0)
> +
> +static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
> +					    struct s1_walk_info *wi,
> +					    struct s1_walk_result *wr,
> +					    struct s1_perms *s1p)
> +{
> +	u8 up, pp, idx;
> +
> +	idx = (FIELD_GET(GENMASK(54, 53), wr->desc) << 2	|
> +	       FIELD_GET(BIT(51), wr->desc) << 1		|
> +	       FIELD_GET(BIT(6), wr->desc));
> +
> +	switch (wi->regime) {
> +	case TR_EL10:
> +		pp = pi_idx(vcpu, PIR_EL1, idx);
> +		up = pi_idx(vcpu, PIRE0_EL1, idx);
> +		break;
> +	case TR_EL20:
> +		pp = pi_idx(vcpu, PIR_EL2, idx);
> +		up = pi_idx(vcpu, PIRE0_EL2, idx);
> +		break;
> +	case TR_EL2:
> +		pp = pi_idx(vcpu, PIR_EL2, idx);
> +		up = 0;
> +		break;
> +	}
> +
> +	set_perms(priv, s1p, pp);
> +
> +	if (wi->regime != TR_EL2)
> +		set_perms(unpriv, s1p, up);
> +	else
> +		set_unpriv_perms(s1p, false, false, false);
> +
> +	if (s1p->px && s1p->uw) {
> +		set_priv_perms(s1p, false, false, false);
> +		set_unpriv_perms(s1p, false, false, false);
> +	}
> +}
> +
>  static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
>  				   struct s1_walk_info *wi,
>  				   struct s1_walk_result *wr,
>  				   struct s1_perms *s1p)
>  {
> -	compute_s1_direct_permissions(vcpu, wi, wr, s1p);
> +	if (!s1pie_enabled(vcpu, wi->regime))
> +		compute_s1_direct_permissions(vcpu, wi, wr, s1p);
> +	else
> +		compute_s1_indirect_permissions(vcpu, wi, wr, s1p);
> +
>  	compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);

Is this (and the previous patch to split this up) right?

Looking at this from the ARM ARM (ARM DDI 0487K.a):

	R JHSVW If Indirect permissions are used, then hierarchical permissions are disabled and TCR_ELx.HPDn are RES 1.

>  
>  	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
> -- 

Thanks,
Joey

