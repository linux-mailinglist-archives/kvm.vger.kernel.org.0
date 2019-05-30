Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC333043C
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfE3Vya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:30 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40191 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfE3Vy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:54:29 -0400
Received: by mail-ot1-f66.google.com with SMTP id u11so7165090otq.7;
        Thu, 30 May 2019 14:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ySRpFG6dIOHZ+M23tjria9Tf+GQw7/jvywjmJkXyRMo=;
        b=rcau95AXvxEykUxo3o4rkucpfbR1LX1x5X5CXkMhzd1fqmFgZZwKoTCbMpKKbYqFfC
         UbdBILZlqxd2RuRIYCEGRxN9ep9jYLYhRreEWra8LWhyYsMzByoobPErsAneYypuf6Gu
         PE0cjm4SCxwhQ+NB4y+KyiiEoBG9ckxFVgWYm/GtS2/Qw+K5GSC6c6a8Nvh8Z/zxoIGG
         Y4buUb8l/83NXSsb2o15MmHUsRTwTI8cOyyoiVqfkSpG+HVP3nQTtHm+7oCsJFRGsagc
         ei5rEo+G+E2/wyIldOG821aJC1RHYMP9oREGt0ATmV6jeHMyQNAdMUGC3sbUmsIg0r9/
         beYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ySRpFG6dIOHZ+M23tjria9Tf+GQw7/jvywjmJkXyRMo=;
        b=du0jgzjCn9doEVuFouLyTc/5woAFpe42QEUAtfxSKhmGztya2LG3K7PLiDJPCKR3FK
         FdSLpxlqh9oGNigyv02JAxVv/jCpcyz1e93ACfPYexQHBr/L55d4JlSCsvmWUG4B8APc
         P8z1sgD/liUl4QkRM7/QrxZI8UEXXEpa92mxjrOJDOu+xskYWCTUZd9pqdddLCxTxAeh
         6qJyqCdKrVj8ycJjVVjoCTKZkXdb4aQt5WIb5SUmfk5JrTnXAHGsvPfrcWGQHipxPNq9
         z2iC5iKFqj0F2AViywn34loUzUa6k7vrh0YFxTeOOYhGAz3fbpQctCImkBt2ZjHJL+Dl
         QjOQ==
X-Gm-Message-State: APjAAAVio4yX4QPgAVwXlk5pJItgZRG9J5uPYxEFZNEGU8CKfOsTf7lL
        rMr+n7yTnQRMI6VuRxJetfM=
X-Google-Smtp-Source: APXvYqxrTapW1llgCNvcp1SuLkSKr6HRUWIeylHL8O4HoCla8qYP0tDZcevscz28QJb95+UxLu1Szg==
X-Received: by 2002:a9d:3285:: with SMTP id u5mr4625825otb.266.1559253268401;
        Thu, 30 May 2019 14:54:28 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id p63sm866455oih.1.2019.05.30.14.54.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:54:27 -0700 (PDT)
Subject: [RFC PATCH 07/11] mm: Add support for acquiring first free "raw" or
 "untreated" page in zone
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:54:26 -0700
Message-ID: <20190530215426.13974.82813.stgit@localhost.localdomain>
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

In order to be able to "treat" memory in an asynchonous fashion we need a
way to acquire a block of memory that isn't already treated, and then flush
that back in a way that we will not pick it back up again.

To achieve that this patch adds a pair of functions. One to fill a list
with pages to be treated, and another that will flush out the list back to
the buddy allocator.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/gfp.h |    6 +++
 mm/page_alloc.c     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index fb07b503dc45..407a089d861f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -559,6 +559,12 @@ extern void *page_frag_alloc(struct page_frag_cache *nc,
 void drain_all_pages(struct zone *zone);
 void drain_local_pages(struct zone *zone);
 
+#ifdef CONFIG_AERATION
+struct page *get_raw_pages(struct zone *zone, unsigned int order,
+			   int migratetype);
+void free_treated_page(struct page *page);
+#endif
+
 void page_alloc_init_late(void);
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f4a629b6af96..e79c65413dc9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2155,6 +2155,113 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	return NULL;
 }
 
+#ifdef CONFIG_AERATION
+static struct page *get_raw_page_from_free_area(struct free_area *area,
+						int migratetype)
+{
+	struct list_head *head = &area->free_list[migratetype];
+	struct page *page;
+
+	/* If we have not worked in this free_list before reset membrane */
+	if (area->treatment_mt != migratetype) {
+		area->treatment_mt = migratetype;
+		area->membrane = head;
+	}
+
+	/* Try to pulling in any untreated pages above the the membrane */
+	page = list_last_entry(area->membrane, struct page, lru);
+	list_for_each_entry_from_reverse(page, head, lru) {
+		/*
+		 * If the page in front of the membrane is treated then try
+		 * skimming the top to see if we have any untreated pages
+		 * up there.
+		 */
+		if (PageTreated(page)) {
+			page = list_first_entry(head, struct page, lru);
+			if (PageTreated(page))
+				break;
+		}
+
+		/* update state of treatment */
+		area->treatment_state = TREATMENT_AERATING;
+
+		return page;
+	}
+
+	/*
+	 * At this point there are no longer any untreated pages between
+	 * the membrane and the first entry of the list. So we can safely
+	 * set the membrane to the top of the treated region and will mark
+	 * the current migratetype as complete for now.
+	 */
+	area->membrane = &page->lru;
+	area->treatment_state = TREATMENT_SETTLING;
+
+	return NULL;
+}
+
+/**
+ * get_raw_pages - Provide a "raw" page for treatment by the aerator
+ * @zone: Zone to draw pages from
+ * @order: Order to draw pages from
+ * @migratetype: Migratetype to draw pages from
+ *
+ * This function will obtain a page that does not have the Treated value
+ * set in the page type field. It will attempt to fetch a "raw" page from
+ * just above the "membrane" and if that is not available it will attempt
+ * to pull a "raw" page from the head of the free list.
+ *
+ * The page will have the migrate type and order stored in the page
+ * metadata.
+ *
+ * Return: page pointer if raw page found, otherwise NULL
+ */
+struct page *get_raw_pages(struct zone *zone, unsigned int order,
+			   int migratetype)
+{
+	struct free_area *area = &(zone->free_area[order]);
+	struct page *page;
+
+	/* Find a page of the appropriate size in the preferred list */
+	page = get_raw_page_from_free_area(area, migratetype);
+	if (page) {
+		del_page_from_free_area(page, area);
+
+		/* record migratetype and order within page */
+		set_pcppage_migratetype(page, migratetype);
+		set_page_private(page, order);
+		__mod_zone_freepage_state(zone, -(1 << order), migratetype);
+	}
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(get_raw_pages);
+
+/**
+ * free_treated_page - Return a now-treated "raw" page back where we got it
+ * @page: Previously "raw" page that can now be returned after treatment
+ *
+ * This function will pull the zone, migratetype, and order information out
+ * of the page and attempt to return it where it found it. We default to
+ * using free_one_page to return the page as it is possible that the
+ * pageblock might have been switched to an isolate migratetype during
+ * treatment.
+ */
+void free_treated_page(struct page *page)
+{
+	unsigned int order, mt;
+	struct zone *zone;
+
+	zone = page_zone(page);
+	mt = get_pcppage_migratetype(page);
+	order = page_private(page);
+
+	set_page_private(page, 0);
+
+	free_one_page(zone, page, page_to_pfn(page), order, mt);
+}
+EXPORT_SYMBOL_GPL(free_treated_page);
+#endif /* CONFIG_AERATION */
 
 /*
  * This array describes the order lists are fallen back to when

