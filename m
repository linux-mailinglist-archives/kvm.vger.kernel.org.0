Return-Path: <kvm+bounces-2869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C05057FEB77
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DA0BB21745
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697F93B2BC;
	Thu, 30 Nov 2023 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ypr4uzdg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD8A10DF
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701335280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3GRpZVrUQ48jcY3nyA21eJ+CgW6QlT8/+5EjDT8mBVQ=;
	b=Ypr4uzdguonHHRuR7z/c0sAo4QPSUu7jun4ms3YYM+AjAGseA0AhgduZi0dwdn7wHv6i5E
	OcuTgEVr8l+1afqasKKV1IJRnBnLrjY/7TryKs8doBKEUNDnWEylHezWVhStXMLdBBjWOA
	cwDqO/2MUGBdUhYGDcv6KuhInO6AVoc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-E2_7YMpgOXygR6voiEq6ZQ-1; Thu,
 30 Nov 2023 04:07:56 -0500
X-MC-Unique: E2_7YMpgOXygR6voiEq6ZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 799D1299E75C;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 72BD01C060AE;
	Thu, 30 Nov 2023 09:07:56 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 06/18] lib/alloc_phys: Remove allocation accounting
Date: Thu, 30 Nov 2023 04:07:08 -0500
Message-Id: <20231130090722.2897974-7-shahuang@redhat.com>
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Alexandru Elisei <alexandru.elisei@arm.com>

The page allocator has better allocation tracking and is used by all
architectures, while the physical allocator is never used for allocating
memory.

Simplify the physical allocator by removing allocation accounting. This
accomplishes two things:

1. It makes the allocator more useful, as the warning that was displayed
for each allocation after the 256th is removed. That can become an issue
if the allocator is used for creating the translation tables, for example.

2. It becomes trivial to add cache maintenance for the internal structures
that the physical allocator maintains, which are now only four static
variables.

phys_alloc_show() has received a slight change in the way it displays the
use and free regions: the end of the region is now non-inclusive, to allow
phys_alloc_show() to express that no memory has been used, or no memory is
free: in both cases, the start and the end adresses are equal.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 63 +++++++++++++-----------------------------------
 lib/alloc_phys.h |  5 ++--
 2 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 064077f7..c96bcb48 100644
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
@@ -70,7 +55,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 	assert(align && !(align & (align - 1)));
 
 	top_safe = top;
-
 	if (sizeof(long) == 4)
 		top_safe = MIN(top_safe, 1ULL << 32);
 	assert(base < top_safe);
@@ -78,42 +62,29 @@ static void *memalign_early(size_t alignment, size_t sz)
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
index 8049c340..4d350f01 100644
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
2.40.1


