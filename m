Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9844D3F7AD9
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhHYQnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhHYQng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:43:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1987EC061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jcXEEAFKxrZrXb0/RbmLi60iPd7jE/iw4DHlF1zixCs=; b=qQ/g9/YyKDllOfhBrDUfhnlZbB
        eQOxNrk9+CCQ/iqhtFEyWto7DGmWKbwf+DH2e72zfh89AuD5XO4n3RuYNb87/mubMu7pgGL2hQIvw
        0lt3a1fHtvHguDZrlD7IyQUEvQceVZAzSF7DJByxnVzhXU84tllsDilrD0UYUXYRB7tc0drsaMHqD
        1atXIEVXpyxCW+X53SYB8RAhHMjtI9rsdItcp6EgCaqIAqEDIwiV5/pEoEElBflhInvSDna7dO0cB
        E4FYo3KInQj6Xr/fSPHqcTBcGRoWn8laZMiZuF5Jux5JgwlvRn6OCGmBsEyx/yFr4tVzIL7QFQrBD
        Ut8ca90w==;
Received: from [2001:4bb8:193:fd10:a3f9:5689:21a4:711f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIvxL-00CUF7-4d; Wed, 25 Aug 2021 16:41:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 14/14] vfio/iommu_type1: remove IS_IOMMU_CAP_DOMAIN_IN_CONTAINER
Date:   Wed, 25 Aug 2021 18:19:15 +0200
Message-Id: <20210825161916.50393-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825161916.50393-1-hch@lst.de>
References: <20210825161916.50393-1-hch@lst.de>
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
---
 drivers/vfio/vfio_iommu_type1.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 871cd2867999cb..7ecf5ca01764a5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -140,9 +140,6 @@ struct vfio_regions {
 	size_t len;
 };
 
-#define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
-					(!list_empty(&iommu->domain_list))
-
 #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
 
 /*
@@ -880,7 +877,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	 * already pinned and accounted. Accounting should be done if there is no
 	 * iommu capable domain in the container.
 	 */
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = list_empty(&iommu->domain_list);
 
 	for (i = 0; i < npage; i++) {
 		struct vfio_pfn *vpfn;
@@ -969,7 +966,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = list_empty(&iommu->domain_list);
 	for (i = 0; i < npage; i++) {
 		struct vfio_dma *dma;
 		dma_addr_t iova;
@@ -1090,7 +1087,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	if (!dma->size)
 		return 0;
 
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (list_empty(&iommu->domain_list))
 		return 0;
 
 	/*
@@ -1667,7 +1664,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	vfio_link_dma(iommu, dma);
 
 	/* Don't pin and map if container doesn't contain IOMMU capable domain*/
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (list_empty(&iommu->domain_list))
 		dma->size = size;
 	else
 		ret = vfio_pin_map_dma(iommu, dma, size);
@@ -2473,7 +2470,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		kfree(group);
 
 		if (list_empty(&iommu->emulated_iommu_groups) &&
-		    !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		    list_empty(&iommu->domain_list)) {
 			WARN_ON(iommu->notifier.head);
 			vfio_iommu_unmap_unpin_all(iommu);
 		}
-- 
2.30.2

