Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6FA37AA4C
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 17:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhEKPLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 11:11:41 -0400
Received: from foss.arm.com ([217.140.110.172]:49694 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231779AbhEKPLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 11:11:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 907CDD6E;
        Tue, 11 May 2021 08:10:34 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B15E23F718;
        Tue, 11 May 2021 08:10:33 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v3 6/8] arm/arm64: setup: Consolidate
 memory layout assumptions
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210429164130.405198-1-drjones@redhat.com>
 <20210429164130.405198-7-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <38b56d10-25a7-bc90-61c3-52a026e5f6fe@arm.com>
Date:   Tue, 11 May 2021 16:11:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210429164130.405198-7-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/29/21 5:41 PM, Andrew Jones wrote:
> Keep as much memory layout assumptions as possible in init::start
> and a single setup function. This prepares us for calling setup()
> from different start functions which have been linked with different
> linker scripts. To do this, stacktop is only referenced from
> init::start, making freemem_start a parameter to setup(). We also
> split mem_init() into three parts, one that populates the mem regions
> per the DT, one that populates the mem regions per assumptions,
> and one that does the mem init. The concept of a primary region
> is dropped, but we add a sanity check for the absence of memory
> holes, because we don't know how to deal with them yet.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S        |   4 +-
>  arm/cstart64.S      |   2 +
>  arm/flat.lds        |  23 ++++++
>  lib/arm/asm/setup.h |   8 +-
>  lib/arm/mmu.c       |   2 -
>  lib/arm/setup.c     | 175 ++++++++++++++++++++++++--------------------
>  6 files changed, 128 insertions(+), 86 deletions(-)
>
> diff --git a/arm/cstart.S b/arm/cstart.S
> index bf3c78157e6a..446966de350d 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -80,7 +80,9 @@ start:
>  
>  	/* complete setup */
>  	pop	{r0-r1}
> -	bl	setup
> +	mov	r3, #0
> +	ldr	r2, =stacktop		@ r2,r3 is the base of free memory
> +	bl	setup			@ r0 is the addr of the dtb
>  
>  	/* run the test */
>  	ldr	r0, =__argc
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 27251fe8b5cd..42ba3a3ca249 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -92,6 +92,8 @@ start:
>  	bl	exceptions_init
>  
>  	/* complete setup */
> +	adrp	x1, stacktop
> +	add	x1, x1, :lo12:stacktop		// x1 is the base of free memory
>  	bl	setup				// x0 is the addr of the dtb
>  
>  	/* run the test */
> diff --git a/arm/flat.lds b/arm/flat.lds
> index 6ed377c0eaa0..6fb459efb815 100644
> --- a/arm/flat.lds
> +++ b/arm/flat.lds
> @@ -1,3 +1,26 @@
> +/*
> + * init::start will pass stacktop to setup() as the base of free memory.
> + * setup() will then move the FDT and initrd to that base before calling
> + * mem_init(). With those movements and this linker script, we'll end up
> + * having the following memory layout:
> + *
> + *    +----------------------+   <-- top of physical memory
> + *    |                      |
> + *    ~                      ~
> + *    |                      |
> + *    +----------------------+   <-- top of initrd
> + *    |                      |
> + *    +----------------------+   <-- top of FDT
> + *    |                      |
> + *    +----------------------+   <-- top of cpu0's stack
> + *    |                      |
> + *    +----------------------+   <-- top of text/data/bss sections
> + *    |                      |
> + *    |                      |
> + *    +----------------------+   <-- load address
> + *    |                      |
> + *    +----------------------+   <-- physical address 0x0
> + */
>  
>  SECTIONS
>  {
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 210c14f818fb..f0e70b119fb0 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -13,9 +13,8 @@
>  extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
>  extern int nr_cpus;
>  
> -#define MR_F_PRIMARY		(1U << 0)
> -#define MR_F_IO			(1U << 1)
> -#define MR_F_CODE		(1U << 2)
> +#define MR_F_IO			(1U << 0)
> +#define MR_F_CODE		(1U << 1)
>  #define MR_F_UNKNOWN		(1U << 31)
>  
>  struct mem_region {
> @@ -26,6 +25,7 @@ struct mem_region {
>  extern struct mem_region *mem_regions;
>  extern phys_addr_t __phys_offset, __phys_end;
>  
> +extern struct mem_region *mem_region_find(phys_addr_t paddr);
>  extern unsigned int mem_region_get_flags(phys_addr_t paddr);
>  
>  #define PHYS_OFFSET		(__phys_offset)
> @@ -35,6 +35,6 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
>  #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
>  #define SMP_CACHE_BYTES		L1_CACHE_BYTES
>  
> -void setup(const void *fdt);
> +void setup(const void *fdt, phys_addr_t freemem_start);
>  
>  #endif /* _ASMARM_SETUP_H_ */
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 7d658a3fe89c..7628f797a543 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -175,12 +175,10 @@ void *setup_mmu(phys_addr_t phys_end)
>  		if (r->flags & MR_F_IO) {
>  			continue;
>  		} else if (r->flags & MR_F_CODE) {
> -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected code region");
>  			/* armv8 requires code shared between EL1 and EL0 to be read-only */
>  			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
>  					   __pgprot(PTE_WBWA | PTE_USER | PTE_RDONLY));
>  		} else {
> -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected data region");
>  			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
>  					   __pgprot(PTE_WBWA | PTE_USER));
>  		}
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 7db308b70744..86f054304baf 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -28,9 +28,10 @@
>  
>  #include "io.h"
>  
> -#define NR_INITIAL_MEM_REGIONS 16
> +#define MAX_DT_MEM_REGIONS	16
> +#define NR_EXTRA_MEM_REGIONS	16
> +#define NR_INITIAL_MEM_REGIONS	(MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS)
>  
> -extern unsigned long stacktop;
>  extern unsigned long etext;
>  
>  struct timer_state __timer_state;
> @@ -75,28 +76,68 @@ static void cpu_init(void)
>  	set_cpu_online(0, true);
>  }
>  
> -unsigned int mem_region_get_flags(phys_addr_t paddr)
> +static void mem_region_add(struct mem_region *r)
> +{
> +	struct mem_region *r_next = mem_regions;
> +	int i = 0;
> +
> +	for (; r_next->end; ++r_next, ++i)
> +		;
> +	assert(i < NR_INITIAL_MEM_REGIONS);
> +
> +	*r_next = *r;
> +}
> +
> +static void mem_regions_add_dt_regions(void)
> +{
> +	struct dt_pbus_reg regs[MAX_DT_MEM_REGIONS];
> +	int nr_regs, i;
> +
> +	nr_regs = dt_get_memory_params(regs, MAX_DT_MEM_REGIONS);
> +	assert(nr_regs > 0);
> +
> +	for (i = 0; i < nr_regs; ++i) {
> +		mem_region_add(&(struct mem_region){
> +			.start = regs[i].addr,
> +			.end = regs[i].addr + regs[i].size,
> +		});
> +	}
> +}
> +
> +struct mem_region *mem_region_find(phys_addr_t paddr)
>  {
>  	struct mem_region *r;
>  
> -	for (r = mem_regions; r->end; ++r) {
> +	for (r = mem_regions; r->end; ++r)
>  		if (paddr >= r->start && paddr < r->end)
> -			return r->flags;
> -	}
> +			return r;
> +	return NULL;
> +}
>  
> -	return MR_F_UNKNOWN;
> +unsigned int mem_region_get_flags(phys_addr_t paddr)
> +{
> +	struct mem_region *r = mem_region_find(paddr);
> +	return r ? r->flags : MR_F_UNKNOWN;
>  }
>  
> -static void mem_init(phys_addr_t freemem_start)
> +static void mem_regions_add_assumed(void)
>  {
>  	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
> -	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
> -	struct mem_region mem = {
> -		.start = (phys_addr_t)-1,
> +	struct mem_region *r;
> +
> +	r = mem_region_find(code_end - 1);
> +	assert(r);
> +
> +	/* Split the region with the code into two regions; code and data */
> +	mem_region_add(&(struct mem_region){
> +		.start = code_end,
> +		.end = r->end,
> +	});
> +	*r = (struct mem_region){
> +		.start = r->start,
> +		.end = code_end,
> +		.flags = MR_F_CODE,
>  	};
> -	struct mem_region *primary = NULL;
> -	phys_addr_t base, top;
> -	int nr_regs, nr_io = 0, i;
>  
>  	/*
>  	 * mach-virt I/O regions:
> @@ -104,57 +145,47 @@ static void mem_init(phys_addr_t freemem_start)
>  	 *   - 512M at 256G (arm64, arm uses highmem=off)
>  	 *   - 512G at 512G (arm64, arm uses highmem=off)
>  	 */
> -	mem_regions[nr_io++] = (struct mem_region){ 0, (1ul << 30), MR_F_IO };
> +	mem_region_add(&(struct mem_region){ 0, (1ul << 30), MR_F_IO });
>  #ifdef __aarch64__
> -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO };
> -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO };
> +	mem_region_add(&(struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO });
> +	mem_region_add(&(struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO });
>  #endif
> +}
>  
> -	nr_regs = dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
> -	assert(nr_regs > 0);
> -
> -	for (i = 0; i < nr_regs; ++i) {
> -		struct mem_region *r = &mem_regions[nr_io + i];
> +static void mem_init(phys_addr_t freemem_start)
> +{
> +	phys_addr_t base, top;
> +	struct mem_region *freemem, *r, mem = {
> +		.start = (phys_addr_t)-1,
> +	};
>  
> -		r->start = regs[i].addr;
> -		r->end = regs[i].addr + regs[i].size;
> +	freemem = mem_region_find(freemem_start);
> +	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
>  
> -		/*
> -		 * pick the region we're in for our primary region
> -		 */
> -		if (freemem_start >= r->start && freemem_start < r->end) {
> -			r->flags |= MR_F_PRIMARY;
> -			primary = r;
> +	for (r = mem_regions; r->end; ++r) {
> +		if (!(r->flags & MR_F_IO)) {
> +			if (r->start < mem.start)
> +				mem.start = r->start;
> +			if (r->end > mem.end)
> +				mem.end = r->end;
>  		}
> -
> -		/*
> -		 * set the lowest and highest addresses found,
> -		 * ignoring potential gaps
> -		 */
> -		if (r->start < mem.start)
> -			mem.start = r->start;
> -		if (r->end > mem.end)
> -			mem.end = r->end;
>  	}
> -	assert(primary);
> -	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
> +	assert(mem.end && !(mem.start & ~PHYS_MASK));
> +	mem.end &= PHYS_MASK;
>  
> -	__phys_offset = primary->start;	/* PHYS_OFFSET */
> -	__phys_end = primary->end;	/* PHYS_END */
> +	/* Check for holes */
> +	r = mem_region_find(mem.start);
> +	while (r && r->end != mem.end)
> +		r = mem_region_find(r->end);
> +	assert(r);
>  
> -	/* Split the primary region into two regions; code and data */
> -	mem_regions[nr_io + i] = (struct mem_region){
> -		.start = code_end,
> -		.end = primary->end,
> -		.flags = MR_F_PRIMARY,
> -	};
> -	*primary = (struct mem_region){
> -		.start = primary->start,
> -		.end = code_end,
> -		.flags = MR_F_PRIMARY | MR_F_CODE,
> -	};
> +	/* Ensure our selected freemem range is somewhere in our full range */
> +	assert(freemem_start >= mem.start && freemem->end <= mem.end);
>  
> -	phys_alloc_init(freemem_start, __phys_end - freemem_start);
> +	__phys_offset = mem.start;	/* PHYS_OFFSET */
> +	__phys_end = mem.end;		/* PHYS_END */
> +
> +	phys_alloc_init(freemem_start, freemem->end - freemem_start);
>  	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
>  
>  	phys_alloc_get_unused(&base, &top);
> @@ -204,35 +235,17 @@ static void timer_save_state(void)
>  	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
>  }
>  
> -void setup(const void *fdt)
> +void setup(const void *fdt, phys_addr_t freemem_start)
>  {
> -	void *freemem = &stacktop;
> +	void *freemem;
>  	const char *bootargs, *tmp;
>  	u32 fdt_size;
>  	int ret;
>  
> -	/*
> -	 * Before calling mem_init we need to move the fdt and initrd
> -	 * to safe locations. We move them to construct the memory
> -	 * map illustrated below:
> -	 *
> -	 *    +----------------------+   <-- top of physical memory
> -	 *    |                      |
> -	 *    ~                      ~
> -	 *    |                      |
> -	 *    +----------------------+   <-- top of initrd
> -	 *    |                      |
> -	 *    +----------------------+   <-- top of FDT
> -	 *    |                      |
> -	 *    +----------------------+   <-- top of cpu0's stack
> -	 *    |                      |
> -	 *    +----------------------+   <-- top of text/data/bss sections,
> -	 *    |                      |       see arm/flat.lds
> -	 *    |                      |
> -	 *    +----------------------+   <-- load address
> -	 *    |                      |
> -	 *    +----------------------+
> -	 */
> +	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
> +	freemem = (void *)(unsigned long)freemem_start;
> +
> +	/* Move the FDT to the base of free memory */
>  	fdt_size = fdt_totalsize(fdt);
>  	ret = fdt_move(fdt, freemem, fdt_size);
>  	assert(ret == 0);
> @@ -240,6 +253,7 @@ void setup(const void *fdt)
>  	assert(ret == 0);
>  	freemem += fdt_size;
>  
> +	/* Move the initrd to the top of the FDT */
>  	ret = dt_get_initrd(&tmp, &initrd_size);
>  	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
>  	if (ret == 0) {
> @@ -248,7 +262,10 @@ void setup(const void *fdt)
>  		freemem += initrd_size;
>  	}
>  
> +	mem_regions_add_dt_regions();
> +	mem_regions_add_assumed();
>  	mem_init(PAGE_ALIGN((unsigned long)freemem));
> +
>  	cpu_init();
>  
>  	/* cpu_init must be called before thread_info_init */
