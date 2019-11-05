Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17DA9F08EA
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbfKEWC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:02:29 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36991 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387456AbfKEWC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:02:29 -0500
Received: by mail-pf1-f196.google.com with SMTP id p24so10516858pfn.4;
        Tue, 05 Nov 2019 14:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Arnys98OGFGvUn7ZxMR2fYbX5ipG4dXriAmeU0Hw7To=;
        b=fDYaPCw7SSUpOLqdGBsY3CNsdT/Xc0yFQY6HIaqzpM0vvxO0xdHbz692CgP1HFwbNy
         EhQFZcJarbDZpPV6U4BeD/S66h+eqzHtFx3/XjTYMJVTn9IXZbBBTAoHwdD7EiwvyeVE
         920Zu5sndl9MsI4ckoiOzkaa4d3qfeBGJptdyyO7UfwXB5EnACEzLzWQKepjr77Gkam0
         gHhOW3HijSCldhSuyFtOz1Qk5FCUGMLlYR5r4f9EdT3K+bXk8h150nh5Srg4MPU7axsT
         6G2LSv/vnpTibJP5yGRmMUXCA60RQBN5e0zJEPEeKbEBfBwSF/npIp/w25P56JkfK5wE
         aQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Arnys98OGFGvUn7ZxMR2fYbX5ipG4dXriAmeU0Hw7To=;
        b=sXH9DvcSxxOUJDbVi5JprI4paye8lS9V2Zy+zqvrH7sYMhrRbJwSjvz/+qQssIrapm
         oZAgMyVfTEE0P0GVbzM+qeIuwkAZDhnuYCddUXGEALZJ3YwwhtGPNh+a1nDCd1QItdqY
         1G0FJNSp8dnD83YkU0gtyqN3VFj+XI+pLCfAPM0rJ2yywWZ3Zdh8/oEJI5dL76xNZymQ
         vihiyaJjASYp2pCc1lz9OFfYiMyrNfNfeXrGf8ehdZS4Mt9vRnZBNnYk4yCmf2vDOu0r
         mNs5pYoE++hvaiVYvW2GF0OogZChAozb2AKyT6Oq4k8c271F0Gn4//i35ts4NObq5REF
         thUw==
X-Gm-Message-State: APjAAAUMOXqmt9+cals7REu/YDtE2sx9kOiI2oMF7umbh/mUFfqVEQt9
        p3PPO15lD0BBHSGdBiE6Fvc=
X-Google-Smtp-Source: APXvYqxRah5M6xAhIPCP23mV82Ke8D+vsnU/bvkjtp4prszOzomLGJIfWmOv16TNsUOpzPQ2c3Giag==
X-Received: by 2002:a17:90a:35d0:: with SMTP id r74mr1642282pjb.47.1572991346994;
        Tue, 05 Nov 2019 14:02:26 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 10sm20052678pgs.11.2019.11.05.14.02.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:02:26 -0800 (PST)
Subject: [PATCH v13 4/6] mm: Add device side and notifier for unused page
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
Date:   Tue, 05 Nov 2019 14:02:25 -0800
Message-ID: <20191105220225.15144.45857.stgit@localhost.localdomain>
In-Reply-To: <20191105215940.15144.65968.stgit@localhost.localdomain>
References: <20191105215940.15144.65968.stgit@localhost.localdomain>
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
index 62234274be39..88bbd5c5cd4a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1078,6 +1078,14 @@ static inline void __free_one_page(struct page *page,
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
@@ -2281,8 +2289,6 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 }
 
 #ifdef CONFIG_PAGE_REPORTING
-struct list_head **reported_boundary __read_mostly;
-
 /**
  * free_reported_page - Return a now-reported page back where we got it
  * @page: Page that was reported
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
new file mode 100644
index 000000000000..546418b22e4f
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
+	struct list_head *tail = get_unreported_tail(order, mt);
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
index 8175dd3d4e55..5c5364514057 100644
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
@@ -147,6 +192,10 @@ static inline void page_reporting_reset_zone(struct zone *zone)
 {
 }
 
+static inline void page_reporting_notify_free(struct zone *zone, int order)
+{
+}
+
 static inline void
 page_reporting_free_area_release(struct zone *zone, unsigned int order, int mt)
 {

