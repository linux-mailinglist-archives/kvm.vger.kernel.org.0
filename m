Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E4E159C7A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgBKWqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:46:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37617 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbgBKWqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:46:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so14615994wru.4;
        Tue, 11 Feb 2020 14:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lZRwr3nMHRBktKFSV5Mq10r8EzROhEGh/FsmDXkj5s8=;
        b=UVWz0nCQ/n8kmTOHKn86Gkoa3EPtzkq+4JVjUqPbfgBPDgmEJaph9S6hs2sBak3jnU
         g2QHDxMYKDlKkSe/LGHE+hp1vu1mfvaOPkerXAuf6C72Dr47sF0u92JEa1eTvqlf/1nl
         /ZuJoRL/qnqdmms5dhCbNXOo8e7yfbcSWt8vcwuLHyxwH3/1/CJGDEIOD9366lXX0Lfg
         FtwE7sZudGoQrMrouqgktpZkk1XT7cQSid7VKMOzEwu+BlwNzmZm7Yf3z+gDxkzkDSAy
         4Sk8Ikw0hh+cWYrMZE8xG7DV6nGWdHW/dHl61rYYLxTWL1X95FfA86wCKOMpg4MqBLSf
         BXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lZRwr3nMHRBktKFSV5Mq10r8EzROhEGh/FsmDXkj5s8=;
        b=UYD8M73WWsWN0AamevLfIG/UsovPY2co6Vw2x2Gwr0We4GKzJ976h703ajEbpSnt01
         LTEEZywhkasq650d/qE1j4EhZISkZBvwyf2zlleuUDuN7TkfZwMAicpz/mp2LDZjCtoM
         BkdRZGbbnukLUOJSVHN9vGRZK8e4Ouq5jQE2WMAnTqFR18CJ7z6FU9KXLF9CgFo0zsJu
         GmsBz/2FCxj8NOmLXmLlO86YAsDcx+m+nWlKOiQRumMqd/04z6vjaVVQGWZqrznavWq0
         GsmL+49fjmYdk29BZLTIEaYOekCoSJyGu1P95Bxk1d6Zp+TsI0dlwnbxEZQ5ZQNffqI3
         Munw==
X-Gm-Message-State: APjAAAUPvjVnCN5VVZEDRHUugh36FnepFA65fXGi+vpb4EHXvJxXWuyd
        C621QKFmwEuDM6An2td2OOE=
X-Google-Smtp-Source: APXvYqw/X8oh8x+2FHV4J/a8al9ZHaabt10Yx+k/wL6WSpd9P7SvzsR/yXN4EvmjPBua26XidW2KBw==
X-Received: by 2002:adf:b7c2:: with SMTP id t2mr11022446wre.269.1581461190406;
        Tue, 11 Feb 2020 14:46:30 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 133sm5999318wmd.5.2020.02.11.14.46.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:46:29 -0800 (PST)
Subject: [PATCH v17 3/9] mm: Add function __putback_isolated_page
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:46:24 -0800
Message-ID: <20200211224624.29318.89287.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
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
index de916aa06a27..b711fc0159d9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3217,6 +3217,25 @@ int __isolate_free_page(struct page *page, unsigned int order)
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
index a9fd7c740c23..2c11a38d6e87 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -117,13 +117,11 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
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

