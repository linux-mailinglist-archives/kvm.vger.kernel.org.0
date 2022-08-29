Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1395A5317
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiH2RZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiH2RZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:25:20 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CB61FCD0
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:25:17 -0700 (PDT)
Date:   Mon, 29 Aug 2022 19:25:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661793916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SY3qaOTb2VJb+wLuf/E+vyY5qSaIIyhVKf+yCSPeXAI=;
        b=rSOBzKUgQDoEc8aNdwhRmKFlA1doBbu+4jtJjCD8BJEGRKzeay1ijiek4S6cV+YNHE9AhJ
        ewI51PQ9ZH65CX78gTRu7EmULuFq8fCghb+k7yA8q1+p1o9JZQeY1FxJ8Jj4kf/h7GJSIr
        ekQ5fAwlzRf2Flt6y1BbNgoqZUF/+kU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v5 07/13] KVM: selftests: Change ____vm_create() to take
 struct kvm_vm_mem_params
Message-ID: <20220829172508.oc3rr44q2irwudi5@kamzik>
References: <20220823234727.621535-1-ricarkol@google.com>
 <20220823234727.621535-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823234727.621535-8-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022 at 11:47:21PM +0000, Ricardo Koller wrote:
> The vm_create() helpers are hardcoded to place most page types (code,
> page-tables, stacks, etc) in the same memslot #0, and always backed with
> anonymous 4K.  There are a couple of issues with that.  First, tests willing to
> differ a bit, like placing page-tables in a different backing source type must
> replicate much of what's already done by the vm_create() functions.  Second,
> the hardcoded assumption of memslot #0 holding most things is spreaded
> everywhere; this makes it very hard to change.
> 
> Fix the above issues by having selftests specify how they want memory to be
> laid out: define the memory regions to use for code, pt (page-tables), and
> data. Introduce a new structure, struct kvm_vm_mem_params, that defines: guest
> mode, a list of memory region descriptions, and some fields specifying what
> regions to use for code, pt, and data.
> 
> There is no functional change intended. The current commit adds a default
> struct kvm_vm_mem_params that lays out memory exactly as before. The next
> commit will change the allocators to get the region they should be using,
> e.g.,: like the page table allocators using the pt memslot.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 61 ++++++++++++++++-
>  .../selftests/kvm/lib/aarch64/processor.c     |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 65 +++++++++++++++++--
>  3 files changed, 119 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index b2dbe253d4d0..abe6c4e390ff 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -93,6 +93,16 @@ struct kvm_vm {
>  	int stats_fd;
>  	struct kvm_stats_header stats_header;
>  	struct kvm_stats_desc *stats_desc;
> +
> +	/*
> +	 * KVM region slots. These are the default memslots used by page
> +	 * allocators, e.g., lib/elf uses the code memslot.
> +	 */
> +	struct {
> +		uint32_t code;
> +		uint32_t pt;
> +		uint32_t data;
> +	} memslot;
>  };
>  
>  
> @@ -105,6 +115,21 @@ struct kvm_vm {
>  struct userspace_mem_region *
>  memslot2region(struct kvm_vm *vm, uint32_t memslot);
>  
> +inline struct userspace_mem_region *vm_get_code_region(struct kvm_vm *vm)
> +{
> +	return memslot2region(vm, vm->memslot.code);
> +}
> +
> +inline struct userspace_mem_region *vm_get_pt_region(struct kvm_vm *vm)
> +{
> +	return memslot2region(vm, vm->memslot.pt);
> +}
> +
> +inline struct userspace_mem_region *vm_get_data_region(struct kvm_vm *vm)
> +{
> +	return memslot2region(vm, vm->memslot.data);
> +}

I feel we'll be revisiting this frequently when more and more region types
are desired. For example, Sean wants a read-only memory region for ucall
exits. How about putting a mem slot array in struct kvm_vm, defining an
enum to index it (which will expand), and then single helper function,
something like

 inline struct userspace_mem_region *
 vm_get_mem_region(struct kvm_vm *vm, enum memslot_type mst)
 {
    return memslot2region(vm, vm->memslots[mst]);
 }

> +
>  /* Minimum allocated guest virtual and physical addresses */
>  #define KVM_UTIL_MIN_VADDR		0x2000
>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
> @@ -637,19 +662,51 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  			      vm_paddr_t paddr_min, uint32_t memslot);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
>  
> +#define MEM_PARAMS_MAX_MEMSLOTS 3

And this becomes MEMSLOT_MAX of the enum proposed above

 enum memslot_type {
     MEMSLOT_CODE,
     MEMSLOT_PT,
     MEMSLOT_DATA,
     MEMSLOT_MAX,
 };

> +
> +struct kvm_vm_mem_params {
> +	enum vm_guest_mode mode;
> +
> +	struct {
> +		enum vm_mem_backing_src_type src_type;
> +		uint64_t guest_paddr;
> +		/*
> +		 * KVM region slot (same meaning as in struct
> +		 * kvm_userspace_memory_region).
> +		 */
> +		uint32_t slot;
> +		uint64_t npages;
> +		uint32_t flags;
> +		bool enabled;
> +	} region[MEM_PARAMS_MAX_MEMSLOTS];
> +
> +	/* Indexes into the above array. */
> +	struct {
> +		uint16_t code;
> +		uint16_t pt;
> +		uint16_t data;
> +	} region_idx;

And this changes to another array of memslots also indexed with
enum memslot_type.

> +};
> +
> +extern struct kvm_vm_mem_params kvm_vm_mem_default;
> +
>  /*
>   * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
>   * loads the test binary into guest memory and creates an IRQ chip (x86 only).
>   * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
>   * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
>   */
> -struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
> +struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params);
>  struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
>  			   uint64_t nr_extra_pages);
>  
>  static inline struct kvm_vm *vm_create_barebones(void)
>  {
> -	return ____vm_create(VM_MODE_DEFAULT, 0);
> +	struct kvm_vm_mem_params params_wo_memslots = {
> +		.mode = kvm_vm_mem_default.mode,
> +	};
> +
> +	return ____vm_create(&params_wo_memslots);
>  }
>  
>  static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 26f0eccff6fe..5a31dc85d054 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -508,7 +508,8 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
>   */
>  void __attribute__((constructor)) init_guest_modes(void)
>  {
> -       guest_modes_append_default();
> +	guest_modes_append_default();
> +	kvm_vm_mem_default.mode = VM_MODE_DEFAULT;
>  }
>  
>  void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5a9f080ff888..91b42d6b726b 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -143,12 +143,41 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>  	       "Missing new mode params?");
>  
> -struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
> +/* A single memslot #0 for code, data, and page tables. */
> +struct kvm_vm_mem_params kvm_vm_mem_default = {
> +#if defined(__aarch64__)
> +	/* arm64 is the only arch without a true default mode. */
> +	.mode = NUM_VM_MODES,

How about

 #ifndef __arch64__
   /* arm64 kvm_vm_mem_default.mode set in init_guest_modes() */
   .mode = VM_MODE_DEFAULT,
 #endif

> +#else
> +	.mode = VM_MODE_DEFAULT,
> +#endif
> +	.region[0] = {
> +		.src_type = VM_MEM_SRC_ANONYMOUS,
> +		.guest_paddr = 0,
> +		.slot = 0,
> +		/*
> +		 * 4mb when page size is 4kb. Note that vm_nr_pages_required(),
> +		 * the function used by most tests to calculate guest memory
> +		 * requirements uses around ~520 pages for more tests.

...requirements, currently returns ~520 pages for the majority of tests.

> +		 */
> +		.npages = 1024,

And here we double it, but it's still fragile. I see we override this
in __vm_create() below though, so now I wonder why we set it at all.

> +		.flags = 0,
> +		.enabled = true,
> +	},
> +	.region_idx = {
> +		.code = 0,
> +		.pt = 0,
> +		.data = 0,
> +	},
> +};
> +
> +struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params)
>  {
> +	enum vm_guest_mode mode = mem_params->mode;
>  	struct kvm_vm *vm;
> +	int idx;
>  
> -	pr_debug("%s: mode='%s' pages='%ld'\n", __func__,
> -		 vm_guest_mode_string(mode), nr_pages);
> +	pr_debug("%s: mode='%s'\n", __func__, vm_guest_mode_string(mode));
>  
>  	vm = calloc(1, sizeof(*vm));
>  	TEST_ASSERT(vm != NULL, "Insufficient Memory");
> @@ -245,9 +274,28 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
>  
>  	/* Allocate and setup memory for guest. */
>  	vm->vpages_mapped = sparsebit_alloc();
> -	if (nr_pages != 0)
> -		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> -					    0, 0, nr_pages, 0);
> +
> +	/* Setup the code, pt, and data memslots according to the spec */
> +	for (idx = 0; idx < MEM_PARAMS_MAX_MEMSLOTS; idx++) {
> +		if (!mem_params->region[idx].enabled)
> +			continue;
> +
> +		vm_userspace_mem_region_add(vm,
> +			mem_params->region[idx].src_type,
> +			mem_params->region[idx].guest_paddr,
> +			mem_params->region[idx].slot,
> +			mem_params->region[idx].npages,
> +			mem_params->region[idx].flags);
> +	}
> +
> +	TEST_ASSERT(mem_params->region_idx.code < MEM_PARAMS_MAX_MEMSLOTS &&
> +		    mem_params->region_idx.pt < MEM_PARAMS_MAX_MEMSLOTS &&
> +		    mem_params->region_idx.data < MEM_PARAMS_MAX_MEMSLOTS,
> +		    "region_idx should be valid indexes\n");
> +
> +	vm->memslot.code = mem_params->region[mem_params->region_idx.code].slot;
> +	vm->memslot.pt = mem_params->region[mem_params->region_idx.pt].slot;
> +	vm->memslot.data = mem_params->region[mem_params->region_idx.data].slot;
>  
>  	return vm;
>  }
> @@ -292,9 +340,12 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
>  {
>  	uint64_t nr_pages = vm_nr_pages_required(mode, nr_runnable_vcpus,
>  						 nr_extra_pages);
> +	struct kvm_vm_mem_params mem_params = kvm_vm_mem_default;
>  	struct kvm_vm *vm;
>  
> -	vm = ____vm_create(mode, nr_pages);
> +	mem_params.region[0].npages = nr_pages;
> +	mem_params.mode = mode;
> +	vm = ____vm_create(&mem_params);
>  
>  	kvm_vm_elf_load(vm, program_invocation_name);
>  
> -- 
> 2.37.1.595.g718a3a8f04-goog
>

Thanks,
drew
