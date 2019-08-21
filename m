Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D78097DDA
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 16:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfHUO7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 10:59:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40223 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbfHUO7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 10:59:39 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so1460318pgj.7;
        Wed, 21 Aug 2019 07:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QPhM4FxLG/tLwSMDGDf/LdT0Fop/lM8Gcn0ubZPF63Q=;
        b=pmRZjyhXPIW1vJkVYB2QAF5y0/5tcxnlwpB7ZAO0Fy+VV95UNeq9duufGGMvxLHJQU
         p+CZYpUGtknHLC6I4RPu+qdfhBXOUVeMXNtZJ5BMlSA0RtWZ2cIHr4pxop6nEt76bTRM
         jg5wMV1ZnhGhmYsPfjGzmKvbqO86oG/HuvrfPrcTiScWmXZOrWextQrIGnJQor9UMP8r
         SjfdB5afonvgflHlux/Uju9eVJ70bmfZpetB8PmatU2wS7SJLr1GaN3e2cl0LuTbL4ie
         vrkAYqnr6+hbqnCanZTe+TPULzpvWc30zoa38m22LFYJjuAALvxvKxfHnkjnUVR5zJwm
         ISzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QPhM4FxLG/tLwSMDGDf/LdT0Fop/lM8Gcn0ubZPF63Q=;
        b=MhRbiH3zHSYYPXqjTDy40eTsgAJvwhpOnuNrBAlmtiWLvYJpmxBtcdNo6mz42gat+X
         dTq9cizhN9FG6/1zFJvyr45w2t3dbm43WvRXgQdjhXa1/P+l93mp/P5dwv+2kwF/WcHA
         xdsU7diH5/vP03+SVP+qDK1wsHFXgUaRLdqbC5DAxPEunV3eJWZbzSdo5XL87oc6s/Tz
         kTGlb/i5eEmEWPhEAVYeXQ5dGGBh4bNw5brN0HJf/+OlX7Q88C/Dmdi6bbrtWo/IxPfT
         5H0Sy9pT4Qe4kiBQU0pwAdcUcs0kLudsiXiKbMLrMcyan0fn2LP6e54zb/U7DsBUQU3n
         J6Hw==
X-Gm-Message-State: APjAAAWBPDpgQSkNEPoAyI+GlLUsu+U4boVa0GkQ2AXAzLGo74xN4boJ
        6Y2OU2h5lK8i9Wmjb0u92Sc=
X-Google-Smtp-Source: APXvYqwiHXRijhHRhNIDrYtME3k6OqWOeiu1KWcm0C0JSNx7KxTeuVS2kjfis9eSrEjyDTRxU3GNjA==
X-Received: by 2002:a63:1d4:: with SMTP id 203mr29204834pgb.441.1566399578782;
        Wed, 21 Aug 2019 07:59:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id e189sm20827753pgc.15.2019.08.21.07.59.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 07:59:38 -0700 (PDT)
Subject: [PATCH v6 2/6] mm: Move set/get_pcppage_migratetype to mmzone.h
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
Date:   Wed, 21 Aug 2019 07:59:37 -0700
Message-ID: <20190821145937.20926.78233.stgit@localhost.localdomain>
In-Reply-To: <20190821145806.20926.22448.stgit@localhost.localdomain>
References: <20190821145806.20926.22448.stgit@localhost.localdomain>
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
index 3f8d5afe61fa..c1f9a80b3f28 100644
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

