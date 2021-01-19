Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0082FBECB
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391729AbhASSUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:20:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41654 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387681AbhASSQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAFWF064418;
        Tue, 19 Jan 2021 18:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=uJxb68WCO2UcF1LIHJd0NAHmUDH7m86195m2DD2rVKs=;
 b=c9Bsa7OwRPVJq8NPD8v1D49vuGXJSYt76uqWLFfGbbxeU5L8dpQR2UyDWWTReWdqYyL1
 zjGgAmqOQNol6bRlLKB2Rh5rJ3swPp4Zy/Kz9UWyZ1PpbIViIQhc9BUkRTXeIfGFVycE
 2PIKds89Wy5OKu/FYzRbL4gwlChKxG0HL8dXNviF9A2rUj6L93c3IkGMTQkd7we3mjyC
 5/hxllE/pYbqNa+tVvbtiItKRNHf9n76pi3gaWwhBfAjIi2kIYYuiNVf9zGQv3t2CM13
 /c/cmyJ6FDbEjgfvcG/atutGE3f2wOwi4Fov4m9LTVWgZtHpCe80WGATznlCZk+gnHlD QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 363r3ktcpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAcZJ051022;
        Tue, 19 Jan 2021 18:16:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3661khmfss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JIG1TI018644;
        Tue, 19 Jan 2021 18:16:01 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:16:01 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 4/9] vfio/type1: implement unmap all
Date:   Tue, 19 Jan 2021 09:48:24 -0800
Message-Id: <1611078509-181959-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement VFIO_DMA_UNMAP_FLAG_ALL.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c687174..ef83018 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1100,6 +1100,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	unsigned long pgshift;
 	dma_addr_t iova = unmap->iova;
 	unsigned long size = unmap->size;
+	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
 
 	mutex_lock(&iommu->lock);
 
@@ -1109,8 +1110,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	if (iova & (pgsize - 1))
 		goto unlock;
 
-	if (!size || size & (pgsize - 1))
+	if (unmap_all) {
+		if (iova || size)
+			goto unlock;
+		size = SIZE_MAX;
+	} else if (!size || size & (pgsize - 1)) {
 		goto unlock;
+	}
 
 	if (iova + size - 1 < iova || size > SIZE_MAX)
 		goto unlock;
@@ -1154,7 +1160,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	 * will only return success and a size of zero if there were no
 	 * mappings within the range.
 	 */
-	if (iommu->v2) {
+	if (iommu->v2 && !unmap_all) {
 		dma = vfio_find_dma(iommu, iova, 1);
 		if (dma && dma->iova != iova)
 			goto unlock;
@@ -1165,7 +1171,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 	ret = 0;
-	while ((dma = vfio_find_dma(iommu, iova, size))) {
+	while ((dma = vfio_find_dma_first(iommu, iova, size))) {
 		if (!iommu->v2 && iova > dma->iova)
 			break;
 		/*
@@ -2538,6 +2544,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
+	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
@@ -2710,6 +2717,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 {
 	struct vfio_iommu_type1_dma_unmap unmap;
 	struct vfio_bitmap bitmap = { 0 };
+	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
+			VFIO_DMA_UNMAP_FLAG_ALL;
 	unsigned long minsz;
 	int ret;
 
@@ -2718,8 +2727,11 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 	if (copy_from_user(&unmap, (void __user *)arg, minsz))
 		return -EFAULT;
 
-	if (unmap.argsz < minsz ||
-	    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
+	if (unmap.argsz < minsz || unmap.flags & ~mask)
+		return -EINVAL;
+
+	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+	    (unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP))
 		return -EINVAL;
 
 	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
-- 
1.8.3.1

