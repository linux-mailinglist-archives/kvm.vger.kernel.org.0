Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D557F308B75
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhA2RX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:23:26 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43292 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhA2RXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:23:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THA1wg084135;
        Fri, 29 Jan 2021 17:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=gSZ5FqHantH7lxOs1ItApbz47LAt9JfG6HhsSgE5EMw=;
 b=LWdBEpGAThlOFT+GKlbwmq9BJ/dT0ACxkl/UGV0Lwn9C/W+67SQcfbfKpxMjfSDeiDpB
 YYeKZwitJsFBVBax4kSxDpn5ZWbMlYfcxhHSdt/EmxZHVbq7p7kDc66XnEQMO3IYTMzR
 qOSvh90F5vDODIwGNTAsQDtjK6WHwgrlrNKhtLvkJ33RCtWnkdqrStzMb9Iun82Qz2Yt
 3OmUwHCgjLA/2V7Fo8TWyqvaTBNxTleSBSuEkzztvH2XDTPMD6nyr8aosBFRB3dVGDgt
 LS3+Nlmw5zWxEkwDMkA1uOtKemhdy5p+Zqpj6TgLZSwP2Ju01Kg93XwcBVY//87xXvYL NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689ab2kfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH5GZ6076655;
        Fri, 29 Jan 2021 17:22:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 368wcsfknm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10THMKEr023167;
        Fri, 29 Jan 2021 17:22:20 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Jan 2021 09:22:19 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 2/9] vfio/type1: unmap cleanup
Date:   Fri, 29 Jan 2021 08:54:05 -0800
Message-Id: <1611939252-7240-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
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
index 5fbf0c1..6bf33c2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1073,34 +1073,28 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
 
@@ -1138,20 +1132,18 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1189,7 +1181,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 		if (unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
 			ret = update_user_bitmap(bitmap->data, iommu, dma,
-						 unmap->iova, pgsize);
+						 iova, pgsize);
 			if (ret)
 				break;
 		}
-- 
1.8.3.1

