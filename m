Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9A8AC810
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 19:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395143AbfIGRZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 13:25:25 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38144 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395135AbfIGRZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 13:25:25 -0400
Received: by mail-oi1-f196.google.com with SMTP id 7so7576082oip.5;
        Sat, 07 Sep 2019 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=s8r1/ABgBnB3hWX83HxFW3/fYZsplR/u2NRf3An56fM=;
        b=gT66tcyAKseISqR8CsU5o/hOmDyEXwRA9o0gyQbtw8srIzHr0AfLB4moldpj0JLz0S
         y799HyAeTuTYL2/7sTq/prLwUi8icchbgSnDqXHnxduaXQLw0snPMj7cuxWX6U6uG1Ak
         VnJdJYuaMB17CNLzlxjSuqym49BphX3A0XdRLNvaCU8bfe9gPE3Swqo86AE1GOKMhG+0
         bnbDr+LbyVme13dQcwqNjLg5wTv8mF7mh70r8brQyWxEkw+75X5GTntXxbl5oW6eoWJB
         O/YtvplE81tf/IrAQmBk+fyfvki5MxKXcBkl1ck7+vxiMQ/0nTGRfL4Yo8WIywncnedM
         DOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s8r1/ABgBnB3hWX83HxFW3/fYZsplR/u2NRf3An56fM=;
        b=d5eEAQwiV0QRMP19JvZjkEWC5KLbH0sZZIyEohKTmXWxUM8//nHGKe9Kid/h2wcPsw
         4bDqVx/0HMrZTgKWmZAX+vZlTAj94b6gp2O+cj0+f7BbIs/6mVhVLRGoqszoschziTmM
         rAKXgNcQrmDFHNbbCAceb+rZW/Bmsamn5lhlcXGZH9psI3BvxpJp4yUYk9fg8of8InWC
         NVtiMlla5dk6hWDWwINsMXaosFnZsr02Z8xPJURokK0TKPYKuoSWi2T2ab6zz5q1vBhv
         Vhm6q8FSlUhsUL8h1C6NLmFlaA+UuiPuP0K12D0Aj6LRpcUuEmj1ODzh9kGXGj73qFZb
         dWCw==
X-Gm-Message-State: APjAAAVaeztU/faE7A+kzNgON0Xl/THlkOaleWwjemMwNJzgsxT6xjgM
        cBBgTQbFyHE3gmuMxo7QloE=
X-Google-Smtp-Source: APXvYqyQJw/FeEzWvcrIBCDrufxLmcN1ztlnfgjQ5bgohHrx6Qkjr2V52hoCPT8TPcay7z/VucYLmw==
X-Received: by 2002:aca:1206:: with SMTP id 6mr3663398ois.4.1567877123638;
        Sat, 07 Sep 2019 10:25:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id d24sm3522512otf.78.2019.09.07.10.25.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:25:23 -0700 (PDT)
Subject: [PATCH v9 2/8] mm: Adjust shuffle code to allow for future
 coalescing
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Date:   Sat, 07 Sep 2019 10:25:20 -0700
Message-ID: <20190907172520.10910.83100.stgit@localhost.localdomain>
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
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

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   12 --------
 mm/page_alloc.c        |   70 +++++++++++++++++++++++++++---------------------
 mm/shuffle.c           |    9 +-----
 mm/shuffle.h           |   12 ++++++++
 4 files changed, 53 insertions(+), 50 deletions(-)

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
index c5d62f1c2851..4e4356ba66c7 100644
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
@@ -906,11 +936,12 @@ static inline void __free_one_page(struct page *page,
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
 
@@ -979,35 +1010,12 @@ static inline void __free_one_page(struct page *page,
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
+	if (is_shuffle_order(order) ? shuffle_pick_tail() :
+	    buddy_merge_likely(pfn, buddy_pfn, page, order))
+		add_to_free_area_tail(page, area, migratetype);
 	else
-		add_to_free_area(page, &zone->free_area[order], migratetype);
-
+		add_to_free_area(page, area, migratetype);
 }
 
 /*
diff --git a/mm/shuffle.c b/mm/shuffle.c
index 9ba542ecf335..345cb4347455 100644
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
@@ -190,8 +189,7 @@ struct batched_bit_entropy {
 
 static DEFINE_PER_CPU(struct batched_bit_entropy, batched_entropy_bool);
 
-void add_to_free_area_random(struct page *page, struct free_area *area,
-		int migratetype)
+bool __shuffle_pick_tail(void)
 {
 	struct batched_bit_entropy *batch;
 	unsigned long entropy;
@@ -213,8 +211,5 @@ void add_to_free_area_random(struct page *page, struct free_area *area,
 	batch->position = position;
 	entropy = batch->entropy_bool;
 
-	if (1ul & (entropy >> position))
-		add_to_free_area(page, area, migratetype);
-	else
-		add_to_free_area_tail(page, area, migratetype);
+	return 1ul & (entropy >> position);
 }
diff --git a/mm/shuffle.h b/mm/shuffle.h
index 777a257a0d2f..0723eb97f22f 100644
--- a/mm/shuffle.h
+++ b/mm/shuffle.h
@@ -3,6 +3,7 @@
 #ifndef _MM_SHUFFLE_H
 #define _MM_SHUFFLE_H
 #include <linux/jump_label.h>
+#include <linux/random.h>
 
 /*
  * SHUFFLE_ENABLE is called from the command line enabling path, or by
@@ -22,6 +23,7 @@ enum mm_shuffle_ctl {
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 extern void page_alloc_shuffle(enum mm_shuffle_ctl ctl);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
+extern bool __shuffle_pick_tail(void);
 static inline void shuffle_free_memory(pg_data_t *pgdat)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
@@ -43,6 +45,11 @@ static inline bool is_shuffle_order(int order)
 		return false;
 	return order >= SHUFFLE_ORDER;
 }
+
+static inline bool shuffle_pick_tail(void)
+{
+	return __shuffle_pick_tail();
+}
 #else
 static inline void shuffle_free_memory(pg_data_t *pgdat)
 {
@@ -60,5 +67,10 @@ static inline bool is_shuffle_order(int order)
 {
 	return false;
 }
+
+static inline bool shuffle_pick_tail(void)
+{
+	return false;
+}
 #endif
 #endif /* _MM_SHUFFLE_H */

