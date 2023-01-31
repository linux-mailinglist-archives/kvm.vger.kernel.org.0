Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB0D683321
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjAaQ60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbjAaQ6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:58:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC46B125A2
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:58:16 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VEDehR020785;
        Tue, 31 Jan 2023 16:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=AGMtS9NtIJLO/95tRh4Erx5mwL1ZPFfSdkN8KSNL2N4=;
 b=S+iqK6LrJ/08YBPDOnjWO9udBl0YsqdVQKS0dzwLR4LVVg0dM9Q4BUDiq8VpgHHzCtMT
 /6NtJCRHT8csoUDVP84HT06eHIpR7+LdMPiD1daiD2z7lMp/uP4b+1Wa4CbuWTy1+Wx2
 /HDbh6igaDJeAzry8QfS9Zd8AcAIIRhS8KJhm3tzifhXd3JyMG2YPKBd4vxg1SpmDghn
 skekHWYvphvtao0hv0iOagY3QGuQEnqmXw389F0Mj09ev5mgWcWeFyTfM9tJo4s6Az/i
 6S/IIthanvp/+SuAlOiajrHgw8M1p779+fbHbTvmVXXt5euQ4JrKuPZQWAeZvIgc+vfm PA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvrjx44s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30VGXHep025041;
        Tue, 31 Jan 2023 16:58:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct566vam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:10 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30VGw98j002013;
        Tue, 31 Jan 2023 16:58:10 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3nct566v9x-2;
        Tue, 31 Jan 2023 16:58:10 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V8 1/7] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Date:   Tue, 31 Jan 2023 08:58:03 -0800
Message-Id: <1675184289-267876-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
References: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310150
X-Proofpoint-GUID: Bp0Q8N9eg5qr7Lvp-PzkD1N5bQuTFhOx
X-Proofpoint-ORIG-GUID: Bp0Q8N9eg5qr7Lvp-PzkD1N5bQuTFhOx
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
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 44 +++++++++++++++++++++++++++++++++++++++--
 include/uapi/linux/vfio.h       | 15 ++++++++------
 2 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2209372..e8902e7 100644
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
 
@@ -2194,11 +2206,16 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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
 
@@ -2669,6 +2686,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
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
@@ -2677,8 +2704,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
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
@@ -3147,6 +3179,13 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
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
@@ -3158,6 +3197,7 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 		user_iova += done;
 	}
 
+out:
 	mutex_unlock(&iommu->lock);
 	return ret;
 }
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 23105eb..0552e8d 100644
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
@@ -1343,8 +1347,7 @@ struct vfio_iommu_type1_info_dma_avail {
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
  *
- * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
- * unblock translation of host virtual addresses in the iova range.  The vaddr
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
  * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
  * maintain memory consistency within the user application, the updated vaddr
  * must address the same memory object as originally mapped.  Failure to do so
@@ -1395,9 +1398,9 @@ struct vfio_bitmap {
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

