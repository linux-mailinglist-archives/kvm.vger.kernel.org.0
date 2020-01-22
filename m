Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC6145B05
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 18:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAVRnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 12:43:24 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37988 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgAVRnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 12:43:24 -0500
Received: by mail-pl1-f196.google.com with SMTP id t6so66898plj.5;
        Wed, 22 Jan 2020 09:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=bkzEcNe3DoBO/lqmPbLjP/akHdI7ACM8vJ/gGyJAkpo=;
        b=mY/sHxwy8IIbtE2Lr43QN6/W+6WzBus0JjUCGu5gxiKp+U283L1BRIIJsN2r6KrjPy
         y//gmS6GP6oCuo9AvQ0SuM9ErdjIw6TwZCyM40sAdUNRTl/VnHLuU8ztNIK0j/2fqZf8
         mv6XtbQOc5e3vgaqwlp20aTSjFbQFzY98T0qY2aX8A58eRwjc93HfCaOLVaarLSr4FPE
         moF37/18BZZg5JMPpZp8iNbMF3yrGD+RwLQCupiUXcD1IP5Id/QURdgdLRg7MgdG0znN
         IPoYN+NE7WkB1R+l7UMDaTG7Gaj/uGAfuzEjiw25hah1LFEyDWV12k1NuwA68kukMs+D
         CA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=bkzEcNe3DoBO/lqmPbLjP/akHdI7ACM8vJ/gGyJAkpo=;
        b=pyCdu77r412qQTU4S1lCaY51x8L7kerjI3FNfpcYZBltrcb+KYzvULq2CCP+QYkVhl
         fjwbnSRXwxS+pNcGBiaprJ1P/iIDr1JYIB/O38yHa4x4R/hwg7x6KcLad0PyqguOIgHm
         5dTa8BJPKpxpOrgI7RXafvc5JJMTq6zMkJL4s0GqpOJp9lXGga95V+80uESlIhM+czoF
         qee/FAhAC+2Vb8dVyi9nXvt0xX4aRlnpiSzrZNO3cKeS3Ve+QWP19j9RPLpgbpp9mvDb
         aId3REYPPYmB4Aw9kEpAEiCsWtjrNqaJmrGDDL/Uk5+aMpGCUQwgd84elzQ6LRMOO9H4
         KRIQ==
X-Gm-Message-State: APjAAAU6XDpi9SSW9uMdQ+wh2Y588l/qbFFywlDkoabTfSGvzpObne5j
        xfTvsBnOL3J3Ao7KqxsJq6w=
X-Google-Smtp-Source: APXvYqwuSJwgHnC+0wc8Lvk9cyJbVsMLDVlHfTjbMqzUbyxkrMrE5MoNYz/HUoF76AllZQ5HTlazMw==
X-Received: by 2002:a17:90b:11c4:: with SMTP id gv4mr4299129pjb.126.1579715003663;
        Wed, 22 Jan 2020 09:43:23 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id g19sm47786568pfh.134.2020.01.22.09.43.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:43:23 -0800 (PST)
Subject: [PATCH v16.1 2/9] mm: Use zone and order instead of free area in
 free_list manipulators
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
Date:   Wed, 22 Jan 2020 09:43:22 -0800
Message-ID: <20200122174322.6142.83329.stgit@localhost.localdomain>
In-Reply-To: <20200122173040.6142.39116.stgit@localhost.localdomain>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

In order to enable the use of the zone from the list manipulator functions
I will need access to the zone pointer. As it turns out most of the
accessors were always just being directly passed &zone->free_area[order]
anyway so it would make sense to just fold that into the function itself
and pass the zone and order as arguments instead of the free area.

In order to be able to reference the zone we need to move the declaration
of the functions down so that we have the zone defined before we define the
list manipulation functions. Since the functions are only used in the file
mm/page_alloc.c we can just move them there to reduce noise in the header.

Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   32 -----------------------
 mm/page_alloc.c        |   67 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bdcd071ab67f..a32bd503b9fc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -100,29 +100,6 @@ struct free_area {
 	unsigned long		nr_free;
 };
 
-/* Used for pages not on another list */
-static inline void add_to_free_area(struct page *page, struct free_area *area,
-			     int migratetype)
-{
-	list_add(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
-}
-
-/* Used for pages not on another list */
-static inline void add_to_free_area_tail(struct page *page, struct free_area *area,
-				  int migratetype)
-{
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
-}
-
-/* Used for pages which are on another list */
-static inline void move_to_free_area(struct page *page, struct free_area *area,
-			     int migratetype)
-{
-	list_move(&page->lru, &area->free_list[migratetype]);
-}
-
 static inline struct page *get_page_from_free_area(struct free_area *area,
 					    int migratetype)
 {
@@ -130,15 +107,6 @@ static inline struct page *get_page_from_free_area(struct free_area *area,
 					struct page, lru);
 }
 
-static inline void del_page_from_free_area(struct page *page,
-		struct free_area *area)
-{
-	list_del(&page->lru);
-	__ClearPageBuddy(page);
-	set_page_private(page, 0);
-	area->nr_free--;
-}
-
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
 	return list_empty(&area->free_list[migratetype]);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2a5949833069..b1cc0dab1c29 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -870,6 +870,44 @@ static inline struct capture_control *task_capc(struct zone *zone)
 }
 #endif /* CONFIG_COMPACTION */
 
+/* Used for pages not on another list */
+static inline void add_to_free_list(struct page *page, struct zone *zone,
+				    unsigned int order, int migratetype)
+{
+	struct free_area *area = &zone->free_area[order];
+
+	list_add(&page->lru, &area->free_list[migratetype]);
+	area->nr_free++;
+}
+
+/* Used for pages not on another list */
+static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
+					 unsigned int order, int migratetype)
+{
+	struct free_area *area = &zone->free_area[order];
+
+	list_add_tail(&page->lru, &area->free_list[migratetype]);
+	area->nr_free++;
+}
+
+/* Used for pages which are on another list */
+static inline void move_to_free_list(struct page *page, struct zone *zone,
+				     unsigned int order, int migratetype)
+{
+	struct free_area *area = &zone->free_area[order];
+
+	list_move(&page->lru, &area->free_list[migratetype]);
+}
+
+static inline void del_page_from_free_list(struct page *page, struct zone *zone,
+					   unsigned int order)
+{
+	list_del(&page->lru);
+	__ClearPageBuddy(page);
+	set_page_private(page, 0);
+	zone->free_area[order].nr_free--;
+}
+
 /*
  * If this is not the largest possible page, check if the buddy
  * of the next-highest order is free. If it is, it's possible
@@ -932,7 +970,6 @@ static inline void __free_one_page(struct page *page,
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
 	unsigned long combined_pfn;
-	struct free_area *area;
 	unsigned int max_order;
 	struct page *buddy;
 	bool to_tail;
@@ -970,7 +1007,7 @@ static inline void __free_one_page(struct page *page,
 		if (page_is_guard(buddy))
 			clear_page_guard(zone, buddy, order, migratetype);
 		else
-			del_page_from_free_area(buddy, &zone->free_area[order]);
+			del_page_from_free_list(buddy, zone, order);
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
@@ -1004,16 +1041,15 @@ static inline void __free_one_page(struct page *page,
 done_merging:
 	set_page_order(page, order);
 
-	area = &zone->free_area[order];
 	if (is_shuffle_order(order))
 		to_tail = shuffle_pick_tail();
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
 
 	if (to_tail)
-		add_to_free_area_tail(page, area, migratetype);
+		add_to_free_list_tail(page, zone, order, migratetype);
 	else
-		add_to_free_area(page, area, migratetype);
+		add_to_free_list(page, zone, order, migratetype);
 }
 
 /*
@@ -2027,13 +2063,11 @@ void __init init_cma_reserved_pageblock(struct page *page)
  * -- nyc
  */
 static inline void expand(struct zone *zone, struct page *page,
-	int low, int high, struct free_area *area,
-	int migratetype)
+	int low, int high, int migratetype)
 {
 	unsigned long size = 1 << high;
 
 	while (high > low) {
-		area--;
 		high--;
 		size >>= 1;
 		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
@@ -2047,7 +2081,7 @@ static inline void expand(struct zone *zone, struct page *page,
 		if (set_page_guard(zone, &page[size], high, migratetype))
 			continue;
 
-		add_to_free_area(&page[size], area, migratetype);
+		add_to_free_list(&page[size], zone, high, migratetype);
 		set_page_order(&page[size], high);
 	}
 }
@@ -2205,8 +2239,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		page = get_page_from_free_area(area, migratetype);
 		if (!page)
 			continue;
-		del_page_from_free_area(page, area);
-		expand(zone, page, order, current_order, area, migratetype);
+		del_page_from_free_list(page, zone, current_order);
+		expand(zone, page, order, current_order, migratetype);
 		set_pcppage_migratetype(page, migratetype);
 		return page;
 	}
@@ -2280,7 +2314,7 @@ static int move_freepages(struct zone *zone,
 		VM_BUG_ON_PAGE(page_zone(page) != zone, page);
 
 		order = page_order(page);
-		move_to_free_area(page, &zone->free_area[order], migratetype);
+		move_to_free_list(page, zone, order, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
@@ -2396,7 +2430,6 @@ static void steal_suitable_fallback(struct zone *zone, struct page *page,
 		unsigned int alloc_flags, int start_type, bool whole_block)
 {
 	unsigned int current_order = page_order(page);
-	struct free_area *area;
 	int free_pages, movable_pages, alike_pages;
 	int old_block_type;
 
@@ -2467,8 +2500,7 @@ static void steal_suitable_fallback(struct zone *zone, struct page *page,
 	return;
 
 single_page:
-	area = &zone->free_area[current_order];
-	move_to_free_area(page, area, start_type);
+	move_to_free_list(page, zone, current_order, start_type);
 }
 
 /*
@@ -3139,7 +3171,6 @@ void split_page(struct page *page, unsigned int order)
 
 int __isolate_free_page(struct page *page, unsigned int order)
 {
-	struct free_area *area = &page_zone(page)->free_area[order];
 	unsigned long watermark;
 	struct zone *zone;
 	int mt;
@@ -3165,7 +3196,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 
 	/* Remove page from free list */
 
-	del_page_from_free_area(page, area);
+	del_page_from_free_list(page, zone, order);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -8725,7 +8756,7 @@ void zone_pcp_reset(struct zone *zone)
 		BUG_ON(!PageBuddy(page));
 		order = page_order(page);
 		offlined_pages += 1 << order;
-		del_page_from_free_area(page, &zone->free_area[order]);
+		del_page_from_free_list(page, zone, order);
 		pfn += (1 << order);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);

