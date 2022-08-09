Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E0658D63A
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbiHIJQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241408AbiHIJP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D322522B3F
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63AEC143D;
        Tue,  9 Aug 2022 02:15:53 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F8E23F67D;
        Tue,  9 Aug 2022 02:15:51 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 18/19] arm/arm64: Perform dcache maintenance at boot
Date:   Tue,  9 Aug 2022 10:15:57 +0100
Message-Id: <20220809091558.14379-19-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The arm and arm64 architectures require explicit cache maintenance to
keep the memory in sync with the caches when the MMU is turned on. When
the MMU is off, reads and writes are access system memory directly, but
with the MMU on, the same accesses hit the cache.

The sequence of cache maintenance operations to keep the cache contents
in sync with memory is:

1. Dcache invalidation for memory location M before the first write to
that location. This is needed to avoid a dirty cache line for address
M* being evicted after the explicit write that follows, and overwriting
the value that software writes. Dcache clean also works, but invalidation
is faster on bare metal. When running in a virtual machine, dcache
invalidation is promoted to dcache clean + invalidation, so it makes little
difference exactly which of the dcache operations is chosen, as long as
the result is that no cache line is dirty.

2. A write, or multiple writes, to memory address M are performed.

3. After the last write, and before the first read with the MMU on, the
dcache line that hold the value for memory location M needs to be
invalidated. This is needed to make sure that loads fetch data from
memory, where the most recent value written in step 2 is, instead of
reading clean, but stale values from the cache**.

For robustness and simplicty, the dcache invalidation at step 3 is
performed after the last write with the MMU off.

When running under KVM, the maintenance operations can be omitted when
first enabling the MMU because:

- KVM performs a dcache clean + invalidate on each page the first time a
guest accesses the page. This corresponds to the maintenance at step 1.

- KVM performs a dcache clean + invalidate on the entire guest memory when
  the MMU is turned on. This corresponds to the maintenance at step 3. The
dcache clean is harmless for a guest, because all accessed cache lines are
already clean because of the cache maintenance above.

The situation changes when kvm-unit-tests turns the MMU off and then turns
it back on: KVM will skip the cache maintenance when the MMU is enabled
again, and potentially skip the maintenance on page access if the page is
already mapped at stage 2. In this case, explicit cache maintenance is
required even when running as a KVM guest, although this is the
responsibility of the test to perform, since the library or boot code
doesn't turn the MMU off after enabling it.

Do what is needed to ensure correctness and perform the CMOs before
enabling the MMU on the boot path. The stack is a special case, since
kvm-unit-tests runs C code with the MMU disabled and the compiler can
arbitrarily modify the stack when compiling C code. So invalidate the
entire stack in the assembly function asm_mmu_enable.

Note that for static variables, the dcache maintenance at step 1 is omitted
because either the variable is stored in the data section of the test
image, which is cleaned to the PoC as per the Linux boot protocol, or in
the BSS section, which is invalidated to the PoC in the assembly entry code.

*The cache line could have been dirtied by higher level software, for
example by firmware.
**Even though the address M is invalidated in step 1, higher level software
could have allocated a new, clean cache line, as a result of a direct or
speculated read.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart.S            | 20 +++++++++++++
 arm/cstart64.S          | 30 ++++++++++++++++++++
 lib/arm/asm/pgtable.h   |  8 ++++++
 lib/arm/mmu.c           |  4 +++
 lib/arm/setup.c         | 62 +++++++++++++++++++++++++++++++++--------
 lib/arm64/asm/pgtable.h | 10 +++++++
 lib/devicetree.c        |  2 +-
 7 files changed, 124 insertions(+), 12 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 877559b367de..fc7c558802f1 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -34,12 +34,24 @@ start:
 	/* zero BSS */
 	ldr	r4, =bss
 	ldr	r5, =ebss
+	mov	r3, r4
+	dmb	sy
+	dcache_by_line_op dcimvac, sy, r4, r5, r6, r7
+	mov	r4, r3
 	zero_range r4, r5, r6, r7
+	mov	r4, r3
+	dmb	sy
+	dcache_by_line_op dcimvac, sy, r4, r5, r6, r7
 
 	/* zero stack */
 	ldr	r5, =stacktop
 	sub	r4, r5, #THREAD_SIZE
+	mov	r3, r4
+	dmb	sy
+	dcache_by_line_op dcimvac, sy, r4, r5, r6, r7
+	mov	r4, r3
 	zero_range r4, r5, r6, r7
+	/* asm_mmu_enable will perform the rest of the cache maintenance. */
 
 	/*
 	 * set stack, making room at top of stack for cpu0's
@@ -145,6 +157,7 @@ secondary_entry:
 	lsr	r2, #THREAD_SHIFT
 	lsl	r2, #THREAD_SHIFT
 	add	r3, r2, #THREAD_SIZE
+	/* Stack already cleaned to PoC, no need for cache maintenance. */
 	zero_range r2, r3, r4, r5
 	mov	sp, r0
 
@@ -204,6 +217,13 @@ asm_mmu_enable:
 	mcrr	p15, 0, r0, r1, c2
 	isb
 
+	dmb	sy
+	mov	r0, sp
+	lsr	r0, #THREAD_SHIFT
+	lsl	r0, #THREAD_SHIFT
+	add	r1, r0, #THREAD_SIZE
+	dcache_by_line_op dcimvac, sy, r0, r1, r3, r4
+
 	/* SCTLR */
 	mrc	p15, 0, r2, c1, c0, 0
 	orr	r2, #CR_C
diff --git a/arm/cstart64.S b/arm/cstart64.S
index face185a7781..1ce6b9e14d23 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -49,6 +49,7 @@ start:
 	add     x5, x5, :lo12:reloc_start
 	adrp	x6, reloc_end
 	add     x6, x6, :lo12:reloc_end
+
 1:
 	cmp	x5, x6
 	b.hs	1f
@@ -56,22 +57,44 @@ start:
 	ldr	x8, [x5, #16]			// r_addend
 	add	x8, x8, x4			// val = base + r_addend
 	str	x8, [x4, x7]			// base[r_offset] = val
+	add	x7, x4, x7
+	dmb	sy
+	/* Image is cleaned to PoC, no need for CMOs before the memory write. */
+	dc	ivac, x7
 	add	x5, x5, #24
 	b	1b
 
 1:
+	/* Complete the cache maintenance operations. */
+	dsb	sy
+
 	/* zero BSS */
 	adrp	x4, bss
 	add	x4, x4, :lo12:bss
 	adrp    x5, ebss
 	add     x5, x5, :lo12:ebss
+	/* Stash start of bss, as dcache_by_line_op corrupts it. */
+	mov	x9, x4
+	dmb	sy
+	/* Make sure there are no dirty cache lines that can be evicted. */
+	dcache_by_line_op ivac, sy, x4, x5, x6, x7
+	mov	x4, x9
 	zero_range x4, x5
+	mov	x9, x4
+	dmb	sy
+	/* Invalidate clean and potentially stale cache lines. */
+	dcache_by_line_op ivac, sy, x4, x5, x6, x7
 
 	/* zero and set up stack */
 	adrp    x5, stacktop
 	add     x5, x5, :lo12:stacktop
 	sub	x4, x5, #THREAD_SIZE
+	mov	x9, x4
+	dmb	sy
+	dcache_by_line_op ivac, sy, x4, x5, x6, x7
+	mov	x4, x9
 	zero_range x4, x5
+	/* asm_mmu_enable will perform the rest of the cache maintenance. */
 
 	/* set SCTLR_EL1 to a known value */
 	ldr	x4, =INIT_SCTLR_EL1_MMU_OFF
@@ -143,6 +166,7 @@ secondary_entry:
 	ldr	x0, [x0, :lo12:secondary_data]
 	and	x1, x0, #THREAD_MASK
 	add	x2, x1, #THREAD_SIZE
+	/* Stack already cleaned to PoC, no need for cache maintenance. */
 	zero_range x1, x2
 	mov	sp, x0
 
@@ -212,6 +236,12 @@ asm_mmu_enable:
 	tlbi	vmalle1			// invalidate I + D TLBs
 	dsb	nsh
 
+	dmb	sy
+	mov	x9, sp
+	and	x9, x9, #THREAD_MASK
+	add	x10, x9, #THREAD_SIZE
+	dcache_by_line_op ivac, sy, x9, x10, x11, x12
+
 	/* TCR */
 	ldr	x1, =TCR_TxSZ(VA_BITS) |		\
 		     TCR_TG_FLAGS  |			\
diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 1911e35bb091..3cfdccd00733 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -22,6 +22,8 @@
  */
 #include <linux/compiler.h>
 
+#include <asm/cacheflush.h>
+
 #define pgtable_va(x)		((void *)(unsigned long)(x))
 #define pgtable_pa(x)		((unsigned long)(x))
 
@@ -44,7 +46,9 @@
 static inline pgd_t *pgd_alloc_early(void)
 {
 	pgd_t *pgd = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pgd);
 	memset(pgd, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pgd);
 	return pgd;
 }
 static inline pgd_t *pgd_alloc(void)
@@ -86,7 +90,9 @@ static inline pmd_t *pmd_alloc_one_early(void)
 {
 	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
 	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	memset(pmd, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	return pmd;
 }
 static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
@@ -125,7 +131,9 @@ static inline pte_t *pte_alloc_one_early(void)
 {
 	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
 	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	memset(pte, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	return pte;
 }
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 19c98a8a9640..56c64d9c26d4 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -5,6 +5,7 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
+#include <asm/cacheflush.h>
 #include <asm/setup.h>
 #include <asm/thread_info.h>
 #include <asm/cpumask.h>
@@ -15,6 +16,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 
+#include "alloc_phys.h"
 #include "io.h"
 #include "vmalloc.h"
 
@@ -186,6 +188,8 @@ void mmu_setup_early(phys_addr_t unused0, void *unused1)
 	install_page_prot(mmu_idmap, (phys_addr_t)(unsigned long)uart_base,
 			  (uintptr_t)uart_base, uart_prot);
 
+	phys_alloc_perform_cache_maintenance(dcache_clean_inval_addr_poc);
+
 	asm_mmu_enable((phys_addr_t)(unsigned long)mmu_idmap);
 }
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 73f7c22c6828..54422fe7a981 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -19,6 +19,7 @@
 #include <vmalloc.h>
 #include <auxinfo.h>
 #include <argv.h>
+#include <asm/cacheflush.h>
 #include <asm/thread_info.h>
 #include <asm/setup.h>
 #include <asm/page.h>
@@ -160,6 +161,7 @@ static void mem_init(phys_addr_t freemem_start)
 	struct mem_region *freemem, *r, mem = {
 		.start = (phys_addr_t)-1,
 	};
+	int nr_regions = 0;
 
 	freemem = mem_region_find(freemem_start);
 	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
@@ -171,6 +173,7 @@ static void mem_init(phys_addr_t freemem_start)
 			if (r->end > mem.end)
 				mem.end = r->end;
 		}
+		nr_regions++;
 	}
 	assert(mem.end && !(mem.start & ~PHYS_MASK));
 	mem.end &= PHYS_MASK;
@@ -184,6 +187,9 @@ static void mem_init(phys_addr_t freemem_start)
 	/* Ensure our selected freemem range is somewhere in our full range */
 	assert(freemem_start >= mem.start && freemem->end <= mem.end);
 
+	dcache_inval_poc((unsigned long)mem_regions,
+			 (unsigned long)(mem_regions + nr_regions));
+
 	__phys_offset = mem.start;	/* PHYS_OFFSET */
 	__phys_end = mem.end;		/* PHYS_END */
 
@@ -240,32 +246,66 @@ static void timer_save_state(void)
 	__timer_state.vtimer.irq_flags = fdt32_to_cpu(data[8]);
 }
 
-void setup(const void *fdt, phys_addr_t freemem_start)
+extern const void *fdt;
+static void do_fdt_move(void *freemem, const void *fdt_addr, u32 *fdt_size)
 {
-	void *freemem;
-	const char *bootargs, *tmp;
-	u32 fdt_size;
 	int ret;
 
-	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
-	freemem = (void *)(unsigned long)freemem_start;
-
 	/* Move the FDT to the base of free memory */
-	fdt_size = fdt_totalsize(fdt);
-	ret = fdt_move(fdt, freemem, fdt_size);
+	*fdt_size = fdt_totalsize(fdt_addr);
+
+	/* Invalidate potentially dirty cache lines. */
+	dcache_inval_poc((unsigned long)freemem, (unsigned long)freemem + *fdt_size);
+	ret = fdt_move(fdt_addr, freemem, *fdt_size);
 	assert(ret == 0);
+
 	ret = dt_init(freemem);
+	/*
+	 * Invalidate the clean (the bootloader cleans the test image to PoC),
+	 * but potentially stale, cache line that holds the value of the
+	 * variable fdt, to force the CPU to fetch it from memory when the MMU
+	 * is enabled.
+	 */
+	dcache_clean_inval_addr_poc((unsigned long)&fdt);
 	assert(ret == 0);
-	freemem += fdt_size;
+}
+
+static void initrd_move(void *freemem)
+{
+	const char *tmp;
+	int ret;
 
 	/* Move the initrd to the top of the FDT */
 	ret = dt_get_initrd(&tmp, &initrd_size);
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	if (ret == 0) {
 		initrd = freemem;
+		/* Invalidate the potentially stale cached value for initrd. */
+		dcache_clean_inval_addr_poc((unsigned long)&initrd);
+		/* Invalidate potentially dirty cache lines. */
+		dcache_inval_poc((unsigned long)freemem, (unsigned long)freemem + initrd_size);
 		memmove(initrd, tmp, initrd_size);
-		freemem += initrd_size;
 	}
+}
+
+void setup(const void *fdt_addr, phys_addr_t freemem_start)
+{
+	void *freemem;
+	const char *bootargs;
+	u32 fdt_size;
+	int ret;
+
+	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
+	freemem = (void *)(unsigned long)freemem_start;
+
+	do_fdt_move(freemem, fdt_addr, &fdt_size);
+	freemem += fdt_size;
+
+	initrd_move(freemem);
+	freemem += initrd_size;
+
+	/* Invalidate potentially stale cache lines. */
+	dcache_inval_poc(freemem_start, (unsigned long)freemem);
 
 	mem_regions_add_dt_regions();
 	mem_regions_add_assumed();
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 98d51c89b7c0..c026fd01e4c8 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -15,6 +15,8 @@
  */
 #include <alloc.h>
 #include <alloc_page.h>
+
+#include <asm/cacheflush.h>
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
@@ -50,7 +52,9 @@
 static inline pgd_t *pgd_alloc_early(void)
 {
 	pgd_t *pgd = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pgd);
 	memset(pgd, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pgd);
 	return pgd;
 }
 static inline pgd_t *pgd_alloc(void)
@@ -96,7 +100,9 @@ static inline pmd_t *pmd_alloc_one_early(void)
 {
 	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
 	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	memset(pmd, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	return pmd;
 }
 static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
@@ -135,7 +141,9 @@ static inline pud_t *pud_alloc_one_early(void)
 {
 	assert(PTRS_PER_PUD * sizeof(pud_t) == PAGE_SIZE);
 	pud_t *pud = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pud);
 	memset(pud, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pud);
 	return pud;
 }
 static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
@@ -174,7 +182,9 @@ static inline pte_t *pte_alloc_one_early(void)
 {
 	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
 	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	memset(pte, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	return pte;
 }
 static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
diff --git a/lib/devicetree.c b/lib/devicetree.c
index 78c1f6fbe474..be3c8a30a72d 100644
--- a/lib/devicetree.c
+++ b/lib/devicetree.c
@@ -7,7 +7,7 @@
 #include "libfdt/libfdt.h"
 #include "devicetree.h"
 
-static const void *fdt;
+const void *fdt;
 
 const void *dt_fdt(void)
 {
-- 
2.37.1

