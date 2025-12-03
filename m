Return-Path: <kvm+bounces-65197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 45053C9EDFC
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 12:43:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1E5464E450D
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 11:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D5F2F5480;
	Wed,  3 Dec 2025 11:43:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD93A2F1FDC
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 11:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764762201; cv=none; b=FQtIRu7O1r+11TWAoo1AYgS1QxpY2CdeTWuozVGMsHD/szoIPMFkDsDWNefTjTrjfbp45p+o3yhj11GeA6aXNdyxX6lcXbQx8iNzsI+JszhAizPMO0UKz3sLBuit9olxuuz9zeGG1EZMkzdomfU1Vx6KHhSqxwwpwEACeRJkOuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764762201; c=relaxed/simple;
	bh=pLOiebTBpnJHjLLx2A1HolSFHezPKLxQjcmSQfsmLS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLqN+XSLzUgTdF9WGzWS8YNNqSCQZoI2S1s/v0EHls0aIIro5LylMCZ9hICvTUpex0frcT1dffGRGfVQnkBxu66r1c9uABCEhfSnaBplK4F1/Ks2V51PEJNm2nLteAgxuwijWCS/XzIoIGljx/c/qbjzjvSK1tkNw5uE+LFcwXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4203339;
	Wed,  3 Dec 2025 03:43:10 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D44513F59E;
	Wed,  3 Dec 2025 03:43:16 -0800 (PST)
Date: Wed, 3 Dec 2025 11:43:14 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/4] arm64: Convert VTCR_EL2 to sysreg infratructure
Message-ID: <aTAiUuc_aK5Bgce0@raptor>
References: <20251129144525.2609207-1-maz@kernel.org>
 <20251129144525.2609207-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129144525.2609207-3-maz@kernel.org>

Hi Marc,

On Sat, Nov 29, 2025 at 02:45:23PM +0000, Marc Zyngier wrote:
> Our definition of VTCR_EL2 is both partial (tons of fields are
> missing) and totally inconsistent (some constants are shifted,
> some are not). They are also expressed in terms of TCR, which is
> rather inconvenient.
> 
> Replace the ad-hoc definitions with the the generated version.
> This results in a bunch of additional changes to make the code
> with the unshifted nature of generated enumerations.
> 
> The register data was extracted from the BSD licenced AARCHMRS
> (AARCHMRS_OPENSOURCE_A_profile_FAT-2025-09_ASL0).

Looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 52 +++++++----------------------
>  arch/arm64/include/asm/sysreg.h  |  1 -
>  arch/arm64/kvm/hyp/pgtable.c     |  8 ++---
>  arch/arm64/kvm/nested.c          |  8 ++---
>  arch/arm64/tools/sysreg          | 57 ++++++++++++++++++++++++++++++++
>  5 files changed, 76 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 1da290aeedce7..cd2dc378baee6 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -123,37 +123,7 @@
>  #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
>  			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
>  
> -/* VTCR_EL2 Registers bits */
> -#define VTCR_EL2_DS		TCR_EL2_DS
> -#define VTCR_EL2_RES1		(1U << 31)
> -#define VTCR_EL2_HD		(1 << 22)
> -#define VTCR_EL2_HA		(1 << 21)
> -#define VTCR_EL2_PS_SHIFT	TCR_EL2_PS_SHIFT
> -#define VTCR_EL2_PS_MASK	TCR_EL2_PS_MASK
> -#define VTCR_EL2_TG0_MASK	TCR_TG0_MASK
> -#define VTCR_EL2_TG0_4K		TCR_TG0_4K
> -#define VTCR_EL2_TG0_16K	TCR_TG0_16K
> -#define VTCR_EL2_TG0_64K	TCR_TG0_64K
> -#define VTCR_EL2_SH0_MASK	TCR_SH0_MASK
> -#define VTCR_EL2_SH0_INNER	TCR_SH0_INNER
> -#define VTCR_EL2_ORGN0_MASK	TCR_ORGN0_MASK
> -#define VTCR_EL2_ORGN0_WBWA	TCR_ORGN0_WBWA
> -#define VTCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
> -#define VTCR_EL2_IRGN0_WBWA	TCR_IRGN0_WBWA
> -#define VTCR_EL2_SL0_SHIFT	6
> -#define VTCR_EL2_SL0_MASK	(3 << VTCR_EL2_SL0_SHIFT)
> -#define VTCR_EL2_T0SZ_MASK	0x3f
> -#define VTCR_EL2_VS_SHIFT	19
> -#define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
> -#define VTCR_EL2_VS_16BIT	(1 << VTCR_EL2_VS_SHIFT)
> -
> -#define VTCR_EL2_T0SZ(x)	TCR_T0SZ(x)
> -
>  /*
> - * We configure the Stage-2 page tables to always restrict the IPA space to be
> - * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
> - * not known to exist and will break with this configuration.
> - *
>   * The VTCR_EL2 is configured per VM and is initialised in kvm_init_stage2_mmu.
>   *
>   * Note that when using 4K pages, we concatenate two first level page tables
> @@ -161,9 +131,6 @@
>   *
>   */
>  
> -#define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
> -				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_RES1)
> -
>  /*
>   * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
>   * Interestingly, it depends on the page size.
> @@ -195,30 +162,35 @@
>   */
>  #ifdef CONFIG_ARM64_64K_PAGES
>  
> -#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_64K
> +#define VTCR_EL2_TGRAN			64K
>  #define VTCR_EL2_TGRAN_SL0_BASE		3UL
>  
>  #elif defined(CONFIG_ARM64_16K_PAGES)
>  
> -#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_16K
> +#define VTCR_EL2_TGRAN			16K
>  #define VTCR_EL2_TGRAN_SL0_BASE		3UL
>  
>  #else	/* 4K */
>  
> -#define VTCR_EL2_TGRAN			VTCR_EL2_TG0_4K
> +#define VTCR_EL2_TGRAN			4K
>  #define VTCR_EL2_TGRAN_SL0_BASE		2UL
>  
>  #endif
>  
>  #define VTCR_EL2_LVLS_TO_SL0(levels)	\
> -	((VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))) << VTCR_EL2_SL0_SHIFT)
> +	FIELD_PREP(VTCR_EL2_SL0, (VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))))
>  #define VTCR_EL2_SL0_TO_LVLS(sl0)	\
>  	((sl0) + 4 - VTCR_EL2_TGRAN_SL0_BASE)
>  #define VTCR_EL2_LVLS(vtcr)		\
> -	VTCR_EL2_SL0_TO_LVLS(((vtcr) & VTCR_EL2_SL0_MASK) >> VTCR_EL2_SL0_SHIFT)
> +	VTCR_EL2_SL0_TO_LVLS(FIELD_GET(VTCR_EL2_SL0, (vtcr)))
> +
> +#define VTCR_EL2_FLAGS	(SYS_FIELD_PREP_ENUM(VTCR_EL2, SH0, INNER)	    | \
> +			 SYS_FIELD_PREP_ENUM(VTCR_EL2, ORGN0, WBWA)	    | \
> +			 SYS_FIELD_PREP_ENUM(VTCR_EL2, IRGN0, WBWA)	    | \
> +			 SYS_FIELD_PREP_ENUM(VTCR_EL2, TG0, VTCR_EL2_TGRAN) | \
> +			 VTCR_EL2_RES1)
>  
> -#define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN)
> -#define VTCR_EL2_IPA(vtcr)		(64 - ((vtcr) & VTCR_EL2_T0SZ_MASK))
> +#define VTCR_EL2_IPA(vtcr)		(64 - FIELD_GET(VTCR_EL2_T0SZ, (vtcr)))
>  
>  /*
>   * ARM VMSAv8-64 defines an algorithm for finding the translation table
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index c231d2a3e5159..acad7a7621b9e 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -516,7 +516,6 @@
>  #define SYS_TTBR1_EL2			sys_reg(3, 4, 2, 0, 1)
>  #define SYS_TCR_EL2			sys_reg(3, 4, 2, 0, 2)
>  #define SYS_VTTBR_EL2			sys_reg(3, 4, 2, 1, 0)
> -#define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
>  
>  #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
>  #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 947ac1a951a5b..e0bd6a0172729 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -583,8 +583,8 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>  	u64 vtcr = VTCR_EL2_FLAGS;
>  	s8 lvls;
>  
> -	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
> -	vtcr |= VTCR_EL2_T0SZ(phys_shift);
> +	vtcr |= FIELD_PREP(VTCR_EL2_PS, kvm_get_parange(mmfr0));
> +	vtcr |= FIELD_PREP(VTCR_EL2_T0SZ, (UL(64) - phys_shift));
>  	/*
>  	 * Use a minimum 2 level page table to prevent splitting
>  	 * host PMD huge pages at stage2.
> @@ -624,9 +624,7 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
>  		vtcr |= VTCR_EL2_DS;
>  
>  	/* Set the vmid bits */
> -	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
> -		VTCR_EL2_VS_16BIT :
> -		VTCR_EL2_VS_8BIT;
> +	vtcr |= (get_vmid_bits(mmfr1) == 16) ? VTCR_EL2_VS : 0;
>  
>  	return vtcr;
>  }
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 911fc99ed99d9..e1ef8930c97b3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -377,7 +377,7 @@ static void vtcr_to_walk_info(u64 vtcr, struct s2_walk_info *wi)
>  {
>  	wi->t0sz = vtcr & TCR_EL2_T0SZ_MASK;
>  
> -	switch (vtcr & VTCR_EL2_TG0_MASK) {
> +	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
>  	case VTCR_EL2_TG0_4K:
>  		wi->pgshift = 12;	 break;
>  	case VTCR_EL2_TG0_16K:
> @@ -513,7 +513,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
>  
>  	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
>  
> -	switch (vtcr & VTCR_EL2_TG0_MASK) {
> +	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
>  	case VTCR_EL2_TG0_4K:
>  		ttl = (TLBI_TTL_TG_4K << 2);
>  		break;
> @@ -530,7 +530,7 @@ static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
>  
>  again:
>  	/* Iteratively compute the block sizes for a particular granule size */
> -	switch (vtcr & VTCR_EL2_TG0_MASK) {
> +	switch (FIELD_GET(VTCR_EL2_TG0_MASK, vtcr)) {
>  	case VTCR_EL2_TG0_4K:
>  		if	(sz < SZ_4K)	sz = SZ_4K;
>  		else if (sz < SZ_2M)	sz = SZ_2M;
> @@ -593,7 +593,7 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
>  
>  	if (!max_size) {
>  		/* Compute the maximum extent of the invalidation */
> -		switch (mmu->tlb_vtcr & VTCR_EL2_TG0_MASK) {
> +		switch (FIELD_GET(VTCR_EL2_TG0_MASK, mmu->tlb_vtcr)) {
>  		case VTCR_EL2_TG0_4K:
>  			max_size = SZ_1G;
>  			break;
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 9d388f87d9a13..6f43b2ae5993b 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4400,6 +4400,63 @@ Field	56:12	BADDR
>  Res0	11:0
>  EndSysreg
>  
> +Sysreg	VTCR_EL2	3	4	2	1	2
> +Res0	63:46	
> +Field	45	HDBSS
> +Field	44	HAFT
> +Res0	43:42	
> +Field	41	TL0
> +Field	40	GCSH
> +Res0	39
> +Field	38	D128
> +Field	37	S2POE
> +Field	36	S2PIE
> +Field	35	TL1
> +Field	34	AssuredOnly
> +Field	33	SL2
> +Field	32	DS
> +Res1	31
> +Field	30	NSA
> +Field	29	NSW
> +Field	28	HWU62
> +Field	27	HWU61
> +Field	26	HWU60
> +Field	25	HWU59
> +Res0	24:23
> +Field	22	HD
> +Field	21	HA
> +Res0	20
> +Enum	19	VS
> +	0b0	8BIT
> +	0b1	16BIT
> +EndEnum
> +Field	18:16	PS
> +Enum	15:14	TG0
> +	0b00	4K
> +	0b01	64K
> +	0b10	16K
> +EndEnum
> +Enum	13:12	SH0
> +	0b00	NONE
> +	0b01	OUTER
> +	0b11	INNER
> +EndEnum
> +Enum	11:10	ORGN0
> +	0b00	NC
> +	0b01	WBWA
> +	0b10	WT
> +	0b11	WBnWA
> +EndEnum
> +Enum	9:8	IRGN0
> +	0b00	NC
> +	0b01	WBWA
> +	0b10	WT
> +	0b11	WBnWA
> +EndEnum
> +Field	7:6	SL0
> +Field	5:0	T0SZ
> +EndSysreg
> +
>  Sysreg	GCSCR_EL2	3	4	2	5	0
>  Fields	GCSCR_ELx
>  EndSysreg
> -- 
> 2.47.3
> 

