Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1BD2EAF9A
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 17:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbhAEQEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 11:04:46 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49614 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbhAEQEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 11:04:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105FssY4031176;
        Tue, 5 Jan 2021 16:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4/H3lHUMJl6zxVO4zaYyVALKN7VwtyrDABjdtel12JY=;
 b=jkkC44nPHAaX8c1BiKWB5ybkXtYMsolvEjMU4edXDMLAWn0MODcFLW0r0hRUegoSyYLR
 Dgf6COkro4L1hP5R0Do889PLP97yLYND6V/nUiZGa6t/RWYF3sgV94yuV6TEYY+g/blc
 YbZWGRR7irREce3erRGVoCXpnpKY6gYeNs6ZB1xY/NqfKfEAhSO3wHDcHhU2qBX7U7gF
 YFZgvbLJ81b2aFr9kW4aP7RcFJ01kUAi6Qou0/vNd7pia65AWBVEkwN8KbaXuiNX+1zV
 JzD8YxBAiGFlEjt8UNQ8u2pkOivCLd9MU4Bbcuorn+DjCGG+d05EPmhmywtOHYtsAjuj SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35tgsksfan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 16:04:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105FukTG187413;
        Tue, 5 Jan 2021 16:03:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35v1f8see1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 16:03:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105G3woQ015365;
        Tue, 5 Jan 2021 16:03:58 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 16:03:58 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 2/5] vfio: option to unmap all
Date:   Tue,  5 Jan 2021 07:36:50 -0800
Message-Id: <1609861013-129801-3-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For VFIO_IOMMU_UNMAP_DMA, delete all mappings if iova=0 and size=0.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 11 ++++++++---
 include/uapi/linux/vfio.h       |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 02228d0..3dc501d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1079,6 +1079,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	size_t unmapped = 0, pgsize;
 	int ret = 0, retries = 0;
 	unsigned long pgshift;
+	dma_addr_t iova;
+	unsigned long size;
 
 	mutex_lock(&iommu->lock);
 
@@ -1090,7 +1092,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		goto unlock;
 	}
 
-	if (!unmap->size || unmap->size & (pgsize - 1)) {
+	if ((!unmap->size && unmap->iova) || unmap->size & (pgsize - 1)) {
 		ret = -EINVAL;
 		goto unlock;
 	}
@@ -1154,8 +1156,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		}
 	}
 
-	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
-		if (!iommu->v2 && unmap->iova > dma->iova)
+	iova = unmap->iova;
+	size = unmap->size ? unmap->size : SIZE_MAX;
+
+	while ((dma = vfio_find_dma(iommu, iova, size))) {
+		if (!iommu->v2 && iova > dma->iova)
 			break;
 		/*
 		 * Task with same address space who mapped this iova range is
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9204705..896e527 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1073,7 +1073,8 @@ struct vfio_bitmap {
  * Caller sets argsz.  The actual unmapped size is returned in the size
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
- * succeed.
+ * succeed.  If iova=0 and size=0, all addresses are unmapped.
+ *
  * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
  * before unmapping IO virtual addresses. When this flag is set, the user must
  * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
-- 
1.8.3.1

