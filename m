Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580754C3B6
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 00:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730938AbfFSWdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 18:33:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34378 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730504AbfFSWde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 18:33:34 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so187437iot.1;
        Wed, 19 Jun 2019 15:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=OnfCOLVUM2RdwkrCGbwB+NaigOrBL5HPfiKOHiPEd+Q=;
        b=VOj/Ebn5EmXVZGb7w3umnmzaylkU/2Mwo9MY4M7o56x1OkSv27WjZ+qp8OSOch2Kwg
         uOHFWPdmdCJbtRsBpzIaWhLNmCjs0BmAfVDNwQ1+LnfFp0wHRWRs0tfTU4G5ZGolUo5q
         kbiCoiPafMyGLqeXWRH5nbFk8fbtYK9rzwhm+GZWXoVUD2T7SuaM9uzpierFXpCjBakk
         mEk1JuHBzZRaYDamWy4DRFni1oycKwq4u7sxLduBDo/Za9qyUACaAv5bV7Kf9ErOZIsa
         zn9UNKNGz9LWE9g8NRzRjUa3MTd3hxH5zjZy2x0sqUeiznvSAAb1YMuzrHGDaCkUgWoi
         naCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=OnfCOLVUM2RdwkrCGbwB+NaigOrBL5HPfiKOHiPEd+Q=;
        b=cuZ4DnE+G+LDwmhbsYwGF/Pw3mw59kt+VYAjddgxelkzUUV7snGRqVaPXjI/yscrpb
         vCiaFtgJN13mChHwnxlJDI9UEkZX/ZLjg7kbS+cNeLCRHO+Q+hHEloPm8bXudM7tgbJ+
         qoigoOIJFqGolNng3SjZ7P7II9GO07rTvyv0QcD78PZiE67ti/FVu3hp8ETtre4bFWRR
         VPk1535juSb46T1rx1en68hSDkCjzRr8QpE7VyelAtORBRFEZ6XPK08dt0eITi6iVTbz
         4bjBlN4yrfaJTgnKWgoBwaYzDpoEacrHz0a6ZSJSC/WYmgJ11dGL4GA6vVYQRlRYbfBc
         enzQ==
X-Gm-Message-State: APjAAAUk5MLHM4hD3sitJf1FgaNAcepCXGfiArAE2dSMnksDn1IzHCoN
        xpIR6QOgMGjGwmWgo5fEWnQ=
X-Google-Smtp-Source: APXvYqzFzWntvUwa+A8P/XLBxNEA6gs2CvtTGf9vkOmTbbiqnl1BvbkUuEpkbUt2yQIUlkfCUmR2Yw==
X-Received: by 2002:a6b:6409:: with SMTP id t9mr14858793iog.270.1560983613186;
        Wed, 19 Jun 2019 15:33:33 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id v25sm15370617ioh.25.2019.06.19.15.33.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:33:32 -0700 (PDT)
Subject: [PATCH v1 5/6] mm: Add logic for separating "aerated" pages from
 "raw" pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 19 Jun 2019 15:33:31 -0700
Message-ID: <20190619223331.1231.39271.stgit@localhost.localdomain>
In-Reply-To: <20190619222922.1231.27432.stgit@localhost.localdomain>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add a set of pointers we shall call "boundary" which represents the upper
boundary between the "raw" and "aerated" pages. The general idea is that in
order for a page to cross from one side of the boundary to the other it
will need to go through the aeration treatment.

By doing this we should be able to make certain that we keep the aerated
pages as one contiguous block on the end of each free list. This will allow
us to efficiently walk the free lists whenever we need to go in and start
processing hints to the hypervisor that the pages are no longer in use.

And added advantage to this approach is that we should be reducing the
overall memory footprint of the guest as it will be more likely to recycle
warm pages versus the aerated pages that are likely to be cache cold.

Since we will only be aerating one zone at a time we keep the boundary
limited to being defined for just the zone we are currently placing aerated
pages into. Doing this we can keep the number of additional poitners needed
quite small.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/memory_aeration.h |   57 ++++++++
 include/linux/mmzone.h          |    8 +
 include/linux/page-flags.h      |    8 +
 mm/Makefile                     |    1 
 mm/aeration.c                   |  270 +++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c                 |    4 -
 6 files changed, 347 insertions(+), 1 deletion(-)
 create mode 100644 mm/aeration.c

diff --git a/include/linux/memory_aeration.h b/include/linux/memory_aeration.h
index 44cfbc259778..2f45196218b1 100644
--- a/include/linux/memory_aeration.h
+++ b/include/linux/memory_aeration.h
@@ -3,19 +3,50 @@
 #define _LINUX_MEMORY_AERATION_H
 
 #include <linux/mmzone.h>
+#include <linux/jump_label.h>
 #include <linux/pageblock-flags.h>
+#include <asm/pgtable_types.h>
 
+#define AERATOR_MIN_ORDER	pageblock_order
+#define AERATOR_HWM		32
+
+struct aerator_dev_info {
+	void (*react)(struct aerator_dev_info *a_dev_info);
+	struct list_head batch;
+	unsigned long capacity;
+	atomic_t refcnt;
+};
+
+extern struct static_key aerator_notify_enabled;
+
+void __aerator_notify(struct zone *zone);
 struct page *get_aeration_page(struct zone *zone, unsigned int order,
 			       int migratetype);
 void put_aeration_page(struct zone *zone, struct page *page);
 
+void __aerator_del_from_boundary(struct page *page, struct zone *zone);
+void aerator_add_to_boundary(struct page *page, struct zone *zone);
+
+struct list_head *__aerator_get_tail(unsigned int order, int migratetype);
 static inline struct list_head *aerator_get_tail(struct zone *zone,
 						 unsigned int order,
 						 int migratetype)
 {
+#ifdef CONFIG_AERATION
+	if (order >= AERATOR_MIN_ORDER &&
+	    test_bit(ZONE_AERATION_ACTIVE, &zone->flags))
+		return __aerator_get_tail(order, migratetype);
+#endif
 	return &zone->free_area[order].free_list[migratetype];
 }
 
+static inline void aerator_del_from_boundary(struct page *page,
+					     struct zone *zone)
+{
+	if (PageAerated(page) && test_bit(ZONE_AERATION_ACTIVE, &zone->flags))
+		__aerator_del_from_boundary(page, zone);
+}
+
 static inline void set_page_aerated(struct page *page,
 				    struct zone *zone,
 				    unsigned int order,
@@ -28,6 +59,9 @@ static inline void set_page_aerated(struct page *page,
 	/* record migratetype and flag page as aerated */
 	set_pcppage_migratetype(page, migratetype);
 	__SetPageAerated(page);
+
+	/* update boundary of new migratetype and record it */
+	aerator_add_to_boundary(page, zone);
 #endif
 }
 
@@ -39,11 +73,19 @@ static inline void clear_page_aerated(struct page *page,
 	if (likely(!PageAerated(page)))
 		return;
 
+	/* push boundary back if we removed the upper boundary */
+	aerator_del_from_boundary(page, zone);
+
 	__ClearPageAerated(page);
 	area->nr_free_aerated--;
 #endif
 }
 
+static inline unsigned long aerator_raw_pages(struct free_area *area)
+{
+	return area->nr_free - area->nr_free_aerated;
+}
+
 /**
  * aerator_notify_free - Free page notification that will start page processing
  * @zone: Pointer to current zone of last page processed
@@ -57,5 +99,20 @@ static inline void clear_page_aerated(struct page *page,
  */
 static inline void aerator_notify_free(struct zone *zone, int order)
 {
+#ifdef CONFIG_AERATION
+	if (!static_key_false(&aerator_notify_enabled))
+		return;
+	if (order < AERATOR_MIN_ORDER)
+		return;
+	if (test_bit(ZONE_AERATION_REQUESTED, &zone->flags))
+		return;
+	if (aerator_raw_pages(&zone->free_area[order]) < AERATOR_HWM)
+		return;
+
+	__aerator_notify(zone);
+#endif
 }
+
+void aerator_shutdown(void);
+int aerator_startup(struct aerator_dev_info *sdev);
 #endif /*_LINUX_MEMORY_AERATION_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7d89722ae9eb..52190a791e63 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -554,6 +554,14 @@ enum zone_flags {
 	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
 					 * Cleared when kswapd is woken.
 					 */
+	ZONE_AERATION_REQUESTED,	/* zone enabled aeration and is
+					 * requesting scrubbing the data out of
+					 * higher order pages.
+					 */
+	ZONE_AERATION_ACTIVE,		/* zone enabled aeration and is
+					 * activly cleaning the data out of
+					 * higher order pages.
+					 */
 };
 
 static inline unsigned long zone_managed_pages(struct zone *zone)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b848517da64c..f16e73318d49 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -745,6 +745,14 @@ static inline int page_has_type(struct page *page)
 PAGE_TYPE_OPS(Offline, offline)
 
 /*
+ * PageAerated() is an alias for Offline, however it is not meant to be an
+ * exclusive value. It should be combined with PageBuddy() when seen as it
+ * is meant to indicate that the page has been scrubbed while waiting in
+ * the buddy system.
+ */
+PAGE_TYPE_OPS(Aerated, offline)
+
+/*
  * If kmemcg is enabled, the buddy allocator will set PageKmemcg() on
  * pages allocated with __GFP_ACCOUNT. It gets cleared on page free.
  */
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
index 000000000000..720dc51cb215
--- /dev/null
+++ b/mm/aeration.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/page-isolation.h>
+#include <linux/gfp.h>
+#include <linux/export.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+static struct aerator_dev_info *a_dev_info;
+struct static_key aerator_notify_enabled;
+
+struct list_head *boundary[MAX_ORDER - AERATOR_MIN_ORDER][MIGRATE_TYPES];
+
+static void aerator_reset_boundary(struct zone *zone, unsigned int order,
+				   unsigned int migratetype)
+{
+	boundary[order - AERATOR_MIN_ORDER][migratetype] =
+			&zone->free_area[order].free_list[migratetype];
+}
+
+#define for_each_aerate_migratetype_order(_order, _type) \
+	for (_order = MAX_ORDER; _order-- != AERATOR_MIN_ORDER;) \
+		for (_type = MIGRATE_TYPES; _type--;)
+
+static void aerator_populate_boundaries(struct zone *zone)
+{
+	unsigned int order, mt;
+
+	if (test_bit(ZONE_AERATION_ACTIVE, &zone->flags))
+		return;
+
+	for_each_aerate_migratetype_order(order, mt)
+		aerator_reset_boundary(zone, order, mt);
+
+	set_bit(ZONE_AERATION_ACTIVE, &zone->flags);
+}
+
+struct list_head *__aerator_get_tail(unsigned int order, int migratetype)
+{
+	return boundary[order - AERATOR_MIN_ORDER][migratetype];
+}
+
+void __aerator_del_from_boundary(struct page *page, struct zone *zone)
+{
+	unsigned int order = page_private(page) - AERATOR_MIN_ORDER;
+	int mt = get_pcppage_migratetype(page);
+	struct list_head **tail = &boundary[order][mt];
+
+	if (*tail == &page->lru)
+		*tail = page->lru.next;
+}
+
+void aerator_add_to_boundary(struct page *page, struct zone *zone)
+{
+	unsigned int order = page_private(page) - AERATOR_MIN_ORDER;
+	int mt = get_pcppage_migratetype(page);
+	struct list_head **tail = &boundary[order][mt];
+
+	*tail = &page->lru;
+}
+
+void aerator_shutdown(void)
+{
+	static_key_slow_dec(&aerator_notify_enabled);
+
+	while (atomic_read(&a_dev_info->refcnt))
+		msleep(20);
+
+	WARN_ON(!list_empty(&a_dev_info->batch));
+
+	a_dev_info = NULL;
+}
+EXPORT_SYMBOL_GPL(aerator_shutdown);
+
+static void aerator_schedule_initial_aeration(void)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		spin_lock(&zone->lock);
+		__aerator_notify(zone);
+		spin_unlock(&zone->lock);
+	}
+}
+
+int aerator_startup(struct aerator_dev_info *sdev)
+{
+	if (a_dev_info)
+		return -EBUSY;
+
+	INIT_LIST_HEAD(&sdev->batch);
+	atomic_set(&sdev->refcnt, 0);
+
+	a_dev_info = sdev;
+	aerator_schedule_initial_aeration();
+
+	static_key_slow_inc(&aerator_notify_enabled);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aerator_startup);
+
+static void aerator_fill(struct zone *zone)
+{
+	struct list_head *batch = &a_dev_info->batch;
+	int budget = a_dev_info->capacity;
+	unsigned int order, mt;
+
+	for_each_aerate_migratetype_order(order, mt) {
+		struct page *page;
+
+		/*
+		 * Pull pages from free list until we have drained
+		 * it or we have filled the batch reactor.
+		 */
+		while ((page = get_aeration_page(zone, order, mt))) {
+			list_add_tail(&page->lru, batch);
+
+			if (!--budget)
+				return;
+		}
+	}
+
+	/*
+	 * If there are no longer enough free pages to fully populate
+	 * the aerator, then we can just shut it down for this zone.
+	 */
+	clear_bit(ZONE_AERATION_REQUESTED, &zone->flags);
+	atomic_dec(&a_dev_info->refcnt);
+}
+
+static void aerator_drain(struct zone *zone)
+{
+	struct list_head *list = &a_dev_info->batch;
+	struct page *page;
+
+	/*
+	 * Drain the now aerated pages back into their respective
+	 * free lists/areas.
+	 */
+	while ((page = list_first_entry_or_null(list, struct page, lru))) {
+		list_del(&page->lru);
+		put_aeration_page(zone, page);
+	}
+}
+
+static void aerator_scrub_zone(struct zone *zone)
+{
+	/* See if there are any pages to pull */
+	if (!test_bit(ZONE_AERATION_REQUESTED, &zone->flags))
+		return;
+
+	spin_lock(&zone->lock);
+
+	do {
+		aerator_fill(zone);
+
+		if (list_empty(&a_dev_info->batch))
+			break;
+
+		spin_unlock(&zone->lock);
+
+		/*
+		 * Start aerating the pages in the batch, and then
+		 * once that is completed we can drain the reactor
+		 * and refill the reactor, restarting the cycle.
+		 */
+		a_dev_info->react(a_dev_info);
+
+		spin_lock(&zone->lock);
+
+		/*
+		 * Guarantee boundaries are populated before we
+		 * start placing aerated pages in the zone.
+		 */
+		aerator_populate_boundaries(zone);
+
+		/*
+		 * We should have a list of pages that have been
+		 * processed. Return them to their original free lists.
+		 */
+		aerator_drain(zone);
+
+		/* keep pulling pages till there are none to pull */
+	} while (test_bit(ZONE_AERATION_REQUESTED, &zone->flags));
+
+	clear_bit(ZONE_AERATION_ACTIVE, &zone->flags);
+
+	spin_unlock(&zone->lock);
+}
+
+/**
+ * aerator_cycle - start aerating a batch of pages, drain, and refill
+ *
+ * The aerator cycle consists of 4 stages, fill, react, drain, and idle.
+ * We will cycle through the first 3 stages until we fail to obtain any
+ * pages, in that case we will switch to idle and the thread will go back
+ * to sleep awaiting the next request for aeration.
+ */
+static void aerator_cycle(struct work_struct *work)
+{
+	struct zone *zone = first_online_pgdat()->node_zones;
+	int refcnt;
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
+	for (;;) {
+		aerator_scrub_zone(zone);
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
+		 * If we never generated any pages and we are
+		 * holding the only remaining reference to active
+		 * hints then we can just let this go for now and
+		 * go idle.
+		 */
+		refcnt = atomic_read(&a_dev_info->refcnt);
+		if (refcnt != 1)
+			continue;
+		if (atomic_try_cmpxchg(&a_dev_info->refcnt, &refcnt, 0))
+			break;
+	}
+}
+
+static DECLARE_DELAYED_WORK(aerator_work, &aerator_cycle);
+
+void __aerator_notify(struct zone *zone)
+{
+	/*
+	 * We can use separate test and set operations here as there
+	 * is nothing else that can set or clear this bit while we are
+	 * holding the zone lock. The advantage to doing it this way is
+	 * that we don't have to dirty the cacheline unless we are
+	 * changing the value.
+	 */
+	set_bit(ZONE_AERATION_REQUESTED, &zone->flags);
+
+	if (atomic_fetch_inc(&a_dev_info->refcnt))
+		return;
+
+	/*
+	 * We should never be calling this function while there are already
+	 * pages in the list being aerated. If we are called under such a
+	 * circumstance report an error.
+	 */
+	WARN_ON(!list_empty(&a_dev_info->batch));
+
+	/*
+	 * Delay the start of work to allow a sizable queue to build. For
+	 * now we are limiting this to running no more than 10 times per
+	 * second.
+	 */
+	schedule_delayed_work(&aerator_work, HZ / 10);
+}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index eb7ba8385374..45269c46c662 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2168,8 +2168,10 @@ struct page *get_aeration_page(struct zone *zone, unsigned int order,
 	list_for_each_entry_from_reverse(page, list, lru) {
 		if (PageAerated(page)) {
 			page = list_first_entry(list, struct page, lru);
-			if (PageAerated(page))
+			if (PageAerated(page)) {
+				aerator_add_to_boundary(page, zone);
 				break;
+			}
 		}
 
 		del_page_from_free_area(page, zone, order);

