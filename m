Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C805DC3904
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 17:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389604AbfJAP3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 11:29:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39530 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389599AbfJAP3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 11:29:24 -0400
Received: by mail-pg1-f193.google.com with SMTP id e1so4373550pgj.6;
        Tue, 01 Oct 2019 08:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Tg18ELn2yO5mcuA4hxXn6maR2nECizjJ7QIklFwPvZY=;
        b=lx1oVk9a+K28U2Q4cIxXEnv2szQ55+pVMEJbqitaU78Q9t6pOGpbqBFo9JgVDqkk7Y
         BAP8Gp/iLZZYowCaiahV22PwkOxuN2SrO/wFKvrzbgNB01XLsTdgW0AgCwXANCk5pd3U
         RnutPSXmj9y26VPc3eXfdJg0ScrTKXsFITcV6oJm3l4UNcRQz5iR+zi9LD+1JvG0uybr
         g/2qB0PbzVl9uRsJMGYbJL6E4PIC2Swqgeo8VuZkm9rTacz7n2xFI29IoyY01jbvRBBO
         ioQQmBVOopuw9V4ZUbAUBGKgUZCJDTUcZc+QOJUmZSRffxZTE2ys0U32nypNgZW/apUu
         dtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Tg18ELn2yO5mcuA4hxXn6maR2nECizjJ7QIklFwPvZY=;
        b=tanUmvmDMYCrPY+Q13b4xOBgVzPgqaEVeMxi3CKh/GJW5kCuaNOl17WU7d7dAvNqFU
         mOzaiLh++U7jF1VwqN+iPS5DaxBVAapYu2o5Yr9AO3hKl5kQ1aRZYkv8q+0OzO3tswrx
         DRukEZOJVpEXx3ddPD9IcRPbBR7DDbZp/VSXh6u3VMd3enOfL1S+T569L03siSZQcxPV
         xSkxOe2qkuJwUIibc+sDlpeauHeapDOLDHDTtD+Ut5aoi184sVmDwDoC5C2TXA9GOu/Z
         N7QW/JWK9LS3MAhob5/OMJDMGl5tzxxES/0YsFPqNRdxdunRuASLdJhz+crjWGDbKC9K
         XQKQ==
X-Gm-Message-State: APjAAAX8m9olonet/1h9WGucvpYE/lllSFj5gQtHsouh0ZEGKVWkE6hc
        BrfKKEeWwtlOsh8Rey6VDIY=
X-Google-Smtp-Source: APXvYqyHYHJwcWxzkd4NhdCH54CaB7vgm6krCM92IUZUhaDZPWi4HQ6ltB3UP1AlBMlsNjIktZRFTw==
X-Received: by 2002:a17:90a:850c:: with SMTP id l12mr6347604pjn.9.1569943763533;
        Tue, 01 Oct 2019 08:29:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id o64sm11445923pjb.24.2019.10.01.08.29.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:29:22 -0700 (PDT)
Subject: [PATCH v11 1/6] mm: Adjust shuffle code to allow for future
 coalescing
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Tue, 01 Oct 2019 08:29:21 -0700
Message-ID: <20191001152921.27008.56300.stgit@localhost.localdomain>
In-Reply-To: <20191001152441.27008.99285.stgit@localhost.localdomain>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
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
index bda20282746b..125f300981c6 100644
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
index 15c2050c629b..bc8de8d9416d 100644
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

