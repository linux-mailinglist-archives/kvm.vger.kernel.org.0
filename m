Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7740B64B8EC
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbiLMPtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236348AbiLMPtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:49:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A0D20BD3
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 07:47:02 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDtn79014504;
        Tue, 13 Dec 2022 15:47:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=NhUry3N3ik+0R8lKag90X6uV3XCOdWuIYxF31km3vvE=;
 b=Ak8Wue21+D3fwtOe810Mo4zO8DczdQWwURrQBDAW2mtHYy0oiMwxkPi73lSJsnkDO8Rh
 AL+i5NeUUlFfr+dDAZhBOXslec9Y/yj1ajO6E04BCTwtIRnM90l94I7mR7kQppXHOvX4
 /EWzFWzF2ePbJmT/7Nt6A9dFVnbmDS2LJ0nPTqDyImpQrsxVkt5YFjJohhXeKtNihoQC
 NjveeG8re6gnSD78CmnPXcBx+jG15YQ/kFhjiyOAlczKqxxPZxn1afVXfpOM+wEDj/D5
 ApuZeyYdgbpUfIW0o1S7QuZb6s9sqdYb7FTUd06aW3exmrrPm13jIsFRakzj1m6DLvrb SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mch1a5rqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:47:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDFCVHe040184;
        Tue, 13 Dec 2022 15:46:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgjcg42n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:46:58 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFgwtI031631;
        Tue, 13 Dec 2022 15:46:58 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3mcgjcg40c-2;
        Tue, 13 Dec 2022 15:46:58 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 1/2] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Date:   Tue, 13 Dec 2022 07:46:55 -0800
Message-Id: <1670946416-155307-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130139
X-Proofpoint-GUID: YtZTwrcuV-agJ7-UZ1HpVQbF4o-m_qB1
X-Proofpoint-ORIG-GUID: YtZTwrcuV-agJ7-UZ1HpVQbF4o-m_qB1
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

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 25 ++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       |  6 +++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe..f81e925 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1343,6 +1343,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
+	/* Cannot update vaddr if mdev is present. */
+	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
+		goto unlock;
+
 	pgshift = __ffs(iommu->pgsize_bitmap);
 	pgsize = (size_t)1 << pgshift;
 
@@ -2189,6 +2193,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
+	/* Prevent an mdev from sneaking in while vaddr flags are used. */
+	if (iommu->vaddr_invalid_count && type == VFIO_EMULATED_IOMMU)
+		goto out_unlock;
+
 	/* Check for duplicates */
 	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
 		goto out_unlock;
@@ -2660,6 +2668,20 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
 	return ret;
 }
 
+/*
+ * Disable this feature if mdevs are present.  They cannot safely pin/unpin
+ * while vaddrs are being updated.
+ */
+static int vfio_iommu_can_update_vaddr(struct vfio_iommu *iommu)
+{
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	ret = list_empty(&iommu->emulated_iommu_groups);
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 					    unsigned long arg)
 {
@@ -2668,8 +2690,9 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1v2_IOMMU:
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
-	case VFIO_UPDATE_VADDR:
 		return 1;
+	case VFIO_UPDATE_VADDR:
+		return iommu && vfio_iommu_can_update_vaddr(iommu);
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
 			return 0;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d7d8e09..6d36b84 100644
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
-- 
1.8.3.1

