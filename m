Return-Path: <kvm+bounces-23848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBC694EE98
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B6AE1F222A7
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0236B183CBD;
	Mon, 12 Aug 2024 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w5xypioI"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B443417C9F9
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470307; cv=none; b=hvgDS5LRQhyT7ttJ7O3BbNPndi81zK17Re7isMclkzCWM4+Le2Xp5jXPjJpU38jtEPb8mNTS1baQsbW5S2NyDeQx1ilk/ESrer8TKROf8ZufPJz+k26ISawafIxMK8Gi6BV/Bt47E5rciROykFd7IcwH0T2UTjC9KUhSQuQiy5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470307; c=relaxed/simple;
	bh=hBG+w/LYTgXd9YEzAs4Wyf0d+E9bmdZL/SThjlO3Ofo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNUyeIbbJ/AyCi0peHvMgJPXkWf523SKCDP3KOd3WJ6HbpL1k5Hje65Y5Ja0eklBbkUdi6q0ODLGrckmgLR3rTMPG8Z+v3nHuhUj+WUF09p0PAHq0XY6SiSsS1QwNylyWFdiL5SvCzpGO8MAxrB6yIdW/J2MOicnf7LYR+nY7yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w5xypioI; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DuBDu2KUddhgkqZOSU6QLhFG2U5c0inzQs/uShG3O8A=;
	b=w5xypioI3FytLjkOanZ9Nl4x3LiXx4OOyGdEcco1jKcsDQ247PQndGSV3HcbpsbeyNUZvG
	wb/NumGWRxWgzAJEHqNyTP8mS+/e1N9kp+7Ou8a2zzvSFiIf9VerRLy34NWBGvA9WLlFHl
	7Cod2CtfzNVli9NZU9P4057LYJLyQ4A=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 3/7] riscv: Support up to 34-bit physical addresses on rv32, sort of
Date: Mon, 12 Aug 2024 15:44:55 +0200
Message-ID: <20240812134451.112498-12-andrew.jones@linux.dev>
In-Reply-To: <20240812134451.112498-9-andrew.jones@linux.dev>
References: <20240812134451.112498-9-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Change virt_to_phys() and phys_to_virt() to use phys_addr_t instead
of unsigned long. This allows 32-bit builds to use physical addresses
over 32 bits wide (the spec allows up to 34 bits). But, to keep
things simple, we don't expect physical addresses wider than 32 bits
in most the library code (and that's ensured by sprinkling around
some asserts). IOW, the support is really only for unit tests which
want to test with an additional high memory region.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/io.h |  4 ++--
 lib/riscv/mmu.c    | 32 ++++++++++++++++++++------------
 lib/riscv/smp.c    |  7 ++++++-
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/lib/riscv/asm/io.h b/lib/riscv/asm/io.h
index 37a130e533c9..a48a9aa654dd 100644
--- a/lib/riscv/asm/io.h
+++ b/lib/riscv/asm/io.h
@@ -77,10 +77,10 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 void __iomem *ioremap(phys_addr_t phys_addr, size_t size);
 
 #define virt_to_phys virt_to_phys
-unsigned long virt_to_phys(volatile void *address);
+phys_addr_t virt_to_phys(volatile void *address);
 
 #define phys_to_virt phys_to_virt
-void *phys_to_virt(unsigned long address);
+void *phys_to_virt(phys_addr_t address);
 
 #include <asm-generic/io.h>
 
diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
index 2c9c4f376ac9..6ab1f15a99ae 100644
--- a/lib/riscv/mmu.c
+++ b/lib/riscv/mmu.c
@@ -18,9 +18,16 @@ static int pte_index(uintptr_t vaddr, int level)
 	return (vaddr >> (PGDIR_BITS * level + PAGE_SHIFT)) & PGDIR_MASK;
 }
 
+static phys_addr_t pteval_to_phys_addr(pteval_t pteval)
+{
+	return (phys_addr_t)((pteval & PTE_PPN) >> PPN_SHIFT) << PAGE_SHIFT;
+}
+
 static pte_t *pteval_to_ptep(pteval_t pteval)
 {
-	return (pte_t *)(((pteval & PTE_PPN) >> PPN_SHIFT) << PAGE_SHIFT);
+	phys_addr_t paddr = pteval_to_phys_addr(pteval);
+	assert(paddr == __pa(paddr));
+	return (pte_t *)__pa(paddr);
 }
 
 static pteval_t ptep_to_pteval(pte_t *ptep)
@@ -106,7 +113,7 @@ void __mmu_enable(unsigned long satp)
 
 void mmu_enable(unsigned long mode, pgd_t *pgtable)
 {
-	unsigned long ppn = (unsigned long)pgtable >> PAGE_SHIFT;
+	unsigned long ppn = __pa(pgtable) >> PAGE_SHIFT;
 	unsigned long satp = mode | ppn;
 
 	assert(!(ppn & ~SATP_PPN));
@@ -118,6 +125,9 @@ void *setup_mmu(phys_addr_t top, void *opaque)
 	struct mem_region *r;
 	pgd_t *pgtable;
 
+	/* The initial page table uses an identity mapping. */
+	assert(top == __pa(top));
+
 	if (!__initial_pgtable)
 		__initial_pgtable = alloc_page();
 	pgtable = __initial_pgtable;
@@ -146,7 +156,8 @@ void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
 	pgd_t *pgtable = current_pgtable();
 	bool flush = true;
 
-	assert(sizeof(long) == 8 || !(phys_addr >> 32));
+	/* I/O is always identity mapped. */
+	assert(end == __pa(end));
 
 	if (!pgtable) {
 		if (!__initial_pgtable)
@@ -158,7 +169,7 @@ void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
 	mmu_set_range_ptes(pgtable, start, start, end,
 			   __pgprot(_PAGE_READ | _PAGE_WRITE), flush);
 
-	return (void __iomem *)(unsigned long)phys_addr;
+	return (void __iomem *)__pa(phys_addr);
 }
 
 phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
@@ -179,27 +190,24 @@ phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
 	if (!pte_val(*ptep))
 		return 0;
 
-	return __pa(pteval_to_ptep(pte_val(*ptep))) | offset_in_page(virt);
+	return pteval_to_phys_addr(pte_val(*ptep)) | offset_in_page(virt);
 }
 
-unsigned long virt_to_phys(volatile void *address)
+phys_addr_t virt_to_phys(volatile void *address)
 {
 	unsigned long satp = csr_read(CSR_SATP);
 	pgd_t *pgtable = (pgd_t *)((satp & SATP_PPN) << PAGE_SHIFT);
-	phys_addr_t paddr;
 
 	if ((satp >> SATP_MODE_SHIFT) == 0)
 		return __pa(address);
 
-	paddr = virt_to_pte_phys(pgtable, (void *)address);
-	assert(sizeof(long) == 8 || !(paddr >> 32));
-
-	return (unsigned long)paddr;
+	return virt_to_pte_phys(pgtable, (void *)address);
 }
 
-void *phys_to_virt(unsigned long address)
+void *phys_to_virt(phys_addr_t address)
 {
 	/* @address must have an identity mapping for this to work. */
+	assert(address == __pa(address));
 	assert(virt_to_phys(__va(address)) == address);
 	return __va(address);
 }
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
index 7e4bb5b76903..4d373e0a29a8 100644
--- a/lib/riscv/smp.c
+++ b/lib/riscv/smp.c
@@ -8,6 +8,7 @@
 #include <alloc_page.h>
 #include <cpumask.h>
 #include <asm/csr.h>
+#include <asm/io.h>
 #include <asm/mmu.h>
 #include <asm/page.h>
 #include <asm/processor.h>
@@ -36,6 +37,7 @@ secondary_func_t secondary_cinit(struct secondary_data *data)
 static void __smp_boot_secondary(int cpu, secondary_func_t func)
 {
 	struct secondary_data *sp = alloc_pages(1) + SZ_8K - 16;
+	phys_addr_t sp_phys;
 	struct sbiret ret;
 
 	sp -= sizeof(struct secondary_data);
@@ -43,7 +45,10 @@ static void __smp_boot_secondary(int cpu, secondary_func_t func)
 	sp->stvec = csr_read(CSR_STVEC);
 	sp->func = func;
 
-	ret = sbi_hart_start(cpus[cpu].hartid, (unsigned long)&secondary_entry, __pa(sp));
+	sp_phys = virt_to_phys(sp);
+	assert(sp_phys == __pa(sp_phys));
+
+	ret = sbi_hart_start(cpus[cpu].hartid, (unsigned long)&secondary_entry, __pa(sp_phys));
 	assert(ret.error == SBI_SUCCESS);
 }
 
-- 
2.45.2


