Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD0D3574B2
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348702AbhDGS7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 14:59:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355483AbhDGS7x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 14:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAm/uw1k66ViU/4zNLQwWF6DnNl4wT3Jgnl43W4WIGU=;
        b=YajUGKTUXn0j+ZQsXXPk6IalJjGFQYys5EUwTWXdZJEmisFVaBMniS+W7bXyJkrRnEy0ba
        qzkkCQQ/fhcX6OHyyZhUnIeL0eTiN20mVeSOhIeXd1zc2safe/XMSOOD/yq/dbEX81p6Km
        ZvboE1CID9on7IiUWsbjgM1Ou34Yvyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-nQLN0p3cNb-vJvyV3MIL2Q-1; Wed, 07 Apr 2021 14:59:41 -0400
X-MC-Unique: nQLN0p3cNb-vJvyV3MIL2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0055991280;
        Wed,  7 Apr 2021 18:59:40 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 196816A038;
        Wed,  7 Apr 2021 18:59:36 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 4/8] arm/arm64: mmu: Stop mapping an assumed IO region
Date:   Wed,  7 Apr 2021 20:59:14 +0200
Message-Id: <20210407185918.371983-5-drjones@redhat.com>
In-Reply-To: <20210407185918.371983-1-drjones@redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By providing a proper ioremap function, we can just rely on devices
calling it for each region they need (as they already do) instead of
mapping a big assumed I/O range. The persistent maps weirdness allows
us to call setup_vm after io_init. Why don't we just call setup_vm
before io_init, I hear you ask? Well, that's because tests like sieve
want to start with the MMU off and later call setup_vm, and all the
while have working I/O. Some unit tests are just really demanding...

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/io.h      |  6 ++++
 lib/arm/asm/mmu-api.h |  1 +
 lib/arm/asm/mmu.h     |  1 +
 lib/arm/asm/page.h    |  2 ++
 lib/arm/mmu.c         | 82 ++++++++++++++++++++++++++++++++++++++-----
 lib/arm64/asm/io.h    |  6 ++++
 lib/arm64/asm/mmu.h   |  1 +
 lib/arm64/asm/page.h  |  2 ++
 8 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/lib/arm/asm/io.h b/lib/arm/asm/io.h
index ba3b0b2412ad..e4caa6ff5d1e 100644
--- a/lib/arm/asm/io.h
+++ b/lib/arm/asm/io.h
@@ -77,6 +77,12 @@ static inline void __raw_writel(u32 val, volatile void __iomem *addr)
 		     : "r" (val));
 }
 
+#define ioremap ioremap
+static inline void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
+{
+	return __ioremap(phys_addr, size);
+}
+
 #define virt_to_phys virt_to_phys
 static inline phys_addr_t virt_to_phys(const volatile void *x)
 {
diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
index 05fc12b5afb8..b9a5a8f6b3c1 100644
--- a/lib/arm/asm/mmu-api.h
+++ b/lib/arm/asm/mmu-api.h
@@ -17,6 +17,7 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			       phys_addr_t phys_start, phys_addr_t phys_end,
 			       pgprot_t prot);
+extern void mmu_set_persistent_maps(pgd_t *pgtable);
 extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
 extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
 #endif
diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index 122874b8aebe..d88a4f16df42 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -12,6 +12,7 @@
 #define PTE_SHARED		L_PTE_SHARED
 #define PTE_AF			PTE_EXT_AF
 #define PTE_WBWA		L_PTE_MT_WRITEALLOC
+#define PTE_UNCACHED		L_PTE_MT_UNCACHED
 
 /* See B3.18.7 TLB maintenance operations */
 
diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
index 1fb5cd26ac66..8eb4a883808e 100644
--- a/lib/arm/asm/page.h
+++ b/lib/arm/asm/page.h
@@ -47,5 +47,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 extern phys_addr_t __virt_to_phys(unsigned long addr);
 extern unsigned long __phys_to_virt(phys_addr_t addr);
 
+extern void *__ioremap(phys_addr_t phys_addr, size_t size);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_PAGE_H_ */
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 15eef007f256..a7b7ae51afe3 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -11,6 +11,7 @@
 #include <asm/mmu.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/io.h>
 
 #include "alloc_page.h"
 #include "vmalloc.h"
@@ -21,6 +22,57 @@
 
 extern unsigned long etext;
 
+#define MMU_MAX_PERSISTENT_MAPS 64
+
+struct mmu_persistent_map {
+	uintptr_t virt_offset;
+	phys_addr_t phys_start;
+	phys_addr_t phys_end;
+	pgprot_t prot;
+	bool sect;
+};
+
+static struct mmu_persistent_map mmu_persistent_maps[MMU_MAX_PERSISTENT_MAPS];
+
+static void
+mmu_set_persistent_range(uintptr_t virt_offset, phys_addr_t phys_start,
+			 phys_addr_t phys_end, pgprot_t prot, bool sect)
+{
+	int i;
+
+	assert(phys_end);
+
+	for (i = 0; i < MMU_MAX_PERSISTENT_MAPS; ++i) {
+		if (!mmu_persistent_maps[i].phys_end)
+			break;
+	}
+	assert(i < MMU_MAX_PERSISTENT_MAPS);
+
+	mmu_persistent_maps[i] = (struct mmu_persistent_map){
+		.virt_offset = virt_offset,
+		.phys_start = phys_start,
+		.phys_end = phys_end,
+		.prot = prot,
+		.sect = sect,
+	};
+}
+
+void mmu_set_persistent_maps(pgd_t *pgtable)
+{
+	struct mmu_persistent_map *map;
+
+	for (map = &mmu_persistent_maps[0]; map->phys_end; ++map) {
+		if (map->sect)
+			mmu_set_range_sect(pgtable, map->virt_offset,
+					   map->phys_start, map->phys_end,
+					   map->prot);
+		else
+			mmu_set_range_ptes(pgtable, map->virt_offset,
+					   map->phys_start, map->phys_end,
+					   map->prot);
+	}
+}
+
 pgd_t *mmu_idmap;
 
 /* CPU 0 starts with disabled MMU */
@@ -157,7 +209,6 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 void *setup_mmu(phys_addr_t phys_end)
 {
 	uintptr_t code_end = (uintptr_t)&etext;
-	struct mem_region *r;
 
 	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
 	if (phys_end > (3ul << 30))
@@ -172,13 +223,6 @@ void *setup_mmu(phys_addr_t phys_end)
 
 	mmu_idmap = alloc_page();
 
-	for (r = mem_regions; r->end; ++r) {
-		if (!(r->flags & MR_F_IO))
-			continue;
-		mmu_set_range_sect(mmu_idmap, r->start, r->start, r->end,
-				   __pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-	}
-
 	/* armv8 requires code shared between EL1 and EL0 to be read-only */
 	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
 		PHYS_OFFSET, code_end,
@@ -188,10 +232,32 @@ void *setup_mmu(phys_addr_t phys_end)
 		code_end, phys_end,
 		__pgprot(PTE_WBWA | PTE_USER));
 
+	mmu_set_persistent_maps(mmu_idmap);
+
 	mmu_enable(mmu_idmap);
 	return mmu_idmap;
 }
 
+void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
+{
+	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
+	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
+	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER);
+
+	assert(sizeof(long) == 8 || !(phys_addr >> 32));
+
+	mmu_set_persistent_range(paddr_aligned, paddr_aligned, paddr_end,
+				 prot, false);
+
+	if (mmu_enabled()) {
+		pgd_t *pgtable = current_thread_info()->pgtable;
+		mmu_set_range_ptes(pgtable, paddr_aligned, paddr_aligned,
+				   paddr_end, prot);
+	}
+
+	return (void __iomem *)(unsigned long)phys_addr;
+}
+
 phys_addr_t __virt_to_phys(unsigned long addr)
 {
 	if (mmu_enabled()) {
diff --git a/lib/arm64/asm/io.h b/lib/arm64/asm/io.h
index e0a03b250d5b..be19f471c0fa 100644
--- a/lib/arm64/asm/io.h
+++ b/lib/arm64/asm/io.h
@@ -71,6 +71,12 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 	return val;
 }
 
+#define ioremap ioremap
+static inline void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
+{
+	return __ioremap(phys_addr, size);
+}
+
 #define virt_to_phys virt_to_phys
 static inline phys_addr_t virt_to_phys(const volatile void *x)
 {
diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 72d75eafc882..72371b2d9fe3 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -8,6 +8,7 @@
 #include <asm/barrier.h>
 
 #define PMD_SECT_UNCACHED	PMD_ATTRINDX(MT_DEVICE_nGnRE)
+#define PTE_UNCACHED		PTE_ATTRINDX(MT_DEVICE_nGnRE)
 #define PTE_WBWA		PTE_ATTRINDX(MT_NORMAL)
 
 static inline void flush_tlb_all(void)
diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
index ae4484b22114..d0fac6ea563d 100644
--- a/lib/arm64/asm/page.h
+++ b/lib/arm64/asm/page.h
@@ -72,5 +72,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 extern phys_addr_t __virt_to_phys(unsigned long addr);
 extern unsigned long __phys_to_virt(phys_addr_t addr);
 
+extern void *__ioremap(phys_addr_t phys_addr, size_t size);
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PAGE_H_ */
-- 
2.26.3

