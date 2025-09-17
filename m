Return-Path: <kvm+bounces-57952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23919B820D2
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9FCE91C2258C
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF6A30C63A;
	Wed, 17 Sep 2025 21:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qNRhO/em"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65221261B70
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758146213; cv=none; b=q19YFwoig0HnX8qmSt49pCPyYgTauzt2nutYXNV71ZabfwOjfO4fUK7z0soUWOId9T4uNBaDbP4QL22mPg+i2KGnIo9ua3C5g9hj1uUFO6Yww9MjmJjugPAiclBbLrgmORjLv8BaFRpn5MdDzThpHJvKm1kVMGEy/Vb8U/bstGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758146213; c=relaxed/simple;
	bh=0m9scD+P5IMalvlfBz3nkm1fdsFxVQ08SOb8GcTU4Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiuKOEZURcxyfmkVTs2r6zX+wK9hFRQE7Qec75uySc3As9QUa4qQmC9oX47cr96XJjP40svWGqewjyzq+J1FlbHHl9+LPR2BQvh3njXTe3eK33Fns5EriMQos1hgOM9KHquZg048Z0/q0fZptfsau7/JGiehJe/CGftSfBTxHOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qNRhO/em; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 18 Sep 2025 06:56:27 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758146199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MXZ7+Ibvsh1cXMBq66vw8RmPmdICgys8MaS/4a4cgSE=;
	b=qNRhO/emD7xbps2428sDp6IrSxnPCufvt9GFU3kcjyRVvZv/+Rh7BH6jm+WQFppq1XLJ99
	jeu17o6yf4WksZPpOza8BduvHVt8qrsQIHmEtKaodDV5fJ1ygRt5yKfxO7wGJJPuZ9AvlU
	N+Npk3U3NqcMV2/RnayFLNRolyP7IMg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [PATCH 07/13] KVM: arm64: selftests: Provide helper for getting
 default vCPU target
Message-ID: <aMsui6JZ0q1z4pSc@vm4>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
 <20250917212044.294760-8-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917212044.294760-8-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 17, 2025 at 02:20:37PM -0700, Oliver Upton wrote:
> The default vCPU target in KVM selftests is pretty boring in that it
> doesn't enable any vCPU features. Expose a helper for getting the
> default target to prepare for cramming in more features. Call
> KVM_ARM_PREFERRED_TARGET directly from get-reg-list as it needs
> fine-grained control over feature flags.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/arm64/psci_test.c   |  2 +-
>  .../testing/selftests/kvm/arm64/smccc_filter.c  |  2 +-
>  .../selftests/kvm/arm64/vpmu_counter_access.c   |  4 ++--
>  tools/testing/selftests/kvm/get-reg-list.c      |  9 ++++++---
>  .../selftests/kvm/include/arm64/processor.h     |  2 ++
>  .../testing/selftests/kvm/lib/arm64/processor.c | 17 +++++++++++------
>  6 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
> index cf208390fd0e..0d4680da66d1 100644
> --- a/tools/testing/selftests/kvm/arm64/psci_test.c
> +++ b/tools/testing/selftests/kvm/arm64/psci_test.c
> @@ -89,7 +89,7 @@ static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
>  
>  	vm = vm_create(2);
>  
> -	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	kvm_get_default_vcpu_target(vm, &init);
>  	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
>  
>  	*source = aarch64_vcpu_add(vm, 0, &init, guest_code);

I wonder if the ioctl() can be called unconditionally in the 
aarch64_vcpu_add() function. If the intention is that the kvm selftest
code needs to write this way I am fine with that.

Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

> diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
> index eb5551d21dbe..a8e22d866ea7 100644
> --- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
> +++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
> @@ -64,7 +64,7 @@ static struct kvm_vm *setup_vm(struct kvm_vcpu **vcpu)
>  	struct kvm_vm *vm;
>  
>  	vm = vm_create(1);
> -	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	kvm_get_default_vcpu_target(vm, &init);
>  
>  	/*
>  	 * Enable in-kernel emulation of PSCI to ensure that calls are denied
> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> index 36a3a8b4e0b5..2a8f31c8e59f 100644
> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> @@ -430,7 +430,7 @@ static void create_vpmu_vm(void *guest_code)
>  	}
>  
>  	/* Create vCPU with PMUv3 */
> -	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
>  	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
>  	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
>  	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
> @@ -525,7 +525,7 @@ static void run_access_test(uint64_t pmcr_n)
>  	 * Reset and re-initialize the vCPU, and run the guest code again to
>  	 * check if PMCR_EL0.N is preserved.
>  	 */
> -	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
>  	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
>  	aarch64_vcpu_setup(vcpu, &init);
>  	vcpu_init_descriptor_tables(vcpu);
> diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
> index 91f05f78e824..f4644c9d2d3b 100644
> --- a/tools/testing/selftests/kvm/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/get-reg-list.c
> @@ -116,10 +116,13 @@ void __weak finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
>  }
>  
>  #ifdef __aarch64__
> -static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
> +static void prepare_vcpu_init(struct kvm_vm *vm, struct vcpu_reg_list *c,
> +			      struct kvm_vcpu_init *init)
>  {
>  	struct vcpu_reg_sublist *s;
>  
> +	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, init);
> +
>  	for_each_sublist(c, s)
>  		if (s->capability)
>  			init->features[s->feature / 32] |= 1 << (s->feature % 32);
> @@ -127,10 +130,10 @@ static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *ini
>  
>  static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm_vm *vm)
>  {
> -	struct kvm_vcpu_init init = { .target = -1, };
> +	struct kvm_vcpu_init init;
>  	struct kvm_vcpu *vcpu;
>  
> -	prepare_vcpu_init(c, &init);
> +	prepare_vcpu_init(vm, c, &init);
>  	vcpu = __vm_vcpu_add(vm, 0);
>  	aarch64_vcpu_setup(vcpu, &init);
>  
> diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
> index 5a4b29c1b965..87f50efed720 100644
> --- a/tools/testing/selftests/kvm/include/arm64/processor.h
> +++ b/tools/testing/selftests/kvm/include/arm64/processor.h
> @@ -357,4 +357,6 @@ static __always_inline u64 ctxt_reg_alias(struct kvm_vcpu *vcpu, u32 encoding)
>  	return KVM_ARM64_SYS_REG(alias);
>  }
>  
> +void kvm_get_default_vcpu_target(struct kvm_vm *vm, struct kvm_vcpu_init *init);
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
> index 311660a9f655..5ae65fefd48c 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -267,19 +267,24 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	}
>  }
>  
> +void kvm_get_default_vcpu_target(struct kvm_vm *vm, struct kvm_vcpu_init *init)
> +{
> +	struct kvm_vcpu_init preferred = {};
> +
> +	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
> +
> +	*init = preferred;
> +}
> +
>  void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
>  {
>  	struct kvm_vcpu_init default_init = { .target = -1, };
>  	struct kvm_vm *vm = vcpu->vm;
>  	uint64_t sctlr_el1, tcr_el1, ttbr0_el1;
>  
> -	if (!init)
> +	if (!init) {
> +		kvm_get_default_vcpu_target(vm, &default_init);
>  		init = &default_init;
> -
> -	if (init->target == -1) {
> -		struct kvm_vcpu_init preferred;
> -		vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
> -		init->target = preferred.target;
>  	}
>  
>  	vcpu_ioctl(vcpu, KVM_ARM_VCPU_INIT, init);
> -- 
> 2.47.3
> 

