Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794F52FBED2
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392573AbhASSUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:20:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392424AbhASSQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAI6E064452;
        Tue, 19 Jan 2021 18:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=pgrK/S5OWo7thCAXZwUErW1uPIZoZlbIUJ7E1iFr81k=;
 b=AkXGUwE2LTtKHv24/SpJX4M5DxBuaJQxQMTh7CrqGDZDTS0uo9spHkY4cAAYyPGvPJ1J
 C24waUNE9ZtrigauS9+iJaUTofaYWw3Po9Qe2IByHDWaSDb7GATMwkSt+cNNw6oMif0l
 mB0GYllzn7mx6xnRVvkkABcyWh70kDeXs0FqXs3IZestaXlANL6XndsKP+osuWIg+yet
 gEEArGIsctKvGNmNwFGvfZ0y5v6xBGC0nEoZBMwamKYaI4YABoQga9172EaHZMFTaTIx
 RCG96pKmC5xBoowJEDVsTn+pvlfiNh5vguuHFK1cRr/UWMzCK99zW7HhI/rd+brKVe13 yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 363r3ktcpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JI9iSg126606;
        Tue, 19 Jan 2021 18:16:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3661er45cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JIG2ab018679;
        Tue, 19 Jan 2021 18:16:02 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:16:02 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 6/9] vfio/type1: implement interfaces to update vaddr
Date:   Tue, 19 Jan 2021 09:48:26 -0800
Message-Id: <1611078509-181959-7-git-send-email-steven.sistare@oracle.com>
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

Implement VFIO_DMA_UNMAP_FLAG_VADDR, VFIO_DMA_MAP_FLAG_VADDR, and
VFIO_UPDATE_VADDR.  This is a partial implementation.  Blocking is
added in the next patch.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ef83018..c307f62 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -92,6 +92,7 @@ struct vfio_dma {
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
+	bool			vaddr_valid;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -1101,6 +1102,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	dma_addr_t iova = unmap->iova;
 	unsigned long size = unmap->size;
 	bool unmap_all = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL);
+	bool invalidate = !!(unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR);
 
 	mutex_lock(&iommu->lock);
 
@@ -1181,6 +1183,18 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
+		if (invalidate) {
+			if (!dma->vaddr_valid)
+				goto unwind;
+			dma->vaddr_valid = false;
+			unmapped += dma->size;
+			size -= dma->iova + dma->size - iova;
+			iova = dma->iova + dma->size;
+			if (iova == 0)
+				break;
+			continue;
+		}
+
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			struct vfio_iommu_type1_dma_unmap nb_unmap;
 
@@ -1218,6 +1232,20 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		unmapped += dma->size;
 		vfio_remove_dma(iommu, dma);
 	}
+	goto unlock;
+
+unwind:
+	iova = unmap->iova;
+	size = unmap_all ? SIZE_MAX : unmap->size;
+	dma_last = dma;
+	while ((dma = vfio_find_dma_first(iommu, iova, size)) &&
+	       dma != dma_last) {
+		dma->vaddr_valid = true;
+		size -= dma->iova + dma->size - iova;
+		iova = dma->iova + dma->size;
+	}
+	ret = -EINVAL;
+	unmapped = 0;
 
 unlock:
 	mutex_unlock(&iommu->lock);
@@ -1319,6 +1347,7 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
+	bool update = map->flags & VFIO_DMA_MAP_FLAG_VADDR;
 	dma_addr_t iova = map->iova;
 	unsigned long vaddr = map->vaddr;
 	size_t size = map->size;
@@ -1336,13 +1365,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
 
+	if ((prot && update) || (!prot && !update))
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
@@ -1353,7 +1385,19 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	if (vfio_find_dma(iommu, iova, size)) {
+	dma = vfio_find_dma(iommu, iova, size);
+	if (update) {
+		if (!dma) {
+			ret = -ENOENT;
+		} else if (dma->vaddr_valid || dma->iova != iova ||
+			   dma->size != size) {
+			ret = -EINVAL;
+		} else {
+			dma->vaddr = vaddr;
+			dma->vaddr_valid = true;
+		}
+		goto out_unlock;
+	} else if (dma) {
 		ret = -EEXIST;
 		goto out_unlock;
 	}
@@ -1377,6 +1421,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	iommu->dma_avail--;
 	dma->iova = iova;
 	dma->vaddr = vaddr;
+	dma->vaddr_valid = true;
 	dma->prot = prot;
 
 	/*
@@ -2545,6 +2590,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
+	case VFIO_UPDATE_VADDR:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
@@ -2699,7 +2745,8 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
 {
 	struct vfio_iommu_type1_dma_map map;
 	unsigned long minsz;
-	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
+	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
+			VFIO_DMA_MAP_FLAG_VADDR;
 
 	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -2718,6 +2765,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 	struct vfio_iommu_type1_dma_unmap unmap;
 	struct vfio_bitmap bitmap = { 0 };
 	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
+			VFIO_DMA_UNMAP_FLAG_VADDR |
 			VFIO_DMA_UNMAP_FLAG_ALL;
 	unsigned long minsz;
 	int ret;
-- 
1.8.3.1

