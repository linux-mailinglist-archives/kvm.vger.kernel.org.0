Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97117A24B4
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 19:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbjIOR3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbjIOR2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 13:28:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE74F2120;
        Fri, 15 Sep 2023 10:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ljKmIcCKst9DHe3IfbavuoPBudCpT3+oRR2H1OkUvA4=; b=BRBrYogwJLaEabmxwgaUjlbSMe
        CV4/6qA1wg4YbLawsYY/VjTxp1stCVMiCAgB+7R6R1Hr8iIZrKnUsgRIJgSLZCwquuBYaop7JUycL
        nnI55Gtyn7HE1B7S/aAmNZPp6xWVHaWcZYCRAavD/29BcSWVAVHStrrm4JEluywCFhysOG5RdTR3F
        CEps4GThOwQsircqgTvFoEEnrxZ9BS3hNq5jpnpRVg5oLKNbRO3RUNyIds+CQu5wawdN1MyJXwu/0
        LrkZJ8R8iDRKcZkHEmRa8QaPMfd5AQxzdnBpcfJHjVJqRLGVf+RYyy8dXMgXHqMoxUy8OHEEJlmrN
        fvln2Fgg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qhCcI-00B2xt-Jb; Fri, 15 Sep 2023 17:28:30 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/3] mm: Convert follow_page_pte() to use a folio
Date:   Fri, 15 Sep 2023 18:28:27 +0100
Message-Id: <20230915172829.2632994-3-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230915172829.2632994-1-willy@infradead.org>
References: <20230915172829.2632994-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove uses of PageAnon(), unpin_user_page(), PageDirty(),
set_page_dirty() and mark_page_accessed(), all of which have a hidden
call to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/gup.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ab8a0ebc728e..ff1eaaba5720 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -582,6 +582,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
+	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
 	int ret;
@@ -644,7 +645,8 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		goto out;
 	}
 
-	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+	folio = page_folio(page);
+	VM_BUG_ON_PAGE((flags & FOLL_PIN) && folio_test_anon(folio) &&
 		       !PageAnonExclusive(page), page);
 
 	/* try_grab_page() does nothing unless FOLL_GET or FOLL_PIN is set. */
@@ -655,28 +657,28 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 
 	/*
-	 * We need to make the page accessible if and only if we are going
+	 * We need to make the folio accessible if and only if we are going
 	 * to access its content (the FOLL_PIN case).  Please see
 	 * Documentation/core-api/pin_user_pages.rst for details.
 	 */
 	if (flags & FOLL_PIN) {
-		ret = arch_make_page_accessible(page);
+		ret = arch_make_folio_accessible(folio);
 		if (ret) {
-			unpin_user_page(page);
+			gup_put_folio(folio, 1, FOLL_PIN);
 			page = ERR_PTR(ret);
 			goto out;
 		}
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !PageDirty(page))
-			set_page_dirty(page);
+		    !pte_dirty(pte) && !folio_test_dirty(folio))
+			folio_mark_dirty(folio);
 		/*
 		 * pte_mkyoung() would be more correct here, but atomic care
 		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * mark_page_accessed().
+		 * folio_mark_accessed().
 		 */
-		mark_page_accessed(page);
+		folio_mark_accessed(folio);
 	}
 out:
 	pte_unmap_unlock(ptep, ptl);
-- 
2.40.1

