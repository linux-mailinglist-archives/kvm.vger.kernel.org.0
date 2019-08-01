Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1927E5AA
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 00:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfHAWbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 18:31:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46578 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfHAWbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 18:31:40 -0400
Received: by mail-pl1-f195.google.com with SMTP id c2so32785398plz.13;
        Thu, 01 Aug 2019 15:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=49QRQWf2FNsjOXVM5hrSB1/wT6sFBWj2i81LIQFGLg0=;
        b=ji33itetIIDF6723/1Y8YKJGaXsZhwxdfFFZT45WUtDznubVlVgr6z8O6LM2Y0Bm8P
         P43KwP1bs6fuGWQAelVx2jsf+HXc9hjzhGqb6BID3daGICPkxx/rJvFHx5nyJeTqaquo
         J5birZo4hMpfVK6j0Z9nSIcOOGAxTZryiD/Bg7Ea0Sh4JYUZV5Q8A5i5BlFn+XlDUn2Y
         xbtmEccIS9ctv1SzHpgWS+Gmvdsmo1e/yOMrR/P+7j5Dc6t3T1NV9Bf8oF0an0BTRzHE
         zwVYl7CMWW7OMqTK+UidQdCn5nY8fJS9gYQXsiGqTJOK0Pc7c31igD37NF4ruL1MGqIV
         abHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=49QRQWf2FNsjOXVM5hrSB1/wT6sFBWj2i81LIQFGLg0=;
        b=n9jK1X8KYXR0qVYxL4mgYzoR7+hPt3qIlbfhNA9uCoj0U1Yur6Hzq9J422+PTJR/ys
         YEevjDguYIYx3kVI4MP5lHP5F+hj19AIvkK4zONfMGtzJLVAbq8VOGoL3f/TH2yZrq5X
         4Na0G4NhvEr7EbpdWY7wD6yIwCEvblY+L7Yhi6Q1VjxJ94o6jaIonGxRo9YuGEQ0gTjS
         /lTfw9yEvfY3QiaBzpD4lLSgdm8b+aGcYZBbZsBGFW+IIrApnlJrB2ZWnLkrsk80Acez
         0Ujie7tKrRDdQvKfxwIltpEVAuPv2/X+N7QCF3Wv1LXN6w42RqrJ8o9PGPHvZYUpb017
         iEQA==
X-Gm-Message-State: APjAAAUS+TC+hizhmTyPTw1DzUQfN4ueZHqOAHE8y09nwXXeoQay5hJr
        jtrVQKiNrY/hdfGKNK3d/RzjWS0u
X-Google-Smtp-Source: APXvYqx2jv1TK82igL61Day1gZd1T9JWolFuPhQSs0j3XhgePDf2nr7I5FyOs/W+WeBpIigsbk6TNg==
X-Received: by 2002:a17:902:2be6:: with SMTP id l93mr129298797plb.0.1564698699193;
        Thu, 01 Aug 2019 15:31:39 -0700 (PDT)
Received: from localhost.localdomain (50-39-177-61.bvtn.or.frontiernet.net. [50.39.177.61])
        by smtp.gmail.com with ESMTPSA id m20sm80514167pff.79.2019.08.01.15.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 15:31:38 -0700 (PDT)
Subject: [PATCH v3 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Thu, 01 Aug 2019 15:29:26 -0700
Message-ID: <20190801222926.22190.81982.stgit@localhost.localdomain>
In-Reply-To: <20190801222158.22190.96964.stgit@localhost.localdomain>
References: <20190801222158.22190.96964.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

In order to support page aeration it will be necessary to store and
retrieve the migratetype of a page. To enable that I am moving the set and
get operations for pcppage_migratetype into the mm/internal.h header so
that they can be used outside of the page_alloc.c file.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/internal.h   |   18 ++++++++++++++++++
 mm/page_alloc.c |   18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0d5f720c75ab..e4a1a57bbd40 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -549,6 +549,24 @@ static inline bool is_migrate_highatomic_page(struct page *page)
 	return get_pageblock_migratetype(page) == MIGRATE_HIGHATOMIC;
 }
 
+/*
+ * A cached value of the page's pageblock's migratetype, used when the page is
+ * put on a pcplist. Used to avoid the pageblock migratetype lookup when
+ * freeing from pcplists in most cases, at the cost of possibly becoming stale.
+ * Also the migratetype set in the page does not necessarily match the pcplist
+ * index, e.g. page might have MIGRATE_CMA set but be on a pcplist with any
+ * other index - this ensures that it will be put on the correct CMA freelist.
+ */
+static inline int get_pcppage_migratetype(struct page *page)
+{
+	return page->index;
+}
+
+static inline void set_pcppage_migratetype(struct page *page, int migratetype)
+{
+	page->index = migratetype;
+}
+
 void setup_zone_pageset(struct zone *zone);
 extern struct page *alloc_new_node_page(struct page *page, unsigned long node);
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dfed182f200d..7cedc73953fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -185,24 +185,6 @@ static int __init early_init_on_free(char *buf)
 }
 early_param("init_on_free", early_init_on_free);
 
-/*
- * A cached value of the page's pageblock's migratetype, used when the page is
- * put on a pcplist. Used to avoid the pageblock migratetype lookup when
- * freeing from pcplists in most cases, at the cost of possibly becoming stale.
- * Also the migratetype set in the page does not necessarily match the pcplist
- * index, e.g. page might have MIGRATE_CMA set but be on a pcplist with any
- * other index - this ensures that it will be put on the correct CMA freelist.
- */
-static inline int get_pcppage_migratetype(struct page *page)
-{
-	return page->index;
-}
-
-static inline void set_pcppage_migratetype(struct page *page, int migratetype)
-{
-	page->index = migratetype;
-}
-
 #ifdef CONFIG_PM_SLEEP
 /*
  * The following functions are used by the suspend/hibernate code to temporarily

