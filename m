Return-Path: <kvm+bounces-14507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 335E08A2C78
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 650D51C22B4A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 866F757307;
	Fri, 12 Apr 2024 10:35:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA37A20310
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918103; cv=none; b=b5wI9qCGNZLEfuLjgmS90TsFK7V80ZgthUYQSyBVUQI654tB7G5nQNLeXwz8JBKo1i4KjnVgqpqT9VnYodYYb057bRLwe0OHlaPxjNUZtHlGehyok+CXUQ+p6E6r6UJqtjpYkdQCUnSt7r8bgygnw8y3c7PUvUeUbOKm4feBysE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918103; c=relaxed/simple;
	bh=I7sjzoM/r8GL7yzwe7yecDHVw8xur7f0XhiwJ6YeBRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NvA/xJKfLKb9JvTCBh7uKkEiRD7mdFy3h9/kgNGZLUBWQU7OG9313h5C93neiuL7rbNNI1Nm5A4td69x/fIIt6mx3iHHvUSFQ8TDH92WCCxAmx9dZJFf0nXFL0hpsdzF3l1107rEYjNtFhayAIxzqltgolZuQ3ZE9iSKA60jeS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DDD8113E;
	Fri, 12 Apr 2024 03:35:30 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 975EC3F64C;
	Fri, 12 Apr 2024 03:34:59 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 21/33] lib/alloc_page: Add shared page allocation support
Date: Fri, 12 Apr 2024 11:33:56 +0100
Message-Id: <20240412103408.2706058-22-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Add support for allocating "pages" that can be shared with the host.
Or in other words, decrypted pages. This is achieved by adding hooks for
setting a memory region as "encrypted" or "decrypted", which can be overridden
by the architecture specific backends.

Also add a new flag - FLAG_SHARED - for allocating shared pages.

The page allocation/free routines get a "_shared_" variant too.
These will be later used for Realm support and tests.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/alloc_page.c     | 20 +++++++++++++++++---
 lib/alloc_page.h     | 24 ++++++++++++++++++++++++
 lib/asm-generic/io.h | 12 ++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 84f01e11..e253cd1d 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -263,7 +263,7 @@ static bool coalesce(struct mem_area *a, u8 order, pfn_t pfn, pfn_t pfn2)
  * - no pages in the memory block were already free
  * - no pages in the memory block are special
  */
-static void _free_pages(void *mem)
+static void _free_pages(void *mem, u32 flags)
 {
 	pfn_t pfn2, pfn = virt_to_pfn(mem);
 	struct mem_area *a = NULL;
@@ -281,6 +281,9 @@ static void _free_pages(void *mem)
 	p = pfn - a->base;
 	order = a->page_states[p] & ORDER_MASK;
 
+	if (flags & FLAG_SHARED)
+		set_memory_encrypted((unsigned long)mem, BIT(order) * PAGE_SIZE);
+
 	/* ensure that the first page is allocated and not special */
 	assert(IS_ALLOCATED(a->page_states[p]));
 	/* ensure that the order has a sane value */
@@ -320,7 +323,14 @@ static void _free_pages(void *mem)
 void free_pages(void *mem)
 {
 	spin_lock(&lock);
-	_free_pages(mem);
+	_free_pages(mem, 0);
+	spin_unlock(&lock);
+}
+
+void free_pages_shared(void *mem)
+{
+	spin_lock(&lock);
+	_free_pages(mem, FLAG_SHARED);
 	spin_unlock(&lock);
 }
 
@@ -353,7 +363,7 @@ static void _unreserve_one_page(pfn_t pfn)
 	i = pfn - a->base;
 	assert(a->page_states[i] == STATUS_SPECIAL);
 	a->page_states[i] = STATUS_ALLOCATED;
-	_free_pages(pfn_to_virt(pfn));
+	_free_pages(pfn_to_virt(pfn), 0);
 }
 
 int reserve_pages(phys_addr_t addr, size_t n)
@@ -401,6 +411,10 @@ static void *page_memalign_order_flags(u8 al, u8 ord, u32 flags)
 		if (area & BIT(i))
 			res = page_memalign_order(areas + i, al, ord, fresh);
 	spin_unlock(&lock);
+
+	if (res && (flags & FLAG_SHARED))
+		set_memory_decrypted((unsigned long)res, BIT(ord) * PAGE_SIZE);
+
 	if (res && !(flags & FLAG_DONTZERO))
 		memset(res, 0, BIT(ord) * PAGE_SIZE);
 	return res;
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 060e0418..8c1ea7b5 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -21,6 +21,7 @@
 
 #define FLAG_DONTZERO	0x10000
 #define FLAG_FRESH	0x20000
+#define FLAG_SHARED	0x40000
 
 /* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
@@ -121,4 +122,27 @@ int reserve_pages(phys_addr_t addr, size_t npages);
  */
 void unreserve_pages(phys_addr_t addr, size_t npages);
 
+/* Shared page operations */
+static inline void *alloc_pages_shared(unsigned int order)
+{
+	return alloc_pages_flags(order, FLAG_SHARED);
+}
+
+static inline void *alloc_page_shared(void)
+{
+	return alloc_pages_shared(0);
+}
+
+void free_pages_shared(void *mem);
+
+static inline void free_page_shared(void *page)
+{
+	free_pages_shared(page);
+}
+
+static inline void free_pages_shared_by_order(void *mem, unsigned int order)
+{
+	free_pages_shared(mem);
+}
+
 #endif
diff --git a/lib/asm-generic/io.h b/lib/asm-generic/io.h
index dc0f46f5..fb65184b 100644
--- a/lib/asm-generic/io.h
+++ b/lib/asm-generic/io.h
@@ -214,4 +214,16 @@ static inline void *phys_to_virt(unsigned long address)
 }
 #endif
 
+#ifndef set_memory_encrypted
+static inline void set_memory_encrypted(unsigned long mem, size_t size)
+{
+}
+#endif
+
+#ifndef set_memory_decrypted
+static inline void set_memory_decrypted(unsigned long mem, size_t size)
+{
+}
+#endif
+
 #endif /* _ASM_GENERIC_IO_H_ */
-- 
2.34.1


