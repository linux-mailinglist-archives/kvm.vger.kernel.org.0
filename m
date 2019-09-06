Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE3ABB6E
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 16:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405622AbfIFOxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 10:53:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45115 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405597AbfIFOxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 10:53:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id x3so3242607plr.12;
        Fri, 06 Sep 2019 07:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XeOFbkXePrFioXOb6FAIERJbwcp7KIiK2/+DoMA6rcA=;
        b=Kx9ZIS92cpUp5XYIgowvjW7gz1qiMuGj8JlFJNvG2oheLU6d8RkrFPqNoYDIqBlCgC
         7yWJrSWC5qsnaNG1td/FhR/Eh7krX8YN3gNEQb7XZDOqw7RIgh/pq97J7x9Dy1Bh+QMK
         tBooMcRP+jUXwbQAoJ7u4uaWvZxlz0NvfE453INuDbkjU92ytM1GjgzEhFudHkrULMBu
         x4I1vfYTMCxzZR5yPeVXEd5nvbYKNtky10MfXkhJ3d31ysg4eDDfOLhqQxUr7ILHA0mZ
         dqp0UtKqt+MixfklXN0qXJm6oUF1E5nRNfabdr0WG9xY8NE8ppzlso5wyOA8+CO4RtcK
         JeXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XeOFbkXePrFioXOb6FAIERJbwcp7KIiK2/+DoMA6rcA=;
        b=HXsVc4uGPuaopDbQ2laFdY3rGSJaGDzHZh2F9DF7VyUhG1C5XrAxGSr//Jc6DDBAPS
         gNtrpFf0CL0G5tHwcrFdxtqvVMz755AVrwzKGy0eEYGwOdFnFzsl8lu7/e2Vaj2TGRkt
         XN0HYuQpXo8+vkRSpsGcJZXIwqblaDzGBDknG614FgHQLEd7KE97BS4Llz8oq4cTj7MI
         1WD1sNSKOPhSplozrzP4MmPExyW4/lHMhEcCFT+eLe24MCR+cf3fxzBxOh1m5rT+Hx2M
         w6QUj9/M6+QQZzYTi50YW5UTDOFbJeH2Ayna2iNCtwGjnn3ipStgJTWnT9Rgr5QQVmZ0
         z+hg==
X-Gm-Message-State: APjAAAUOhjh3XPiJgeG17nrLFB6e6aEDTD3HFtAfOqLBO/IsT/eb08q5
        PeNcCINLG3fHCwFct7wGuNM=
X-Google-Smtp-Source: APXvYqxhaJ6uuXR8fGWWr/ufBumPF6vYW2fu4W//uKfSwtowVRUUh4NcMog0BEj7MwBiHEYx30eOGA==
X-Received: by 2002:a17:902:36a:: with SMTP id 97mr9103349pld.75.1567781621416;
        Fri, 06 Sep 2019 07:53:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id d15sm6060563pfo.118.2019.09.06.07.53.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 07:53:41 -0700 (PDT)
Subject: [PATCH v8 3/7] mm: Move set/get_pcppage_migratetype to mmzone.h
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Fri, 06 Sep 2019 07:53:40 -0700
Message-ID: <20190906145340.32552.49026.stgit@localhost.localdomain>
In-Reply-To: <20190906145213.32552.30160.stgit@localhost.localdomain>
References: <20190906145213.32552.30160.stgit@localhost.localdomain>
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

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
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
index 4e4356ba66c7..a791f2baeeeb 100644
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

