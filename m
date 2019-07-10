Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7740664CFF
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 21:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbfGJTw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 15:52:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfGJTw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 15:52:28 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3500430C0DFE;
        Wed, 10 Jul 2019 19:52:27 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 686A219C70;
        Wed, 10 Jul 2019 19:52:25 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, pbonzini@redhat.com, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com, yang.zhang.wz@gmail.com,
        riel@surriel.com, david@redhat.com, mst@redhat.com,
        dodgen@google.com, konrad.wilk@oracle.com, dhildenb@redhat.com,
        aarcange@redhat.com, alexander.duyck@gmail.com,
        john.starks@microsoft.com, dave.hansen@intel.com, mhocko@suse.com
Subject: [RFC][Patch v11 1/2] mm: page_hinting: core infrastructure
Date:   Wed, 10 Jul 2019 15:51:57 -0400
Message-Id: <20190710195158.19640-2-nitesh@redhat.com>
In-Reply-To: <20190710195158.19640-1-nitesh@redhat.com>
References: <20190710195158.19640-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 10 Jul 2019 19:52:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces the core infrastructure for free page hinting in
virtual environments. It enables the kernel to track the free pages which
can be reported to its hypervisor so that the hypervisor could
free and reuse that memory as per its requirement.

While the pages are getting processed in the hypervisor (e.g.,
via MADV_FREE), the guest must not use them, otherwise, data loss
would be possible. To avoid such a situation, these pages are
temporarily removed from the buddy. The amount of pages removed
temporarily from the buddy is governed by the backend(virtio-balloon
in our case).

To efficiently identify free pages that can to be hinted to the
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

There are still various things to look into (e.g., memory hotplug, more
efficient locking, possible races when disabling).

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/linux/page_hinting.h |  45 +++++++
 mm/Kconfig                   |   6 +
 mm/Makefile                  |   1 +
 mm/page_alloc.c              |  18 +--
 mm/page_hinting.c            | 250 +++++++++++++++++++++++++++++++++++
 5 files changed, 312 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/page_hinting.h
 create mode 100644 mm/page_hinting.c

diff --git a/include/linux/page_hinting.h b/include/linux/page_hinting.h
new file mode 100644
index 000000000000..4900feb796f9
--- /dev/null
+++ b/include/linux/page_hinting.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PAGE_HINTING_H
+#define _LINUX_PAGE_HINTING_H
+
+/*
+ * Minimum page order required for a page to be hinted to the host.
+ */
+#define PAGE_HINTING_MIN_ORDER		(MAX_ORDER - 2)
+
+/*
+ * struct page_hinting_config: holds the information supplied by the balloon
+ * device to page hinting.
+ * @hint_pages:		Callback which reports the isolated pages
+ *			synchornously to the host.
+ * @max_pages:		Maxmimum pages that are going to be hinted to the host
+ *			at a time of granularity >= PAGE_HINTING_MIN_ORDER.
+ */
+struct page_hinting_config {
+	void (*hint_pages)(struct list_head *list);
+	int max_pages;
+};
+
+extern int __isolate_free_page(struct page *page, unsigned int order);
+extern void __free_one_page(struct page *page, unsigned long pfn,
+			    struct zone *zone, unsigned int order,
+			    int migratetype, bool hint);
+#ifdef CONFIG_PAGE_HINTING
+void page_hinting_enqueue(struct page *page, int order);
+int page_hinting_enable(const struct page_hinting_config *conf);
+void page_hinting_disable(void);
+#else
+static inline void page_hinting_enqueue(struct page *page, int order)
+{
+}
+
+static inline int page_hinting_enable(const struct page_hinting_config *conf)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void page_hinting_disable(void)
+{
+}
+#endif
+#endif /* _LINUX_PAGE_HINTING_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index f0c76ba47695..e97fab429d9b 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -765,4 +765,10 @@ config GUP_BENCHMARK
 config ARCH_HAS_PTE_SPECIAL
 	bool
 
+# PAGE_HINTING will allow the guest to report the free pages to the
+# host in fixed chunks as soon as the threshold is reached.
+config PAGE_HINTING
+       bool
+       def_bool n
+       depends on X86_64
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index ac5e5ba78874..73be49177656 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_Z3FOLD)	+= z3fold.o
 obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
 obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
+obj-$(CONFIG_PAGE_HINTING) += page_hinting.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
 obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d66bc8abe0af..8a44338bd04e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -69,6 +69,7 @@
 #include <linux/lockdep.h>
 #include <linux/nmi.h>
 #include <linux/psi.h>
+#include <linux/page_hinting.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -874,10 +875,10 @@ compaction_capture(struct capture_control *capc, struct page *page,
  * -- nyc
  */
 
-static inline void __free_one_page(struct page *page,
+inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool hint)
 {
 	unsigned long combined_pfn;
 	unsigned long uninitialized_var(buddy_pfn);
@@ -980,7 +981,8 @@ static inline void __free_one_page(struct page *page,
 				migratetype);
 	else
 		add_to_free_area(page, &zone->free_area[order], migratetype);
-
+	if (hint)
+		page_hinting_enqueue(page, order);
 }
 
 /*
@@ -1263,7 +1265,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1272,14 +1274,14 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 static void free_one_page(struct zone *zone,
 				struct page *page, unsigned long pfn,
 				unsigned int order,
-				int migratetype)
+				int migratetype, bool hint)
 {
 	spin_lock(&zone->lock);
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype, hint);
 	spin_unlock(&zone->lock);
 }
 
@@ -1369,7 +1371,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, pfn, order, migratetype);
+	free_one_page(page_zone(page), page, pfn, order, migratetype, true);
 	local_irq_restore(flags);
 }
 
@@ -2969,7 +2971,7 @@ static void free_unref_page_commit(struct page *page, unsigned long pfn)
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(zone, page, pfn, 0, migratetype);
+			free_one_page(zone, page, pfn, 0, migratetype, true);
 			return;
 		}
 		migratetype = MIGRATE_MOVABLE;
diff --git a/mm/page_hinting.c b/mm/page_hinting.c
new file mode 100644
index 000000000000..0bfa09f8c3ed
--- /dev/null
+++ b/mm/page_hinting.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Page hinting core infrastructure to enable a VM to report free pages to its
+ * hypervisor.
+ *
+ * Copyright Red Hat, Inc. 2019
+ *
+ * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/page_hinting.h>
+#include <linux/kvm_host.h>
+
+/*
+ * struct zone_free_area: For a single zone across NUMA nodes, it holds the
+ * bitmap pointer to track the free pages and other required parameters
+ * used to recover these pages by scanning the bitmap.
+ * @bitmap:		Pointer to the bitmap in PAGE_HINTING_MIN_ORDER
+ *			granularity.
+ * @base_pfn:		Starting PFN value for the zone whose bitmap is stored.
+ * @end_pfn:		Indicates the last PFN value for the zone.
+ * @free_pages:		Tracks the number of free pages of granularity
+ *			PAGE_HINTING_MIN_ORDER.
+ * @nbits:		Indicates the total size of the bitmap in bits allocated
+ *			at the time of initialization.
+ */
+struct zone_free_area {
+	unsigned long *bitmap;
+	unsigned long base_pfn;
+	unsigned long end_pfn;
+	atomic_t free_pages;
+	unsigned long nbits;
+} free_area[MAX_NR_ZONES];
+
+static void init_hinting_wq(struct work_struct *work);
+static DEFINE_MUTEX(page_hinting_init);
+const struct page_hinting_config *page_hitning_conf;
+struct work_struct hinting_work;
+atomic_t page_hinting_active;
+
+void free_area_cleanup(int nr_zones)
+{
+	int zone_idx;
+
+	for (zone_idx = 0; zone_idx < nr_zones; zone_idx++) {
+		bitmap_free(free_area[zone_idx].bitmap);
+		free_area[zone_idx].base_pfn = 0;
+		free_area[zone_idx].end_pfn = 0;
+		free_area[zone_idx].nbits = 0;
+		atomic_set(&free_area[zone_idx].free_pages, 0);
+	}
+}
+
+int page_hinting_enable(const struct page_hinting_config *conf)
+{
+	unsigned long bitmap_size = 0;
+	int zone_idx = 0, ret = -EBUSY;
+	struct zone *zone;
+
+	mutex_lock(&page_hinting_init);
+	if (!page_hitning_conf) {
+		for_each_populated_zone(zone) {
+			zone_idx = zone_idx(zone);
+#ifdef CONFIG_ZONE_DEVICE
+			if (zone_idx == ZONE_DEVICE)
+				continue;
+#endif
+			spin_lock(&zone->lock);
+			if (free_area[zone_idx].base_pfn) {
+				free_area[zone_idx].base_pfn =
+					min(free_area[zone_idx].base_pfn,
+					    zone->zone_start_pfn);
+				free_area[zone_idx].end_pfn =
+					max(free_area[zone_idx].end_pfn,
+					    zone->zone_start_pfn +
+					    zone->spanned_pages);
+			} else {
+				free_area[zone_idx].base_pfn =
+					zone->zone_start_pfn;
+				free_area[zone_idx].end_pfn =
+					zone->zone_start_pfn +
+					zone->spanned_pages;
+			}
+			spin_unlock(&zone->lock);
+		}
+
+		for (zone_idx = 0; zone_idx < MAX_NR_ZONES; zone_idx++) {
+			unsigned long pages = free_area[zone_idx].end_pfn -
+					free_area[zone_idx].base_pfn;
+			bitmap_size = (pages >> PAGE_HINTING_MIN_ORDER) + 1;
+			if (!bitmap_size)
+				continue;
+			free_area[zone_idx].bitmap = bitmap_zalloc(bitmap_size,
+								   GFP_KERNEL);
+			if (!free_area[zone_idx].bitmap) {
+				free_area_cleanup(zone_idx);
+				mutex_unlock(&page_hinting_init);
+				return -ENOMEM;
+			}
+			free_area[zone_idx].nbits = bitmap_size;
+		}
+		page_hitning_conf = conf;
+		INIT_WORK(&hinting_work, init_hinting_wq);
+		ret = 0;
+	}
+	mutex_unlock(&page_hinting_init);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(page_hinting_enable);
+
+void page_hinting_disable(void)
+{
+	cancel_work_sync(&hinting_work);
+	page_hitning_conf = NULL;
+	free_area_cleanup(MAX_NR_ZONES);
+}
+EXPORT_SYMBOL_GPL(page_hinting_disable);
+
+static unsigned long pfn_to_bit(struct page *page, int zone_idx)
+{
+	unsigned long bitnr;
+
+	bitnr = (page_to_pfn(page) - free_area[zone_idx].base_pfn)
+			 >> PAGE_HINTING_MIN_ORDER;
+	return bitnr;
+}
+
+static void release_buddy_pages(struct list_head *pages)
+{
+	int mt = 0, zone_idx, order;
+	struct page *page, *next;
+	unsigned long bitnr;
+	struct zone *zone;
+
+	list_for_each_entry_safe(page, next, pages, lru) {
+		zone_idx = page_zonenum(page);
+		zone = page_zone(page);
+		bitnr = pfn_to_bit(page, zone_idx);
+		spin_lock(&zone->lock);
+		list_del(&page->lru);
+		order = page_private(page);
+		set_page_private(page, 0);
+		mt = get_pageblock_migratetype(page);
+		__free_one_page(page, page_to_pfn(page), zone,
+				order, mt, false);
+		spin_unlock(&zone->lock);
+	}
+}
+
+static void bm_set_pfn(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+	int zone_idx = page_zonenum(page);
+	unsigned long bitnr = 0;
+
+	lockdep_assert_held(&zone->lock);
+	bitnr = pfn_to_bit(page, zone_idx);
+	/*
+	 * TODO: fix possible underflows.
+	 */
+	if (free_area[zone_idx].bitmap &&
+	    bitnr < free_area[zone_idx].nbits &&
+	    !test_and_set_bit(bitnr, free_area[zone_idx].bitmap))
+		atomic_inc(&free_area[zone_idx].free_pages);
+}
+
+static void scan_zone_free_area(int zone_idx, int free_pages)
+{
+	int ret = 0, order, isolated_cnt = 0;
+	unsigned long set_bit, start = 0;
+	LIST_HEAD(isolated_pages);
+	struct page *page;
+	struct zone *zone;
+
+	for (;;) {
+		ret = 0;
+		set_bit = find_next_bit(free_area[zone_idx].bitmap,
+					free_area[zone_idx].nbits, start);
+		if (set_bit >= free_area[zone_idx].nbits)
+			break;
+		page = pfn_to_online_page((set_bit << PAGE_HINTING_MIN_ORDER) +
+				free_area[zone_idx].base_pfn);
+		if (!page)
+			continue;
+		zone = page_zone(page);
+		spin_lock(&zone->lock);
+
+		if (PageBuddy(page) && page_private(page) >=
+		    PAGE_HINTING_MIN_ORDER) {
+			order = page_private(page);
+			ret = __isolate_free_page(page, order);
+		}
+		clear_bit(set_bit, free_area[zone_idx].bitmap);
+		atomic_dec(&free_area[zone_idx].free_pages);
+		spin_unlock(&zone->lock);
+		if (ret) {
+			/*
+			 * restoring page order to use it while releasing
+			 * the pages back to the buddy.
+			 */
+			set_page_private(page, order);
+			list_add_tail(&page->lru, &isolated_pages);
+			isolated_cnt++;
+			if (isolated_cnt == page_hitning_conf->max_pages) {
+				page_hitning_conf->hint_pages(&isolated_pages);
+				release_buddy_pages(&isolated_pages);
+				isolated_cnt = 0;
+			}
+		}
+		start = set_bit + 1;
+	}
+	if (isolated_cnt) {
+		page_hitning_conf->hint_pages(&isolated_pages);
+		release_buddy_pages(&isolated_pages);
+	}
+}
+
+static void init_hinting_wq(struct work_struct *work)
+{
+	int zone_idx, free_pages;
+
+	atomic_set(&page_hinting_active, 1);
+	for (zone_idx = 0; zone_idx < MAX_NR_ZONES; zone_idx++) {
+		free_pages = atomic_read(&free_area[zone_idx].free_pages);
+		if (free_pages >= page_hitning_conf->max_pages)
+			scan_zone_free_area(zone_idx, free_pages);
+	}
+	atomic_set(&page_hinting_active, 0);
+}
+
+void page_hinting_enqueue(struct page *page, int order)
+{
+	int zone_idx;
+
+	if (!page_hitning_conf || order < PAGE_HINTING_MIN_ORDER)
+		return;
+
+	bm_set_pfn(page);
+	if (atomic_read(&page_hinting_active))
+		return;
+	zone_idx = zone_idx(page_zone(page));
+	if (atomic_read(&free_area[zone_idx].free_pages) >=
+			page_hitning_conf->max_pages) {
+		int cpu = smp_processor_id();
+
+		queue_work_on(cpu, system_wq, &hinting_work);
+	}
+}
-- 
2.21.0

