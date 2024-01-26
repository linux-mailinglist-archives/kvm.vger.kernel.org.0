Return-Path: <kvm+bounces-7166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 880F383DBC3
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11F8E1F22B2A
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EA11EA7F;
	Fri, 26 Jan 2024 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NuNN8Qny"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AFB1DFF9
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279066; cv=none; b=PVzoL0ZW2Jz3kKa5fgrNDhbh1HqaifWn3bsFLP5S1BcPMxy3+lIf+SExNdjvL7wFTaniAtlaPD8IRvxidlY0PKsNLBvSzf3uGwvNOb/VAN2LantdimA0Zo35j4xnHKE0v0yUEUwEqK8xdkwsIYK9/LHwPlXcmKrvx/UaPC35TGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279066; c=relaxed/simple;
	bh=h1abOWRPvGi+/NpWgCqz1l5RTlxyNcPwkzBYj9g0wOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=jzyex9SnWTTG4RsBjN4ZWeJwFG63kVsMTh+lzSuHAtIx45PNa0KOwahQe0S2biMqzFzTIm8uT6SXJUyMDLMIp6m86WQthTYRutb9MtPKv5zdYeIUqQsK+dY7+nYeO+D+AIRqHFrZg5RCB/VW9kTpYf41fzy5M4CvBgcmIcmkD80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NuNN8Qny; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U4AeEeFqRbeeigOvgdGnI3SSed50CshpA/F9+LkTR5A=;
	b=NuNN8QnyX+o/hoZMiaz9+SD39JF76wUUreVrN9JGcSr/Lk0DXBPa+YXCDCWm8W4jq5aPZe
	042r+UV+rPclYlGzegK9u6ueFNO1+J0PFUSziHc4kwCzyf3iLz4e02B3x5YgKD1F3q6sLI
	E5GMtAjfGVnOFgLLFI4Dk93Mw4EW2+s=
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
Subject: [kvm-unit-tests PATCH v2 20/24] riscv: Enable vmalloc
Date: Fri, 26 Jan 2024 15:23:45 +0100
Message-ID: <20240126142324.66674-46-andrew.jones@linux.dev>
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

Implement the functions that vmalloc depends on and let it enable the
MMU through setup_vm(). We can now also run the sieve test, so we
add it as well.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm/io.h  |  6 +++++
 lib/riscv/asm/mmu.h |  2 --
 lib/riscv/mmu.c     | 57 ++++++++++++++++++++++++++++++++++++++++++++-
 lib/riscv/setup.c   | 16 ++++++++++---
 riscv/Makefile      |  3 ++-
 riscv/sieve.c       |  1 +
 6 files changed, 78 insertions(+), 7 deletions(-)
 create mode 120000 riscv/sieve.c

diff --git a/lib/riscv/asm/io.h b/lib/riscv/asm/io.h
index 6fe111289102..37a130e533c9 100644
--- a/lib/riscv/asm/io.h
+++ b/lib/riscv/asm/io.h
@@ -76,6 +76,12 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define ioremap ioremap
 void __iomem *ioremap(phys_addr_t phys_addr, size_t size);
 
+#define virt_to_phys virt_to_phys
+unsigned long virt_to_phys(volatile void *address);
+
+#define phys_to_virt phys_to_virt
+void *phys_to_virt(unsigned long address);
+
 #include <asm-generic/io.h>
 
 #endif /* _ASMRISCV_IO_H_ */
diff --git a/lib/riscv/asm/mmu.h b/lib/riscv/asm/mmu.h
index 18d39e75ba30..bb60f0895e2b 100644
--- a/lib/riscv/asm/mmu.h
+++ b/lib/riscv/asm/mmu.h
@@ -18,8 +18,6 @@ void __mmu_enable(unsigned long satp);
 void mmu_enable(unsigned long mode, pgd_t *pgtable);
 void mmu_disable(void);
 
-void setup_mmu(void);
-
 static inline void local_flush_tlb_page(unsigned long addr)
 {
 	asm volatile("sfence.vma %0" : : "r" (addr) : "memory");
diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
index 4d13a3034ccc..bd006881a95f 100644
--- a/lib/riscv/mmu.c
+++ b/lib/riscv/mmu.c
@@ -5,6 +5,7 @@
 #include <libcflat.h>
 #include <alloc_page.h>
 #include <memregions.h>
+#include <vmalloc.h>
 #include <asm/csr.h>
 #include <asm/io.h>
 #include <asm/mmu.h>
@@ -64,6 +65,15 @@ static pteval_t *__install_page(pgd_t *pgtable, phys_addr_t paddr,
 	return (pteval_t *)ptep;
 }
 
+pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt)
+{
+	phys_addr_t paddr = phys & PAGE_MASK;
+	uintptr_t vaddr = (uintptr_t)virt & PAGE_MASK;
+
+	return __install_page(pgtable, paddr, vaddr,
+			      __pgprot(_PAGE_READ | _PAGE_WRITE), true);
+}
+
 void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			phys_addr_t phys_start, phys_addr_t phys_end,
 			pgprot_t prot, bool flush)
@@ -103,7 +113,7 @@ void mmu_enable(unsigned long mode, pgd_t *pgtable)
 	__mmu_enable(satp);
 }
 
-void setup_mmu(void)
+void *setup_mmu(phys_addr_t top, void *opaque)
 {
 	struct mem_region *r;
 	pgd_t *pgtable;
@@ -125,6 +135,8 @@ void setup_mmu(void)
 	}
 
 	mmu_enable(SATP_MODE_DEFAULT, pgtable);
+
+	return pgtable;
 }
 
 void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
@@ -148,3 +160,46 @@ void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
 
 	return (void __iomem *)(unsigned long)phys_addr;
 }
+
+phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt)
+{
+	uintptr_t vaddr = (uintptr_t)virt;
+	pte_t *ptep = (pte_t *)pgtable;
+
+	assert(pgtable && !((uintptr_t)pgtable & ~PAGE_MASK));
+
+	for (int level = NR_LEVELS - 1; level > 0; --level) {
+		pte_t *next = &ptep[pte_index(vaddr, level)];
+		if (!pte_val(*next))
+			return 0;
+		ptep = pteval_to_ptep(pte_val(*next));
+	}
+	ptep = &ptep[pte_index(vaddr, 0)];
+
+	if (!pte_val(*ptep))
+		return 0;
+
+	return __pa(pteval_to_ptep(pte_val(*ptep)));
+}
+
+unsigned long virt_to_phys(volatile void *address)
+{
+	unsigned long satp = csr_read(CSR_SATP);
+	pgd_t *pgtable = (pgd_t *)((satp & SATP_PPN) << PAGE_SHIFT);
+	phys_addr_t paddr;
+
+	if ((satp >> SATP_MODE_SHIFT) == 0)
+		return __pa(address);
+
+	paddr = virt_to_pte_phys(pgtable, (void *)address);
+	assert(sizeof(long) == 8 || !(paddr >> 32));
+
+	return (unsigned long)paddr;
+}
+
+void *phys_to_virt(unsigned long address)
+{
+	/* @address must have an identity mapping for this to work. */
+	assert(virt_to_phys(__va(address)) == address);
+	return __va(address);
+}
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index c4c1bd58b337..40ff26a24cfc 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -9,10 +9,12 @@
 #include <alloc_page.h>
 #include <alloc_phys.h>
 #include <argv.h>
+#include <auxinfo.h>
 #include <cpumask.h>
 #include <devicetree.h>
 #include <memregions.h>
 #include <on-cpus.h>
+#include <vmalloc.h>
 #include <asm/csr.h>
 #include <asm/mmu.h>
 #include <asm/page.h>
@@ -20,6 +22,11 @@
 #include <asm/setup.h>
 
 #define VA_BASE			((phys_addr_t)3 * SZ_1G)
+#if __riscv_xlen == 64
+#define VA_TOP			((phys_addr_t)4 * SZ_1G)
+#else
+#define VA_TOP			((phys_addr_t)0)
+#endif
 
 #define MAX_DT_MEM_REGIONS	16
 #define NR_MEM_REGIONS		(MAX_DT_MEM_REGIONS + 16)
@@ -106,6 +113,8 @@ static void mem_init(phys_addr_t freemem_start)
 		freemem_end = VA_BASE;
 	assert(freemem_end - freemem_start >= SZ_1M * 16);
 
+	init_alloc_vpage(__va(VA_TOP));
+
 	/*
 	 * TODO: Remove the need for this phys allocator dance, since, as we
 	 * can see with the assert, we could have gone straight to the page
@@ -137,7 +146,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	int ret;
 
 	assert(sizeof(long) == 8 || freemem_start < VA_BASE);
-	freemem = (void *)(unsigned long)freemem_start;
+	freemem = __va(freemem_start);
 
 	/* Move the FDT to the base of free memory */
 	fdt_size = fdt_totalsize(fdt);
@@ -156,7 +165,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 		freemem += initrd_size;
 	}
 
-	mem_init(PAGE_ALIGN((unsigned long)freemem));
+	mem_init(PAGE_ALIGN(__pa(freemem)));
 	cpu_init();
 	thread_info_init();
 	io_init();
@@ -172,7 +181,8 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 		setup_env(env, initrd_size);
 	}
 
-	setup_mmu();
+	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
+		setup_vm();
 
 	banner();
 }
diff --git a/riscv/Makefile b/riscv/Makefile
index 821891b719e7..61a1ff88d8ec 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -13,7 +13,7 @@ endif
 tests =
 tests += $(TEST_DIR)/sbi.$(exe)
 tests += $(TEST_DIR)/selftest.$(exe)
-#tests += $(TEST_DIR)/sieve.$(exe)
+tests += $(TEST_DIR)/sieve.$(exe)
 
 all: $(tests)
 
@@ -27,6 +27,7 @@ cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/devicetree.o
 cflatobjs += lib/memregions.o
 cflatobjs += lib/on-cpus.o
+cflatobjs += lib/vmalloc.o
 cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
 cflatobjs += lib/riscv/mmu.o
diff --git a/riscv/sieve.c b/riscv/sieve.c
new file mode 120000
index 000000000000..8f14a5c3d4aa
--- /dev/null
+++ b/riscv/sieve.c
@@ -0,0 +1 @@
+../x86/sieve.c
\ No newline at end of file
-- 
2.43.0


