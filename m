Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6433630431
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfE3VyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:00 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42671 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfE3Vxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:53:52 -0400
Received: by mail-oi1-f196.google.com with SMTP id v25so5617905oic.9;
        Thu, 30 May 2019 14:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=7/ShmDor402LGxJdUnB6r3jYiu3C2H9J7GnwmwTdNWw=;
        b=jad/iZgDNFkLMXFeonjDMysadIOYcRNWeBjMK29xpgVosay9LzT2MFQMnv8Astm+6I
         pgM0i8wpDmzoi9qt7K91vUNWAGuh+XGZ2oJLqx8pewNeoPkJHZ5l/7H/8Ysxd6AtsFFl
         aCj2g9XNTxsTLctkn9rrNH39jDVy6ARaVZzwtxvqbbMedEezNh4AZEXOWhWMzzldDSdV
         apibBvcrrTo43whDeU+YJ3/f0h4B9swIqxrcA+2OL8YXB2+ysoauJw7hhuxHQ0jgxIeu
         X2GG8rL6oO7EhHvgrSOsaIBDg+IvsM2JE3gktx0c3oymPA5CCfmTN5G5oMzc74r4ZgSx
         RU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7/ShmDor402LGxJdUnB6r3jYiu3C2H9J7GnwmwTdNWw=;
        b=bvhvkXgj1/VPABMx5dynRKruWsfDxJGFOP/dify+8e3myNDIjSS/fcAqhVIZZeRnzx
         TNNlQFTwnUQ+AdSdZXswZ5/csf2TqKnOfTQ2y6yWcnJDUMZ6a5Df1MF909c6Z5H4SyXc
         aTpSpHph6/tXOiU1qsQVjWhN+FkXmcyOP2Rqd6G5cGvjRluCsQIFZ17TX4YHKK87UsCE
         k35ioMz2OBDwPKoG96lYaGJjmZ76Z7JSbjw7U6QmdvfQ7FWpxDb710oRTBjW26ioC1Rw
         Al/gKIzrKOSYQS+z3yJiOTQQFGirWqS9+twdfgpuGP39LGFw4yem+/z+nfyx5twdbBwg
         OUmw==
X-Gm-Message-State: APjAAAWnI9rLVYbceVIndcTHK/VNb8IYYDs2nMRJMJvPaLvTE/uaAqFq
        iCK1ANQfeK+zX7T/KO+FGqU=
X-Google-Smtp-Source: APXvYqxpsklzRzklzaaWunr5R2owZZS1CzYFOUcljqCLnm6wJpxHd7Xotg82bP7Wx08VkZW6UTLEHw==
X-Received: by 2002:aca:3242:: with SMTP id y63mr3882561oiy.148.1559253231505;
        Thu, 30 May 2019 14:53:51 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id t21sm1459319otj.46.2019.05.30.14.53.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:53:50 -0700 (PDT)
Subject: [RFC PATCH 02/11] mm: Adjust shuffle code to allow for future
 coalescing
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:53:49 -0700
Message-ID: <20190530215349.13974.25544.stgit@localhost.localdomain>
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

This patch is meant to move the head/tail adding logic out of the shuffle
code and into the __free_one_page function since ultimately that is where
it is really needed anyway. By doing this we should be able to reduce the
overhead and can consolidate all of the list addition bits in one spot.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   12 --------
 mm/page_alloc.c        |   70 +++++++++++++++++++++++++++---------------------
 mm/shuffle.c           |   24 ----------------
 mm/shuffle.h           |   35 ++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 67 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a6bdff538437..297edb45071a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -108,18 +108,6 @@ static inline void add_to_free_area_tail(struct page *page, struct free_area *ar
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
index c061f66c2d0c..2fa5bbb372bb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -851,6 +851,36 @@ static inline struct capture_control *task_capc(struct zone *zone)
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
+	if (is_shuffle_order(order) || order >= (MAX_ORDER - 2))
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
@@ -879,11 +909,12 @@ static inline void __free_one_page(struct page *page,
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
 
@@ -952,35 +983,12 @@ static inline void __free_one_page(struct page *page,
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
+	if (buddy_merge_likely(pfn, buddy_pfn, page, order) ||
+	    is_shuffle_tail_page(order))
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
index 777a257a0d2f..3f4edb60a453 100644
--- a/mm/shuffle.h
+++ b/mm/shuffle.h
@@ -3,6 +3,7 @@
 #ifndef _MM_SHUFFLE_H
 #define _MM_SHUFFLE_H
 #include <linux/jump_label.h>
+#include <linux/random.h>
 
 /*
  * SHUFFLE_ENABLE is called from the command line enabling path, or by
@@ -43,6 +44,35 @@ static inline bool is_shuffle_order(int order)
 		return false;
 	return order >= SHUFFLE_ORDER;
 }
+
+static inline bool is_shuffle_tail_page(int order)
+{
+	static u64 rand;
+	static u8 rand_bits;
+	u64 rand_old;
+
+	if (!is_shuffle_order(order))
+		return false;
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
@@ -60,5 +90,10 @@ static inline bool is_shuffle_order(int order)
 {
 	return false;
 }
+
+static inline bool is_shuffle_tail_page(int order)
+{
+	return false;
+}
 #endif
 #endif /* _MM_SHUFFLE_H */

