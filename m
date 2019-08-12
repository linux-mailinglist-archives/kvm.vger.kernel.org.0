Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039508A968
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 23:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfHLVdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 17:33:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36712 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfHLVdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 17:33:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id g4so1894035plo.3;
        Mon, 12 Aug 2019 14:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WW0uT2ahqseYD/ICutagrxfmYr6/0Asx9aPlWAKzD3s=;
        b=TglaDpjjRHZ+KsvRxEqknLEkWVAq94ftFgdutHNZpUYZf2g0uwc5xU73P+SaxJG8Bk
         EWl9NmetWTgPIDxM/NLB1uSlM5K+BZPM7YCCaUU3jnaifqCBJso3yJcI1Pnap3e9+Fqi
         NubKiYdLIpJbZc2QJzHhmvsoqFGDUAx3SrKjt5oezk9qtVsCSJsQkhs7SXf+Netbw3uh
         dQalyUbryRzuwcv74wNayKRr0bbtT5AyJ28Vb8DXjJ8Hg/86+jePFjrAaj8/TxJPplzN
         V7HvGmEe5zHRLH0Qp7xLQMWOt+WvsmB3jUo8F3/xIy7FDyFb3Xfh5d0m1PC1VJ+tRFcy
         BN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WW0uT2ahqseYD/ICutagrxfmYr6/0Asx9aPlWAKzD3s=;
        b=gVnITdtGtBO8lm3NxJQ0ddsqoUnzNGv5VKXQT7yYztYg2qD4AerGCaN2ktFDpWI1f5
         yFOEGrFjq3PrQOKHAJVtzDRZqgcDmq/BGNo2m9YhAguqtVEpAvUHauprW1xbuFClfo+5
         G3KgX7yhjcpJdayvv/RH8zxtwQiJz+wA+6OBkLPEcCl+qiTS7AQsYq7mOFQJdubEjnNb
         CvVQyi0yy0XhVUjIiieaP3GJ/yKFttGWQxGlcXSU6PP1zqTWd8UwC54N743gR0wk43lh
         aQJq4QqK1ZmaBdTftAIDUo4+Tnp5pPovJt2vsxzmyBl3L0n0kP0NBeIdZzLJCoIcI+4U
         iR/g==
X-Gm-Message-State: APjAAAXEyc+uhzGkd7PNW877NY5emm6pKAKoLeyChdrxF9PpYkmM/bQm
        9jyKnm+HgjuxHK9rGHkw6v0=
X-Google-Smtp-Source: APXvYqw+SeolP+DsjX5W0JmUtnDyCrxswFmu78E9ZMnw6VHhCq3mpeBsSm1NJFYz26MZ5vNfAgQsFw==
X-Received: by 2002:a17:902:fe86:: with SMTP id x6mr253510plm.73.1565645625176;
        Mon, 12 Aug 2019 14:33:45 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id p8sm4647847pfq.129.2019.08.12.14.33.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:33:44 -0700 (PDT)
Subject: [PATCH v5 4/6] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Mon, 12 Aug 2019 14:33:44 -0700
Message-ID: <20190812213344.22097.86213.stgit@localhost.localdomain>
In-Reply-To: <20190812213158.22097.30576.stgit@localhost.localdomain>
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
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

It adds a set of pointers we shall call "boundary" which represents the
upper boundary between the unreported and reported pages. The general idea
is that in order for a page to cross from one side of the boundary to the
other it will need to go through the reporting process. Ultimately a
free_list has been fully processed when the boundary has been moved from
the tail all they way up to occupying the first entry in the list.

Doing this we should be able to make certain that we keep the reported
pages as one contiguous block in each free list. This will allow us to
efficiently manipulate the free lists whenever we need to go in and start
sending reports to the hypervisor that there are new pages that have been
freed and are no longer in use.

An added advantage to this approach is that we should be reducing the
overall memory footprint of the guest as it will be more likely to recycle
warm pages versus trying to allocate the reported pages that were likely
evicted from the guest memory.

Since we will only be reporting one zone at a time we keep the boundary
limited to being defined for just the zone we are currently reporting pages
from. Doing this we can keep the number of additional pointers needed quite
small. To flag that the boundaries are in place we use a single bit
in the zone to indicate that reporting and the boundaries are active.

The determination of when to start reporting is based on the tracking of
the number of free pages in a given area versus the number of reported
pages in that area. We keep track of the number of reported pages per
free_area in a separate zone specific area. We do this to avoid modifying
the free_area structure as this can lead to false sharing for the highest
order with the zone lock which leads to a noticeable performance
degradation.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h         |   40 +++++
 include/linux/page-flags.h     |   11 +
 include/linux/page_reporting.h |  138 ++++++++++++++++++
 mm/Kconfig                     |    5 +
 mm/Makefile                    |    1 
 mm/memory_hotplug.c            |    1 
 mm/page_alloc.c                |  136 +++++++++++++++++-
 mm/page_reporting.c            |  308 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 632 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2f2b6f968ed3..b8ed926552b1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -462,6 +462,14 @@ struct zone {
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
@@ -537,6 +545,14 @@ enum zone_flags {
 	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
 					 * Cleared when kswapd is woken.
 					 */
+	ZONE_PAGE_REPORTING_REQUESTED,	/* zone enabled page reporting and has
+					 * requested flushing the data out of
+					 * higher order pages.
+					 */
+	ZONE_PAGE_REPORTING_ACTIVE,	/* zone enabled page reporting and is
+					 * activly flushing the data out of
+					 * higher order pages.
+					 */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
@@ -757,6 +773,8 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
 	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
 }
 
+#include <linux/page_reporting.h>
+
 /* Used for pages not on another list */
 static inline void add_to_free_list(struct page *page, struct zone *zone,
 				    unsigned int order, int migratetype)
@@ -771,10 +789,16 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
 static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
 					 unsigned int order, int migratetype)
 {
-	struct free_area *area = &zone->free_area[order];
+	struct list_head *tail = get_unreported_tail(zone, order, migratetype);
 
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	/*
+	 * To prevent the unreported pages from being interleaved with the
+	 * reported ones while we are actively processing pages we will use
+	 * the head of the reported pages to determine the tail of the free
+	 * list.
+	 */
+	list_add_tail(&page->lru, tail);
+	zone->free_area[order].nr_free++;
 }
 
 /* Used for pages which are on another list */
@@ -783,12 +807,22 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 {
 	struct free_area *area = &zone->free_area[order];
 
+	/*
+	 * Clear Hinted flag, if present, to avoid placing reported pages
+	 * at the top of the free_list. It is cheaper to just process this
+	 * page again than to walk around a page that is already reported.
+	 */
+	clear_page_reported(page, zone);
+
 	list_move(&page->lru, &area->free_list[migratetype]);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 					   unsigned int order)
 {
+	/* Clear Reported flag, if present, before resetting page type */
+	clear_page_reported(page, zone);
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
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
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
new file mode 100644
index 000000000000..498bde6ea764
--- /dev/null
+++ b/include/linux/page_reporting.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PAGE_REPORTING_H
+#define _LINUX_PAGE_REPORTING_H
+
+#include <linux/mmzone.h>
+#include <linux/jump_label.h>
+#include <linux/pageblock-flags.h>
+#include <asm/pgtable_types.h>
+
+#define PAGE_REPORTING_MIN_ORDER	pageblock_order
+#define PAGE_REPORTING_HWM		32
+
+#ifdef CONFIG_PAGE_REPORTING
+struct page_reporting_dev_info {
+	/* function that alters pages to make them "reported" */
+	void (*report)(struct page_reporting_dev_info *phdev,
+		       unsigned int nents);
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
+	/* work struct for processing reports */
+	struct delayed_work work;
+
+	/*
+	 * The number of zones requesting reporting, plus one additional if
+	 * processing thread is active.
+	 */
+	atomic_t refcnt;
+};
+
+extern struct static_key page_reporting_notify_enabled;
+
+/* Boundary functions */
+struct list_head *__page_reporting_get_boundary(unsigned int order,
+						int migratetype);
+void page_reporting_del_from_boundary(struct page *page, struct zone *zone);
+void page_reporting_add_to_boundary(struct page *page, struct zone *zone,
+				    int migratetype);
+
+/* Hinted page accessors, defined in page_alloc.c */
+struct page *get_unreported_page(struct zone *zone, unsigned int order,
+				 int migratetype);
+void put_reported_page(struct zone *zone, struct page *page);
+
+void __page_reporting_request(struct zone *zone);
+void __page_reporting_free_stats(struct zone *zone);
+
+/* Tear-down and bring-up for page reporting devices */
+void page_reporting_shutdown(struct page_reporting_dev_info *phdev);
+int page_reporting_startup(struct page_reporting_dev_info *phdev);
+#endif /* CONFIG_PAGE_REPORTING */
+
+static inline struct list_head *
+get_unreported_tail(struct zone *zone, unsigned int order, int migratetype)
+{
+#ifdef CONFIG_PAGE_REPORTING
+	if (order >= PAGE_REPORTING_MIN_ORDER &&
+	    test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
+		return __page_reporting_get_boundary(order, migratetype);
+#endif
+	return &zone->free_area[order].free_list[migratetype];
+}
+
+static inline void clear_page_reported(struct page *page,
+				     struct zone *zone)
+{
+#ifdef CONFIG_PAGE_REPORTING
+	if (likely(!PageReported(page)))
+		return;
+
+	/* push boundary back if we removed the upper boundary */
+	if (test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
+		page_reporting_del_from_boundary(page, zone);
+
+	__ClearPageReported(page);
+
+	/* page_private will contain the page order, so just use it directly */
+	zone->reported_pages[page_private(page) - PAGE_REPORTING_MIN_ORDER]--;
+#endif
+}
+
+/* Free reported_pages and reset reported page tracking count to 0 */
+static inline void page_reporting_reset(struct zone *zone)
+{
+#ifdef CONFIG_PAGE_REPORTING
+	if (zone->reported_pages)
+		__page_reporting_free_stats(zone);
+#endif
+}
+
+/**
+ * page_reporting_notify_free - Free page notification to start page processing
+ * @zone: Pointer to current zone of last page processed
+ * @order: Order of last page added to zone
+ *
+ * This function is meant to act as a screener for __page_reporting_request
+ * which will determine if a give zone has crossed over the high-water mark
+ * that will justify us beginning page treatment. If we have crossed that
+ * threshold then it will start the process of pulling some pages and
+ * placing them in the batch list for treatment.
+ */
+static inline void page_reporting_notify_free(struct zone *zone, int order)
+{
+#ifdef CONFIG_PAGE_REPORTING
+	unsigned long nr_reported;
+
+	/* Called from hot path in __free_one_page() */
+	if (!static_key_false(&page_reporting_notify_enabled))
+		return;
+
+	/* Limit notifications only to higher order pages */
+	if (order < PAGE_REPORTING_MIN_ORDER)
+		return;
+
+	/* Do not bother with tests if we have already requested reporting */
+	if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
+		return;
+
+	/* If reported_pages is not populated, assume 0 */
+	nr_reported = zone->reported_pages ?
+		    zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER] : 0;
+
+	/* Only request it if we have enough to begin the page reporting */
+	if (zone->free_area[order].nr_free < nr_reported + PAGE_REPORTING_HWM)
+		return;
+
+	/* This is slow, but should be called very rarely */
+	__page_reporting_request(zone);
+#endif
+}
+#endif /*_LINUX_PAGE_REPORTING_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 1c9698509273..daa8c45e2af4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -237,6 +237,11 @@ config COMPACTION
           linux-mm@kvack.org.
 
 #
+# support for unused page reporting
+config PAGE_REPORTING
+	bool
+
+#
 # support for page migration
 #
 config MIGRATION
diff --git a/mm/Makefile b/mm/Makefile
index d0b295c3b764..1e17ba0ed2f0 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -105,3 +105,4 @@ obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
+obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 5b8811945bbb..bd40beac293b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1612,6 +1612,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
+		page_reporting_reset(zone);
 	} else
 		zone_pcp_update(zone);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4b5812c3800e..d0d3fb12ba54 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -68,6 +68,7 @@
 #include <linux/lockdep.h>
 #include <linux/nmi.h>
 #include <linux/psi.h>
+#include <linux/page_reporting.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -915,7 +916,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool reported)
 {
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
@@ -990,11 +991,20 @@ static inline void __free_one_page(struct page *page,
 done_merging:
 	set_page_order(page, order);
 
-	if (is_shuffle_order(order) ? shuffle_add_to_tail() :
-	    buddy_merge_likely(pfn, buddy_pfn, page, order))
+	if (reported ||
+	    (is_shuffle_order(order) ? shuffle_add_to_tail() :
+	     buddy_merge_likely(pfn, buddy_pfn, page, order)))
 		add_to_free_list_tail(page, zone, order, migratetype);
 	else
 		add_to_free_list(page, zone, order, migratetype);
+
+	/*
+	 * No need to notify on a reported page as the total count of
+	 * unreported pages will not have increased since we have essentially
+	 * merged the reported page with one or more unreported pages.
+	 */
+	if (!reported)
+		page_reporting_notify_free(zone, order);
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
 
+#ifdef CONFIG_PAGE_REPORTING
+/**
+ * get_unreported_page - Pull an unreported page from the free_list
+ * @zone: Zone to draw pages from
+ * @order: Order to draw pages from
+ * @mt: Migratetype to draw pages from
+ *
+ * This function will obtain a page from the free list. It will start by
+ * attempting to pull from the tail of the free list and if that is already
+ * reported on it will instead pull the head if that is unreported.
+ *
+ * The page will have the migrate type and order stored in the page
+ * metadata. While being processed the page will not be avaialble for
+ * allocation.
+ *
+ * Return: page pointer if raw page found, otherwise NULL
+ */
+struct page *get_unreported_page(struct zone *zone, unsigned int order, int mt)
+{
+	struct list_head *tail = get_unreported_tail(zone, order, mt);
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
+		/* If the page is reported try the head of the list */
+		if (PageReported(page)) {
+			page = list_first_entry(list, struct page, lru);
+
+			/*
+			 * If both the head and tail are reported then reset
+			 * the boundary so that we read as an empty list
+			 * next time and bail out.
+			 */
+			if (PageReported(page)) {
+				page_reporting_add_to_boundary(page, zone, mt);
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
+ * put_reported_page - Return a now-reported page back where we got it
+ * @zone: Zone to return pages to
+ * @page: Page that was reported
+ *
+ * This function will pull the migratetype and order information out
+ * of the page and attempt to return it where it found it. If the page
+ * is added to the free list without changes we will mark it as being
+ * reported.
+ */
+void put_reported_page(struct zone *zone, struct page *page)
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
+	 * the result to be "reported" since part of the page hasn't been.
+	 * In this case we will simply exit and not update the "reported"
+	 * state. Instead just treat the result as a unreported page.
+	 */
+	if (!PageBuddy(page) || page_order(page) != order)
+		return;
+
+	/* update areated page accounting */
+	zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER]++;
+
+	/* update boundary of new migratetype and record it */
+	page_reporting_add_to_boundary(page, zone, mt);
+
+	/* flag page as reported */
+	__SetPageReported(page);
+}
+#endif /* CONFIG_PAGE_REPORTING */
+
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
new file mode 100644
index 000000000000..dafcd6259260
--- /dev/null
+++ b/mm/page_reporting.c
@@ -0,0 +1,308 @@
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
+static struct page_reporting_dev_info __rcu *ph_dev_info __read_mostly;
+struct static_key page_reporting_notify_enabled;
+
+struct list_head *boundary[MAX_ORDER - PAGE_REPORTING_MIN_ORDER][MIGRATE_TYPES];
+
+static void page_reporting_reset_boundary(struct zone *zone, unsigned int order,
+					  unsigned int migratetype)
+{
+	boundary[order - PAGE_REPORTING_MIN_ORDER][migratetype] =
+			&zone->free_area[order].free_list[migratetype];
+}
+
+#define for_each_reporting_migratetype_order(_order, _type) \
+	for (_order = MAX_ORDER; _order-- != PAGE_REPORTING_MIN_ORDER;) \
+		for (_type = MIGRATE_TYPES; _type--;) \
+			if (!is_migrate_cma(_type) && \
+			    !is_migrate_isolate(_type))
+
+static int page_reporting_populate_metadata(struct zone *zone)
+{
+	unsigned int order, mt;
+
+	/*
+	 * We need to make sure we have somewhere to store the tracking
+	 * data for how many reported pages are in the zone. To do that
+	 * we need to make certain zone->reported_pages is populated.
+	 */
+	if (!zone->reported_pages) {
+		zone->reported_pages =
+			kcalloc(MAX_ORDER - PAGE_REPORTING_MIN_ORDER,
+				sizeof(unsigned long),
+				GFP_KERNEL);
+		if (!zone->reported_pages)
+			return -ENOMEM;
+	}
+
+	/* Update boundary data to reflect the zone we are currently working */
+	for_each_reporting_migratetype_order(order, mt)
+		page_reporting_reset_boundary(zone, order, mt);
+
+	return 0;
+}
+
+struct list_head *__page_reporting_get_boundary(unsigned int order,
+						int migratetype)
+{
+	return boundary[order - PAGE_REPORTING_MIN_ORDER][migratetype];
+}
+
+void page_reporting_del_from_boundary(struct page *page, struct zone *zone)
+{
+	unsigned int order = page_private(page) - PAGE_REPORTING_MIN_ORDER;
+	int mt = get_pcppage_migratetype(page);
+	struct list_head **tail = &boundary[order][mt];
+
+	if (*tail == &page->lru)
+		*tail = page->lru.next;
+}
+
+void page_reporting_add_to_boundary(struct page *page, struct zone *zone,
+				    int migratetype)
+{
+	unsigned int order = page_private(page) - PAGE_REPORTING_MIN_ORDER;
+	struct list_head **tail = &boundary[order][migratetype];
+
+	*tail = &page->lru;
+}
+
+static unsigned int page_reporting_fill(struct zone *zone,
+					struct page_reporting_dev_info *phdev)
+{
+	struct scatterlist *sg = phdev->sg;
+	unsigned int order, mt, count = 0;
+
+	sg_init_table(phdev->sg, phdev->capacity);
+
+	for_each_reporting_migratetype_order(order, mt) {
+		struct page *page;
+
+		/*
+		 * Pull pages from free list until we have drained
+		 * it or we have reached capacity.
+		 */
+		while ((page = get_unreported_page(zone, order, mt))) {
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
+	__clear_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags);
+	atomic_dec(&phdev->refcnt);
+
+	return count;
+}
+
+static void page_reporting_drain(struct zone *zone,
+				 struct page_reporting_dev_info *phdev)
+{
+	struct scatterlist *sg = phdev->sg;
+
+	/*
+	 * Drain the now reported pages back into their respective
+	 * free lists/areas. We assume at least one page is populated.
+	 */
+	do {
+		put_reported_page(zone, sg_page(sg));
+	} while (!sg_is_last(sg++));
+}
+
+/*
+ * The page reporting cycle consists of 4 stages, fill, report, drain, and idle.
+ * We will cycle through the first 3 stages until we fail to obtain any
+ * pages, in that case we will switch to idle.
+ */
+static void page_reporting_cycle(struct zone *zone,
+				 struct page_reporting_dev_info *phdev)
+{
+	/*
+	 * Guarantee boundaries and stats are populated before we
+	 * start placing reported pages in the zone.
+	 */
+	if (page_reporting_populate_metadata(zone))
+		return;
+
+	spin_lock_irq(&zone->lock);
+
+	/* set bit indicating boundaries are present */
+	__set_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags);
+
+	do {
+		/* Pull pages out of allocator into a scaterlist */
+		unsigned int nents = page_reporting_fill(zone, phdev);
+
+		/* no pages were acquired, give up */
+		if (!nents)
+			break;
+
+		spin_unlock_irq(&zone->lock);
+
+		/* begin processing pages in local list */
+		phdev->report(phdev, nents);
+
+		spin_lock_irq(&zone->lock);
+
+		/*
+		 * We should have a scatterlist of pages that have been
+		 * processed. Return them to their original free lists.
+		 */
+		page_reporting_drain(zone, phdev);
+
+		/* keep pulling pages till there are none to pull */
+	} while (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags));
+
+	/* processing of the zone is complete, we can disable boundaries */
+	__clear_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags);
+
+	spin_unlock_irq(&zone->lock);
+}
+
+static void page_reporting_process(struct work_struct *work)
+{
+	struct delayed_work *d_work = to_delayed_work(work);
+	struct page_reporting_dev_info *phdev =
+		container_of(d_work, struct page_reporting_dev_info, work);
+	struct zone *zone = first_online_pgdat()->node_zones;
+
+	do {
+		if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
+			page_reporting_cycle(zone, phdev);
+
+		/* Move to next zone, if at end of list start over */
+		zone = next_zone(zone) ? : first_online_pgdat()->node_zones;
+
+		/*
+		 * As long as refcnt has not reached zero there are still
+		 * zones to be processed.
+		 */
+	} while (atomic_read(&phdev->refcnt));
+}
+
+/* request page reporting on this zone */
+void __page_reporting_request(struct zone *zone)
+{
+	struct page_reporting_dev_info *phdev;
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
+	__set_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags);
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
+void __page_reporting_free_stats(struct zone *zone)
+{
+	/* free reported_page statisitics */
+	kfree(zone->reported_pages);
+	zone->reported_pages = NULL;
+}
+
+static DEFINE_MUTEX(page_reporting_mutex);
+
+void page_reporting_shutdown(struct page_reporting_dev_info *phdev)
+{
+	mutex_lock(&page_reporting_mutex);
+
+	if (rcu_access_pointer(ph_dev_info) == phdev) {
+		/* Disable page reporting notification */
+		static_key_slow_dec(&page_reporting_notify_enabled);
+		RCU_INIT_POINTER(ph_dev_info, NULL);
+		synchronize_rcu();
+
+		/* Flush any existing work, and lock it out */
+		cancel_delayed_work_sync(&phdev->work);
+
+		/* Free scatterlist */
+		kfree(phdev->sg);
+		phdev->sg = NULL;
+	}
+
+	mutex_unlock(&page_reporting_mutex);
+}
+EXPORT_SYMBOL_GPL(page_reporting_shutdown);
+
+int page_reporting_startup(struct page_reporting_dev_info *phdev)
+{
+	struct zone *zone;
+	int err = 0;
+
+	mutex_lock(&page_reporting_mutex);
+
+	/* nothing to do if already in use */
+	if (rcu_access_pointer(ph_dev_info)) {
+		err = -EBUSY;
+		goto err_out;
+	}
+
+	/* allocate scatterlist to store pages being reported on */
+	phdev->sg = kcalloc(phdev->capacity, sizeof(*phdev->sg), GFP_KERNEL);
+	if (!phdev->sg) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* initialize refcnt and work structures */
+	atomic_set(&phdev->refcnt, 0);
+	INIT_DELAYED_WORK(&phdev->work, &page_reporting_process);
+
+	/* assign device, and begin initial flush of populated zones */
+	rcu_assign_pointer(ph_dev_info, phdev);
+	for_each_populated_zone(zone) {
+		spin_lock(&zone->lock);
+		__page_reporting_request(zone);
+		spin_unlock(&zone->lock);
+	}
+
+	/* enable page reporting notification */
+	static_key_slow_inc(&page_reporting_notify_enabled);
+err_out:
+	mutex_unlock(&page_reporting_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(page_reporting_startup);

