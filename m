Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1392C3574B3
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355525AbhDGTAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 15:00:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355512AbhDGS77 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 14:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1xkdbI5dHRq6fFNZKzfhYkUvq8CvPIi1fKJ3AV2wbw=;
        b=CrZwL/eu3hOfChcoiVYOPHN+CrwyealirGZjUHpPDYwXyxLqxgFB4AyWss6SlGQPZz1CXX
        1i8MjScZPs0Az22yR0nGCJlC9qYoKjaAzWJD/dfBHitGUN00HUAuh6dNdwSyX67LP61EoZ
        2Gnq6Iw4onCN7hsbf1bvc2OrLNFO2Wc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-_WYk46P3OMyZKFLZw5Jg1Q-1; Wed, 07 Apr 2021 14:59:46 -0400
X-MC-Unique: _WYk46P3OMyZKFLZw5Jg1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EE6C8189C8;
        Wed,  7 Apr 2021 18:59:45 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65E5F614EF;
        Wed,  7 Apr 2021 18:59:40 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 5/8] arm/arm64: mmu: Remove memory layout assumptions
Date:   Wed,  7 Apr 2021 20:59:15 +0200
Message-Id: <20210407185918.371983-6-drjones@redhat.com>
In-Reply-To: <20210407185918.371983-1-drjones@redhat.com>
References: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than making too many assumptions about the memory layout
in mmu code, just set up the page tables per the memory regions
(which means putting all the memory layout assumptions in setup).
To ensure we get the right default flags set we need to split the
primary region into two regions for code and data.

We still only expect the primary regions to be present, but the
next patch will remove that assumption too.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/setup.h |  1 +
 lib/arm/mmu.c       | 26 +++++++++++++++-----------
 lib/arm/setup.c     | 22 ++++++++++++++--------
 3 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
index c8afb2493f8d..210c14f818fb 100644
--- a/lib/arm/asm/setup.h
+++ b/lib/arm/asm/setup.h
@@ -15,6 +15,7 @@ extern int nr_cpus;
 
 #define MR_F_PRIMARY		(1U << 0)
 #define MR_F_IO			(1U << 1)
+#define MR_F_CODE		(1U << 2)
 #define MR_F_UNKNOWN		(1U << 31)
 
 struct mem_region {
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index a7b7ae51afe3..edd2b9da809b 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -20,8 +20,6 @@
 
 #include <linux/compiler.h>
 
-extern unsigned long etext;
-
 #define MMU_MAX_PERSISTENT_MAPS 64
 
 struct mmu_persistent_map {
@@ -208,7 +206,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 
 void *setup_mmu(phys_addr_t phys_end)
 {
-	uintptr_t code_end = (uintptr_t)&etext;
+	struct mem_region *r;
 
 	/* 0G-1G = I/O, 1G-3G = identity, 3G-4G = vmalloc */
 	if (phys_end > (3ul << 30))
@@ -223,14 +221,20 @@ void *setup_mmu(phys_addr_t phys_end)
 
 	mmu_idmap = alloc_page();
 
-	/* armv8 requires code shared between EL1 and EL0 to be read-only */
-	mmu_set_range_ptes(mmu_idmap, PHYS_OFFSET,
-		PHYS_OFFSET, code_end,
-		__pgprot(PTE_WBWA | PTE_RDONLY | PTE_USER));
-
-	mmu_set_range_ptes(mmu_idmap, code_end,
-		code_end, phys_end,
-		__pgprot(PTE_WBWA | PTE_USER));
+	for (r = mem_regions; r->end; ++r) {
+		if (r->flags & MR_F_IO) {
+			continue;
+		} else if (r->flags & MR_F_CODE) {
+			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected code region");
+			/* armv8 requires code shared between EL1 and EL0 to be read-only */
+			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
+					   __pgprot(PTE_WBWA | PTE_USER | PTE_RDONLY));
+		} else {
+			assert_msg(r->flags & MR_F_PRIMARY, "Unexpected data region");
+			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
+					   __pgprot(PTE_WBWA | PTE_USER));
+		}
+	}
 
 	mmu_set_persistent_maps(mmu_idmap);
 
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 9c16f6004e9f..9da5d24b0be9 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -31,6 +31,7 @@
 #define NR_INITIAL_MEM_REGIONS 16
 
 extern unsigned long stacktop;
+extern unsigned long etext;
 
 struct timer_state __timer_state;
 
@@ -88,10 +89,12 @@ unsigned int mem_region_get_flags(phys_addr_t paddr)
 
 static void mem_init(phys_addr_t freemem_start)
 {
+	phys_addr_t code_end = (phys_addr_t)(unsigned long)&etext;
 	struct dt_pbus_reg regs[NR_INITIAL_MEM_REGIONS];
-	struct mem_region primary, mem = {
+	struct mem_region mem = {
 		.start = (phys_addr_t)-1,
 	};
+	struct mem_region *primary = NULL;
 	phys_addr_t base, top;
 	int nr_regs, nr_io = 0, i;
 
@@ -110,8 +113,6 @@ static void mem_init(phys_addr_t freemem_start)
 	nr_regs = dt_get_memory_params(regs, NR_INITIAL_MEM_REGIONS - nr_io);
 	assert(nr_regs > 0);
 
-	primary = (struct mem_region){ 0 };
-
 	for (i = 0; i < nr_regs; ++i) {
 		struct mem_region *r = &mem_regions[nr_io + i];
 
@@ -123,7 +124,7 @@ static void mem_init(phys_addr_t freemem_start)
 		 */
 		if (freemem_start >= r->start && freemem_start < r->end) {
 			r->flags |= MR_F_PRIMARY;
-			primary = *r;
+			primary = r;
 		}
 
 		/*
@@ -135,13 +136,18 @@ static void mem_init(phys_addr_t freemem_start)
 		if (r->end > mem.end)
 			mem.end = r->end;
 	}
-	assert(primary.end != 0);
+	assert(primary);
 	assert(!(mem.start & ~PHYS_MASK) && !((mem.end - 1) & ~PHYS_MASK));
 
-	__phys_offset = primary.start;	/* PHYS_OFFSET */
-	__phys_end = primary.end;	/* PHYS_END */
+	__phys_offset = primary->start;	/* PHYS_OFFSET */
+	__phys_end = primary->end;	/* PHYS_END */
+
+	/* Split the primary region into two regions; code and data */
+	mem.start = code_end, mem.end = primary->end, mem.flags = MR_F_PRIMARY;
+	mem_regions[nr_io + i] = mem;
+	primary->end = code_end, primary->flags |= MR_F_CODE;
 
-	phys_alloc_init(freemem_start, primary.end - freemem_start);
+	phys_alloc_init(freemem_start, __phys_end - freemem_start);
 	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
 
 	phys_alloc_get_unused(&base, &top);
-- 
2.26.3

