Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBD9A8954
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbfIDPKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:10:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38799 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730714AbfIDPKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:10:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so6883765pfe.5;
        Wed, 04 Sep 2019 08:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=p6kpa+V/mOCw2Z+/w4fmfqemmfT1IhqWlu84Sk3ejgg=;
        b=UFkLFQpC7E14Ptl4qhmREGp8b+BS/boPhGg+O4m+5ArD6kZf3FfjmAiTLZuUmkI9Ty
         OZGjg3C0zJnk4XgjOsLLfFKed7k3HdgxKtDtveiknbYQRkBFjfuYYrVB+kI8mX3tc0YF
         3gyE136VMmMvaCZhCWqAA1f0NuTsdCQL/n9hMLMCmC/yyNcUO7rzgc6bBfuSYVQn7QO4
         4xfcHLLp9fjwzH5U/MDqPGMleIl53/lI+O/0ubte1uyIFmU+nYcd8R9VSVkwaet4v8lc
         xPSSdiyMlPiEooJhGOKIrRD23sse/vHSBlGXXWob+PZTqG0xKym5Z7Xfx+mPx4Sn4C11
         j4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=p6kpa+V/mOCw2Z+/w4fmfqemmfT1IhqWlu84Sk3ejgg=;
        b=FZyZ2Z7c18l2CTsOb8eYCJumWxLdvH127Gm/Q95njIgV0Ju6bMzwgQy1h7sj7GcQTf
         xurDrCpoceSV/znMXgX1a42VVYXF/93t2cv3cjZ1FT2Qm3aMKng/W9GkSrg3Nf2Uu7Qe
         9fIbBtqYZ8M/O3FRBPRyIR2yHPWvYJ65fQE14rqz/KAH2ZCe0yMUK4aeM9VtCN5MJXKf
         4yjJUHZmVz5vUhH5ifLe/ik+LxzXHF3gR2kUFIaCh3ntmerrEhDS7DsSiDLuxSUosh8v
         +02QHwuaX91MgrGmScn53BXnTD/g8t4AWqR1PfuK79DL6rnyucfWLOkRqRyo+C7y7ww/
         13+Q==
X-Gm-Message-State: APjAAAWmYLFk94eIfiyp/NXCHKBtpvjztTpSelRZp6ksLvzf+jdg9PsN
        Gok99nyCCGX1yfYgIsBN+Rs=
X-Google-Smtp-Source: APXvYqwrcq8XegDQKGDNlpLz9ievgPZeY+21HMDXgAdbxzbLSVIJ4dp0rvcd/C0zGXp9pDll7JlPZg==
X-Received: by 2002:aa7:9343:: with SMTP id 3mr15433820pfn.145.1567609838132;
        Wed, 04 Sep 2019 08:10:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id u69sm25695517pgu.77.2019.09.04.08.10.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:10:37 -0700 (PDT)
Subject: [PATCH v7 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
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
Date:   Wed, 04 Sep 2019 08:10:36 -0700
Message-ID: <20190904151036.13848.36062.stgit@localhost.localdomain>
In-Reply-To: <20190904150920.13848.32271.stgit@localhost.localdomain>
References: <20190904150920.13848.32271.stgit@localhost.localdomain>
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

