Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30D1212FE3D
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgACVRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 16:17:01 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34218 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbgACVQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 16:16:59 -0500
Received: by mail-pg1-f194.google.com with SMTP id r11so23956581pgf.1;
        Fri, 03 Jan 2020 13:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=q6OeJXPwWEnUOz8Lo8TsCrdbcxtEJkAXopv2X8QuM5w=;
        b=B6iIFQrM8v3I3ajt/BcBzw2sj/0ZMyP4nYVWUfntvKkPYDY0R9APeMJ1WpZRZGkN6N
         d+IIO3MQwmbBe2pjirF4XfYePTo0LQeSH3a3YHzE//DsxP+V0ySI0l+mcua2uFJxoTad
         El7TOmniUKXJDw9fBgQ4YbfFAX3cigl3dVx13vGcxo6uhVA3E7Xk4ff2+VsKvCM7j5Rp
         Y0bh0qkAowgldLhmOpzQjdfWY1UeqnVp201hqLwnJWbVv5TSmHVHHwKhVcCCXHR18tbQ
         sUTvjofReqQ+o6jfRki1xNMw1dL5XmKL7JWMViVGNibXaZ1w9L/ARxvx2ObyqP8Efdux
         JyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=q6OeJXPwWEnUOz8Lo8TsCrdbcxtEJkAXopv2X8QuM5w=;
        b=oTHy28WHwtw1lv/EI+DLu3G3gTkYP7BerC9GdLO0ayIy3OP7WzmMGt6r/ptqRZ/Ppx
         P83q7lXemWgpvrB+EDj/saQ13AYYepOS5GMMMJv6sQq6Bx/2trr6kJIZeA4masIPobkn
         JPfdQ8BF1JHFHjKk/sVBsrvtu4NsL4XT1FNcQIya0EjVSsQdEBOWaba7sqyQ5VnumY1j
         L0nUJN/Qenxs2sOwKkLZ9MczCuSduNg+Y4CEy7WyrLBetDFC3D3x+V0hJL5XfOMMSGK2
         QdoxdNhhUJavA+CFEvvMhN9kJ0LlJKyOQQSXsf2FbWMWQ/TyjFM1iVDzAgFFUzoQw3Ej
         1vbQ==
X-Gm-Message-State: APjAAAUPjztejAXtewWykh83I+PCOlZ4tHgiuzg+sI9TvsRFnYaapP/z
        hbr6lX1WuijYnQDeRyZArRY=
X-Google-Smtp-Source: APXvYqzgh5Xrxh62OI8wBacWpgPuHGMSycLz0VPkIcffysY9nks3kpviBjQt/XeAYm7ykj3kfI4RDA==
X-Received: by 2002:a62:2cc1:: with SMTP id s184mr97912791pfs.111.1578086218911;
        Fri, 03 Jan 2020 13:16:58 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id a28sm68177056pfh.119.2020.01.03.13.16.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 13:16:58 -0800 (PST)
Subject: [PATCH v16 7/9] mm: Rotate free list so reported pages are moved to
 the tail of the list
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
Date:   Fri, 03 Jan 2020 13:16:57 -0800
Message-ID: <20200103211657.29237.50194.stgit@localhost.localdomain>
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

