Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719C6365FF2
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 21:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhDTTB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 15:01:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233694AbhDTTB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 15:01:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618945255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FVp3LZvtExU15+eednp7IXZjLKDIdz9wHZ1dMG7ZCWU=;
        b=JdvP3EVRXVVDWzXyfWt1uF/hoHVR2E0J8Py3yayfAQTgAFgh3MWQ8uzScii7p6hg/y8Qwv
        zm+QtvyMbDbvd1t7ChoykkQd2UanovB7pK+4DceuXPzK+vBflHldpQNOptp/izyUES7CNr
        jmWHlWbn7OxiHIDIDNuR53b9cYg7MpQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-CRnE6TzUMxiYJJMvi3xJMA-1; Tue, 20 Apr 2021 15:00:52 -0400
X-MC-Unique: CRnE6TzUMxiYJJMvi3xJMA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A48A343B1;
        Tue, 20 Apr 2021 19:00:51 +0000 (UTC)
Received: from gator.home (unknown [10.40.195.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A98FC19D9B;
        Tue, 20 Apr 2021 19:00:37 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests v2 4/8] arm/arm64: mmu: Stop mapping an assumed IO region
Date:   Tue, 20 Apr 2021 20:59:58 +0200
Message-Id: <20210420190002.383444-5-drjones@redhat.com>
In-Reply-To: <20210420190002.383444-1-drjones@redhat.com>
References: <20210420190002.383444-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By providing a proper ioremap function, we can just rely on devices
calling it for each region they need (as they already do) instead of
mapping a big assumed I/O range. We don't require the MMU to be
enabled at the time of the ioremap. In that case, we add the mapping
to the identity map anyway. This allows us to call setup_vm after
io_init. Why don't we just call setup_vm before io_init, I hear you
ask? Well, that's because tests like sieve want to start with the MMU
off, later call setup_vm, and all the while have working I/O. Some
unit tests are just really demanding...

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/io.h     |  6 ++++++
 lib/arm/asm/mmu.h    |  1 +
 lib/arm/asm/page.h   |  2 ++
 lib/arm/mmu.c        | 37 +++++++++++++++++++++++++++----------
 lib/arm64/asm/io.h   |  6 ++++++
 lib/arm64/asm/mmu.h  |  1 +
 lib/arm64/asm/page.h |  2 ++
 7 files changed, 45 insertions(+), 10 deletions(-)

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
index 15eef007f256..ee0c79142ba1 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -11,6 +11,7 @@
 #include <asm/mmu.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/io.h>
 
 #include "alloc_page.h"
 #include "vmalloc.h"
@@ -157,9 +158,8 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 void *setup_mmu(phys_addr_t phys_end)
 {
 	uintptr_t code_end = (uintptr_t)&etext;
-	struct mem_region *r;
 
-	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
+	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
 	if (phys_end > (3ul << 30))
 		phys_end = 3ul << 30;
 
@@ -170,14 +170,8 @@ void *setup_mmu(phys_addr_t phys_end)
 			"Unsupported translation granule %ld\n", PAGE_SIZE);
 #endif
 
-	mmu_idmap = alloc_page();
-
-	for (r = mem_regions; r->end; ++r) {
-		if (!(r->flags & MR_F_IO))
-			continue;
-		mmu_set_range_sect(mmu_idmap, r->start, r->start, r->end,
-				   __pgprot(PMD_SECT_UNCACHED | PMD_SECT_USER));
-	}
+	if (!mmu_idmap)
+		mmu_idmap = alloc_page();
 
 	/* armv8 requires code shared between EL1 and EL0 to be read-only */
 	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
@@ -192,6 +186,29 @@ void *setup_mmu(phys_addr_t phys_end)
 	return mmu_idmap;
 }
 
+void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
+{
+	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
+	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
+	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER);
+	pgd_t *pgtable;
+
+	assert(sizeof(long) == 8 || !(phys_addr >> 32));
+
+	if (mmu_enabled()) {
+		pgtable = current_thread_info()->pgtable;
+	} else {
+		if (!mmu_idmap)
+			mmu_idmap = alloc_page();
+		pgtable = mmu_idmap;
+	}
+
+	mmu_set_range_ptes(pgtable, paddr_aligned, paddr_aligned,
+			   paddr_end, prot);
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
2.30.2

