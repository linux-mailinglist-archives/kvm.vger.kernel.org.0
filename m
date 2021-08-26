Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233D43F8966
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhHZNwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbhHZNwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:52:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818EAC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=20dC0MIl5V0+AlR4PNwSgV2vrmvVudgZDf3FOUU0Hpg=; b=h1ajGa+0Mn0OIVtGqi+Q+uwZr4
        CPwko4pn6j/rb5qnOoBH9tFnird4fIpEbW2rNkrN+VL805h1/jTnI6NQvRkcgw7gIAlvNKKifNnuB
        L8238/3LRExm7bRbCHyzsgUTtzVLyQIL9/WKhgqcpSJvrzZXERbyoWD6GLl8VC9mgiKmB5PY20shM
        KBSLAPARtPWz9lvTt9c4tNHDZ/kq+yreahnR/PDENy+V3Izs3ogc/c2EdZ994b6lc0Ays5IU4fC8x
        6vqquyRO3rIjxrCLydu/xQ+eVF7Txsz1ZnH8ZJpx7Y+aMQFnqu0Syv8BDDOa7hXwiBN2QeRFQ9xaf
        7EJiXgHg==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFlB-00DLpF-Ta; Thu, 26 Aug 2021 13:50:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 14/14] vfio/iommu_type1: remove IS_IOMMU_CAP_DOMAIN_IN_CONTAINER
Date:   Thu, 26 Aug 2021 15:34:24 +0200
Message-Id: <20210826133424.3362-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IS_IOMMU_CAP_DOMAIN_IN_CONTAINER just obsfucated the checks being
performed, so open code it in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 1ef98d4e2abecf..94441e6c0983be 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -139,9 +139,6 @@ struct vfio_regions {
 	size_t len;
 };
 
-#define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
-					(!list_empty(&iommu->domain_list))
-
 #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
 
 /*
@@ -879,7 +876,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	 * already pinned and accounted. Accounting should be done if there is no
 	 * iommu capable domain in the container.
 	 */
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = list_empty(&iommu->domain_list);
 
 	for (i = 0; i < npage; i++) {
 		struct vfio_pfn *vpfn;
@@ -968,7 +965,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = list_empty(&iommu->domain_list);
 	for (i = 0; i < npage; i++) {
 		struct vfio_dma *dma;
 		dma_addr_t iova;
@@ -1089,7 +1086,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	if (!dma->size)
 		return 0;
 
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (list_empty(&iommu->domain_list))
 		return 0;
 
 	/*
@@ -1666,7 +1663,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	vfio_link_dma(iommu, dma);
 
 	/* Don't pin and map if container doesn't contain IOMMU capable domain*/
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (list_empty(&iommu->domain_list))
 		dma->size = size;
 	else
 		ret = vfio_pin_map_dma(iommu, dma, size);
@@ -2472,7 +2469,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		kfree(group);
 
 		if (list_empty(&iommu->emulated_iommu_groups) &&
-		    !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		    list_empty(&iommu->domain_list)) {
 			WARN_ON(iommu->notifier.head);
 			vfio_iommu_unmap_unpin_all(iommu);
 		}
-- 
2.30.2

