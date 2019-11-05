Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772BBF08E6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfKEWCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:02:16 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46631 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbfKEWCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:02:16 -0500
Received: by mail-pg1-f195.google.com with SMTP id f19so15485416pgn.13;
        Tue, 05 Nov 2019 14:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=FmMtVxUb8jWo9yu0U7lNzowFgflNr/I9cspZkonwfrQ=;
        b=jMrSaoB5t5tvGYRURg+hmL0vqMy+N3TemAgLkhZJhc10D5vtHRaccGJ/KswvrKFPfM
         CxqHhq9CZixIF7589dxnRr366734Vhgk6+sBA+xx8HwaT+LMV1Zg109Tfl1TYjM6NNXG
         BrVSyZW03+X4jPpwp6NJLfhHX/4Q7o70DaUjne9Ougc2PDUGV7WJlWiuk0whVQoKivzx
         8SM5GzChNcigoL2wkiY3E5i4TqvgILTNVrCfO+BqF03dv0uRS3j7i/3LMHBxBdNahEE2
         BG2Zr1jIK6WCMHsjO9pG+156x7wLsBC8XG47MLZdF/U4mEIAJrXt/Ov7/+yi8QBA5QBC
         XhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FmMtVxUb8jWo9yu0U7lNzowFgflNr/I9cspZkonwfrQ=;
        b=GrY4ujq98tMDBz1iFG7e92KPZK3ZYMyCFJ03ZuXU0rNVQX6O8rotUTXzdpmJ4u5WAG
         T7m9dwxBKZOo9C/21FcfJXOj7ueHSzrHhFRQBnkZzAn2YrS5NlRVOYpjfz2DTI8ckNwV
         i1RZM04k2FNvhb5ekTEXc9ooV5b16+7F8ZYkABYdXE2d386rktw1b6XPxCkY8C1RFtMe
         9QbK1nyed/PlyMiZdMINEp54DjnAramZv7GoIZKpcYnUduZ0c/0kjc3XaB0SjTd/YJv6
         fSwfXdRNsthjDBe1Hpp7e9D2DKA3o2RqdSa5Al4AcXcrGQOY2CBH9RE4JBVrgpyaXbpe
         Rx9g==
X-Gm-Message-State: APjAAAUnJE8SoHQ1/wLKoSl29fTTcQU3FPpgNedNbwbhCA54x+aTRbFs
        OZMtLDz9HJpl//cd61j7Ssc=
X-Google-Smtp-Source: APXvYqxwheyHcriB5wvmCqOFA9BogZEIvc6eI672y4oaU90eSTWpQ+SiX9onWa2v79ENNTu5UROW8g==
X-Received: by 2002:a62:1605:: with SMTP id 5mr24082312pfw.206.1572991334263;
        Tue, 05 Nov 2019 14:02:14 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id s18sm25006745pfc.120.2019.11.05.14.02.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:02:13 -0800 (PST)
Subject: [PATCH v13 2/6] mm: Use zone and order instead of free area in
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
Date:   Tue, 05 Nov 2019 14:02:13 -0800
Message-ID: <20191105220213.15144.93299.stgit@localhost.localdomain>
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

In order to enable the use of the zone from the list manipulator functions
I will need access to the zone pointer. As it turns out most of the
accessors were always just being directly passed &zone->free_area[order]
anyway so it would make sense to just fold that into the function itself
and pass the zone and order as arguments instead of the free area.

In order to be able to reference the zone we need to move the declaration
of the functions down so that we have the zone defined before we define the
list manipulation functions. Since the functions are only used in the file
mm/page_alloc.c we can just move them there to reduce noise in the header.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   32 -----------------------
 mm/page_alloc.c        |   67 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 49 insertions(+), 50 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f1361dd79757..da289a3f8c5e 100644
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
index fdf2d4eccc22..55061675b5e2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -877,6 +877,44 @@ static inline struct capture_control *task_capc(struct zone *zone)
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
@@ -939,7 +977,6 @@ static inline void __free_one_page(struct page *page,
 	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
 	unsigned long combined_pfn;
-	struct free_area *area;
 	unsigned int max_order;
 	struct page *buddy;
 	bool to_tail;
@@ -977,7 +1014,7 @@ static inline void __free_one_page(struct page *page,
 		if (page_is_guard(buddy))
 			clear_page_guard(zone, buddy, order, migratetype);
 		else
-			del_page_from_free_area(buddy, &zone->free_area[order]);
+			del_page_from_free_list(buddy, zone, order);
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
@@ -1011,16 +1048,15 @@ static inline void __free_one_page(struct page *page,
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
@@ -2038,13 +2074,11 @@ void __init init_cma_reserved_pageblock(struct page *page)
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
@@ -2058,7 +2092,7 @@ static inline void expand(struct zone *zone, struct page *page,
 		if (set_page_guard(zone, &page[size], high, migratetype))
 			continue;
 
-		add_to_free_area(&page[size], area, migratetype);
+		add_to_free_list(&page[size], zone, high, migratetype);
 		set_page_order(&page[size], high);
 	}
 }
@@ -2216,8 +2250,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
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
@@ -2291,7 +2325,7 @@ static int move_freepages(struct zone *zone,
 		VM_BUG_ON_PAGE(page_zone(page) != zone, page);
 
 		order = page_order(page);
-		move_to_free_area(page, &zone->free_area[order], migratetype);
+		move_to_free_list(page, zone, order, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
 	}
@@ -2407,7 +2441,6 @@ static void steal_suitable_fallback(struct zone *zone, struct page *page,
 		unsigned int alloc_flags, int start_type, bool whole_block)
 {
 	unsigned int current_order = page_order(page);
-	struct free_area *area;
 	int free_pages, movable_pages, alike_pages;
 	int old_block_type;
 
@@ -2478,8 +2511,7 @@ static void steal_suitable_fallback(struct zone *zone, struct page *page,
 	return;
 
 single_page:
-	area = &zone->free_area[current_order];
-	move_to_free_area(page, area, start_type);
+	move_to_free_list(page, zone, current_order, start_type);
 }
 
 /*
@@ -3150,7 +3182,6 @@ void split_page(struct page *page, unsigned int order)
 
 int __isolate_free_page(struct page *page, unsigned int order)
 {
-	struct free_area *area = &page_zone(page)->free_area[order];
 	unsigned long watermark;
 	struct zone *zone;
 	int mt;
@@ -3176,7 +3207,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 
 	/* Remove page from free list */
 
-	del_page_from_free_area(page, area);
+	del_page_from_free_list(page, zone, order);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -8720,7 +8751,7 @@ void zone_pcp_reset(struct zone *zone)
 		pr_info("remove from free list %lx %d %lx\n",
 			pfn, 1 << order, end_pfn);
 #endif
-		del_page_from_free_area(page, &zone->free_area[order]);
+		del_page_from_free_list(page, zone, order);
 		pfn += (1 << order);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);

