Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69212FBEBD
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392594AbhASSSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:18:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41670 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392405AbhASSQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAJ6I064458;
        Tue, 19 Jan 2021 18:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=zwY2hxguzharX5Ghh9ONIA4dbr8KHa573VIjQjRBs4A=;
 b=EVaKj8UrEgOIGoxNCqKYLFZz3BDp6OFwMcigOLjV8jCQkkVV28NKD5ewgJxZtEMUCg+W
 x/LlVVcQclsR8yR/IBFk3tbjTKyfHlkBHTp6xyrZUSld0iPYevsImfTVUK0Ka9mQr+Bp
 CRv9BxzfQTN6k2EChzQFTaXg0JfWecVh/97XkDGrODc2bNgmL/imNeq0gHwoY2/WX+lV
 hHAK9UL81hMMkw0gMLoYRXX75GnE1ySoOnkRwItpGKejY530NWCVsxisgPNNOwlykvf6
 shNm0IITnD15YKxqkY/rR73vbBtgt2XxAdWlfSPc1cVtdF3fpBCVf+F4uO9jAWxUgV2I zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 363r3ktcpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JI9jK2126660;
        Tue, 19 Jan 2021 18:16:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3661er45b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10JIG0Wg027514;
        Tue, 19 Jan 2021 18:16:00 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:16:00 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 3/9] vfio/type1: unmap cleanup
Date:   Tue, 19 Jan 2021 09:48:23 -0800
Message-Id: <1611078509-181959-4-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor changes in vfio_dma_do_unmap to improve readability, which also
simplify the subsequent unmap-all patch.  No functional change.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a2c2b96..c687174 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1096,34 +1096,28 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 {
 	struct vfio_dma *dma, *dma_last = NULL;
 	size_t unmapped = 0, pgsize;
-	int ret = 0, retries = 0;
+	int ret = -EINVAL, retries = 0;
 	unsigned long pgshift;
+	dma_addr_t iova = unmap->iova;
+	unsigned long size = unmap->size;
 
 	mutex_lock(&iommu->lock);
 
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
-	if (unmap->iova & (pgsize - 1)) {
-		ret = -EINVAL;
+	if (iova & (pgsize - 1))
 		goto unlock;
-	}
 
-	if (!unmap->size || unmap->size & (pgsize - 1)) {
-		ret = -EINVAL;
+	if (!size || size & (pgsize - 1))
 		goto unlock;
-	}
 
-	if (unmap->iova + unmap->size - 1 < unmap->iova ||
-	    unmap->size > SIZE_MAX) {
-		ret = -EINVAL;
+	if (iova + size - 1 < iova || size > SIZE_MAX)
 		goto unlock;
-	}
 
 	/* When dirty tracking is enabled, allow only min supported pgsize */
 	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
 	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
-		ret = -EINVAL;
 		goto unlock;
 	}
 
@@ -1161,20 +1155,18 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	 * mappings within the range.
 	 */
 	if (iommu->v2) {
-		dma = vfio_find_dma(iommu, unmap->iova, 1);
-		if (dma && dma->iova != unmap->iova) {
-			ret = -EINVAL;
+		dma = vfio_find_dma(iommu, iova, 1);
+		if (dma && dma->iova != iova)
 			goto unlock;
-		}
-		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
-		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
-			ret = -EINVAL;
+
+		dma = vfio_find_dma(iommu, iova + size - 1, 0);
+		if (dma && dma->iova + dma->size != iova + size)
 			goto unlock;
-		}
 	}
 
-	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
-		if (!iommu->v2 && unmap->iova > dma->iova)
+	ret = 0;
+	while ((dma = vfio_find_dma(iommu, iova, size))) {
+		if (!iommu->v2 && iova > dma->iova)
 			break;
 		/*
 		 * Task with same address space who mapped this iova range is
@@ -1212,7 +1204,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 		if (unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
 			ret = update_user_bitmap(bitmap->data, iommu, dma,
-						 unmap->iova, pgsize);
+						 iova, pgsize);
 			if (ret)
 				break;
 		}
-- 
1.8.3.1

