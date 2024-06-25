Return-Path: <kvm+bounces-20493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B50916ABB
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 16:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7AA91C217B1
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 14:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD65016D4CA;
	Tue, 25 Jun 2024 14:40:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BA516CD0A
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719326416; cv=none; b=Q2o0nh2PxpImUXq+LyX4g2YADHleYexJzuUjUXGSBkotCE4QuY0MhKs8WGrOEyYnnACpSzDTDaonpxL2NpKS6aPw5LZvatGAwGi6huu23/AbaAEzftC4iSZXaAiw8FumXQ4jEjO7oKWk9S7D+21izoHBT5BkF9xTLheHbsUmuKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719326416; c=relaxed/simple;
	bh=g2OcnpR9Vr2xV3mX5BqIKQPIXjsSgI5slclVS1pdFUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fO8e6EHnV+dSD8DN1eZAuC5iAGVYqIMTdZRcfnSPhsnEYExd0pZvIN5Q/J6yvAYbJ3IEIMDj6mUQRRSHOdx8NHTCmyWCza6c7Vyvg+QsfA3alreZbef4LSJ9kdezZhf9QYLtU3P/iwkLgnyJfL2OL8kxbhKjIpH+ll1sn5bwoGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B633339;
	Tue, 25 Jun 2024 07:40:39 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16FDC3F73B;
	Tue, 25 Jun 2024 07:40:12 -0700 (PDT)
Date: Tue, 25 Jun 2024 15:40:10 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/5] KVM: arm64: Get rid of HCRX_GUEST_FLAGS
Message-ID: <20240625144010.GB1517668@e124191.cambridge.arm.com>
References: <20240625130042.259175-1-maz@kernel.org>
 <20240625130042.259175-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625130042.259175-3-maz@kernel.org>

On Tue, Jun 25, 2024 at 02:00:38PM +0100, Marc Zyngier wrote:
> HCRX_GUEST_FLAGS gives random KVM hackers the impression that
> they can stuff bits in this macro and unconditionally enable
> features in the guest.
> 
> In general, this is wrong (we have been there with FEAT_MOPS,
> and again with FEAT_TCRX).
> 
> Document that HCRX_EL2.SMPME is an exception rather than the rule,
> and get rid of HCRX_GUEST_FLAGS.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 1 -
>  arch/arm64/kvm/sys_regs.c        | 8 +++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index e6682a3ace5af..d81cc746e0ebd 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -102,7 +102,6 @@
>  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
>  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
>  
> -#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME)
>  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
>  
>  /* TCR_EL2 Registers bits */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 71996d36f3751..8e22232c4b0f4 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4062,7 +4062,13 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
>  
>  	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> -		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
> +		/*
> +		 * In general, all HCRX_EL2 bits are gated by a feature.
> +		 * The only reason we can set SMPME without checking any
> +		 * feature is that its effects are not directly observable
> +		 * from the guest.
> +		 */
> +		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
>  
>  		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
>  			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

