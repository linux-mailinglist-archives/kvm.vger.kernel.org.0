Return-Path: <kvm+bounces-50487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7456FAE656F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E43813AA670
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEB2299920;
	Tue, 24 Jun 2025 12:50:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005D21DFFC;
	Tue, 24 Jun 2025 12:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750769445; cv=none; b=oE9eEVfnRAuoDAtWlcXRP3nWlUeRvKBB63AA0qP0gJZpZrMLBm6qSeBlzvgy0pee07iNfLWIREjYnjd/u8ib0I4IQhc5nXYdmqszaDMIWQPMHMP84jYc0lFCF3smfP+UXBpO8uUfoU8yBj5dxZhg3CIRq1t+r1B3rkPZXhQeh+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750769445; c=relaxed/simple;
	bh=GyodmIXznG8GSgL/Ai3LAgH/nDuaIi0hljP1HBMPTe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=di3X5Z+Ufu3AIldNgj+3U5n0oE4uWtLt5GfLjBco8uxWJopUJPkDeWwagkCDJ6GUMKr8zbeGZQ2JBKM5OXdHnxzdZStMwNFl0ZNGVk+kFHbhdsN28uG6t7joYtM/nr+wIQC5PxHGMr738c5FU/alN00U5fNKksxUU02EQGH8Si4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25A03106F;
	Tue, 24 Jun 2025 05:50:23 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D7073F66E;
	Tue, 24 Jun 2025 05:50:37 -0700 (PDT)
Date: Tue, 24 Jun 2025 13:50:32 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
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
Subject: Re: [PATCH v9 28/43] arm64: RME: Allow checking SVE on VM instance
Message-ID: <20250624125032.GA111675@e124191.cambridge.arm.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-29-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611104844.245235-29-steven.price@arm.com>

On Wed, Jun 11, 2025 at 11:48:25AM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Given we have different types of VMs supported, check the
> support for SVE for the given instance of the VM to accurately
> report the status.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/include/asm/kvm_rme.h | 2 ++
>  arch/arm64/kvm/arm.c             | 5 ++++-
>  arch/arm64/kvm/rme.c             | 5 +++++
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 2d7d7233c525..af5150c084ce 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -94,6 +94,8 @@ void kvm_init_rme(void);
>  u32 kvm_realm_ipa_limit(void);
>  u32 kvm_realm_vgic_nr_lr(void);
>  
> +bool kvm_rme_supports_sve(void);
> +
>  int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>  int kvm_init_realm_vm(struct kvm *kvm);
>  void kvm_destroy_realm(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4eb229b6c315..d1ef12fe6176 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -426,7 +426,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = get_kvm_ipa_limit();
>  		break;
>  	case KVM_CAP_ARM_SVE:
> -		r = system_supports_sve();
> +		if (kvm_is_realm(kvm))
> +			r = kvm_rme_supports_sve();
> +		else
> +			r = system_supports_sve();
>  		break;
>  	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 5f1fdefc0364..6bd21223a8be 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -38,6 +38,11 @@ static bool rme_has_feature(unsigned long feature)
>  	return !!u64_get_bits(rmm_feat_reg0, feature);
>  }
>  
> +bool kvm_rme_supports_sve(void)
> +{
> +	return rme_has_feature(RMI_FEATURE_REGISTER_0_SVE_EN);
> +}
> +
>  static int rmi_check_version(void)
>  {
>  	struct arm_smccc_res res;
> -- 
> 2.43.0
> 

