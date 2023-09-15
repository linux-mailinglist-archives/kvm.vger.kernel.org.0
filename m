Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A007A24B5
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 19:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbjIOR3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 13:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbjIOR2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 13:28:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62562105;
        Fri, 15 Sep 2023 10:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=2i/sXmSR7Ozo56DuBZMs0VNeeLRw22KLzNAbjpObZmM=; b=KELzHD3jhsEdbC0d5YQRPhCjCb
        VXnx6bRq+99LdZHQQA64VkBwEU6daG4JCKk8gA+OETsEyFUXnPD5mBRFgyTQd2djDc5LpjoOQFNug
        awAryetTdBr2gj6hS8M/Ad9FUcpBVzNZ4zoWL+ApESxKeOX88cQBlP44ZsxzHjfm2qUt8guLGTFMX
        yqHwEJJjW6qnTFr43xwhyHmLW73hZvZ43fr0JNeRn20U8zNfM3/sxxSfA6SQXqj8qIqSj53+bKFxY
        Cfk7UHweI7D5BusCRJi97CiZ6RAqsxnbpohzp522AsxMtrVMe9IXIrlpuuIsM40xtC18vSpZcbwvc
        EVNbgyEQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qhCcI-00B2xr-Ge; Fri, 15 Sep 2023 17:28:30 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/3] mm: Use arch_make_folio_accessible() in gup_pte_range()
Date:   Fri, 15 Sep 2023 18:28:26 +0100
Message-Id: <20230915172829.2632994-2-willy@infradead.org>
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

This function already uses folios, so convert the
arch_make_page_accessible() call to arch_make_folio_accessible().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/gup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 2f8a2d89fde1..ab8a0ebc728e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2622,13 +2622,13 @@ static int gup_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 		}
 
 		/*
-		 * We need to make the page accessible if and only if we are
+		 * We need to make the folio accessible if and only if we are
 		 * going to access its content (the FOLL_PIN case).  Please
 		 * see Documentation/core-api/pin_user_pages.rst for
 		 * details.
 		 */
 		if (flags & FOLL_PIN) {
-			ret = arch_make_page_accessible(page);
+			ret = arch_make_folio_accessible(folio);
 			if (ret) {
 				gup_put_folio(folio, 1, flags);
 				goto pte_unmap;
-- 
2.40.1

