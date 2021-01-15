Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8183F2F7A0A
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbhAOMoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:44:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25318 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731332AbhAOMoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:44:17 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCXQIE058749;
        Fri, 15 Jan 2021 07:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tOGayUs71BJ4wLsYc5gTHjt5X9MmZRcIRky+ib3AO+0=;
 b=qOoZ2dbU0zozMxRPJvvag0imHlz3YeBgGwCjK58YwCdvmALTHBusyTspGy3plemtBtBA
 mebDb7iA8L7bujEPTM0Ic+/K8lRJfX0OJNNpCLQpUzWfOA/GFEVIEF02+IiqATm2GTAq
 JW3Rf2iNufpZPvvrPVamNpPEJuvUcW++UuUwtqbF9r5LAfV/wyScimUNtdrhyVHLVoCp
 sQuLWw/taaPbPs2JL9Hya1s2QP3LjEFCAJKzATsY9p/pLyrDqyinShpq1LUTCvhA8LvJ
 odwVjip5WuCRHUU85hGI+LNJBBKIKo/0Ba8afBXwAb5Boo3tKUHEM43ZLFdPx0QyK4V1 LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363auyrn1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:39 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCXTED058832;
        Fri, 15 Jan 2021 07:37:39 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363auyrn1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:38 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCbKMb032570;
        Fri, 15 Jan 2021 12:37:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447yp49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbY4D33161578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60E05AE053;
        Fri, 15 Jan 2021 12:37:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3955AE055;
        Fri, 15 Jan 2021 12:37:33 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:33 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 05/11] lib/alloc_page: fix and improve the page allocator
Date:   Fri, 15 Jan 2021 13:37:24 +0100
Message-Id: <20210115123730.381612-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces some improvements to the code, mostly readability
improvements, but also some semantic details, and improvements in the
documentation.

* introduce and use pfn_t to semantically tag parameters as PFNs
* remove the PFN macro, use virt_to_pfn instead
* rename area_or_metadata_contains and area_contains to area_contains_pfn
  and usable_area_contains_pfn respectively
* fix/improve comments in lib/alloc_page.h
* move some wrapper functions to the header

Fixes: 8131e91a4b61 ("lib/alloc_page: complete rewrite of the page allocator")
Fixes: 34c950651861 ("lib/alloc_page: allow reserving arbitrary memory ranges")

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.h |  52 ++++++++++-----
 lib/alloc_page.c | 165 +++++++++++++++++++++++------------------------
 2 files changed, 118 insertions(+), 99 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index b6aace5..6fd2ff0 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -8,6 +8,7 @@
 #ifndef ALLOC_PAGE_H
 #define ALLOC_PAGE_H 1
 
+#include <stdbool.h>
 #include <asm/memory_areas.h>
 
 #define AREA_ANY -1
@@ -23,7 +24,7 @@ bool page_alloc_initialized(void);
  * top_pfn is the physical frame number of the first page immediately after
  * the end of the area to initialize
  */
-void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn);
+void page_alloc_init_area(u8 n, phys_addr_t base_pfn, phys_addr_t top_pfn);
 
 /* Enables the page allocator. At least one area must have been initialized */
 void page_alloc_ops_enable(void);
@@ -37,9 +38,12 @@ void *memalign_pages_area(unsigned int areas, size_t alignment, size_t size);
 
 /*
  * Allocate aligned memory from any area.
- * Equivalent to memalign_pages_area(~0, alignment, size).
+ * Equivalent to memalign_pages_area(AREA_ANY, alignment, size).
  */
-void *memalign_pages(size_t alignment, size_t size);
+static inline void *memalign_pages(size_t alignment, size_t size)
+{
+	return memalign_pages_area(AREA_ANY, alignment, size);
+}
 
 /*
  * Allocate naturally aligned memory from the specified areas.
@@ -48,16 +52,23 @@ void *memalign_pages(size_t alignment, size_t size);
 void *alloc_pages_area(unsigned int areas, unsigned int order);
 
 /*
- * Allocate one page from any area.
- * Equivalent to alloc_pages(0);
+ * Allocate naturally aligned pages from any area; the number of allocated
+ * pages is 1 << order.
+ * Equivalent to alloc_pages_area(AREA_ANY, order);
  */
-void *alloc_page(void);
+static inline void *alloc_pages(unsigned int order)
+{
+	return alloc_pages_area(AREA_ANY, order);
+}
 
 /*
- * Allocate naturally aligned memory from any area.
- * Equivalent to alloc_pages_area(~0, order);
+ * Allocate one page from any area.
+ * Equivalent to alloc_pages(0);
  */
-void *alloc_pages(unsigned int order);
+static inline void *alloc_page(void)
+{
+	return alloc_pages(0);
+}
 
 /*
  * Frees a memory block allocated with any of the memalign_pages* or
@@ -66,31 +77,40 @@ void *alloc_pages(unsigned int order);
  */
 void free_pages(void *mem);
 
-/* For backwards compatibility */
+/*
+ * Free one page.
+ * Equivalent to free_pages(mem).
+ */
 static inline void free_page(void *mem)
 {
 	return free_pages(mem);
 }
 
-/* For backwards compatibility */
+/*
+ * Free pages by order.
+ * Equivalent to free_pages(mem).
+ */
 static inline void free_pages_by_order(void *mem, unsigned int order)
 {
 	free_pages(mem);
 }
 
 /*
- * Allocates and reserves the specified memory range if possible.
- * Returns NULL in case of failure.
+ * Reserves the specified physical memory range if possible.
+ * If the specified range cannot be reserved in its entirety, no action is
+ * performed and -1 is returned.
+ *
+ * Returns 0 in case of success, -1 otherwise.
  */
-void *alloc_pages_special(uintptr_t addr, size_t npages);
+int reserve_pages(phys_addr_t addr, size_t npages);
 
 /*
  * Frees a reserved memory range that had been reserved with
- * alloc_pages_special.
+ * reserve_pages.
  * The memory range does not need to match a previous allocation
  * exactly, it can also be a subset, in which case only the specified
  * pages will be freed and unreserved.
  */
-void free_pages_special(uintptr_t addr, size_t npages);
+void unreserve_pages(phys_addr_t addr, size_t npages);
 
 #endif
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index ed0ff02..337a4e0 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -17,25 +17,29 @@
 
 #define IS_ALIGNED_ORDER(x,order) IS_ALIGNED((x),BIT_ULL(order))
 #define NLISTS ((BITS_PER_LONG) - (PAGE_SHIFT))
-#define PFN(x) ((uintptr_t)(x) >> PAGE_SHIFT)
 
 #define ORDER_MASK	0x3f
 #define ALLOC_MASK	0x40
 #define SPECIAL_MASK	0x80
 
+typedef phys_addr_t pfn_t;
+
 struct mem_area {
 	/* Physical frame number of the first usable frame in the area */
-	uintptr_t base;
+	pfn_t base;
 	/* Physical frame number of the first frame outside the area */
-	uintptr_t top;
-	/* Combination of SPECIAL_MASK, ALLOC_MASK, and order */
+	pfn_t top;
+	/* Per page metadata, each entry is a combination *_MASK and order */
 	u8 *page_states;
 	/* One freelist for each possible block size, up to NLISTS */
 	struct linked_list freelists[NLISTS];
 };
 
+/* Descriptors for each possible area */
 static struct mem_area areas[MAX_AREAS];
+/* Mask of initialized areas */
 static unsigned int areas_mask;
+/* Protects areas and areas mask */
 static struct spinlock lock;
 
 bool page_alloc_initialized(void)
@@ -43,12 +47,24 @@ bool page_alloc_initialized(void)
 	return areas_mask != 0;
 }
 
-static inline bool area_or_metadata_contains(struct mem_area *a, uintptr_t pfn)
+/*
+ * Each memory area contains an array of metadata entries at the very
+ * beginning. The usable memory follows immediately afterwards.
+ * This function returns true if the given pfn falls anywhere within the
+ * memory area, including the metadata area.
+ */
+static inline bool area_contains_pfn(struct mem_area *a, pfn_t pfn)
 {
-	return (pfn >= PFN(a->page_states)) && (pfn < a->top);
+	return (pfn >= virt_to_pfn(a->page_states)) && (pfn < a->top);
 }
 
-static inline bool area_contains(struct mem_area *a, uintptr_t pfn)
+/*
+ * Each memory area contains an array of metadata entries at the very
+ * beginning. The usable memory follows immediately afterwards.
+ * This function returns true if the given pfn falls in the usable range of
+ * the given memory area.
+ */
+static inline bool usable_area_contains_pfn(struct mem_area *a, pfn_t pfn)
 {
 	return (pfn >= a->base) && (pfn < a->top);
 }
@@ -69,21 +85,19 @@ static inline bool area_contains(struct mem_area *a, uintptr_t pfn)
  */
 static void split(struct mem_area *a, void *addr)
 {
-	uintptr_t pfn = PFN(addr);
-	struct linked_list *p;
-	uintptr_t i, idx;
+	pfn_t pfn = virt_to_pfn(addr);
+	pfn_t i, idx;
 	u8 order;
 
-	assert(a && area_contains(a, pfn));
+	assert(a && usable_area_contains_pfn(a, pfn));
 	idx = pfn - a->base;
 	order = a->page_states[idx];
 	assert(!(order & ~ORDER_MASK) && order && (order < NLISTS));
 	assert(IS_ALIGNED_ORDER(pfn, order));
-	assert(area_contains(a, pfn + BIT(order) - 1));
+	assert(usable_area_contains_pfn(a, pfn + BIT(order) - 1));
 
 	/* Remove the block from its free list */
-	p = list_remove(addr);
-	assert(p);
+	list_remove(addr);
 
 	/* update the block size for each page in the block */
 	for (i = 0; i < BIT(order); i++) {
@@ -92,9 +106,9 @@ static void split(struct mem_area *a, void *addr)
 	}
 	order--;
 	/* add the first half block to the appropriate free list */
-	list_add(a->freelists + order, p);
+	list_add(a->freelists + order, addr);
 	/* add the second half block to the appropriate free list */
-	list_add(a->freelists + order, (void *)((pfn + BIT(order)) * PAGE_SIZE));
+	list_add(a->freelists + order, pfn_to_virt(pfn + BIT(order)));
 }
 
 /*
@@ -105,7 +119,7 @@ static void split(struct mem_area *a, void *addr)
  */
 static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 {
-	struct linked_list *p, *res = NULL;
+	struct linked_list *p;
 	u8 order;
 
 	assert((al < NLISTS) && (sz < NLISTS));
@@ -130,17 +144,17 @@ static void *page_memalign_order(struct mem_area *a, u8 al, u8 sz)
 	for (; order > sz; order--)
 		split(a, p);
 
-	res = list_remove(p);
-	memset(a->page_states + (PFN(res) - a->base), ALLOC_MASK | order, BIT(order));
-	return res;
+	list_remove(p);
+	memset(a->page_states + (virt_to_pfn(p) - a->base), ALLOC_MASK | order, BIT(order));
+	return p;
 }
 
-static struct mem_area *get_area(uintptr_t pfn)
+static struct mem_area *get_area(pfn_t pfn)
 {
 	uintptr_t i;
 
 	for (i = 0; i < MAX_AREAS; i++)
-		if ((areas_mask & BIT(i)) && area_contains(areas + i, pfn))
+		if ((areas_mask & BIT(i)) && usable_area_contains_pfn(areas + i, pfn))
 			return areas + i;
 	return NULL;
 }
@@ -160,17 +174,16 @@ static struct mem_area *get_area(uintptr_t pfn)
  * - all of the pages of the two blocks must have the same block size
  * - the function is called with the lock held
  */
-static bool coalesce(struct mem_area *a, u8 order, uintptr_t pfn, uintptr_t pfn2)
+static bool coalesce(struct mem_area *a, u8 order, pfn_t pfn, pfn_t pfn2)
 {
-	uintptr_t first, second, i;
-	struct linked_list *li;
+	pfn_t first, second, i;
 
 	assert(IS_ALIGNED_ORDER(pfn, order) && IS_ALIGNED_ORDER(pfn2, order));
 	assert(pfn2 == pfn + BIT(order));
 	assert(a);
 
 	/* attempting to coalesce two blocks that belong to different areas */
-	if (!area_contains(a, pfn) || !area_contains(a, pfn2 + BIT(order) - 1))
+	if (!usable_area_contains_pfn(a, pfn) || !usable_area_contains_pfn(a, pfn2 + BIT(order) - 1))
 		return false;
 	first = pfn - a->base;
 	second = pfn2 - a->base;
@@ -179,17 +192,15 @@ static bool coalesce(struct mem_area *a, u8 order, uintptr_t pfn, uintptr_t pfn2
 		return false;
 
 	/* we can coalesce, remove both blocks from their freelists */
-	li = list_remove((void *)(pfn2 << PAGE_SHIFT));
-	assert(li);
-	li = list_remove((void *)(pfn << PAGE_SHIFT));
-	assert(li);
+	list_remove(pfn_to_virt(pfn2));
+	list_remove(pfn_to_virt(pfn));
 	/* check the metadata entries and update with the new size */
 	for (i = 0; i < (2ull << order); i++) {
 		assert(a->page_states[first + i] == order);
 		a->page_states[first + i] = order + 1;
 	}
 	/* finally add the newly coalesced block to the appropriate freelist */
-	list_add(a->freelists + order + 1, li);
+	list_add(a->freelists + order + 1, pfn_to_virt(pfn));
 	return true;
 }
 
@@ -209,7 +220,7 @@ static bool coalesce(struct mem_area *a, u8 order, uintptr_t pfn, uintptr_t pfn2
  */
 static void _free_pages(void *mem)
 {
-	uintptr_t pfn2, pfn = PFN(mem);
+	pfn_t pfn2, pfn = virt_to_pfn(mem);
 	struct mem_area *a = NULL;
 	uintptr_t i, p;
 	u8 order;
@@ -232,7 +243,7 @@ static void _free_pages(void *mem)
 	/* ensure that the block is aligned properly for its size */
 	assert(IS_ALIGNED_ORDER(pfn, order));
 	/* ensure that the area can contain the whole block */
-	assert(area_contains(a, pfn + BIT(order) - 1));
+	assert(usable_area_contains_pfn(a, pfn + BIT(order) - 1));
 
 	for (i = 0; i < BIT(order); i++) {
 		/* check that all pages of the block have consistent metadata */
@@ -268,63 +279,68 @@ void free_pages(void *mem)
 	spin_unlock(&lock);
 }
 
-static void *_alloc_page_special(uintptr_t addr)
+static int _reserve_one_page(pfn_t pfn)
 {
 	struct mem_area *a;
-	uintptr_t mask, i;
+	pfn_t mask, i;
 
-	a = get_area(PFN(addr));
-	assert(a);
-	i = PFN(addr) - a->base;
+	a = get_area(pfn);
+	if (!a)
+		return -1;
+	i = pfn - a->base;
 	if (a->page_states[i] & (ALLOC_MASK | SPECIAL_MASK))
-		return NULL;
+		return -1;
 	while (a->page_states[i]) {
-		mask = GENMASK_ULL(63, PAGE_SHIFT + a->page_states[i]);
-		split(a, (void *)(addr & mask));
+		mask = GENMASK_ULL(63, a->page_states[i]);
+		split(a, pfn_to_virt(pfn & mask));
 	}
 	a->page_states[i] = SPECIAL_MASK;
-	return (void *)addr;
+	return 0;
 }
 
-static void _free_page_special(uintptr_t addr)
+static void _unreserve_one_page(pfn_t pfn)
 {
 	struct mem_area *a;
-	uintptr_t i;
+	pfn_t i;
 
-	a = get_area(PFN(addr));
+	a = get_area(pfn);
 	assert(a);
-	i = PFN(addr) - a->base;
+	i = pfn - a->base;
 	assert(a->page_states[i] == SPECIAL_MASK);
 	a->page_states[i] = ALLOC_MASK;
-	_free_pages((void *)addr);
+	_free_pages(pfn_to_virt(pfn));
 }
 
-void *alloc_pages_special(uintptr_t addr, size_t n)
+int reserve_pages(phys_addr_t addr, size_t n)
 {
-	uintptr_t i;
+	pfn_t pfn;
+	size_t i;
 
 	assert(IS_ALIGNED(addr, PAGE_SIZE));
+	pfn = addr >> PAGE_SHIFT;
 	spin_lock(&lock);
 	for (i = 0; i < n; i++)
-		if (!_alloc_page_special(addr + i * PAGE_SIZE))
+		if (_reserve_one_page(pfn + i))
 			break;
 	if (i < n) {
 		for (n = 0 ; n < i; n++)
-			_free_page_special(addr + n * PAGE_SIZE);
-		addr = 0;
+			_unreserve_one_page(pfn + n);
+		n = 0;
 	}
 	spin_unlock(&lock);
-	return (void *)addr;
+	return -!n;
 }
 
-void free_pages_special(uintptr_t addr, size_t n)
+void unreserve_pages(phys_addr_t addr, size_t n)
 {
-	uintptr_t i;
+	pfn_t pfn;
+	size_t i;
 
 	assert(IS_ALIGNED(addr, PAGE_SIZE));
+	pfn = addr >> PAGE_SHIFT;
 	spin_lock(&lock);
 	for (i = 0; i < n; i++)
-		_free_page_special(addr + i * PAGE_SIZE);
+		_unreserve_one_page(pfn + i);
 	spin_unlock(&lock);
 }
 
@@ -351,11 +367,6 @@ void *alloc_pages_area(unsigned int area, unsigned int order)
 	return page_memalign_order_area(area, order, order);
 }
 
-void *alloc_pages(unsigned int order)
-{
-	return alloc_pages_area(AREA_ANY, order);
-}
-
 /*
  * Allocates (1 << order) physically contiguous aligned pages.
  * Returns NULL if the allocation was not possible.
@@ -370,18 +381,6 @@ void *memalign_pages_area(unsigned int area, size_t alignment, size_t size)
 	return page_memalign_order_area(area, size, alignment);
 }
 
-void *memalign_pages(size_t alignment, size_t size)
-{
-	return memalign_pages_area(AREA_ANY, alignment, size);
-}
-
-/*
- * Allocates one page
- */
-void *alloc_page()
-{
-	return alloc_pages(0);
-}
 
 static struct alloc_ops page_alloc_ops = {
 	.memalign = memalign_pages,
@@ -416,7 +415,7 @@ void page_alloc_ops_enable(void)
  * - the memory area to add does not overlap with existing areas
  * - the memory area to add has at least 5 pages available
  */
-static void _page_alloc_init_area(u8 n, uintptr_t start_pfn, uintptr_t top_pfn)
+static void _page_alloc_init_area(u8 n, pfn_t start_pfn, pfn_t top_pfn)
 {
 	size_t table_size, npages, i;
 	struct mem_area *a;
@@ -437,7 +436,7 @@ static void _page_alloc_init_area(u8 n, uintptr_t start_pfn, uintptr_t top_pfn)
 
 	/* fill in the values of the new area */
 	a = areas + n;
-	a->page_states = (void *)(start_pfn << PAGE_SHIFT);
+	a->page_states = pfn_to_virt(start_pfn);
 	a->base = start_pfn + table_size;
 	a->top = top_pfn;
 	npages = top_pfn - a->base;
@@ -447,14 +446,14 @@ static void _page_alloc_init_area(u8 n, uintptr_t start_pfn, uintptr_t top_pfn)
 	for (i = 0; i < MAX_AREAS; i++) {
 		if (!(areas_mask & BIT(i)))
 			continue;
-		assert(!area_or_metadata_contains(areas + i, start_pfn));
-		assert(!area_or_metadata_contains(areas + i, top_pfn - 1));
-		assert(!area_or_metadata_contains(a, PFN(areas[i].page_states)));
-		assert(!area_or_metadata_contains(a, areas[i].top - 1));
+		assert(!area_contains_pfn(areas + i, start_pfn));
+		assert(!area_contains_pfn(areas + i, top_pfn - 1));
+		assert(!area_contains_pfn(a, virt_to_pfn(areas[i].page_states)));
+		assert(!area_contains_pfn(a, areas[i].top - 1));
 	}
 	/* initialize all freelists for the new area */
 	for (i = 0; i < NLISTS; i++)
-		a->freelists[i].next = a->freelists[i].prev = a->freelists + i;
+		a->freelists[i].prev = a->freelists[i].next = a->freelists + i;
 
 	/* initialize the metadata for the available memory */
 	for (i = a->base; i < a->top; i += 1ull << order) {
@@ -473,13 +472,13 @@ static void _page_alloc_init_area(u8 n, uintptr_t start_pfn, uintptr_t top_pfn)
 		assert(order < NLISTS);
 		/* initialize the metadata and add to the freelist */
 		memset(a->page_states + (i - a->base), order, BIT(order));
-		list_add(a->freelists + order, (void *)(i << PAGE_SHIFT));
+		list_add(a->freelists + order, pfn_to_virt(i));
 	}
 	/* finally mark the area as present */
 	areas_mask |= BIT(n);
 }
 
-static void __page_alloc_init_area(u8 n, uintptr_t cutoff, uintptr_t base_pfn, uintptr_t *top_pfn)
+static void __page_alloc_init_area(u8 n, pfn_t cutoff, pfn_t base_pfn, pfn_t *top_pfn)
 {
 	if (*top_pfn > cutoff) {
 		spin_lock(&lock);
@@ -500,7 +499,7 @@ static void __page_alloc_init_area(u8 n, uintptr_t cutoff, uintptr_t base_pfn, u
  * Prerequisites:
  * see _page_alloc_init_area
  */
-void page_alloc_init_area(u8 n, uintptr_t base_pfn, uintptr_t top_pfn)
+void page_alloc_init_area(u8 n, phys_addr_t base_pfn, phys_addr_t top_pfn)
 {
 	if (n != AREA_ANY_NUMBER) {
 		__page_alloc_init_area(n, 0, base_pfn, &top_pfn);
-- 
2.26.2

