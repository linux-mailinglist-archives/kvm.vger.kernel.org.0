Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0DD35E441
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 18:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhDMQlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 12:41:24 -0400
Received: from foss.arm.com ([217.140.110.172]:44912 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhDMQlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 12:41:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB63011B3;
        Tue, 13 Apr 2021 09:41:03 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D694A3F694;
        Tue, 13 Apr 2021 09:41:02 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 6/8] arm/arm64: setup: Consolidate memory
 layout assumptions
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-7-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <534d262b-7b20-1fdb-f7cd-a048bedd55e9@arm.com>
Date:   Tue, 13 Apr 2021 17:41:01 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-7-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2021 19:59, Andrew Jones wrote:
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
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   arm/cstart.S        |   4 +-
>   arm/cstart64.S      |   2 +
>   arm/flat.lds        |  23 ++++++
>   lib/arm/asm/setup.h |   8 +--
>   lib/arm/mmu.c       |   2 -
>   lib/arm/setup.c     | 165 ++++++++++++++++++++++++--------------------
>   6 files changed, 123 insertions(+), 81 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 731f841695ce..14444124c43f 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -80,7 +80,9 @@ start:
>   
>   	/* complete setup */
>   	pop	{r0-r1}
> -	bl	setup
> +	mov	r1, #0
> +	ldr	r2, =stacktop		@ r1,r2 is the base of free memory
> +	bl	setup			@ r0 is the addr of the dtb
>   
>   	/* run the test */
>   	ldr	r0, =__argc
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index add60a2b4e74..434723d4b45d 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -94,6 +94,8 @@ start:
>   
>   	/* complete setup */
>   	mov	x0, x4				// restore the addr of the dtb
> +	adrp	x1, stacktop
> +	add	x1, x1, :lo12:stacktop		// x1 is the base of free memory
>   	bl	setup
>   
>   	/* run the test */
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
>   SECTIONS
>   {
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 210c14f818fb..f0e70b119fb0 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -13,9 +13,8 @@
>   extern u64 cpus[NR_CPUS];	/* per-cpu IDs (MPIDRs) */
>   extern int nr_cpus;
>   
> -#define MR_F_PRIMARY		(1U << 0)
> -#define MR_F_IO			(1U << 1)
> -#define MR_F_CODE		(1U << 2)
> +#define MR_F_IO			(1U << 0)
> +#define MR_F_CODE		(1U << 1)
>   #define MR_F_UNKNOWN		(1U << 31)
>   
>   struct mem_region {
> @@ -26,6 +25,7 @@ struct mem_region {
>   extern struct mem_region *mem_regions;
>   extern phys_addr_t __phys_offset, __phys_end;
>   
> +extern struct mem_region *mem_region_find(phys_addr_t paddr);
>   extern unsigned int mem_region_get_flags(phys_addr_t paddr);
>   
>   #define PHYS_OFFSET		(__phys_offset)
> @@ -35,6 +35,6 @@ extern unsigned int mem_region_get_flags(phys_addr_t paddr);
>   #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
>   #define SMP_CACHE_BYTES		L1_CACHE_BYTES
>   
> -void setup(const void *fdt);
> +void setup(const void *fdt, phys_addr_t freemem_start);
>   
>   #endif /* _ASMARM_SETUP_H_ */
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index edd2b9da809b..7cff22a12e86 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -225,12 +225,10 @@ void *setup_mmu(phys_addr_t phys_end)
>   		if (r->flags & MR_F_IO) {
>   			continue;
>   		} else if (r->flags & MR_F_CODE) {
> -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected code region");
>   			/* armv8 requires code shared between EL1 and EL0 to be read-only */
>   			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
>   					   __pgprot(PTE_WBWA | PTE_USER | PTE_RDONLY));
>   		} else {
> -			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected data region");
>   			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
>   					   __pgprot(PTE_WBWA | PTE_USER));
>   		}
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 9da5d24b0be9..5cda2d919d2b 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -28,9 +28,9 @@
>   
>   #include "io.h"
>   
> -#define NR_INITIAL_MEM_REGIONS 16
> +#define MAX_DT_MEM_REGIONS	16
> +#define NR_EXTRA_MEM_REGIONS	16
>   
> -extern unsigned long stacktop;
>   extern unsigned long etext;
>   
>   struct timer_state __timer_state;
> @@ -41,7 +41,7 @@ u32 initrd_size;
>   u64 cpus[NR_CPUS] = { [0 ... NR_CPUS-1] = (u64)~0 };
>   int nr_cpus;
>   
> -static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
> +static struct mem_region __initial_mem_regions[MAX_DT_MEM_REGIONS + NR_EXTRA_MEM_REGIONS];
>   struct mem_region *mem_regions = __initial_mem_regions;
>   phys_addr_t __phys_offset, __phys_end;
>   
> @@ -75,28 +75,62 @@ static void cpu_init(void)
>   	set_cpu_online(0, true);
>   }
>   
> -unsigned int mem_region_get_flags(phys_addr_t paddr)
> +static int mem_regions_next_index(void)

Wouldn't it be better if we added a mem_regions_add() function instead? 
I don't really mind this solution but it would hide the underlying 
implementation of mem_regions.

The rest of the change looks good to me. With the above comment:

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

>   {
>   	struct mem_region *r;
> +	int n;
>   
> -	for (r = mem_regions; r->end; ++r) {
> -		if (paddr >= r->start && paddr < r->end)
> -			return r->flags;
> +	for (r = mem_regions, n = 0; r->end; ++r, ++n)
> +		;
> +	return n;
> +}
> +
> +static void mem_regions_get_dt_regions(void)
> +{
> +	struct dt_pbus_reg regs[MAX_DT_MEM_REGIONS];
> +	int nr_regs, i, n;
> +
> +	nr_regs = dt_get_memory_params(regs, MAX_DT_MEM_REGIONS);
> +	assert(nr_regs > 0);
> +
> +	n = mem_regions_next_index();
> +
> +	for (i = 0; i < nr_regs; ++i) {
> +		struct mem_region *r = &mem_regions[n + i];
> +		r->start = regs[i].addr;
> +		r->end = regs[i].addr + regs[i].size;
>   	}
> +}
> +
> +struct mem_region *mem_region_find(phys_addr_t paddr)
> +{
> +	struct mem_region *r;
> +
> +	for (r = mem_regions; r->end; ++r)
> +		if (paddr >= r->start && paddr < r->end)
> +			return r;
> +	return NULL;
> +}
>   
> -	return MR_F_UNKNOWN;
> +unsigned int mem_region_get_flags(phys_addr_t paddr)
> +{
> +	struct mem_region *r = mem_region_find(paddr);
> +	return r ? r->flags : MR_F_UNKNOWN;
>   }
>   
> -static void mem_init(phys_addr_t freemem_start)
> +static void mem_regions_add_assumed(void)
>   {
>   	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
> -	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
> -	struct mem_region mem = {
> -		.start = (phys_addr_t)-1,
> -	};
> -	struct mem_region *primary = NULL;
> -	phys_addr_t base, top;
> -	int nr_regs, nr_io = 0, i;
> +	int n = mem_regions_next_index();
> +	struct mem_region mem = {0}, *r;
> +
> +	r = mem_region_find(code_end - 1);
> +	assert(r);
> +
> +	/* Split the region with the code into two regions; code and data */
> +	mem.start = code_end, mem.end = r->end;
> +	mem_regions[n++] = mem;
> +	r->end = code_end, r->flags = MR_F_CODE;
>   
>   	/*
>   	 * mach-virt I/O regions:
> @@ -104,50 +138,47 @@ static void mem_init(phys_addr_t freemem_start)
>   	 *   - 512M at 256G (arm64, arm uses highmem=off)
>   	 *   - 512G at 512G (arm64, arm uses highmem=off)
>   	 */
> -	mem_regions[nr_io++] = (struct mem_region){ 0, (1ul << 30), MR_F_IO };
> +	mem_regions[n++] = (struct mem_region){ 0, (1ul << 30), MR_F_IO };
>   #ifdef __aarch64__
> -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO };
> -	mem_regions[nr_io++] = (struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO };
> +	mem_regions[n++] = (struct mem_region){ (1ul << 38), (1ul << 38) | (1ul << 29), MR_F_IO };
> +	mem_regions[n++] = (struct mem_region){ (1ul << 39), (1ul << 40), MR_F_IO };
>   #endif
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
> +		assert(!(r->start & ~PHYS_MASK) && !((r->end - 1) & ~PHYS_MASK));
> +		if (!(r->flags & MR_F_IO)) {
> +			if (r->start < mem.start)
> +				mem.start = r->start;
> +			if (r->end > mem.end)
> +				mem.end = r->end;
>   		}
> -
> -		/*
> -		 * set the lowest and highest addresses found,
> -		 * ignoring potential gaps
> -		 */
> -		if (r->start < mem.start)
> -			mem.start = r->start;
> -		if (r->end > mem.end)
> -			mem.end = r->end;
>   	}
> -	assert(primary);
> -	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
> +	assert(mem.end);
> +
> +	/* Check for holes */
> +	r = mem_region_find(mem.start);
> +	while (r && r->end != mem.end)
> +		r = mem_region_find(r->end);
> +	assert(r);
>   
> -	__phys_offset = primary->start;	/* PHYS_OFFSET */
> -	__phys_end = primary->end;	/* PHYS_END */
> +	/* Ensure our selected freemem region is somewhere in our full range */
> +	assert(freemem_start >= mem.start && freemem->end <= mem.end);
>   
> -	/* Split the primary region into two regions; code and data */
> -	mem.start = code_end, mem.end = primary->end, mem.flags = MR_F_PRIMARY;
> -	mem_regions[nr_io + i] = mem;
> -	primary->end = code_end, primary->flags |= MR_F_CODE;
> +	__phys_offset = mem.start;	/* PHYS_OFFSET */
> +	__phys_end = mem.end;		/* PHYS_END */
>   
> -	phys_alloc_init(freemem_start, __phys_end - freemem_start);
> +	phys_alloc_init(freemem_start, freemem->end - freemem_start);
>   	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
>   
>   	phys_alloc_get_unused(&base, &top);
> @@ -197,35 +228,17 @@ static void timer_save_state(void)
>   	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
>   }
>   
> -void setup(const void *fdt)
> +void setup(const void *fdt, phys_addr_t freemem_start)
>   {
> -	void *freemem = &stacktop;
> +	void *freemem;
>   	const char *bootargs, *tmp;
>   	u32 fdt_size;
>   	int ret;
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
>   	fdt_size = fdt_totalsize(fdt);
>   	ret = fdt_move(fdt, freemem, fdt_size);
>   	assert(ret == 0);
> @@ -233,6 +246,7 @@ void setup(const void *fdt)
>   	assert(ret == 0);
>   	freemem += fdt_size;
>   
> +	/* Move the initrd to the top of the FDT */
>   	ret = dt_get_initrd(&tmp, &initrd_size);
>   	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
>   	if (ret == 0) {
> @@ -241,7 +255,10 @@ void setup(const void *fdt)
>   		freemem += initrd_size;
>   	}
>   
> +	mem_regions_get_dt_regions();
> +	mem_regions_add_assumed();
>   	mem_init(PAGE_ALIGN((unsigned long)freemem));
> +
>   	cpu_init();
>   
>   	/* cpu_init must be called before thread_info_init */
> 
