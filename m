Return-Path: <kvm+bounces-53357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B3DB1080D
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 12:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92C431CE6246
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 10:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F4326B0BC;
	Thu, 24 Jul 2025 10:47:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D702926A1B5;
	Thu, 24 Jul 2025 10:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753354075; cv=none; b=DLh15wYQjduAzA7YASNhnGjZl3KT+A9QXUkoA/+mgiJ6J8awL7L1qLNFCQ8vZ2okm+mktIW4FPThTrL5eIXYRDy3JHf4+SO3fBhtgpvgDf/avHTE//EMBHAPDyNdePtwSfAuFDaR7DmB5Hv/VUMtBYsl25SJBiT1UiuAQzLWyWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753354075; c=relaxed/simple;
	bh=za0tp7BwBrUVSU6SuraZ5F3wSLucXvJIf5emTmKp+Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bv6KZKzMl1Y/0zaqN1J65PLCpnxZlNBDFGoPx8cF5AoR9xUm2pOr8HgEV4YrKmo+6/JbUlWEnmuMb3XlFREGXQvdAIPRKx4rz0lYKe5B05gXcQM7urj3ptYBR091bB0dgPxaoRRK7LOcMJG6OAdGzKb3lLacFuGZkab7O6zJXaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA4951A00;
	Thu, 24 Jul 2025 03:47:46 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7B6C3F5A1;
	Thu, 24 Jul 2025 03:47:47 -0700 (PDT)
Date: Thu, 24 Jul 2025 11:47:44 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>
Subject: Re: [PATCH v9 36/43] arm64: RME: Initialize PMCR.N with number
 counter supported by RMM
Message-ID: <20250724104744.GC2753450@e124191.cambridge.arm.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-37-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611104844.245235-37-steven.price@arm.com>

On Wed, Jun 11, 2025 at 11:48:33AM +0100, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Provide an accurate number of available PMU counters to userspace when
> setting up a Realm.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_rme.h | 1 +
>  arch/arm64/kvm/pmu-emul.c        | 3 +++
>  arch/arm64/kvm/rme.c             | 5 +++++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index c8564d5aaff4..ee10fc3c1f3d 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -93,6 +93,7 @@ struct realm_rec {
>  void kvm_init_rme(void);
>  u32 kvm_realm_ipa_limit(void);
>  u32 kvm_realm_vgic_nr_lr(void);
> +u8 kvm_realm_max_pmu_counters(void);
>  
>  u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
>  
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 83f957ed0b80..0afe93bc5527 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1014,6 +1014,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
>  {
>  	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
>  
> +	if (kvm_is_realm(kvm))
> +		return kvm_realm_max_pmu_counters();
> +
>  	/*
>  	 * PMUv3 requires that all event counters are capable of counting any
>  	 * event, though the same may not be true of non-PMUv3 hardware.
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index bf814f45a387..a31920e05cf7 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -87,6 +87,11 @@ u32 kvm_realm_vgic_nr_lr(void)
>  	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>  }
>  
> +u8 kvm_realm_max_pmu_counters(void)
> +{
> +	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS);
> +}
> +
>  u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>  {
>  	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
> -- 
> 2.43.0
> 

