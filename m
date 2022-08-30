Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524D45A59B3
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 05:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiH3DFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 23:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH3DFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 23:05:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4636723BDE
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 20:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661828742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=5ztsqq+Cpr3ONWup9F41dO8g+K5tgkK5hLut9gytdfk=;
        b=iN0605apUPlzQB7sp0pWuz5FarjBdeQjFk/bfuWLofAMHqwYXzqzdEN3QAt7xXKsnZC6Yw
        yz2v9Z9h9M0nACk/BurzcEL4bCfzl5F3S94YM9s0uM4uiuZGwNbMSAj+AwpD6va50Dw0fn
        P3tgPSSsUtqJawFkaXtQ7JQanrsMCu4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-SrmQDBtyPiCxTIUf-D_lIw-1; Mon, 29 Aug 2022 23:05:41 -0400
X-MC-Unique: SrmQDBtyPiCxTIUf-D_lIw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C302329AA2E9;
        Tue, 30 Aug 2022 03:05:40 +0000 (UTC)
Received: from [172.30.41.16] (unknown [10.22.18.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6675BC15BB3;
        Tue, 30 Aug 2022 03:05:40 +0000 (UTC)
Subject: [PATCH] vfio/type1: Unpin zero pages
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@redhat.com, lpivarc@redhat.com
Date:   Mon, 29 Aug 2022 21:05:40 -0600
Message-ID: <166182871735.3518559.8884121293045337358.stgit@omen>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's currently a reference count leak on the zero page.  We increment
the reference via pin_user_pages_remote(), but the page is later handled
as an invalid/reserved page, therefore it's not accounted against the
user and not unpinned by our put_pfn().

Introducing special zero page handling in put_pfn() would resolve the
leak, but without accounting of the zero page, a single user could
still create enough mappings to generate a reference count overflow.

The zero page is always resident, so for our purposes there's no reason
to keep it pinned.  Therefore, add a loop to walk pages returned from
pin_user_pages_remote() and unpin any zero pages.

Cc: David Hildenbrand <david@redhat.com>
Cc: stable@vger.kernel.org
Reported-by: Luboslav Pivarc <lpivarc@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index db516c90a977..8706482665d1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -558,6 +558,18 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
 				    pages, NULL, NULL);
 	if (ret > 0) {
+		int i;
+
+		/*
+		 * The zero page is always resident, we don't need to pin it
+		 * and it falls into our invalid/reserved test so we don't
+		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
+		 */
+		for (i = 0 ; i < ret; i++) {
+			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
+				unpin_user_page(pages[i]);
+		}
+
 		*pfn = page_to_pfn(pages[0]);
 		goto done;
 	}


