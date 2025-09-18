Return-Path: <kvm+bounces-57959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCCBCB828BE
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 03:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 441973A036C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 01:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614BA1A5BB4;
	Thu, 18 Sep 2025 01:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SdFDJG43"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF64B35947
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 01:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758159967; cv=none; b=aNwEBUuYXRJcahJbY2WjoBlX8gpLNmPRg2Do6NSbjEGSjAllkFMLfEzrJ7KE1tt+NgSadZi4IAYfo7dnNTtCklKiXtCZyuM0tbR1LDqIxAyCMTZsixBJxAJg3TshlXO0TDmbthlOv0h/fqgorJ3sfMghoj+KXekH7AK1iSbCwiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758159967; c=relaxed/simple;
	bh=JVKhKkxSZop6mixyG1NVJRyT4yaVnmI+fcWd4yK7LYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VXXYjic35P4dz7VCOdBUvf4bgbqsH2a3jxdRJJelOSf7TB39zksimJsOc8JkRkaMG46EjVlCEaypFEE9I9mlc5ef8tw+qtNXHRBE84p180Iw/8/6xbiDK1u8Kkg+zuxgNjScGMukKApQNdFxjjQa5lkeqluSQDS4/uPx0cJCQcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SdFDJG43; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 18 Sep 2025 10:45:51 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758159961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Doq25p+1DFVIRWlQc0G6ormH2onTHdI1vNqxrn+KXcE=;
	b=SdFDJG43Gg2xOHKStNM2G3t1zfMEJn8q/nCLMxuuojmrQU+IeUjSD+5NZqg5gBfGAs9eWV
	moCt+yQvsQkKHWqOlRTWaTGEqc40rT28Q2++P52OSgOLJCzlQ8sRzzs9Ib9fTaez9NxouV
	zSK6sR23IO6F6TriRgy5CY10IyJsKlQ=
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
Subject: Re: [PATCH 03/13] KVM: arm64: selftests: Add helper to check for
 VGICv3 support
Message-ID: <aMtkT9CC+lRH/vSD@vm4>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
 <20250917212044.294760-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917212044.294760-4-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 17, 2025 at 02:20:33PM -0700, Oliver Upton wrote:
> Introduce a proper predicate for probing VGICv3 by performing a 'test'
> creation of the device on a dummy VM.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  tools/testing/selftests/kvm/arm64/arch_timer.c        |  3 ++-
>  .../selftests/kvm/arm64/arch_timer_edge_cases.c       |  3 ++-
>  tools/testing/selftests/kvm/arm64/vgic_irq.c          |  3 ++-
>  tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c   |  4 ++--
>  .../testing/selftests/kvm/arm64/vpmu_counter_access.c |  3 +--
>  tools/testing/selftests/kvm/include/arm64/vgic.h      |  1 +
>  tools/testing/selftests/kvm/lib/arm64/vgic.c          | 11 +++++++++++
>  7 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/arch_timer.c b/tools/testing/selftests/kvm/arm64/arch_timer.c
> index eeba1cc87ff8..aaf4285f832a 100644
> --- a/tools/testing/selftests/kvm/arm64/arch_timer.c
> +++ b/tools/testing/selftests/kvm/arm64/arch_timer.c
> @@ -184,6 +184,8 @@ struct kvm_vm *test_vm_create(void)
>  	unsigned int i;
>  	int nr_vcpus = test_args.nr_vcpus;
>  
> +	TEST_REQUIRE(kvm_supports_vgic_v3());
> +
>  	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
>  
>  	vm_init_descriptor_tables(vm);
> @@ -205,7 +207,6 @@ struct kvm_vm *test_vm_create(void)
>  
>  	test_init_timer_irq(vm);
>  	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
> -	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
>  
>  	/* Make all the test's cmdline args visible to the guest */
>  	sync_global_to_guest(vm, test_args);
> diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> index ce74d069cb7b..d349d80d8418 100644
> --- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> +++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
> @@ -952,7 +952,6 @@ static void test_vm_create(struct kvm_vm **vm, struct kvm_vcpu **vcpu,
>  
>  	test_init_timer_irq(*vm, *vcpu);
>  	gic_fd = vgic_v3_setup(*vm, 1, 64);
> -	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
>  
>  	sync_global_to_guest(*vm, test_args);
>  	sync_global_to_guest(*vm, CVAL_MAX);
> @@ -1042,6 +1041,8 @@ int main(int argc, char *argv[])
>  	/* Tell stdout not to buffer its content */
>  	setbuf(stdout, NULL);
>  
> +	TEST_REQUIRE(kvm_supports_vgic_v3());
> +
>  	if (!parse_args(argc, argv))
>  		exit(KSFT_SKIP);
>  
> diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
> index a09dd423c2d7..9fc9e8e44ecd 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
> @@ -752,7 +752,6 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>  	vcpu_args_set(vcpu, 1, args_gva);
>  
>  	gic_fd = vgic_v3_setup(vm, 1, nr_irqs);
> -	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3, skipping");
>  
>  	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
>  		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
> @@ -802,6 +801,8 @@ int main(int argc, char **argv)
>  	int opt;
>  	bool eoi_split = false;
>  
> +	TEST_REQUIRE(kvm_supports_vgic_v3());
> +
>  	while ((opt = getopt(argc, argv, "hn:e:l:")) != -1) {
>  		switch (opt) {
>  		case 'n':
> diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> index fc4fe52fb6f8..cc2b21d374af 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> @@ -215,8 +215,6 @@ static void setup_test_data(void)
>  static void setup_gic(void)
>  {
>  	gic_fd = vgic_v3_setup(vm, test_data.nr_cpus, 64);
> -	__TEST_REQUIRE(gic_fd >= 0, "Failed to create GICv3");
> -
>  	its_fd = vgic_its_setup(vm);
>  }
>  
> @@ -374,6 +372,8 @@ int main(int argc, char **argv)
>  	u32 nr_threads;
>  	int c;
>  
> +	TEST_REQUIRE(kvm_supports_vgic_v3());
> +
>  	while ((c = getopt(argc, argv, "hv:d:e:i:")) != -1) {
>  		switch (c) {
>  		case 'v':
> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> index a0c4ab839155..01f61657de45 100644
> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> @@ -436,8 +436,6 @@ static void create_vpmu_vm(void *guest_code)
>  	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
>  	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
>  	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64);
> -	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
> -		       "Failed to create vgic-v3, skipping");
>  
>  	/* Make sure that PMUv3 support is indicated in the ID register */
>  	dfr0 = vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1));
> @@ -634,6 +632,7 @@ int main(void)
>  	uint64_t i, pmcr_n;
>  
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
> +	TEST_REQUIRE(kvm_supports_vgic_v3());
>  
>  	pmcr_n = get_pmcr_n_limit();
>  	for (i = 0; i <= pmcr_n; i++) {
> diff --git a/tools/testing/selftests/kvm/include/arm64/vgic.h b/tools/testing/selftests/kvm/include/arm64/vgic.h
> index c481d0c00a5d..b858fa8195b4 100644
> --- a/tools/testing/selftests/kvm/include/arm64/vgic.h
> +++ b/tools/testing/selftests/kvm/include/arm64/vgic.h
> @@ -16,6 +16,7 @@
>  	((uint64_t)(flags) << 12) | \
>  	index)
>  
> +bool kvm_supports_vgic_v3(void);
>  int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs);
>  
>  #define VGIC_MAX_RESERVED	1023
> diff --git a/tools/testing/selftests/kvm/lib/arm64/vgic.c b/tools/testing/selftests/kvm/lib/arm64/vgic.c
> index 64e793795563..661744c6532e 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/vgic.c
> @@ -15,6 +15,17 @@
>  #include "gic.h"
>  #include "gic_v3.h"
>  
> +bool kvm_supports_vgic_v3(void)
> +{
> +	struct kvm_vm *vm = vm_create_barebones();
> +	int r;
> +
> +	r = __kvm_test_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3);
> +	kvm_vm_free(vm);
> +
> +	return !r;
> +}
> +
>  /*
>   * vGIC-v3 default host setup
>   *
> -- 
> 2.47.3
> 

Oliver
The arch_timer_edge_cases selftest does not return nor fails on FVP RevC.
I boot the system with kvm-arm.mode=nested.

Thanks,
Itaru.

