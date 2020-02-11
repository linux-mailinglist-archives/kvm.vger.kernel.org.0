Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85616159C83
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgBKWrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:47:16 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35912 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbgBKWrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:47:16 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so14621015wru.3;
        Tue, 11 Feb 2020 14:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=q6OeJXPwWEnUOz8Lo8TsCrdbcxtEJkAXopv2X8QuM5w=;
        b=gdqkBY5tGbiMNDJ4wqiCepJ8YXg/3EiJi0JOAI2tx4qlfJJlzhFoNdbuz/sNNNq3PG
         U+L7mlN0oUB4muF4Ai4keJpGp39n7UWVFwPR9BlHlyEi2bp0ksiGnU1tyLkwIN4OKfhF
         JqT5Na4647BS1x9rsipCv2TqUJGtNfMP3TugVRM2uxqFB/UK48tJMEB/tonKFZFhOj5/
         HzPRXPhMd/Y5dcKzbxzveT2Y87nhgn9QVjse7rlPTWPddpBk3O81Es39GAYCXFxkN2tS
         lS3ppIhVptxaXYTP7Qp91OJ3PVwD5fNcZFkmEUexSbxOFbzTp0SKWWgCGqRVpUmqwBxB
         N2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=q6OeJXPwWEnUOz8Lo8TsCrdbcxtEJkAXopv2X8QuM5w=;
        b=uZXRLWKN3G4Tc/5DpI917jOOcci6q7o+vu6mX1RFyOSM/JB4XpCmRRzGsvEzU5791c
         CiF8JaWT+4nRYNYIKQITYGY6DnZWP60wFUcE/w+Npteo5xfX6dBc+aAG9/1r2/oh8gNl
         W4g3VjTuXG4Pj41QLIk6z0Kl1wVFasGqlp/7ov+vbzMhkxRHh+fJMR3Hn66sePFU8cFu
         yebWkswTHgJfVRHx0biKY0BdfAAkojxC2PbnEOAjp1xdf0AoxBqGzXDlGeb63Wggf4UY
         zY03E499u/XA2p98DEMv5ktm4nN5gX+8LJ9Q3qfad54uNEs6dqPcsFRXzyKxFXTBm6Iq
         BUyg==
X-Gm-Message-State: APjAAAUsYrheXQioFGYlqSZpiYKKaqgyD5UR8A1Nz+fWwrfNsSv37jgS
        8h8nqiCIfwGxG0xq307d0Xc=
X-Google-Smtp-Source: APXvYqxlgc69mpm5mOtrTz4wpHiodKuG0hVB/KKC8SEPcsJZBDWdjBxrGa3+eksMaEXqt5GHMRf/vQ==
X-Received: by 2002:a5d:5345:: with SMTP id t5mr11932990wrv.0.1581461234292;
        Tue, 11 Feb 2020 14:47:14 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 18sm5760932wmf.1.2020.02.11.14.47.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:47:13 -0800 (PST)
Subject: [PATCH v17 7/9] mm/page_reporting: Rotate reported pages to the
 tail of the list
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
Date:   Tue, 11 Feb 2020 14:47:08 -0800
Message-ID: <20200211224708.29318.16862.stgit@localhost.localdomain>
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

Rather than walking over the same pages again and again to get to the pages
that have yet to be reported we can save ourselves a significant amount of
time by simply rotating the list so that when we have a full list of
reported pages the head of the list is pointing to the next non-reported
page. Doing this should save us some significant time when processing each
free list.

This doesn't gain us much in the standard case as all of the non-reported
pages should be near the top of the list already. However in the case of
page shuffling this results in a noticeable improvement. Below are the
will-it-scale page_fault1 w/ THP numbers for 16 tasks with and without
this patch.

Without:
tasks   processes       processes_idle  threads         threads_idle
16      8093776.25      0.17            5393242.00      38.20

With:
tasks   processes       processes_idle  threads         threads_idle
16      8283274.75      0.17            5594261.00      38.15

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 mm/page_reporting.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 1047c6872d4f..6885e74c2367 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -131,17 +131,27 @@ void __page_reporting_notify(void)
 		if (PageReported(page))
 			continue;
 
-		/* Attempt to pull page from list */
-		if (!__isolate_free_page(page, order))
-			break;
+		/* Attempt to pull page from list and place in scatterlist */
+		if (*offset) {
+			if (!__isolate_free_page(page, order)) {
+				next = page;
+				break;
+			}
 
-		/* Add page to scatter list */
-		--(*offset);
-		sg_set_page(&sgl[*offset], page, page_len, 0);
+			/* Add page to scatter list */
+			--(*offset);
+			sg_set_page(&sgl[*offset], page, page_len, 0);
 
-		/* If scatterlist isn't full grab more pages */
-		if (*offset)
 			continue;
+		}
+
+		/*
+		 * Make the first non-processed page in the free list
+		 * the new head of the free list before we release the
+		 * zone lock.
+		 */
+		if (&page->lru != list && !list_is_first(&page->lru, list))
+			list_rotate_to_front(&page->lru, list);
 
 		/* release lock before waiting on report processing */
 		spin_unlock_irq(&zone->lock);
@@ -169,6 +179,10 @@ void __page_reporting_notify(void)
 			break;
 	}
 
+	/* Rotate any leftover pages to the head of the freelist */
+	if (&next->lru != list && !list_is_first(&next->lru, list))
+		list_rotate_to_front(&next->lru, list);
+
 	spin_unlock_irq(&zone->lock);
 
 	return err;

