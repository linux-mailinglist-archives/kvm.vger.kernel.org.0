Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8822D3043B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfE3VyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:23 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35748 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfE3VyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:54:22 -0400
Received: by mail-oi1-f196.google.com with SMTP id y6so2567146oix.2;
        Thu, 30 May 2019 14:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=s26j7V3iEZr//55S8rYqaobNc+2iO706C6wxuCttLf0=;
        b=aSb1R8bqa6Rr+SLly5lIAn6ed5UqisHx2cm6+o2zE7jy8I/m6Ufv6nvAAvA+75/NEu
         m/lrayI+hShBHlah07B/ZkL3lqq696x2NUjibkLhfJPBsBJBESEtYFuDzDrckyYAlDvg
         XXaTAzOzEL2wAXcPUQn0S6hyluZbeHnPjkSRnnT1eJeZEbbFA3q5XaMAAPOKmsUfnE+1
         7UeR4D2WS4GiveHpkiF9qIUMj9VMCxpY6cjNmQwdap0RJYIve+PbJK2N2DZsXq9TKApw
         jm/vr+vrW24xGM/DJ8+ArlgCGwtunsLl3XaJ3Agwt/xQPku1APV5CR+J397GTEJKbI+1
         6yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s26j7V3iEZr//55S8rYqaobNc+2iO706C6wxuCttLf0=;
        b=Nn8mZmuQjKMHAHQNfesD15S9awdvsVVzFNDdd8oy7uCXr2UydjBvtzSQOU5htdNexK
         s40aW8g8GZ9U5NqzdTBg8jJ0E2gHY66tQ95fCDITshMVogHhpSynP9NCjL8+0Bl8Z2tN
         DDw2eJjVY/txBJbEhRMphusjl4LopKC0Q7C+dgu5GXalx+fE9cUqMxJf6sYlg4R6Ux52
         rEkditFwPva1fioLCCuQ+6pUbusTYWnI/Fj1fozzL3jKD+O5ZC+fCwZxTlvmhQEnY9+9
         uioDfER3QVrO9qCxbeDV63CjqOwhukdhl25FBA35+cIvXZSodj/awc6hCZ5QZmE1/j++
         pRnA==
X-Gm-Message-State: APjAAAXA2d72cCPI1yUYikJXO+OeE0/1LXigHEuzd347QdDva8v/InL6
        MALqgnKup7zvkWykl8PXZc0=
X-Google-Smtp-Source: APXvYqy/FQ8bhtfq9GgSYKUcKlSG4/DGy0PBOtr85jmyWEPil3tQV1gAaVwyI4p86YxQAPDAp9Ru0A==
X-Received: by 2002:aca:5004:: with SMTP id e4mr3986999oib.179.1559253261053;
        Thu, 30 May 2019 14:54:21 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id v89sm1442292otb.14.2019.05.30.14.54.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:54:20 -0700 (PDT)
Subject: [RFC PATCH 06/11] mm: Add membrane to free area to use as divider
 between treated and raw pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:54:18 -0700
Message-ID: <20190530215418.13974.63493.stgit@localhost.localdomain>
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

Add a pointer we shall call "membrane" which represents the upper boundary
between the "raw" and "treated" pages. The general idea is that in order
for a page to cross from one side of the membrane to the other it will need
to go through the aeration treatment.

By doing this we should be able to make certain that we keep the treated
pages as one contiguous block within each free list. While treating the
pages there may be two, but the two should merge into one before we
complete the migratetype and allow it to fall back into the "settling"
state.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   38 ++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c        |   14 ++++++++++++--
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a55fe6d2f63c..be996e8ca6b5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -87,10 +87,28 @@ static inline bool is_migrate_movable(int mt)
 	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
 			PB_migrate_end, MIGRATETYPE_MASK)
 
+/*
+ * The treatment state indicates the current state of the region pointed to
+ * by the treatment_mt and the membrane pointer. The general idea is that
+ * when we are in the "SETTLING" state the treatment area is contiguous and
+ * it is safe to move on to treating another migratetype. If we are in the
+ * "AERATING" state then the region is being actively processed and we
+ * would cause issues such as potentially isolating a section of raw pages
+ * between two sections of treated pages if we were to move onto another
+ * migratetype.
+ */
+enum treatment_state {
+	TREATMENT_SETTLING,
+	TREATMENT_AERATING,
+};
+
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free_raw;
 	unsigned long		nr_free_treated;
+	struct list_head	*membrane;
+	u8			treatment_mt;
+	u8			treatment_state;
 };
 
 /* Used for pages not on another list */
@@ -113,6 +131,19 @@ static inline void add_to_free_area_tail(struct page *page, struct free_area *ar
 	list_add_tail(&page->lru, &area->free_list[migratetype]);
 }
 
+static inline void
+add_to_free_area_treated(struct page *page, struct free_area *area,
+			 int migratetype)
+{
+	area->nr_free_treated++;
+
+	BUG_ON(area->treatment_mt != migratetype);
+
+	/* Insert page above membrane, then move membrane to the page */
+	list_add_tail(&page->lru, area->membrane);
+	area->membrane = &page->lru;
+}
+
 /* Used for pages which are on another list */
 static inline void move_to_free_area(struct page *page, struct free_area *area,
 			     int migratetype)
@@ -135,6 +166,10 @@ static inline void move_to_free_area(struct page *page, struct free_area *area,
 		area->nr_free_raw++;
 	}
 
+	/* push membrane back if we removed the upper boundary */
+	if (area->membrane == &page->lru)
+		area->membrane = page->lru.next;
+
 	list_move(&page->lru, &area->free_list[migratetype]);
 }
 
@@ -153,6 +188,9 @@ static inline void del_page_from_free_area(struct page *page,
 	else
 		area->nr_free_raw--;
 
+	if (area->membrane == &page->lru)
+		area->membrane = page->lru.next;
+
 	list_del(&page->lru);
 	__ClearPageBuddy(page);
 	__ResetPageTreated(page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f6c067c6c784..f4a629b6af96 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -989,6 +989,11 @@ static inline void __free_one_page(struct page *page,
 	set_page_order(page, order);
 
 	area = &zone->free_area[order];
+	if (PageTreated(page)) {
+		add_to_free_area_treated(page, area, migratetype);
+		return;
+	}
+
 	if (buddy_merge_likely(pfn, buddy_pfn, page, order) ||
 	    is_shuffle_tail_page(order))
 		add_to_free_area_tail(page, area, migratetype);
@@ -5961,8 +5966,13 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 
 	for (order = MAX_ORDER; order--; ) {
-		zone->free_area[order].nr_free_raw = 0;
-		zone->free_area[order].nr_free_treated = 0;
+		struct free_area *area = &zone->free_area[order];
+
+		area->nr_free_raw = 0;
+		area->nr_free_treated = 0;
+		area->treatment_mt = 0;
+		area->treatment_state = TREATMENT_SETTLING;
+		area->membrane = &area->free_list[0];
 	}
 }
 

