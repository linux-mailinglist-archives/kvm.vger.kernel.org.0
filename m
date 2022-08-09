Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7288958D626
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiHIJP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235729AbiHIJPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FA9B1C939
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:35 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A8CF23A;
        Tue,  9 Aug 2022 02:15:36 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7886E3F67D;
        Tue,  9 Aug 2022 02:15:34 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 06/19] lib/alloc_phys: Remove allocation accounting
Date:   Tue,  9 Aug 2022 10:15:45 +0100
Message-Id: <20220809091558.14379-7-alexandru.elisei@arm.com>
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

The page allocator has better allocation tracking and is used by all
architectures, while the physical allocator is now never used for
allocating memory.

Simplify the physical allocator by removing allocation accounting. This
accomplishes two things:

1. It makes the allocator more useful, as the warning that was displayed
each allocation after the 256th is removed.

2. Together with the lock removal, the physical allocator becomes more
appealing as a very early allocator, when using the page allocator might
not be desirable or feasible.

Also, phys_alloc_show() has received a slight change in the way it displays
the use and free regions: the end of the region is now non-inclusive, to
allow phys_alloc_show() to express that no memory has been used, or no
memory is free, in which case the start and the end adresses are equal.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 65 ++++++++++++++----------------------------------
 lib/alloc_phys.h |  5 ++--
 2 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 2e0b9c079d1d..1e1fc179f108 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -11,17 +11,11 @@
 #include "asm/io.h"
 #include "alloc_phys.h"
 
-#define PHYS_ALLOC_NR_REGIONS	256
-
-struct phys_alloc_region {
-	phys_addr_t base;
-	phys_addr_t size;
-};
-
-static struct phys_alloc_region regions[PHYS_ALLOC_NR_REGIONS];
-static int nr_regions;
-
-static phys_addr_t base, top;
+/*
+ * used is the end address of the currently allocated memory, non-inclusive.
+ * used equals top means that all memory has been allocated.
+ */
+static phys_addr_t base, used, top;
 
 #define DEFAULT_MINIMUM_ALIGNMENT	32
 static size_t align_min = DEFAULT_MINIMUM_ALIGNMENT;
@@ -34,23 +28,15 @@ struct alloc_ops *alloc_ops = &early_alloc_ops;
 
 void phys_alloc_show(void)
 {
-	int i;
-
 	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
-	for (i = 0; i < nr_regions; ++i)
-		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
-			(u64)regions[i].base,
-			(u64)(regions[i].base + regions[i].size - 1),
-			"USED");
-	printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
-		(u64)base, (u64)(top - 1), "FREE");
+	printf("%016" PRIx64 "-%016" PRIx64 " [USED]\n", (u64)base, (u64)used);
+	printf("%016" PRIx64 "-%016" PRIx64 " [FREE]\n", (u64)used, (u64)top);
 }
 
 void phys_alloc_init(phys_addr_t base_addr, phys_addr_t size)
 {
-	base = base_addr;
+	used = base = base_addr;
 	top = base + size;
-	nr_regions = 0;
 }
 
 void phys_alloc_set_minimum_alignment(phys_addr_t align)
@@ -61,7 +47,6 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 
 static void *memalign_early(size_t alignment, size_t sz)
 {
-	static bool warned = false;
 	phys_addr_t align = (phys_addr_t)alignment;
 	phys_addr_t size = (phys_addr_t)sz;
 	phys_addr_t size_orig = size;
@@ -70,50 +55,36 @@ static void *memalign_early(size_t alignment, size_t sz)
 	assert(align && !(align & (align - 1)));
 
 	top_safe = top;
-
 	if (sizeof(long) == 4)
 		top_safe = MIN(top_safe, 1ULL << 32);
+	assert(used < top_safe);
 
-	assert(base < top_safe);
 	if (align < align_min)
 		align = align_min;
 
-	addr = ALIGN(base, align);
-	size += addr - base;
+	addr = ALIGN(used, align);
+	size += addr - used;
 
-	if ((top_safe - base) < size) {
+	if (size > top_safe - used) {
 		printf("phys_alloc: requested=%#" PRIx64
 		       " (align=%#" PRIx64 "), "
 		       "need=%#" PRIx64 ", but free=%#" PRIx64 ". "
 		       "top=%#" PRIx64 ", top_safe=%#" PRIx64 "\n",
 		       (u64)size_orig, (u64)align, (u64)size,
-		       (u64)(top_safe - base), (u64)top, (u64)top_safe);
+		       (u64)(top_safe - used), (u64)top, (u64)top_safe);
 		return NULL;
 	}
 
-	base += size;
-
-	if (nr_regions < PHYS_ALLOC_NR_REGIONS) {
-		regions[nr_regions].base = addr;
-		regions[nr_regions].size = size_orig;
-		++nr_regions;
-	} else if (!warned) {
-		printf("WARNING: phys_alloc: No free log entries, "
-		       "can no longer log allocations...\n");
-		warned = true;
-	}
+	used += size;
 
 	return phys_to_virt(addr);
 }
 
 void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
 {
-	*p_base = base;
+	*p_base = used;
 	*p_top = top;
-	if (base == top)
-		return;
-	regions[nr_regions].base = base;
-	regions[nr_regions].size = top - base;
-	++nr_regions;
-	base = top;
+
+	/* Empty allocator. */
+	used = top;
 }
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 8049c340818d..4d350f010031 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -29,8 +29,9 @@ extern void phys_alloc_set_minimum_alignment(phys_addr_t align);
 
 /*
  * phys_alloc_show outputs all currently allocated regions with the
- * following format
- *   <start_addr>-<end_addr> [<USED|FREE>]
+ * following format, where <end_addr> is non-inclusive:
+ *
+ * <start_addr>-<end_addr> [<USED|FREE>]
  */
 extern void phys_alloc_show(void);
 
-- 
2.37.1

