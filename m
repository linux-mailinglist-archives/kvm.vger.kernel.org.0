Return-Path: <kvm+bounces-49275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B97AD7571
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 17:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06E673A2CFF
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 15:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 995C728AAF8;
	Thu, 12 Jun 2025 15:14:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2B426FA69;
	Thu, 12 Jun 2025 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749741280; cv=none; b=DOXBhK5lARP7VcGMu0//6bioxMWgogDApNFKr0zhzlZhaatAdG2sPPOuXs1DqTTMLHOFeoqZx5UhLZQVeh7OLAbA8WvCIDcBYMZ66Kpj/s9C/J1iaAIcKCzjRzuRUE38zCEBxrT6bFcjcVghdDyNI8PvwFKYgsyuRqQGCDElSvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749741280; c=relaxed/simple;
	bh=XipgtzNNDlXpQtTflFkk/N7lOsqTfvwkLoXG2kqL59E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKXyjOqYMwkOZbbmar/FYKF435d7xrWk/WMdtZhG0rTh++dHw1pwp1ZQLvgo8ZOQ4hORl9rCDwfC+mC7pHkUqWT7P34jMXjteQf8u1uzbPE1qWDXisRB838ns7wPYV7xbu40PSJpIelNNl3X8ZYoA093TRMl+GokmKXaa4eTj7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A5D0153B;
	Thu, 12 Jun 2025 08:14:16 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 223A43F66E;
	Thu, 12 Jun 2025 08:14:32 -0700 (PDT)
Date: Thu, 12 Jun 2025 16:14:27 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
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
Subject: Re: [PATCH v9 41/43] KVM: arm64: Expose support for private memory
Message-ID: <20250612151427.GA1913753@e124191.cambridge.arm.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-42-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611104844.245235-42-steven.price@arm.com>

Hi Steven,

On Wed, Jun 11, 2025 at 11:48:38AM +0100, Steven Price wrote:
> Select KVM_GENERIC_PRIVATE_MEM and provide the necessary support
> functions.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
> Changes since v2:
>  * Switch kvm_arch_has_private_mem() to a macro to avoid overhead of a
>    function call.
>  * Guard definitions of kvm_arch_{pre,post}_set_memory_attributes() with
>    #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES.
>  * Early out in kvm_arch_post_set_memory_attributes() if the WARN_ON
>    should trigger.
> ---
>  arch/arm64/include/asm/kvm_host.h |  6 ++++++
>  arch/arm64/kvm/Kconfig            |  1 +
>  arch/arm64/kvm/mmu.c              | 24 ++++++++++++++++++++++++
>  3 files changed, 31 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a1857802db64..9903b0e8ef3f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1514,6 +1514,12 @@ struct kvm *kvm_arch_alloc_vm(void);
>  
>  #define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>  
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
> +#else
> +#define kvm_arch_has_private_mem(kvm) false
> +#endif

I don't understand the ifdef here (or below). In the Kconfig you 'select
KVM_GENERIC_PRIVATE_MEM', so it will always be on/defined? Unless I'm
misunderstanding something.

> +
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 713248f240e0..3a04b040869d 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,7 @@ menuconfig KVM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
> +	select KVM_GENERIC_PRIVATE_MEM
>  	help
>  	  Support hosting virtualized guest machines.
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 580ed362833c..c866891fd8f9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2384,6 +2384,30 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> +					struct kvm_gfn_range *range)
> +{
> +	WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm));
> +	return false;
> +}
> +
> +bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> +					 struct kvm_gfn_range *range)
> +{
> +	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> +		return false;
> +
> +	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
> +		range->attr_filter = KVM_FILTER_SHARED;
> +	else
> +		range->attr_filter = KVM_FILTER_PRIVATE;
> +	kvm_unmap_gfn_range(kvm, range);
> +
> +	return false;
> +}
> +#endif
> +
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
>  }
> -- 
> 2.43.0
> 

Thanks,
Joey

