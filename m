Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0F8A963
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 23:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfHLVd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 17:33:27 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38546 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfHLVd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 17:33:27 -0400
Received: by mail-pg1-f195.google.com with SMTP id z14so12899499pga.5;
        Mon, 12 Aug 2019 14:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8Up9pojviE1H2/TRQbKOgpo0f8QQ8J9T+rPQMo69VKw=;
        b=PujC4KlblxkMZOOALiBIooNTvNVBEi9b/Dk/Zwsu7FRRMz9zdyXDTMWwwuAXZQQQi1
         bnY+6M/bAUXL/arFDRmKISapOpOMafRr3Jbw+lGp+yDWmQqpw5agqiULCVkq6lz8MCe2
         jR43mGWIOU3Z/582EyPTQEAqgmaaU7BcFsRHLi83zHMB9O8588C1BlALCKbXyNB9ulmA
         R3h44eh0mwkp3AWwApdeY6hZW9kbAsxDZlmmsHW2Yw7C5bhdFuvKtiMnk1HHeE3bysWo
         JS69ae6H3IV356vDhLvvs+zZ8VAR++vbj3mHLW7eNfgy+WZqImUUFmJZDNsV6qlWlf9L
         10yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8Up9pojviE1H2/TRQbKOgpo0f8QQ8J9T+rPQMo69VKw=;
        b=a5LmIgsfcWSiJ0rjN0gjhPpARFvVP6A/nww8RU+ZaO8OJqZHn7md7YZVCXaKciSzpG
         r8hpPYZVmt0omJEh0XWWqEgvE9xVwZOcK5AQpv+V+QXKVLsK7BSEpRUhmkAu76etyr7+
         4EcoR5hPJV3bna2mw1GSE4cqWfBqozbj0iTdJsj0rxFHOIg/c1e91bYIGdEnHz8s+wGD
         cd1kab1DQLpBtbUaxAhPTGDv2kRr7L1wN77TJcUsmS+yaJB4WgJXEeHIRPqXn6feKq9Q
         j7kyKBnGJ7R/k8JBzO7UKuYBE70W2tZOZo/nEzyGs/nNWCbsdQZ17E2AnlUx2BmHiy2j
         xRdg==
X-Gm-Message-State: APjAAAUa8Kf5FIielo6ztzCdClkslCSW/h/tXSuRM0hAlwnNY8zNFuqS
        POGXsLzS6XrIKQimZEnSBeY=
X-Google-Smtp-Source: APXvYqxuj6DbeWRtYunAyPnoI83yin+hNXz7bY+SObICug8ilfzdPwmiFKCWMkQxvW90XHOvDVRDXw==
X-Received: by 2002:a62:83c9:: with SMTP id h192mr11927113pfe.57.1565645606389;
        Mon, 12 Aug 2019 14:33:26 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id t9sm120209041pgj.89.2019.08.12.14.33.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:33:25 -0700 (PDT)
Subject: [PATCH v5 1/6] mm: Adjust shuffle code to allow for future
 coalescing
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Mon, 12 Aug 2019 14:33:25 -0700
Message-ID: <20190812213324.22097.30886.stgit@localhost.localdomain>
In-Reply-To: <20190812213158.22097.30576.stgit@localhost.localdomain>
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

This patch is meant to move the head/tail adding logic out of the shuffle
code and into the __free_one_page function since ultimately that is where
it is really needed anyway. By doing this we should be able to reduce the
overhead and can consolidate all of the list addition bits in one spot.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   12 --------
 mm/page_alloc.c        |   70 +++++++++++++++++++++++++++---------------------
 mm/shuffle.c           |   24 ----------------
 mm/shuffle.h           |   32 ++++++++++++++++++++++
 4 files changed, 71 insertions(+), 67 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index aa0dd8ca36c8..c6bd8e9bb476 100644
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
index af29c05e23aa..e3cb6e7aa296 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -877,6 +877,36 @@ static inline struct capture_control *task_capc(struct zone *zone)
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
@@ -905,11 +935,12 @@ static inline void __free_one_page(struct page *page,
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
 
 	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
 
@@ -978,35 +1009,12 @@ static inline void __free_one_page(struct page *page,
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
-	if (is_shuffle_order(order))
-		add_to_free_area_random(page, &zone->free_area[order],
-				migratetype);
+	area = &zone->free_area[order];
+	if (is_shuffle_order(order) ? shuffle_add_to_tail() :
+	    buddy_merge_likely(pfn, buddy_pfn, page, order))
+		add_to_free_area_tail(page, area, migratetype);
 	else
-		add_to_free_area(page, &zone->free_area[order], migratetype);
-
+		add_to_free_area(page, area, migratetype);
 }
 
 /*
diff --git a/mm/shuffle.c b/mm/shuffle.c
index 3ce12481b1dc..55d592e62526 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -4,7 +4,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/mmzone.h>
-#include <linux/random.h>
 #include <linux/moduleparam.h>
 #include "internal.h"
 #include "shuffle.h"
@@ -182,26 +181,3 @@ void __meminit __shuffle_free_memory(pg_data_t *pgdat)
 	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
 		shuffle_zone(z);
 }
-
-void add_to_free_area_random(struct page *page, struct free_area *area,
-		int migratetype)
-{
-	static u64 rand;
-	static u8 rand_bits;
-
-	/*
-	 * The lack of locking is deliberate. If 2 threads race to
-	 * update the rand state it just adds to the entropy.
-	 */
-	if (rand_bits == 0) {
-		rand_bits = 64;
-		rand = get_random_u64();
-	}
-
-	if (rand & 1)
-		add_to_free_area(page, area, migratetype);
-	else
-		add_to_free_area_tail(page, area, migratetype);
-	rand_bits--;
-	rand >>= 1;
-}
diff --git a/mm/shuffle.h b/mm/shuffle.h
index 777a257a0d2f..add763cc0995 100644
--- a/mm/shuffle.h
+++ b/mm/shuffle.h
@@ -3,6 +3,7 @@
 #ifndef _MM_SHUFFLE_H
 #define _MM_SHUFFLE_H
 #include <linux/jump_label.h>
+#include <linux/random.h>
 
 /*
  * SHUFFLE_ENABLE is called from the command line enabling path, or by
@@ -43,6 +44,32 @@ static inline bool is_shuffle_order(int order)
 		return false;
 	return order >= SHUFFLE_ORDER;
 }
+
+static inline bool shuffle_add_to_tail(void)
+{
+	static u64 rand;
+	static u8 rand_bits;
+	u64 rand_old;
+
+	/*
+	 * The lack of locking is deliberate. If 2 threads race to
+	 * update the rand state it just adds to the entropy.
+	 */
+	if (rand_bits-- == 0) {
+		rand_bits = 64;
+		rand = get_random_u64();
+	}
+
+	/*
+	 * Test highest order bit while shifting our random value. This
+	 * should result in us testing for the carry flag following the
+	 * shift.
+	 */
+	rand_old = rand;
+	rand <<= 1;
+
+	return rand < rand_old;
+}
 #else
 static inline void shuffle_free_memory(pg_data_t *pgdat)
 {
@@ -60,5 +87,10 @@ static inline bool is_shuffle_order(int order)
 {
 	return false;
 }
+
+static inline bool shuffle_add_to_tail(void)
+{
+	return false;
+}
 #endif
 #endif /* _MM_SHUFFLE_H */

