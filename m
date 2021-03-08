Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA7E33199F
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCHVtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:49:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232001AbhCHVtG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:49:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cbA4Upz6JfYHZisf65UoZM/yG3LCNqxzyODN3VMABkE=;
        b=g+8zcvB4h+jZTj+XSj86KwbRNG7gPgTAo5vyXyoVbqKBq1r3gjyCoEN593YCCZw6DJKfN4
        QK9gkZ7Nn8TKe6ggQOH67rJ0EdPpQIVq6+n30vMK2QFzJjtogPi1N6YQEWIaDYjZ9y1KCT
        Y7XQ+rBiv/meY39u5AUqwt6EMNmTQqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-ZzJdFQ8lPm-DidCu4_rQ1A-1; Mon, 08 Mar 2021 16:49:02 -0500
X-MC-Unique: ZzJdFQ8lPm-DidCu4_rQ1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65A0380432E;
        Mon,  8 Mar 2021 21:49:01 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 566A11A86F;
        Mon,  8 Mar 2021 21:48:54 +0000 (UTC)
Subject: [PATCH v1 09/14] vfio/type1: Refactor pfn_list clearing
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:48:54 -0700
Message-ID: <161524013398.3480.17180657517567370372.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pull code out to a function for re-use.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   57 +++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 12d9905b429f..f7d35a114354 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -542,6 +542,39 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
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
 /*
  * Returns the positive number of pfns successfully obtained or a negative
  * error code.
@@ -1397,29 +1430,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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

