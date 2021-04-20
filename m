Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFDD365FF3
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhDTTBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 15:01:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233708AbhDTTB3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 15:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618945257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vfJFdZSjEQUXvaroG0mBhd+ZqUxFkJnNSVyh9EWz61k=;
        b=L3SSwUqxaSO4chACPbi+VMUM1K4avSzyq7MwtfAfwGp/svfx5Jsqddte2SB1/qLajcPLxl
        YYXYB7wP0IvOIfg/8VfOokawmZL727G06CR8bacoK3p4oFlxLgIoOGXdP7U3LR/zgshXyv
        bjwnsY8xizQWDKEz1Iqsjq+zVPtHZHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-3uiJErXbNVWS6YIpMo_MHw-1; Tue, 20 Apr 2021 15:00:55 -0400
X-MC-Unique: 3uiJErXbNVWS6YIpMo_MHw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1F2E802B62;
        Tue, 20 Apr 2021 19:00:53 +0000 (UTC)
Received: from gator.home (unknown [10.40.195.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCAD719701;
        Tue, 20 Apr 2021 19:00:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests v2 5/8] arm/arm64: mmu: Remove memory layout assumptions
Date:   Tue, 20 Apr 2021 20:59:59 +0200
Message-Id: <20210420190002.383444-6-drjones@redhat.com>
In-Reply-To: <20210420190002.383444-1-drjones@redhat.com>
References: <20210420190002.383444-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

(Unfortunately we still have an assumption in setup_mmu. We assume
 the range 3G-4G is available for the virtual memory allocator. We'll
 need to remove that assumption as well with another patch in order
 to support arbitrary memory maps.)

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm/asm/setup.h |  1 +
 lib/arm/mmu.c       | 26 +++++++++++++++-----------
 lib/arm/setup.c     | 29 +++++++++++++++++++++--------
 3 files changed, 37 insertions(+), 19 deletions(-)

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
index ee0c79142ba1..4e3cf37e33d0 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -20,8 +20,6 @@
 
 #include <linux/compiler.h>
 
-extern unsigned long etext;
-
 pgd_t *mmu_idmap;
 
 /* CPU 0 starts with disabled MMU */
@@ -157,7 +155,7 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
 
 void *setup_mmu(phys_addr_t phys_end)
 {
-	uintptr_t code_end = (uintptr_t)&etext;
+	struct mem_region *r;
 
 	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
 	if (phys_end > (3ul << 30))
@@ -173,14 +171,20 @@ void *setup_mmu(phys_addr_t phys_end)
 	if (!mmu_idmap)
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
 
 	mmu_enable(mmu_idmap);
 	return mmu_idmap;
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 9c16f6004e9f..7db308b70744 100644
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
@@ -135,13 +136,25 @@ static void mem_init(phys_addr_t freemem_start)
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
+	mem_regions[nr_io + i] = (struct mem_region){
+		.start = code_end,
+		.end = primary->end,
+		.flags = MR_F_PRIMARY,
+	};
+	*primary = (struct mem_region){
+		.start = primary->start,
+		.end = code_end,
+		.flags = MR_F_PRIMARY | MR_F_CODE,
+	};
 
-	phys_alloc_init(freemem_start, primary.end - freemem_start);
+	phys_alloc_init(freemem_start, __phys_end - freemem_start);
 	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
 
 	phys_alloc_get_unused(&base, &top);
-- 
2.30.2

