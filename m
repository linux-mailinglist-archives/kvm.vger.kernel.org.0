Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9218B159C87
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgBKWr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:47:28 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38943 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727697AbgBKWr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:47:27 -0500
Received: by mail-wr1-f49.google.com with SMTP id y11so14613746wrt.6;
        Tue, 11 Feb 2020 14:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yW1O0jjXB9z8bWi4RkuBpy5DqO+Vy5mEgFaRwUh2ELE=;
        b=k/ZZ+lfpzEGfg+UQhvPpShfpEaurARkpcqAqNcLNcvwHtPzAnGLuMxKYr3XGyL76qC
         q5ww+uyhV3ub/LeCdlUbXkUqx1Ur4neRgdMLm8sl9oVy5N4gZLpAtBQK4IYIMaVQxTZ4
         qnpX1fpZoxjv7lDwWEA4pO8dewQBCze7tDs0eTyaJUl8SMQ3zEVm9zCrPDBkUa+W/7wX
         A82kNhRKc4rqYF4wi1on/CZPacT42Xuzm/ZPH7DN+Q+b3+2E1ySpNljpXXqp5Rmqd/7H
         cfJ5KY5vTtjk8owwjzSjyA4Wjt6VuCRVdadJl+602Lj8m9L6QtpqFfIj7MgOE4wvfg6Q
         De2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yW1O0jjXB9z8bWi4RkuBpy5DqO+Vy5mEgFaRwUh2ELE=;
        b=UysH9Z8rXpO6fVrIMFN6DFkKrH2LCeDV7FLbQRdDwZDQUQcGACiZHwx21U9xb+oo0I
         RiLIP5dRcaf0cy5lpge/HIgiB5ZIv1J8QmtAKEnpOVN2MmV68TcWfIi5CjrH8lz//09m
         UF9bp0BEqkHi7vGMAUta/Q+cb96k821Jzje7yLsa8jIye5cAp/24NurPrgqU5aTv3RLA
         9+KuOK077I0ihKheAwtMs+c1OCXV5HsCSXP1pv13z9jJ92DSUpX42Qz+CxStb3flMjPT
         4ZEcGXDzhriJCpYuYirF6y8SdlqvL71CpoFY/QlB7PijVR3qF5z6wZCNxTPI1hYlcJed
         R6Tg==
X-Gm-Message-State: APjAAAUdXCiLAUvqXon8boH9UrvFQE/SCTPCHnwE+dCa+CKt5c5tVRVa
        r/eLupWHsz3rt9AxCapgeDY=
X-Google-Smtp-Source: APXvYqyBICHCkeHDpm6RD3uyh8bdwL0rVnBjkmhC3o2O8S+6ELPC2u1XcjZqBe1aU4GpnrQ+8IDiAw==
X-Received: by 2002:adf:fe83:: with SMTP id l3mr11515445wrr.41.1581461245256;
        Tue, 11 Feb 2020 14:47:25 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id r6sm7225892wrq.92.2020.02.11.14.47.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:47:24 -0800 (PST)
Subject: [PATCH v17 8/9] mm/page_reporting: Add budget limit on how many
 pages can be reported per pass
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, david@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, vbabka@suse.cz,
        osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:47:19 -0800
Message-ID: <20200211224719.29318.72113.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
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
 

