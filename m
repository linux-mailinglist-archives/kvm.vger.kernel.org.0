Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB70258D629
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiHIJQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiHIJPk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A664322B17
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25EA723A;
        Tue,  9 Aug 2022 02:15:39 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 460433F67D;
        Tue,  9 Aug 2022 02:15:37 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 08/19] arm/arm64: Use pgd_alloc() to allocate mmu_idmap
Date:   Tue,  9 Aug 2022 10:15:47 +0100
Message-Id: <20220809091558.14379-9-alexandru.elisei@arm.com>
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

Until commit 031755dbfefb ("arm: enable vmalloc"), the idmap was allocated
using pgd_alloc(). After that commit, all the page table allocator
functions were switched to using the page allocator, but pgd_alloc() was
left unchanged and became unused, with the idmap now being allocated with
alloc_page().

For arm64, the pgd table size varies based on the page size, which is
configured by the user. For arm, it will always contain 4 entries (it
translates bits 31:30 of the input address). To keep things simple and
consistent with the other functions and across both architectures, modify
pgd_alloc() to use alloc_page() instead of memalign like the rest of the
page table allocator functions and use it to allocate the idmap.

Note that when the idmap is created, alloc_ops->memalign is
memalign_pages() which allocates memory with page granularity. Using
memalign() as before would still have allocated a full page.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/pgtable.h   | 4 ++--
 lib/arm/mmu.c           | 4 ++--
 lib/arm64/asm/pgtable.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index d7c73906ba5e..a35f42965df9 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -43,8 +43,8 @@
 #define pgd_free(pgd) free(pgd)
 static inline pgd_t *pgd_alloc(void)
 {
-	pgd_t *pgd = memalign(L1_CACHE_BYTES, PTRS_PER_PGD * sizeof(pgd_t));
-	memset(pgd, 0, PTRS_PER_PGD * sizeof(pgd_t));
+	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
+	pgd_t *pgd = alloc_page();
 	return pgd;
 }
 
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 8f936acafe8b..2b7405d0274f 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -165,7 +165,7 @@ void *setup_mmu(phys_addr_t unused0, void *unused1)
 #endif
 
 	if (!mmu_idmap)
-		mmu_idmap = alloc_page();
+		mmu_idmap = pgd_alloc();
 
 	for (r = mem_regions; r->end; ++r) {
 		if (r->flags & MR_F_IO) {
@@ -197,7 +197,7 @@ void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
 		pgtable = current_thread_info()->pgtable;
 	} else {
 		if (!mmu_idmap)
-			mmu_idmap = alloc_page();
+			mmu_idmap = pgd_alloc();
 		pgtable = mmu_idmap;
 	}
 
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index bfb8a993e112..06357920aa74 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -49,8 +49,8 @@
 #define pgd_free(pgd) free(pgd)
 static inline pgd_t *pgd_alloc(void)
 {
-	pgd_t *pgd = memalign(PAGE_SIZE, PTRS_PER_PGD * sizeof(pgd_t));
-	memset(pgd, 0, PTRS_PER_PGD * sizeof(pgd_t));
+	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
+	pgd_t *pgd = alloc_page();
 	return pgd;
 }
 
-- 
2.37.1

