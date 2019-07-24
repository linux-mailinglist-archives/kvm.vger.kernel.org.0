Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E557347F
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 19:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbfGXRAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 13:00:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44956 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfGXRAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 13:00:41 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so90976712iob.11;
        Wed, 24 Jul 2019 10:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=H5uePaAnfho3jP4O84y/TR/d85pMr1PHhHfJNr70LiM=;
        b=kHN1iP7zA3FJ74YxjzC8lHyl0JgV6YH25zYfaGW5aYOffgySOf1QKp+KZSQHNEMZFn
         GKh2kTELEzLGxrmnDZLQUmt0ykjoIDF3onJTscviyJA5ehSAC5J/5UW+6OaSP+iS5bu/
         1xU8vU3Z2VYVFmXfnmjeHFfNhPttjVDYToOKq1rg678rqHxcm0f7g0tiQhJpl/xRi+Wd
         hxAt6HjXkfC9jvuYIpfnwcVzdP5pFdL9Cf7F6GyLICGbk9RmPEUy6b4Qcp04eardBWx/
         jknqRgy69k+O7wjc/qY01mpJ20yzKRb5wPGzFCtmmEbEQ6QD7AfuECV7TisOSvi+bo3l
         Y7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=H5uePaAnfho3jP4O84y/TR/d85pMr1PHhHfJNr70LiM=;
        b=Ouj7+48xLx8xxC/3hrv/3u8iPvVsXEERwc49aQESMcXao6pIjVEZaI20MS9qM5JRL8
         tTNK3c8UpvQxyl4WSnReiVASL2r1hEDrm42yD8dYIQhntu+0e4k1IvPJmzs6KhyBway2
         lxslRlR0TC7JRx+un1XZnGNS9YXmSrY+baV/xouNjmURJ+wi1RmIpUFRwyo6Q8AJ8S1C
         s9szJUg5RtM2SDPymhw4mvNlTFhYNJDIO/T8vzZEh1i5npMDzhpWfVJHwxbUIK4HGChy
         ebQuxolOP31ST3I8iehr/jVZYBtV/1leBCaOcP65EPcJonKJb9kAc2/EDJ6bGXVGNPuG
         7UgA==
X-Gm-Message-State: APjAAAXdIBFF2vN118kIC7Tmxc7edqz2fNABaBNCsdBp3guQXa47Hmv0
        m7LjyM5rLXsBOSC2JzNjthM=
X-Google-Smtp-Source: APXvYqx+6Zi+RypFO68n1WeSfP+QuoinYaHM4/PZrw3z9TvZURJv9ULbWB+7BvwlnKgD1QoYlHaN3g==
X-Received: by 2002:a02:6d24:: with SMTP id m36mr87555505jac.87.1563987640301;
        Wed, 24 Jul 2019 10:00:40 -0700 (PDT)
Received: from localhost.localdomain (50-39-177-61.bvtn.or.frontiernet.net. [50.39.177.61])
        by smtp.gmail.com with ESMTPSA id b8sm38161917ioj.16.2019.07.24.10.00.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 10:00:39 -0700 (PDT)
Subject: [PATCH v2 2/5] mm: Move set/get_pcppage_migratetype to mmzone.h
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Wed, 24 Jul 2019 09:58:30 -0700
Message-ID: <20190724165830.6685.51110.stgit@localhost.localdomain>
In-Reply-To: <20190724165158.6685.87228.stgit@localhost.localdomain>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
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
index e32390802fd3..e432c7d5940d 100644
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
index 1c4644b6cdc3..3d612a6b1771 100644
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

