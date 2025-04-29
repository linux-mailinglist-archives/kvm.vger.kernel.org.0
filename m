Return-Path: <kvm+bounces-44784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E490AA0EB7
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B64C84A0FC0
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A092D3220;
	Tue, 29 Apr 2025 14:27:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D0410942
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745936824; cv=none; b=OgWEv8MjTqgnrW1aRohyDbK7XCYtvkbOshn24/FlJXRd7GwpOlbPr5ONA/83QTxQEs1HPaGZ1YW2AI7ZZfMGObUYITnVqzNIQGl8FLXufqSBnm0/yC6XZcguPF6hdzGb6fUJ0J9F7ZZ/sPDfrrvaJ+TSFuOZ1w1ahti8WD4rjEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745936824; c=relaxed/simple;
	bh=UiIY08Y/6+nhIJI8wKvKvIAHTXxvlTKEvJzUqzV6zvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVxq2c5YWJrJJItgbpEJgfwHRxr4wEUHGiWV6wrvAhKuwgtx8iwcnnNWxpmkc71D/0IYhSmAQLeqfONKYJOSdAmBmU7KpF8o8WQhTPq2QFsMHDhL/iriUTP8hNe4OTdpjz6Gpn+io9o6MpzOJaVto05CSiiCCxz1tjCyshlplVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08AE416F3;
	Tue, 29 Apr 2025 07:26:54 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D42EE3F66E;
	Tue, 29 Apr 2025 07:26:58 -0700 (PDT)
Date: Tue, 29 Apr 2025 15:26:56 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 04/42] arm64: sysreg: Replace HGFxTR_EL2 with
 HFG{R,W}TR_EL2
Message-ID: <20250429142656.GD1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-5-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:27:58PM +0100, Marc Zyngier wrote:
> Treating HFGRTR_EL2 and HFGWTR_EL2 identically was a mistake.
> It makes things hard to reason about, has the potential to
> introduce bugs by giving a meaning to bits that are really reserved,
> and is in general a bad description of the architecture.
> 
> Given that #defines are cheap, let's describe both registers as
> intended by the architecture, and repaint all the existing uses.
> 
> Yes, this is painful.
> 
> The registers themselves are generated from the JSON file in
> an automated way.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/el2_setup.h      |  14 +-
>  arch/arm64/include/asm/kvm_arm.h        |   4 +-
>  arch/arm64/include/asm/kvm_host.h       |   3 +-
>  arch/arm64/kvm/emulate-nested.c         | 154 +++++++++----------
>  arch/arm64/kvm/hyp/include/hyp/switch.h |   4 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c         |   8 +-
>  arch/arm64/kvm/nested.c                 |  42 ++---
>  arch/arm64/kvm/sys_regs.c               |  20 +--
>  arch/arm64/tools/sysreg                 | 194 +++++++++++++++---------
>  9 files changed, 250 insertions(+), 193 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index ebceaae3c749b..055e69a4184ce 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -213,8 +213,8 @@
>  	cbz	x1, .Lskip_debug_fgt_\@
>  
>  	/* Disable nVHE traps of TPIDR2 and SMPRI */
> -	orr	x0, x0, #HFGxTR_EL2_nSMPRI_EL1_MASK
> -	orr	x0, x0, #HFGxTR_EL2_nTPIDR2_EL0_MASK
> +	orr	x0, x0, #HFGRTR_EL2_nSMPRI_EL1_MASK
> +	orr	x0, x0, #HFGRTR_EL2_nTPIDR2_EL0_MASK
>  
>  .Lskip_debug_fgt_\@:
>  	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
> @@ -222,8 +222,8 @@
>  	cbz	x1, .Lskip_pie_fgt_\@
>  
>  	/* Disable trapping of PIR_EL1 / PIRE0_EL1 */
> -	orr	x0, x0, #HFGxTR_EL2_nPIR_EL1
> -	orr	x0, x0, #HFGxTR_EL2_nPIRE0_EL1
> +	orr	x0, x0, #HFGRTR_EL2_nPIR_EL1
> +	orr	x0, x0, #HFGRTR_EL2_nPIRE0_EL1
>  
>  .Lskip_pie_fgt_\@:
>  	mrs_s	x1, SYS_ID_AA64MMFR3_EL1
> @@ -231,7 +231,7 @@
>  	cbz	x1, .Lskip_poe_fgt_\@
>  
>  	/* Disable trapping of POR_EL0 */
> -	orr	x0, x0, #HFGxTR_EL2_nPOR_EL0
> +	orr	x0, x0, #HFGRTR_EL2_nPOR_EL0
>  
>  .Lskip_poe_fgt_\@:
>  	/* GCS depends on PIE so we don't check it if PIE is absent */
> @@ -240,8 +240,8 @@
>  	cbz	x1, .Lset_fgt_\@
>  
>  	/* Disable traps of access to GCS registers at EL0 and EL1 */
> -	orr	x0, x0, #HFGxTR_EL2_nGCS_EL1_MASK
> -	orr	x0, x0, #HFGxTR_EL2_nGCS_EL0_MASK
> +	orr	x0, x0, #HFGRTR_EL2_nGCS_EL1_MASK
> +	orr	x0, x0, #HFGRTR_EL2_nGCS_EL0_MASK
>  
>  .Lset_fgt_\@:
>  	msr_s	SYS_HFGRTR_EL2, x0

We still treat them as the same here, funny that the diff cut off the next line:

	msr_s   SYS_HFGWTR_EL2, x0

Not saying you should do anything about it, I think it's fine.	

> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index f36d067967c33..43a630b940bfb 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -325,7 +325,7 @@
>   * Once we get to a point where the two describe the same thing, we'll
>   * merge the definitions. One day.
>   */
> -#define __HFGRTR_EL2_RES0	HFGxTR_EL2_RES0
> +#define __HFGRTR_EL2_RES0	HFGRTR_EL2_RES0
>  #define __HFGRTR_EL2_MASK	GENMASK(49, 0)
>  #define __HFGRTR_EL2_nMASK	~(__HFGRTR_EL2_RES0 | __HFGRTR_EL2_MASK)
>  
> @@ -336,7 +336,7 @@
>  #define __HFGRTR_ONLY_MASK	(BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
>  				 GENMASK(26, 25) | BIT(21) | BIT(18) | \
>  				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
> -#define __HFGWTR_EL2_RES0	(__HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)
> +#define __HFGWTR_EL2_RES0	HFGWTR_EL2_RES0
>  #define __HFGWTR_EL2_MASK	(__HFGRTR_EL2_MASK & ~__HFGRTR_ONLY_MASK)
>  #define __HFGWTR_EL2_nMASK	~(__HFGWTR_EL2_RES0 | __HFGWTR_EL2_MASK)
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e98cfe7855a62..7a1ef5be7efb2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -273,7 +273,8 @@ struct kvm_sysreg_masks;
>  
>  enum fgt_group_id {
>  	__NO_FGT_GROUP__,
> -	HFGxTR_GROUP,
> +	HFGRTR_GROUP,
> +	HFGWTR_GROUP = HFGRTR_GROUP,

I think this change makes most of the diffs using this enum more confusing, but
it also seems to algin the code more closely with HDFGWTR_EL2 and HDFGWTR_EL2.

>  	HDFGRTR_GROUP,
>  	HDFGWTR_GROUP = HDFGRTR_GROUP,
>  	HFGITR_GROUP,
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 0fcfcc0478f94..efe1eb3f1bd07 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1296,81 +1296,81 @@ enum fg_filter_id {
>  
>  static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>  	/* HFGRTR_EL2, HFGWTR_EL2 */
> -	SR_FGT(SYS_AMAIR2_EL1,		HFGxTR, nAMAIR2_EL1, 0),
> -	SR_FGT(SYS_MAIR2_EL1,		HFGxTR, nMAIR2_EL1, 0),
> -	SR_FGT(SYS_S2POR_EL1,		HFGxTR, nS2POR_EL1, 0),
> -	SR_FGT(SYS_POR_EL1,		HFGxTR, nPOR_EL1, 0),
> -	SR_FGT(SYS_POR_EL0,		HFGxTR, nPOR_EL0, 0),
> -	SR_FGT(SYS_PIR_EL1,		HFGxTR, nPIR_EL1, 0),
> -	SR_FGT(SYS_PIRE0_EL1,		HFGxTR, nPIRE0_EL1, 0),
> -	SR_FGT(SYS_RCWMASK_EL1,		HFGxTR, nRCWMASK_EL1, 0),
> -	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
> -	SR_FGT(SYS_SMPRI_EL1,		HFGxTR, nSMPRI_EL1, 0),
> -	SR_FGT(SYS_GCSCR_EL1,		HFGxTR, nGCS_EL1, 0),
> -	SR_FGT(SYS_GCSPR_EL1,		HFGxTR, nGCS_EL1, 0),
> -	SR_FGT(SYS_GCSCRE0_EL1,		HFGxTR, nGCS_EL0, 0),
> -	SR_FGT(SYS_GCSPR_EL0,		HFGxTR, nGCS_EL0, 0),
> -	SR_FGT(SYS_ACCDATA_EL1,		HFGxTR, nACCDATA_EL1, 0),
> -	SR_FGT(SYS_ERXADDR_EL1,		HFGxTR, ERXADDR_EL1, 1),
> -	SR_FGT(SYS_ERXPFGCDN_EL1,	HFGxTR, ERXPFGCDN_EL1, 1),
> -	SR_FGT(SYS_ERXPFGCTL_EL1,	HFGxTR, ERXPFGCTL_EL1, 1),
> -	SR_FGT(SYS_ERXPFGF_EL1,		HFGxTR, ERXPFGF_EL1, 1),
> -	SR_FGT(SYS_ERXMISC0_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> -	SR_FGT(SYS_ERXMISC1_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> -	SR_FGT(SYS_ERXMISC2_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> -	SR_FGT(SYS_ERXMISC3_EL1,	HFGxTR, ERXMISCn_EL1, 1),
> -	SR_FGT(SYS_ERXSTATUS_EL1,	HFGxTR, ERXSTATUS_EL1, 1),
> -	SR_FGT(SYS_ERXCTLR_EL1,		HFGxTR, ERXCTLR_EL1, 1),
> -	SR_FGT(SYS_ERXFR_EL1,		HFGxTR, ERXFR_EL1, 1),
> -	SR_FGT(SYS_ERRSELR_EL1,		HFGxTR, ERRSELR_EL1, 1),
> -	SR_FGT(SYS_ERRIDR_EL1,		HFGxTR, ERRIDR_EL1, 1),
> -	SR_FGT(SYS_ICC_IGRPEN0_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
> -	SR_FGT(SYS_ICC_IGRPEN1_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
> -	SR_FGT(SYS_VBAR_EL1,		HFGxTR, VBAR_EL1, 1),
> -	SR_FGT(SYS_TTBR1_EL1,		HFGxTR, TTBR1_EL1, 1),
> -	SR_FGT(SYS_TTBR0_EL1,		HFGxTR, TTBR0_EL1, 1),
> -	SR_FGT(SYS_TPIDR_EL0,		HFGxTR, TPIDR_EL0, 1),
> -	SR_FGT(SYS_TPIDRRO_EL0,		HFGxTR, TPIDRRO_EL0, 1),
> -	SR_FGT(SYS_TPIDR_EL1,		HFGxTR, TPIDR_EL1, 1),
> -	SR_FGT(SYS_TCR_EL1,		HFGxTR, TCR_EL1, 1),
> -	SR_FGT(SYS_TCR2_EL1,		HFGxTR, TCR_EL1, 1),
> -	SR_FGT(SYS_SCXTNUM_EL0,		HFGxTR, SCXTNUM_EL0, 1),
> -	SR_FGT(SYS_SCXTNUM_EL1, 	HFGxTR, SCXTNUM_EL1, 1),
> -	SR_FGT(SYS_SCTLR_EL1, 		HFGxTR, SCTLR_EL1, 1),
> -	SR_FGT(SYS_REVIDR_EL1, 		HFGxTR, REVIDR_EL1, 1),
> -	SR_FGT(SYS_PAR_EL1, 		HFGxTR, PAR_EL1, 1),
> -	SR_FGT(SYS_MPIDR_EL1, 		HFGxTR, MPIDR_EL1, 1),
> -	SR_FGT(SYS_MIDR_EL1, 		HFGxTR, MIDR_EL1, 1),
> -	SR_FGT(SYS_MAIR_EL1, 		HFGxTR, MAIR_EL1, 1),
> -	SR_FGT(SYS_LORSA_EL1, 		HFGxTR, LORSA_EL1, 1),
> -	SR_FGT(SYS_LORN_EL1, 		HFGxTR, LORN_EL1, 1),
> -	SR_FGT(SYS_LORID_EL1, 		HFGxTR, LORID_EL1, 1),
> -	SR_FGT(SYS_LOREA_EL1, 		HFGxTR, LOREA_EL1, 1),
> -	SR_FGT(SYS_LORC_EL1, 		HFGxTR, LORC_EL1, 1),
> -	SR_FGT(SYS_ISR_EL1, 		HFGxTR, ISR_EL1, 1),
> -	SR_FGT(SYS_FAR_EL1, 		HFGxTR, FAR_EL1, 1),
> -	SR_FGT(SYS_ESR_EL1, 		HFGxTR, ESR_EL1, 1),
> -	SR_FGT(SYS_DCZID_EL0, 		HFGxTR, DCZID_EL0, 1),
> -	SR_FGT(SYS_CTR_EL0, 		HFGxTR, CTR_EL0, 1),
> -	SR_FGT(SYS_CSSELR_EL1, 		HFGxTR, CSSELR_EL1, 1),
> -	SR_FGT(SYS_CPACR_EL1, 		HFGxTR, CPACR_EL1, 1),
> -	SR_FGT(SYS_CONTEXTIDR_EL1, 	HFGxTR, CONTEXTIDR_EL1, 1),
> -	SR_FGT(SYS_CLIDR_EL1, 		HFGxTR, CLIDR_EL1, 1),
> -	SR_FGT(SYS_CCSIDR_EL1, 		HFGxTR, CCSIDR_EL1, 1),
> -	SR_FGT(SYS_APIBKEYLO_EL1, 	HFGxTR, APIBKey, 1),
> -	SR_FGT(SYS_APIBKEYHI_EL1, 	HFGxTR, APIBKey, 1),
> -	SR_FGT(SYS_APIAKEYLO_EL1, 	HFGxTR, APIAKey, 1),
> -	SR_FGT(SYS_APIAKEYHI_EL1, 	HFGxTR, APIAKey, 1),
> -	SR_FGT(SYS_APGAKEYLO_EL1, 	HFGxTR, APGAKey, 1),
> -	SR_FGT(SYS_APGAKEYHI_EL1, 	HFGxTR, APGAKey, 1),
> -	SR_FGT(SYS_APDBKEYLO_EL1, 	HFGxTR, APDBKey, 1),
> -	SR_FGT(SYS_APDBKEYHI_EL1, 	HFGxTR, APDBKey, 1),
> -	SR_FGT(SYS_APDAKEYLO_EL1, 	HFGxTR, APDAKey, 1),
> -	SR_FGT(SYS_APDAKEYHI_EL1, 	HFGxTR, APDAKey, 1),
> -	SR_FGT(SYS_AMAIR_EL1, 		HFGxTR, AMAIR_EL1, 1),
> -	SR_FGT(SYS_AIDR_EL1, 		HFGxTR, AIDR_EL1, 1),
> -	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
> -	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
> +	SR_FGT(SYS_AMAIR2_EL1,		HFGRTR, nAMAIR2_EL1, 0),
> +	SR_FGT(SYS_MAIR2_EL1,		HFGRTR, nMAIR2_EL1, 0),
> +	SR_FGT(SYS_S2POR_EL1,		HFGRTR, nS2POR_EL1, 0),
> +	SR_FGT(SYS_POR_EL1,		HFGRTR, nPOR_EL1, 0),
> +	SR_FGT(SYS_POR_EL0,		HFGRTR, nPOR_EL0, 0),
> +	SR_FGT(SYS_PIR_EL1,		HFGRTR, nPIR_EL1, 0),
> +	SR_FGT(SYS_PIRE0_EL1,		HFGRTR, nPIRE0_EL1, 0),
> +	SR_FGT(SYS_RCWMASK_EL1,		HFGRTR, nRCWMASK_EL1, 0),
> +	SR_FGT(SYS_TPIDR2_EL0,		HFGRTR, nTPIDR2_EL0, 0),
> +	SR_FGT(SYS_SMPRI_EL1,		HFGRTR, nSMPRI_EL1, 0),
> +	SR_FGT(SYS_GCSCR_EL1,		HFGRTR, nGCS_EL1, 0),
> +	SR_FGT(SYS_GCSPR_EL1,		HFGRTR, nGCS_EL1, 0),
> +	SR_FGT(SYS_GCSCRE0_EL1,		HFGRTR, nGCS_EL0, 0),
> +	SR_FGT(SYS_GCSPR_EL0,		HFGRTR, nGCS_EL0, 0),
> +	SR_FGT(SYS_ACCDATA_EL1,		HFGRTR, nACCDATA_EL1, 0),
> +	SR_FGT(SYS_ERXADDR_EL1,		HFGRTR, ERXADDR_EL1, 1),
> +	SR_FGT(SYS_ERXPFGCDN_EL1,	HFGRTR, ERXPFGCDN_EL1, 1),
> +	SR_FGT(SYS_ERXPFGCTL_EL1,	HFGRTR, ERXPFGCTL_EL1, 1),
> +	SR_FGT(SYS_ERXPFGF_EL1,		HFGRTR, ERXPFGF_EL1, 1),
> +	SR_FGT(SYS_ERXMISC0_EL1,	HFGRTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXMISC1_EL1,	HFGRTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXMISC2_EL1,	HFGRTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXMISC3_EL1,	HFGRTR, ERXMISCn_EL1, 1),
> +	SR_FGT(SYS_ERXSTATUS_EL1,	HFGRTR, ERXSTATUS_EL1, 1),
> +	SR_FGT(SYS_ERXCTLR_EL1,		HFGRTR, ERXCTLR_EL1, 1),
> +	SR_FGT(SYS_ERXFR_EL1,		HFGRTR, ERXFR_EL1, 1),
> +	SR_FGT(SYS_ERRSELR_EL1,		HFGRTR, ERRSELR_EL1, 1),
> +	SR_FGT(SYS_ERRIDR_EL1,		HFGRTR, ERRIDR_EL1, 1),
> +	SR_FGT(SYS_ICC_IGRPEN0_EL1,	HFGRTR, ICC_IGRPENn_EL1, 1),
> +	SR_FGT(SYS_ICC_IGRPEN1_EL1,	HFGRTR, ICC_IGRPENn_EL1, 1),
> +	SR_FGT(SYS_VBAR_EL1,		HFGRTR, VBAR_EL1, 1),
> +	SR_FGT(SYS_TTBR1_EL1,		HFGRTR, TTBR1_EL1, 1),
> +	SR_FGT(SYS_TTBR0_EL1,		HFGRTR, TTBR0_EL1, 1),
> +	SR_FGT(SYS_TPIDR_EL0,		HFGRTR, TPIDR_EL0, 1),
> +	SR_FGT(SYS_TPIDRRO_EL0,		HFGRTR, TPIDRRO_EL0, 1),
> +	SR_FGT(SYS_TPIDR_EL1,		HFGRTR, TPIDR_EL1, 1),
> +	SR_FGT(SYS_TCR_EL1,		HFGRTR, TCR_EL1, 1),
> +	SR_FGT(SYS_TCR2_EL1,		HFGRTR, TCR_EL1, 1),
> +	SR_FGT(SYS_SCXTNUM_EL0,		HFGRTR, SCXTNUM_EL0, 1),
> +	SR_FGT(SYS_SCXTNUM_EL1, 	HFGRTR, SCXTNUM_EL1, 1),
> +	SR_FGT(SYS_SCTLR_EL1, 		HFGRTR, SCTLR_EL1, 1),
> +	SR_FGT(SYS_REVIDR_EL1, 		HFGRTR, REVIDR_EL1, 1),
> +	SR_FGT(SYS_PAR_EL1, 		HFGRTR, PAR_EL1, 1),
> +	SR_FGT(SYS_MPIDR_EL1, 		HFGRTR, MPIDR_EL1, 1),
> +	SR_FGT(SYS_MIDR_EL1, 		HFGRTR, MIDR_EL1, 1),
> +	SR_FGT(SYS_MAIR_EL1, 		HFGRTR, MAIR_EL1, 1),
> +	SR_FGT(SYS_LORSA_EL1, 		HFGRTR, LORSA_EL1, 1),
> +	SR_FGT(SYS_LORN_EL1, 		HFGRTR, LORN_EL1, 1),
> +	SR_FGT(SYS_LORID_EL1, 		HFGRTR, LORID_EL1, 1),
> +	SR_FGT(SYS_LOREA_EL1, 		HFGRTR, LOREA_EL1, 1),
> +	SR_FGT(SYS_LORC_EL1, 		HFGRTR, LORC_EL1, 1),
> +	SR_FGT(SYS_ISR_EL1, 		HFGRTR, ISR_EL1, 1),
> +	SR_FGT(SYS_FAR_EL1, 		HFGRTR, FAR_EL1, 1),
> +	SR_FGT(SYS_ESR_EL1, 		HFGRTR, ESR_EL1, 1),
> +	SR_FGT(SYS_DCZID_EL0, 		HFGRTR, DCZID_EL0, 1),
> +	SR_FGT(SYS_CTR_EL0, 		HFGRTR, CTR_EL0, 1),
> +	SR_FGT(SYS_CSSELR_EL1, 		HFGRTR, CSSELR_EL1, 1),
> +	SR_FGT(SYS_CPACR_EL1, 		HFGRTR, CPACR_EL1, 1),
> +	SR_FGT(SYS_CONTEXTIDR_EL1, 	HFGRTR, CONTEXTIDR_EL1, 1),
> +	SR_FGT(SYS_CLIDR_EL1, 		HFGRTR, CLIDR_EL1, 1),
> +	SR_FGT(SYS_CCSIDR_EL1, 		HFGRTR, CCSIDR_EL1, 1),
> +	SR_FGT(SYS_APIBKEYLO_EL1, 	HFGRTR, APIBKey, 1),
> +	SR_FGT(SYS_APIBKEYHI_EL1, 	HFGRTR, APIBKey, 1),
> +	SR_FGT(SYS_APIAKEYLO_EL1, 	HFGRTR, APIAKey, 1),
> +	SR_FGT(SYS_APIAKEYHI_EL1, 	HFGRTR, APIAKey, 1),
> +	SR_FGT(SYS_APGAKEYLO_EL1, 	HFGRTR, APGAKey, 1),
> +	SR_FGT(SYS_APGAKEYHI_EL1, 	HFGRTR, APGAKey, 1),
> +	SR_FGT(SYS_APDBKEYLO_EL1, 	HFGRTR, APDBKey, 1),
> +	SR_FGT(SYS_APDBKEYHI_EL1, 	HFGRTR, APDBKey, 1),
> +	SR_FGT(SYS_APDAKEYLO_EL1, 	HFGRTR, APDAKey, 1),
> +	SR_FGT(SYS_APDAKEYHI_EL1, 	HFGRTR, APDAKey, 1),
> +	SR_FGT(SYS_AMAIR_EL1, 		HFGRTR, AMAIR_EL1, 1),
> +	SR_FGT(SYS_AIDR_EL1, 		HFGRTR, AIDR_EL1, 1),
> +	SR_FGT(SYS_AFSR1_EL1, 		HFGRTR, AFSR1_EL1, 1),
> +	SR_FGT(SYS_AFSR0_EL1, 		HFGRTR, AFSR0_EL1, 1),
>  	/* HFGITR_EL2 */
>  	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
>  	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
> @@ -2243,7 +2243,7 @@ static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
>  		return false;
>  
>  	switch ((enum fgt_group_id)tc.fgt) {
> -	case HFGxTR_GROUP:
> +	case HFGRTR_GROUP:
>  		sr = is_read ? HFGRTR_EL2 : HFGWTR_EL2;
>  		break;
>  
> @@ -2319,7 +2319,7 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
>  	case __NO_FGT_GROUP__:
>  		break;
>  
> -	case HFGxTR_GROUP:
> +	case HFGRTR_GROUP:
>  		if (is_read)
>  			val = __vcpu_sys_reg(vcpu, HFGRTR_EL2);
>  		else
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index b741ea6aefa58..3150e42d79341 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -79,7 +79,7 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  		switch(reg) {						\
>  		case HFGRTR_EL2:					\
>  		case HFGWTR_EL2:					\
> -			id = HFGxTR_GROUP;				\
> +			id = HFGRTR_GROUP;				\
>  			break;						\
>  		case HFGITR_EL2:					\
>  			id = HFGITR_GROUP;				\
> @@ -166,7 +166,7 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  	update_fgt_traps(hctxt, vcpu, kvm, HFGRTR_EL2);
>  	update_fgt_traps_cs(hctxt, vcpu, kvm, HFGWTR_EL2, 0,
>  			    cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38) ?
> -			    HFGxTR_EL2_TCR_EL1_MASK : 0);
> +			    HFGWTR_EL2_TCR_EL1_MASK : 0);
>  	update_fgt_traps(hctxt, vcpu, kvm, HFGITR_EL2);
>  	update_fgt_traps(hctxt, vcpu, kvm, HDFGRTR_EL2);
>  	update_fgt_traps(hctxt, vcpu, kvm, HDFGWTR_EL2);
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index ed363aa3027e5..f38565e28a23a 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -1052,11 +1052,11 @@ static bool __vgic_v3_check_trap_forwarding(struct kvm_vcpu *vcpu,
>  	switch (sysreg) {
>  	case SYS_ICC_IGRPEN0_EL1:
>  		if (is_read &&
> -		    (__vcpu_sys_reg(vcpu, HFGRTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
> +		    (__vcpu_sys_reg(vcpu, HFGRTR_EL2) & HFGRTR_EL2_ICC_IGRPENn_EL1))
>  			return true;
>  
>  		if (!is_read &&
> -		    (__vcpu_sys_reg(vcpu, HFGWTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
> +		    (__vcpu_sys_reg(vcpu, HFGWTR_EL2) & HFGWTR_EL2_ICC_IGRPENn_EL1))
>  			return true;
>  
>  		fallthrough;
> @@ -1073,11 +1073,11 @@ static bool __vgic_v3_check_trap_forwarding(struct kvm_vcpu *vcpu,
>  
>  	case SYS_ICC_IGRPEN1_EL1:
>  		if (is_read &&
> -		    (__vcpu_sys_reg(vcpu, HFGRTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
> +		    (__vcpu_sys_reg(vcpu, HFGRTR_EL2) & HFGRTR_EL2_ICC_IGRPENn_EL1))
>  			return true;
>  
>  		if (!is_read &&
> -		    (__vcpu_sys_reg(vcpu, HFGWTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
> +		    (__vcpu_sys_reg(vcpu, HFGWTR_EL2) & HFGWTR_EL2_ICC_IGRPENn_EL1))
>  			return true;
>  
>  		fallthrough;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 4a3fc11f7ecf3..16f6129c70b59 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1103,40 +1103,40 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	res0 = res1 = 0;
>  	if (!(kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
>  	      kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC)))
> -		res0 |= (HFGxTR_EL2_APDAKey | HFGxTR_EL2_APDBKey |
> -			 HFGxTR_EL2_APGAKey | HFGxTR_EL2_APIAKey |
> -			 HFGxTR_EL2_APIBKey);
> +		res0 |= (HFGRTR_EL2_APDAKey | HFGRTR_EL2_APDBKey |
> +			 HFGRTR_EL2_APGAKey | HFGRTR_EL2_APIAKey |
> +			 HFGRTR_EL2_APIBKey);
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
> -		res0 |= (HFGxTR_EL2_LORC_EL1 | HFGxTR_EL2_LOREA_EL1 |
> -			 HFGxTR_EL2_LORID_EL1 | HFGxTR_EL2_LORN_EL1 |
> -			 HFGxTR_EL2_LORSA_EL1);
> +		res0 |= (HFGRTR_EL2_LORC_EL1 | HFGRTR_EL2_LOREA_EL1 |
> +			 HFGRTR_EL2_LORID_EL1 | HFGRTR_EL2_LORN_EL1 |
> +			 HFGRTR_EL2_LORSA_EL1);
>  	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
>  	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
> -		res0 |= (HFGxTR_EL2_SCXTNUM_EL1 | HFGxTR_EL2_SCXTNUM_EL0);
> +		res0 |= (HFGRTR_EL2_SCXTNUM_EL1 | HFGRTR_EL2_SCXTNUM_EL0);
>  	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP))
> -		res0 |= HFGxTR_EL2_ICC_IGRPENn_EL1;
> +		res0 |= HFGRTR_EL2_ICC_IGRPENn_EL1;
>  	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
> -		res0 |= (HFGxTR_EL2_ERRIDR_EL1 | HFGxTR_EL2_ERRSELR_EL1 |
> -			 HFGxTR_EL2_ERXFR_EL1 | HFGxTR_EL2_ERXCTLR_EL1 |
> -			 HFGxTR_EL2_ERXSTATUS_EL1 | HFGxTR_EL2_ERXMISCn_EL1 |
> -			 HFGxTR_EL2_ERXPFGF_EL1 | HFGxTR_EL2_ERXPFGCTL_EL1 |
> -			 HFGxTR_EL2_ERXPFGCDN_EL1 | HFGxTR_EL2_ERXADDR_EL1);
> +		res0 |= (HFGRTR_EL2_ERRIDR_EL1 | HFGRTR_EL2_ERRSELR_EL1 |
> +			 HFGRTR_EL2_ERXFR_EL1 | HFGRTR_EL2_ERXCTLR_EL1 |
> +			 HFGRTR_EL2_ERXSTATUS_EL1 | HFGRTR_EL2_ERXMISCn_EL1 |
> +			 HFGRTR_EL2_ERXPFGF_EL1 | HFGRTR_EL2_ERXPFGCTL_EL1 |
> +			 HFGRTR_EL2_ERXPFGCDN_EL1 | HFGRTR_EL2_ERXADDR_EL1);
>  	if (!kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA))
> -		res0 |= HFGxTR_EL2_nACCDATA_EL1;
> +		res0 |= HFGRTR_EL2_nACCDATA_EL1;
>  	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -		res0 |= (HFGxTR_EL2_nGCS_EL0 | HFGxTR_EL2_nGCS_EL1);
> +		res0 |= (HFGRTR_EL2_nGCS_EL0 | HFGRTR_EL2_nGCS_EL1);
>  	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
> -		res0 |= (HFGxTR_EL2_nSMPRI_EL1 | HFGxTR_EL2_nTPIDR2_EL0);
> +		res0 |= (HFGRTR_EL2_nSMPRI_EL1 | HFGRTR_EL2_nTPIDR2_EL0);
>  	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> -		res0 |= HFGxTR_EL2_nRCWMASK_EL1;
> +		res0 |= HFGRTR_EL2_nRCWMASK_EL1;
>  	if (!kvm_has_s1pie(kvm))
> -		res0 |= (HFGxTR_EL2_nPIRE0_EL1 | HFGxTR_EL2_nPIR_EL1);
> +		res0 |= (HFGRTR_EL2_nPIRE0_EL1 | HFGRTR_EL2_nPIR_EL1);
>  	if (!kvm_has_s1poe(kvm))
> -		res0 |= (HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nPOR_EL1);
> +		res0 |= (HFGRTR_EL2_nPOR_EL0 | HFGRTR_EL2_nPOR_EL1);
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
> -		res0 |= HFGxTR_EL2_nS2POR_EL1;
> +		res0 |= HFGRTR_EL2_nS2POR_EL1;
>  	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
> -		res0 |= (HFGxTR_EL2_nMAIR2_EL1 | HFGxTR_EL2_nAMAIR2_EL1);
> +		res0 |= (HFGRTR_EL2_nMAIR2_EL1 | HFGRTR_EL2_nAMAIR2_EL1);
>  	set_sysreg_masks(kvm, HFGRTR_EL2, res0 | __HFGRTR_EL2_RES0, res1);
>  	set_sysreg_masks(kvm, HFGWTR_EL2, res0 | __HFGWTR_EL2_RES0, res1);
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 005ad28f73068..6e01b06bedcae 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5147,12 +5147,12 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>  	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
>  		goto out;
>  
> -	kvm->arch.fgu[HFGxTR_GROUP] = (HFGxTR_EL2_nAMAIR2_EL1		|
> -				       HFGxTR_EL2_nMAIR2_EL1		|
> -				       HFGxTR_EL2_nS2POR_EL1		|
> -				       HFGxTR_EL2_nACCDATA_EL1		|
> -				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
> -				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
> +	kvm->arch.fgu[HFGRTR_GROUP] = (HFGRTR_EL2_nAMAIR2_EL1		|
> +				       HFGRTR_EL2_nMAIR2_EL1		|
> +				       HFGRTR_EL2_nS2POR_EL1		|
> +				       HFGRTR_EL2_nACCDATA_EL1		|
> +				       HFGRTR_EL2_nSMPRI_EL1_MASK	|
> +				       HFGRTR_EL2_nTPIDR2_EL0_MASK);

For example here you see HFGRTR_GROUP but it actually also applies to HFGWTR_GROUP.

>  
>  	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
>  		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
> @@ -5188,12 +5188,12 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
>  						HFGITR_EL2_ATS1E1WP);
>  
>  	if (!kvm_has_s1pie(kvm))
> -		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
> -						HFGxTR_EL2_nPIR_EL1);
> +		kvm->arch.fgu[HFGRTR_GROUP] |= (HFGRTR_EL2_nPIRE0_EL1 |
> +						HFGRTR_EL2_nPIR_EL1);
>  
>  	if (!kvm_has_s1poe(kvm))
> -		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPOR_EL1 |
> -						HFGxTR_EL2_nPOR_EL0);
> +		kvm->arch.fgu[HFGRTR_GROUP] |= (HFGRTR_EL2_nPOR_EL1 |
> +						HFGRTR_EL2_nPOR_EL0);
>  
>  	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
>  		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 7f39c8f7f036d..e21e881314a33 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2464,73 +2464,6 @@ UnsignedEnum	2:0	F8S1
>  EndEnum
>  EndSysreg
>  
> -SysregFields	HFGxTR_EL2
> -Field	63	nAMAIR2_EL1
> -Field	62	nMAIR2_EL1
> -Field	61	nS2POR_EL1
> -Field	60	nPOR_EL1
> -Field	59	nPOR_EL0
> -Field	58	nPIR_EL1
> -Field	57	nPIRE0_EL1
> -Field	56	nRCWMASK_EL1
> -Field	55	nTPIDR2_EL0
> -Field	54	nSMPRI_EL1
> -Field	53	nGCS_EL1
> -Field	52	nGCS_EL0
> -Res0	51
> -Field	50	nACCDATA_EL1
> -Field	49	ERXADDR_EL1
> -Field	48	ERXPFGCDN_EL1
> -Field	47	ERXPFGCTL_EL1
> -Field	46	ERXPFGF_EL1
> -Field	45	ERXMISCn_EL1
> -Field	44	ERXSTATUS_EL1
> -Field	43	ERXCTLR_EL1
> -Field	42	ERXFR_EL1
> -Field	41	ERRSELR_EL1
> -Field	40	ERRIDR_EL1
> -Field	39	ICC_IGRPENn_EL1
> -Field	38	VBAR_EL1
> -Field	37	TTBR1_EL1
> -Field	36	TTBR0_EL1
> -Field	35	TPIDR_EL0
> -Field	34	TPIDRRO_EL0
> -Field	33	TPIDR_EL1
> -Field	32	TCR_EL1
> -Field	31	SCXTNUM_EL0
> -Field	30	SCXTNUM_EL1
> -Field	29	SCTLR_EL1
> -Field	28	REVIDR_EL1
> -Field	27	PAR_EL1
> -Field	26	MPIDR_EL1
> -Field	25	MIDR_EL1
> -Field	24	MAIR_EL1
> -Field	23	LORSA_EL1
> -Field	22	LORN_EL1
> -Field	21	LORID_EL1
> -Field	20	LOREA_EL1
> -Field	19	LORC_EL1
> -Field	18	ISR_EL1
> -Field	17	FAR_EL1
> -Field	16	ESR_EL1
> -Field	15	DCZID_EL0
> -Field	14	CTR_EL0
> -Field	13	CSSELR_EL1
> -Field	12	CPACR_EL1
> -Field	11	CONTEXTIDR_EL1
> -Field	10	CLIDR_EL1
> -Field	9	CCSIDR_EL1
> -Field	8	APIBKey
> -Field	7	APIAKey
> -Field	6	APGAKey
> -Field	5	APDBKey
> -Field	4	APDAKey
> -Field	3	AMAIR_EL1
> -Field	2	AIDR_EL1
> -Field	1	AFSR1_EL1
> -Field	0	AFSR0_EL1
> -EndSysregFields
> -
>  Sysreg	HCR_EL2		3	4	1	1	0
>  Field	63:60	TWEDEL
>  Field	59	TWEDEn
> @@ -2635,11 +2568,134 @@ Field	4:0	HPMN
>  EndSysreg
>  
>  Sysreg HFGRTR_EL2	3	4	1	1	4
> -Fields	HFGxTR_EL2
> +Field	63	nAMAIR2_EL1
> +Field	62	nMAIR2_EL1
> +Field	61	nS2POR_EL1
> +Field	60	nPOR_EL1
> +Field	59	nPOR_EL0
> +Field	58	nPIR_EL1
> +Field	57	nPIRE0_EL1
> +Field	56	nRCWMASK_EL1
> +Field	55	nTPIDR2_EL0
> +Field	54	nSMPRI_EL1
> +Field	53	nGCS_EL1
> +Field	52	nGCS_EL0
> +Res0	51
> +Field	50	nACCDATA_EL1
> +Field	49	ERXADDR_EL1
> +Field	48	ERXPFGCDN_EL1
> +Field	47	ERXPFGCTL_EL1
> +Field	46	ERXPFGF_EL1
> +Field	45	ERXMISCn_EL1
> +Field	44	ERXSTATUS_EL1
> +Field	43	ERXCTLR_EL1
> +Field	42	ERXFR_EL1
> +Field	41	ERRSELR_EL1
> +Field	40	ERRIDR_EL1
> +Field	39	ICC_IGRPENn_EL1
> +Field	38	VBAR_EL1
> +Field	37	TTBR1_EL1
> +Field	36	TTBR0_EL1
> +Field	35	TPIDR_EL0
> +Field	34	TPIDRRO_EL0
> +Field	33	TPIDR_EL1
> +Field	32	TCR_EL1
> +Field	31	SCXTNUM_EL0
> +Field	30	SCXTNUM_EL1
> +Field	29	SCTLR_EL1
> +Field	28	REVIDR_EL1
> +Field	27	PAR_EL1
> +Field	26	MPIDR_EL1
> +Field	25	MIDR_EL1
> +Field	24	MAIR_EL1
> +Field	23	LORSA_EL1
> +Field	22	LORN_EL1
> +Field	21	LORID_EL1
> +Field	20	LOREA_EL1
> +Field	19	LORC_EL1
> +Field	18	ISR_EL1
> +Field	17	FAR_EL1
> +Field	16	ESR_EL1
> +Field	15	DCZID_EL0
> +Field	14	CTR_EL0
> +Field	13	CSSELR_EL1
> +Field	12	CPACR_EL1
> +Field	11	CONTEXTIDR_EL1
> +Field	10	CLIDR_EL1
> +Field	9	CCSIDR_EL1
> +Field	8	APIBKey
> +Field	7	APIAKey
> +Field	6	APGAKey
> +Field	5	APDBKey
> +Field	4	APDAKey
> +Field	3	AMAIR_EL1
> +Field	2	AIDR_EL1
> +Field	1	AFSR1_EL1
> +Field	0	AFSR0_EL1
>  EndSysreg
>  
>  Sysreg HFGWTR_EL2	3	4	1	1	5
> -Fields	HFGxTR_EL2
> +Field	63	nAMAIR2_EL1
> +Field	62	nMAIR2_EL1
> +Field	61	nS2POR_EL1
> +Field	60	nPOR_EL1
> +Field	59	nPOR_EL0
> +Field	58	nPIR_EL1
> +Field	57	nPIRE0_EL1
> +Field	56	nRCWMASK_EL1
> +Field	55	nTPIDR2_EL0
> +Field	54	nSMPRI_EL1
> +Field	53	nGCS_EL1
> +Field	52	nGCS_EL0
> +Res0	51
> +Field	50	nACCDATA_EL1
> +Field	49	ERXADDR_EL1
> +Field	48	ERXPFGCDN_EL1
> +Field	47	ERXPFGCTL_EL1
> +Res0	46
> +Field	45	ERXMISCn_EL1
> +Field	44	ERXSTATUS_EL1
> +Field	43	ERXCTLR_EL1
> +Res0	42
> +Field	41	ERRSELR_EL1
> +Res0	40
> +Field	39	ICC_IGRPENn_EL1
> +Field	38	VBAR_EL1
> +Field	37	TTBR1_EL1
> +Field	36	TTBR0_EL1
> +Field	35	TPIDR_EL0
> +Field	34	TPIDRRO_EL0
> +Field	33	TPIDR_EL1
> +Field	32	TCR_EL1
> +Field	31	SCXTNUM_EL0
> +Field	30	SCXTNUM_EL1
> +Field	29	SCTLR_EL1
> +Res0	28
> +Field	27	PAR_EL1
> +Res0	26:25	
> +Field	24	MAIR_EL1
> +Field	23	LORSA_EL1
> +Field	22	LORN_EL1
> +Res0	21
> +Field	20	LOREA_EL1
> +Field	19	LORC_EL1
> +Res0	18
> +Field	17	FAR_EL1
> +Field	16	ESR_EL1
> +Res0	15:14
> +Field	13	CSSELR_EL1
> +Field	12	CPACR_EL1
> +Field	11	CONTEXTIDR_EL1
> +Res0	10:9
> +Field	8	APIBKey
> +Field	7	APIAKey
> +Field	6	APGAKey
> +Field	5	APDBKey
> +Field	4	APDAKey
> +Field	3	AMAIR_EL1
> +Res0	2
> +Field	1	AFSR1_EL1
> +Field	0	AFSR0_EL1
>  EndSysreg
>  
>  Sysreg HFGITR_EL2	3	4	1	1	6
> -- 
> 2.39.2
> 

