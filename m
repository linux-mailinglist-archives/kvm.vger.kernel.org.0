Return-Path: <kvm+bounces-65226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B821C9FF6D
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 17:29:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0A4B300DA4D
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 16:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D203557FA;
	Wed,  3 Dec 2025 16:17:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B1B3451DC
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 16:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778644; cv=none; b=POoW/6KMnOfumdT07v+Wr4tnZsN8V9QXBiWrfJVgGcczeJXXhdPsL7sRVG/aAmbQTlFm8FxI4heWYXNWoncQVAkGXvjN81EINa3eWnvKntTFz+6h2is0tfaAW0d/9nierAt/8K0IilkTr/PM22MW2+2hKcQxGtZor+KDFBK/gCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778644; c=relaxed/simple;
	bh=ZgDtOVPSWZyP+Yt2Ga3r9KRjbu/RrjqzEbQ1CwGz8Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qeORuEE7DOy12Uwp3gD1MgN05PKRbTpLdw7EWf99xHuRt53cEr9fIOBZU0TBfguSq9tq7TnX/0N1no5fK8AaymaaLzwhBjsZVd2l3M7hpy8DLZ2iahiziQnTQC0+xcu/N9gonFHcNuJ6C/4PrNChRLeiaPrw/r9uAlzoPJnL9eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB3D9339;
	Wed,  3 Dec 2025 08:17:14 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B99F93F66E;
	Wed,  3 Dec 2025 08:17:20 -0800 (PST)
Date: Wed, 3 Dec 2025 16:17:15 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 4/4] KVM: arm64: Convert VTCR_EL2 to config-driven
 sanitisation
Message-ID: <20251203161715.GA4187196@e124191.cambridge.arm.com>
References: <20251129144525.2609207-1-maz@kernel.org>
 <20251129144525.2609207-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129144525.2609207-5-maz@kernel.org>

Hi!

On Sat, Nov 29, 2025 at 02:45:25PM +0000, Marc Zyngier wrote:
> Describe all the VTCR_EL2 fields and their respective configurations,
> making sure that we correctly ignore the bits that are not defined
> for a given guest configuration.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 69 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/nested.c |  3 +-
>  2 files changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index a02c28d6a61c9..c36e133c51912 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -141,6 +141,7 @@ struct reg_feat_map_desc {
>  #define FEAT_AA64EL1		ID_AA64PFR0_EL1, EL1, IMP
>  #define FEAT_AA64EL2		ID_AA64PFR0_EL1, EL2, IMP
>  #define FEAT_AA64EL3		ID_AA64PFR0_EL1, EL3, IMP
> +#define FEAT_SEL2		ID_AA64PFR0_EL1, SEL2, IMP
>  #define FEAT_AIE		ID_AA64MMFR3_EL1, AIE, IMP
>  #define FEAT_S2POE		ID_AA64MMFR3_EL1, S2POE, IMP
>  #define FEAT_S1POE		ID_AA64MMFR3_EL1, S1POE, IMP
> @@ -202,6 +203,8 @@ struct reg_feat_map_desc {
>  #define FEAT_ASID2		ID_AA64MMFR4_EL1, ASID2, IMP
>  #define FEAT_MEC		ID_AA64MMFR3_EL1, MEC, IMP
>  #define FEAT_HAFT		ID_AA64MMFR1_EL1, HAFDBS, HAFT
> +#define FEAT_HDBSS		ID_AA64MMFR1_EL1, HAFDBS, HDBSS
> +#define FEAT_HPDS2		ID_AA64MMFR1_EL1, HPDS, HPDS2
>  #define FEAT_BTI		ID_AA64PFR1_EL1, BT, IMP
>  #define FEAT_ExS		ID_AA64MMFR0_EL1, EXS, IMP
>  #define FEAT_IESB		ID_AA64MMFR2_EL1, IESB, IMP
> @@ -219,6 +222,7 @@ struct reg_feat_map_desc {
>  #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
>  #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
>  #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
> +#define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
>  
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
> @@ -362,6 +366,28 @@ static bool feat_pmuv3p9(struct kvm *kvm)
>  	return check_pmu_revision(kvm, V3P9);
>  }
>  
> +#define has_feat_s2tgran(k, s)						\
> +  ((kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, TGRAN##s) && \
> +    !kvm_has_feat_enum(kvm, ID_AA64MMFR0_EL1, TGRAN##s, NI))	     ||	\
> +   kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN##s##_2, IMP))
> +
> +static bool feat_lpa2(struct kvm *kvm)
> +{
> +	return ((kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, 52_BIT)    ||
> +		 !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4, IMP))	&&
> +		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, 52_BIT)   ||
> +		 !kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16, IMP))	&&
> +		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN4_2, 52_BIT)  ||
> +		 !has_feat_s2tgran(kvm, 4))				&&
> +		(kvm_has_feat(kvm, ID_AA64MMFR0_EL1, TGRAN16_2, 52_BIT) ||
> +		 !has_feat_s2tgran(kvm, 16)));
> +}
> +
> +static bool feat_vmid16(struct kvm *kvm)
> +{
> +	return kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16);
> +}
> +
>  static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
>  {
>  	/* This is purely academic: AArch32 and NV are mutually exclusive */
> @@ -1168,6 +1194,44 @@ static const struct reg_bits_to_feat_map mdcr_el2_feat_map[] = {
>  static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
>  			      mdcr_el2_feat_map, FEAT_AA64EL2);
>  
> +static const struct reg_bits_to_feat_map vtcr_el2_feat_map[] = {
> +	NEEDS_FEAT(VTCR_EL2_HDBSS, FEAT_HDBSS),
> +	NEEDS_FEAT(VTCR_EL2_HAFT, FEAT_HAFT),
> +	NEEDS_FEAT(VTCR_EL2_TL0		|
> +		   VTCR_EL2_TL1		|
> +		   VTCR_EL2_AssuredOnly	|
> +		   VTCR_EL2_GCSH,
> +		   FEAT_THE),

The text for VTCR_EL2.AssuredOnly says:

	This field is RES0 when VTCR_EL2.D128 is 1.

> +	NEEDS_FEAT(VTCR_EL2_D128, FEAT_D128),
> +	NEEDS_FEAT(VTCR_EL2_S2POE, FEAT_S2POE),
> +	NEEDS_FEAT(VTCR_EL2_S2PIE, FEAT_S2PIE),

The text for VTCR_EL2.S2PIE says:

	This field is RES1 when VTCR_EL2.D128 is set.


Are these cases that need to be handled here somehow?

Thanks,
Joey


> +	NEEDS_FEAT(VTCR_EL2_SL2		|
> +		   VTCR_EL2_DS,
> +		   feat_lpa2),
> +	NEEDS_FEAT(VTCR_EL2_NSA		|
> +		   VTCR_EL2_NSW,
> +		   FEAT_SEL2),
> +	NEEDS_FEAT(VTCR_EL2_HWU62	|
> +		   VTCR_EL2_HWU61	|
> +		   VTCR_EL2_HWU60	|
> +		   VTCR_EL2_HWU59,
> +		   FEAT_HPDS2),
> +	NEEDS_FEAT(VTCR_EL2_HD, ID_AA64MMFR1_EL1, HAFDBS, DBM),
> +	NEEDS_FEAT(VTCR_EL2_HA, ID_AA64MMFR1_EL1, HAFDBS, AF),
> +	NEEDS_FEAT(VTCR_EL2_VS, feat_vmid16),
> +	NEEDS_FEAT(VTCR_EL2_PS		|
> +		   VTCR_EL2_TG0		|
> +		   VTCR_EL2_SH0		|
> +		   VTCR_EL2_ORGN0	|
> +		   VTCR_EL2_IRGN0	|
> +		   VTCR_EL2_SL0		|
> +		   VTCR_EL2_T0SZ,
> +		   FEAT_AA64EL1),
> +};
> +
> +static const DECLARE_FEAT_MAP(vtcr_el2_desc, VTCR_EL2,
> +			      vtcr_el2_feat_map, FEAT_AA64EL2);
> +
>  static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
>  				  int map_size, u64 res0, const char *str)
>  {
> @@ -1211,6 +1275,7 @@ void __init check_feature_map(void)
>  	check_reg_desc(&tcr2_el2_desc);
>  	check_reg_desc(&sctlr_el1_desc);
>  	check_reg_desc(&mdcr_el2_desc);
> +	check_reg_desc(&vtcr_el2_desc);
>  }
>  
>  static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map *map)
> @@ -1425,6 +1490,10 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
>  		*res0 = compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
>  		*res1 = MDCR_EL2_RES1;
>  		break;
> +	case VTCR_EL2:
> +		*res0 = compute_reg_res0_bits(kvm, &vtcr_el2_desc, 0, 0);
> +		*res1 = VTCR_EL2_RES1;
> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  		*res0 = *res1 = 0;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index e1ef8930c97b3..606cebcaa7c09 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1719,8 +1719,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
>  
>  	/* VTCR_EL2 */
> -	res0 = GENMASK(63, 32) | GENMASK(30, 20);
> -	res1 = BIT(31);
> +	get_reg_fixed_bits(kvm, VTCR_EL2, &res0, &res1);
>  	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
>  
>  	/* VMPIDR_EL2 */
> -- 
> 2.47.3
> 

