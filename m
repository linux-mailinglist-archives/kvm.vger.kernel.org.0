Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B2D64BD69
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 20:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiLMTlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 14:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiLMTlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 14:41:04 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0816222A6
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:41:03 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDJJZWH005098;
        Tue, 13 Dec 2022 19:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=CXbwhsrykjSxagfr6OFUfu9eXJ+3ZRBqCHJSSZAn4G8=;
 b=EFy5tA2qR6rXBNQRRGeTnEJaZJwMjqQ51AbsO0M7ZzAqHLDeI7Fqj2mxxk6liYnZxa3k
 c30XcPus00LLhh4eLD0TjBmc5d5fm2x7blXSguTy/J5+EGCL3JtPWOvfYRQ1IOihVu5S
 F0mHWavbvauQb1c3lMsYYsLcjc1h8bcw5/DNb+A8WpI1JWa9vEaJHVFvZzYpIKvilqRa
 QDsCuHQRCnuxC/Z1KK1g3LLKy8gRKOn2TbD7nQjKltEfCkL50BRavhOxhne9WTg1Q7VF
 m7C8qQq4Y6VNJWttxRZL7BVWK67dgZ5uiZaXJTKP3NugtXArggma+UsZ0pZ93SaqONdS rQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerr20j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDJJCQF031179;
        Tue, 13 Dec 2022 19:41:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesrs09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 19:41:01 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDJf0Gj028128;
        Tue, 13 Dec 2022 19:41:00 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyesrry8-2;
        Tue, 13 Dec 2022 19:41:00 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Date:   Tue, 13 Dec 2022 11:40:55 -0800
Message-Id: <1670960459-415264-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212130171
X-Proofpoint-ORIG-GUID: Tu6JgK8gf6B-7mX2rX4CDfg1rPZ70LVz
X-Proofpoint-GUID: Tu6JgK8gf6B-7mX2rX4CDfg1rPZ70LVz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
Their kernel threads could be blocked indefinitely by a misbehaving
userland while trying to pin/unpin pages while vaddrs are being updated.

Do not allow groups to be added to the container while vaddr's are invalid,
so we never need to block user threads from pinning, and can delete the
vaddr-waiting code in a subsequent patch.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       | 15 +++++++++------
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe..80bdb4d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -859,6 +859,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	if (!iommu->v2)
 		return -EACCES;
 
+	WARN_ON(iommu->vaddr_invalid_count);
+
 	mutex_lock(&iommu->lock);
 
 	/*
@@ -976,6 +978,8 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
+	WARN_ON(iommu->vaddr_invalid_count);
+
 	do_accounting = list_empty(&iommu->domain_list);
 	for (i = 0; i < npage; i++) {
 		dma_addr_t iova = user_iova + PAGE_SIZE * i;
@@ -1343,6 +1347,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
+	/* Cannot update vaddr if mdev is present. */
+	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
+		goto unlock;
+
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
@@ -2189,6 +2197,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
+	/* Attach could require pinning, so disallow while vaddr is invalid. */
+	if (iommu->vaddr_invalid_count)
+		goto out_unlock;
+
 	/* Check for duplicates */
 	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
 		goto out_unlock;
@@ -2660,6 +2672,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
 	return ret;
 }
 
+static int vfio_iommu_has_emulated(struct vfio_iommu *iommu)
+{
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	ret = !list_empty(&iommu->emulated_iommu_groups);
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 					    unsigned long arg)
 {
@@ -2668,8 +2690,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
-	case VFIO_UPDATE_VADDR:
 		return 1;
+	case VFIO_UPDATE_VADDR:
+		/*
+		 * Disable this feature if mdevs are present.  They cannot
+		 * safely pin/unpin while vaddrs are being updated.
+		 */
+		return iommu && !vfio_iommu_has_emulated(iommu);
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
 			return 0;
@@ -3080,6 +3107,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 	size_t offset;
 	int ret;
 
+	WARN_ON(iommu->vaddr_invalid_count);
+
 	*copied = 0;
 
 	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d7d8e09..4e8d344 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -49,7 +49,11 @@
 /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
 #define VFIO_UNMAP_ALL			9
 
-/* Supports the vaddr flag for DMA map and unmap */
+/*
+ * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
+ * devices, so this capability is subject to change as groups are added or
+ * removed.
+ */
 #define VFIO_UPDATE_VADDR		10
 
 /*
@@ -1215,8 +1219,7 @@ struct vfio_iommu_type1_info_dma_avail {
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
  *
- * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
- * unblock translation of host virtual addresses in the iova range.  The vaddr
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
  * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
  * maintain memory consistency within the user application, the updated vaddr
  * must address the same memory object as originally mapped.  Failure to do so
@@ -1267,9 +1270,9 @@ struct vfio_bitmap {
  * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
  *
  * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
- * virtual addresses in the iova range.  Tasks that attempt to translate an
- * iova's vaddr will block.  DMA to already-mapped pages continues.  This
- * cannot be combined with the get-dirty-bitmap flag.
+ * virtual addresses in the iova range.  DMA to already-mapped pages continues.
+ * Groups may not be added to the container while any addresses are invalid.
+ * This cannot be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
-- 
1.8.3.1

