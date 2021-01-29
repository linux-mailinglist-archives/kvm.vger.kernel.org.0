Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAF0308B78
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhA2RXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:23:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37364 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbhA2RXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:23:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THA0g4034087;
        Fri, 29 Jan 2021 17:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ubkvQ4iUa5032llFuh/+Ir6DMDSIAhhVMh/d/b4buKo=;
 b=umSDgL1XVbrk16G73FP2YbTnupu8/8GroURI5W4Ionnycq7jwAGi64yU1A8vXQCSNwLX
 NSeOSmfHq36vvQbqiNuLBZjSNwp76A7RNEz9KWDNufBa8lnSenh5cf19AGspIQYX1lef
 UC8EIa2VSj/12Ij7J/RnG2yEJxbRF34iDGUR1Ol2CCeklHH2c/dEmuuitUNsqmMNcFT7
 8T1I20WJWA3wGfvH8R/JBTSg49egwt87HF3ZwdQUOEqjB8ZVkPAUsV/WJ+iBgYFsi2vb
 zrwixpknUiSio/w05SqJ8b52OIihRKDSwa9UmcNnWdSEdgiPtz7CL6RFbRqJ9bLPwGwY zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7raf4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH4iq6040972;
        Fri, 29 Jan 2021 17:22:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 36ceug5k8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10THML1o002784;
        Fri, 29 Jan 2021 17:22:21 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Jan 2021 09:22:21 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 6/9] vfio/type1: implement interfaces to update vaddr
Date:   Fri, 29 Jan 2021 08:54:09 -0800
Message-Id: <1611939252-7240-7-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290084
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement VFIO_DMA_UNMAP_FLAG_VADDR, VFIO_DMA_MAP_FLAG_VADDR, and
VFIO_UPDATE_VADDR.  This is a partial implementation.  Blocking is
added in a subsequent patch.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 62 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5823607..cbe3c65 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -74,6 +74,7 @@ struct vfio_iommu {
 	bool			nesting;
 	bool			dirty_page_tracking;
 	bool			pinned_page_dirty_scope;
+	int			vaddr_invalid_count;
 };
 
 struct vfio_domain {
@@ -92,6 +93,7 @@ struct vfio_dma {
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
+	bool			vaddr_invalid;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -973,6 +975,8 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
 	vfio_dma_bitmap_free(dma);
+	if (dma->vaddr_invalid)
+		--iommu->vaddr_invalid_count;
 	kfree(dma);
 	iommu->dma_avail++;
 }
@@ -1103,7 +1107,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	dma_addr_t iova = unmap->iova;
 	unsigned long size = unmap->size;
 	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
-	struct rb_node *n;
+	bool invalidate_vaddr = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR);
+	struct rb_node *n, *first_n, *last_n;
 
 	mutex_lock(&iommu->lock);
 
@@ -1174,7 +1179,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	}
 
 	ret = 0;
-	n = vfio_find_dma_first(iommu, iova, size);
+	n = first_n = vfio_find_dma_first(iommu, iova, size);
 
 	while (n) {
 		dma = rb_entry(n, struct vfio_dma, node);
@@ -1190,6 +1195,16 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
+		if (invalidate_vaddr) {
+			if (dma->vaddr_invalid)
+				goto unwind;
+			dma->vaddr_invalid = true;
+			iommu->vaddr_invalid_count++;
+			unmapped += dma->size;
+			n = rb_next(n);
+			continue;
+		}
+
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			struct vfio_iommu_type1_dma_unmap nb_unmap;
 
@@ -1228,6 +1243,18 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		n = rb_next(n);
 		vfio_remove_dma(iommu, dma);
 	}
+	goto unlock;
+
+unwind:
+	last_n = n;
+
+	for (n = first_n; n != last_n; n = rb_next(n)) {
+		dma = rb_entry(n, struct vfio_dma, node);
+		dma->vaddr_invalid = false;
+		--iommu->vaddr_invalid_count;
+	}
+	ret = -EINVAL;
+	unmapped = 0;
 
 unlock:
 	mutex_unlock(&iommu->lock);
@@ -1329,6 +1356,7 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
+	bool set_vaddr = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
 	dma_addr_t iova = map->iova;
 	unsigned long vaddr = map->vaddr;
 	size_t size = map->size;
@@ -1346,13 +1374,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
 
+	if ((prot && set_vaddr) || (!prot && !set_vaddr))
+		return -EINVAL;
+
 	mutex_lock(&iommu->lock);
 
 	pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
 
 	WARN_ON((pgsize - 1) & PAGE_MASK);
 
-	if (!prot || !size || (size | iova | vaddr) & (pgsize - 1)) {
+	if (!size || (size | iova | vaddr) & (pgsize - 1)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -1363,7 +1394,20 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	if (vfio_find_dma(iommu, iova, size)) {
+	dma = vfio_find_dma(iommu, iova, size);
+	if (set_vaddr) {
+		if (!dma) {
+			ret = -ENOENT;
+		} else if (!dma->vaddr_invalid || dma->iova != iova ||
+			   dma->size != size) {
+			ret = -EINVAL;
+		} else {
+			dma->vaddr = vaddr;
+			dma->vaddr_invalid = false;
+			--iommu->vaddr_invalid_count;
+		}
+		goto out_unlock;
+	} else if (dma) {
 		ret = -EEXIST;
 		goto out_unlock;
 	}
@@ -1387,6 +1431,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	iommu->dma_avail--;
 	dma->iova = iova;
 	dma->vaddr = vaddr;
+	dma->vaddr_invalid = false;
 	dma->prot = prot;
 
 	/*
@@ -2483,6 +2528,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	INIT_LIST_HEAD(&iommu->iova_list);
 	iommu->dma_list = RB_ROOT;
 	iommu->dma_avail = dma_entry_limit;
+	iommu->vaddr_invalid_count = 0;
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
 
@@ -2555,6 +2601,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
+	case VFIO_UPDATE_VADDR:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
@@ -2709,7 +2756,8 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
 {
 	struct vfio_iommu_type1_dma_map map;
 	unsigned long minsz;
-	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
+	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
+			VFIO_DMA_MAP_FLAG_VADDR;
 
 	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -2728,6 +2776,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 	struct vfio_iommu_type1_dma_unmap unmap;
 	struct vfio_bitmap bitmap = { 0 };
 	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
+			VFIO_DMA_UNMAP_FLAG_VADDR |
 			VFIO_DMA_UNMAP_FLAG_ALL;
 	unsigned long minsz;
 	int ret;
@@ -2741,7 +2790,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 		return -EINVAL;
 
 	if ((unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
-	    (unmap.flags & VFIO_DMA_UNMAP_FLAG_ALL))
+	    (unmap.flags & (VFIO_DMA_UNMAP_FLAG_ALL |
+			    VFIO_DMA_UNMAP_FLAG_VADDR)))
 		return -EINVAL;
 
 	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
-- 
1.8.3.1

