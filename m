Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938697348E
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfGXRFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 13:05:11 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35543 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfGXRFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 13:05:11 -0400
Received: by mail-io1-f68.google.com with SMTP id m24so91178615ioo.2;
        Wed, 24 Jul 2019 10:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=EdB1fvJ2UIfN9MK80DlB9EXRkbzZe2alnUINvp0mAD4=;
        b=SRMU+1pQKt24pMqH+pa3gHU8eL364E9EFYTcOdKATOeAAcmWmzZSq2WKXhUok6vUgj
         i8YbwHjJD5zBrRFIMg7N/a/G5O7mPy05sFtvlfyU3eu2TkToWYPKW1L1osbcW9B8tx+X
         /pW2BzPVEIiYKwtOIsr6D8LOgV0FA8FRE4S3w7vyxgBomroBhwO9VcA/6yZ9FAntUwyJ
         L4QtEwufdlYqzAEfnAnNUOM1JB9T/gswYpErwhaCoMCKZg3IpiJ6aKTDBtCG1AafX1Im
         Gt2u8M1GmJntlSACAS9X2XZ0jgDiX15XfkgrBWaAGXvWgxFmuqlL7w7yd7oo5az6BRc6
         DQwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EdB1fvJ2UIfN9MK80DlB9EXRkbzZe2alnUINvp0mAD4=;
        b=d2vjg/7+QpYdo81pS7YVvH27eQlsJGvZbaTjJG6Hzc60sVMfj2+f0ZGX7A/Oqz+eD2
         l4eAaKxyhAoLhrxM0LAULhYlhYjQSLNwTAu/0Os6T2EGXxjMzldDPPvuA82r/k2+TIoD
         1TehMAVSBjwtpwmozRyL/Ijowl+FbM7hSVPBlGBj7vzNQbsadiSS3qmXFt/ah3aGxjme
         llsCHU3w3GjvtuOx1Ydxc59eDmRDBQZWrInv6k/9ZO2dmp/zj0dSiuyO7ESb/cBMB3WZ
         fFcVY2EPuZg123zCq3FwHhV7Q8M+VmceZgMrbKBs8rRLFuWnQ5TvCBtsgMWlHhIdWvL3
         zuoA==
X-Gm-Message-State: APjAAAVA2EDWcRnTGRZ6B2S0FU1ByzJCsi/iIU922sLDbTRE+D9cCZUb
        PQaecZzUBVpE0LWSiexhIx4=
X-Google-Smtp-Source: APXvYqw4EWZ44teDYe7DqvveZv2Vd8v20RraEqD8LVP27seh3Q8jdSy0lppE0eMopwWz3JvOMmIG5g==
X-Received: by 2002:a02:b68f:: with SMTP id i15mr56624615jam.107.1563987909410;
        Wed, 24 Jul 2019 10:05:09 -0700 (PDT)
Received: from localhost.localdomain (50-39-177-61.bvtn.or.frontiernet.net. [50.39.177.61])
        by smtp.gmail.com with ESMTPSA id q13sm42456451ioh.36.2019.07.24.10.05.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 10:05:08 -0700 (PDT)
Subject: [PATCH v2 4/5] mm: Introduce Hinted pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 24 Jul 2019 10:03:00 -0700
Message-ID: <20190724170259.6685.18028.stgit@localhost.localdomain>
In-Reply-To: <20190724165158.6685.87228.stgit@localhost.localdomain>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

In order to pave the way for free page hinting in virtualized environments
we will need a way to get pages out of the free lists and identify those
pages after they have been returned. To accomplish this, this patch adds
the concept of a Hinted Buddy, which is essentially meant to just be the
Offline page type used in conjunction with the Buddy page type.

It adds a set of pointers we shall call "boundary" which represents the
upper boundary between the unhinted and hinted pages. The general idea is
that in order for a page to cross from one side of the boundary to the
other it will need to go through the hinting process. Ultimately a
free_list has been fully processed when the boundary has been moved from
the tail all they way up to occupying the first entry in the list.

Doing this we should be able to make certain that we keep the hinted
pages as one contiguous block in each free list. This will allow us to
efficiently manipulate the free lists whenever we need to go in and start
sending hints to the hypervisor that there are new pages that have been
freed and are no longer in use.

An added advantage to this approach is that we should be reducing the
overall memory footprint of the guest as it will be more likely to recycle
warm pages versus trying to allocate the hinted pages that were likely
evicted from the guest memory.

Since we will only be hinting one zone at a time we keep the boundary
limited to being defined for just the zone we are currently placing hinted
pages into. Doing this we can keep the number of additional pointers needed
quite small. To flag that the boundaries are in place we use a single bit
in the zone to indicate that hinting and the boundaries are active.

The determination of when to start hinting is based on the tracking of the
number of free pages in a given area versus the number of hinted pages in
that area. We keep track of the number of hinted pages per free_area in a
separate zone specific area. We do this to avoid modifying the free_area
structure as this can lead to false sharing for the highest order with the
zone lock which leads to a noticeable performance degradation.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h       |   40 +++++-
 include/linux/page-flags.h   |    8 +
 include/linux/page_hinting.h |  139 ++++++++++++++++++++
 mm/Kconfig                   |    5 +
 mm/Makefile                  |    1 
 mm/memory_hotplug.c          |    1 
 mm/page_alloc.c              |  136 ++++++++++++++++++-
 mm/page_hinting.c            |  298 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 620 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/page_hinting.h
 create mode 100644 mm/page_hinting.c

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f0c68b6b6154..42bdebb20484 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -460,6 +460,14 @@ struct zone {
 	seqlock_t		span_seqlock;
 #endif
 
+#ifdef CONFIG_PAGE_HINTING
+	/*
+	 * Pointer to hinted page tracking statistics array. The size of
+	 * the array is MAX_ORDER - PAGE_HINTING_MIN_ORDER. NULL when
+	 * page hinting is not present.
+	 */
+	unsigned long		*hinted_pages;
+#endif
 	int initialized;
 
 	/* Write-intensive fields used from the page allocator */
@@ -535,6 +543,14 @@ enum zone_flags {
 	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
 					 * Cleared when kswapd is woken.
 					 */
+	ZONE_PAGE_HINTING_REQUESTED,	/* zone enabled page hinting and has
+					 * requested flushing the data out of
+					 * higher order pages.
+					 */
+	ZONE_PAGE_HINTING_ACTIVE,	/* zone enabled page hinting and is
+					 * activly flushing the data out of
+					 * higher order pages.
+					 */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
@@ -755,6 +771,8 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
 	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
 }
 
+#include <linux/page_hinting.h>
+
 /* Used for pages not on another list */
 static inline void add_to_free_list(struct page *page, struct zone *zone,
 				    unsigned int order, int migratetype)
@@ -769,10 +787,16 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
 static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
 					 unsigned int order, int migratetype)
 {
-	struct free_area *area = &zone->free_area[order];
+	struct list_head *tail = get_unhinted_tail(zone, order, migratetype);
 
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	/*
+	 * To prevent the unhinted pages from being interleaved with the
+	 * hinted ones while we are actively processing pages we will use
+	 * the head of the hinted pages to determine the tail of the free
+	 * list.
+	 */
+	list_add_tail(&page->lru, tail);
+	zone->free_area[order].nr_free++;
 }
 
 /* Used for pages which are on another list */
@@ -781,12 +805,22 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 {
 	struct free_area *area = &zone->free_area[order];
 
+	/*
+	 * Clear Hinted flag, if present, to avoid placing hinted pages
+	 * at the top of the free_list. It is cheaper to just process this
+	 * page again, then have to walk around a page that is already hinted.
+	 */
+	clear_page_hinted(page, zone);
+
 	list_move(&page->lru, &area->free_list[migratetype]);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 					   unsigned int order)
 {
+	/* Clear Hinted flag, if present, before clearing the Buddy flag */
+	clear_page_hinted(page, zone);
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b848517da64c..b753dbf673cb 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -745,6 +745,14 @@ static inline int page_has_type(struct page *page)
 PAGE_TYPE_OPS(Offline, offline)
 
 /*
+ * PageHinted() is an alias for Offline, however it is not meant to be an
+ * exclusive value. It should be combined with PageBuddy() when seen as it
+ * is meant to indicate that the page has been scrubbed while waiting in
+ * the buddy system.
+ */
+PAGE_TYPE_OPS(Hinted, offline)
+
+/*
  * If kmemcg is enabled, the buddy allocator will set PageKmemcg() on
  * pages allocated with __GFP_ACCOUNT. It gets cleared on page free.
  */
diff --git a/include/linux/page_hinting.h b/include/linux/page_hinting.h
new file mode 100644
index 000000000000..526fb26663d9
--- /dev/null
+++ b/include/linux/page_hinting.h
@@ -0,0 +1,139 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PAGE_HINTING_H
+#define _LINUX_PAGE_HINTING_H
+
+#include <linux/mmzone.h>
+#include <linux/jump_label.h>
+#include <linux/pageblock-flags.h>
+#include <asm/pgtable_types.h>
+
+#define PAGE_HINTING_MIN_ORDER	pageblock_order
+#define PAGE_HINTING_HWM		32
+
+#ifdef CONFIG_PAGE_HINTING
+struct page_hinting_dev_info {
+	/* function that alters pages to make them "hinted" */
+	void (*react)(struct page_hinting_dev_info *phdev,
+		      unsigned int num_hints);
+
+	/* scatterlist containing pages to be processed */
+	struct scatterlist *sg;
+
+	/*
+	 * Upper limit on the number of pages that the react function
+	 * expects to be placed into the batch list to be processed.
+	 */
+	unsigned long capacity;
+
+	/* work struct for processing hints */
+	struct delayed_work work;
+
+	/*
+	 * The number of zones requesting hinting, plus one additional if
+	 * processing thread is active.
+	 */
+	atomic_t refcnt;
+};
+
+extern struct static_key page_hinting_notify_enabled;
+
+/* Boundary functions */
+struct list_head *__page_hinting_get_boundary(unsigned int order,
+					      int migratetype);
+void page_hinting_del_from_boundary(struct page *page, struct zone *zone);
+void page_hinting_add_to_boundary(struct page *page, struct zone *zone,
+			     int migratetype);
+
+/* Hinted page accessors, defined in page_alloc.c */
+struct page *get_unhinted_page(struct zone *zone, unsigned int order,
+			       int migratetype);
+void put_hinted_page(struct zone *zone, struct page *page);
+
+void __page_hinting_request(struct zone *zone);
+void __page_hinting_free_stats(struct zone *zone);
+
+/* Tear-down and bring-up for page hinting devices */
+void page_hinting_shutdown(struct page_hinting_dev_info *phdev);
+int page_hinting_startup(struct page_hinting_dev_info *phdev);
+#endif /* CONFIG_PAGE_HINTING */
+
+static inline struct list_head *get_unhinted_tail(struct zone *zone,
+						  unsigned int order,
+						  int migratetype)
+{
+#ifdef CONFIG_PAGE_HINTING
+	if (order >= PAGE_HINTING_MIN_ORDER &&
+	    test_bit(ZONE_PAGE_HINTING_ACTIVE, &zone->flags))
+		return __page_hinting_get_boundary(order, migratetype);
+#endif
+	return &zone->free_area[order].free_list[migratetype];
+}
+
+static inline void clear_page_hinted(struct page *page,
+				     struct zone *zone)
+{
+#ifdef CONFIG_PAGE_HINTING
+	if (likely(!PageHinted(page)))
+		return;
+
+	/* push boundary back if we removed the upper boundary */
+	if (test_bit(ZONE_PAGE_HINTING_ACTIVE, &zone->flags))
+		page_hinting_del_from_boundary(page, zone);
+
+	__ClearPageHinted(page);
+
+	/* page_private will contain the page order, so just use it directly */
+	zone->hinted_pages[page_private(page) - PAGE_HINTING_MIN_ORDER]--;
+#endif
+}
+
+/* Free hinted_pages and reset hinted page tracking count to 0 */
+static inline void page_hinting_reset(struct zone *zone)
+{
+#ifdef CONFIG_PAGE_HINTING
+	if (zone->hinted_pages)
+		__page_hinting_free_stats(zone);
+#endif
+}
+
+/**
+ * page_hinting_notify_free - Free page notification to start page processing
+ * @zone: Pointer to current zone of last page processed
+ * @order: Order of last page added to zone
+ *
+ * This function is meant to act as a screener for __page_hinting_request which
+ * will determine if a give zone has crossed over the high-water mark that
+ * will justify us beginning page treatment. If we have crossed that
+ * threshold then it will start the process of pulling some pages and
+ * placing them in the batch list for treatment.
+ */
+static inline void page_hinting_notify_free(struct zone *zone, int order)
+{
+#ifdef CONFIG_PAGE_HINTING
+	unsigned long nr_hinted;
+
+	/* Called from hot path in __free_one_page() */
+	if (!static_key_false(&page_hinting_notify_enabled))
+		return;
+
+	/* Limit notifications only to higher order pages */
+	if (order < PAGE_HINTING_MIN_ORDER)
+		return;
+
+	/* Do not bother with tests if we have already requested hinting */
+	if (test_bit(ZONE_PAGE_HINTING_REQUESTED, &zone->flags))
+		return;
+
+	/* If hinted_pages is not populated, assume 0 */
+	nr_hinted = zone->hinted_pages ?
+		    zone->hinted_pages[order - PAGE_HINTING_MIN_ORDER] : 0;
+
+	/* Only request it if we have enough to begin the page hinting */
+	if (zone->free_area[order].nr_free < nr_hinted + PAGE_HINTING_HWM)
+		return;
+
+	/* This is slow, but should be called very rarely */
+	__page_hinting_request(zone);
+#endif
+}
+#endif /*_LINUX_PAGE_HINTING_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 56cec636a1fc..38354668f849 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -237,6 +237,11 @@ config COMPACTION
           linux-mm@kvack.org.
 
 #
+# support for free page hinting
+config PAGE_HINTING
+	bool
+
+#
 # support for page migration
 #
 config MIGRATION
diff --git a/mm/Makefile b/mm/Makefile
index 338e528ad436..7277ced923ab 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
+obj-$(CONFIG_PAGE_HINTING) += page_hinting.o
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a9bbddb0e55..7c2d49b1a918 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1622,6 +1622,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
+		page_hinting_reset(zone);
 	} else
 		zone_pcp_update(zone);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9a73f69b37af..c83cb4a30aff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -68,6 +68,7 @@
 #include <linux/lockdep.h>
 #include <linux/nmi.h>
 #include <linux/psi.h>
+#include <linux/page_hinting.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -915,7 +916,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool hinted)
 {
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
@@ -990,11 +991,20 @@ static inline void __free_one_page(struct page *page,
 done_merging:
 	set_page_order(page, order);
 
-	if (is_shuffle_order(order) ? shuffle_add_to_tail() :
-	    buddy_merge_likely(pfn, buddy_pfn, page, order))
+	if (hinted ||
+	    (is_shuffle_order(order) ? shuffle_add_to_tail() :
+	     buddy_merge_likely(pfn, buddy_pfn, page, order)))
 		add_to_free_list_tail(page, zone, order, migratetype);
 	else
 		add_to_free_list(page, zone, order, migratetype);
+
+	/*
+	 * No need to notify on a hinted page as the total count of
+	 * unhinted pages will not have increased since we have essentially
+	 * merged the hinted page with one or more unhinted pages.
+	 */
+	if (!hinted)
+		page_hinting_notify_free(zone, order);
 }
 
 /*
@@ -1305,7 +1315,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, false);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1321,7 +1331,7 @@ static void free_one_page(struct zone *zone,
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype, false);
 	spin_unlock(&zone->lock);
 }
 
@@ -2183,6 +2193,122 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	return NULL;
 }
 
+#ifdef CONFIG_PAGE_HINTING
+/**
+ * get_unhinted_page - Pull an unhinted page from the free_list
+ * @zone: Zone to draw pages from
+ * @order: Order to draw pages from
+ * @mt: Migratetype to draw pages from
+ *
+ * This function will obtain a page from the free list. It will start by
+ * attempting to pull from the tail of the free list and if that is already
+ * hinted on it will instead pull the head if that is unhinted.
+ *
+ * The page will have the migrate type and order stored in the page
+ * metadata. While being processed the page will not be avaialble for
+ * allocation.
+ *
+ * Return: page pointer if raw page found, otherwise NULL
+ */
+struct page *get_unhinted_page(struct zone *zone, unsigned int order, int mt)
+{
+	struct list_head *tail = get_unhinted_tail(zone, order, mt);
+	struct free_area *area = &(zone->free_area[order]);
+	struct list_head *list = &area->free_list[mt];
+	struct page *page;
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	/* Find a page of the appropriate size in the preferred list */
+	page = list_last_entry(tail, struct page, lru);
+	list_for_each_entry_from_reverse(page, list, lru) {
+		/* If we entered this loop then the "raw" list isn't empty */
+
+		/* If the page is hinted try the head of the list */
+		if (PageHinted(page)) {
+			page = list_first_entry(list, struct page, lru);
+
+			/*
+			 * If both the head and tail are hinted then reset
+			 * the boundary so that we read as an empty list
+			 * next time and bail out.
+			 */
+			if (PageHinted(page)) {
+				page_hinting_add_to_boundary(page, zone, mt);
+				break;
+			}
+		}
+
+		del_page_from_free_list(page, zone, order);
+
+		/* record migratetype and order within page */
+		set_pcppage_migratetype(page, mt);
+		set_page_private(page, order);
+
+		/*
+		 * Page will not be available for allocation while we are
+		 * processing it so update the freepage state.
+		 */
+		__mod_zone_freepage_state(zone, -(1 << order), mt);
+
+		return page;
+	}
+
+	return NULL;
+}
+
+/**
+ * put_hinted_page - Return a now-hinted page back where we got it
+ * @zone: Zone to return pages to
+ * @page: Page that was hinted
+ *
+ * This function will pull the migratetype and order information out
+ * of the page and attempt to return it where it found it. If the page
+ * is added to the free list without changes we will mark it as being
+ * hinted.
+ */
+void put_hinted_page(struct zone *zone, struct page *page)
+{
+	unsigned int order, mt;
+	unsigned long pfn;
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	mt = get_pcppage_migratetype(page);
+	pfn = page_to_pfn(page);
+
+	if (unlikely(has_isolate_pageblock(zone) || is_migrate_isolate(mt))) {
+		mt = get_pfnblock_migratetype(page, pfn);
+		set_pcppage_migratetype(page, mt);
+	}
+
+	order = page_private(page);
+	set_page_private(page, 0);
+
+	__free_one_page(page, pfn, zone, order, mt, true);
+
+	/*
+	 * If page was comingled with another page we cannot consider
+	 * the result to be "hinted" since part of the page hasn't been.
+	 * In this case we will simply exit and not update the "hinted"
+	 * state. Instead just treat the result as a unhinted page.
+	 */
+	if (!PageBuddy(page) || page_order(page) != order)
+		return;
+
+	/* update areated page accounting */
+	zone->hinted_pages[order - PAGE_HINTING_MIN_ORDER]++;
+
+	/* update boundary of new migratetype and record it */
+	page_hinting_add_to_boundary(page, zone, mt);
+
+	/* flag page as hinted */
+	__SetPageHinted(page);
+}
+#endif /* CONFIG_PAGE_HINTING */
+
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
diff --git a/mm/page_hinting.c b/mm/page_hinting.c
new file mode 100644
index 000000000000..d06d3762b315
--- /dev/null
+++ b/mm/page_hinting.c
@@ -0,0 +1,298 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/page-isolation.h>
+#include <linux/gfp.h>
+#include <linux/export.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include "internal.h"
+
+static struct page_hinting_dev_info __rcu *ph_dev_info __read_mostly;
+struct static_key page_hinting_notify_enabled;
+
+struct list_head *boundary[MAX_ORDER - PAGE_HINTING_MIN_ORDER][MIGRATE_TYPES];
+
+static void page_hinting_reset_boundary(struct zone *zone, unsigned int order,
+				   unsigned int migratetype)
+{
+	boundary[order - PAGE_HINTING_MIN_ORDER][migratetype] =
+			&zone->free_area[order].free_list[migratetype];
+}
+
+#define for_each_hinting_migratetype_order(_order, _type) \
+	for (_order = MAX_ORDER; _order-- != PAGE_HINTING_MIN_ORDER;) \
+		for (_type = MIGRATE_TYPES; _type--;)
+
+static int page_hinting_populate_metadata(struct zone *zone)
+{
+	unsigned int order, mt;
+
+	/*
+	 * We need to make sure we have somewhere to store the tracking
+	 * data for how many hinted pages are in the zone. To do that
+	 * we need to make certain zone->hinted_pages is populated.
+	 */
+	if (!zone->hinted_pages) {
+		zone->hinted_pages = kcalloc(MAX_ORDER - PAGE_HINTING_MIN_ORDER,
+					     sizeof(unsigned long),
+					     GFP_KERNEL);
+		if (!zone->hinted_pages)
+			return -ENOMEM;
+	}
+
+	/* Update boundary data to reflect the zone we are currently working */
+	for_each_hinting_migratetype_order(order, mt)
+		page_hinting_reset_boundary(zone, order, mt);
+
+	return 0;
+}
+
+struct list_head *__page_hinting_get_boundary(unsigned int order,
+					      int migratetype)
+{
+	return boundary[order - PAGE_HINTING_MIN_ORDER][migratetype];
+}
+
+void page_hinting_del_from_boundary(struct page *page, struct zone *zone)
+{
+	unsigned int order = page_private(page) - PAGE_HINTING_MIN_ORDER;
+	int mt = get_pcppage_migratetype(page);
+	struct list_head **tail = &boundary[order][mt];
+
+	if (*tail == &page->lru)
+		*tail = page->lru.next;
+}
+
+void page_hinting_add_to_boundary(struct page *page, struct zone *zone,
+			     int migratetype)
+{
+	unsigned int order = page_private(page) - PAGE_HINTING_MIN_ORDER;
+	struct list_head **tail = &boundary[order][migratetype];
+
+	*tail = &page->lru;
+}
+
+static unsigned int page_hinting_fill(struct zone *zone,
+				      struct page_hinting_dev_info *phdev)
+{
+	struct scatterlist *sg = phdev->sg;
+	unsigned int order, mt, count = 0;
+
+	sg_init_table(phdev->sg, phdev->capacity);
+
+	for_each_hinting_migratetype_order(order, mt) {
+		struct page *page;
+
+		/*
+		 * Pull pages from free list until we have drained
+		 * it or we have reached capacity.
+		 */
+		while ((page = get_unhinted_page(zone, order, mt))) {
+			sg_set_page(&sg[count], page, PAGE_SIZE << order, 0);
+
+			if (++count == phdev->capacity)
+				return count;
+		}
+	}
+
+	/* mark end of scatterlist due to underflow */
+	if (count)
+		sg_mark_end(&sg[count - 1]);
+
+	/*
+	 * If there are no longer enough free pages to fully populate
+	 * the scatterlist, then we can just shut it down for this zone.
+	 */
+	clear_bit(ZONE_PAGE_HINTING_REQUESTED, &zone->flags);
+	atomic_dec(&phdev->refcnt);
+
+	return count;
+}
+
+static void page_hinting_drain(struct zone *zone,
+			       struct page_hinting_dev_info *phdev)
+{
+	struct scatterlist *sg = phdev->sg;
+
+	/*
+	 * Drain the now hinted pages back into their respective
+	 * free lists/areas. We assume at least one page is populated.
+	 */
+	do {
+		put_hinted_page(zone, sg_page(sg));
+	} while (!sg_is_last(sg++));
+}
+
+/*
+ * The page hinting cycle consists of 4 stages, fill, react, drain, and idle.
+ * We will cycle through the first 3 stages until we fail to obtain any
+ * pages, in that case we will switch to idle.
+ */
+static void page_hinting_cycle(struct zone *zone,
+			       struct page_hinting_dev_info *phdev)
+{
+	/*
+	 * Guarantee boundaries and stats are populated before we
+	 * start placing hinted pages in the zone.
+	 */
+	if (page_hinting_populate_metadata(zone))
+		return;
+
+	spin_lock(&zone->lock);
+
+	/* set bit indicating boundaries are present */
+	set_bit(ZONE_PAGE_HINTING_ACTIVE, &zone->flags);
+
+	do {
+		/* Pull pages out of allocator into a scaterlist */
+		unsigned int num_hints = page_hinting_fill(zone, phdev);
+
+		/* no pages were acquired, give up */
+		if (!num_hints)
+			break;
+
+		spin_unlock(&zone->lock);
+
+		/* begin processing pages in local list */
+		phdev->react(phdev, num_hints);
+
+		spin_lock(&zone->lock);
+
+		/*
+		 * We should have a scatterlist of pages that have been
+		 * processed. Return them to their original free lists.
+		 */
+		page_hinting_drain(zone, phdev);
+
+		/* keep pulling pages till there are none to pull */
+	} while (test_bit(ZONE_PAGE_HINTING_REQUESTED, &zone->flags));
+
+	/* processing of the zone is complete, we can disable boundaries */
+	clear_bit(ZONE_PAGE_HINTING_ACTIVE, &zone->flags);
+
+	spin_unlock(&zone->lock);
+}
+
+static void page_hinting_process(struct work_struct *work)
+{
+	struct delayed_work *d_work = to_delayed_work(work);
+	struct page_hinting_dev_info *phdev =
+		container_of(d_work, struct page_hinting_dev_info, work);
+	struct zone *zone = first_online_pgdat()->node_zones;
+
+	do {
+		if (test_bit(ZONE_PAGE_HINTING_REQUESTED, &zone->flags))
+			page_hinting_cycle(zone, phdev);
+
+		/*
+		 * Move to next zone, if at the end of the list
+		 * test to see if we can just go into idle.
+		 */
+		zone = next_zone(zone);
+		if (zone)
+			continue;
+		zone = first_online_pgdat()->node_zones;
+
+		/*
+		 * As long as refcnt has not reached zero there are still
+		 * zones to be processed.
+		 */
+	} while (atomic_read(&phdev->refcnt));
+}
+
+/* request page hinting on this zone */
+void __page_hinting_request(struct zone *zone)
+{
+	struct page_hinting_dev_info *phdev;
+
+	rcu_read_lock();
+
+	/*
+	 * We use RCU to protect the ph_dev_info pointer. In almost all
+	 * cases this should be present, however in the unlikely case of
+	 * a shutdown this will be NULL and we should exit.
+	 */
+	phdev = rcu_dereference(ph_dev_info);
+	if (unlikely(!phdev))
+		return;
+
+	/*
+	 * We can use separate test and set operations here as there
+	 * is nothing else that can set or clear this bit while we are
+	 * holding the zone lock. The advantage to doing it this way is
+	 * that we don't have to dirty the cacheline unless we are
+	 * changing the value.
+	 */
+	set_bit(ZONE_PAGE_HINTING_REQUESTED, &zone->flags);
+
+	/*
+	 * Delay the start of work to allow a sizable queue to
+	 * build. For now we are limiting this to running no more
+	 * than 10 times per second.
+	 */
+	if (!atomic_fetch_inc(&phdev->refcnt))
+		schedule_delayed_work(&phdev->work, HZ / 10);
+
+	rcu_read_unlock();
+}
+
+void __page_hinting_free_stats(struct zone *zone)
+{
+	/* free hinted_page statisitics */
+	kfree(zone->hinted_pages);
+	zone->hinted_pages = NULL;
+}
+
+void page_hinting_shutdown(struct page_hinting_dev_info *phdev)
+{
+	if (rcu_access_pointer(ph_dev_info) != phdev)
+		return;
+
+	/* Disable page hinting notification */
+	static_key_slow_dec(&page_hinting_notify_enabled);
+	RCU_INIT_POINTER(ph_dev_info, NULL);
+	synchronize_rcu();
+
+	/* Flush any existing work, and lock it out */
+	cancel_delayed_work_sync(&phdev->work);
+
+	/* Free scatterlist */
+	kfree(phdev->sg);
+	phdev->sg = NULL;
+}
+EXPORT_SYMBOL_GPL(page_hinting_shutdown);
+
+int page_hinting_startup(struct page_hinting_dev_info *phdev)
+{
+	struct zone *zone;
+
+	/* nothing to do if already in use */
+	if (rcu_access_pointer(ph_dev_info))
+		return -EBUSY;
+
+	/* allocate scatterlist to store pages being hinted on */
+	phdev->sg = kcalloc(phdev->capacity, sizeof(*phdev->sg), GFP_KERNEL);
+	if (!phdev->sg)
+		return -ENOMEM;
+
+	/* initialize refcnt and work structures */
+	atomic_set(&phdev->refcnt, 0);
+	INIT_DELAYED_WORK(&phdev->work, &page_hinting_process);
+
+	/* assign device, and begin initial flush of populated zones */
+	rcu_assign_pointer(ph_dev_info, phdev);
+	for_each_populated_zone(zone) {
+		spin_lock(&zone->lock);
+		__page_hinting_request(zone);
+		spin_unlock(&zone->lock);
+	}
+
+	/* enable page hinting notification */
+	static_key_slow_inc(&page_hinting_notify_enabled);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(page_hinting_startup);
+

