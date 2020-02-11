Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A715159C7C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgBKWqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:46:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36988 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgBKWqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:46:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id a6so5773131wme.2;
        Tue, 11 Feb 2020 14:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nknHa1upAr2QpTNzJYibeur4mLAhCnpe46NYeDiLGiE=;
        b=irFgPHtW2y8GC6i5WitBtcCw6+rqTiar/f4dsAGZsOwDPKT/EtImzTFAACf6dXBiml
         YRV4gxwftDf8nvR7zH37izMWI7mKJY4MwhgJimaqN4PKl+mN7cvrfdjQ+nEoLoUoFr4J
         L8XIDndLQ68gKLH5RKIQlfKGWN88LQXoyA38t1joEE/jZM7raU1ZS1EYqwQ6KMQEBVwH
         yoGKZ2+LI2vS8qFgHBR2zrsELMYytfoi3HIrq7V56+bJl6gpAcYGgSY2sjheuEEQJzQU
         e5GqBWH+46+2P/pL6idoyFY9nbaZbuiFQXNemUCk+5MarvX8hHU3I54THA6d3U3z/Vjh
         7ptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nknHa1upAr2QpTNzJYibeur4mLAhCnpe46NYeDiLGiE=;
        b=o0L/WVJ9opsrf2D/kXs91HCA3gNyg6ncPR5ClyreQC2fxSiIqPP/DxoMc6XI2MRUgK
         O1vJj2pVVyCe4pZoYBtSj0PT/tVZJNINMgwRowqtay387lb7Su/OHq+TRr3q0JXzrH2j
         3kB87xo9CFqpa83ts2akpHSqgDGYBhUJPH+CITb6UX3ornhmk1tDP8VX8gTdvgrL8OAh
         qxqaZCtlS+DczVao5SIcc2ApnwtViVzzRupO983O1i/W/UTgMtd+ve5/uEQ8Kg9NesVo
         Xrx2Hdi6nk/f6wXmAx/W8bgREefF/SpMPyzxjZWO2KHb+ofFjo5/S/u/gktihXfRo5RL
         I6hw==
X-Gm-Message-State: APjAAAV6qaQIHp26/p10tYeKV3hGHQcVhlQ0EOfJ38FM0jTbZylLK8GW
        2l9EIdKt6MLyt+MDhRCINrI=
X-Google-Smtp-Source: APXvYqxQ8NpTfd+YFNvN48LIYg4l8clZCbd1sW5efbea8Vhbr9cT6TRZU7DkVIo5QeM6RhbB7oSIfg==
X-Received: by 2002:a7b:c0c7:: with SMTP id s7mr8675605wmh.129.1581461201507;
        Tue, 11 Feb 2020 14:46:41 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id m21sm5485744wmi.27.2020.02.11.14.46.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:46:40 -0800 (PST)
Subject: [PATCH v17 4/9] mm: Introduce Reported pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:46:35 -0800
Message-ID: <20200211224635.29318.19750.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
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
added a check to clear the PageReported bit in the del_page_from_free_list
function. As a result any reported page that is split, merged, or
allocated will have the flag cleared prior to the PageBuddy value being
cleared.

The process for reporting pages is fairly simple. Once we free a page that
meets the minimum order for page reporting we will schedule a worker thread
to start 2s or more in the future. That worker thread will begin working
from the lowest supported page reporting order up to MAX_ORDER - 1 pulling
unreported pages from the free list and storing them in the scatterlist.

When processing each individual free list it is necessary for the worker
thread to release the zone lock when it needs to stop and report the full
scatterlist of pages. To reduce the work of the next iteration the worker
thread will rotate the free list so that the first unreported page in the
free list becomes the first entry in the list.

It will then call a reporting function providing information on how many
entries are in the scatterlist. Once the function completes it will return
the pages to the free area from which they were allocated and start over
pulling more pages from the free areas until there are no longer enough
pages to report on to keep the worker busy, or we have processed as many
pages as were contained in the free area when we started processing the
list.

The worker thread will work in a round-robin fashion making its way
though each zone requesting reporting, and through each reportable free
list within that zone. Once all free areas within the zone have been
processed it will check to see if there have been any requests for
reporting while it was processing. If so it will reschedule the worker
thread to start up again in roughly 2s and exit.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/page-flags.h     |   11 +
 include/linux/page_reporting.h |   25 +++
 mm/Kconfig                     |   11 +
 mm/Makefile                    |    1 
 mm/page_alloc.c                |   17 ++
 mm/page_reporting.c            |  319 ++++++++++++++++++++++++++++++++++++++++
 mm/page_reporting.h            |   54 +++++++
 7 files changed, 434 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c
 create mode 100644 mm/page_reporting.h

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 1bf83c8fcaa7..49c2697046b9 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -163,6 +163,9 @@ enum pageflags {
 
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
+
+	/* Only valid for buddy pages. Used to track pages that are reported */
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
index 000000000000..32355486f572
--- /dev/null
+++ b/include/linux/page_reporting.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PAGE_REPORTING_H
+#define _LINUX_PAGE_REPORTING_H
+
+#include <linux/mmzone.h>
+#include <linux/scatterlist.h>
+
+#define PAGE_REPORTING_CAPACITY		32
+
+struct page_reporting_dev_info {
+	/* function that alters pages to make them "reported" */
+	int (*report)(struct page_reporting_dev_info *prdev,
+		      struct scatterlist *sg, unsigned int nents);
+
+	/* work struct for processing reports */
+	struct delayed_work work;
+
+	/* Current state of page reporting */
+	atomic_t state;
+};
+
+/* Tear-down and bring-up for page reporting devices */
+void page_reporting_unregister(struct page_reporting_dev_info *prdev);
+int page_reporting_register(struct page_reporting_dev_info *prdev);
+#endif /*_LINUX_PAGE_REPORTING_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index ab80933be65f..d40a873402ff 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -237,6 +237,17 @@ config COMPACTION
 	  linux-mm@kvack.org.
 
 #
+# support for free page reporting
+config PAGE_REPORTING
+	bool "Free page reporting"
+	def_bool n
+	help
+	  Free page reporting allows for the incremental acquisition of
+	  free pages from the buddy allocator for the purpose of reporting
+	  those pages to another entity, such as a hypervisor, so that the
+	  memory can be freed within the host for other uses.
+
+#
 # support for page migration
 #
 config MIGRATION
diff --git a/mm/Makefile b/mm/Makefile
index c9696f3ec840..7b5eec34d0e9 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -118,3 +118,4 @@ obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
 obj-$(CONFIG_PTDUMP_CORE) += ptdump.o
+obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b711fc0159d9..1142b2f91377 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -74,6 +74,7 @@
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
+#include "page_reporting.h"
 
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
@@ -902,6 +903,10 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 					   unsigned int order)
 {
+	/* clear reported state and update reported page count */
+	if (page_reported(page))
+		__ClearPageReported(page);
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
@@ -965,7 +970,7 @@ static inline void del_page_from_free_list(struct page *page, struct zone *zone,
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool report)
 {
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
@@ -1050,6 +1055,10 @@ static inline void __free_one_page(struct page *page,
 		add_to_free_list_tail(page, zone, order, migratetype);
 	else
 		add_to_free_list(page, zone, order, migratetype);
+
+	/* Notify page reporting subsystem of freed page */
+	if (report)
+		page_reporting_notify_free(order);
 }
 
 /*
@@ -1366,7 +1375,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1382,7 +1391,7 @@ static void free_one_page(struct zone *zone,
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype, true);
 	spin_unlock(&zone->lock);
 }
 
@@ -3233,7 +3242,7 @@ void __putback_isolated_page(struct page *page, unsigned int order, int mt)
 	lockdep_assert_held(&zone->lock);
 
 	/* Return isolated page to tail of freelist. */
-	__free_one_page(page, page_to_pfn(page), zone, order, mt);
+	__free_one_page(page, page_to_pfn(page), zone, order, mt, false);
 }
 
 /*
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
new file mode 100644
index 000000000000..1047c6872d4f
--- /dev/null
+++ b/mm/page_reporting.c
@@ -0,0 +1,319 @@
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
+#define PAGE_REPORTING_DELAY	(2 * HZ)
+static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
+
+enum {
+	PAGE_REPORTING_IDLE = 0,
+	PAGE_REPORTING_REQUESTED,
+	PAGE_REPORTING_ACTIVE
+};
+
+/* request page reporting */
+static void
+__page_reporting_request(struct page_reporting_dev_info *prdev)
+{
+	unsigned int state;
+
+	/* Check to see if we are in desired state */
+	state = atomic_read(&prdev->state);
+	if (state == PAGE_REPORTING_REQUESTED)
+		return;
+
+	/*
+	 *  If reporting is already active there is nothing we need to do.
+	 *  Test against 0 as that represents PAGE_REPORTING_IDLE.
+	 */
+	state = atomic_xchg(&prdev->state, PAGE_REPORTING_REQUESTED);
+	if (state != PAGE_REPORTING_IDLE)
+		return;
+
+	/*
+	 * Delay the start of work to allow a sizable queue to build. For
+	 * now we are limiting this to running no more than once every
+	 * couple of seconds.
+	 */
+	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+}
+
+/* notify prdev of free page reporting request */
+void __page_reporting_notify(void)
+{
+	struct page_reporting_dev_info *prdev;
+
+	/*
+	 * We use RCU to protect the pr_dev_info pointer. In almost all
+	 * cases this should be present, however in the unlikely case of
+	 * a shutdown this will be NULL and we should exit.
+	 */
+	rcu_read_lock();
+	prdev = rcu_dereference(pr_dev_info);
+	if (likely(prdev))
+		__page_reporting_request(prdev);
+
+	rcu_read_unlock();
+}
+
+static void
+page_reporting_drain(struct page_reporting_dev_info *prdev,
+		     struct scatterlist *sgl, unsigned int nents, bool reported)
+{
+	struct scatterlist *sg = sgl;
+
+	/*
+	 * Drain the now reported pages back into their respective
+	 * free lists/areas. We assume at least one page is populated.
+	 */
+	do {
+		struct page *page = sg_page(sg);
+		int mt = get_pageblock_migratetype(page);
+		unsigned int order = get_order(sg->length);
+
+		__putback_isolated_page(page, order, mt);
+
+		/* If the pages were not reported due to error skip flagging */
+		if (!reported)
+			continue;
+
+		/*
+		 * If page was not comingled with another page we can
+		 * consider the result to be "reported" since the page
+		 * hasn't been modified, otherwise we will need to
+		 * report on the new larger page when we make our way
+		 * up to that higher order.
+		 */
+		if (PageBuddy(page) && page_order(page) == order)
+			__SetPageReported(page);
+	} while ((sg = sg_next(sg)));
+
+	/* reinitialize scatterlist now that it is empty */
+	sg_init_table(sgl, nents);
+}
+
+/*
+ * The page reporting cycle consists of 4 stages, fill, report, drain, and
+ * idle. We will cycle through the first 3 stages until we cannot obtain a
+ * full scatterlist of pages, in that case we will switch to idle.
+ */
+static int
+page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
+		     unsigned int order, unsigned int mt,
+		     struct scatterlist *sgl, unsigned int *offset)
+{
+	struct free_area *area = &zone->free_area[order];
+	struct list_head *list = &area->free_list[mt];
+	unsigned int page_len = PAGE_SIZE << order;
+	struct page *page, *next;
+	int err = 0;
+
+	/*
+	 * Perform early check, if free area is empty there is
+	 * nothing to process so we can skip this free_list.
+	 */
+	if (list_empty(list))
+		return err;
+
+	spin_lock_irq(&zone->lock);
+
+	/* loop through free list adding unreported pages to sg list */
+	list_for_each_entry_safe(page, next, list, lru) {
+		/* We are going to skip over the reported pages. */
+		if (PageReported(page))
+			continue;
+
+		/* Attempt to pull page from list */
+		if (!__isolate_free_page(page, order))
+			break;
+
+		/* Add page to scatter list */
+		--(*offset);
+		sg_set_page(&sgl[*offset], page, page_len, 0);
+
+		/* If scatterlist isn't full grab more pages */
+		if (*offset)
+			continue;
+
+		/* release lock before waiting on report processing */
+		spin_unlock_irq(&zone->lock);
+
+		/* begin processing pages in local list */
+		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
+
+		/* reset offset since the full list was reported */
+		*offset = PAGE_REPORTING_CAPACITY;
+
+		/* reacquire zone lock and resume processing */
+		spin_lock_irq(&zone->lock);
+
+		/* flush reported pages from the sg list */
+		page_reporting_drain(prdev, sgl, PAGE_REPORTING_CAPACITY, !err);
+
+		/*
+		 * Reset next to first entry, the old next isn't valid
+		 * since we dropped the lock to report the pages
+		 */
+		next = list_first_entry(list, struct page, lru);
+
+		/* exit on error */
+		if (err)
+			break;
+	}
+
+	spin_unlock_irq(&zone->lock);
+
+	return err;
+}
+
+static int
+page_reporting_process_zone(struct page_reporting_dev_info *prdev,
+			    struct scatterlist *sgl, struct zone *zone)
+{
+	unsigned int order, mt, leftover, offset = PAGE_REPORTING_CAPACITY;
+	unsigned long watermark;
+	int err = 0;
+
+	/* Generate minimum watermark to be able to guarantee progress */
+	watermark = low_wmark_pages(zone) +
+		    (PAGE_REPORTING_CAPACITY << PAGE_REPORTING_MIN_ORDER);
+
+	/*
+	 * Cancel request if insufficient free memory or if we failed
+	 * to allocate page reporting statistics for the zone.
+	 */
+	if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
+		return err;
+
+	/* Process each free list starting from lowest order/mt */
+	for (order = PAGE_REPORTING_MIN_ORDER; order < MAX_ORDER; order++) {
+		for (mt = 0; mt < MIGRATE_TYPES; mt++) {
+			/* We do not pull pages from the isolate free list */
+			if (is_migrate_isolate(mt))
+				continue;
+
+			err = page_reporting_cycle(prdev, zone, order, mt,
+						   sgl, &offset);
+			if (err)
+				return err;
+		}
+	}
+
+	/* report the leftover pages before going idle */
+	leftover = PAGE_REPORTING_CAPACITY - offset;
+	if (leftover) {
+		sgl = &sgl[offset];
+		err = prdev->report(prdev, sgl, leftover);
+
+		/* flush any remaining pages out from the last report */
+		spin_lock_irq(&zone->lock);
+		page_reporting_drain(prdev, sgl, leftover, !err);
+		spin_unlock_irq(&zone->lock);
+	}
+
+	return err;
+}
+
+static void page_reporting_process(struct work_struct *work)
+{
+	struct delayed_work *d_work = to_delayed_work(work);
+	struct page_reporting_dev_info *prdev =
+		container_of(d_work, struct page_reporting_dev_info, work);
+	int err = 0, state = PAGE_REPORTING_ACTIVE;
+	struct scatterlist *sgl;
+	struct zone *zone;
+
+	/*
+	 * Change the state to "Active" so that we can track if there is
+	 * anyone requests page reporting after we complete our pass. If
+	 * the state is not altered by the end of the pass we will switch
+	 * to idle and quit scheduling reporting runs.
+	 */
+	atomic_set(&prdev->state, state);
+
+	/* allocate scatterlist to store pages being reported on */
+	sgl = kmalloc_array(PAGE_REPORTING_CAPACITY, sizeof(*sgl), GFP_KERNEL);
+	if (!sgl)
+		goto err_out;
+
+	sg_init_table(sgl, PAGE_REPORTING_CAPACITY);
+
+	for_each_zone(zone) {
+		err = page_reporting_process_zone(prdev, sgl, zone);
+		if (err)
+			break;
+	}
+
+	kfree(sgl);
+err_out:
+	/*
+	 * If the state has reverted back to requested then there may be
+	 * additional pages to be processed. We will defer for 2s to allow
+	 * more pages to accumulate.
+	 */
+	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
+	if (state == PAGE_REPORTING_REQUESTED)
+		schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
+}
+
+static DEFINE_MUTEX(page_reporting_mutex);
+DEFINE_STATIC_KEY_FALSE(page_reporting_enabled);
+
+int page_reporting_register(struct page_reporting_dev_info *prdev)
+{
+	int err = 0;
+
+	mutex_lock(&page_reporting_mutex);
+
+	/* nothing to do if already in use */
+	if (rcu_access_pointer(pr_dev_info)) {
+		err = -EBUSY;
+		goto err_out;
+	}
+
+	/* initialize state and work structures */
+	atomic_set(&prdev->state, PAGE_REPORTING_IDLE);
+	INIT_DELAYED_WORK(&prdev->work, &page_reporting_process);
+
+	/* Begin initial flush of zones */
+	__page_reporting_request(prdev);
+
+	/* Assign device to allow notifications */
+	rcu_assign_pointer(pr_dev_info, prdev);
+
+	/* enable page reporting notification */
+	if (!static_key_enabled(&page_reporting_enabled)) {
+		static_branch_enable(&page_reporting_enabled);
+		pr_info("Free page reporting enabled\n");
+	}
+err_out:
+	mutex_unlock(&page_reporting_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(page_reporting_register);
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
+	}
+
+	mutex_unlock(&page_reporting_mutex);
+}
+EXPORT_SYMBOL_GPL(page_reporting_unregister);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
new file mode 100644
index 000000000000..aa6d37f4dc22
--- /dev/null
+++ b/mm/page_reporting.h
@@ -0,0 +1,54 @@
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
+#include <linux/scatterlist.h>
+
+#define PAGE_REPORTING_MIN_ORDER	pageblock_order
+
+#ifdef CONFIG_PAGE_REPORTING
+DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
+void __page_reporting_notify(void);
+
+static inline bool page_reported(struct page *page)
+{
+	return static_branch_unlikely(&page_reporting_enabled) &&
+	       PageReported(page);
+}
+
+/**
+ * page_reporting_notify_free - Free page notification to start page processing
+ *
+ * This function is meant to act as a screener for __page_reporting_notify
+ * which will determine if a give zone has crossed over the high-water mark
+ * that will justify us beginning page treatment. If we have crossed that
+ * threshold then it will start the process of pulling some pages and
+ * placing them in the batch list for treatment.
+ */
+static inline void page_reporting_notify_free(unsigned int order)
+{
+	/* Called from hot path in __free_one_page() */
+	if (!static_branch_unlikely(&page_reporting_enabled))
+		return;
+
+	/* Determine if we have crossed reporting threshold */
+	if (order < PAGE_REPORTING_MIN_ORDER)
+		return;
+
+	/* This will add a few cycles, but should be called infrequently */
+	__page_reporting_notify();
+}
+#else /* CONFIG_PAGE_REPORTING */
+#define page_reported(_page)	false
+
+static inline void page_reporting_notify_free(unsigned int order)
+{
+}
+#endif /* CONFIG_PAGE_REPORTING */
+#endif /*_MM_PAGE_REPORTING_H */

