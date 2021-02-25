Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD2325727
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 20:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhBYT45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 14:56:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44766 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234592AbhBYTzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 14:55:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PJoGkB141068;
        Thu, 25 Feb 2021 19:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=VjXJGwSMw8GdU9G0Fstg4nGMaqu6u6fs9lwl/KkMb+U=;
 b=zjNqg/z3eHDEuyaVQBL4wTrpyAghzVjctJ0+fhqoYN28oq33+GORer8uksDj7DFN6r23
 PsEshD8JyOJtp+XiLBz3CKFis5BIrfu4hQC3TfyFeTFMPz52gJzEd6JQpOdLFWNhTEHv
 SepPlAVleLI6r0hSZqdb/kewy17O4QvmOK8DfDUIfYqn7dgFpCuW2rR8xjylNIWaZr6J
 V6rdotgXyYrLldyOh8LhdRaQp/Yyd3bI7rLmaj8qtNnJ2oeBN8P89j8RxswPWBwAlJxL
 cn8Sr5Rvnc4EgquVMNh65Ct+M11JPL54B+aBVVTB7NhFSVWdPlFVL/NKvD0VSxhyYJ2C 5Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsur7rbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 19:54:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11PJoFFp141810;
        Thu, 25 Feb 2021 19:54:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 36uc6ux8e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 19:54:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11PJsNGZ028249;
        Thu, 25 Feb 2021 19:54:23 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Feb 2021 11:54:22 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH] vfio/type1: fix unmap all on ILP32
Date:   Thu, 25 Feb 2021 11:25:02 -0800
Message-Id: <1614281102-230747-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250150
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9906 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250150
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some ILP32 architectures support mapping a 32-bit vaddr within a 64-bit
iova space.  The unmap-all code uses 32-bit SIZE_MAX as an upper bound on
the extent of the mappings within iova space, so mappings above 4G cannot
be found and unmapped.  Use U64_MAX instead, and use u64 for size variables.
This also fixes a static analysis bug found by the kernel test robot running
smatch for ILP32.

Fixes: 0f53afa12bae ("vfio/type1: unmap cleanup")
Fixes: c19650995374 ("vfio/type1: implement unmap all")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6cf1dad..b1be0a6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -181,7 +181,7 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 }
 
 static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
-						dma_addr_t start, size_t size)
+						dma_addr_t start, u64 size)
 {
 	struct rb_node *res = NULL;
 	struct rb_node *node = iommu->dma_list.rb_node;
@@ -1184,7 +1184,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	int ret = -EINVAL, retries = 0;
 	unsigned long pgshift;
 	dma_addr_t iova = unmap->iova;
-	unsigned long size = unmap->size;
+	u64 size = unmap->size;
 	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
 	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
 	struct rb_node *n, *first_n;
@@ -1200,14 +1200,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	if (unmap_all) {
 		if (iova || size)
 			goto unlock;
-		size = SIZE_MAX;
-	} else if (!size || size & (pgsize - 1)) {
+		size = U64_MAX;
+	} else if (!size || size & (pgsize - 1) ||
+		   iova + size - 1 < iova || size > SIZE_MAX) {
 		goto unlock;
 	}
 
-	if (iova + size - 1 < iova || size > SIZE_MAX)
-		goto unlock;
-
 	/* When dirty tracking is enabled, allow only min supported pgsize */
 	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
 	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
-- 
1.8.3.1

