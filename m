Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B6E408566
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhIMHdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbhIMHdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 03:33:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4D1C061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QPqcDnGKoItwTv6G4JTLad9nl/a1Crm1jF5v/ZzDz3Q=; b=vHgLJ8VlUW//qGFlpuj/6x5Lu7
        ZdH+aUCAz/P1uMZj7MCRJ+utul17cKsQDzlw0nvPHGrP87pmE535fiIq6+QLlebveu40bAiDtI65J
        axGniviC//HFA0rgY/PBagH8/OFRA865wt4am4D0+0/In4z53e7GWN1iQ0s7URhyI3Yaxe5FDBQ8K
        a58JQW4zuejf0F6wv9klOyaawIct5i9TGVd0ZiFDOYGN56IJ07bscshf4vd3A69UpNe5tRXdO74cV
        Poo5zUHsDAkh7duv2uGRSy+W4vYiSXvq2Nw4QJA730oc76bSiYYKo6GEApzG/GYTuQ9E2a6US2MI4
        jxnvOKUQ==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPgQI-00DGu5-DH; Mon, 13 Sep 2021 07:30:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 14/14] vfio/iommu_type1: remove IS_IOMMU_CAP_DOMAIN_IN_CONTAINER
Date:   Mon, 13 Sep 2021 09:16:06 +0200
Message-Id: <20210913071606.2966-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913071606.2966-1-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
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
index d2db62cb2aaa39..7ad56afb11750e 100644
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

