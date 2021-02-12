Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B540931A4EB
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 20:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhBLTDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 14:03:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229832AbhBLTDV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 14:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613156514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7ooNXOow4Kc5cp7DA82+I6l6Eq7HpYL88e585qRTAoI=;
        b=NbW6EDLNIOfXrDnJ1cMAFxYOlDo7YOVBiuxrHnC6krNtC9MKlZOtGHLCkmZT7TgAMdInTH
        +SeJOJWABAVBZazDitZUoh9YN72AG/FK42JTTAwZhhNFfaF6Yi3ao1IJw427eQzLnuoUKf
        dzdFmpVV1Zc7RkPLy39k/HUXfbBfXDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-naFLspz-PfSloqjQBz4ZfQ-1; Fri, 12 Feb 2021 14:01:52 -0500
X-MC-Unique: naFLspz-PfSloqjQBz4ZfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E79449126D;
        Fri, 12 Feb 2021 19:01:50 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A00660BF1;
        Fri, 12 Feb 2021 19:01:50 +0000 (UTC)
Subject: [PATCH] vfio/type1: Use follow_pte()
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, jgg@nvidia.com,
        peterx@redhat.com
Date:   Fri, 12 Feb 2021 12:01:50 -0700
Message-ID: <161315649533.7249.11715726297751446001.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

follow_pfn() doesn't make sure that we're using the correct page
protections, get the pte with follow_pte() so that we can test
protections and get the pfn from the pte.

Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ec9fd95a138b..90715413c3d9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -463,9 +463,11 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 			    unsigned long vaddr, unsigned long *pfn,
 			    bool write_fault)
 {
+	pte_t *ptep;
+	spinlock_t *ptl;
 	int ret;
 
-	ret = follow_pfn(vma, vaddr, pfn);
+	ret = follow_pte(vma->vm_mm, vaddr, NULL, &ptep, NULL, &ptl);
 	if (ret) {
 		bool unlocked = false;
 
@@ -479,9 +481,17 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 		if (ret)
 			return ret;
 
-		ret = follow_pfn(vma, vaddr, pfn);
+		ret = follow_pte(vma->vm_mm, vaddr, NULL, &ptep, NULL, &ptl);
+		if (ret)
+			return ret;
 	}
 
+	if (write_fault && !pte_write(*ptep))
+		ret = -EFAULT;
+	else
+		*pfn = pte_pfn(*ptep);
+
+	pte_unmap_unlock(ptep, ptl);
 	return ret;
 }
 

