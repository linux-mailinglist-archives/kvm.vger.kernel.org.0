Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A077F08E4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 23:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfKEWCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 17:02:10 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46690 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbfKEWCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 17:02:09 -0500
Received: by mail-pl1-f194.google.com with SMTP id l4so5081695plt.13;
        Tue, 05 Nov 2019 14:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=i4Pj4oR+V08pVNadxlEGqPfJoWSfrMh8VdQBKoieZtk=;
        b=bFXSnYX0KHMaqYAudxt/ZKAOjXg7f/AI3kpdfKGV3E4LutcsiZavdrL7VwF/UZpw+6
         0dK2FFZHJid5YtXeWDy0lXwQGG9q3YFlnXDoXO6YWvFCVMOflfaoLQ5GrJqcvC78k4U5
         IRPNbdabq4GFbKoqIx8jB7U5Ldn+mn2YgJuly2ja01tycsTQhqble86uQQUPp/YKH3CI
         1qTG2s4F5kM/z9dITv7g1cSWXY60l8T4M8jKi9CVPNzTNKkqjSBS/gzUHZ6DRTPihBln
         XzgFNer86hX4lzUApIj904pj6TTz5TDWT6MEGFVqWAuBb/ItXw7HjWfgwjS1tYSChvWL
         ztEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=i4Pj4oR+V08pVNadxlEGqPfJoWSfrMh8VdQBKoieZtk=;
        b=aveS1OzuBArrvho5KcFI9YlhTPcr2S1wNTEyrvzIZDPAvABzKGRVAGYCSUIhCvAcJJ
         HRSWJLhUtnamnKXbOoYjhRV2195tYDS5ZKWlSe/0WAi3mawvQZYhFRs8Nq9zzEO0U7ob
         6Vm2Ve65Yxr2/7cC4DTAVBgTlF/uRuAwQuzJZ3vmoRdCbx8QIiVNAunO2W+xSvVwdK1Q
         VET88x4PFRb8qwKCsG0ktsEgkjpsh1CNe9/BfDXQS0kiULf5QRTZX2uzftGmEzZAswuu
         N38zUmZa3jnSqrHQWGCkNyyI7QBGpZZ8JwzBeqEQQuxVELg8P5PM3BH3+ueMq2Xq2Wbd
         KA5Q==
X-Gm-Message-State: APjAAAXP272+Z+z422wOFWXDChnZn0Gsz0eydukZ9LbLT+CjAQ1Ws62+
        wkmoM0fB7cEmroE6c7h/VFg=
X-Google-Smtp-Source: APXvYqzKjudW8fUnUrJWRHusKNShU6INWXSkltd7Te9vyU9aGAqlLdgBCwH1s68upZJCTyo9wR5Bgg==
X-Received: by 2002:a17:902:848e:: with SMTP id c14mr4241977plo.62.1572991328117;
        Tue, 05 Nov 2019 14:02:08 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id a16sm1749665pfc.56.2019.11.05.14.02.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 14:02:07 -0800 (PST)
Subject: [PATCH v13 1/6] mm: Adjust shuffle code to allow for future
 coalescing
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
Date:   Tue, 05 Nov 2019 14:02:07 -0800
Message-ID: <20191105220207.15144.8826.stgit@localhost.localdomain>
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

Move the head/tail adding logic out of the shuffle code and into the
__free_one_page function since ultimately that is where it is really
needed anyway. By doing this we should be able to reduce the overhead
and can consolidate all of the list addition bits in one spot.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   12 --------
 mm/page_alloc.c        |   71 ++++++++++++++++++++++++++++--------------------
 mm/shuffle.c           |   12 ++++----
 mm/shuffle.h           |    6 ++++
 4 files changed, 54 insertions(+), 47 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d4ca03b93373..f1361dd79757 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -116,18 +116,6 @@ static inline void add_to_free_area_tail(struct page *page, struct free_area *ar
 	area->nr_free++;
 }
 
-#ifdef CONFIG_SHUFFLE_PAGE_ALLOCATOR
-/* Used to preserve page allocation order entropy */
-void add_to_free_area_random(struct page *page, struct free_area *area,
-		int migratetype);
-#else
-static inline void add_to_free_area_random(struct page *page,
-		struct free_area *area, int migratetype)
-{
-	add_to_free_area(page, area, migratetype);
-}
-#endif
-
 /* Used for pages which are on another list */
 static inline void move_to_free_area(struct page *page, struct free_area *area,
 			     int migratetype)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12f3ce09d33d..fdf2d4eccc22 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -878,6 +878,36 @@ static inline struct capture_control *task_capc(struct zone *zone)
 #endif /* CONFIG_COMPACTION */
 
 /*
+ * If this is not the largest possible page, check if the buddy
+ * of the next-highest order is free. If it is, it's possible
+ * that pages are being freed that will coalesce soon. In case,
+ * that is happening, add the free page to the tail of the list
+ * so it's less likely to be used soon and more likely to be merged
+ * as a higher order page
+ */
+static inline bool
+buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
+		   struct page *page, unsigned int order)
+{
+	struct page *higher_page, *higher_buddy;
+	unsigned long combined_pfn;
+
+	if (order >= MAX_ORDER - 2)
+		return false;
+
+	if (!pfn_valid_within(buddy_pfn))
+		return false;
+
+	combined_pfn = buddy_pfn & pfn;
+	higher_page = page + (combined_pfn - pfn);
+	buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
+	higher_buddy = higher_page + (buddy_pfn - combined_pfn);
+
+	return pfn_valid_within(buddy_pfn) &&
+	       page_is_buddy(higher_page, higher_buddy, order + 1);
+}
+
+/*
  * Freeing function for a buddy system allocator.
  *
  * The concept of a buddy system is to maintain direct-mapped table
@@ -906,11 +936,13 @@ static inline void __free_one_page(struct page *page,
 		struct zone *zone, unsigned int order,
 		int migratetype)
 {
-	unsigned long combined_pfn;
+	struct capture_control *capc = task_capc(zone);
 	unsigned long uninitialized_var(buddy_pfn);
-	struct page *buddy;
+	unsigned long combined_pfn;
+	struct free_area *area;
 	unsigned int max_order;
-	struct capture_control *capc = task_capc(zone);
+	struct page *buddy;
+	bool to_tail;
 
 	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
 
@@ -979,35 +1011,16 @@ static inline void __free_one_page(struct page *page,
 done_merging:
 	set_page_order(page, order);
 
-	/*
-	 * If this is not the largest possible page, check if the buddy
-	 * of the next-highest order is free. If it is, it's possible
-	 * that pages are being freed that will coalesce soon. In case,
-	 * that is happening, add the free page to the tail of the list
-	 * so it's less likely to be used soon and more likely to be merged
-	 * as a higher order page
-	 */
-	if ((order < MAX_ORDER-2) && pfn_valid_within(buddy_pfn)
-			&& !is_shuffle_order(order)) {
-		struct page *higher_page, *higher_buddy;
-		combined_pfn = buddy_pfn & pfn;
-		higher_page = page + (combined_pfn - pfn);
-		buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
-		higher_buddy = higher_page + (buddy_pfn - combined_pfn);
-		if (pfn_valid_within(buddy_pfn) &&
-		    page_is_buddy(higher_page, higher_buddy, order + 1)) {
-			add_to_free_area_tail(page, &zone->free_area[order],
-					      migratetype);
-			return;
-		}
-	}
-
+	area = &zone->free_area[order];
 	if (is_shuffle_order(order))
-		add_to_free_area_random(page, &zone->free_area[order],
-				migratetype);
+		to_tail = shuffle_pick_tail();
 	else
-		add_to_free_area(page, &zone->free_area[order], migratetype);
+		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
 
+	if (to_tail)
+		add_to_free_area_tail(page, area, migratetype);
+	else
+		add_to_free_area(page, area, migratetype);
 }
 
 /*
diff --git a/mm/shuffle.c b/mm/shuffle.c
index b3fe97fd6654..e65d57f39486 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -183,11 +183,11 @@ void __meminit __shuffle_free_memory(pg_data_t *pgdat)
 		shuffle_zone(z);
 }
 
-void add_to_free_area_random(struct page *page, struct free_area *area,
-		int migratetype)
+bool shuffle_pick_tail(void)
 {
 	static u64 rand;
 	static u8 rand_bits;
+	bool ret;
 
 	/*
 	 * The lack of locking is deliberate. If 2 threads race to
@@ -198,10 +198,10 @@ void add_to_free_area_random(struct page *page, struct free_area *area,
 		rand = get_random_u64();
 	}
 
-	if (rand & 1)
-		add_to_free_area(page, area, migratetype);
-	else
-		add_to_free_area_tail(page, area, migratetype);
+	ret = rand & 1;
+
 	rand_bits--;
 	rand >>= 1;
+
+	return ret;
 }
diff --git a/mm/shuffle.h b/mm/shuffle.h
index 777a257a0d2f..4d79f03b6658 100644
--- a/mm/shuffle.h
+++ b/mm/shuffle.h
@@ -22,6 +22,7 @@ enum mm_shuffle_ctl {
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 extern void page_alloc_shuffle(enum mm_shuffle_ctl ctl);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
+extern bool shuffle_pick_tail(void);
 static inline void shuffle_free_memory(pg_data_t *pgdat)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
@@ -44,6 +45,11 @@ static inline bool is_shuffle_order(int order)
 	return order >= SHUFFLE_ORDER;
 }
 #else
+static inline bool shuffle_pick_tail(void)
+{
+	return false;
+}
+
 static inline void shuffle_free_memory(pg_data_t *pgdat)
 {
 }

