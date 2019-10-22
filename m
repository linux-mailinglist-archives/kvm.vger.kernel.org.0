Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8443AE0E30
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 00:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388862AbfJVW2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 18:28:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45391 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732698AbfJVW2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 18:28:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id b4so2611009pfr.12;
        Tue, 22 Oct 2019 15:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=EEJclE8OjeAnfZoACHGa92bjltpuXuMPL4tJH9Rb3b8=;
        b=jGEdYdFh8gV3JAVtigFrJs4Mqi8f4QSGPK2tNc9InPkEXyJfthV4Nxrd7CciIuatgp
         5u1MbQYytbj72VE/oy7GR+gRrF1sFL3IYxMhGCFGrnKqAYoUKezNQY2zCw+XgBub74R/
         n2KeZIeUAHAJJEbGgu2pddLpd+6TIQitIQUH7JI2lytHop9bNq6m7qS0tS3LYUJcLR5f
         Vv06OmBP1nbSSaeTYB0BFdJ4O8nE8nEePRkh++V3mBb+EgWwpsS3MmFK4IfT471qeUdU
         siV4rIZ63HJXgN97ocaHCs/cBRCTiEjrMvdV3jypKjBHQfQXggwPy18HoIKKYwG/qlG9
         7UcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EEJclE8OjeAnfZoACHGa92bjltpuXuMPL4tJH9Rb3b8=;
        b=IAIEcpqd3wc5Rg7T554/97VU6i80Su9xSbHFeHceGQveyXfZ9eh9V8L5qKtjkx+gdc
         T+irjcGSrMSZBgVmgTcwcd2OiNQK+dZBLDfC7taqhcq3I8qWKIKROo8AjeqhI+WBxFCJ
         UqUTDzUfTd7Br3ATG8DwKTbNjZ+UsX6qc9llG+f9NuYIZ/683406Hp41NMgPBjE2r2lF
         7lQ+JUMuiEJkMTEClxQJBscdIL0Gx8kPeHqJRrDTbN7tNuQoav8leZAQSSM6kdvpT7Cd
         QBHbtJCmKVvnDhwQpo4YrzjT+3r0M158mIW2pbgmPd+rVkFuM9opMnWOpx2KWKaERK7C
         PfOg==
X-Gm-Message-State: APjAAAUlfPameZATzThJ50TezaQ0RFibsEWXCpNSmmOT6C8OmfIH9bWF
        5AvlmH6J0LdPJpyoBcegO9U=
X-Google-Smtp-Source: APXvYqy5SvEE4R9ofvXLsMrkrx2ocyUaRvCRWCQfp+ssrfmIIoexgMknVy2RjEJibif/Mvbvz3bgUQ==
X-Received: by 2002:a65:689a:: with SMTP id e26mr6287706pgt.346.1571783300499;
        Tue, 22 Oct 2019 15:28:20 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id o42sm20828816pjo.32.2019.10.22.15.28.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 15:28:19 -0700 (PDT)
Subject: [PATCH v12 4/6] mm: Add device side and notifier for unused page
 reporting
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
Date:   Tue, 22 Oct 2019 15:28:18 -0700
Message-ID: <20191022222818.17338.61428.stgit@localhost.localdomain>
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

With this patch we are adding the pieces needed to enable the reporting of
pages to a specific device. That device needs to register a page reporting
device that can be used to handle notifications that that pages are unused.

Registering the device will in turn enable the notifications and allow page
reporting to be active. When the the device is unregistered it will disable
page reporting notifications. For now we only allow one page reporting
device to be registered at a time.

The determination of when to start reporting is based on the tracking of
the number of free pages in a given area versus the number of reported
pages in that area. We keep track of the number of reported pages per
free_area in a separate zone specific area. We do this to avoid modifying
the free_area structure as this can lead to false sharing for the highest
order with the zone lock which leads to a noticeable performance
degradation.

Once reporting has started get_unreported_pages will use the
reported_boundary pointers to track where it should resume processing the
free lists. It will go through and either set the index if it finds a
reported page, or it will attempt to isolate the page so that it can be
reported.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/page_reporting.h |   31 ++++
 mm/Makefile                    |    1 
 mm/page_alloc.c                |   10 +
 mm/page_reporting.c            |  353 ++++++++++++++++++++++++++++++++++++++++
 mm/page_reporting.h            |   49 ++++++
 5 files changed, 442 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
new file mode 100644
index 000000000000..155006fc9911
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
+	void (*report)(struct page_reporting_dev_info *phdev,
+		       unsigned int nents);
+
+	/* scatterlist containing pages to be processed */
+	struct scatterlist *sg;
+
+	/*
+	 * Upper limit on the number of pages that the report function
+	 * expects to be placed into the scatterlist to be processed.
+	 */
+	unsigned long capacity;
+
+	/* work struct for processing reports */
+	struct delayed_work work;
+
+	/* The number of zones requesting reporting */
+	atomic_t refcnt;
+};
+
+/* Tear-down and bring-up for page reporting devices */
+void page_reporting_unregister(struct page_reporting_dev_info *phdev);
+int page_reporting_register(struct page_reporting_dev_info *phdev);
+#endif /*_LINUX_PAGE_REPORTING_H */
diff --git a/mm/Makefile b/mm/Makefile
index d996846697ef..fc4fa17b6c83 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -107,3 +107,4 @@ obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
+obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f67846101bb6..4ce7b33a1b09 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1073,6 +1073,14 @@ static inline void __free_one_page(struct page *page,
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
@@ -2276,8 +2284,6 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 }
 
 #ifdef CONFIG_PAGE_REPORTING
-struct list_head **reported_boundary __read_mostly;
-
 /**
  * free_reported_page - Return a now-reported page back where we got it
  * @page: Page that was reported
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
new file mode 100644
index 000000000000..52e038f1b657
--- /dev/null
+++ b/mm/page_reporting.c
@@ -0,0 +1,353 @@
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
+static struct page_reporting_dev_info __rcu *ph_dev_info __read_mostly;
+struct list_head **reported_boundary __read_mostly;
+
+#define for_each_reporting_migratetype_order(_order, _type) \
+	for (_order = MAX_ORDER; _order-- != PAGE_REPORTING_MIN_ORDER;) \
+		for (_type = MIGRATE_TYPES; _type--;) \
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
+static void page_reporting_reset_all_boundaries(struct zone *zone)
+{
+	unsigned int order, mt;
+
+	/* Update boundary data to reflect the zone we are currently working */
+	for_each_reporting_migratetype_order(order, mt)
+		page_reporting_reset_boundary(zone, order, mt);
+}
+
+static struct page *
+get_unreported_page(struct zone *zone, unsigned int order, int mt)
+{
+	struct list_head *list = &zone->free_area[order].free_list[mt];
+	struct list_head *tail = get_unreported_tail(zone, order, mt);
+	unsigned long index = get_reporting_index(order, mt);
+	struct page *page;
+
+	/* Find a page of the appropriate size in the preferred list */
+	page = list_last_entry(tail, struct page, lru);
+	tail = NULL;
+
+	list_for_each_entry_from_reverse(page, list, lru) {
+		/* If we entered this loop then the "raw" list isn't empty */
+
+		/*
+		 * We are going to skip over the reported pages. Make
+		 * certain that the index of those pages are correct
+		 * as we will later be moving the boundary into place
+		 * above them.
+		 */
+		if (PageReported(page)) {
+			page->index = index;
+			tail = &page->lru;
+			continue;
+		}
+
+		/* Drop reference to page if isolate fails */
+		if (!__isolate_free_page(page, order))
+			break;
+
+		goto out;
+	}
+
+	page = NULL;
+out:
+	/* Update the boundary if we skipped some pages */
+	if (tail)
+		reported_boundary[index] = tail;
+
+	return page;
+}
+
+static void
+__page_reporting_cancel(struct zone *zone,
+			struct page_reporting_dev_info *phdev)
+{
+	/* processing of the zone is complete, we can disable boundaries */
+	page_reporting_disable_boundaries(zone);
+
+	/*
+	 * If there are no longer enough free pages to fully populate
+	 * the scatterlist, then we can just shut it down for this zone.
+	 */
+	__clear_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags);
+	atomic_dec(&phdev->refcnt);
+}
+
+static unsigned int
+page_reporting_fill(struct zone *zone, struct page_reporting_dev_info *phdev)
+{
+	struct scatterlist *sg = phdev->sg;
+	unsigned int order, mt, count = 0;
+
+	sg_init_table(phdev->sg, phdev->capacity);
+
+	/* Make sure the boundaries are enabled */
+	if (!__test_and_set_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
+		page_reporting_reset_all_boundaries(zone);
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
+				return phdev->capacity;
+		}
+	}
+
+	/* mark end of scatterlist due to underflow */
+	if (count)
+		sg_mark_end(&sg[count - 1]);
+
+	/* We ran out of pages so we can stop now */
+	__page_reporting_cancel(zone, phdev);
+
+	return count;
+}
+
+static void page_reporting_drain(struct page_reporting_dev_info *phdev)
+{
+	struct scatterlist *sg = phdev->sg;
+
+	/*
+	 * Drain the now reported pages back into their respective
+	 * free lists/areas. We assume at least one page is populated.
+	 */
+	do {
+		free_reported_page(sg_page(sg), get_order(sg->length));
+	} while (!sg_is_last(sg++));
+}
+
+/*
+ * The page reporting cycle consists of 4 stages, fill, report, drain, and
+ * idle. We will cycle through the first 3 stages until we fail to obtain any
+ * pages, in that case we will switch to idle.
+ */
+static void
+page_reporting_cycle(struct zone *zone, struct page_reporting_dev_info *phdev)
+{
+	/*
+	 * Guarantee boundaries and stats are populated before we
+	 * start placing reported pages in the zone.
+	 */
+	page_reporting_populate_metadata(zone);
+
+	spin_lock_irq(&zone->lock);
+
+	/* Cancel the request if we failed to populate zone metadata */
+	if (!zone->reported_pages) {
+		__page_reporting_cancel(zone, phdev);
+		goto zone_not_ready;
+	}
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
+		page_reporting_drain(phdev);
+
+		/* keep pulling pages till there are none to pull */
+	} while (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags));
+zone_not_ready:
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
+	 * than 10 times per second.
+	 */
+	if (!atomic_fetch_inc(&phdev->refcnt))
+		schedule_delayed_work(&phdev->work, HZ / 10);
+out:
+	rcu_read_unlock();
+}
+
+static DEFINE_MUTEX(page_reporting_mutex);
+DEFINE_STATIC_KEY_FALSE(page_reporting_notify_enabled);
+
+void page_reporting_unregister(struct page_reporting_dev_info *phdev)
+{
+	mutex_lock(&page_reporting_mutex);
+
+	if (rcu_access_pointer(ph_dev_info) == phdev) {
+		/* Disable page reporting notification */
+		static_branch_disable(&page_reporting_notify_enabled);
+		RCU_INIT_POINTER(ph_dev_info, NULL);
+		synchronize_rcu();
+
+		/* Flush any existing work, and lock it out */
+		cancel_delayed_work_sync(&phdev->work);
+
+		/* Free scatterlist */
+		kfree(phdev->sg);
+		phdev->sg = NULL;
+
+		/* Free boundaries */
+		kfree(reported_boundary);
+		reported_boundary = NULL;
+	}
+
+	mutex_unlock(&page_reporting_mutex);
+}
+EXPORT_SYMBOL_GPL(page_reporting_unregister);
+
+int page_reporting_register(struct page_reporting_dev_info *phdev)
+{
+	struct zone *zone;
+	int err = 0;
+
+	/* No point in enabling this if it cannot handle any pages */
+	if (WARN_ON(!phdev->capacity || phdev->capacity > PAGE_REPORTING_HWM))
+		return -EINVAL;
+
+	mutex_lock(&page_reporting_mutex);
+
+	/* nothing to do if already in use */
+	if (rcu_access_pointer(ph_dev_info)) {
+		err = -EBUSY;
+		goto err_out;
+	}
+
+	/*
+	 * Allocate space to store the boundaries for the zone we are
+	 * actively reporting on. We will need to store one boundary
+	 * pointer per migratetype, and then we need to have one of these
+	 * arrays per order for orders greater than or equal to
+	 * PAGE_REPORTING_MIN_ORDER.
+	 */
+	reported_boundary = kcalloc(get_reporting_index(MAX_ORDER, 0),
+				    sizeof(struct list_head *), GFP_KERNEL);
+	if (!reported_boundary) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	/* allocate scatterlist to store pages being reported on */
+	phdev->sg = kcalloc(phdev->capacity, sizeof(*phdev->sg), GFP_KERNEL);
+	if (!phdev->sg) {
+		err = -ENOMEM;
+
+		kfree(reported_boundary);
+		reported_boundary = NULL;
+
+		goto err_out;
+	}
+
+
+	/* initialize refcnt and work structures */
+	atomic_set(&phdev->refcnt, 0);
+	INIT_DELAYED_WORK(&phdev->work, &page_reporting_process);
+
+	/* assign device, and begin initial flush of populated zones */
+	rcu_assign_pointer(ph_dev_info, phdev);
+	for_each_populated_zone(zone) {
+		spin_lock_irq(&zone->lock);
+		__page_reporting_request(zone);
+		spin_unlock_irq(&zone->lock);
+	}
+
+	/* enable page reporting notification */
+	static_branch_enable(&page_reporting_notify_enabled);
+err_out:
+	mutex_unlock(&page_reporting_mutex);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(page_reporting_register);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index ee4d86daa089..7aaa1d9a42e8 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -10,6 +10,7 @@
 #include <asm/pgtable.h>
 
 #define PAGE_REPORTING_MIN_ORDER	pageblock_order
+#define PAGE_REPORTING_HWM		32
 
 #ifdef CONFIG_PAGE_REPORTING
 /* Reported page accessors, defined in page_alloc.c */
@@ -24,6 +25,50 @@ static inline void page_reporting_reset_zone(struct zone *zone)
 	zone->reported_pages = NULL;
 }
 
+DECLARE_STATIC_KEY_FALSE(page_reporting_notify_enabled);
+void __page_reporting_request(struct zone *zone);
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
+	unsigned long next_report = PAGE_REPORTING_HWM;
+	int report_order;
+
+	/* Called from hot path in __free_one_page() */
+	if (!static_branch_unlikely(&page_reporting_notify_enabled))
+		return;
+
+	/* Limit notifications only to higher order pages */
+	report_order = order - PAGE_REPORTING_MIN_ORDER;
+	if (report_order < 0)
+		return;
+
+	/* Do not bother with tests if we have already requested reporting */
+	if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
+		return;
+
+	/* Add reported_pages count if it is present */
+	if (zone->reported_pages)
+		next_report += zone->reported_pages[report_order];
+
+	/* Determine if we have crossed reporting threshold */
+	if (zone->free_area[order].nr_free < next_report)
+		return;
+
+	/* This is slow, but should be called very rarely */
+	__page_reporting_request(zone);
+}
+
 /* Boundary functions */
 static inline pgoff_t
 get_reporting_index(unsigned int order, unsigned int migratetype)
@@ -145,6 +190,10 @@ static inline void page_reporting_reset_zone(struct zone *zone)
 {
 }
 
+static inline void page_reporting_notify_free(struct zone *zone, int order)
+{
+}
+
 static inline void
 page_reporting_free_area_release(struct zone *zone, unsigned int order, int mt)
 {

