Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED7412FE33
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 22:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgACVQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 16:16:36 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34737 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbgACVQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 16:16:35 -0500
Received: by mail-pl1-f196.google.com with SMTP id x17so19460467pln.1;
        Fri, 03 Jan 2020 13:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Q5g0XGFgrpPSKiXo2HRT1FkXuZnAh556vUBRJ0hqLcw=;
        b=LFZqotGiJfnk82Pn00DUvtwp9P2Cbk3/QLUEi08e3ZK22MyX+P+YE2AwNvEbXqjruJ
         f4P/JhVz/oDsKOFwLFUfYcmW3EXRjS47yl362VcRa/2H5sHkyc5bNV22F47TKa32cUkF
         jz6/L3C9pMpv+7z603yYZbgwXd5CewZOMHrDcVj3/5qdmRWxEjojr8M+cD+H4sxz0V00
         47Nkt/9Ko+4H8+wwEA58HcUIXGwNiPGwrj/Uo+PToeZjMZDrRfKat/VZg1F69U8IEKJn
         U7Mni5JwskAafAmGtjkttlTMtMINOfXVl4HHwRvdKZwx4GiEVCDDC18IfxIJJe40nFwT
         G+Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Q5g0XGFgrpPSKiXo2HRT1FkXuZnAh556vUBRJ0hqLcw=;
        b=Wp3o4sNPlTi1VSjy8MQkNzMa6ELlWNe+rCgAtKwcF91F92zeIKncuRYQ3MNKG+X5/0
         yePK+Kndjkc9+OtvvdxTzxx0LEmn5uJMa+nlxpYLTg9pVsYhLO4K1XH9/hP+d7cVVDs5
         IqVoAKhKfgyxxcjC7m5WcCZqNGuyapVY+5wqsz+nP5HMyQhUCKa8THvlGWJFB1e3dZbG
         SlYDKMkDbqbIdaNeEwBKFi3uqPSW/pKP5G87ur7Xp6uaUy3FDADiew6No5o8wBbL8BFP
         JU12LO9eww9uwqD+Uydr+xaAubH0Uo1FBatj807DsVSiNJYmEwiA3Wgg9q7dLmXuzAZa
         b5qg==
X-Gm-Message-State: APjAAAVmN57Oh0wIHG1FfdJlzqq+DAefTZRk4Y9BScTMsQRDZPnQdIYD
        TbvKp071JjkSH9RZBshj78c=
X-Google-Smtp-Source: APXvYqy+sqEgFI9fo0GpNaDboSO7okRsT8jjyucvGx6hJrYGMUqhKYGga78lyrzuh0g9r/DjHNOlBg==
X-Received: by 2002:a17:902:a503:: with SMTP id s3mr89388388plq.274.1578086194471;
        Fri, 03 Jan 2020 13:16:34 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r30sm69404162pfl.162.2020.01.03.13.16.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 13:16:34 -0800 (PST)
Subject: [PATCH v16 3/9] mm: Add function __putback_isolated_page
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
Date:   Fri, 03 Jan 2020 13:16:33 -0800
Message-ID: <20200103211633.29237.89510.stgit@localhost.localdomain>
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

There are cases where we would benefit from avoiding having to go through
the allocation and free cycle to return an isolated page.

Examples for this might include page poisoning in which we isolate a page
and then put it back in the free list without ever having actually
allocated it.

This will enable us to also avoid notifiers for the future free page
reporting which will need to avoid retriggering page reporting when
returning pages that have been reported on.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/internal.h       |    2 ++
 mm/page_alloc.c     |   19 +++++++++++++++++++
 mm/page_isolation.c |    6 ++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 3cf20ab3ca01..7b108222e5f4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -157,6 +157,8 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
+extern void __putback_isolated_page(struct page *page, unsigned int order,
+				    int mt);
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 459c6b2109bd..9dce69fce9e0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3228,6 +3228,25 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	return 1UL << order;
 }
 
+/**
+ * __putback_isolated_page - Return a now-isolated page back where we got it
+ * @page: Page that was isolated
+ * @order: Order of the isolated page
+ *
+ * This function is meant to return a page pulled from the free lists via
+ * __isolate_free_page back to the free lists they were pulled from.
+ */
+void __putback_isolated_page(struct page *page, unsigned int order, int mt)
+{
+	struct zone *zone = page_zone(page);
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	/* Return isolated page to tail of freelist. */
+	__free_one_page(page, page_to_pfn(page), zone, order, mt);
+}
+
 /*
  * Update NUMA hit/miss statistics
  *
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 04ee1663cdbe..cb26aea9b9fd 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -134,13 +134,11 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	}
 	set_pageblock_migratetype(page, migratetype);
+	if (isolated_page)
+		__putback_isolated_page(page, order, migratetype);
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
-	if (isolated_page) {
-		post_alloc_hook(page, order, __GFP_MOVABLE);
-		__free_pages(page, order);
-	}
 }
 
 static inline struct page *

