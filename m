Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1C5A5340
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiH2RfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiH2Re6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:34:58 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB7725DA
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:34:54 -0700 (PDT)
Date:   Mon, 29 Aug 2022 19:34:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661794492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nRX4u5nOm1gamZS1Xwo93WlSnjatjuMfp/rqm89u66k=;
        b=iHD2qngggZIx3q+rrqxH8O4N006gvZJoRBRVrB7oFSHG3OHKZ2oA7q2hZlcrSuaJ+c/FWu
        WYGSp6kx62ENOfArNiv4r9fdT3UoT87Zux8pUqrOWHVYlPdUVtZHU9da/gEhP3iQE0Hpfb
        is27blRIdgAngtrqIzyXYr8ob+7AzjQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v5 08/13] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
Message-ID: <20220829173449.x6voncycvbdirzfr@kamzik>
References: <20220823234727.621535-1-ricarkol@google.com>
 <20220823234727.621535-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823234727.621535-9-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022 at 11:47:22PM +0000, Ricardo Koller wrote:
> The previous commit added support for callers of ____vm_create() to specify
> what memslots to use for code, page-tables, and data allocations. Change
> them accordingly:
> 
> - stacks, code, and exception tables use the code memslot
> - page tables and the pgd use the pt memslot
> - data (anything allocated with vm_vaddr_alloc()) uses the data memslot
> 
> No functional change intended. All allocators keep using memslot #0.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +
>  .../selftests/kvm/lib/aarch64/processor.c     | 11 ++--
>  tools/testing/selftests/kvm/lib/elf.c         |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
>  .../selftests/kvm/lib/riscv/processor.c       |  7 ++-
>  .../selftests/kvm/lib/s390x/processor.c       |  7 ++-
>  .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
>  7 files changed, 61 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index abe6c4e390ff..696719b227b9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -406,7 +406,10 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
>  struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
> +vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
> +			    vm_vaddr_t vaddr_min, uint32_t memslot);

With the enum suggestion these take 'enum memslot_type', allowing this...

>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> +vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, uint32_t memslot);
>  vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
>  
>  void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 5a31dc85d054..b6ebfdaf4957 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -79,7 +79,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  	if (!vm->pgd_created) {
>  		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
>  			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
> -			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +			KVM_GUEST_PAGE_TABLE_MIN_PADDR, vm->memslot.pt);

...to be KVM_GUEST_PAGE_TABLE_MIN_PADDR, MEMSLOT_PT);

>  		vm->pgd = paddr;
>  		vm->pgd_created = true;
>  	}
> @@ -328,8 +328,9 @@ struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
>  	size_t stack_size = vm->page_size == 4096 ?
>  					DEFAULT_STACK_PGS * vm->page_size :
>  					vm->page_size;
> -	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
> -					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
> +	uint64_t stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
> +						DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
> +						vm->memslot.code);
>  	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
>  
>  	aarch64_vcpu_setup(vcpu, init);
> @@ -435,8 +436,8 @@ void route_exception(struct ex_regs *regs, int vector)
>  
>  void vm_init_descriptor_tables(struct kvm_vm *vm)
>  {
> -	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> -			vm->page_size);
> +	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
> +					vm->page_size, vm->memslot.code);
>  
>  	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
>  }
> diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
> index 9f54c098d9d0..62cfbe3b6171 100644
> --- a/tools/testing/selftests/kvm/lib/elf.c
> +++ b/tools/testing/selftests/kvm/lib/elf.c
> @@ -161,7 +161,8 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
>  		seg_vend |= vm->page_size - 1;
>  		size_t seg_size = seg_vend - seg_vstart + 1;
>  
> -		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart);
> +		vm_vaddr_t vaddr = __vm_vaddr_alloc(vm, seg_size, seg_vstart,
> +						    vm->memslot.code);
>  		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
>  			"virtual memory for segment at requested min addr,\n"
>  			"  segment idx: %u\n"
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 91b42d6b726b..44b4298d375e 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1233,32 +1233,14 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
>  	return pgidx_start * vm->page_size;
>  }
>  
> -/*
> - * VM Virtual Address Allocate
> - *
> - * Input Args:
> - *   vm - Virtual Machine
> - *   sz - Size in bytes
> - *   vaddr_min - Minimum starting virtual address
> - *
> - * Output Args: None
> - *
> - * Return:
> - *   Starting guest virtual address
> - *
> - * Allocates at least sz bytes within the virtual address space of the vm
> - * given by vm.  The allocated bytes are mapped to a virtual address >=
> - * the address given by vaddr_min.  Note that each allocation uses a
> - * a unique set of pages, with the minimum real allocation being at least
> - * a page.
> - */
> -vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
> +vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
> +			    vm_vaddr_t vaddr_min, uint32_t memslot)
>  {
>  	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
>  
>  	virt_pgd_alloc(vm);
>  	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
> -					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
> +				KVM_UTIL_MIN_PFN * vm->page_size, memslot);

Here we'd do the lookup vm->memslots[memslot]

>  
>  	/*
>  	 * Find an unused range of virtual page addresses of at least
> @@ -1279,6 +1261,30 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
>  	return vaddr_start;
>  }
>  
> +/*
> + * VM Virtual Address Allocate
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   sz - Size in bytes
> + *   vaddr_min - Minimum starting virtual address
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Starting guest virtual address
> + *
> + * Allocates at least sz bytes within the virtual address space of the vm
> + * given by vm.  The allocated bytes are mapped to a virtual address >=
> + * the address given by vaddr_min.  Note that each allocation uses a
> + * a unique set of pages, with the minimum real allocation being at least
> + * a page. The allocated physical space comes from the data memslot.
> + */
> +vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
> +{
> +	return __vm_vaddr_alloc(vm, sz, vaddr_min, vm->memslot.data);
> +}
> +
>  /*
>   * VM Virtual Address Allocate Pages
>   *
> @@ -1298,6 +1304,12 @@ vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
>  	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
>  }
>  
> +vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, uint32_t memslot)
> +{
> +	return __vm_vaddr_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR,
> +				memslot);

nit: no need to wrap the line

> +}
> +
>  /*
>   * VM Virtual Address Allocate Page
>   *
> @@ -1863,7 +1875,8 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
>  {
> -	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +				 vm->memslot.pt);
>  }
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
> index 604478151212..464d8db43dbc 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -58,7 +58,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  	if (!vm->pgd_created) {
>  		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
>  			page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size,
> -			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +			KVM_GUEST_PAGE_TABLE_MIN_PADDR, vm->memslot.pt);
>  		vm->pgd = paddr;
>  		vm->pgd_created = true;
>  	}
> @@ -282,8 +282,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
>  	size_t stack_size = vm->page_size == 4096 ?
>  					DEFAULT_STACK_PGS * vm->page_size :
>  					vm->page_size;
> -	unsigned long stack_vaddr = vm_vaddr_alloc(vm, stack_size,
> -					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
> +	unsigned long stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
> +					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
> +					vm->memslot.code);
>  	unsigned long current_gp = 0;
>  	struct kvm_mp_state mps;
>  	struct kvm_vcpu *vcpu;
> diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
> index 89d7340d9cbd..2d3ca4d4d004 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/processor.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
> @@ -21,7 +21,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
>  		return;
>  
>  	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
> -				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +			KVM_GUEST_PAGE_TABLE_MIN_PADDR, vm->memslot.pt);
>  	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
>  
>  	vm->pgd = paddr;
> @@ -167,8 +167,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
>  	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
>  		    vm->page_size);
>  
> -	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
> -				     DEFAULT_GUEST_STACK_VADDR_MIN);
> +	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
> +				     DEFAULT_GUEST_STACK_VADDR_MIN,
> +				     vm->memslot.code);
>  
>  	vcpu = __vm_vcpu_add(vm, vcpu_id);
>  
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 2e6e61bbe81b..307e654513c6 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -525,7 +525,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
>  {
>  	if (!vm->gdt)
> -		vm->gdt = vm_vaddr_alloc_page(vm);
> +		vm->gdt = __vm_vaddr_alloc_page(vm, vm->memslot.code);
>  
>  	dt->base = vm->gdt;
>  	dt->limit = getpagesize();
> @@ -535,7 +535,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  				int selector)
>  {
>  	if (!vm->tss)
> -		vm->tss = vm_vaddr_alloc_page(vm);
> +		vm->tss = __vm_vaddr_alloc_page(vm, vm->memslot.code);
>  
>  	memset(segp, 0, sizeof(*segp));
>  	segp->base = vm->tss;
> @@ -620,8 +620,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
>  	vm_vaddr_t stack_vaddr;
>  	struct kvm_vcpu *vcpu;
>  
> -	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
> -				     DEFAULT_GUEST_STACK_VADDR_MIN);
> +	stack_vaddr = __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
> +				       DEFAULT_GUEST_STACK_VADDR_MIN,
> +				       vm->memslot.code);
>  
>  	vcpu = __vm_vcpu_add(vm, vcpu_id);
>  	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
> @@ -1118,8 +1119,8 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	extern void *idt_handlers;
>  	int i;
>  
> -	vm->idt = vm_vaddr_alloc_page(vm);
> -	vm->handlers = vm_vaddr_alloc_page(vm);
> +	vm->idt = __vm_vaddr_alloc_page(vm, vm->memslot.code);
> +	vm->handlers = __vm_vaddr_alloc_page(vm, vm->memslot.code);
>  	/* Handlers have the same address in both address spaces.*/
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
>  		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> -- 
> 2.37.1.595.g718a3a8f04-goog
>

Thanks,
drew
