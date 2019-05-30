Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108923043E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfE3Vyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:38 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43148 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfE3Vyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:54:37 -0400
Received: by mail-ot1-f67.google.com with SMTP id i8so7145738oth.10;
        Thu, 30 May 2019 14:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VrUdZuuah1ePBnYB1FF7mjrwNfzoFpJZPyHrGDL/mrg=;
        b=RWkM8Yl5fLEz/8vjf5jVcRJXT8EF4ayMTXv7VUaV9qHT5iuiRJFkfD2jAc7TX5vZE9
         R6fwxU1uo7dbhu+Ta23F46YEx+EpstmpbboqE8ZzWfc73qPEBl8SVwYR3OxGein+w+pF
         4TKspLHWCWLJrXCjZkUbFlNZ2p32JYAHCBjCKjE0s7lDIugHB2trrFgc3MpeSVSn9ypB
         iv0ZOemcgSITjKPMhkRw5HzR45ku6p6dVQrLPKbpZ6koXhcRFmuK2wVawtM0hYmcTq/i
         rJ860wczu4at7pY2GoVb3tGpoh2NxTlvLYvJS5tmmmm2w6Kv/KKg9NscA0k+VbbULgUG
         PZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VrUdZuuah1ePBnYB1FF7mjrwNfzoFpJZPyHrGDL/mrg=;
        b=dNh6XH5kYpGjRJQL6Ttm4VRYSmusW6NdAcu/px4GwN8COky9n9qrbKtQFSh8bEtQ/w
         Vzbq1ikXUxDzkOB8IH9MZYz4V4RwpBQgDbBOqzzKYMihWzkeEUxIV0B+H5QoQZJfvhwP
         t0E+A/INTXVCVZHTLg6HEudWx+EI/Uum+OYANsmSB+rjlQGy6NjL0VRw0gM+DEjlzQW2
         6NKX4I+uL+D1pHyIj6V1xEhoBOPvcdIavlld+E68CFNXeFjEPztOrB6+Bmydv1obZ8gh
         EPGQw/QRpFoTDcdJRY52nkWPzMlijqXKxnU7M6DrBbFmEtAgVbGWwtFgEl4ht41sleAA
         7jLg==
X-Gm-Message-State: APjAAAXyOzGZukSZtnoJWIWWKw9nDu6ZHQuieavwkmfVA1Edz/YSw2nB
        UC2jOh4yXFOT7oHfLPdwM98=
X-Google-Smtp-Source: APXvYqw7g1L+G0cqINE4PJyWCvfS0dKJpUSfVKFCiCqnvg3eJwWRViAbuOlMVDgf+SLDserE4hl5Ig==
X-Received: by 2002:a05:6830:1318:: with SMTP id p24mr2104325otq.75.1559253276059;
        Thu, 30 May 2019 14:54:36 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id z16sm1117798ote.50.2019.05.30.14.54.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:54:35 -0700 (PDT)
Subject: [RFC PATCH 08/11] mm: Add support for creating memory aeration
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:54:33 -0700
Message-ID: <20190530215433.13974.43219.stgit@localhost.localdomain>
In-Reply-To: <20190530215223.13974.22445.stgit@localhost.localdomain>
References: <20190530215223.13974.22445.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for "aerating" memory in a guest by pushing individual pages
out. This patch is meant to add generic support for this by adding a common
framework that can be used later by drivers such as virtio-balloon.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/memory_aeration.h |   54 +++++++
 mm/Kconfig                      |    5 +
 mm/Makefile                     |    1 
 mm/aeration.c                   |  320 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 380 insertions(+)
 create mode 100644 include/linux/memory_aeration.h
 create mode 100644 mm/aeration.c

diff --git a/include/linux/memory_aeration.h b/include/linux/memory_aeration.h
new file mode 100644
index 000000000000..5ba0e634f240
--- /dev/null
+++ b/include/linux/memory_aeration.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEMORY_AERATION_H
+#define _LINUX_MEMORY_AERATION_H
+
+#include <linux/pageblock-flags.h>
+#include <linux/jump_label.h>
+#include <asm/pgtable_types.h>
+
+struct zone;
+
+#define AERATOR_MIN_ORDER	pageblock_order
+
+struct aerator_dev_info {
+	unsigned long capacity;
+	struct list_head batch_reactor;
+	atomic_t refcnt;
+	void (*react)(struct aerator_dev_info *a_dev_info);
+};
+
+extern struct static_key aerator_notify_enabled;
+
+void aerator_cycle(void);
+void __aerator_notify(struct zone *zone, int order);
+
+/**
+ * aerator_notify_free - Free page notification that will start page processing
+ * @page: Last page processed
+ * @zone: Pointer to current zone of last page processed
+ * @order: Order of last page added to zone
+ *
+ * This function is meant to act as a screener for __aerator_notify which
+ * will determine if a give zone has crossed over the high-water mark that
+ * will justify us beginning page treatment. If we have crossed that
+ * threshold then it will start the process of pulling some pages and
+ * placing them in the batch_reactor list for treatment.
+ */
+static inline void
+aerator_notify_free(struct page *page, struct zone *zone, int order)
+{
+	if (!static_key_false(&aerator_notify_enabled))
+		return;
+
+	if (order < AERATOR_MIN_ORDER)
+		return;
+
+	__aerator_notify(zone, order);
+}
+
+void aerator_shutdown(void);
+int aerator_startup(struct aerator_dev_info *sdev);
+
+#define AERATOR_ZONE_BITS	(BITS_TO_LONGS(MAX_NR_ZONES) * BITS_PER_LONG)
+#define AERATOR_HWM_BITS	(AERATOR_ZONE_BITS * MAX_NUMNODES)
+#endif /*_LINUX_MEMORY_AERATION_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index f0c76ba47695..34680214cefa 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -236,6 +236,11 @@ config COMPACTION
           linux-mm@kvack.org.
 
 #
+# support for memory aeration
+config AERATION
+	bool
+
+#
 # support for page migration
 #
 config MIGRATION
diff --git a/mm/Makefile b/mm/Makefile
index ac5e5ba78874..26c2fcd2b89d 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -104,3 +104,4 @@ obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
 obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
 obj-$(CONFIG_HMM) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
+obj-$(CONFIG_AERATION) += aeration.o
diff --git a/mm/aeration.c b/mm/aeration.c
new file mode 100644
index 000000000000..aaf8af8d822f
--- /dev/null
+++ b/mm/aeration.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/memory_aeration.h>
+#include <linux/mmzone.h>
+#include <linux/gfp.h>
+#include <linux/export.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+static unsigned long *aerator_hwm;
+static struct aerator_dev_info *a_dev_info;
+struct static_key aerator_notify_enabled;
+
+void aerator_shutdown(void)
+{
+	static_key_slow_dec(&aerator_notify_enabled);
+
+	while (atomic_read(&a_dev_info->refcnt))
+		msleep(20);
+
+	kfree(aerator_hwm);
+	aerator_hwm = NULL;
+
+	a_dev_info = NULL;
+}
+EXPORT_SYMBOL_GPL(aerator_shutdown);
+
+int aerator_startup(struct aerator_dev_info *sdev)
+{
+	size_t size = BITS_TO_LONGS(AERATOR_HWM_BITS) * sizeof(unsigned long);
+	unsigned long *hwm;
+
+	if (a_dev_info || aerator_hwm)
+		return -EBUSY;
+
+	a_dev_info = sdev;
+
+	atomic_set(&sdev->refcnt, 0);
+
+	hwm = kzalloc(size, GFP_KERNEL);
+	if (!hwm) {
+		aerator_shutdown();
+		return -ENOMEM;
+	}
+
+	aerator_hwm = hwm;
+
+	static_key_slow_inc(&aerator_notify_enabled);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aerator_startup);
+
+static inline unsigned long *get_aerator_hwm(int nid)
+{
+	if (!aerator_hwm)
+		return NULL;
+
+	return aerator_hwm + (BITS_TO_LONGS(MAX_NR_ZONES) * nid);
+}
+
+static int __aerator_fill(struct zone *zone, unsigned int size)
+{
+	struct list_head *batch = &a_dev_info->batch_reactor;
+	unsigned long nr_raw = 0;
+	unsigned int len = 0;
+	unsigned int order;
+
+	for (order = MAX_ORDER; order-- != AERATOR_MIN_ORDER;) {
+		struct free_area *area = &(zone->free_area[order]);
+		int mt = area->treatment_mt;
+
+		/*
+		 * If there are no untreated pages to pull
+		 * then we might as well skip the area.
+		 */
+		while (area->nr_free_raw) {
+			unsigned int count = 0;
+			struct page *page;
+
+			/*
+			 * If we completed aeration we can let the current
+			 * free list work on settling so that a batch of
+			 * new raw pages can build. In the meantime move on
+			 * to the next migratetype.
+			 */
+			if (++mt >= MIGRATE_TYPES)
+				mt = 0;
+
+			/*
+			 * Pull pages from free list until we have drained
+			 * it or we have filled the batch reactor.
+			 */
+			while ((page = get_raw_pages(zone, order, mt))) {
+				list_add(&page->lru, batch);
+
+				if (++count == (size - len))
+					return size;
+			}
+
+			/*
+			 * If we pulled any pages from this migratetype then
+			 * we must move on to a new free area as we cannot
+			 * move the membrane until after we have decanted the
+			 * pages currently being aerated.
+			 */
+			if (count) {
+				len += count;
+				break;
+			}
+		}
+
+		/*
+		 * Keep a running total of the raw packets we have left
+		 * behind. We will use this to determine if we should
+		 * clear the HWM flag.
+		 */
+		nr_raw += area->nr_free_raw;
+	}
+
+	/*
+	 * If there are no longer enough free pages to fully populate
+	 * the aerator, then we can just shut it down for this zone.
+	 */
+	if (nr_raw < a_dev_info->capacity) {
+		unsigned long *hwm = get_aerator_hwm(zone_to_nid(zone));
+
+		clear_bit(zone_idx(zone), hwm);
+		atomic_dec(&a_dev_info->refcnt);
+	}
+
+	return len;
+}
+
+static unsigned int aerator_fill(int nid, int zid, int budget)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	struct zone *zone = &pgdat->node_zones[zid];
+	unsigned long flags;
+	int len;
+
+	spin_lock_irqsave(&zone->lock, flags);
+
+	/* fill aerator with "raw" pages */
+	len = __aerator_fill(zone, budget);
+
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	return len;
+}
+
+static void aerator_fill_and_react(void)
+{
+	int budget = a_dev_info->capacity;
+	int nr;
+
+	/*
+	 * We should never be calling this function while there are already
+	 * pages in the reactor being aerated. If we are called under such
+	 * a circumstance report an error.
+	 */
+	BUG_ON(!list_empty(&a_dev_info->batch_reactor));
+retry:
+	/*
+	 * We want to hold one additional reference against the number of
+	 * active hints as we may clear the hint that originally brought us
+	 * here. We will clear it after we have either vaporized the content
+	 * of the pages, or if we discover all pages were stolen out from
+	 * under us.
+	 */
+	atomic_inc(&a_dev_info->refcnt);
+
+	for_each_set_bit(nr, aerator_hwm, AERATOR_HWM_BITS) {
+		int node_id = nr / AERATOR_ZONE_BITS;
+		int zone_id = nr % AERATOR_ZONE_BITS;
+
+		budget -= aerator_fill(node_id, zone_id, budget);
+		if (!budget)
+			goto start_aerating;
+	}
+
+	if (unlikely(list_empty(&a_dev_info->batch_reactor))) {
+		/*
+		 * If we never generated any pages, and we were holding the
+		 * only remaining reference to active hints then we can
+		 * just let this go for now and go idle.
+		 */
+		if (atomic_dec_and_test(&a_dev_info->refcnt))
+			return;
+
+		/*
+		 * There must be a bit populated somewhere, try going
+		 * back through and finding it.
+		 */
+		goto retry;
+	}
+
+start_aerating:
+	a_dev_info->react(a_dev_info);
+}
+
+void aerator_decant(void)
+{
+	struct list_head *list = &a_dev_info->batch_reactor;
+	struct page *page;
+
+	/*
+	 * This function should never be called on an empty list. If so it
+	 * points to a bug as we should never be running the aerator when
+	 * the list is empty.
+	 */
+	WARN_ON(list_empty(&a_dev_info->batch_reactor));
+
+	while ((page = list_first_entry_or_null(list, struct page, lru))) {
+		list_del(&page->lru);
+
+		__SetPageTreated(page);
+
+		free_treated_page(page);
+	}
+}
+
+/**
+ * aerator_cycle - drain, fill, and start aerating another batch of pages
+ *
+ * This function is at the heart of the aerator. It should be called after
+ * the previous batch of pages has finished being processed by the aerator.
+ * It will drain the aerator, refill it, and start the next set of pages
+ * being processed.
+ */
+void aerator_cycle(void)
+{
+	aerator_decant();
+
+	/*
+	 * Now that the pages have been flushed we can drop our reference to
+	 * the active hints list. If there are no further hints that need to
+	 * be processed we can simply go idle.
+	 */
+	if (atomic_dec_and_test(&a_dev_info->refcnt))
+		return;
+
+	aerator_fill_and_react();
+}
+EXPORT_SYMBOL_GPL(aerator_cycle);
+
+static void __aerator_fill_and_react(struct zone *zone)
+{
+	/*
+	 * We should never be calling this function while there are already
+	 * pages in the list being aerated. If we are called under such a
+	 * circumstance report an error.
+	 */
+	BUG_ON(!list_empty(&a_dev_info->batch_reactor));
+
+	/*
+	 * We want to hold one additional reference against the number of
+	 * active hints as we may clear the hint that originally brought us
+	 * here. We will clear it after we have either vaporized the content
+	 * of the pages, or if we discover all pages were stolen out from
+	 * under us.
+	 */
+	atomic_inc(&a_dev_info->refcnt);
+
+	__aerator_fill(zone, a_dev_info->capacity);
+
+	if (unlikely(list_empty(&a_dev_info->batch_reactor))) {
+		/*
+		 * If we never generated any pages, and we were holding the
+		 * only remaining reference to active hints then we can just
+		 * let this go for now and go idle.
+		 */
+		if (atomic_dec_and_test(&a_dev_info->refcnt))
+			return;
+
+		/*
+		 * Another zone must have populated some raw pages that
+		 * need to be processed. Release the zone lock and process
+		 * that zone instead.
+		 */
+		spin_unlock(&zone->lock);
+		aerator_fill_and_react();
+	} else {
+		/* Release the zone lock and begin the page aerator */
+		spin_unlock(&zone->lock);
+		a_dev_info->react(a_dev_info);
+	}
+
+	/* Reaquire lock so we can resume processing this zone */
+	spin_lock(&zone->lock);
+}
+
+void __aerator_notify(struct zone *zone, int order)
+{
+	int node_id = zone_to_nid(zone);
+	int zone_id = zone_idx(zone);
+	unsigned long *hwm;
+
+	if (zone->free_area[order].nr_free_raw < (2 * a_dev_info->capacity))
+		return;
+
+	hwm = get_aerator_hwm(node_id);
+
+	/*
+	 * We an use separate test and set operations here as there
+	 * is nothing else that can set or clear this bit while we are
+	 * holding the zone lock. The advantage to doing it this way is
+	 * that we don't have to dirty the cacheline unless we are
+	 * changing the value.
+	 */
+	if (test_bit(zone_id, hwm))
+		return;
+	set_bit(zone_id, hwm);
+
+	if (atomic_fetch_inc(&a_dev_info->refcnt))
+		return;
+
+	__aerator_fill_and_react(zone);
+}
+EXPORT_SYMBOL_GPL(__aerator_notify);
+

