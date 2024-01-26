Return-Path: <kvm+bounces-7164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6814383DBC1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:25:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6DCB1F24A70
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF2A1D535;
	Fri, 26 Jan 2024 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sb5undMf"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FD71CFA8
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279062; cv=none; b=pgdibgL6sJjlHQ4ZALPSfJu2gG9jBa5+6NH1KZ2Pb/o5Mp3svPOvShWrvDrU3RCZ4Fq617ZmniyoZxhOGCz5DK0oK20yQNxQbAPQfABDSiHrEYt2oZJS+fdtC5OKLEbCjH/dJRMay0RQVE8Sz2qM3GtwpidTfV+O5HAYSlbw1kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279062; c=relaxed/simple;
	bh=zvqXIhaN4O3KzlFACSQZAPaFC4SJMwLmBU1qhjQvdAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=OQ8jxazbYu7N7YAKAbzMJKvp1zqItxELJUe8YCFrDlXwZohbwyurkDGa8MSSyAWHzl3lkvRRg3en6T262aC0gPuTAqCloqsiKD2qsJnObDx8ypSNwq3RVSJECryCQyn3uno6vJSDvRK67CclFZSS0fq6K//rHf4+ZO730qCsgaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sb5undMf; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hngb6HbaAZIHLva2X8ovDw9OURKG7F1oxRSEccU4GBg=;
	b=Sb5undMfk0ns/CzA3Lq/japZzEqWFQfU0rqLWQ/p1wy+/GL0bX2527uPiL/BbJPQDFJofm
	BG2kHRwyqjkGkcESK0vgRP8iLWRr3+o/TQ/N15K420ffjtxIjIEFICuOX8W0J6KrYc7qSp
	cAbdWn7RlmEC24QuMHoTtDL4sj30DBU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 18/24] riscv: Add MMU support
Date: Fri, 26 Jan 2024 15:23:43 +0100
Message-ID: <20240126142324.66674-44-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add minimal page table defines and functions in order to build page
tables and enable the MMU.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm/csr.h     |   1 +
 lib/riscv/asm/io.h      |   3 +
 lib/riscv/asm/mmu.h     |  34 +++++++++
 lib/riscv/asm/page.h    |  14 ++++
 lib/riscv/asm/pgtable.h |  42 +++++++++++
 lib/riscv/mmu.c         | 150 ++++++++++++++++++++++++++++++++++++++++
 lib/riscv/setup.c       |   3 +
 riscv/Makefile          |   1 +
 8 files changed, 248 insertions(+)
 create mode 100644 lib/riscv/asm/mmu.h
 create mode 100644 lib/riscv/asm/pgtable.h
 create mode 100644 lib/riscv/mmu.c

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index 39ffd2a146be..52608512b68d 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -9,6 +9,7 @@
 #define CSR_SEPC		0x141
 #define CSR_SCAUSE		0x142
 #define CSR_STVAL		0x143
+#define CSR_SATP		0x180
 
 /* Exception cause high bit - is an interrupt if set */
 #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
diff --git a/lib/riscv/asm/io.h b/lib/riscv/asm/io.h
index d2eb3acc9fda..6fe111289102 100644
--- a/lib/riscv/asm/io.h
+++ b/lib/riscv/asm/io.h
@@ -73,6 +73,9 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 }
 #endif
 
+#define ioremap ioremap
+void __iomem *ioremap(phys_addr_t phys_addr, size_t size);
+
 #include <asm-generic/io.h>
 
 #endif /* _ASMRISCV_IO_H_ */
diff --git a/lib/riscv/asm/mmu.h b/lib/riscv/asm/mmu.h
new file mode 100644
index 000000000000..18d39e75ba30
--- /dev/null
+++ b/lib/riscv/asm/mmu.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_MMU_H_
+#define _ASMRISCV_MMU_H_
+#include <libcflat.h>
+#include <asm/csr.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+static inline pgd_t *current_pgtable(void)
+{
+	return (pgd_t *)((csr_read(CSR_SATP) & SATP_PPN) << PAGE_SHIFT);
+}
+
+void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
+			phys_addr_t phys_start, phys_addr_t phys_end,
+			pgprot_t prot, bool flush);
+void __mmu_enable(unsigned long satp);
+void mmu_enable(unsigned long mode, pgd_t *pgtable);
+void mmu_disable(void);
+
+void setup_mmu(void);
+
+static inline void local_flush_tlb_page(unsigned long addr)
+{
+	asm volatile("sfence.vma %0" : : "r" (addr) : "memory");
+}
+
+/*
+ * Get the pte pointer for a virtual address, even if it's not mapped.
+ * Constructs upper levels of the table as necessary.
+ */
+pte_t *get_pte(pgd_t *pgtable, uintptr_t vaddr);
+
+#endif /* _ASMRISCV_MMU_H_ */
diff --git a/lib/riscv/asm/page.h b/lib/riscv/asm/page.h
index 7d7c9191605a..07b482f76176 100644
--- a/lib/riscv/asm/page.h
+++ b/lib/riscv/asm/page.h
@@ -2,6 +2,20 @@
 #ifndef _ASMRISCV_PAGE_H_
 #define _ASMRISCV_PAGE_H_
 
+#ifndef __ASSEMBLY__
+
+typedef unsigned long pgd_t;
+typedef unsigned long pte_t;
+typedef unsigned long pgprot_t;
+typedef unsigned long pteval_t;
+
+#define pte_val(x)		((pteval_t)(x))
+#define pgprot_val(x)		((pteval_t)(x))
+#define __pte(x)		((pte_t)(x))
+#define __pgprot(x)		((pgprot_t)(x))
+
+#endif /* !__ASSEMBLY__ */
+
 #include <asm-generic/page.h>
 
 #endif /* _ASMRISCV_PAGE_H_ */
diff --git a/lib/riscv/asm/pgtable.h b/lib/riscv/asm/pgtable.h
new file mode 100644
index 000000000000..98d41ff9f661
--- /dev/null
+++ b/lib/riscv/asm/pgtable.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_PGTABLE_H_
+#define _ASMRISCV_PGTABLE_H_
+#include <linux/const.h>
+
+#if __riscv_xlen == 32
+#define SATP_PPN		_AC(0x003FFFFF, UL)
+#define SATP_MODE_32		_AC(0x80000000, UL)
+#define SATP_MODE_SHIFT		31
+#define NR_LEVELS		2
+#define PGDIR_BITS		10
+#define PGDIR_MASK		_AC(0x3FF, UL)
+#define PTE_PPN			_AC(0xFFFFFC00, UL)
+
+#define SATP_MODE_DEFAULT	SATP_MODE_32
+
+#else
+#define SATP_PPN		_AC(0x00000FFFFFFFFFFF, UL)
+#define SATP_MODE_39		_AC(0x8000000000000000, UL)
+#define SATP_MODE_SHIFT		60
+#define NR_LEVELS		3
+#define PGDIR_BITS		9
+#define PGDIR_MASK		_AC(0x1FF, UL)
+#define PTE_PPN			_AC(0x3FFFFFFFFFFC00, UL)
+
+#define SATP_MODE_DEFAULT	SATP_MODE_39
+
+#endif
+
+#define PPN_SHIFT		10
+
+#define _PAGE_PRESENT		(1 << 0)
+#define _PAGE_READ		(1 << 1)
+#define _PAGE_WRITE		(1 << 2)
+#define _PAGE_EXEC		(1 << 3)
+#define _PAGE_USER		(1 << 4)
+#define _PAGE_GLOBAL		(1 << 5)
+#define _PAGE_ACCESSED		(1 << 6)
+#define _PAGE_DIRTY		(1 << 7)
+#define _PAGE_SOFT		(3 << 8)
+
+#endif /* _ASMRISCV_PGTABLE_H_ */
diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
new file mode 100644
index 000000000000..4d13a3034ccc
--- /dev/null
+++ b/lib/riscv/mmu.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
+ */
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <memregions.h>
+#include <asm/csr.h>
+#include <asm/io.h>
+#include <asm/mmu.h>
+#include <asm/page.h>
+
+static pgd_t *__initial_pgtable;
+
+static int pte_index(uintptr_t vaddr, int level)
+{
+	return (vaddr >> (PGDIR_BITS * level + PAGE_SHIFT)) & PGDIR_MASK;
+}
+
+static pte_t *pteval_to_ptep(pteval_t pteval)
+{
+	return (pte_t *)(((pteval & PTE_PPN) >> PPN_SHIFT) << PAGE_SHIFT);
+}
+
+static pteval_t ptep_to_pteval(pte_t *ptep)
+{
+	return ((pteval_t)ptep >> PAGE_SHIFT) << PPN_SHIFT;
+}
+
+pte_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
+{
+	pte_t *ptep = (pte_t *)pgtable;
+
+	assert(pgtable && !((uintptr_t)pgtable & ~PAGE_MASK));
+
+	for (int level = NR_LEVELS - 1; level > 0; --level) {
+		pte_t *next = &ptep[pte_index(vaddr, level)];
+		if (!pte_val(*next)) {
+			void *page = alloc_page();
+			*next = __pte(ptep_to_pteval(page) | _PAGE_PRESENT);
+		}
+		ptep = pteval_to_ptep(pte_val(*next));
+	}
+	ptep = &ptep[pte_index(vaddr, 0)];
+
+	return ptep;
+}
+
+static pteval_t *__install_page(pgd_t *pgtable, phys_addr_t paddr,
+				uintptr_t vaddr, pgprot_t prot, bool flush)
+{
+	phys_addr_t ppn = (paddr >> PAGE_SHIFT) << PPN_SHIFT;
+	pteval_t pte = (pteval_t)ppn;
+	pte_t *ptep;
+
+	assert(!(ppn & ~PTE_PPN));
+
+	ptep = get_pte(pgtable, vaddr);
+	*ptep = __pte(pte | pgprot_val(prot) | _PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_DIRTY);
+
+	if (flush)
+		local_flush_tlb_page(vaddr);
+
+	return (pteval_t *)ptep;
+}
+
+void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
+			phys_addr_t phys_start, phys_addr_t phys_end,
+			pgprot_t prot, bool flush)
+{
+	phys_addr_t paddr = phys_start & PAGE_MASK;
+	uintptr_t vaddr = virt_offset & PAGE_MASK;
+	uintptr_t virt_end = phys_end - paddr + vaddr;
+
+	assert(phys_start < phys_end);
+
+	for (; vaddr < virt_end; vaddr += PAGE_SIZE, paddr += PAGE_SIZE)
+		__install_page(pgtable, paddr, vaddr, prot, flush);
+}
+
+void mmu_disable(void)
+{
+	__asm__ __volatile__ (
+	"	csrw	" xstr(CSR_SATP) ", zero\n"
+	"	sfence.vma\n"
+	: : : "memory");
+}
+
+void __mmu_enable(unsigned long satp)
+{
+	__asm__ __volatile__ (
+	"	sfence.vma\n"
+	"	csrw	" xstr(CSR_SATP) ", %0\n"
+	: : "r" (satp) : "memory");
+}
+
+void mmu_enable(unsigned long mode, pgd_t *pgtable)
+{
+	unsigned long ppn = (unsigned long)pgtable >> PAGE_SHIFT;
+	unsigned long satp = mode | ppn;
+
+	assert(!(ppn & ~SATP_PPN));
+	__mmu_enable(satp);
+}
+
+void setup_mmu(void)
+{
+	struct mem_region *r;
+	pgd_t *pgtable;
+
+	if (!__initial_pgtable)
+		__initial_pgtable = alloc_page();
+	pgtable = __initial_pgtable;
+
+	for (r = mem_regions; r->end; ++r) {
+		if (r->flags & (MR_F_IO | MR_F_RESERVED))
+			continue;
+		if (r->flags & MR_F_CODE) {
+			mmu_set_range_ptes(pgtable, r->start, r->start, r->end,
+					   __pgprot(_PAGE_READ | _PAGE_EXEC), false);
+		} else {
+			mmu_set_range_ptes(pgtable, r->start, r->start, r->end,
+					   __pgprot(_PAGE_READ | _PAGE_WRITE), false);
+		}
+	}
+
+	mmu_enable(SATP_MODE_DEFAULT, pgtable);
+}
+
+void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
+{
+	phys_addr_t start = phys_addr & PAGE_MASK;
+	phys_addr_t end = PAGE_ALIGN(phys_addr + size);
+	pgd_t *pgtable = current_pgtable();
+	bool flush = true;
+
+	assert(sizeof(long) == 8 || !(phys_addr >> 32));
+
+	if (!pgtable) {
+		if (!__initial_pgtable)
+			__initial_pgtable = alloc_page();
+		pgtable = __initial_pgtable;
+		flush = false;
+	}
+
+	mmu_set_range_ptes(pgtable, start, start, end,
+			   __pgprot(_PAGE_READ | _PAGE_WRITE), flush);
+
+	return (void __iomem *)(unsigned long)phys_addr;
+}
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 848ec8e83496..c4c1bd58b337 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -14,6 +14,7 @@
 #include <memregions.h>
 #include <on-cpus.h>
 #include <asm/csr.h>
+#include <asm/mmu.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
@@ -171,5 +172,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 		setup_env(env, initrd_size);
 	}
 
+	setup_mmu();
+
 	banner();
 }
diff --git a/riscv/Makefile b/riscv/Makefile
index ed1a14025ed2..821891b719e7 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -29,6 +29,7 @@ cflatobjs += lib/memregions.o
 cflatobjs += lib/on-cpus.o
 cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
+cflatobjs += lib/riscv/mmu.o
 cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
 cflatobjs += lib/riscv/setup.o
-- 
2.43.0


