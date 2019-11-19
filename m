Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7F1102E82
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 22:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfKSVqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 16:46:37 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41244 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKSVqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 16:46:37 -0500
Received: by mail-pg1-f194.google.com with SMTP id 207so4786963pge.8;
        Tue, 19 Nov 2019 13:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CJp3/uRV0iWbhG+ok4dWB/RvFvlh+OmnuOcxk96/tt4=;
        b=HcB7fVES2W0rYUBmeY1C/xpkClSm08RdnAeiQn0BZvn3hqEUJ43X3m1HqnpwoJQYm9
         AVTLHkb9C0qDqLB2ruIuM53dZRF2xsMuhx/oH+j+qmsRtqzqCgj9t9cQbQ5yNmeZzxsG
         v4SUlxia8krXeNS/RvLym5zVA0wddOBP4WGFuC3+Jy8+xJn6lxQQ9pnCTr45yCFItbI9
         y8JYGr0UTghvuejJ0FzVUEPCnS1CUfllBUkTWWhljD0vIFlSvDpyzbEvUM8d5Dzc82qu
         z4PMcjHQVkOnIEZFSq2zXMPfOt/hTs7P8J1A7Dc3SleKDeroBWUUl3dyr4APU0/bNF+9
         gmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CJp3/uRV0iWbhG+ok4dWB/RvFvlh+OmnuOcxk96/tt4=;
        b=UwyBFFm/1Fheq+NMK3sViMTOPUmopUp7B5uigygRSF3ZawxDJ561rGXwDefYurhzqb
         Skim3O5X64XdsslcVnBbqSwUAKJYHaFtC1ypSKw27d50vSooLJSGuE67RQKE1zYv70eg
         5H/j9wB2rvuy0pwO+3FQgKBGR3f7UD3foo1DL006ALcPwinAN9lFamZoZsogL+M3JwkI
         zag76eoVv+CDfYjYD7e6LsNoW0aLLg4UhoGyS9YMaC2YLOPJzM1sBYQv81zinTMryS9L
         QZKqbyiBcT+nCvHppG6BF+aSVg0E/cVzarjpvyvbHCqvF6haAu5maAqVFDK26rNYV70Y
         tZXw==
X-Gm-Message-State: APjAAAUMDMjhsNIII98n6rU89m3awtAK74AJEql+y3K+R6J9qFo0cLmY
        EH8/nxt/5WbX0FpKXziha5YaJ9v6
X-Google-Smtp-Source: APXvYqxLh+vEXj2X26RdTu1zubG+UQOBUoBI9bvJqRyJtNY8d9mtfs+s3V+qBN6kYS7HfX5YHVyMAg==
X-Received: by 2002:a63:e44b:: with SMTP id i11mr7976765pgk.437.1574199995222;
        Tue, 19 Nov 2019 13:46:35 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id w15sm21368363pfi.168.2019.11.19.13.46.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 13:46:34 -0800 (PST)
Subject: [PATCH v14 3/6] mm: Introduce Reported pages
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
Date:   Tue, 19 Nov 2019 13:46:33 -0800
Message-ID: <20191119214633.24996.46821.stgit@localhost.localdomain>
In-Reply-To: <20191119214454.24996.66289.stgit@localhost.localdomain>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
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

To prevent the reported pages from leaking outside of the buddy lists I
have added a call to clear_reported_page to the del_page_from_free_list
function. As a result any reported page that is split, merged, or
allocated will have the flag cleared prior to the PageBuddy value being
cleared.

The process for reporting pages is fairly simple. Once the nr_free for
a given free area has exceeded the number of pages reported for that area
plus a certain high watermark value we will flag the zone as needing
reporting and schedule the worker thread to start reporting. That worker
thread will begin working from the lowest supported page reporting order
up to MAX_ORDER - 1 pulling unreported pages from the free list and
storing them in the scatterlist.

When processing each individual free list it is necessary for the worker
thread to release the zone lock when it needs to stop and report the full
scatterlist of pages. To reduce the work of the next iteration the worker
thread will rotate the free list so that the first unreported page in the
free list becomes the first entry in the list. Doing this we should only
have to walk an entire free list no more than twice assuming large
numbers of pages are not being added to the tail of the list.

It will then call a reporting function providing information on how many
entries are in the scatterlist. Once the function completes it will return
the pages to the tail of the free area from which they were allocated and
start over pulling more pages from the free areas until there are no
longer enough pages to report on to keep the worker busy.

The worker thread will work in a round-robin fashion making its way
though each zone requesting reporting, and through each reportable free
list within that zone. Once all free areas within the zone is below the
high watermark level for free pages to report the flag indicating that the
zone has requested reporting will be cleared, and if no zones are
requesting reporting the worker thread will exit.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h         |   12 +
 include/linux/page-flags.h     |   11 +
 include/linux/page_reporting.h |   31 ++++
 mm/Kconfig                     |   11 +
 mm/Makefile                    |    1 
 mm/memory_hotplug.c            |    2 
 mm/page_alloc.c                |   53 ++++++
 mm/page_reporting.c            |  337 ++++++++++++++++++++++++++++++++++++++++
 mm/page_reporting.h            |  125 +++++++++++++++
 9 files changed, 579 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c
 create mode 100644 mm/page_reporting.h

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8d93106490f3..9647499983b1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -478,6 +478,14 @@ struct zone {
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
@@ -550,6 +558,10 @@ enum zone_flags {
 	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
 					 * Cleared when kswapd is woken.
 					 */
+	ZONE_PAGE_REPORTING_REQUESTED,	/* zone enabled page reporting and has
+					 * requested flushing the data out of
+					 * higher order pages.
+					 */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 1bf83c8fcaa7..a3a3b15b56a8 100644
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
index 000000000000..925a16b1d14b
--- /dev/null
+++ b/include/linux/page_reporting.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PAGE_REPORTING_H
+#define _LINUX_PAGE_REPORTING_H
+
+#include <linux/mmzone.h>
+
+struct page_reporting_dev_info {
+	/* function that alters pages to make them "reported" */
+	void (*report)(struct page_reporting_dev_info *prdev,
+		       unsigned int nents);
+
+	/* pointer to scatterlist containing pages to be processed */
+	struct scatterlist *sg;
+
+	/*
+	 * Upper limit on the number of pages that the report function
+	 * expects to be placed into the scatterlist to be processed.
+	 */
+	unsigned int capacity;
+
+	/* The number of zones requesting reporting */
+	atomic_t refcnt;
+
+	/* work struct for processing reports */
+	struct delayed_work work;
+};
+
+/* Tear-down and bring-up for page reporting devices */
+void page_reporting_unregister(struct page_reporting_dev_info *prdev);
+int page_reporting_register(struct page_reporting_dev_info *prdev);
+#endif /*_LINUX_PAGE_REPORTING_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index e38ff1d5968d..bd68901bbfe2 100644
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
diff --git a/mm/Makefile b/mm/Makefile
index fa02f19f8e50..41e6aa432781 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -108,3 +108,4 @@ obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
+obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 46b2e056a43f..bf19d94cb206 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -41,6 +41,7 @@
 
 #include "internal.h"
 #include "shuffle.h"
+#include "page_reporting.h"
 
 /*
  * online_page_callback contains pointer to current page onlining function.
@@ -1566,6 +1567,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
+		page_reporting_reset_zone(zone);
 	} else
 		zone_pcp_update(zone);
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e0a7895300fb..5ef8f5abdd4d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -74,6 +74,7 @@
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
+#include "page_reporting.h"
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
@@ -909,6 +910,10 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 					   unsigned int order)
 {
+	/* clear reported state and update reported page count */
+	if (page_reported(page))
+		clear_page_reported(page, zone, order);
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
@@ -972,7 +977,7 @@ static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool reported)
 {
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
@@ -1048,7 +1053,9 @@ static inline void __free_one_page(struct page *page,
 done_merging:
 	set_page_order(page, order);
 
-	if (is_shuffle_order(order))
+	if (reported)
+		to_tail = true;
+	else if (is_shuffle_order(order))
 		to_tail = shuffle_pick_tail();
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
@@ -1057,6 +1064,14 @@ static inline void __free_one_page(struct page *page,
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
@@ -1373,7 +1388,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, false);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1389,7 +1404,7 @@ static void free_one_page(struct zone *zone,
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype, false);
 	spin_unlock(&zone->lock);
 }
 
@@ -3228,6 +3243,36 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	return 1UL << order;
 }
 
+#ifdef CONFIG_PAGE_REPORTING
+/**
+ * __free_isolated_page - Return a now-isolated page back where we got it
+ * @page: Page that was isolated
+ * @order: Order of the isolated page
+ *
+ * This function is meant to return a page pulled from the free lists via
+ * __isolate_free_page back to the free lists they were pulled from.
+ */
+void __free_isolated_page(struct page *page, unsigned int order)
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
+
+	/*
+	 * Return isolated page to tail of freelist and don't bother with
+	 * triggering the page reporting notifiers since this page was
+	 * previously on the freelist and has likely already been reported.
+	 */
+	__free_one_page(page, pfn, zone, order, mt, true);
+}
+#endif /* CONFIG_PAGE_REPORTING */
+
 /*
  * Update NUMA hit/miss statistics
  *
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
new file mode 100644
index 000000000000..4844f0aa2904
--- /dev/null
+++ b/mm/page_reporting.c
@@ -0,0 +1,337 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/page_reporting.h>
+#include <linux/gfp.h>
+#include <linux/export.h>
+#include <linux/delay.h>
+#include <linux/scatterlist.h>
+
+#include "page_reporting.h"
+#include "internal.h"
+
+static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
+
+#define for_each_reporting_migratetype_order(_order, _type) \
+	for (_order = PAGE_REPORTING_MIN_ORDER; _order < MAX_ORDER; _order++) \
+		for (_type = 0; _type < MIGRATE_TYPES; _type++) \
+			if (!is_migrate_isolate(_type))
+
+static void page_reporting_populate_metadata(struct zone *zone)
+{
+	size_t size;
+	int node;
+
+	/*
+	 * We need to make sure we have somewhere to store the tracking
+	 * data for how many reported pages are in the zone. To do that
+	 * we need to make certain zone->reported_pages is populated.
+	 */
+	if (zone->reported_pages)
+		return;
+
+	node = zone_to_nid(zone);
+	size = (MAX_ORDER - PAGE_REPORTING_MIN_ORDER) * sizeof(unsigned long);
+	zone->reported_pages = kzalloc_node(size, GFP_KERNEL, node);
+}
+
+static void
+page_reporting_drain(struct page_reporting_dev_info *prdev, struct zone *zone)
+{
+	struct scatterlist *sg = prdev->sg;
+
+	/*
+	 * Drain the now reported pages back into their respective
+	 * free lists/areas. We assume at least one page is populated.
+	 */
+	do {
+		unsigned int order = get_order(sg->length);
+		struct page *page = sg_page(sg);
+
+		__free_isolated_page(page, order);
+
+		/*
+		 * If page was not comingled with another page we can
+		 * consider the result to be "reported" since the page
+		 * hasn't been modified, otherwise we will need to
+		 * report on the new larger page when we make our way
+		 * up to that higher order.
+		 */
+		if (PageBuddy(page) && page_order(page) == order)
+			mark_page_reported(page, zone, order);
+	} while (!sg_is_last(sg++));
+}
+
+/*
+ * The page reporting cycle consists of 4 stages, fill, report, drain, and
+ * idle. We will cycle through the first 3 stages until we cannot obtain a
+ * full scatterlist of pages, in that case we will switch to idle.
+ */
+static unsigned int
+page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
+		     unsigned int order, unsigned int mt, unsigned int nents)
+{
+	struct list_head *list = &zone->free_area[order].free_list[mt];
+	unsigned int page_len = PAGE_SIZE << order;
+	struct scatterlist *sg = prdev->sg;
+	struct page *page, *next;
+
+	/*
+	 * Perform early check, if free area is empty there is
+	 * nothing to process so we can skip this free_list.
+	 */
+	if (list_empty(list))
+		return nents;
+
+	spin_lock_irq(&zone->lock);
+
+	/* loop through free list adding unreported pages to sg list */
+	list_for_each_entry_safe(page, next, list, lru) {
+		/* We are going to skip over the reported pages. */
+		if (PageReported(page))
+			continue;
+
+		/* Attempt to add page to sg list */
+		if (nents < prdev->capacity) {
+			if (!__isolate_free_page(page, order))
+				break;
+
+			sg_set_page(&sg[nents++], page, page_len, 0);
+			continue;
+		}
+
+		/*
+		 * Make the first non-reported entry in the free list
+		 * the new head of the free list before we exit.
+		 */
+		if (!list_is_first(&page->lru, list))
+			list_rotate_to_front(&page->lru, list);
+
+		/* release lock before waiting on report processing*/
+		spin_unlock_irq(&zone->lock);
+
+		/* begin processing pages in local list */
+		prdev->report(prdev, nents);
+
+		/* reset number of entries */
+		nents = 0;
+
+		/* reacquire zone lock and resume processing free lists */
+		spin_lock_irq(&zone->lock);
+
+		/* flush reported pages from the sg list */
+		page_reporting_drain(prdev, zone);
+
+		/*
+		 * Reset next to first entry, the old next isn't valid
+		 * since we dropped the lock to report the pages
+		 */
+		next = list_first_entry(list, struct page, lru);
+	}
+
+	spin_unlock_irq(&zone->lock);
+
+	return nents;
+}
+
+static int
+page_reporting_process_zone(struct page_reporting_dev_info *prdev,
+			    struct zone *zone)
+{
+	unsigned int order, mt, nents = 0;
+	unsigned long watermark;
+	int refcnt = -1;
+
+	page_reporting_populate_metadata(zone);
+
+	/* Generate minimum watermark to be able to guarantee progress */
+	watermark = low_wmark_pages(zone) +
+		    (prdev->capacity << PAGE_REPORTING_MIN_ORDER);
+
+	/*
+	 * Cancel request if insufficient free memory or if we failed
+	 * to allocate page reporting statistics for the zone.
+	 */
+	if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA) ||
+	    !zone->reported_pages) {
+		spin_lock_irq(&zone->lock);
+		goto zone_not_ready;
+	}
+
+	sg_init_table(prdev->sg, prdev->capacity);
+
+	/* Process each free list starting from lowest order/mt */
+	for_each_reporting_migratetype_order(order, mt)
+		nents = page_reporting_cycle(prdev, zone, order, mt, nents);
+
+	/* mark end of sg list and report the remainder */
+	if (nents) {
+		sg_mark_end(&prdev->sg[nents - 1]);
+		prdev->report(prdev, nents);
+	}
+
+	spin_lock_irq(&zone->lock);
+
+	/* flush any remaining pages out from the last report */
+	if (nents)
+		page_reporting_drain(prdev, zone);
+
+	/* check to see if values are low enough for us to stop for now */
+	for (order = PAGE_REPORTING_MIN_ORDER; order < MAX_ORDER; order++) {
+		if (pages_unreported(zone, order) < PAGE_REPORTING_HWM)
+			continue;
+#ifdef CONFIG_MEMORY_ISOLATION
+		/*
+		 * Do not allow a free_area with isolated pages to request
+		 * that we continue with page reporting. Keep the reporting
+		 * light until the isolated pages have been cleared.
+		 */
+		if (!free_area_empty(&zone->free_area[order], MIGRATE_ISOLATE))
+			continue;
+#endif
+		goto zone_not_complete;
+	}
+
+zone_not_ready:
+	/*
+	 * If there are no longer enough free pages to fully populate
+	 * the scatterlist, then we can just shut it down for this zone.
+	 */
+	__clear_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags);
+	refcnt = atomic_dec_return(&prdev->refcnt);
+zone_not_complete:
+	spin_unlock_irq(&zone->lock);
+
+	return refcnt;
+}
+
+static void page_reporting_process(struct work_struct *work)
+{
+	struct delayed_work *d_work = to_delayed_work(work);
+	struct page_reporting_dev_info *prdev =
+		container_of(d_work, struct page_reporting_dev_info, work);
+	struct zone *zone = first_online_pgdat()->node_zones;
+	int refcnt = -1;
+
+	do {
+		if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
+			refcnt = page_reporting_process_zone(prdev, zone);
+
+		/* Move to next zone, if at end of list start over */
+		zone = next_zone(zone) ? : first_online_pgdat()->node_zones;
+
+		/*
+		 * As long as refcnt has not reached zero there are still
+		 * zones to be processed.
+		 */
+	} while (refcnt);
+}
+
+/* request page reporting on this zone */
+void __page_reporting_request(struct zone *zone)
+{
+	struct page_reporting_dev_info *prdev;
+
+	rcu_read_lock();
+
+	/*
+	 * We use RCU to protect the pr_dev_info pointer. In almost all
+	 * cases this should be present, however in the unlikely case of
+	 * a shutdown this will be NULL and we should exit.
+	 */
+	prdev = rcu_dereference(pr_dev_info);
+	if (unlikely(!prdev))
+		goto out;
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
+	 * than 5 times per second.
+	 */
+	if (!atomic_fetch_inc(&prdev->refcnt))
+		schedule_delayed_work(&prdev->work, HZ / 5);
+out:
+	rcu_read_unlock();
+}
+
+static DEFINE_MUTEX(page_reporting_mutex);
+DEFINE_STATIC_KEY_FALSE(page_reporting_enabled);
+
+void page_reporting_unregister(struct page_reporting_dev_info *prdev)
+{
+	mutex_lock(&page_reporting_mutex);
+
+	if (rcu_access_pointer(pr_dev_info) == prdev) {
+		/* Disable page reporting notification */
+		RCU_INIT_POINTER(pr_dev_info, NULL);
+		synchronize_rcu();
+
+		/* Flush any existing work, and lock it out */
+		cancel_delayed_work_sync(&prdev->work);
+
+		/* Free scatterlist */
+		kfree(prdev->sg);
+		prdev->sg = NULL;
+	}
+
+	mutex_unlock(&page_reporting_mutex);
+}
+EXPORT_SYMBOL_GPL(page_reporting_unregister);
+
+int page_reporting_register(struct page_reporting_dev_info *prdev)
+{
+	struct zone *zone;
+	int err = 0;
+
+	/* No point in enabling this if it cannot handle any pages */
+	if (WARN_ON(!prdev->capacity || prdev->capacity > PAGE_REPORTING_HWM))
+		return -EINVAL;
+
+	mutex_lock(&page_reporting_mutex);
+
+	/* nothing to do if already in use */
+	if (rcu_access_pointer(pr_dev_info)) {
+		err = -EBUSY;
+		goto err_out;
+	}
+
+	/* allocate scatterlist to store pages being reported on */
+	prdev->sg = kcalloc(prdev->capacity, sizeof(*prdev->sg), GFP_KERNEL);
+	if (!prdev->sg) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+
+	/* initialize refcnt and work structures */
+	atomic_set(&prdev->refcnt, 0);
+	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
+
+	/* assign device, and begin initial flush of populated zones */
+	rcu_assign_pointer(pr_dev_info, prdev);
+	for_each_populated_zone(zone) {
+		spin_lock_irq(&zone->lock);
+		__page_reporting_request(zone);
+		spin_unlock_irq(&zone->lock);
+	}
+
+	/* enable page reporting notification */
+	if (!static_key_enabled(&page_reporting_enabled)) {
+		static_branch_enable(&page_reporting_enabled);
+		pr_info("Unused page reporting enabled\n");
+	}
+err_out:
+	mutex_unlock(&page_reporting_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(page_reporting_register);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
new file mode 100644
index 000000000000..2ad31bbb0036
--- /dev/null
+++ b/mm/page_reporting.h
@@ -0,0 +1,125 @@
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
+#define PAGE_REPORTING_HWM		32
+
+#ifdef CONFIG_PAGE_REPORTING
+/* Reported page accessors, defined in page_alloc.c */
+void __free_isolated_page(struct page *page, unsigned int order);
+
+/* Free reported_pages and reset reported page tracking count to 0 */
+static inline void page_reporting_reset_zone(struct zone *zone)
+{
+	kfree(zone->reported_pages);
+	zone->reported_pages = NULL;
+}
+
+DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
+void __page_reporting_request(struct zone *zone);
+
+static inline bool page_reported(struct page *page)
+{
+	return static_branch_unlikely(&page_reporting_enabled) &&
+	       PageReported(page);
+}
+
+static inline unsigned long
+pages_unreported(struct zone *zone, int order)
+{
+	unsigned long nr_free;
+	int report_order;
+
+	/* Limit notifications only to higher order pages */
+	report_order = order - PAGE_REPORTING_MIN_ORDER;
+	if (report_order < 0)
+		return 0;
+
+	nr_free = zone->free_area[order].nr_free;
+
+	/* Only subtract reported_pages count if it is present */
+	if (!zone->reported_pages)
+		return nr_free;
+
+	return nr_free - zone->reported_pages[report_order];
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
+	/* Called from hot path in __free_one_page() */
+	if (!static_branch_unlikely(&page_reporting_enabled))
+		return;
+
+	/* Do not bother with tests if we have already requested reporting */
+	if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
+		return;
+
+	/* Determine if we have crossed reporting threshold */
+	if (pages_unreported(zone, order) < PAGE_REPORTING_HWM)
+		return;
+
+	/* This is slow, but should be called very rarely */
+	__page_reporting_request(zone);
+}
+
+/*
+ * Functions for marking/clearing reported pages from the freelist.
+ * All of them expect the zone lock to be held to maintain
+ * consistency of the reported_pages count versus nr_free.
+ */
+static inline void
+mark_page_reported(struct page *page, struct zone *zone, unsigned int order)
+{
+	/* flag page as reported */
+	__SetPageReported(page);
+
+	/* update areated page accounting */
+	zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER]++;
+}
+
+static inline void
+clear_page_reported(struct page *page, struct zone *zone, unsigned int order)
+{
+	/* page_private will contain the page order, so just use it directly */
+	zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER]--;
+
+	/* clear the flag so we can report on it when it returns */
+	__ClearPageReported(page);
+}
+
+#else /* CONFIG_PAGE_REPORTING */
+#define page_reported(_page)	false
+
+static inline void page_reporting_reset_zone(struct zone *zone)
+{
+}
+
+static inline void page_reporting_notify_free(struct zone *zone, int order)
+{
+}
+
+static inline void
+clear_page_reported(struct page *page, struct zone *zone, unsigned int order)
+{
+}
+#endif /* CONFIG_PAGE_REPORTING */
+#endif /*_MM_PAGE_REPORTING_H */

