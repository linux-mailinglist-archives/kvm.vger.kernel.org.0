Return-Path: <kvm+bounces-10559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5551086D6E9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:36:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 576E9B22C85
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE02F38384;
	Thu, 29 Feb 2024 22:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0DTi40j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BA02031D
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 22:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709246165; cv=none; b=BFgXyB24CjIKSWHyMha7L+LXruir5jtHXLqPYAbg8FcK18QeaSbV5jFHVit4l+hqd7h3IRfwd4cs1eycoKt7cmZrzxg6zmhaR5GvCCi6pas0P23gizdRz27y96vcXhLNUQjtwE3Nf3G8w4cJktf3xibmcY5ackE2kqRFLioTsu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709246165; c=relaxed/simple;
	bh=XiYWXAEkJNz3jiTdHBo8zNvpfm3+VlZhC+wdvHcT8wc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qmCS6tLXA57usvtHrVck+QJeLtfi+IcVHteKwWgSvqyfTMmtuIxVdFumw/e6LaredCoHnRndAXvOTwRp4JfwzIdcGHNDmmtysJr3uApazoNgtdkuAkXdj4wO2Tx4PS8kJ6/GRr11kAR7aacm61ACAHupgntylFrKmBmAIEbGnho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0DTi40j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709246161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pPbMIoaOFEzd4CIJyR5bdcWJChrXb88CaqXQOthl8XY=;
	b=b0DTi40jb432G4jVZ7Sq7W6EG3xOwvZvnvvWg3ZYG7aLAlSR01hoIaeShLpoA5LlDpGXaB
	LcUk0qh1Dc9WlgioCbgmT89mnTlMfw2Etl0/H27Zl+n2fJcuqut/0+j5LenyqS+98ty2du
	3RwMLewnpNWAye0LLlK3T0lQjeWZeEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-TJBCsRcINEiRxl9Vde4ifw-1; Thu, 29 Feb 2024 17:35:59 -0500
X-MC-Unique: TJBCsRcINEiRxl9Vde4ifw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D296800074;
	Thu, 29 Feb 2024 22:35:57 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.8.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF4872166AE8;
	Thu, 29 Feb 2024 22:35:56 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "vfio/type1: Unpin zero pages"
Date: Thu, 29 Feb 2024 15:35:40 -0700
Message-ID: <20240229223544.257207-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

This reverts commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4.

This was a heinous workaround and it turns out it's been fixed in mm
twice since it was introduced.  Most recently, commit c8070b787519
("mm: Don't pin ZERO_PAGE in pin_user_pages()") would have prevented
running up the zeropage refcount, but even before that commit
84209e87c696 ("mm/gup: reliable R/O long-term pinning in COW mappings")
avoids the vfio use case from pinning the zeropage at all, instead
replacing it with exclusive anonymous pages.

Remove this now useless overhead.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b2854d7939ce..b5c15fe8f9fc 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -567,18 +567,6 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
 				    pages, NULL);
 	if (ret > 0) {
-		int i;
-
-		/*
-		 * The zero page is always resident, we don't need to pin it
-		 * and it falls into our invalid/reserved test so we don't
-		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
-		 */
-		for (i = 0 ; i < ret; i++) {
-			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
-				unpin_user_page(pages[i]);
-		}
-
 		*pfn = page_to_pfn(pages[0]);
 		goto done;
 	}
-- 
2.43.2


