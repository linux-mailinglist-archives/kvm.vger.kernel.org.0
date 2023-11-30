Return-Path: <kvm+bounces-2879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D207FEB81
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5894028252D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96D93C6B1;
	Thu, 30 Nov 2023 09:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dr4m+3qm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3538110F5
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6DfW5sT1Il8qeGHiWy46mkuBI8jJIv1DTM2KX/kYA2k=;
	b=dr4m+3qmE+u+D8I2qhKoy/V3EdY46b3MM8A1ALKY9zyyQdLeuxdwcmcwL4wALvVv6Uyc/L
	MELUHYCVytLa0MuDKrTnj4R2NwYLLBIxKRLpew6rAh40sSuvMBNe8u3QV3dgRbQ8YcHEqQ
	WhWZsJeuolXr9Yeji68vZ3atKYT6igs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-XC-rW_S9OECdoiFhr8ExLw-1; Thu, 30 Nov 2023 04:07:58 -0500
X-MC-Unique: XC-rW_S9OECdoiFhr8ExLw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D2A5185A795;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AB331C060AE;
	Thu, 30 Nov 2023 09:07:58 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 17/18] arm/arm64: Perform dcache maintenance at boot
Date: Thu, 30 Nov 2023 04:07:19 -0500
Message-Id: <20231130090722.2897974-18-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

The arm and arm64 architectures require explicit cache maintenance to keep
the memory in sync with the caches when the MMU is turned on. That's
because when the MMU is off, reads and writes are access system memory
directly, but with the MMU on, the same accesses hit the cache.

The sequence of cache maintenance operations to keep the cache contents
in sync with memory is:

1. Dcache invalidation for memory location M before the first write to that
location. This is needed to avoid a dirty cache line for address M*
being evicted after the explicit write that follows, and overwriting the
value that is explicitely written. Dcache clean also works, but
invalidation is faster on bare metal. When running in a virtual machine,
dcache invalidation is promoted to dcache clean + invalidation, so it makes
little difference exactly which of the dcache operations is chosen, as long
as the result is that the cache line is not dirty.

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
already clean because of the maintenance that KVM performs when memory is
first accessed.

The situation changes when kvm-unit-tests turns the MMU off and then turns
it back on: KVM will skip the cache maintenance when the MMU is enabled
again, and likely skip the maintenance on page access if the page is
already mapped at stage 2. In this case, explicit cache maintenance is
required even when running as a KVM guest, although this is the
responsibility of the test to perform, since the kvm-unit-tests library
doesn't turn the MMU off after enabling it.

Do what is needed to ensure correctness and perform the CMOs before
enabling the MMU on the boot path. The stack is a special case, since
kvm-unit-tests runs C code with the MMU disabled and the compiler can
arbitrarily use the stack when compiling C code. Invalidate the entire
stack in the assembly function asm_mmu_enable, as there is no other way to
make sure that the stack is invalidated after the MMU is enabled.

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
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arm/cstart.S            | 24 +++++++++++++
 arm/cstart64.S          | 34 +++++++++++++++++++
 lib/arm/asm/page.h      |  2 ++
 lib/arm/asm/pgtable.h   | 12 +++++++
 lib/arm/mmu.c           |  4 +++
 lib/arm/setup.c         | 75 +++++++++++++++++++++++++++++++++++------
 lib/arm64/asm/pgtable.h | 16 +++++++++
 lib/devicetree.c        |  2 +-
 8 files changed, 157 insertions(+), 12 deletions(-)

diff --git a/arm/cstart.S b/arm/cstart.S
index 090cf38d..48dc87f5 100644
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
@@ -145,7 +157,12 @@ secondary_entry:
 	lsr	r2, #THREAD_SHIFT
 	lsl	r2, #THREAD_SHIFT
 	add	r3, r2, #THREAD_SIZE
+	mov	r6, r2
+	dmb	sy
+	dcache_by_line_op dcimvac, sy, r2, r3, r4, r5
+	mov	r2, r6
 	zero_range r2, r3, r4, r5
+	/* asm_mmu_enable will perform the rest of the cache maintenance. */
 	mov	sp, r0
 
 	bl	exceptions_init
@@ -204,6 +221,13 @@ asm_mmu_enable:
 	mcrr	p15, 0, r0, r1, c2
 	isb
 
+	dmb	sy
+	mov	r0, sp
+	lsr	r0, #THREAD_SHIFT
+	lsl	r0, #THREAD_SHIFT
+	add	r1, r0, #THREAD_SIZE
+	dcache_by_line_op dcimvac, sy, r0, r1, r2, r3
+
 	/* SCTLR */
 	mrc	p15, 0, r2, c1, c0, 0
 	orr	r2, #CR_C
diff --git a/arm/cstart64.S b/arm/cstart64.S
index b9784d82..d8200ea2 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -53,6 +53,7 @@ start:
 	add     x5, x5, :lo12:reloc_start
 	adrp	x6, reloc_end
 	add     x6, x6, :lo12:reloc_end
+
 1:
 	cmp	x5, x6
 	b.hs	1f
@@ -60,22 +61,44 @@ start:
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
@@ -149,7 +172,12 @@ secondary_entry:
 	ldr	x0, [x0, :lo12:secondary_data]
 	and	x1, x0, #THREAD_MASK
 	add	x2, x1, #THREAD_SIZE
+	mov	x9, x1
+	dmb	sy
+	dcache_by_line_op ivac, sy, x1, x2, x3, x4
+	mov	x1, x9
 	zero_range x1, x2
+	/* asm_mmu_enable will perform the rest of the cache maintenance. */
 	mov	sp, x0
 
 	/* Enable FP/ASIMD */
@@ -242,6 +270,12 @@ asm_mmu_enable:
 	msr	ttbr0_el1, x0
 	isb
 
+	dmb	sy
+	mov	x9, sp
+	and	x9, x9, #THREAD_MASK
+	add	x10, x9, #THREAD_SIZE
+	dcache_by_line_op ivac, sy, x9, x10, x11, x12
+
 	/* SCTLR */
 	mrs	x1, sctlr_el1
 	orr	x1, x1, SCTLR_EL1_C
diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
index 8eb4a883..0a46bda0 100644
--- a/lib/arm/asm/page.h
+++ b/lib/arm/asm/page.h
@@ -8,6 +8,8 @@
 
 #include <linux/const.h>
 
+#include <libcflat.h>
+
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 49c74e19..4c565737 100644
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
@@ -74,7 +78,9 @@ static inline pmd_t *pgd_page_vaddr(pgd_t pgd)
 static inline pmd_t *pmd_alloc_one_early(void)
 {
 	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	memset(pmd, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	return pmd;
 }
 static inline pmd_t *pmd_alloc_one(void)
@@ -89,6 +95,8 @@ static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
 		pgd_t entry;
 		pgd_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pgd, entry);
+		if (!page_alloc_initialized())
+			dcache_clean_inval_addr_poc((unsigned long)pgd);
 	}
 	return pmd_offset(pgd, addr);
 }
@@ -107,7 +115,9 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 static inline pte_t *pte_alloc_one_early(void)
 {
 	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	memset(pte, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	return pte;
 }
 static inline pte_t *pte_alloc_one(void)
@@ -122,6 +132,8 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 		pmd_t entry;
 		pmd_val(entry) = pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pmd, entry);
+		if (!page_alloc_initialized())
+			dcache_clean_inval_addr_poc((unsigned long)pmd);
 
 	}
 	return pte_offset(pmd, addr);
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 0aec0bf9..c280c361 100644
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
 
@@ -236,6 +238,8 @@ void mmu_setup_early(phys_addr_t phys_end)
 
 	ioremap((phys_addr_t)(unsigned long)uart_early_base(), PAGE_SIZE);
 
+	phys_alloc_perform_cache_maintenance(dcache_clean_inval_addr_poc);
+
 	/*
 	 * Open-code part of mmu_enabled(), because at this point thread_info
 	 * hasn't been initialized. mmu_mark_enabled() cannot be called here
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 4b9423e5..71106682 100644
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
@@ -197,6 +198,7 @@ static void mem_init(phys_addr_t freemem_start)
 	struct mem_region *freemem, *r, mem = {
 		.start = (phys_addr_t)-1,
 	};
+	int nr_regions = 0;
 
 	freemem = mem_region_find(freemem_start);
 	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
@@ -208,6 +210,7 @@ static void mem_init(phys_addr_t freemem_start)
 			if (r->end > mem.end)
 				mem.end = r->end;
 		}
+		nr_regions++;
 	}
 	assert(mem.end && !(mem.start & ~PHYS_MASK));
 	mem.end &= PHYS_MASK;
@@ -221,6 +224,9 @@ static void mem_init(phys_addr_t freemem_start)
 	/* Ensure our selected freemem range is somewhere in our full range */
 	assert(freemem_start >= mem.start && freemem->end <= mem.end);
 
+	dcache_inval_poc((unsigned long)mem_regions,
+			 (unsigned long)(mem_regions + nr_regions));
+
 	__phys_offset = mem.start;	/* PHYS_OFFSET */
 	__phys_end = mem.end;		/* PHYS_END */
 
@@ -240,32 +246,69 @@ static void mem_init(phys_addr_t freemem_start)
 	page_alloc_ops_enable();
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
+		/* Invalidate the potentially stale value for the variable. */
+		dcache_clean_inval_addr_poc((unsigned long)&initrd);
+		/*
+		 * Invalidate potentially dirty cache lines for where the initrd
+		 * will be moved.
+		 */
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
+	/* Invalidate potentially stale cache lines for the fdt and initrd. */
+	dcache_inval_poc(freemem_start, (unsigned long)freemem);
 
 	mem_regions_add_dt_regions();
 	mem_regions_add_assumed();
@@ -335,6 +378,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
 	const void *fdt = efi_bootinfo->fdt;
 	int fdt_size, ret;
+	int nr_regions = 0;
 
 	/*
 	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
@@ -398,7 +442,16 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 				__phys_end = r.end;
 		}
 		mem_region_add(&r);
+		nr_regions++;
 	}
+
+	/*
+	 * The mem_regions will be used after mmu_disable and before mmu_enable
+	 * again, so clean the dcache to poc.
+	 */
+	dcache_clean_poc((unsigned long)mem_regions,
+			 (unsigned long)(mem_regions + nr_regions));
+
 	if (fdt) {
 		/* Move the FDT to the base of free memory */
 		fdt_size = fdt_totalsize(fdt);
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index cc6a1bb5..6f59d65a 100644
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
@@ -84,7 +88,9 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 static inline pmd_t *pmd_alloc_one_early(void)
 {
 	pmd_t *pmd = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	memset(pmd, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pmd);
 	return pmd;
 }
 static inline pmd_t *pmd_alloc_one(void)
@@ -99,6 +105,8 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
 		pud_t entry;
 		pud_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pud, entry);
+		if (!page_alloc_initialized())
+			dcache_clean_inval_addr_poc((unsigned long)pud);
 	}
 	return pmd_offset(pud, addr);
 }
@@ -117,7 +125,9 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
 static inline pud_t *pud_alloc_one_early(void)
 {
 	pud_t *pud = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pud);
 	memset(pud, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pud);
 	return pud;
 }
 static inline pud_t *pud_alloc_one(void)
@@ -132,6 +142,8 @@ static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
 		pgd_t entry;
 		pgd_val(entry) = pgtable_pa(pud_alloc_one()) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pgd, entry);
+		if (!page_alloc_initialized())
+			dcache_clean_inval_addr_poc((unsigned long)pgd);
 	}
 	return pud_offset(pgd, addr);
 }
@@ -150,7 +162,9 @@ static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
 static inline pte_t *pte_alloc_one_early(void)
 {
 	pte_t *pte = memalign(PAGE_SIZE, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	memset(pte, 0, PAGE_SIZE);
+	dcache_inval_page_poc((unsigned long)pte);
 	return pte;
 }
 static inline pte_t *pte_alloc_one(void)
@@ -165,6 +179,8 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 		pmd_t entry;
 		pmd_val(entry) = pgtable_pa(pte_alloc_one()) | PMD_TYPE_TABLE;
 		WRITE_ONCE(*pmd, entry);
+		if (!page_alloc_initialized())
+			dcache_clean_inval_addr_poc((unsigned long)pmd);
 	}
 	return pte_offset(pmd, addr);
 }
diff --git a/lib/devicetree.c b/lib/devicetree.c
index 3ff9d164..1cc44cf1 100644
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
2.40.1


