Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1DF7A24B1
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 19:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbjIOR3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 13:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbjIOR2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 13:28:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C581BF2;
        Fri, 15 Sep 2023 10:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qrq8p9yZWY/o7Jujh/Hgy9LgFQ+ehicAWEAzhOimblQ=; b=V4WSU6j3lknAkAKGSi7BS51kBd
        IgDYexp3G9Sq2vB35PEykRe/Z/9hxh8qCDis88/OYvmu7uoMZn/ulox76Gs9v2ZWB2ixlnT8VLQb3
        y26PNvyHjGMuwF97rHf3T+2P1Q+6dECmvQXVcyaqcy+mzLy03+ofmwaw8HQ1kGHw8QD0OjbkOJx9u
        QUn8qCSC7i2L6jkjmqSNtcm3cr1i/1MsR4CeKvU8LOKw61CZETdN4h6TsBnLBabChT0fI8mk5zDD3
        nvM46wOeLE7gm99sQSfLNETpjZRyzFVtbroiPTgbbpecgUJB42e1IhhNbBiWzUyPgdmMmRaLCnlJd
        CtTrBobw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qhCcI-00B2xp-DA; Fri, 15 Sep 2023 17:28:30 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/3] Use arch_make_folio_accessible() everywhere
Date:   Fri, 15 Sep 2023 18:28:25 +0100
Message-Id: <20230915172829.2632994-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
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

We introduced arch_make_folio_accessible() a couple of years
ago, and it's in use in the page writeback path.  GUP still uses
arch_make_page_accessible(), which means that we can succeed in making
a single page of a folio accessible, then fail to make the rest of the
folio accessible when it comes time to do writeback and it's too late
to do anything about it.  I'm not sure how much of a real problem this is.

Switching everything around to arch_make_folio_accessible() also lets
us switch the page flag to be per-folio instead of per-page, which is
a good step towards dynamically allocated folios.

Build-tested only.

Matthew Wilcox (Oracle) (3):
  mm: Use arch_make_folio_accessible() in gup_pte_range()
  mm: Convert follow_page_pte() to use a folio
  s390: Convert arch_make_page_accessible() to
    arch_make_folio_accessible()

 arch/s390/include/asm/page.h |  5 ++--
 arch/s390/kernel/uv.c        | 46 +++++++++++++++++++++++-------------
 arch/s390/mm/fault.c         | 15 ++++++------
 include/linux/mm.h           | 20 ++--------------
 mm/gup.c                     | 22 +++++++++--------
 5 files changed, 54 insertions(+), 54 deletions(-)

-- 
2.40.1

