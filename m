Return-Path: <kvm+bounces-46696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2EBAB8A8A
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7A1F1889C2E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE662153E1;
	Thu, 15 May 2025 15:24:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E6B2135A0
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747322679; cv=none; b=levVW0tDR2DQmg7YnEoW6ps6F3/3s9nb5qnerk6RFJ97Cs5icduCSfJimMDLD3WISDfNjjUxSLYUYYuw6VmngAcGAVy505Q5GztaJeI0HG1lvTfmbYXOmnk7S+K5npWmilXlz4OsmLdikYazZolxZ8R3fhksprk/0JyoKWdSiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747322679; c=relaxed/simple;
	bh=wh8yNL1oUHMYv1DqQxCXEvfYNwpJOTk46IC/ffSc8kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nidcm0+3b+X7n/B5E6wviIpfu+l5AGbDzC50z3fFDBdozYNq+QWJxzM0daebv4e34FsB8hDJb9sa4KmH0hBIJFe0CCVS+3MlKiqV2c4QmT9Px45BqbHE3LGw2Pxile+Drx95OihHm2sPwMueowkUNHMB9vKXJgmbR8z0e/KXFaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C55C14BF;
	Thu, 15 May 2025 08:24:23 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 308353F673;
	Thu, 15 May 2025 08:24:33 -0700 (PDT)
Date: Thu, 15 May 2025 16:24:27 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v4 33/43] KVM: arm64: Use FGT feature maps to drive RES0
 bits
Message-ID: <20250515152427.GA118636@e124191.cambridge.arm.com>
References: <20250506164348.346001-1-maz@kernel.org>
 <20250506164348.346001-34-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506164348.346001-34-maz@kernel.org>

On Tue, May 06, 2025 at 05:43:38PM +0100, Marc Zyngier wrote:
> Another benefit of mapping bits to features is that it becomes trivial
> to define which bits should be handled as RES0.
> 
> Let's apply this principle to the guest's view of the FGT registers.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   1 +
>  arch/arm64/kvm/config.c           |  46 +++++++++++
>  arch/arm64/kvm/nested.c           | 129 +++---------------------------
>  3 files changed, 57 insertions(+), 119 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 59bfb049ce987..0eff513167868 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1611,6 +1611,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
>  
>  void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
> +void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64*res1);

nit: u64* res1

>  void check_feature_map(void);
>  
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 242c82eefd5e4..388f207bf64f6 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -616,3 +616,49 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>  
>  	kvm->arch.fgu[fgt] = val;
>  }
> +
> +void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1)
> +{
> +	switch (reg) {
> +	case HFGRTR_EL2:
> +		*res0 = compute_res0_bits(kvm, hfgrtr_feat_map,
> +					  ARRAY_SIZE(hfgrtr_feat_map), 0, 0);
> +		*res0 |= hfgrtr_masks.res0;
> +		*res1 = HFGRTR_EL2_RES1;
> +		break;
> +	case HFGWTR_EL2:
> +		*res0 = compute_res0_bits(kvm, hfgwtr_feat_map,
> +					  ARRAY_SIZE(hfgwtr_feat_map), 0, 0);
> +		*res0 |= hfgwtr_masks.res0;
> +		*res1 = HFGWTR_EL2_RES1;
> +		break;
> +	case HFGITR_EL2:
> +		*res0 = compute_res0_bits(kvm, hfgitr_feat_map,
> +					  ARRAY_SIZE(hfgitr_feat_map), 0, 0);
> +		*res0 |= hfgitr_masks.res0;
> +		*res1 = HFGITR_EL2_RES1;
> +		break;
> +	case HDFGRTR_EL2:
> +		*res0 = compute_res0_bits(kvm, hdfgrtr_feat_map,
> +					  ARRAY_SIZE(hdfgrtr_feat_map), 0, 0);
> +		*res0 |= hdfgrtr_masks.res0;
> +		*res1 = HDFGRTR_EL2_RES1;
> +		break;
> +	case HDFGWTR_EL2:
> +		*res0 = compute_res0_bits(kvm, hdfgwtr_feat_map,
> +					  ARRAY_SIZE(hdfgwtr_feat_map), 0, 0);
> +		*res0 |= hdfgwtr_masks.res0;
> +		*res1 = HDFGWTR_EL2_RES1;
> +		break;
> +	case HAFGRTR_EL2:
> +		*res0 = compute_res0_bits(kvm, hafgrtr_feat_map,
> +					  ARRAY_SIZE(hafgrtr_feat_map), 0, 0);
> +		*res0 |= hafgrtr_masks.res0;
> +		*res1 = HAFGRTR_EL2_RES1;
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		*res0 = *res1 = 0;
> +		break;
> +	}
> +}
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 666df85230c9b..3d91a0233652b 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1100,132 +1100,23 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	set_sysreg_masks(kvm, HCRX_EL2, res0, res1);
>  
>  	/* HFG[RW]TR_EL2 */
> -	res0 = res1 = 0;
> -	if (!(kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
> -	      kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC)))

The change from checking kvm_vcpu_has_feature() to using feat_pauth() (from
"KVM: arm64: Switch to table-driven FGU configuration" patch 31) is fine
because the ID regs (ID_AA64ISAR1_EL, ID_AA64ISAR2_EL) are sanitised by
__kvm_read_sanitised_id_reg(), which checks vcpu_has_feature() via
vcpu_has_ptrauth().

> -		res0 |= (HFGRTR_EL2_APDAKey | HFGRTR_EL2_APDBKey |
> -			 HFGRTR_EL2_APGAKey | HFGRTR_EL2_APIAKey |
> -			 HFGRTR_EL2_APIBKey);
> -	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
> -		res0 |= (HFGRTR_EL2_LORC_EL1 | HFGRTR_EL2_LOREA_EL1 |
> -			 HFGRTR_EL2_LORID_EL1 | HFGRTR_EL2_LORN_EL1 |
> -			 HFGRTR_EL2_LORSA_EL1);
> -	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
> -	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
> -		res0 |= (HFGRTR_EL2_SCXTNUM_EL1 | HFGRTR_EL2_SCXTNUM_EL0);
> -	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP))
> -		res0 |= HFGRTR_EL2_ICC_IGRPENn_EL1;
> -	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
> -		res0 |= (HFGRTR_EL2_ERRIDR_EL1 | HFGRTR_EL2_ERRSELR_EL1 |
> -			 HFGRTR_EL2_ERXFR_EL1 | HFGRTR_EL2_ERXCTLR_EL1 |
> -			 HFGRTR_EL2_ERXSTATUS_EL1 | HFGRTR_EL2_ERXMISCn_EL1 |
> -			 HFGRTR_EL2_ERXPFGF_EL1 | HFGRTR_EL2_ERXPFGCTL_EL1 |
> -			 HFGRTR_EL2_ERXPFGCDN_EL1 | HFGRTR_EL2_ERXADDR_EL1);
> -	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
> -		res0 |= HFGRTR_EL2_nACCDATA_EL1;
> -	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -		res0 |= (HFGRTR_EL2_nGCS_EL0 | HFGRTR_EL2_nGCS_EL1);
> -	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
> -		res0 |= (HFGRTR_EL2_nSMPRI_EL1 | HFGRTR_EL2_nTPIDR2_EL0);
> -	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> -		res0 |= HFGRTR_EL2_nRCWMASK_EL1;
> -	if (!kvm_has_s1pie(kvm))
> -		res0 |= (HFGRTR_EL2_nPIRE0_EL1 | HFGRTR_EL2_nPIR_EL1);
> -	if (!kvm_has_s1poe(kvm))
> -		res0 |= (HFGRTR_EL2_nPOR_EL0 | HFGRTR_EL2_nPOR_EL1);
> -	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
> -		res0 |= HFGRTR_EL2_nS2POR_EL1;
> -	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
> -		res0 |= (HFGRTR_EL2_nMAIR2_EL1 | HFGRTR_EL2_nAMAIR2_EL1);
> -	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | hfgrtr_masks.res0, res1);
> -	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hfgwtr_masks.res0, res1);
> +	get_reg_fixed_bits(kvm, HFGRTR_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HFGRTR_EL2, res0, res1);
> +	get_reg_fixed_bits(kvm, HFGWTR_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HFGWTR_EL2, res0, res1);
>  
>  	/* HDFG[RW]TR_EL2 */
> -	res0 = res1 = 0;
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
> -		res0 |= HDFGRTR_EL2_OSDLR_EL1;
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
> -		res0 |= (HDFGRTR_EL2_PMEVCNTRn_EL0 | HDFGRTR_EL2_PMEVTYPERn_EL0 |
> -			 HDFGRTR_EL2_PMCCFILTR_EL0 | HDFGRTR_EL2_PMCCNTR_EL0 |
> -			 HDFGRTR_EL2_PMCNTEN | HDFGRTR_EL2_PMINTEN |
> -			 HDFGRTR_EL2_PMOVS | HDFGRTR_EL2_PMSELR_EL0 |
> -			 HDFGRTR_EL2_PMMIR_EL1 | HDFGRTR_EL2_PMUSERENR_EL0 |
> -			 HDFGRTR_EL2_PMCEIDn_EL0);
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, IMP))
> -		res0 |= (HDFGRTR_EL2_PMBLIMITR_EL1 | HDFGRTR_EL2_PMBPTR_EL1 |
> -			 HDFGRTR_EL2_PMBSR_EL1 | HDFGRTR_EL2_PMSCR_EL1 |
> -			 HDFGRTR_EL2_PMSEVFR_EL1 | HDFGRTR_EL2_PMSFCR_EL1 |
> -			 HDFGRTR_EL2_PMSICR_EL1 | HDFGRTR_EL2_PMSIDR_EL1 |
> -			 HDFGRTR_EL2_PMSIRR_EL1 | HDFGRTR_EL2_PMSLATFR_EL1 |
> -			 HDFGRTR_EL2_PMBIDR_EL1);
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
> -		res0 |= (HDFGRTR_EL2_TRC | HDFGRTR_EL2_TRCAUTHSTATUS |
> -			 HDFGRTR_EL2_TRCAUXCTLR | HDFGRTR_EL2_TRCCLAIM |
> -			 HDFGRTR_EL2_TRCCNTVRn | HDFGRTR_EL2_TRCID |
> -			 HDFGRTR_EL2_TRCIMSPECn | HDFGRTR_EL2_TRCOSLSR |
> -			 HDFGRTR_EL2_TRCPRGCTLR | HDFGRTR_EL2_TRCSEQSTR |
> -			 HDFGRTR_EL2_TRCSSCSRn | HDFGRTR_EL2_TRCSTATR |
> -			 HDFGRTR_EL2_TRCVICTLR);
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, IMP))
> -		res0 |= (HDFGRTR_EL2_TRBBASER_EL1 | HDFGRTR_EL2_TRBIDR_EL1 |
> -			 HDFGRTR_EL2_TRBLIMITR_EL1 | HDFGRTR_EL2_TRBMAR_EL1 |
> -			 HDFGRTR_EL2_TRBPTR_EL1 | HDFGRTR_EL2_TRBSR_EL1 |
> -			 HDFGRTR_EL2_TRBTRG_EL1);
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
> -		res0 |= (HDFGRTR_EL2_nBRBIDR | HDFGRTR_EL2_nBRBCTL |
> -			 HDFGRTR_EL2_nBRBDATA);
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2))
> -		res0 |= HDFGRTR_EL2_nPMSNEVFR_EL1;
> -	set_sysreg_masks(kvm, HDFGRTR_EL2, res0 | hdfgrtr_masks.res0, res1);
> -
> -	/* Reuse the bits from the read-side and add the write-specific stuff */
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP))
> -		res0 |= (HDFGWTR_EL2_PMCR_EL0 | HDFGWTR_EL2_PMSWINC_EL0);
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP))
> -		res0 |= HDFGWTR_EL2_TRCOSLAR;
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
> -		res0 |= HDFGWTR_EL2_TRFCR_EL1;
> -	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | hdfgwtr_masks.res0, res1);
> +	get_reg_fixed_bits(kvm, HDFGRTR_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HDFGRTR_EL2, res0, res1);
> +	get_reg_fixed_bits(kvm, HDFGWTR_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HDFGWTR_EL2, res0, res1);
>  
>  	/* HFGITR_EL2 */
> -	res0 = hfgitr_masks.res0;
> -	res1 = HFGITR_EL2_RES1;
> -	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, DPB, DPB2))
> -		res0 |= HFGITR_EL2_DCCVADP;
> -	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, PAN, PAN2))
> -		res0 |= (HFGITR_EL2_ATS1E1RP | HFGITR_EL2_ATS1E1WP);
> -	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> -		res0 |= (HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
> -			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS |
> -			 HFGITR_EL2_TLBIVAALE1OS | HFGITR_EL2_TLBIVALE1OS |
> -			 HFGITR_EL2_TLBIVAAE1OS | HFGITR_EL2_TLBIASIDE1OS |
> -			 HFGITR_EL2_TLBIVAE1OS | HFGITR_EL2_TLBIVMALLE1OS);
> -	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
> -		res0 |= (HFGITR_EL2_TLBIRVAALE1 | HFGITR_EL2_TLBIRVALE1 |
> -			 HFGITR_EL2_TLBIRVAAE1 | HFGITR_EL2_TLBIRVAE1 |
> -			 HFGITR_EL2_TLBIRVAALE1IS | HFGITR_EL2_TLBIRVALE1IS |
> -			 HFGITR_EL2_TLBIRVAAE1IS | HFGITR_EL2_TLBIRVAE1IS |
> -			 HFGITR_EL2_TLBIRVAALE1OS | HFGITR_EL2_TLBIRVALE1OS |
> -			 HFGITR_EL2_TLBIRVAAE1OS | HFGITR_EL2_TLBIRVAE1OS);
> -	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, IMP))
> -		res0 |= (HFGITR_EL2_CFPRCTX | HFGITR_EL2_DVPRCTX |
> -			 HFGITR_EL2_CPPRCTX);
> -	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, BRBE, IMP))
> -		res0 |= (HFGITR_EL2_nBRBINJ | HFGITR_EL2_nBRBIALL);
> -	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -		res0 |= (HFGITR_EL2_nGCSPUSHM_EL1 | HFGITR_EL2_nGCSSTR_EL1 |
> -			 HFGITR_EL2_nGCSEPP);
> -	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX))
> -		res0 |= HFGITR_EL2_COSPRCTX;
> -	if (!kvm_has_feat(kvm, ID_AA64ISAR2_EL1, ATS1A, IMP))
> -		res0 |= HFGITR_EL2_ATS1E1A;
> +	get_reg_fixed_bits(kvm, HFGITR_EL2, &res0, &res1);
>  	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
>  
>  	/* HAFGRTR_EL2 - not a lot to see here */
> -	res0 = hafgrtr_masks.res0;
> -	res1 = HAFGRTR_EL2_RES1;
> -	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
> -		res0 |= ~(res0 | res1);
> +	get_reg_fixed_bits(kvm, HAFGRTR_EL2, &res0, &res1);
>  	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
>  
>  	/* TCR2_EL2 */

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

