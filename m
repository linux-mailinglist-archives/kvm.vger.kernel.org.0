Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2DA321D7D
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 17:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhBVQyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 11:54:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231589AbhBVQxp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 11:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614012738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+ZP4IysQRoO0JLElNVXWcMQeJKBgRYaLkjQsWChkbU=;
        b=Hk2xOo3SPLlIIJB5iwVVyri0dvouSSfVdLRR23S7+L3262IqKtjYELFzNqPLCUCT5Lekpz
        75EsrKIaAcAqWOC/k7JtQe2c/UbHEm9a1SlHBITjI0mItsTk5tvGXYLwQjZhu9HyA7SaWA
        qEE7nq+pClFLPmEHIfrj0cXyGQQ7ykM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-NmjuhxvSMzKV0q7wYt_OLQ-1; Mon, 22 Feb 2021 11:52:16 -0500
X-MC-Unique: NmjuhxvSMzKV0q7wYt_OLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1ECAF80197A;
        Mon, 22 Feb 2021 16:52:15 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F153C5D9D0;
        Mon, 22 Feb 2021 16:52:07 +0000 (UTC)
Subject: [RFC PATCH 08/10] vfio/type1: Refactor pfn_list clearing
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 22 Feb 2021 09:52:07 -0700
Message-ID: <161401272758.16443.12511933342363753977.stgit@gimli.home>
In-Reply-To: <161401167013.16443.8389863523766611711.stgit@gimli.home>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
User-Agent: StGit/0.21-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pull code out to a function for re-use.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   57 +++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b3df383d7028..5099b3c9dce0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -484,6 +484,39 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
 	return ret;
 }
 
+/* Return 1 if iommu->lock dropped and notified, 0 if done */
+static int unmap_dma_pfn_list(struct vfio_iommu *iommu, struct vfio_dma *dma,
+			      struct vfio_dma **dma_last, int *retries)
+{
+	if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
+		struct vfio_iommu_type1_dma_unmap nb_unmap;
+
+		if (*dma_last == dma) {
+			BUG_ON(++(*retries) > 10);
+		} else {
+			*dma_last = dma;
+			*retries = 0;
+		}
+
+		nb_unmap.iova = dma->iova;
+		nb_unmap.size = dma->size;
+
+		/*
+		 * Notify anyone (mdev vendor drivers) to invalidate and
+		 * unmap iovas within the range we're about to unmap.
+		 * Vendor drivers MUST unpin pages in response to an
+		 * invalidation.
+		 */
+		mutex_unlock(&iommu->lock);
+		blocking_notifier_call_chain(&iommu->notifier,
+					     VFIO_IOMMU_NOTIFY_DMA_UNMAP,
+					     &nb_unmap);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 			 int prot, unsigned long *pfn)
 {
@@ -1307,29 +1340,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			continue;
 		}
 
-		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
-			struct vfio_iommu_type1_dma_unmap nb_unmap;
-
-			if (dma_last == dma) {
-				BUG_ON(++retries > 10);
-			} else {
-				dma_last = dma;
-				retries = 0;
-			}
-
-			nb_unmap.iova = dma->iova;
-			nb_unmap.size = dma->size;
-
-			/*
-			 * Notify anyone (mdev vendor drivers) to invalidate and
-			 * unmap iovas within the range we're about to unmap.
-			 * Vendor drivers MUST unpin pages in response to an
-			 * invalidation.
-			 */
-			mutex_unlock(&iommu->lock);
-			blocking_notifier_call_chain(&iommu->notifier,
-						    VFIO_IOMMU_NOTIFY_DMA_UNMAP,
-						    &nb_unmap);
+		if (unmap_dma_pfn_list(iommu, dma, &dma_last, &retries)) {
 			mutex_lock(&iommu->lock);
 			goto again;
 		}

