Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90481308B79
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhA2RXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:23:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37322 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbhA2RXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:23:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THA22o034264;
        Fri, 29 Jan 2021 17:22:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=d3aFx130XwI+Pm3VO3gKHCv/R5G8faz6/12s/4dOpa0=;
 b=aPnZxG2dYXlFTHD8x/Qn7S2BHsgbKGs6rUNirUenhM9Lv8ZBPIIxCxF6rgVIjojbY55E
 NJg6j0HO6wWFGwq3TILpBcnpNHHF2wciHM/Jgv1zD3IQiHnQVNC0a5liGf0Z/1zQuoRl
 rqpkAFs1NaT921F3czx8dNaQQwsXJkBwtFtFmjqjAevEiTEcd+7XlfeExIQwQ9Ug2u7c
 Bi2xdZ76dzTWnqRNLApKTla0uNYpa9fjxyFHHU81PFmnLYkGcN5wlydAwCvbELCrHRbK
 st7tG0Sofsh0Rvu4dqe3naMJncrf3E7OayP7bSdWecT+hb6nB3AoRhjqj9KN23YIO7PD 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 368b7raf4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH5GNv076646;
        Fri, 29 Jan 2021 17:22:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 368wcsfknq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:21 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10THMKVg002755;
        Fri, 29 Jan 2021 17:22:20 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Jan 2021 09:22:20 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 3/9] vfio/type1: implement unmap all
Date:   Fri, 29 Jan 2021 08:54:06 -0800
Message-Id: <1611939252-7240-4-git-send-email-steven.sistare@oracle.com>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement VFIO_DMA_UNMAP_FLAG_ALL.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6bf33c2..407f0f7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1077,6 +1077,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	unsigned long pgshift;
 	dma_addr_t iova = unmap->iova;
 	unsigned long size = unmap->size;
+	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
 
 	mutex_lock(&iommu->lock);
 
@@ -1086,8 +1087,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
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
@@ -1131,7 +1137,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	 * will only return success and a size of zero if there were no
 	 * mappings within the range.
 	 */
-	if (iommu->v2) {
+	if (iommu->v2 && !unmap_all) {
 		dma = vfio_find_dma(iommu, iova, 1);
 		if (dma && dma->iova != iova)
 			goto unlock;
@@ -2515,6 +2521,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
+	case VFIO_UNMAP_ALL:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
@@ -2687,6 +2694,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 {
 	struct vfio_iommu_type1_dma_unmap unmap;
 	struct vfio_bitmap bitmap = { 0 };
+	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
+			VFIO_DMA_UNMAP_FLAG_ALL;
 	unsigned long minsz;
 	int ret;
 
@@ -2695,8 +2704,11 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 	if (copy_from_user(&unmap, (void __user *)arg, minsz))
 		return -EFAULT;
 
-	if (unmap.argsz < minsz ||
-	    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
+	if (unmap.argsz < minsz || unmap.flags & ~mask)
+		return -EINVAL;
+
+	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
+	    (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL))
 		return -EINVAL;
 
 	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
-- 
1.8.3.1

