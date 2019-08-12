Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686A689F53
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 15:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbfHLNNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 09:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbfHLNNP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 09:13:15 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E81C306F4AB;
        Mon, 12 Aug 2019 13:13:14 +0000 (UTC)
Received: from virtlab605.virt.lab.eng.bos.redhat.com (virtlab605.virt.lab.eng.bos.redhat.com [10.19.152.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F8AD5D71A;
        Mon, 12 Aug 2019 13:13:10 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, virtio-dev@lists.oasis-open.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        david@redhat.com, mst@redhat.com, dodgen@google.com,
        konrad.wilk@oracle.com, dhildenb@redhat.com, aarcange@redhat.com,
        alexander.duyck@gmail.com, john.starks@microsoft.com,
        dave.hansen@intel.com, mhocko@suse.com, cohuck@redhat.com
Subject: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
Date:   Mon, 12 Aug 2019 09:12:34 -0400
Message-Id: <20190812131235.27244-2-nitesh@redhat.com>
In-Reply-To: <20190812131235.27244-1-nitesh@redhat.com>
References: <20190812131235.27244-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 12 Aug 2019 13:13:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces the core infrastructure for free page reporting in
virtual environments. It enables the kernel to track the free pages which
can be reported to its hypervisor so that the hypervisor could
free and reuse that memory as per its requirement.

While the pages are getting processed in the hypervisor (e.g.,
via MADV_DONTNEED), the guest must not use them, otherwise, data loss
would be possible. To avoid such a situation, these pages are
temporarily removed from the buddy. The amount of pages removed
temporarily from the buddy is governed by the backend(virtio-balloon
in our case).

To efficiently identify free pages that can to be reported to the
hypervisor, bitmaps in a coarse granularity are used. Only fairly big
chunks are reported to the hypervisor - especially, to not break up THP
in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
in the bitmap are an indication whether a page *might* be free, not a
guarantee. A new hook after buddy merging sets the bits.

Bitmaps are stored per zone, protected by the zone lock. A workqueue
asynchronously processes the bitmaps, trying to isolate and report pages
that are still free. The backend (virtio-balloon) is responsible for
reporting these batched pages to the host synchronously. Once reporting/
freeing is complete, isolated pages are returned back to the buddy.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/linux/mmzone.h         |  11 ++
 include/linux/page_reporting.h |  63 +++++++
 mm/Kconfig                     |   6 +
 mm/Makefile                    |   1 +
 mm/page_alloc.c                |  42 ++++-
 mm/page_reporting.c            | 332 +++++++++++++++++++++++++++++++++
 6 files changed, 448 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/page_reporting.h
 create mode 100644 mm/page_reporting.c

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d77d717c620c..ba5f5b508f25 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -559,6 +559,17 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_stat[NR_VM_NUMA_STAT_ITEMS];
+#ifdef CONFIG_PAGE_REPORTING
+	/* Pointer to the bitmap in PAGE_REPORTING_MIN_ORDER granularity */
+	unsigned long *bitmap;
+	/* Preserve start and end PFN in case they change due to hotplug */
+	unsigned long base_pfn;
+	unsigned long end_pfn;
+	/* Free pages of granularity PAGE_REPORTING_MIN_ORDER */
+	atomic_t free_pages;
+	/* Number of bits required in the bitmap */
+	unsigned long nbits;
+#endif
 } ____cacheline_internodealigned_in_smp;
 
 enum pgdat_flags {
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
new file mode 100644
index 000000000000..37a39589939d
--- /dev/null
+++ b/include/linux/page_reporting.h
@@ -0,0 +1,63 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PAGE_REPORTING_H
+#define _LINUX_PAGE_REPORTING_H
+
+#define PAGE_REPORTING_MIN_ORDER		(MAX_ORDER - 2)
+#define PAGE_REPORTING_MAX_PAGES		16
+
+#ifdef CONFIG_PAGE_REPORTING
+struct page_reporting_config {
+	/* function to hint batch of isolated pages */
+	void (*report)(struct page_reporting_config *phconf,
+		       unsigned int num_pages);
+
+	/* scatterlist to hold the isolated pages to be hinted */
+	struct scatterlist *sg;
+
+	/*
+	 * Maxmimum pages that are going to be hinted to the hypervisor at a
+	 * time of granularity >= PAGE_REPORTING_MIN_ORDER.
+	 */
+	int max_pages;
+
+	/* work object to process page reporting rqeuests */
+	struct work_struct reporting_work;
+
+	/* tracks the number of reporting request processed at a time */
+	atomic_t refcnt;
+};
+
+void __page_reporting_enqueue(struct page *page);
+void __return_isolated_page(struct zone *zone, struct page *page);
+void set_pageblock_migratetype(struct page *page, int migratetype);
+
+/**
+ * page_reporting_enqueue - checks the eligibility of the freed page based on
+ * its order for further page reporting processing.
+ * @page: page which has been freed.
+ * @order: order for the the free page.
+ */
+static inline void page_reporting_enqueue(struct page *page, int order)
+{
+	if (order < PAGE_REPORTING_MIN_ORDER)
+		return;
+	__page_reporting_enqueue(page);
+}
+
+int page_reporting_enable(struct page_reporting_config *phconf);
+void page_reporting_disable(struct page_reporting_config *phconf);
+#else
+static inline void page_reporting_enqueue(struct page *page, int order)
+{
+}
+
+static inline int page_reporting_enable(struct page_reporting_config *phconf)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void page_reporting_disable(struct page_reporting_config *phconf)
+{
+}
+#endif /* CONFIG_PAGE_REPORTING */
+#endif /* _LINUX_PAGE_REPORTING_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 56cec636a1fc..6a35a9dad350 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -736,4 +736,10 @@ config ARCH_HAS_PTE_SPECIAL
 config ARCH_HAS_HUGEPD
 	bool
 
+# PAGE_REPORTING will allow the guest to report the free pages to the
+# host in fixed chunks as soon as a fixed threshold is reached.
+config PAGE_REPORTING
+       bool
+       def_bool n
+       depends on X86_64
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 338e528ad436..6a32cdfa61c2 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
+obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 272c6de1bf4e..aa7c89d50c85 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -68,6 +68,7 @@
 #include <linux/lockdep.h>
 #include <linux/nmi.h>
 #include <linux/psi.h>
+#include <linux/page_reporting.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -903,7 +904,7 @@ compaction_capture(struct capture_control *capc, struct page *page,
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool needs_reporting)
 {
 	unsigned long combined_pfn;
 	unsigned long uninitialized_var(buddy_pfn);
@@ -1006,7 +1007,8 @@ static inline void __free_one_page(struct page *page,
 				migratetype);
 	else
 		add_to_free_area(page, &zone->free_area[order], migratetype);
-
+	if (needs_reporting)
+		page_reporting_enqueue(page, order);
 }
 
 /*
@@ -1317,7 +1319,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1326,14 +1328,14 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 static void free_one_page(struct zone *zone,
 				struct page *page, unsigned long pfn,
 				unsigned int order,
-				int migratetype)
+				int migratetype, bool needs_reporting)
 {
 	spin_lock(&zone->lock);
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype, needs_reporting);
 	spin_unlock(&zone->lock);
 }
 
@@ -1423,7 +1425,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, pfn, order, migratetype);
+	free_one_page(page_zone(page), page, pfn, order, migratetype, true);
 	local_irq_restore(flags);
 }
 
@@ -2197,6 +2199,32 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	return NULL;
 }
 
+#ifdef CONFIG_PAGE_REPORTING
+/**
+ * return_isolated_page - returns a reported page back to the buddy.
+ * @zone: zone from where the page was isolated.
+ * @page: page which will be returned.
+ */
+void __return_isolated_page(struct zone *zone, struct page *page)
+{
+	unsigned int order, mt;
+	unsigned long pfn;
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	mt = get_pageblock_migratetype(page);
+	pfn = page_to_pfn(page);
+
+	if (unlikely(has_isolate_pageblock(zone) || is_migrate_isolate(mt)))
+		mt = get_pfnblock_migratetype(page, pfn);
+
+	order = page_private(page);
+	set_page_private(page, 0);
+
+	__free_one_page(page, pfn, zone, order, mt, false);
+}
+#endif /* CONFIG_PAGE_REPORTING */
 
 /*
  * This array describes the order lists are fallen back to when
@@ -3041,7 +3069,7 @@ static void free_unref_page_commit(struct page *page, unsigned long pfn)
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(zone, page, pfn, 0, migratetype);
+			free_one_page(zone, page, pfn, 0, migratetype, true);
 			return;
 		}
 		migratetype = MIGRATE_MOVABLE;
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
new file mode 100644
index 000000000000..4ee2c172cd9a
--- /dev/null
+++ b/mm/page_reporting.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Page reporting core infrastructure to enable a VM to report free pages to its
+ * hypervisor.
+ *
+ * Copyright Red Hat, Inc. 2019
+ *
+ * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/page_reporting.h>
+#include <linux/scatterlist.h>
+#include "internal.h"
+
+static struct page_reporting_config __rcu *page_reporting_conf __read_mostly;
+static DEFINE_MUTEX(page_reporting_mutex);
+
+static inline unsigned long pfn_to_bit(struct page *page, struct zone *zone)
+{
+	unsigned long bitnr;
+
+	bitnr = (page_to_pfn(page) - zone->base_pfn) >>
+		PAGE_REPORTING_MIN_ORDER;
+
+	return bitnr;
+}
+
+static void return_isolated_page(struct zone *zone,
+				 struct page_reporting_config *phconf)
+{
+	struct scatterlist *sg = phconf->sg;
+
+	spin_lock(&zone->lock);
+	do {
+		__return_isolated_page(zone, sg_page(sg));
+	} while (!sg_is_last(sg++));
+	spin_unlock(&zone->lock);
+}
+
+static void bitmap_set_bit(struct page *page, struct zone *zone)
+{
+	unsigned long bitnr = 0;
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	bitnr = pfn_to_bit(page, zone);
+	/* set bit if it is not already set and is a valid bit */
+	if (zone->bitmap && bitnr < zone->nbits &&
+	    !test_and_set_bit(bitnr, zone->bitmap))
+		atomic_inc(&zone->free_pages);
+}
+
+static int process_free_page(struct page *page,
+			     struct page_reporting_config *phconf, int count)
+{
+	int mt, order, ret = 0;
+
+	mt = get_pageblock_migratetype(page);
+	order = page_private(page);
+	ret = __isolate_free_page(page, order);
+
+	if (ret) {
+		/*
+		 * Preserving order and migratetype for reuse while
+		 * releasing the pages back to the buddy.
+		 */
+		set_pageblock_migratetype(page, mt);
+		set_page_private(page, order);
+
+		sg_set_page(&phconf->sg[count++], page,
+			    PAGE_SIZE << order, 0);
+	}
+
+	return count;
+}
+
+/**
+ * scan_zone_bitmap - scans the bitmap for the requested zone.
+ * @phconf: page reporting configuration object initialized by the backend.
+ * @zone: zone for which page reporting is requested.
+ *
+ * For every page marked in the bitmap it checks if it is still free if so it
+ * isolates and adds them to a scatterlist. As soon as the number of isolated
+ * pages reach the threshold set by the backend, they are reported to the
+ * hypervisor by the backend. Once the hypervisor responds after processing
+ * they are returned back to the buddy for reuse.
+ */
+static void scan_zone_bitmap(struct page_reporting_config *phconf,
+			     struct zone *zone)
+{
+	unsigned long setbit;
+	struct page *page;
+	int count = 0;
+
+	sg_init_table(phconf->sg, phconf->max_pages);
+
+	for_each_set_bit(setbit, zone->bitmap, zone->nbits) {
+		/* Process only if the page is still online */
+		page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
+					  zone->base_pfn);
+		if (!page)
+			continue;
+
+		spin_lock(&zone->lock);
+
+		/* Ensure page is still free and can be processed */
+		if (PageBuddy(page) && page_private(page) >=
+		    PAGE_REPORTING_MIN_ORDER)
+			count = process_free_page(page, phconf, count);
+
+		spin_unlock(&zone->lock);
+		/* Page has been processed, adjust its bit and zone counter */
+		clear_bit(setbit, zone->bitmap);
+		atomic_dec(&zone->free_pages);
+
+		if (count == phconf->max_pages) {
+			/* Report isolated pages to the hypervisor */
+			phconf->report(phconf, count);
+
+			/* Return processed pages back to the buddy */
+			return_isolated_page(zone, phconf);
+
+			/* Reset for next reporting */
+			sg_init_table(phconf->sg, phconf->max_pages);
+			count = 0;
+		}
+	}
+	/*
+	 * If the number of isolated pages does not meet the max_pages
+	 * threshold, we would still prefer to report them as we have already
+	 * isolated them.
+	 */
+	if (count) {
+		sg_mark_end(&phconf->sg[count - 1]);
+		phconf->report(phconf, count);
+
+		return_isolated_page(zone, phconf);
+	}
+}
+
+/**
+ * page_reporting_wq - checks the number of free_pages in all the zones and
+ * invokes a request to scan the respective bitmap if free_pages reaches or
+ * exceeds the threshold specified by the backend.
+ */
+static void page_reporting_wq(struct work_struct *work)
+{
+	struct page_reporting_config *phconf =
+		container_of(work, struct page_reporting_config,
+			     reporting_work);
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		if (atomic_read(&zone->free_pages) >= phconf->max_pages)
+			scan_zone_bitmap(phconf, zone);
+	}
+	/*
+	 * We have processed all the zones, we can process new page reporting
+	 * request now.
+	 */
+	atomic_set(&phconf->refcnt, 0);
+}
+
+/**
+ * __page_reporting_enqueue - tracks the freed page in the respective zone's
+ * bitmap and enqueues a new page reporting job to the workqueue if possible.
+ */
+void __page_reporting_enqueue(struct page *page)
+{
+	struct page_reporting_config *phconf;
+	struct zone *zone;
+
+	rcu_read_lock();
+	/*
+	 * We should not process this page if either page reporting is not
+	 * yet completely enabled or it has been disabled by the backend.
+	 */
+	phconf = rcu_dereference(page_reporting_conf);
+	if (!phconf)
+		return;
+
+	zone = page_zone(page);
+	bitmap_set_bit(page, zone);
+
+	/*
+	 * We should not enqueue a job if a previously enqueued reporting work
+	 * is in progress or we don't have enough free pages in the zone.
+	 */
+	if (atomic_read(&zone->free_pages) >= phconf->max_pages &&
+	    !atomic_cmpxchg(&phconf->refcnt, 0, 1))
+		schedule_work(&phconf->reporting_work);
+
+	rcu_read_unlock();
+}
+
+/**
+ * zone_reporting_cleanup - resets the page reporting fields and free the
+ * bitmap for all the initialized zones.
+ */
+static void zone_reporting_cleanup(void)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		/*
+		 * Bitmap may not be allocated for all the zones if the
+		 * initialization fails before reaching to the last one.
+		 */
+		if (!zone->bitmap)
+			continue;
+		bitmap_free(zone->bitmap);
+		zone->bitmap = NULL;
+		atomic_set(&zone->free_pages, 0);
+	}
+}
+
+static int zone_bitmap_alloc(struct zone *zone)
+{
+	unsigned long bitmap_size, pages;
+
+	pages = zone->end_pfn - zone->base_pfn;
+	bitmap_size = (pages >> PAGE_REPORTING_MIN_ORDER) + 1;
+
+	if (!bitmap_size)
+		return 0;
+
+	zone->bitmap = bitmap_zalloc(bitmap_size, GFP_KERNEL);
+	if (!zone->bitmap)
+		return -ENOMEM;
+
+	zone->nbits = bitmap_size;
+
+	return 0;
+}
+
+/**
+ * zone_reporting_init - For each zone initializes the page reporting fields
+ * and allocates the respective bitmap.
+ *
+ * This function returns 0 on successful initialization, -ENOMEM otherwise.
+ */
+static int zone_reporting_init(void)
+{
+	struct zone *zone;
+	int ret;
+
+	for_each_populated_zone(zone) {
+#ifdef CONFIG_ZONE_DEVICE
+		/* we can not report pages which are not in the buddy */
+		if (zone_idx(zone) == ZONE_DEVICE)
+			continue;
+#endif
+		spin_lock(&zone->lock);
+		zone->base_pfn = zone->zone_start_pfn;
+		zone->end_pfn = zone_end_pfn(zone);
+		spin_unlock(&zone->lock);
+
+		ret = zone_bitmap_alloc(zone);
+		if (ret < 0) {
+			zone_reporting_cleanup();
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+void page_reporting_disable(struct page_reporting_config *phconf)
+{
+	mutex_lock(&page_reporting_mutex);
+
+	if (rcu_access_pointer(page_reporting_conf) != phconf)
+		return;
+
+	RCU_INIT_POINTER(page_reporting_conf, NULL);
+	synchronize_rcu();
+
+	/* Cancel any pending reporting request */
+	cancel_work_sync(&phconf->reporting_work);
+
+	/* Free the scatterlist used for isolated pages */
+	kfree(phconf->sg);
+	phconf->sg = NULL;
+
+	/* Cleanup the bitmaps and old tracking data */
+	zone_reporting_cleanup();
+
+	mutex_unlock(&page_reporting_mutex);
+}
+EXPORT_SYMBOL_GPL(page_reporting_disable);
+
+int page_reporting_enable(struct page_reporting_config *phconf)
+{
+	int ret = 0;
+
+	mutex_lock(&page_reporting_mutex);
+
+	/* check if someone is already using page reporting*/
+	if (rcu_access_pointer(page_reporting_conf)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* allocate scatterlist to hold isolated pages */
+	phconf->sg = kcalloc(phconf->max_pages, sizeof(*phconf->sg),
+			     GFP_KERNEL);
+	if (!phconf->sg) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* initialize each zone's fields required for page reporting */
+	ret = zone_reporting_init();
+	if (ret < 0) {
+		kfree(phconf->sg);
+		goto out;
+	}
+
+	atomic_set(&phconf->refcnt, 0);
+	INIT_WORK(&phconf->reporting_work, page_reporting_wq);
+
+	/* assign the configuration object provided by the backend */
+	rcu_assign_pointer(page_reporting_conf, phconf);
+
+out:
+	mutex_unlock(&page_reporting_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(page_reporting_enable);
-- 
2.21.0

