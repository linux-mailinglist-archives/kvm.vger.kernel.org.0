Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60B830434
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfE3VyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:10 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37080 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfE3VyH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:54:07 -0400
Received: by mail-oi1-f193.google.com with SMTP id i4so5797780oih.4;
        Thu, 30 May 2019 14:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=7u7wbcMP7bQHGisrQkMqGe4jN5gZ6kjRirjphuZkn6o=;
        b=jP6bqG9uQs1ohqmq0Ump0fIbO7IxQeGQBZTVwUv4QXZmN55C38S5+LgtxXDZ7b+N9P
         cAwMGK4qHImZyjEj6sRWXhaAwVLfCApEINYmjP5KrfZYd2t8BOrBaNoyoLIrUM0k3LFI
         DQ+B9FgHQwHwhiVlXjLQKZ2+0wYMokLivRn6KCHbG3dcN1u+X+QQrGmEiVKQ8pJR9fZM
         py3W9rnBsAIVOfzb51cz2748m+NAsXx4DoiT2Y3cLP8Uh60CNpq1ptq6vOPbzxCdvbtX
         4aMHOysaC09KZyvYkaubbr2BsO34Q31M2S7Md+9+pSC+JqL+j+2deEuSc7oAcy2mTuRT
         2hZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7u7wbcMP7bQHGisrQkMqGe4jN5gZ6kjRirjphuZkn6o=;
        b=jaUdBOCJv31zPXFMZ8FzkEAXe3H440V9mRd9WrzRvuh2POHGD9UJ7a1GStkjD5avSC
         z6TWNpvXFhPTl0qMPrH2VsHwhISM7Wojp1XWytWhiBKUq2tRcXg0OB7+r46yv3UvIsF1
         5hIk4XO5zHv8ciT0hrFbGYkZ7+EBdLQXVsTE8yMSP/JCuK4E9spYEGpHDuJjkJwUtJ1G
         yE4hMDcFQcFnh47LbpkERudqPzFmp/hVV9T20xvLL6amcfFaUmr2UVWX5PIgbQPVPVL3
         +GNP3WodbH7qcBzgPtakhiouYTc9i3YOHt/k6E1pdhAOdLoqtieV9FvjLu3TEZUFUszl
         ez2Q==
X-Gm-Message-State: APjAAAWnkp3QIKvt3daHtjBzH82dPZIEVfy85tPQaP8EHq1Uynpq3vFb
        0kIjUyitv96/A0XAqvTG7FjLUgkYBFo=
X-Google-Smtp-Source: APXvYqxs6hYRpQ0oJ3XzfwlTWjcwNAqk0y0aofeteBpXV1+xcjtP7sCaSxRds4CMWdwRHoJjAzHDUg==
X-Received: by 2002:aca:c450:: with SMTP id u77mr2702554oif.119.1559253246531;
        Thu, 30 May 2019 14:54:06 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id t198sm1526478oih.41.2019.05.30.14.54.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:54:05 -0700 (PDT)
Subject: [RFC PATCH 04/11] mm: Split nr_free into nr_free_raw and
 nr_free_treated
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:54:04 -0700
Message-ID: <20190530215404.13974.27449.stgit@localhost.localdomain>
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

Split the nr_free value into two values that track where the pages were
inserted into the list. The idea is that we can use this later to track
which pages were treated and added to the free list versus the raw pages
which were just added to the head of the list.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   36 ++++++++++++++++++++++++++++++++----
 mm/compaction.c        |    4 ++--
 mm/page_alloc.c        |   14 +++++++++-----
 mm/vmstat.c            |    5 +++--
 4 files changed, 46 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0263d5bf0b84..988c3094b686 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -89,7 +89,8 @@ static inline bool is_migrate_movable(int mt)
 
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
-	unsigned long		nr_free;
+	unsigned long		nr_free_raw;
+	unsigned long		nr_free_treated;
 };
 
 /* Used for pages not on another list */
@@ -97,7 +98,7 @@ static inline void add_to_free_area(struct page *page, struct free_area *area,
 			     int migratetype)
 {
 	list_add(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	area->nr_free_raw++;
 }
 
 /* Used for pages not on another list */
@@ -105,13 +106,31 @@ static inline void add_to_free_area_tail(struct page *page, struct free_area *ar
 				  int migratetype)
 {
 	list_add_tail(&page->lru, &area->free_list[migratetype]);
-	area->nr_free++;
+	area->nr_free_raw++;
 }
 
 /* Used for pages which are on another list */
 static inline void move_to_free_area(struct page *page, struct free_area *area,
 			     int migratetype)
 {
+	/*
+	 * Since we are moving the page out of one migrate type and into
+	 * another the page will be added to the head of the new list.
+	 *
+	 * To avoid creating an island of raw pages floating between two
+	 * sections of treated pages we should reset the page type and
+	 * just re-treat the page when we process the destination.
+	 *
+	 * No need to trigger a notification for this since the page itself
+	 * is actually treated and we are just doing this for logistical
+	 * reasons.
+	 */
+	if (PageTreated(page)) {
+		__ResetPageTreated(page);
+		area->nr_free_treated--;
+		area->nr_free_raw++;
+	}
+
 	list_move(&page->lru, &area->free_list[migratetype]);
 }
 
@@ -125,11 +144,15 @@ static inline struct page *get_page_from_free_area(struct free_area *area,
 static inline void del_page_from_free_area(struct page *page,
 		struct free_area *area)
 {
+	if (PageTreated(page))
+		area->nr_free_treated--;
+	else
+		area->nr_free_raw--;
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	__ResetPageTreated(page);
 	set_page_private(page, 0);
-	area->nr_free--;
 }
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
@@ -137,6 +160,11 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
 	return list_empty(&area->free_list[migratetype]);
 }
 
+static inline unsigned long nr_pages_in_free_area(struct free_area *area)
+{
+	return area->nr_free_raw + area->nr_free_treated;
+}
+
 struct pglist_data;
 
 /*
diff --git a/mm/compaction.c b/mm/compaction.c
index 9febc8cc84e7..f5a27d5dccdf 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1318,7 +1318,7 @@ static int next_search_order(struct compact_control *cc, int order)
 		unsigned long flags;
 		unsigned int order_scanned = 0;
 
-		if (!area->nr_free)
+		if (!nr_pages_in_free_area(area))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
@@ -1674,7 +1674,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		unsigned long flags;
 		struct page *freepage;
 
-		if (!area->nr_free)
+		if (!nr_pages_in_free_area(area))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2894990862bd..10eaea762627 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2418,7 +2418,7 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
 	int i;
 	int fallback_mt;
 
-	if (area->nr_free == 0)
+	if (!nr_pages_in_free_area(area))
 		return -1;
 
 	*can_steal = false;
@@ -3393,7 +3393,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 		struct free_area *area = &z->free_area[o];
 		int mt;
 
-		if (!area->nr_free)
+		if (!nr_pages_in_free_area(area))
 			continue;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
@@ -5325,7 +5325,7 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			struct free_area *area = &zone->free_area[order];
 			int type;
 
-			nr[order] = area->nr_free;
+			nr[order] = nr_pages_in_free_area(area);
 			total += nr[order] << order;
 
 			types[order] = 0;
@@ -5944,9 +5944,13 @@ void __ref memmap_init_zone_device(struct zone *zone,
 static void __meminit zone_init_free_lists(struct zone *zone)
 {
 	unsigned int order, t;
-	for_each_migratetype_order(order, t) {
+
+	for_each_migratetype_order(order, t)
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
-		zone->free_area[order].nr_free = 0;
+
+	for (order = MAX_ORDER; order--; ) {
+		zone->free_area[order].nr_free_raw = 0;
+		zone->free_area[order].nr_free_treated = 0;
 	}
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index fd7e16ca6996..aa822fda4250 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1031,7 +1031,7 @@ static void fill_contig_page_info(struct zone *zone,
 		unsigned long blocks;
 
 		/* Count number of free blocks */
-		blocks = zone->free_area[order].nr_free;
+		blocks = nr_pages_in_free_area(&zone->free_area[order]);
 		info->free_blocks_total += blocks;
 
 		/* Count free base pages */
@@ -1353,7 +1353,8 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 
 	seq_printf(m, "Node %d, zone %8s ", pgdat->node_id, zone->name);
 	for (order = 0; order < MAX_ORDER; ++order)
-		seq_printf(m, "%6lu ", zone->free_area[order].nr_free);
+		seq_printf(m, "%6lu ",
+			   nr_pages_in_free_area(&zone->free_area[order]));
 	seq_putc(m, '\n');
 }
 

