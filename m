Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89FF1144B1
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 17:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbfLEQWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 11:22:35 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:44040 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbfLEQWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 11:22:34 -0500
Received: by mail-qv1-f66.google.com with SMTP id n8so1472824qvg.11;
        Thu, 05 Dec 2019 08:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qdguelrx2s1Wt3tWO+WfWlC6LCbWX2daKxv86hu6t5o=;
        b=Y5UBAwIq4OWO3ExNVc24wmptqgL8EocYFQM9GD1xFSzSxsBJ/d5nPiz0qTX/phkTYp
         chHI8pBVIY+eKRZHgkJCYwJITEPS0uexD4dGoofAvXArMCb8YNk1gc5LpI9z04dJ6EnQ
         NwqCiNVIQWBF43cRB0hpQfDoAmD64O8aUsW71Clv+JAhwpr3lKxncd2aSC0TVlLFrEHz
         ZR9wnwccG43MrICtusZhtAzliDoaS+OK04F1MXSQoubf9QZJ66Z1JV0YpcbA/tXbmgTF
         Us/iVbsrFGQbiReK/s3yCeIcv6YFiqduhX3N5dTBjvAOqFiVfhuOHJAiLd6ktlA1ka79
         BEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qdguelrx2s1Wt3tWO+WfWlC6LCbWX2daKxv86hu6t5o=;
        b=Kt6k2c34dT929IFNrx557rIhNQk9nm55hJ8gaKBV5/ftrX63+nJ5BvqvHiWMlOId8A
         08jgMTfzz7lLaoqj2M6S/pbHrEXegyAvTGynFNSYxU+FJup/jraYkcUz3HAVOWMFnvZZ
         i6uE20LuENjizkRIzAEvWd/YCHFQqPfH/XE8lUO/ZnpLFHXsHvi5qpOG2KnJgJamKMUi
         2JniA+H4msC+gzyhT2XagjykT1ffLSVrUmgLuy8rx6ZQsacJ/KP33kyuSrFbMxTZNX13
         kZLyUfBezUK66zxx3P0aP0njwSDkYm4qnaXaFlElripAxrKdTGNC0C6c+YAH4m3e5C11
         w3xg==
X-Gm-Message-State: APjAAAUOOtP2lkagnvdJ75OjKYDgkyok1roKFiZYauvCQBJVvSLF7SeS
        hfshf9u2XPeqbapa6f53DQc9yiBUAvA=
X-Google-Smtp-Source: APXvYqyUS56n7YGvPTV8wc+PhM19cVoX5iTOZF7S9Cf9suV0sNP8auM3g2jdOkVHjJWemqlPIzfaNg==
X-Received: by 2002:a0c:fac1:: with SMTP id p1mr8325843qvo.231.1575562953446;
        Thu, 05 Dec 2019 08:22:33 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id t15sm5029696qkt.30.2019.12.05.08.22.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 08:22:32 -0800 (PST)
Subject: [PATCH v15 3/7] mm: Add function __putback_isolated_page
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
Date:   Thu, 05 Dec 2019 08:22:30 -0800
Message-ID: <20191205162230.19548.70198.stgit@localhost.localdomain>
In-Reply-To: <20191205161928.19548.41654.stgit@localhost.localdomain>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
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

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/internal.h       |    1 +
 mm/page_alloc.c     |   24 ++++++++++++++++++++++++
 mm/page_isolation.c |    6 ++----
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 3cf20ab3ca01..e1c908d0bf83 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -157,6 +157,7 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
+extern void __putback_isolated_page(struct page *page, unsigned int order);
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e0a7895300fb..500b242c6f7f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3228,6 +3228,30 @@ int __isolate_free_page(struct page *page, unsigned int order)
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
+void __putback_isolated_page(struct page *page, unsigned int order)
+{
+	struct zone *zone = page_zone(page);
+	unsigned long pfn;
+	unsigned int mt;
+
+	/* zone lock should be held when this function is called */
+	lockdep_assert_held(&zone->lock);
+
+	pfn = page_to_pfn(page);
+	mt = get_pfnblock_migratetype(page, pfn);
+
+	/* Return isolated page to tail of freelist. */
+	__free_one_page(page, pfn, zone, order, mt);
+}
+
 /*
  * Update NUMA hit/miss statistics
  *
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 04ee1663cdbe..d93d2be0070f 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -134,13 +134,11 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 		__mod_zone_freepage_state(zone, nr_pages, migratetype);
 	}
 	set_pageblock_migratetype(page, migratetype);
+	if (isolated_page)
+		__putback_isolated_page(page, order);
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
-	if (isolated_page) {
-		post_alloc_hook(page, order, __GFP_MOVABLE);
-		__free_pages(page, order);
-	}
 }
 
 static inline struct page *

