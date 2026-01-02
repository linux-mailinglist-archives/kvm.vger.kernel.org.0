Return-Path: <kvm+bounces-66952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB86CEF02C
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 17:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D49B13008545
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 16:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D99C2D24BA;
	Fri,  2 Jan 2026 16:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k+stiLoG"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8052C3276;
	Fri,  2 Jan 2026 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767373137; cv=none; b=B2Nzn0KDuKkGfuz3j9aiukmkAmir8q8j2zcjpMFxScQW1iUj5WN0Vjh+nXQ+23NhT3bSa9xBGo1AQFfXvFm8aG8fUQD9S/XhPAXm5MHM4vbmdJEs7RaO5+OMAsVHw0xuXZHdpH4x8045gJmGGj3KCyVDwp4Y+3W74wOOs+fl2+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767373137; c=relaxed/simple;
	bh=zw/m5RqmSJ7ns2Awc3++dE85qaJs/sr5TDrf1QfSkLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHUahWDn9kX8WYxOCyHv4qQm9tmzdEagl8UMHA/66K6iq/kI5J3u3MZ2WmF3SYg9CT9dsOUMN+LWl7VYqE3QHeVKBewIklMT8gM4HBOhSN0J311esJSCnJ2Jjnwr0c+Bilrd3DICDGwrpqwmnxtFe28bNUi5vcV6U90PXt9jyhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k+stiLoG; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Jan 2026 16:58:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767373123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/adiBUQZ/Qfmrr9PCE7JkH+ijh6pLAj2iSLGgdDMeSc=;
	b=k+stiLoG2msiz8lDhi0bK0hfFL0ljxjmLODRlAEWWpsz6Wk7P/3pT/HCHF3JyWeTPpcJ7d
	aMGosRJm7ObB3I3sfFf1GgVxnCt+zIl5yM+WCAw1Kyhwc2MFBg3u7RCuEJ/6ztn6B2lauL
	lKPJ7WtdryBm5BSsd21cHGaTirpQ1pU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/21] KVM: selftests: Stop passing VMX metadata to
 TDP mapping functions
Message-ID: <pa4l62zp7wf77xdxoliuj2f7gliyan37fdcyl5tyblpknfu5iu@voe5mj6tz7vk>
References: <20251230230150.4150236-1-seanjc@google.com>
 <20251230230150.4150236-12-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230230150.4150236-12-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 03:01:40PM -0800, Sean Christopherson wrote:
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> The root GPA can now be retrieved from the nested MMU, stop passing VMX
> metadata. This is in preparation for making these functions work for
> NPTs as well.

Super nit: I think at this point the root GPA is already being retrieved
from the nested MMU, so maybe s/can now be/is?

Also, maybe call it TDP MMU or stage2 MMU since it was renamed.

> 
> Opportunistically drop tdp_pg_map() since it's unused.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86/vmx.h | 11 ++-----
>  .../testing/selftests/kvm/lib/x86/memstress.c | 11 +++----
>  tools/testing/selftests/kvm/lib/x86/vmx.c     | 33 +++++++------------
>  .../selftests/kvm/x86/vmx_dirty_log_test.c    |  9 +++--
>  4 files changed, 24 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
> index 1fd83c23529a..4dd4c2094ee6 100644
> --- a/tools/testing/selftests/kvm/include/x86/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86/vmx.h
> @@ -557,14 +557,9 @@ bool load_vmcs(struct vmx_pages *vmx);
>  
>  bool ept_1g_pages_supported(void);
>  
> -void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
> -		uint64_t paddr);
> -void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
> -	     uint64_t paddr, uint64_t size);
> -void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
> -				       struct kvm_vm *vm);
> -void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
> -			 uint64_t addr, uint64_t size);
> +void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
> +void tdp_identity_map_default_memslots(struct kvm_vm *vm);
> +void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
>  bool kvm_cpu_has_ept(void);
>  void vm_enable_ept(struct kvm_vm *vm);
>  void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
> diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
> index 00f7f11e5f0e..3319cb57a78d 100644
> --- a/tools/testing/selftests/kvm/lib/x86/memstress.c
> +++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
> @@ -59,7 +59,7 @@ uint64_t memstress_nested_pages(int nr_vcpus)
>  	return 513 + 10 * nr_vcpus;
>  }
>  
> -static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *vm)
> +static void memstress_setup_ept_mappings(struct kvm_vm *vm)
>  {
>  	uint64_t start, end;
>  
> @@ -68,16 +68,15 @@ static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *v
>  	 * KVM can shadow the EPT12 with the maximum huge page size supported
>  	 * by the backing source.
>  	 */
> -	tdp_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
> +	tdp_identity_map_1g(vm, 0, 0x100000000ULL);
>  
>  	start = align_down(memstress_args.gpa, PG_SIZE_1G);
>  	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
> -	tdp_identity_map_1g(vmx, vm, start, end - start);
> +	tdp_identity_map_1g(vm, start, end - start);
>  }
>  
>  void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
>  {
> -	struct vmx_pages *vmx;
>  	struct kvm_regs regs;
>  	vm_vaddr_t vmx_gva;
>  	int vcpu_id;
> @@ -87,11 +86,11 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
>  
>  	vm_enable_ept(vm);
>  	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> -		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
> +		vcpu_alloc_vmx(vm, &vmx_gva);
>  
>  		/* The EPTs are shared across vCPUs, setup the mappings once */
>  		if (vcpu_id == 0)
> -			memstress_setup_ept_mappings(vmx, vm);
> +			memstress_setup_ept_mappings(vm);
>  
>  		/*
>  		 * Override the vCPU to run memstress_l1_guest_code() which will
> diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
> index 9d4e391fdf2c..ea1c09f9e8ab 100644
> --- a/tools/testing/selftests/kvm/lib/x86/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
> @@ -409,8 +409,8 @@ static void tdp_create_pte(struct kvm_vm *vm,
>  }
>  
>  
> -void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> -		  uint64_t nested_paddr, uint64_t paddr, int target_level)
> +void __tdp_pg_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
> +		  int target_level)
>  {
>  	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
>  	void *eptp_hva = addr_gpa2hva(vm, vm->arch.tdp_mmu->pgd);
> @@ -453,12 +453,6 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
>  	}
>  }
>  
> -void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> -		uint64_t nested_paddr, uint64_t paddr)
> -{
> -	__tdp_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
> -}
> -
>  /*
>   * Map a range of EPT guest physical addresses to the VM's physical address
>   *
> @@ -476,9 +470,8 @@ void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
>   * Within the VM given by vm, creates a nested guest translation for the
>   * page range starting at nested_paddr to the page range starting at paddr.
>   */
> -void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> -	       uint64_t nested_paddr, uint64_t paddr, uint64_t size,
> -		  int level)
> +void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
> +	       uint64_t size, int level)
>  {
>  	size_t page_size = PG_LEVEL_SIZE(level);
>  	size_t npages = size / page_size;
> @@ -487,23 +480,22 @@ void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
>  	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
>  
>  	while (npages--) {
> -		__tdp_pg_map(vmx, vm, nested_paddr, paddr, level);
> +		__tdp_pg_map(vm, nested_paddr, paddr, level);
>  		nested_paddr += page_size;
>  		paddr += page_size;
>  	}
>  }
>  
> -void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
> -	     uint64_t nested_paddr, uint64_t paddr, uint64_t size)
> +void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
> +	     uint64_t size)
>  {
> -	__tdp_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
> +	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
>  }
>  
>  /* Prepare an identity extended page table that maps all the
>   * physical pages in VM.
>   */
> -void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
> -				       struct kvm_vm *vm)
> +void tdp_identity_map_default_memslots(struct kvm_vm *vm)
>  {
>  	uint32_t s, memslot = 0;
>  	sparsebit_idx_t i, last;
> @@ -520,16 +512,15 @@ void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
>  		if (i > last)
>  			break;
>  
> -		tdp_map(vmx, vm, (uint64_t)i << vm->page_shift,
> +		tdp_map(vm, (uint64_t)i << vm->page_shift,
>  			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
>  	}
>  }
>  
>  /* Identity map a region with 1GiB Pages. */
> -void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
> -			    uint64_t addr, uint64_t size)
> +void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
>  {
> -	__tdp_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
> +	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
>  }
>  
>  bool kvm_cpu_has_ept(void)
> diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
> index 5c8cf8ac42a2..370f8d3117c2 100644
> --- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
> @@ -80,7 +80,6 @@ void l1_guest_code(struct vmx_pages *vmx)
>  static void test_vmx_dirty_log(bool enable_ept)
>  {
>  	vm_vaddr_t vmx_pages_gva = 0;
> -	struct vmx_pages *vmx;
>  	unsigned long *bmap;
>  	uint64_t *host_test_mem;
>  
> @@ -96,7 +95,7 @@ static void test_vmx_dirty_log(bool enable_ept)
>  	if (enable_ept)
>  		vm_enable_ept(vm);
>  
> -	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
> +	vcpu_alloc_vmx(vm, &vmx_pages_gva);
>  	vcpu_args_set(vcpu, 1, vmx_pages_gva);
>  
>  	/* Add an extra memory slot for testing dirty logging */
> @@ -120,9 +119,9 @@ static void test_vmx_dirty_log(bool enable_ept)
>  	 * GPAs as the EPT enabled case.
>  	 */
>  	if (enable_ept) {
> -		tdp_identity_map_default_memslots(vmx, vm);
> -		tdp_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
> -		tdp_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
> +		tdp_identity_map_default_memslots(vm);
> +		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
> +		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
>  	}
>  
>  	bmap = bitmap_zalloc(TEST_MEM_PAGES);
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

