Return-Path: <kvm+bounces-38707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 697D9A3DC0B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7264E178851
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5801C3308;
	Thu, 20 Feb 2025 14:03:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296C833985
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060212; cv=none; b=mXNIy1Jjn9SGMC+qJzaOibkQpY6jAEpeH1DdW3OsuSl1Fe/nCd+pf2dTvoOLJzxBq+JbOXXfAvFKssKbpLSkR55cTC5Z/m0+/ndhv0tEosxtN708Mg87kZFpOsVgLXssZUu8Zg45yV6y4sYniiIgUOu6yCKSA19TBr4MQGsg+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060212; c=relaxed/simple;
	bh=KjAFqnr8JmknNbLe5eh6enoLVPvDPr0qHxYTQixGD+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBWiPvDOy+7Aoo5pqp01+XoPPjZXJcbLYhF+GkvmBHJ94si/wLsAFf/EFb5p+X6PjfDroNRxUocig5poxC5DvRjcRyIskygy8Hi3+F+hes717Q1wDHN/AE2cQ+4BjM519NjiHtFzLOIoT8u6L8wLpcDCsaDe78qlr2WRLavwlgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C35C16F3;
	Thu, 20 Feb 2025 06:03:48 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD0A23F59E;
	Thu, 20 Feb 2025 06:03:28 -0800 (PST)
Date: Thu, 20 Feb 2025 14:03:23 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: Re: [PATCH v2 01/14] arm64: cpufeature: Handle NV_frac as a synonym
 of NV2
Message-ID: <20250220140323.GA2562076@e124191.cambridge.arm.com>
References: <20250220134907.554085-1-maz@kernel.org>
 <20250220134907.554085-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220134907.554085-2-maz@kernel.org>

On Thu, Feb 20, 2025 at 01:48:54PM +0000, Marc Zyngier wrote:
> With ARMv9.5, an implementation supporting Nested Virtualization
> is allowed to only support NV2, and to avoid supporting the old
> (and useless) ARMv8.3 variant.
> 
> This is indicated by ID_AA64MMFR2_EL1.NV being 0 (as if NV wasn't
> implemented) and ID_AA64MMDR4_EL1.NV_frac being 1 (indicating that

typo: ID_AA64MMDR4_EL1 -> ID_AA64MMFR4_EL1

> NV2 is actually supported).
> 
> Given that KVM only deals with NV2 and refuses to use the old NV,
> detecting NV2 or NV_frac is what we need to enable it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/cpufeature.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index d561cf3b8ac7b..2c198cd4f9405 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -497,6 +497,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
>  
>  static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
>  	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
>  	ARM64_FTR_END,
>  };
>  
> @@ -2162,7 +2163,7 @@ static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
>  	if (kvm_get_mode() != KVM_MODE_NV)
>  		return false;
>  
> -	if (!has_cpuid_feature(cap, scope)) {
> +	if (!cpucap_multi_entry_cap_matches(cap, scope)) {
>  		pr_warn("unavailable: %s\n", cap->desc);
>  		return false;
>  	}
> @@ -2519,7 +2520,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.capability = ARM64_HAS_NESTED_VIRT,
>  		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>  		.matches = has_nested_virt_support,
> -		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, NV2)
> +		.match_list = (const struct arm64_cpu_capabilities []){
> +			{
> +				.matches = has_cpuid_feature,
> +				ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, NV, NV2)
> +			},
> +			{
> +				.matches = has_cpuid_feature,
> +				ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY)
> +			},
> +			{ /* Sentinel */ }
> +		},
>  	},
>  	{
>  		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
> -- 
> 2.39.2
> 

