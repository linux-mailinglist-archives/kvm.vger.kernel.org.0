Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67173145B08
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAVRna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 12:43:30 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54463 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgAVRna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 12:43:30 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so212558pjb.4;
        Wed, 22 Jan 2020 09:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=eI6p6MEInjZCHKWZd3a6CL3jD4YUNkjKzQ5d3wA61zk=;
        b=Nml0JO94Yi7Z0V055K0HCI/PFEbCDgvmVM0UPodbYoFdF0WjI1G9yHic9yQqbq5KBd
         0/dURuFDtZdIcyXc0B6anVn1fdbOVsyOfxZYdAVjsikeGrO/ER2gCCcAfDBzB0Wq1wYF
         G7fzREH7BTHCFFC5KxCyo+2n1wLscSIymTWVc1TMdSQ5Ac/SBJctRG65ags3ZF3bw3GS
         /RuxC8GDHu+GJhi2hSlyyR73cJ/7atG/So0h9QSxLrJKYeL/AYZDgSGEtL7CiKGG1k61
         KGp2P9adQGtCGpR7N27z+bbXl25u3YNVjK9Zg7tvykuns2MYAXrj3hc9tOj5qkb1xIUq
         e1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eI6p6MEInjZCHKWZd3a6CL3jD4YUNkjKzQ5d3wA61zk=;
        b=Q6VKcGpCo9ugwxsr/7hg7SFzJEIQaQ5wVTouC49kIvN6K+SxFTKYFVjuIZsBUcm/F2
         LF772pds9wb4sOoqFqhePMFXIHp2NKFGrEmHn8mH11Z2mi69kXmafOC8DuUW08bLUWvP
         tJNsAP+4T+RUZ3K2dRgDyDNfZsLcppP0LI0sAKb7SbKSylDg1CSSaEk9zfUdzvaPGaAO
         G/IriNlCT+bLB6KB7ujvmXrBerC0JrZXSX4RasGBc5Hli9yrtyi16QEUHibCl4FycM/P
         Am2PETnTXI6WNUsueOjxsO7xKmw0rUNf1UcD0Y0HfhePjynhRw0jcXRQ3EZTUbMO99yo
         A+Tg==
X-Gm-Message-State: APjAAAU+02u9cA+iMo4yJIjcv1q7rcJS2AnOqV4Edb6O5rXa/9q/0a5u
        Vu5sGmbwfTWwhh6Mb7QB1x4=
X-Google-Smtp-Source: APXvYqyOujo9zTybEbWxtLbC29f+GQuJ7Og/W6UU8xSrKvJEJCExGn59VDy0J2wdvlHkDzyYXKQdwg==
X-Received: by 2002:a17:90a:d807:: with SMTP id a7mr4469723pjv.15.1579715009674;
        Wed, 22 Jan 2020 09:43:29 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id c22sm47286700pfo.50.2020.01.22.09.43.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:43:29 -0800 (PST)
Subject: [PATCH v16.1 3/9] mm: Add function __putback_isolated_page
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
Date:   Wed, 22 Jan 2020 09:43:28 -0800
Message-ID: <20200122174328.6142.13364.stgit@localhost.localdomain>
In-Reply-To: <20200122173040.6142.39116.stgit@localhost.localdomain>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
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
index b1cc0dab1c29..f65e398eed89 100644
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
index e70586523ca3..28d5ef1f85ef 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -113,13 +113,11 @@ static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
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

