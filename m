Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5385E0E2E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 00:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbfJVW2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 18:28:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44995 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732315AbfJVW2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 18:28:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so10808899pgd.11;
        Tue, 22 Oct 2019 15:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=cMLKWvd+XSVk8vcJzmDS4ZebqyOUlSSmVL1gEH1L88Y=;
        b=WfeQbe49JL9HGLm1BzwXVGoCbugxwGwRHIaER6OSeOfgdIcjpoz1OKRugsrFYuaDau
         /B84g6uRZrHnF4LdeGKTjpa/FfWrjxaV25dhKLE05lZznPfN+jR8PUyXbgEuYkRSxGNq
         7S1mr1Y/14jOLVUj/D1uzqGNmOG1Dg9uoqUagg2q4GjxuY3N3Yn3GzXO4LoQCtEEKZ/M
         t34SpJ7KyQ1kYb87SJNas2gKH72JKb8MbqsOz41LzhVf1zXoXiexIwqOg8Rl8F9htVqm
         ng7IyVTcHtkh3/XNFWIEB8zmn50lfArkQSM0RSj84G5Uirj4JMXPKjENuk/tZNhPYvcf
         ewlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cMLKWvd+XSVk8vcJzmDS4ZebqyOUlSSmVL1gEH1L88Y=;
        b=VmLVjMvtZuNpkDcmZ94bfNsGr3kLr2YRQBwlVf2DMAzaMNcb0PcAt/50J0DBkuKmfp
         9tywLPipUnSl7yIwTTssLtbelUtIoczkG1Wyg3Wb7qzJNJAnvWolsNxl0eXpOl9oBv9a
         XX9R2RxOpEdKdTvjP3X3A/Q4Y2ZTA/NT2XM/26VWJ7nFzx6nGecaTvJcVDOhhuTxUYWg
         67CLXkUtKpVaL6HmIJiTDnAzPJXq1DoCCmwFwU69ci/B0+bal+zyw6GB0RFYowKgJKN3
         QwwTEbpJFUjex888k4R+4aAyXE3Vg8gqFJFf7+hB3zUuL9vRyKRKfW/9b7TQDnikQuYZ
         fOAg==
X-Gm-Message-State: APjAAAVWmO9FN3m+TYIOzRKaTVNPeKGAq6HEwiUu+W/nfJuCRTChDSKV
        YxgX6ZvvILZ/5qS+jnsr9f0=
X-Google-Smtp-Source: APXvYqwdY0L9Vl1MlgabU8BK5mLJQ/8O2l2oqznEzek+vm5+jUvCdbOMBwzS8jViC5N4tyN5jV2/nA==
X-Received: by 2002:a17:90a:ba8d:: with SMTP id t13mr7512378pjr.129.1571783293393;
        Tue, 22 Oct 2019 15:28:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id x20sm26495459pfp.120.2019.10.22.15.28.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 15:28:12 -0700 (PDT)
Subject: [PATCH v12 3/6] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Tue, 22 Oct 2019 15:28:12 -0700
Message-ID: <20191022222812.17338.49450.stgit@localhost.localdomain>
In-Reply-To: <20191022221223.17338.5860.stgit@localhost.localdomain>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

In order to pave the way for free page reporting in virtualized
environments we will need a way to get pages out of the free lists and
identify those pages after they have been returned. To accomplish this,
this patch adds the concept of a Reported Buddy, which is essentially
meant to just be the Uptodate flag used in conjunction with the Buddy
page type.

It adds a set of pointers we shall call "reported_boundary" which
represent the upper boundary between the unreported and reported pages.
The general idea is that in order for a page to cross from one side of the
boundary to the other it will need to verify that it went through the
reporting process. Ultimately a free list has been fully processed when
the boundary has been moved from the tail all they way up to occupying the
first entry in the list. Without this we would have to manually walk the
entire page list until we have find a page that hasn't been reported. In my
testing this adds as much as 18% additional overhead which would make this
unattractive as a solution.

One limitation to this approach is that it is essentially a linear search
and in the case of the free lists we can have pages added to either the
head or the tail of the list. In order to place limits on this we only
allow pages to be added before the reported_boundary instead of adding
to the tail itself. An added advantage to this approach is that we should
be reducing the overall memory footprint of the guest as it will be more
likely to recycle warm pages versus trying to allocate the reported pages
that were likely evicted from the guest memory.

Since we will only be reporting one zone at a time we keep the boundary
limited to being defined for just the zone we are currently reporting pages
from. Doing this we can keep the number of additional pointers needed quite
small. To flag that the boundaries are in place we use a single bit
in the zone to indicate that reporting and the boundaries are active.

We store the index of the boundary pointer used to track the reported page
in the page->index value. Doing this we can avoid unnecessary computation
to determine the index value again. There should be no issues with this as
the value is unused when the page is in the buddy allocator, and is reset
as soon as the page is removed from the free list.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h     |   16 ++++
 include/linux/page-flags.h |   11 +++
 mm/Kconfig                 |   11 +++
 mm/compaction.c            |    5 +
 mm/memory_hotplug.c        |    2 +
 mm/page_alloc.c            |   66 +++++++++++++++--
 mm/page_reporting.h        |  176 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 280 insertions(+), 7 deletions(-)
 create mode 100644 mm/page_reporting.h

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index da289a3f8c5e..5ab34fab760e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -470,6 +470,14 @@ struct zone {
 	seqlock_t		span_seqlock;
 #endif
 
+#ifdef CONFIG_PAGE_REPORTING
+	/*
+	 * Pointer to reported page tracking statistics array. The size of
+	 * the array is MAX_ORDER - PAGE_REPORTING_MIN_ORDER. NULL when
+	 * unused page reporting is not present.
+	 */
+	unsigned long		*reported_pages;
+#endif
 	int initialized;
 
 	/* Write-intensive fields used from the page allocator */
@@ -545,6 +553,14 @@ enum zone_flags {
 	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
 					 * Cleared when kswapd is woken.
 					 */
+	ZONE_PAGE_REPORTING_ACTIVE,	/* zone enabled page reporting and is
+					 * actively flushing the data out of
+					 * higher order pages.
+					 */
+	ZONE_PAGE_REPORTING_REQUESTED,	/* zone enabled page reporting and has
+					 * requested flushing the data out of
+					 * higher order pages.
+					 */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f91cb8898ff0..759a3b3956f2 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -163,6 +163,9 @@ enum pageflags {
 
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
+
+	/* Buddy pages. Used to track which pages have been reported */
+	PG_reported = PG_uptodate,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -432,6 +435,14 @@ static inline bool set_hwpoison_free_buddy_page(struct page *page)
 #endif
 
 /*
+ * PageReported() is used to track reported free pages within the Buddy
+ * allocator. We can use the non-atomic version of the test and set
+ * operations as both should be shielded with the zone lock to prevent
+ * any possible races on the setting or clearing of the bit.
+ */
+__PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
+
+/*
  * On an anonymous page mapped into a user virtual memory area,
  * page->mapping points to its anon_vma, not to a struct address_space;
  * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
diff --git a/mm/Kconfig b/mm/Kconfig
index a5dae9a7eb51..0419b2a9be3e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -237,6 +237,17 @@ config COMPACTION
           linux-mm@kvack.org.
 
 #
+# support for unused page reporting
+config PAGE_REPORTING
+	bool "Allow for reporting of unused pages"
+	def_bool n
+	help
+	  Unused page reporting allows for the incremental acquisition of
+	  unused pages from the buddy allocator for the purpose of reporting
+	  those pages to another entity, such as a hypervisor, so that the
+	  memory can be freed up for other uses.
+
+#
 # support for page migration
 #
 config MIGRATION
diff --git a/mm/compaction.c b/mm/compaction.c
index 672d3c78c6ab..d20816b21b55 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include "internal.h"
+#include "page_reporting.h"
 
 #ifdef CONFIG_COMPACTION
 static inline void count_compact_event(enum vm_event_item item)
@@ -1326,6 +1327,8 @@ static int next_search_order(struct compact_control *cc, int order)
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
+		page_reporting_free_area_release(cc->zone, order,
+						 MIGRATE_MOVABLE);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
 		list_for_each_entry_reverse(freepage, freelist, lru) {
 			unsigned long pfn;
@@ -1682,6 +1685,8 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
+		page_reporting_free_area_release(cc->zone, order,
+						 MIGRATE_MOVABLE);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
 		list_for_each_entry(freepage, freelist, lru) {
 			unsigned long free_pfn;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 5e6b2a312362..aa86669ebcc5 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -41,6 +41,7 @@
 
 #include "internal.h"
 #include "shuffle.h"
+#include "page_reporting.h"
 
 /*
  * online_page_callback contains pointer to current page onlining function.
@@ -1558,6 +1559,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
+		page_reporting_reset_zone(zone);
 	} else
 		zone_pcp_update(zone);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ea11c6f65157..f67846101bb6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -74,6 +74,7 @@
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
+#include "page_reporting.h"
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
@@ -891,10 +892,15 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
 static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
 					 unsigned int order, int migratetype)
 {
-	struct free_area *area = &zone->free_area[order];
+	struct list_head *tail = get_unreported_tail(zone, order, migratetype);
 
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	/*
+	 * To prevent the unreported pages from slipping behind our iterator
+	 * we will force them to be inserted in front of it. By doing this
+	 * we should only need to make one pass through the freelist.
+	 */
+	list_add_tail(&page->lru, tail);
+	zone->free_area[order].nr_free++;
 }
 
 /* Used for pages which are on another list */
@@ -903,12 +909,20 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 {
 	struct free_area *area = &zone->free_area[order];
 
+	/* Make certain the page isn't occupying the boundary */
+	if (page_is_reported(page))
+		__del_page_from_reported_list(page, zone);
+
 	list_move(&page->lru, &area->free_list[migratetype]);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 					   unsigned int order)
 {
+	/* remove page from reported list, and clear reported state */
+	if (page_is_reported(page))
+		del_page_from_reported_list(page, zone, order);
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
@@ -972,7 +986,7 @@ static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool reported)
 {
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
@@ -1048,7 +1062,9 @@ static inline void __free_one_page(struct page *page,
 done_merging:
 	set_page_order(page, order);
 
-	if (is_shuffle_order(order))
+	if (reported)
+		to_tail = true;
+	else if (is_shuffle_order(order))
 		to_tail = shuffle_pick_tail();
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
@@ -1373,7 +1389,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, false);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1389,7 +1405,7 @@ static void free_one_page(struct zone *zone,
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype, false);
 	spin_unlock(&zone->lock);
 }
 
@@ -2259,6 +2275,42 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	return NULL;
 }
 
+#ifdef CONFIG_PAGE_REPORTING
+struct list_head **reported_boundary __read_mostly;
+
+/**
+ * free_reported_page - Return a now-reported page back where we got it
+ * @page: Page that was reported
+ * @order: Order of the reported page
+ *
+ * This function will pull the migratetype and order information out
+ * of the page and attempt to return it where it found it. If the page
+ * is added to the free list without changes we will mark it as being
+ * reported.
+ */
+void free_reported_page(struct page *page, unsigned int order)
+{
+	struct zone *zone = page_zone(page);
+	unsigned long pfn;
+	unsigned int mt;
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	pfn = page_to_pfn(page);
+	mt = get_pfnblock_migratetype(page, pfn);
+	__free_one_page(page, pfn, zone, order, mt, true);
+
+	/*
+	 * If page was not comingled with another page we can consider
+	 * the result to be "reported" since part of the page hasn't been
+	 * modified, otherwise we would need to report on the new larger
+	 * page.
+	 */
+	if (PageBuddy(page) && page_order(page) == order)
+		add_page_to_reported_list(page, zone, order, mt);
+}
+#endif /* CONFIG_PAGE_REPORTING */
 
 /*
  * This array describes the order lists are fallen back to when
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
new file mode 100644
index 000000000000..ee4d86daa089
--- /dev/null
+++ b/mm/page_reporting.h
@@ -0,0 +1,176 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_PAGE_REPORTING_H
+#define _MM_PAGE_REPORTING_H
+
+#include <linux/mmzone.h>
+#include <linux/pageblock-flags.h>
+#include <linux/page-isolation.h>
+#include <linux/jump_label.h>
+#include <linux/slab.h>
+#include <asm/pgtable.h>
+
+#define PAGE_REPORTING_MIN_ORDER	pageblock_order
+
+#ifdef CONFIG_PAGE_REPORTING
+/* Reported page accessors, defined in page_alloc.c */
+void free_reported_page(struct page *page, unsigned int order);
+
+#define page_is_reported(_page)	unlikely(PageReported(_page))
+
+/* Free reported_pages and reset reported page tracking count to 0 */
+static inline void page_reporting_reset_zone(struct zone *zone)
+{
+	kfree(zone->reported_pages);
+	zone->reported_pages = NULL;
+}
+
+/* Boundary functions */
+static inline pgoff_t
+get_reporting_index(unsigned int order, unsigned int migratetype)
+{
+	/*
+	 * We will only ever be dealing with pages greater-than or equal to
+	 * PAGE_REPORTING_MIN_ORDER. Since that is the case we can avoid
+	 * allocating unused space by limiting our index range to only the
+	 * orders that are supported for page reporting.
+	 */
+	return (order - PAGE_REPORTING_MIN_ORDER) * MIGRATE_TYPES + migratetype;
+}
+
+extern struct list_head **reported_boundary __read_mostly;
+
+static inline void
+page_reporting_reset_boundary(struct zone *zone, unsigned int order, int mt)
+{
+	int index;
+
+	if (order < PAGE_REPORTING_MIN_ORDER)
+		return;
+	if (!test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
+		return;
+
+	index = get_reporting_index(order, mt);
+	reported_boundary[index] = &zone->free_area[order].free_list[mt];
+}
+
+static inline void page_reporting_disable_boundaries(struct zone *zone)
+{
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	__clear_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags);
+}
+
+static inline void
+page_reporting_free_area_release(struct zone *zone, unsigned int order, int mt)
+{
+	page_reporting_reset_boundary(zone, order, mt);
+}
+
+/*
+ * Method for obtaining the tail of the free list. Using this allows for
+ * tail insertions of unreported pages into the region that is currently
+ * being scanned so as to avoid interleaving reported and unreported pages.
+ */
+static inline struct list_head *
+get_unreported_tail(struct zone *zone, unsigned int order, int migratetype)
+{
+	if (order >= PAGE_REPORTING_MIN_ORDER &&
+	    test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
+		return reported_boundary[get_reporting_index(order,
+							     migratetype)];
+
+	return &zone->free_area[order].free_list[migratetype];
+}
+
+/*
+ * Functions for adding/removing reported pages to the freelist.
+ * All of them expect the zone lock to be held to maintain
+ * consistency of the reported list as a subset of the free list.
+ */
+static inline void
+add_page_to_reported_list(struct page *page, struct zone *zone,
+			  unsigned int order, unsigned int mt)
+{
+	/*
+	 * Default to using index 0, this will be updated later if the zone
+	 * is still being processed.
+	 */
+	page->index = 0;
+
+	/* flag page as reported */
+	__SetPageReported(page);
+
+	/* update areated page accounting */
+	zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER]++;
+}
+
+static inline void page_reporting_pull_boundary(struct page *page)
+{
+	struct list_head **tail = &reported_boundary[page->index];
+
+	if (*tail == &page->lru)
+		*tail = page->lru.next;
+}
+
+static inline void
+__del_page_from_reported_list(struct page *page, struct zone *zone)
+{
+	/*
+	 * Since the page is being pulled from the list we need to update
+	 * the boundary, after that we can just update the index so that
+	 * the correct boundary will be checked in the future.
+	 */
+	if (test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
+		page_reporting_pull_boundary(page);
+}
+
+static inline void
+del_page_from_reported_list(struct page *page, struct zone *zone,
+			    unsigned int order)
+{
+	__del_page_from_reported_list(page, zone);
+
+	/* page_private will contain the page order, so just use it directly */
+	zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER]--;
+
+	/* clear the flag so we can report on it when it returns */
+	__ClearPageReported(page);
+}
+
+#else /* CONFIG_PAGE_REPORTING */
+#define page_is_reported(_page)	false
+
+static inline void page_reporting_reset_zone(struct zone *zone)
+{
+}
+
+static inline void
+page_reporting_free_area_release(struct zone *zone, unsigned int order, int mt)
+{
+}
+
+static inline struct list_head *
+get_unreported_tail(struct zone *zone, unsigned int order, int migratetype)
+{
+	return &zone->free_area[order].free_list[migratetype];
+}
+
+static inline void
+add_page_to_reported_list(struct page *page, struct zone *zone,
+			  int order, int migratetype)
+{
+}
+
+static inline void
+__del_page_from_reported_list(struct page *page, struct zone *zone)
+{
+}
+
+static inline void
+del_page_from_reported_list(struct page *page, struct zone *zone,
+			    unsigned int order)
+{
+}
+#endif /* CONFIG_PAGE_REPORTING */
+#endif /*_MM_PAGE_REPORTING_H */

