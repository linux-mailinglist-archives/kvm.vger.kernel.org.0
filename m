Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923758A965
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 23:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfHLVdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 17:33:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37515 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfHLVdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 17:33:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id 129so3440649pfa.4;
        Mon, 12 Aug 2019 14:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=gP7k43mJSv5f3YSNOpp9K4LaCXk5lNEqmssvOI0R3mU=;
        b=tYp6+TIUEgqUEVOd3/wG8T2Wc6LtpGcesLdCDXD7zKuA9rlMoqRP1Hao9b5KKfCxov
         4vTvfO0mfXRWJYtn8WF8OJ9ENLMWipWoXQoBgwvqn8fY2KU4H98Iqh9QJ0jLiYXsoNvw
         XPqSZ4RgVZm//f6mfnGMk1IfzBZNWhPhub2fWw9uRBtVdEx2FjXSrp2xit2/nlrhmJ44
         wK36rTY4Oc7I14eHPdikOaMp8EopPMhki8WlxKWaA2vLUClZxtz3NR50HdFgf/HtgypD
         /66NSma8aerTGVGesGGmlU8jQbytgUFKcTY3tpf4LC70ulROJea5XMcKA2Ed3YxnXVfa
         x6Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gP7k43mJSv5f3YSNOpp9K4LaCXk5lNEqmssvOI0R3mU=;
        b=GKlzsS57eJ2DviEXMVrupHGaix2HV5qMrAG8+GuM9H3dTOQ6au00uxGChOe1Zt3BaN
         95e3w94zQfumgH/CcGs/xxhOUjRivPmyX7znq6fUyCY6Gu4lCzrqGsQRMnl8TWxaQtnB
         nPekk6FJ2gkJzqSnfiv4/xwUTZXvbSytfLcVXC/9ELLs/daWIJufO8lJ0EqMvfrmoHi+
         M7QpThREVMmxZYctwvgJN3noeER9hiqpkGBhap6+aMZrzvhneE18BZHQ+K7vHrE6QLRc
         +MxcHI/pGpbK9Wz8Im0iqfvrNO5voIbFYXco82lwaAU6QgNqXac9ZJqv30yEasQLbWtr
         +7vQ==
X-Gm-Message-State: APjAAAWpc2J/+v7kYmuLu/RCKSIKvHrBa0/vYMrEp4muyzePVTK7GKtp
        fZ9kvbJewHzSvS9DLp3iRdg=
X-Google-Smtp-Source: APXvYqyuO0QCuGKHd/8j+/2toQLfvARYCrAPYBvjPNhEu77qAFuOgxBKtquha3T84KDeJcTTHIjcLA==
X-Received: by 2002:a63:6c02:: with SMTP id h2mr33347922pgc.61.1565645612681;
        Mon, 12 Aug 2019 14:33:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id c70sm8063pfb.163.2019.08.12.14.33.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:33:32 -0700 (PDT)
Subject: [PATCH v5 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
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
Date:   Mon, 12 Aug 2019 14:33:31 -0700
Message-ID: <20190812213331.22097.94620.stgit@localhost.localdomain>
In-Reply-To: <20190812213158.22097.30576.stgit@localhost.localdomain>
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
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

