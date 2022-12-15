Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699DF64E38E
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLOV5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiLOV5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:57:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B3B2D1FF
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:57:11 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3t8Y026495;
        Thu, 15 Dec 2022 21:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=baDXaUC98G70KZOEf1Fdz2/8edh7SuxC3H6XPm/28ak=;
 b=EYLL6ukKTrFl8Jw03EvzHxns6Of3ffsuxmI+tNHUtMHdoYxTyjMUJNYKGGDWpwYN5K6e
 ebPUDRUwmK6ZK7HeNuTqVpXJaBLGj0tJ/+ykUFkrX3o+RmdyRzYkuvYQOAiWGTR5lxJF
 ZZiwgfOyDRV8PBL/w0xa8luTAh9bHubYhM7I6BiKJnIA832VIzlN1d9UTqV7KH2xNOmV
 stJv4rB3Y0Z9c135x9fuBSi1MQJVooD5HMyDrWCuuQ6TdUQWJF/QehfZB3hO1xEu+Jyf
 F1477hKQHlMliCpENt+dcDbKEmXfI7hH1NV8HyWK0MSLy3KrcM1ikgowLOXRPPiLH8/i hQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerxb1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKcblE033015;
        Thu, 15 Dec 2022 21:57:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerdf38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:06 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLv5XI007209;
        Thu, 15 Dec 2022 21:57:05 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyerdf2f-2;
        Thu, 15 Dec 2022 21:57:05 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V5 1/7] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Date:   Thu, 15 Dec 2022 13:56:58 -0800
Message-Id: <1671141424-81853-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-ORIG-GUID: BwbpIftcQIF83I-XLH_64pz3TaO3SlkQ
X-Proofpoint-GUID: BwbpIftcQIF83I-XLH_64pz3TaO3SlkQ
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

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 44 +++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h       | 15 ++++++++------
 2 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe..144f5bb 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
+	if (WARN_ONCE(iommu->vaddr_invalid_count,
+		      "vfio_pin_pages not allowed with VFIO_UPDATE_VADDR\n")) {
+		ret = -EBUSY;
+		goto pin_done;
+	}
+
 	/*
 	 * Wait for all necessary vaddr's to be valid so they can be used in
 	 * the main loop without dropping the lock, to avoid racing vs unmap.
@@ -1343,6 +1349,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
+	/* Cannot update vaddr if mdev is present. */
+	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
@@ -2185,11 +2197,16 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
 	LIST_HEAD(group_resv_regions);
-	int ret = -EINVAL;
+	int ret = -EBUSY;
 
 	mutex_lock(&iommu->lock);
 
+	/* Attach could require pinning, so disallow while vaddr is invalid. */
+	if (iommu->vaddr_invalid_count)
+		goto out_unlock;
+
 	/* Check for duplicates */
+	ret = -EINVAL;
 	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
 		goto out_unlock;
 
@@ -2660,6 +2677,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
 	return ret;
 }
 
+static bool vfio_iommu_has_emulated(struct vfio_iommu *iommu)
+{
+	bool ret;
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
@@ -2668,8 +2695,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
-	case VFIO_UPDATE_VADDR:
 		return 1;
+	case VFIO_UPDATE_VADDR:
+		/*
+		 * Disable this feature if mdevs are present.  They cannot
+		 * safely pin/unpin/rw while vaddrs are being updated.
+		 */
+		return iommu && !vfio_iommu_has_emulated(iommu);
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
 			return 0;
@@ -3138,6 +3170,13 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	size_t done;
 
 	mutex_lock(&iommu->lock);
+
+	if (WARN_ONCE(iommu->vaddr_invalid_count,
+		      "vfio_dma_rw not allowed with VFIO_UPDATE_VADDR\n")) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	while (count > 0) {
 		ret = vfio_iommu_type1_dma_rw_chunk(iommu, user_iova, data,
 						    count, write, &done);
@@ -3149,6 +3188,7 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 		user_iova += done;
 	}
 
+out:
 	mutex_unlock(&iommu->lock);
 	return ret;
 }
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

