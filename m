Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3F630437
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfE3VyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:54:16 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45790 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfE3VyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:54:14 -0400
Received: by mail-oi1-f194.google.com with SMTP id b20so2595183oie.12;
        Thu, 30 May 2019 14:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=B4jiG1jHnMkQIVQ7CnmS/QGR53dJGB1zbfKCiInlabY=;
        b=gFqv4vxWqkG3q53XLUYxfM48NGGzs7jrJLI7d0NMsnFs3NTQJkvh/fhH7mNOhxNcwm
         Sibve0l8XDYlIMV6OuYkQ6hf2niU43j1ZVnWuTaSLmSd0utr5H6sIS+JtZc+zOty4IZi
         jjpXbccBXneHJ+bauOZ5a1GEd+4AOlJzJF95ua0OmIFggONVmImQ37q6Gp7FU/ZiUdju
         aosW9LUpVAmmvtENAf6doZ+0L5J0NvgSXY9lSqm4aatO01j1LJRrnC/71+cwmr56xVyH
         oy5F4HCSkc722yy8f4DT7yX+LiTTfV7tGD7wAWHkP/5MMiq7ldDQ90Ta2pzoEocPFtCj
         4Ffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=B4jiG1jHnMkQIVQ7CnmS/QGR53dJGB1zbfKCiInlabY=;
        b=YtM4GElyrODjLtnvJ6wpddtBi0/GbVeCsiulrtD/Ug1nO8Mb1daKXaIw00tpL4yAYU
         HD+SmyfuQdDed4giMEHy9T08ETBFjqgkbzo3lKk70S3XdHyrNLKCd32IbM4/UtggGZ0H
         rO8FsvOCubRoguHEqnuKc3whckjLyUv0z9JiyVD63Z//bEOMJlT/dvZA0cwQIwNK3HZT
         Ldate5Q5IBksT2qar53m8xiSZAzDq51TA5bkb/9bFOdorQzbaJr8FYyc6vbirQVmZqGR
         0AA9EOlQbqUUhxYijDFYzhAiFBcWoDjPRpMyrYXKqMqSaDqjFnMxsqQV0wdm/cgjSHc4
         mSeg==
X-Gm-Message-State: APjAAAXCCnIq03xVhj9MiU1h50rioGrC9Z8U9ZnYSfK5Kea7ucUVcIb9
        WPD9vGkrEmpmaQ07Fy4jorE=
X-Google-Smtp-Source: APXvYqwuDRLHPeeQeLx6gytguQrqXX7UFDROgnc7qqhaG7g508ei93QI0YTUhPJGvN6SN4xgMuKEFA==
X-Received: by 2002:aca:ec0f:: with SMTP id k15mr3783572oih.43.1559253253781;
        Thu, 30 May 2019 14:54:13 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id w130sm1429402oib.44.2019.05.30.14.54.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:54:13 -0700 (PDT)
Subject: [RFC PATCH 05/11] mm: Propogate Treated bit when splitting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:54:11 -0700
Message-ID: <20190530215411.13974.73205.stgit@localhost.localdomain>
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

When we are going to call "expand" to split a page into subpages we should
mark those subpages as being "Treated" if the parent page was a "Treated"
page. By doing this we can avoid potentially providing hints on a page that
was already hinted at a larger page size as being unused.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |    8 ++++++--
 mm/page_alloc.c        |   18 +++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 988c3094b686..a55fe6d2f63c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -97,16 +97,20 @@ struct free_area {
 static inline void add_to_free_area(struct page *page, struct free_area *area,
 			     int migratetype)
 {
+	if (PageTreated(page))
+		area->nr_free_treated++;
+	else
+		area->nr_free_raw++;
+
 	list_add(&page->lru, &area->free_list[migratetype]);
-	area->nr_free_raw++;
 }
 
 /* Used for pages not on another list */
 static inline void add_to_free_area_tail(struct page *page, struct free_area *area,
 				  int migratetype)
 {
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
 	area->nr_free_raw++;
+	list_add_tail(&page->lru, &area->free_list[migratetype]);
 }
 
 /* Used for pages which are on another list */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 10eaea762627..f6c067c6c784 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1965,7 +1965,7 @@ void __init init_cma_reserved_pageblock(struct page *page)
  */
 static inline void expand(struct zone *zone, struct page *page,
 	int low, int high, struct free_area *area,
-	int migratetype)
+	int migratetype, bool treated)
 {
 	unsigned long size = 1 << high;
 
@@ -1984,8 +1984,17 @@ static inline void expand(struct zone *zone, struct page *page,
 		if (set_page_guard(zone, &page[size], high, migratetype))
 			continue;
 
-		add_to_free_area(&page[size], area, migratetype);
 		set_page_order(&page[size], high);
+		if (treated)
+			__SetPageTreated(&page[size]);
+
+		/*
+		 * The list we are placing this page in should be empty
+		 * so it should be safe to place it here without worrying
+		 * about creating a block of raw pages floating in between
+		 * two blocks of treated pages.
+		 */
+		add_to_free_area(&page[size], area, migratetype);
 	}
 }
 
@@ -2122,6 +2131,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 	unsigned int current_order;
 	struct free_area *area;
 	struct page *page;
+	bool treated;
 
 	/* Find a page of the appropriate size in the preferred list */
 	for (current_order = order; current_order < MAX_ORDER; ++current_order) {
@@ -2129,8 +2139,10 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		page = get_page_from_free_area(area, migratetype);
 		if (!page)
 			continue;
+		treated = PageTreated(page);
 		del_page_from_free_area(page, area);
-		expand(zone, page, order, current_order, area, migratetype);
+		expand(zone, page, order, current_order, area, migratetype,
+		       treated);
 		set_pcppage_migratetype(page, migratetype);
 		return page;
 	}

