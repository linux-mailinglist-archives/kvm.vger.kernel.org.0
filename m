Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0E4145B12
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 18:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgAVRoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 12:44:02 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:42014 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 12:44:01 -0500
Received: by mail-pg1-f172.google.com with SMTP id s64so3883767pgb.9;
        Wed, 22 Jan 2020 09:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=yW1O0jjXB9z8bWi4RkuBpy5DqO+Vy5mEgFaRwUh2ELE=;
        b=PXQ9nF6eD9JqXqGbBcHCAnoNaPt6TbCdFAlSKlRh3x/clFanOB7zXHzp/j/btaJeQe
         sAdDm0NRgY2EXlZYVSmb4vDeib4pDcZ5cuXq4PNBrrbvaPxAac/m1TWqdx+JJcJYtLZu
         oKVRDrOH6f1kb3Gzp6ZQxwD4FYFshRc82FwTHwQNY5w4TbuHBrK+0MnMkkVY15xhdK67
         bXmQe0Sj2+r9z+Vb0aQrbIk+XV8VvgMXUnwIM3/3hS0aOAZesFR8y54xkDUZ96H8zFMH
         PjI0Ubd8/EOVV3jQmqRBehTB2bgxZIXhHLIjQfdYK9313sUtY4VY8gganAVhavYMnhY6
         EUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yW1O0jjXB9z8bWi4RkuBpy5DqO+Vy5mEgFaRwUh2ELE=;
        b=Pioj+5utZ8v+Bkybt2kiQHGNzO3sO8SK+HQoe0JuRQFNZU//F8u9IBC+FE4aLsptt/
         VvftvOsmz7gUaRv6YSP7Yq2q3LSBVj8y6eErfUhDjOw4cWVJG+58WTbtSuG2bTFoQ2Le
         ZiO+O/ebkRb6ZBKLG6aeJkUkV9X9NH4/3x9UR/BobAss80S6aHQt3RiwCe3r8HE4oLK/
         tUtcmrOddyexK4Mdi0HykoE2iMPW2C8xziVlDjslwbzy9YiCr+P76P0xFwpnTU33VQLx
         Nh8IRors9vQANzcjAWC+7BYItNpLgQ8ocFGL0eQC2X1re1K76y5UhzpYRwcPTO5aHb9/
         16Dw==
X-Gm-Message-State: APjAAAUbOV5NXZsDPjbmH25A67tmTvp1um+t83SsPNpJzSbBbDTn7TAj
        b++u3LcOp0Vd82ESLcHhDdA=
X-Google-Smtp-Source: APXvYqz0A9CG8xZ7h+97UwPy5e048YsSkZo8foaSUuWR8QkXhlxpnBzoYJBxR+QAKI+++O7kQfKYsw==
X-Received: by 2002:a63:c748:: with SMTP id v8mr11843658pgg.451.1579715040621;
        Wed, 22 Jan 2020 09:44:00 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id a10sm4093429pjq.8.2020.01.22.09.43.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 09:44:00 -0800 (PST)
Subject: [PATCH v16.1 8/9] mm/page_reporting: Add budget limit on how many
 pages can be reported per pass
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
Date:   Wed, 22 Jan 2020 09:43:59 -0800
Message-ID: <20200122174359.6142.21993.stgit@localhost.localdomain>
In-Reply-To: <20200122173040.6142.39116.stgit@localhost.localdomain>
References: <20200122173040.6142.39116.stgit@localhost.localdomain>
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
 

