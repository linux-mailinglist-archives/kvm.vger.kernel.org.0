Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EA312FE3F
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 22:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgACVRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 16:17:08 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:40603 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbgACVRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 16:17:05 -0500
Received: by mail-pg1-f181.google.com with SMTP id k25so23926060pgt.7;
        Fri, 03 Jan 2020 13:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yW1O0jjXB9z8bWi4RkuBpy5DqO+Vy5mEgFaRwUh2ELE=;
        b=N80AAa3s0zzd3IKELy/pbRakvvtwA55lPakZG0dcI6ezILUb1eCpIyR9Q1ehAbeKRD
         2bbB4pS/D2iQTaP5M99p5+BeB3boYWFCkk0nwaydCdGDI16JTQJP7IWTqlTjRWmEqM8c
         L/Ze6ZVTH21A0XPI4MnVOIqXkIMzoxSxrWwuMLmApBmqIpafRJdLn2ybp5xAqNJJOO8V
         EjH2ROym8hZAoXkNPgXwY0zcbYZrL/ulVvHwud6NLmuOirehKNsZlr53orYwHCFyN1MY
         fI2C1dWH1Fp+ZJ2JmBkmVimkP1kWR5uBzOQ9rNc0tVAG55Y4WeMxBOThtX1j/ulvnnJj
         T6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yW1O0jjXB9z8bWi4RkuBpy5DqO+Vy5mEgFaRwUh2ELE=;
        b=J+1d2x7Bp+jhiSVDrSFxYpNJLFQedd65Ykhrd9imn0iVIqlpGrxF9HkMa6mc1LUyHL
         eSDtLEKfHjoAgXSbjYv6vJuq21ycT5z5+qC5wa+73OP1hhW300/7Yc1TQmfln1nzEPn5
         atv74ypdlctXriFuSppAY8vUoH0z/yr4iNFWL0yTnRAd5CLX69KEtctNrREha/0Z0WtG
         mAfVxYK8BjpuSOolJCr4uDbyz3A23RTAkl9Y/Fazjm2aU8sICPgpoWG8c9sOZHHlxVo0
         lpj7/yG6wtHfGlhjgkVTsOw62OGyfjCkcOQBA0z9atvKNoC8Ku4u3keR3rlaMd5Tj5JU
         ZqDg==
X-Gm-Message-State: APjAAAWSU/h2ljidVVInHZzuATS7MZSIDgZnNJ3wBWz9fF8g+b4kYPXT
        1v5L3b0dTKmbpjrGs2C3JTI=
X-Google-Smtp-Source: APXvYqwsbem4TbYMQQreA2Pi/h0WlGAfaGKiQLSCp81sdU5fSB81pX1FGoqthPyYMX3DmCit7YbtBQ==
X-Received: by 2002:aa7:9218:: with SMTP id 24mr95742121pfo.145.1578086224950;
        Fri, 03 Jan 2020 13:17:04 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id z16sm69364196pff.125.2020.01.03.13.17.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 13:17:04 -0800 (PST)
Subject: [PATCH v16 8/9] mm: Add budget limit to how many pages can be
 reported per list per pass
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
Date:   Fri, 03 Jan 2020 13:17:04 -0800
Message-ID: <20200103211703.29237.95865.stgit@localhost.localdomain>
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

In order to keep ourselves from reporting pages that are just going to be
reused again in the case of heavy churn we can put a limit on how many
total pages we will process per pass. Doing this will allow the worker
thread to go into idle much more quickly so that we avoid competing with
other threads that might be allocating or freeing pages.

The logic added here will limit the worker thread to no more than one
sixteenth of the total free pages in a given area per list. Once that limit
is reached it will update the state so that at the end of the pass we will
reschedule the worker to try again in 2 seconds when the memory churn has
hopefully settled down.

Again this optimization doesn't show much of a benefit in the standard case
as the memory churn is minmal. However with page allocator shuffling
enabled the gain is quite noticeable. Below are the results with a THP
enabled version of the will-it-scale page_fault1 test showing the
improvement in iterations for 16 processes or threads.

Without:
tasks   processes       processes_idle  threads         threads_idle
16      8283274.75      0.17            5594261.00      38.15

With:
tasks   processes       processes_idle  threads         threads_idle
16      8767010.50      0.21            5791312.75      36.98

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/page_reporting.h |    1 +
 mm/page_reporting.c            |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index 32355486f572..3b99e0ec24f2 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -5,6 +5,7 @@
 #include <linux/mmzone.h>
 #include <linux/scatterlist.h>
 
+/* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
 
 struct page_reporting_dev_info {
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 6885e74c2367..3bbd471cfc81 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -114,6 +114,7 @@ void __page_reporting_notify(void)
 	struct list_head *list = &area->free_list[mt];
 	unsigned int page_len = PAGE_SIZE << order;
 	struct page *page, *next;
+	long budget;
 	int err = 0;
 
 	/*
@@ -125,12 +126,39 @@ void __page_reporting_notify(void)
 
 	spin_lock_irq(&zone->lock);
 
+	/*
+	 * Limit how many calls we will be making to the page reporting
+	 * device for this list. By doing this we avoid processing any
+	 * given list for too long.
+	 *
+	 * The current value used allows us enough calls to process over a
+	 * sixteenth of the current list plus one additional call to handle
+	 * any pages that may have already been present from the previous
+	 * list processed. This should result in us reporting all pages on
+	 * an idle system in about 30 seconds.
+	 *
+	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
+	 * should always be a power of 2.
+	 */
+	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
+
 	/* loop through free list adding unreported pages to sg list */
 	list_for_each_entry_safe(page, next, list, lru) {
 		/* We are going to skip over the reported pages. */
 		if (PageReported(page))
 			continue;
 
+		/*
+		 * If we fully consumed our budget then update our
+		 * state to indicate that we are requesting additional
+		 * processing and exit this list.
+		 */
+		if (budget < 0) {
+			atomic_set(&prdev->state, PAGE_REPORTING_REQUESTED);
+			next = page;
+			break;
+		}
+
 		/* Attempt to pull page from list and place in scatterlist */
 		if (*offset) {
 			if (!__isolate_free_page(page, order)) {
@@ -146,7 +174,7 @@ void __page_reporting_notify(void)
 		}
 
 		/*
-		 * Make the first non-processed page in the free list
+		 * Make the first non-reported page in the free list
 		 * the new head of the free list before we release the
 		 * zone lock.
 		 */
@@ -162,6 +190,9 @@ void __page_reporting_notify(void)
 		/* reset offset since the full list was reported */
 		*offset = PAGE_REPORTING_CAPACITY;
 
+		/* update budget to reflect call to report function */
+		budget--;
+
 		/* reacquire zone lock and resume processing */
 		spin_lock_irq(&zone->lock);
 

