Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC47B855F7
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 00:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbfHGWl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 18:41:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34957 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389412AbfHGWl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 18:41:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id n4so1192517pgv.2;
        Wed, 07 Aug 2019 15:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=gP7k43mJSv5f3YSNOpp9K4LaCXk5lNEqmssvOI0R3mU=;
        b=M47wq6oaadwL5mKkByQrptrnOULI9VDmL0/6L+92fOzfVvfitjC/ElFoAnWigW6Tgl
         2BH+ULIYowkwt5Hra57TrApc83fuelgXBZL+tmKfGBj6Y3DLb7RmXg85Th88SRjxi/k6
         TfW4pMsajAECj1ptU2TDe/SNHCHtERvlsBgXaRyx/NIKpv1HlsNIIm8klzHtptg4KiAJ
         jvM5DgvkZSawumIhfZwbBoqk+Z9YLeG36U2JqC4FPSXlD5VjeyMI7yHlnv9J64LCuUO+
         sBW0JPMMK8sjF5cZxgEemkrTFFuMEQENWnSKtZQPgOUbzPCV7zCmtK+6VxwlUyc6tk4A
         Is0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gP7k43mJSv5f3YSNOpp9K4LaCXk5lNEqmssvOI0R3mU=;
        b=LV8YOWzA+/lZi6Ox6fUvzeVYFgMfaAKi0+vhIi5XCo6Zm267dDOPQJ/zZ0dAzJstCz
         x89rWrFnF/yA+kwVQkOQYiF2iufQnsTZJ5GEmUGkbzOfHPMMbJZ+3EOsCb8q7ZIEG9VW
         K0tgZ0283xt8I3uATnnl2QcTlELDp5XY+FyIwNeeitRy+zudJ9up27vP5gfVpZveucFT
         6na3rjoptPSwlDTtXWoeIz4ZIN8grvtUi3NnqHByXw8vPJ3SwAxW2ciyJbBfYtStdiYk
         MWsLrQY0g7Xf4S2VIEXRSkJ7a9Qtkbl1sJUo3ApGfp3gkxCVyCTAg30zhPVZsmRsLyoo
         liwQ==
X-Gm-Message-State: APjAAAVQYfORxn979ITBu3t09/j5N4zw8mM5jS2jlXzWk/+NhTOxp2zQ
        bwbGrQHh62kVtTzKj3BXJJA=
X-Google-Smtp-Source: APXvYqw7+iGCoVEpaok0NeV0fhf636bWennC5o7JVfoBsRlCRu3ykru0N0YOA2U0+OillUts6lvxTA==
X-Received: by 2002:a63:3147:: with SMTP id x68mr10013656pgx.212.1565217715594;
        Wed, 07 Aug 2019 15:41:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id a6sm209209pjs.31.2019.08.07.15.41.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 15:41:55 -0700 (PDT)
Subject: [PATCH v4 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
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
Date:   Wed, 07 Aug 2019 15:41:54 -0700
Message-ID: <20190807224154.6891.29107.stgit@localhost.localdomain>
In-Reply-To: <20190807224037.6891.53512.stgit@localhost.localdomain>
References: <20190807224037.6891.53512.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

In order to support page reporting it will be necessary to store and
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
index e3cb6e7aa296..f04192f5ec3c 100644
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

