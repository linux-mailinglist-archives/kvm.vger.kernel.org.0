Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A722EAF9B
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 17:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbhAEQEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 11:04:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45500 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbhAEQEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 11:04:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105Ftgdj138082;
        Tue, 5 Jan 2021 16:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=2nFsFxZoKMVelZhOQbExkZ51PmPGycR3uHNdk+4xWgw=;
 b=bNNwEKjXx5LZGVkNkPCVKhzMUuHn9mxFVBEYt4BFt+0w9pUOnebUGOK3bsxVQlsJSrHz
 qHVbn9hmF/F6B8MuCAA9PpsFjMlshshyh3JHD6soywp/gXMxlsBlVIVP0sGDO5fYyTIp
 C86l74J+JKEQV+0hEp3AuGr0wwXhAXlHuxmuqZrfBeFuzSVuehtUEcgzdfbF4eDsYgkD
 XTMreDDUcFObQUjNmohHwMga15m3B4IZ1/JK6KvukTFl8AbPHnSfqY4nvQLuR5V2z/bk
 N+MDiI4jkjWRm/ryPP1tIzaFVDMBp2SwXytcozKXXhWwmoSa1xSikj5nvqTjBc2LCOMt qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35tg8r1g6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 16:04:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105FuR3Q026734;
        Tue, 5 Jan 2021 16:04:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35v4rbj5xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 16:03:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105G3xR5015510;
        Tue, 5 Jan 2021 16:03:59 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 16:03:59 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 4/5] vfio: VA suspend interface
Date:   Tue,  5 Jan 2021 07:36:52 -0800
Message-Id: <1609861013-129801-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add interfaces that allow the underlying memory object of an iova
range to be mapped to a new host virtual address in the host process:

  - VFIO_DMA_UNMAP_FLAG_SUSPEND for VFIO_IOMMU_UNMAP_DMA
  - VFIO_DMA_MAP_FLAG_RESUME flag for VFIO_IOMMU_MAP_DMA
  - VFIO_SUSPEND extension for VFIO_CHECK_EXTENSION

The suspend interface blocks vfio translation of host virtual
addresses in a range, but DMA to already-mapped pages continues.
The resume interface records the new base VA and resumes translation.
See comments in uapi/linux/vfio.h for more details.

This is a partial implementation.  Blocking is added in the next patch.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 47 +++++++++++++++++++++++++++++++++++------
 include/uapi/linux/vfio.h       | 16 ++++++++++++++
 2 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3dc501d..2c164a6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -92,6 +92,7 @@ struct vfio_dma {
 	int			prot;		/* IOMMU_READ/WRITE */
 	bool			iommu_mapped;
 	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
+	bool			suspended;
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
@@ -1080,7 +1081,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 	int ret = 0, retries = 0;
 	unsigned long pgshift;
 	dma_addr_t iova;
-	unsigned long size;
+	unsigned long size, consumed;
 
 	mutex_lock(&iommu->lock);
 
@@ -1169,6 +1170,21 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 		if (dma->task->mm != current->mm)
 			break;
 
+		if (unmap->flags & VFIO_DMA_UNMAP_FLAG_SUSPEND) {
+			if (dma->suspended) {
+				ret = -EINVAL;
+				goto unlock;
+			}
+			dma->suspended = true;
+			consumed = dma->iova + dma->size - iova;
+			if (consumed >= size)
+				break;
+			iova += consumed;
+			size -= consumed;
+			unmapped += dma->size;
+			continue;
+		}
+
 		if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
 			struct vfio_iommu_type1_dma_unmap nb_unmap;
 
@@ -1307,6 +1323,7 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
+	bool resume = map->flags & VFIO_DMA_MAP_FLAG_RESUME;
 	dma_addr_t iova = map->iova;
 	unsigned long vaddr = map->vaddr;
 	size_t size = map->size;
@@ -1324,13 +1341,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
 
+	if ((prot && resume) || (!prot && !resume))
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
@@ -1341,7 +1361,19 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		goto out_unlock;
 	}
 
-	if (vfio_find_dma(iommu, iova, size)) {
+	dma = vfio_find_dma(iommu, iova, size);
+	if (resume) {
+		if (!dma) {
+			ret = -ENOENT;
+		} else if (!dma->suspended || dma->iova != iova ||
+			   dma->size != size) {
+			ret = -EINVAL;
+		} else {
+			dma->vaddr = vaddr;
+			dma->suspended = false;
+		}
+		goto out_unlock;
+	} else if (dma) {
 		ret = -EEXIST;
 		goto out_unlock;
 	}
@@ -2532,6 +2564,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1_IOMMU:
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
+	case VFIO_SUSPEND:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
@@ -2686,7 +2719,8 @@ static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
 {
 	struct vfio_iommu_type1_dma_map map;
 	unsigned long minsz;
-	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
+	uint32_t mask = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE |
+			VFIO_DMA_MAP_FLAG_RESUME;
 
 	minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
@@ -2704,6 +2738,8 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 {
 	struct vfio_iommu_type1_dma_unmap unmap;
 	struct vfio_bitmap bitmap = { 0 };
+	uint32_t mask = VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP |
+			VFIO_DMA_UNMAP_FLAG_SUSPEND;
 	unsigned long minsz;
 	int ret;
 
@@ -2712,8 +2748,7 @@ static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
 	if (copy_from_user(&unmap, (void __user *)arg, minsz))
 		return -EFAULT;
 
-	if (unmap.argsz < minsz ||
-	    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
+	if (unmap.argsz < minsz || unmap.flags & ~mask || unmap.flags == mask)
 		return -EINVAL;
 
 	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 896e527..fcf7b56 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -46,6 +46,9 @@
  */
 #define VFIO_NOIOMMU_IOMMU		8
 
+/* Supports VFIO DMA suspend and resume */
+#define VFIO_SUSPEND			9
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -1046,12 +1049,19 @@ struct vfio_iommu_type1_info_cap_migration {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * If flags & VFIO_DMA_MAP_FLAG_RESUME, record the new base vaddr for iova, and
+ * resume translation of host virtual addresses in the iova range.  The new
+ * vaddr must point to the same memory object as the old vaddr, but this is not
+ * verified.  iova and size must match those in the original MAP_DMA call.
+ * Protection is not changed, and the READ & WRITE flags must be 0.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_RESUME (1 << 2)
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
@@ -1084,11 +1094,17 @@ struct vfio_bitmap {
  * indicates that the page at that offset from iova is dirty. A Bitmap of the
  * pages in the range of unmapped size is returned in the user-provided
  * vfio_bitmap.data.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_SUSPEND, do not unmap, but suspend vfio
+ * translation of host virtual addresses in the iova range.  During suspension,
+ * kernel threads that attempt to translate will block.  DMA to already-mapped
+ * pages continues.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
+#define VFIO_DMA_UNMAP_FLAG_SUSPEND	     (1 << 1)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];
-- 
1.8.3.1

