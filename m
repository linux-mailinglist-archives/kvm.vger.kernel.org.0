Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F29E4C3B0
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 00:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbfFSWd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 18:33:28 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38348 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730914AbfFSWd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 18:33:27 -0400
Received: by mail-io1-f67.google.com with SMTP id j6so436809ioa.5;
        Wed, 19 Jun 2019 15:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=uFIpek7shBaVr9DU13GRQZ4ibKs0x6v0iQmP4OpKI7k=;
        b=k/OoraMNYNLWswsjRZR3jEbeHgciCrA3Pvkj8V+NcMuwZd4nDStE1mCeb2clq7uoPE
         Bf0GYaBQ58HCl4cWZHr/PK4K4jEqlPVoK9CIq9gBKyQP+SAMwHApaOQ+/pM/boz+OI3N
         Ddc47rKbDu9wx2/eEEMCGKLqNnTrNgKTd6Eb2XLmtry661w/558JU3OoCoNGpsOBoRAn
         mhk+F4qr5+ZnCArtmzi2LJGPyjE7a2T+Bn/9P+Ib5zy4BsTFTShpemJziW9RGWAgDKkx
         0qaUB6uoFgFyhUPIj/dCvXQQW9NCpd74Z4QihncLfIL8C1BwyheFscAO19MnmxiE0jYW
         AH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uFIpek7shBaVr9DU13GRQZ4ibKs0x6v0iQmP4OpKI7k=;
        b=Alae/MRlkPe2T2dQ19GnGDhfV5rAVql1UkKno/m/uGlo02w8juQEk/mogfXYItpDmk
         lF9U1TxQJ/Ghysudw/+lP5THPaPJ/l4YIOpsKEJf00pChAFyGQ1ZW8OhAK+QTfVpgE89
         aBIr6tYqmTOnH7ILh9x/PdPVnmGakelmM9VVFXg9y9A80X9VUC2Bcf5pO6TmTsrF9nuO
         6si8KiZMWMxaaBgVhcA6LPaDPvHaVqraAC5kHSo+nacvupKZco2QxkZdDp4oz5yYsJCh
         reY+DayjxD/sQciYPRCcO0hDSCOMMNEQ0B9xrbDHzXM0FB+r+lijkmzsPoFaSQHLlNVg
         b90w==
X-Gm-Message-State: APjAAAUdnJKkEVnjkU0Qw2dcfZV3bIHszDmGWvHq23xLkV42D9CkrvYB
        leXkRFyYMzJ+DVOruKdOUiU=
X-Google-Smtp-Source: APXvYqyGIUEECip5yOIkf36i1rUmylXKTO5CxpW8E+NA2U4z3c9cYnuIYIokSVtGEOBlV0rtIuMF/Q==
X-Received: by 2002:a02:ccd2:: with SMTP id k18mr1709593jaq.3.1560983605934;
        Wed, 19 Jun 2019 15:33:25 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id a15sm13136500ioc.27.2019.06.19.15.33.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:33:25 -0700 (PDT)
Subject: [PATCH v1 4/6] mm: Introduce "aerated" pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 19 Jun 2019 15:33:23 -0700
Message-ID: <20190619223323.1231.86906.stgit@localhost.localdomain>
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

In order to pave the way for free page hinting in virtualized environments
we will need a way to get pages out of the free lists and identify those
pages after they have been returned. To accomplish this patch adds the
concept of an "aerated" flag, which is essentially meant to just be the
Offline page type used in conjustion with the Buddy page type bit.

For now we can just add the basic logic to set the flag and track the
number of aerated pages per free area.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/memory_aeration.h |   61 +++++++++++++++++++++++++
 include/linux/mmzone.h          |   13 ++++-
 mm/Kconfig                      |    5 ++
 mm/page_alloc.c                 |   97 +++++++++++++++++++++++++++++++++++++--
 4 files changed, 168 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/memory_aeration.h

diff --git a/include/linux/memory_aeration.h b/include/linux/memory_aeration.h
new file mode 100644
index 000000000000..44cfbc259778
--- /dev/null
+++ b/include/linux/memory_aeration.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEMORY_AERATION_H
+#define _LINUX_MEMORY_AERATION_H
+
+#include <linux/mmzone.h>
+#include <linux/pageblock-flags.h>
+
+struct page *get_aeration_page(struct zone *zone, unsigned int order,
+			       int migratetype);
+void put_aeration_page(struct zone *zone, struct page *page);
+
+static inline struct list_head *aerator_get_tail(struct zone *zone,
+						 unsigned int order,
+						 int migratetype)
+{
+	return &zone->free_area[order].free_list[migratetype];
+}
+
+static inline void set_page_aerated(struct page *page,
+				    struct zone *zone,
+				    unsigned int order,
+				    int migratetype)
+{
+#ifdef CONFIG_AERATION
+	/* update areated page accounting */
+	zone->free_area[order].nr_free_aerated++;
+
+	/* record migratetype and flag page as aerated */
+	set_pcppage_migratetype(page, migratetype);
+	__SetPageAerated(page);
+#endif
+}
+
+static inline void clear_page_aerated(struct page *page,
+				      struct zone *zone,
+				      struct free_area *area)
+{
+#ifdef CONFIG_AERATION
+	if (likely(!PageAerated(page)))
+		return;
+
+	__ClearPageAerated(page);
+	area->nr_free_aerated--;
+#endif
+}
+
+/**
+ * aerator_notify_free - Free page notification that will start page processing
+ * @zone: Pointer to current zone of last page processed
+ * @order: Order of last page added to zone
+ *
+ * This function is meant to act as a screener for __aerator_notify which
+ * will determine if a give zone has crossed over the high-water mark that
+ * will justify us beginning page treatment. If we have crossed that
+ * threshold then it will start the process of pulling some pages and
+ * placing them in the batch list for treatment.
+ */
+static inline void aerator_notify_free(struct zone *zone, int order)
+{
+}
+#endif /*_LINUX_MEMORY_AERATION_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c3597920a155..7d89722ae9eb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -116,6 +116,7 @@ static inline void set_pcppage_migratetype(struct page *page, int migratetype)
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
+	unsigned long		nr_free_aerated;
 };
 
 static inline struct page *get_page_from_free_area(struct free_area *area,
@@ -773,6 +774,8 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
 	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
 }
 
+#include <linux/memory_aeration.h>
+
 /* Used for pages not on another list */
 static inline void add_to_free_area(struct page *page, struct zone *zone,
 				    unsigned int order, int migratetype)
@@ -787,10 +790,10 @@ static inline void add_to_free_area(struct page *page, struct zone *zone,
 static inline void add_to_free_area_tail(struct page *page, struct zone *zone,
 					 unsigned int order, int migratetype)
 {
-	struct free_area *area = &zone->free_area[order];
+	struct list_head *tail = aerator_get_tail(zone, order, migratetype);
 
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	list_add_tail(&page->lru, tail);
+	zone->free_area[order].nr_free++;
 }
 
 /* Used for pages which are on another list */
@@ -799,6 +802,8 @@ static inline void move_to_free_area(struct page *page, struct zone *zone,
 {
 	struct free_area *area = &zone->free_area[order];
 
+	clear_page_aerated(page, zone, area);
+
 	list_move(&page->lru, &area->free_list[migratetype]);
 }
 
@@ -807,6 +812,8 @@ static inline void del_page_from_free_area(struct page *page, struct zone *zone,
 {
 	struct free_area *area = &zone->free_area[order];
 
+	clear_page_aerated(page, zone, area);
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
diff --git a/mm/Kconfig b/mm/Kconfig
index 7c41d2300e07..209dc4bea481 100644
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aad2b2529ab7..eb7ba8385374 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -68,6 +68,7 @@
 #include <linux/lockdep.h>
 #include <linux/nmi.h>
 #include <linux/psi.h>
+#include <linux/memory_aeration.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -868,10 +869,11 @@ static inline struct capture_control *task_capc(struct zone *zone)
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype)
+		int migratetype, bool aerated)
 {
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
+	bool fully_aerated = aerated;
 	unsigned long combined_pfn;
 	unsigned int max_order;
 	struct page *buddy;
@@ -902,6 +904,11 @@ static inline void __free_one_page(struct page *page,
 			goto done_merging;
 		if (!page_is_buddy(page, buddy, order))
 			goto done_merging;
+
+		/* assume buddy is not aerated */
+		if (aerated)
+			fully_aerated = false;
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -943,11 +950,17 @@ static inline void __free_one_page(struct page *page,
 done_merging:
 	set_page_order(page, order);
 
-	if (buddy_merge_likely(pfn, buddy_pfn, page, order) ||
+	if (aerated ||
+	    buddy_merge_likely(pfn, buddy_pfn, page, order) ||
 	    is_shuffle_tail_page(order))
 		add_to_free_area_tail(page, zone, order, migratetype);
 	else
 		add_to_free_area(page, zone, order, migratetype);
+
+	if (fully_aerated)
+		set_page_aerated(page, zone, order, migratetype);
+	else
+		aerator_notify_free(zone, order);
 }
 
 /*
@@ -1247,7 +1260,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, false);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1263,7 +1276,7 @@ static void free_one_page(struct zone *zone,
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype);
+	__free_one_page(page, pfn, zone, order, migratetype, false);
 	spin_unlock(&zone->lock);
 }
 
@@ -2127,6 +2140,77 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	return NULL;
 }
 
+#ifdef CONFIG_AERATION
+/**
+ * get_aeration_page - Provide a "raw" page for aeration by the aerator
+ * @zone: Zone to draw pages from
+ * @order: Order to draw pages from
+ * @migratetype: Migratetype to draw pages from
+ *
+ * This function will obtain a page from above the boundary. As a result
+ * we can guarantee the page has not been aerated.
+ *
+ * The page will have the migrate type and order stored in the page
+ * metadata.
+ *
+ * Return: page pointer if raw page found, otherwise NULL
+ */
+struct page *get_aeration_page(struct zone *zone, unsigned int order,
+			       int migratetype)
+{
+	struct free_area *area = &(zone->free_area[order]);
+	struct list_head *list = &area->free_list[migratetype];
+	struct page *page;
+
+	/* Find a page of the appropriate size in the preferred list */
+	page = list_last_entry(aerator_get_tail(zone, order, migratetype),
+			       struct page, lru);
+	list_for_each_entry_from_reverse(page, list, lru) {
+		if (PageAerated(page)) {
+			page = list_first_entry(list, struct page, lru);
+			if (PageAerated(page))
+				break;
+		}
+
+		del_page_from_free_area(page, zone, order);
+
+		/* record migratetype and order within page */
+		set_pcppage_migratetype(page, migratetype);
+		set_page_private(page, order);
+		__mod_zone_freepage_state(zone, -(1 << order), migratetype);
+
+		return page;
+	}
+
+	return NULL;
+}
+
+/**
+ * put_aeration_page - Return a now-aerated "raw" page back where we got it
+ * @zone: Zone to return pages to
+ * @page: Previously "raw" page that can now be returned after aeration
+ *
+ * This function will pull the migratetype and order information out
+ * of the page and attempt to return it where it found it.
+ */
+void put_aeration_page(struct zone *zone, struct page *page)
+{
+	unsigned int order, mt;
+	unsigned long pfn;
+
+	mt = get_pcppage_migratetype(page);
+	pfn = page_to_pfn(page);
+
+	if (unlikely(has_isolate_pageblock(zone) || is_migrate_isolate(mt)))
+		mt = get_pfnblock_migratetype(page, pfn);
+
+	order = page_private(page);
+	set_page_private(page, 0);
+
+	__free_one_page(page, pfn, zone, order, mt, true);
+}
+#endif /* CONFIG_AERATION */
+
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
@@ -5929,9 +6013,12 @@ void __ref memmap_init_zone_device(struct zone *zone,
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
 	unsigned int order, t;
-	for_each_migratetype_order(order, t) {
+	for_each_migratetype_order(order, t)
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
+
+	for (order = MAX_ORDER; order--; ) {
 		zone->free_area[order].nr_free = 0;
+		zone->free_area[order].nr_free_aerated = 0;
 	}
 }
 

