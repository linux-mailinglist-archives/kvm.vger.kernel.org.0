Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E146B4C3AB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 00:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbfFSWdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 18:33:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33499 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730730AbfFSWdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 18:33:12 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so1460663iop.0;
        Wed, 19 Jun 2019 15:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NZX9ozjZ+h++nQ9qTzVYYR055FmQZfSwp2MFV40l/Yg=;
        b=AykkqRY/B8jQYskC0hBeay6QNRuqle2AeMVGLRM8LvJGbh2o+2wLfzsOBZFBEUIu9Y
         qCSO6NhEds2PvgNyNoMgHAKvxivTIw9RwSJ2CdlS5Zm4U/SjABUyMfAwNpnYf6X+WqnU
         M7/QbmMXRZZlCzuk9OblJhNYm0tZmX+NxWi693yH6wo7MWpwFAdRKQlJ3U1fwg0m6f0P
         2iROcjzO+q3Rrm3wki11NzixozRES4o5dJ10ciG8N9BtseIWAF4Tn0T3o8HgFZWUpeLy
         Un960tboJzppnKgY/ELquoAi59xkBmskrUyQsnEHENGdgSl3UiTCXoyywpupYHnM0Rdg
         I9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NZX9ozjZ+h++nQ9qTzVYYR055FmQZfSwp2MFV40l/Yg=;
        b=SZEDujrAHkEXTT5irJxtVGK7PMwhW1r11WqLOcvefWd39vho77Zqf71/lbdt6aHfzi
         uE0BNflP652fOLnMkdvGdyshoRZXR++U9dAmTW+RiJ/xznUhceD4h7JUeUgVmyKOCzpc
         nhiyc2CYoB39wt2S/I5iAPgau9acDEyLA0wI0tptBT0HgBUvzGatIyUjPgWjhbU7Bs8i
         6pYlFTZ2xfL0aSHlDteWUq747qvJXWr5TPNbISugMo9MurUfecgkqZkhxIfI/faIZ+jp
         WFzZFa+Z99eG/cDcvvKUkqZ9JHjOZKhmPOslP7IXMQ8VhKZbWFRFJjysCSnyRHA5fHCk
         +dCQ==
X-Gm-Message-State: APjAAAVKepplJl37QrcQKMEg5aG+eewCyrB0R6noPxWnEIwt27/IztRS
        lkXk/Ahx6T6aBBgNMeKUMSY=
X-Google-Smtp-Source: APXvYqwRnLuDFzAfR5lMoUpbGfuz69Ko0BWafruD9h5MagTA3O8l8M6s6sqfE+SW8RL4CMOIW1ybvA==
X-Received: by 2002:a02:5489:: with SMTP id t131mr97296596jaa.70.1560983591570;
        Wed, 19 Jun 2019 15:33:11 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id q13sm17804752ioh.36.2019.06.19.15.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:33:11 -0700 (PDT)
Subject: [PATCH v1 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 19 Jun 2019 15:33:09 -0700
Message-ID: <20190619223309.1231.16506.stgit@localhost.localdomain>
In-Reply-To: <20190619222922.1231.27432.stgit@localhost.localdomain>
References: <20190619222922.1231.27432.stgit@localhost.localdomain>
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
get operations for pcppage_migratetype into the mmzone header so that they
can be used when adding or removing pages from the free lists.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h |   18 ++++++++++++++++++
 mm/page_alloc.c        |   18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4c07af2cfc2f..6f8fd5c1a286 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -95,6 +95,24 @@ static inline bool is_migrate_movable(int mt)
 	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
 			PB_migrate_end, MIGRATETYPE_MASK)
 
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
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ec344ce46587..3e21e01f6165 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -136,24 +136,6 @@ struct pcpu_drain {
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
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

