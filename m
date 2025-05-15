Return-Path: <kvm+bounces-46703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E49DBAB8BD0
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 18:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A58B1891D01
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 16:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F7421ABB1;
	Thu, 15 May 2025 16:04:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF036136
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747325076; cv=none; b=XRpIpiNj3JpEldjaf821MtoPtDDfLJUfcp7VIdkutjboOtA4H1Z+i6bqKG4usRHUXns+VgmZHhQ+hx8rKPnnD+ZxBRdoPdAQriSmxqeWMpZDOE1YTA7QF0mNSgXawAf8o4fMDv+kiGdP3THBQs2z4OreD7uyRUu710KF7oz33+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747325076; c=relaxed/simple;
	bh=1Dsy9IOibHqAlza2DVvn3vTnwanAJQWpOGOksglrPAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqYA1RIhkTkY9QnfjWnAXfwvSBgU6SjMQ7Hk4sQ7LaKYlhZjxBTFK36ca7Y46U40RJj8dajUeTAyD/hDmutSHDcNX+DMQuoKM7O5M3ap14XDNIvIVD/bPejY/qHkr13lt34ftN11R/c5LMSJ8BuSsbDyFoGvlpsYhrdKXJoHVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E59C14BF;
	Thu, 15 May 2025 09:04:20 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 431E33F5A1;
	Thu, 15 May 2025 09:04:30 -0700 (PDT)
Date: Thu, 15 May 2025 17:04:27 +0100
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
Subject: Re: [PATCH v4 38/43] KVM: arm64: Add sanitisation for FEAT_FGT2
 registers
Message-ID: <20250515160427.GB118636@e124191.cambridge.arm.com>
References: <20250506164348.346001-1-maz@kernel.org>
 <20250506164348.346001-39-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506164348.346001-39-maz@kernel.org>

On Tue, May 06, 2025 at 05:43:43PM +0100, Marc Zyngier wrote:
> Just like the FEAT_FGT registers, treat the FGT2 variant the same
> way. THis is a large  update, but a fairly mechanical one.
> 
> The config dependencies are extracted from the 2025-03 JSON drop.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

As with the other patches, I didn't review every single FEAT, but had a look at
a few random ones.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_host.h |  15 +++
>  arch/arm64/kvm/arm.c              |   5 +
>  arch/arm64/kvm/config.c           | 194 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/emulate-nested.c   |  22 ++++
>  arch/arm64/kvm/hyp/nvhe/switch.c  |   5 +
>  arch/arm64/kvm/nested.c           |  16 +++
>  arch/arm64/kvm/sys_regs.c         |   3 +
>  7 files changed, 260 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index abe45f97266c5..4e191c81f9aa1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -279,6 +279,11 @@ enum fgt_group_id {
>  	HDFGWTR_GROUP = HDFGRTR_GROUP,
>  	HFGITR_GROUP,
>  	HAFGRTR_GROUP,
> +	HFGRTR2_GROUP,
> +	HFGWTR2_GROUP = HFGRTR2_GROUP,
> +	HDFGRTR2_GROUP,
> +	HDFGWTR2_GROUP = HDFGRTR2_GROUP,
> +	HFGITR2_GROUP,
>  
>  	/* Must be last */
>  	__NR_FGT_GROUP_IDS__
> @@ -625,6 +630,11 @@ extern struct fgt_masks hfgitr_masks;
>  extern struct fgt_masks hdfgrtr_masks;
>  extern struct fgt_masks hdfgwtr_masks;
>  extern struct fgt_masks hafgrtr_masks;
> +extern struct fgt_masks hfgrtr2_masks;
> +extern struct fgt_masks hfgwtr2_masks;
> +extern struct fgt_masks hfgitr2_masks;
> +extern struct fgt_masks hdfgrtr2_masks;
> +extern struct fgt_masks hdfgwtr2_masks;
>  
>  extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
>  extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
> @@ -632,6 +642,11 @@ extern struct fgt_masks kvm_nvhe_sym(hfgitr_masks);
>  extern struct fgt_masks kvm_nvhe_sym(hdfgrtr_masks);
>  extern struct fgt_masks kvm_nvhe_sym(hdfgwtr_masks);
>  extern struct fgt_masks kvm_nvhe_sym(hafgrtr_masks);
> +extern struct fgt_masks kvm_nvhe_sym(hfgrtr2_masks);
> +extern struct fgt_masks kvm_nvhe_sym(hfgwtr2_masks);
> +extern struct fgt_masks kvm_nvhe_sym(hfgitr2_masks);
> +extern struct fgt_masks kvm_nvhe_sym(hdfgrtr2_masks);
> +extern struct fgt_masks kvm_nvhe_sym(hdfgwtr2_masks);
>  
>  struct kvm_cpu_context {
>  	struct user_pt_regs regs;	/* sp = sp_el0 */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8951e8693ca7b..ff1c0cf97ee53 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2457,6 +2457,11 @@ static void kvm_hyp_init_symbols(void)
>  	kvm_nvhe_sym(hdfgrtr_masks) = hdfgrtr_masks;
>  	kvm_nvhe_sym(hdfgwtr_masks) = hdfgwtr_masks;
>  	kvm_nvhe_sym(hafgrtr_masks) = hafgrtr_masks;
> +	kvm_nvhe_sym(hfgrtr2_masks) = hfgrtr2_masks;
> +	kvm_nvhe_sym(hfgwtr2_masks) = hfgwtr2_masks;
> +	kvm_nvhe_sym(hfgitr2_masks) = hfgitr2_masks;
> +	kvm_nvhe_sym(hdfgrtr2_masks)= hdfgrtr2_masks;
> +	kvm_nvhe_sym(hdfgwtr2_masks)= hdfgwtr2_masks;
>  
>  	/*
>  	 * Flush entire BSS since part of its data containing init symbols is read
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index b1db94057c937..666070d4ccd7f 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -66,7 +66,9 @@ struct reg_bits_to_feat_map {
>  #define FEAT_BRBE		ID_AA64DFR0_EL1, BRBE, IMP
>  #define FEAT_TRC_SR		ID_AA64DFR0_EL1, TraceVer, IMP
>  #define FEAT_PMUv3		ID_AA64DFR0_EL1, PMUVer, IMP
> +#define FEAT_PMUv3p9		ID_AA64DFR0_EL1, PMUVer, V3P9
>  #define FEAT_TRBE		ID_AA64DFR0_EL1, TraceBuffer, IMP
> +#define FEAT_TRBEv1p1		ID_AA64DFR0_EL1, TraceBuffer, TRBE_V1P1
>  #define FEAT_DoubleLock		ID_AA64DFR0_EL1, DoubleLock, IMP
>  #define FEAT_TRF		ID_AA64DFR0_EL1, TraceFilt, IMP
>  #define FEAT_AA32EL0		ID_AA64PFR0_EL1, EL0, AARCH32
> @@ -84,8 +86,10 @@ struct reg_bits_to_feat_map {
>  #define FEAT_LS64_V		ID_AA64ISAR1_EL1, LS64, LS64_V
>  #define FEAT_LS64_ACCDATA	ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA
>  #define FEAT_RAS		ID_AA64PFR0_EL1, RAS, IMP
> +#define FEAT_RASv2		ID_AA64PFR0_EL1, RAS, V2
>  #define FEAT_GICv3		ID_AA64PFR0_EL1, GIC, IMP
>  #define FEAT_LOR		ID_AA64MMFR1_EL1, LO, IMP
> +#define FEAT_SPEv1p4		ID_AA64DFR0_EL1, PMSVer, V1P4
>  #define FEAT_SPEv1p5		ID_AA64DFR0_EL1, PMSVer, V1P5
>  #define FEAT_ATS1A		ID_AA64ISAR2_EL1, ATS1A, IMP
>  #define FEAT_SPECRES2		ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX
> @@ -110,10 +114,23 @@ struct reg_bits_to_feat_map {
>  #define FEAT_EVT_TTLBxS		ID_AA64MMFR2_EL1, EVT, TTLBxS
>  #define FEAT_MTE2		ID_AA64PFR1_EL1, MTE, MTE2
>  #define FEAT_RME		ID_AA64PFR0_EL1, RME, IMP
> +#define FEAT_MPAM		ID_AA64PFR0_EL1, MPAM, 1
>  #define FEAT_S2FWB		ID_AA64MMFR2_EL1, FWB, IMP
>  #define FEAT_TME		ID_AA64ISAR0_EL1, TME, IMP
>  #define FEAT_TWED		ID_AA64MMFR1_EL1, TWED, IMP
>  #define FEAT_E2H0		ID_AA64MMFR4_EL1, E2H0, IMP
> +#define FEAT_SRMASK		ID_AA64MMFR4_EL1, SRMASK, IMP
> +#define FEAT_PoPS		ID_AA64MMFR4_EL1, PoPS, IMP
> +#define FEAT_PFAR		ID_AA64PFR1_EL1, PFAR, IMP
> +#define FEAT_Debugv8p9		ID_AA64DFR0_EL1, PMUVer, V3P9
> +#define FEAT_PMUv3_SS		ID_AA64DFR0_EL1, PMSS, IMP
> +#define FEAT_SEBEP		ID_AA64DFR0_EL1, SEBEP, IMP
> +#define FEAT_EBEP		ID_AA64DFR1_EL1, EBEP, IMP
> +#define FEAT_ITE		ID_AA64DFR1_EL1, ITE, IMP
> +#define FEAT_PMUv3_ICNTR	ID_AA64DFR1_EL1, PMICNTR, IMP
> +#define FEAT_SPMU		ID_AA64DFR1_EL1, SPMU, IMP
> +#define FEAT_SPE_nVM		ID_AA64DFR2_EL1, SPE_nVM, IMP
> +#define FEAT_STEP2		ID_AA64DFR2_EL1, STEP, IMP
>  
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
> @@ -180,6 +197,32 @@ static bool feat_sme_smps(struct kvm *kvm)
>  		(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
>  }
>  
> +static bool feat_spe_fds(struct kvm *kvm)
> +{
> +	/*
> +	 * Revists this if KVM ever supports SPE -- this really should
> +	 * look at the guest's view of PMSIDR_EL1.
> +	 */
> +	return (kvm_has_feat(kvm, FEAT_SPEv1p4) &&
> +		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FDS));
> +}
> +
> +static bool feat_trbe_mpam(struct kvm *kvm)
> +{
> +	/*
> +	 * Revists this if KVM ever supports both MPAM and TRBE --
> +	 * this really should look at the guest's view of TRBIDR_EL1.
> +	 */
> +	return (kvm_has_feat(kvm, FEAT_TRBE) &&
> +		kvm_has_feat(kvm, FEAT_MPAM) &&
> +		(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_MPAM));
> +}
> +
> +static bool feat_ebep_pmuv3_ss(struct kvm *kvm)
> +{
> +	return kvm_has_feat(kvm, FEAT_EBEP) || kvm_has_feat(kvm, FEAT_PMUv3_SS);
> +}
> +
>  static bool compute_hcr_rw(struct kvm *kvm, u64 *bits)
>  {
>  	/* This is purely academic: AArch32 and NV are mutually exclusive */
> @@ -589,6 +632,106 @@ static const struct reg_bits_to_feat_map hafgrtr_feat_map[] = {
>  		   FEAT_AMUv1),
>  };
>  
> +static const struct reg_bits_to_feat_map hfgitr2_feat_map[] = {
> +	NEEDS_FEAT(HFGITR2_EL2_nDCCIVAPS, FEAT_PoPS),
> +	NEEDS_FEAT(HFGITR2_EL2_TSBCSYNC, FEAT_TRBEv1p1)
> +};
> +
> +static const struct reg_bits_to_feat_map hfgrtr2_feat_map[] = {
> +	NEEDS_FEAT(HFGRTR2_EL2_nPFAR_EL1, FEAT_PFAR),
> +	NEEDS_FEAT(HFGRTR2_EL2_nERXGSR_EL1, FEAT_RASv2),
> +	NEEDS_FEAT(HFGRTR2_EL2_nACTLRALIAS_EL1	|
> +		   HFGRTR2_EL2_nACTLRMASK_EL1	|
> +		   HFGRTR2_EL2_nCPACRALIAS_EL1	|
> +		   HFGRTR2_EL2_nCPACRMASK_EL1	|
> +		   HFGRTR2_EL2_nSCTLR2MASK_EL1	|
> +		   HFGRTR2_EL2_nSCTLRALIAS2_EL1	|
> +		   HFGRTR2_EL2_nSCTLRALIAS_EL1	|
> +		   HFGRTR2_EL2_nSCTLRMASK_EL1	|
> +		   HFGRTR2_EL2_nTCR2ALIAS_EL1	|
> +		   HFGRTR2_EL2_nTCR2MASK_EL1	|
> +		   HFGRTR2_EL2_nTCRALIAS_EL1	|
> +		   HFGRTR2_EL2_nTCRMASK_EL1,
> +		   FEAT_SRMASK),
> +	NEEDS_FEAT(HFGRTR2_EL2_nRCWSMASK_EL1, FEAT_THE),
> +};
> +
> +static const struct reg_bits_to_feat_map hfgwtr2_feat_map[] = {
> +	NEEDS_FEAT(HFGWTR2_EL2_nPFAR_EL1, FEAT_PFAR),
> +	NEEDS_FEAT(HFGWTR2_EL2_nACTLRALIAS_EL1	|
> +		   HFGWTR2_EL2_nACTLRMASK_EL1	|
> +		   HFGWTR2_EL2_nCPACRALIAS_EL1	|
> +		   HFGWTR2_EL2_nCPACRMASK_EL1	|
> +		   HFGWTR2_EL2_nSCTLR2MASK_EL1	|
> +		   HFGWTR2_EL2_nSCTLRALIAS2_EL1	|
> +		   HFGWTR2_EL2_nSCTLRALIAS_EL1	|
> +		   HFGWTR2_EL2_nSCTLRMASK_EL1	|
> +		   HFGWTR2_EL2_nTCR2ALIAS_EL1	|
> +		   HFGWTR2_EL2_nTCR2MASK_EL1	|
> +		   HFGWTR2_EL2_nTCRALIAS_EL1	|
> +		   HFGWTR2_EL2_nTCRMASK_EL1,
> +		   FEAT_SRMASK),
> +	NEEDS_FEAT(HFGWTR2_EL2_nRCWSMASK_EL1, FEAT_THE),
> +};
> +
> +static const struct reg_bits_to_feat_map hdfgrtr2_feat_map[] = {
> +	NEEDS_FEAT(HDFGRTR2_EL2_nMDSELR_EL1, FEAT_Debugv8p9),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMECR_EL1, feat_ebep_pmuv3_ss),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nTRCITECR_EL1, FEAT_ITE),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMICFILTR_EL0	|
> +		   HDFGRTR2_EL2_nPMICNTR_EL0,
> +		   FEAT_PMUv3_ICNTR),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMUACR_EL1, FEAT_PMUv3p9),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMSSCR_EL1	|
> +		   HDFGRTR2_EL2_nPMSSDATA,
> +		   FEAT_PMUv3_SS),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMIAR_EL1, FEAT_SEBEP),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMSDSFR_EL1, feat_spe_fds),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMBMAR_EL1, FEAT_SPE_nVM),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nSPMACCESSR_EL1	|
> +		   HDFGRTR2_EL2_nSPMCNTEN	|
> +		   HDFGRTR2_EL2_nSPMCR_EL0	|
> +		   HDFGRTR2_EL2_nSPMDEVAFF_EL1	|
> +		   HDFGRTR2_EL2_nSPMEVCNTRn_EL0	|
> +		   HDFGRTR2_EL2_nSPMEVTYPERn_EL0|
> +		   HDFGRTR2_EL2_nSPMID		|
> +		   HDFGRTR2_EL2_nSPMINTEN	|
> +		   HDFGRTR2_EL2_nSPMOVS		|
> +		   HDFGRTR2_EL2_nSPMSCR_EL1	|
> +		   HDFGRTR2_EL2_nSPMSELR_EL0,
> +		   FEAT_SPMU),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nMDSTEPOP_EL1, FEAT_STEP2),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nTRBMPAM_EL1, feat_trbe_mpam),
> +};
> +
> +static const struct reg_bits_to_feat_map hdfgwtr2_feat_map[] = {
> +	NEEDS_FEAT(HDFGWTR2_EL2_nMDSELR_EL1, FEAT_Debugv8p9),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMECR_EL1, feat_ebep_pmuv3_ss),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nTRCITECR_EL1, FEAT_ITE),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMICFILTR_EL0	|
> +		   HDFGWTR2_EL2_nPMICNTR_EL0,
> +		   FEAT_PMUv3_ICNTR),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMUACR_EL1	|
> +		   HDFGWTR2_EL2_nPMZR_EL0,
> +		   FEAT_PMUv3p9),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMSSCR_EL1, FEAT_PMUv3_SS),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMIAR_EL1, FEAT_SEBEP),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMSDSFR_EL1, feat_spe_fds),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMBMAR_EL1, FEAT_SPE_nVM),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nSPMACCESSR_EL1	|
> +		   HDFGWTR2_EL2_nSPMCNTEN	|
> +		   HDFGWTR2_EL2_nSPMCR_EL0	|
> +		   HDFGWTR2_EL2_nSPMEVCNTRn_EL0	|
> +		   HDFGWTR2_EL2_nSPMEVTYPERn_EL0|
> +		   HDFGWTR2_EL2_nSPMINTEN	|
> +		   HDFGWTR2_EL2_nSPMOVS		|
> +		   HDFGWTR2_EL2_nSPMSCR_EL1	|
> +		   HDFGWTR2_EL2_nSPMSELR_EL0,
> +		   FEAT_SPMU),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nMDSTEPOP_EL1, FEAT_STEP2),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nTRBMPAM_EL1, feat_trbe_mpam),
> +};
> +
>  static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
>  	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
>  	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
> @@ -820,6 +963,27 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
>  					 ARRAY_SIZE(hafgrtr_feat_map),
>  					 0, NEVER_FGU);
>  		break;
> +	case HFGRTR2_GROUP:
> +		val |= compute_res0_bits(kvm, hfgrtr2_feat_map,
> +					 ARRAY_SIZE(hfgrtr2_feat_map),
> +					 0, NEVER_FGU);
> +		val |= compute_res0_bits(kvm, hfgwtr2_feat_map,
> +					 ARRAY_SIZE(hfgwtr2_feat_map),
> +					 0, NEVER_FGU);
> +		break;
> +	case HFGITR2_GROUP:
> +		val |= compute_res0_bits(kvm, hfgitr2_feat_map,
> +					 ARRAY_SIZE(hfgitr2_feat_map),
> +					 0, NEVER_FGU);
> +		break;
> +	case HDFGRTR2_GROUP:
> +		val |= compute_res0_bits(kvm, hdfgrtr2_feat_map,
> +					 ARRAY_SIZE(hdfgrtr2_feat_map),
> +					 0, NEVER_FGU);
> +		val |= compute_res0_bits(kvm, hdfgwtr2_feat_map,
> +					 ARRAY_SIZE(hdfgwtr2_feat_map),
> +					 0, NEVER_FGU);
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -868,6 +1032,36 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
>  		*res0 |= hafgrtr_masks.res0;
>  		*res1 = HAFGRTR_EL2_RES1;
>  		break;
> +	case HFGRTR2_EL2:
> +		*res0 = compute_res0_bits(kvm, hfgrtr2_feat_map,
> +					  ARRAY_SIZE(hfgrtr2_feat_map), 0, 0);
> +		*res0 |= hfgrtr2_masks.res0;
> +		*res1 = HFGRTR2_EL2_RES1;
> +		break;
> +	case HFGWTR2_EL2:
> +		*res0 = compute_res0_bits(kvm, hfgwtr2_feat_map,
> +					  ARRAY_SIZE(hfgwtr2_feat_map), 0, 0);
> +		*res0 |= hfgwtr2_masks.res0;
> +		*res1 = HFGWTR2_EL2_RES1;
> +		break;
> +	case HFGITR2_EL2:
> +		*res0 = compute_res0_bits(kvm, hfgitr2_feat_map,
> +					  ARRAY_SIZE(hfgitr2_feat_map), 0, 0);
> +		*res0 |= hfgitr2_masks.res0;
> +		*res1 = HFGITR2_EL2_RES1;
> +		break;
> +	case HDFGRTR2_EL2:
> +		*res0 = compute_res0_bits(kvm, hdfgrtr2_feat_map,
> +					  ARRAY_SIZE(hdfgrtr2_feat_map), 0, 0);
> +		*res0 |= hdfgrtr2_masks.res0;
> +		*res1 = HDFGRTR2_EL2_RES1;
> +		break;
> +	case HDFGWTR2_EL2:
> +		*res0 = compute_res0_bits(kvm, hdfgwtr2_feat_map,
> +					  ARRAY_SIZE(hdfgwtr2_feat_map), 0, 0);
> +		*res0 |= hdfgwtr2_masks.res0;
> +		*res1 = HDFGWTR2_EL2_RES1;
> +		break;
>  	case HCRX_EL2:
>  		*res0 = compute_res0_bits(kvm, hcrx_feat_map,
>  					  ARRAY_SIZE(hcrx_feat_map), 0, 0);
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 0b033d3a3d7a4..3312aefa095e0 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2060,6 +2060,11 @@ FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
>  FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
>  FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
>  FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
> +FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2_RES0);
> +FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2_RES0);
> +FGT_MASKS(hfgitr2_masks, HFGITR2_EL2_RES0);
> +FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2_RES0);
> +FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2_RES0);
>  
>  static __init bool aggregate_fgt(union trap_config tc)
>  {
> @@ -2082,6 +2087,18 @@ static __init bool aggregate_fgt(union trap_config tc)
>  		rmasks = &hfgitr_masks;
>  		wmasks = NULL;
>  		break;
> +	case HFGRTR2_GROUP:
> +		rmasks = &hfgrtr2_masks;
> +		wmasks = &hfgwtr2_masks;
> +		break;
> +	case HDFGRTR2_GROUP:
> +		rmasks = &hdfgrtr2_masks;
> +		wmasks = &hdfgwtr2_masks;
> +		break;
> +	case HFGITR2_GROUP:
> +		rmasks = &hfgitr2_masks;
> +		wmasks = NULL;
> +		break;
>  	}
>  
>  	/*
> @@ -2141,6 +2158,11 @@ static __init int check_all_fgt_masks(int ret)
>  		&hdfgrtr_masks,
>  		&hdfgwtr_masks,
>  		&hafgrtr_masks,
> +		&hfgrtr2_masks,
> +		&hfgwtr2_masks,
> +		&hfgitr2_masks,
> +		&hdfgrtr2_masks,
> +		&hdfgwtr2_masks,
>  	};
>  	int err = 0;
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index ae55d6d87e3d2..6947aaf117f63 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -39,6 +39,11 @@ struct fgt_masks hfgitr_masks;
>  struct fgt_masks hdfgrtr_masks;
>  struct fgt_masks hdfgwtr_masks;
>  struct fgt_masks hafgrtr_masks;
> +struct fgt_masks hfgrtr2_masks;
> +struct fgt_masks hfgwtr2_masks;
> +struct fgt_masks hfgitr2_masks;
> +struct fgt_masks hdfgrtr2_masks;
> +struct fgt_masks hdfgwtr2_masks;
>  
>  extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
>  
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index b633666be6df4..f6a5736ba7ef7 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1045,6 +1045,22 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	get_reg_fixed_bits(kvm, HAFGRTR_EL2, &res0, &res1);
>  	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
>  
> +	/* HFG[RW]TR2_EL2 */
> +	get_reg_fixed_bits(kvm, HFGRTR2_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HFGRTR2_EL2, res0, res1);
> +	get_reg_fixed_bits(kvm, HFGWTR2_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HFGWTR2_EL2, res0, res1);
> +
> +	/* HDFG[RW]TR2_EL2 */
> +	get_reg_fixed_bits(kvm, HDFGRTR2_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0, res1);
> +	get_reg_fixed_bits(kvm, HDFGWTR2_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0, res1);
> +
> +	/* HFGITR2_EL2 */
> +	get_reg_fixed_bits(kvm, HFGITR2_EL2, &res0, &res1);
> +	set_sysreg_masks(kvm, HFGITR2_EL2, res0, res1);
> +
>  	/* TCR2_EL2 */
>  	res0 = TCR2_EL2_RES0;
>  	res1 = TCR2_EL2_RES1;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f24d1a7d9a8f4..8b994690bf1ad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5151,6 +5151,9 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>  	compute_fgu(kvm, HFGITR_GROUP);
>  	compute_fgu(kvm, HDFGRTR_GROUP);
>  	compute_fgu(kvm, HAFGRTR_GROUP);
> +	compute_fgu(kvm, HFGRTR2_GROUP);
> +	compute_fgu(kvm, HFGITR2_GROUP);
> +	compute_fgu(kvm, HDFGRTR2_GROUP);
>  
>  	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
>  out:
> -- 
> 2.39.2
> 

