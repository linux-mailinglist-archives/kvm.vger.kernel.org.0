Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7613AC812
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2019 19:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395163AbfIGRZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Sep 2019 13:25:32 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33388 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395132AbfIGRZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Sep 2019 13:25:32 -0400
Received: by mail-ot1-f68.google.com with SMTP id g25so7487883otl.0;
        Sat, 07 Sep 2019 10:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XeOFbkXePrFioXOb6FAIERJbwcp7KIiK2/+DoMA6rcA=;
        b=rYZVLzjvr5yE4QlzHHD82dZS2lBNT8G+0FQqFRdBYAjb/wKgN0lU5D1lBtoQWqfTjX
         aSCp6awRi7fd3X5kAvvuGccRdgGzZtxlICkGXwUikok0PX+w0BwbIa3SKAUzKWWokUeZ
         Qps21btfn9+VGyzAHOVRDS6z2Kqho67V64Mbajq6dDKkghbv6HLu8OoqaTF3ne8jpW/A
         uy6B4yNR064NWLAcd1nJqcMiDvCWIWDdSqgiAzUal7K14B5N6xMLv4F+4vPTHKSWOCJI
         Yzxr0oGW//qzZPv/1RcDfTKG18YRItPedk5lEVTeukfviAzCKHdYZIHdUFfHEbJsMsKs
         NGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XeOFbkXePrFioXOb6FAIERJbwcp7KIiK2/+DoMA6rcA=;
        b=iZ5RxXVNCI0/BBc3rdjamMZWh2Phquvvq+yMfAiVJCZ+ykON+yFQX4sIsLhE3NmDlU
         Pw95Z7zm4D3WyUhugsua91DOK3DZxKg+ncE1FrjOEk92lYPtCYKRcaY9NYm19EbhQvVv
         iECuPh0M3qJ3kFKouYvfsTRvve+k/6OeDvUztwgk3OSaPVBWd6ZBSfEVQyCwZ5zR2GXj
         HpxCC+fA3V/2lDPvtE3Wy+wees/uOLI6gr1ba7veg85rF08qamrz6jTRwqu3ZYEfGTFr
         qUXkqwAfCjOQNxtnj6p0rZuYY6gK79QlFVgqZ70R329H4ZOswrSGNPWVZUAWCew4QOv2
         PyHQ==
X-Gm-Message-State: APjAAAX1Ui9Oqx9FmWdhddVPE7TPagNzk4AdP8twlEmWOjtPOMyfXCa/
        afFXrfv3oK69ptvVjPjY3aM=
X-Google-Smtp-Source: APXvYqwv1SFq7ObWqAIFpc+/RF0fOZtse6a3DjMkC4Rs/jY3P0in4RopuF/MfrzoMf7ETBATX4C09g==
X-Received: by 2002:a9d:1921:: with SMTP id j33mr12440399ota.304.1567877131742;
        Sat, 07 Sep 2019 10:25:31 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id p28sm3582003oth.38.2019.09.07.10.25.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:25:31 -0700 (PDT)
Subject: [PATCH v9 3/8] mm: Move set/get_pcppage_migratetype to mmzone.h
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, catalin.marinas@arm.com, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        ying.huang@intel.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, fengguang.wu@intel.com,
        alexander.h.duyck@linux.intel.com, kirill.shutemov@linux.intel.com
Date:   Sat, 07 Sep 2019 10:25:28 -0700
Message-ID: <20190907172528.10910.37051.stgit@localhost.localdomain>
In-Reply-To: <20190907172225.10910.34302.stgit@localhost.localdomain>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
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

