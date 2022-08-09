Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1B658D624
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiHIJPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiHIJPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:15:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD1CD1C120
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:15:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE2571477;
        Tue,  9 Aug 2022 02:15:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 184A03F67D;
        Tue,  9 Aug 2022 02:15:32 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Date:   Tue,  9 Aug 2022 10:15:44 +0100
Message-Id: <20220809091558.14379-6-alexandru.elisei@arm.com>
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

With powerpc moving the page allocator, there are no architectures left
which use the physical allocator after the boot setup:  arm, arm64,
s390x and powerpc drain the physical allocator to initialize the page
allocator; and x86 calls setup_vm() to drain the allocator for each of
the tests that allocate memory.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index efb783b34002..2e0b9c079d1d 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -21,7 +21,6 @@ struct phys_alloc_region {
 static struct phys_alloc_region regions[PHYS_ALLOC_NR_REGIONS];
 static int nr_regions;
 
-static struct spinlock lock;
 static phys_addr_t base, top;
 
 #define DEFAULT_MINIMUM_ALIGNMENT	32
@@ -37,7 +36,6 @@ void phys_alloc_show(void)
 {
 	int i;
 
-	spin_lock(&lock);
 	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
 	for (i = 0; i < nr_regions; ++i)
 		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
@@ -46,24 +44,19 @@ void phys_alloc_show(void)
 			"USED");
 	printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
 		(u64)base, (u64)(top - 1), "FREE");
-	spin_unlock(&lock);
 }
 
 void phys_alloc_init(phys_addr_t base_addr, phys_addr_t size)
 {
-	spin_lock(&lock);
 	base = base_addr;
 	top = base + size;
 	nr_regions = 0;
-	spin_unlock(&lock);
 }
 
 void phys_alloc_set_minimum_alignment(phys_addr_t align)
 {
 	assert(align && !(align & (align - 1)));
-	spin_lock(&lock);
 	align_min = align;
-	spin_unlock(&lock);
 }
 
 static void *memalign_early(size_t alignment, size_t sz)
@@ -76,8 +69,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 
 	assert(align && !(align & (align - 1)));
 
-	spin_lock(&lock);
-
 	top_safe = top;
 
 	if (sizeof(long) == 4)
@@ -97,7 +88,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 		       "top=%#" PRIx64 ", top_safe=%#" PRIx64 "\n",
 		       (u64)size_orig, (u64)align, (u64)size,
 		       (u64)(top_safe - base), (u64)top, (u64)top_safe);
-		spin_unlock(&lock);
 		return NULL;
 	}
 
@@ -113,8 +103,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 		warned = true;
 	}
 
-	spin_unlock(&lock);
-
 	return phys_to_virt(addr);
 }
 
@@ -124,10 +112,8 @@ void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
 	*p_top = top;
 	if (base == top)
 		return;
-	spin_lock(&lock);
 	regions[nr_regions].base = base;
 	regions[nr_regions].size = top - base;
 	++nr_regions;
 	base = top;
-	spin_unlock(&lock);
 }
-- 
2.37.1

