Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63AA7ABCFB
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjIWB2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjIWB2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F811B1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:01 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLXvpi004323;
        Sat, 23 Sep 2023 01:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=8i/3M2S061YwgEH8Lh9q7iEzTlF7Z9RtgbUswkZp09s=;
 b=M4ntg8udDhiFdz8zdWPK54/Ibhme1IAurtHmMrUTVE4z7YkRm6XNhvKuzpx9RI1KI3fX
 Z80E5OhRgtIftVXIai/bHK3jANy7ZXZouocKC+B4ultBPaF16JE1aor8fFvuR7apUcDt
 zNzmIGBPeKZbFqrXCsxJQbJ+n32zb+Q7lMCYMJbqWEGU5lTLFaLE2aiw+/jzA8CSICXn
 ipv80HsqiJtGCnIpx7SN5hqwNFRZ4t7uZgMpv5wvuAnnp7xAAvjub8KTg7oQo49gk8rL
 tkjNFNiMRBWn0B++ctCFkAs5oIknTxSz7aCY34cVEjBT80Y+56ZO13WQvcSRntiodEsD 7g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tswk4f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N092kH007661;
        Sat, 23 Sep 2023 01:27:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:38 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hG040930;
        Sat, 23 Sep 2023 01:27:37 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-11;
        Sat, 23 Sep 2023 01:27:37 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 10/19] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Date:   Sat, 23 Sep 2023 02:25:02 +0100
Message-Id: <20230923012511.10379-11-joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-GUID: FQGH35zZI1F3KWOBZJksnSF5Q4xKL-5z
X-Proofpoint-ORIG-GUID: FQGH35zZI1F3KWOBZJksnSF5Q4xKL-5z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Connect a hw_pagetable to the IOMMU core dirty tracking
read_and_clear_dirty iommu domain op. It exposes all of the functionality
for the UAPI that read the dirtied IOVAs while clearing the Dirty bits from
the PTEs

In doing so the previously internal iommufd_dirty_data structure is moved
over as the UAPI intermediate structure for representing iommufd dirty
bitmaps.

Contrary to past incantation of a similar interface in VFIO the IOVA range
to be scanned is tied in to the bitmap size, thus the application needs to
pass a appropriately sized bitmap address taking into account the iova
range being passed *and* page size ... as opposed to allowing
bitmap-iova != iova.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 55 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h | 11 ++---
 drivers/iommu/iommufd/main.c            |  3 ++
 include/uapi/linux/iommufd.h            | 36 ++++++++++++++++
 4 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 22354b0ba554..a5712992bb4b 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -219,3 +219,58 @@ int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(&hwpt->obj);
 	return rc;
 }
+
+int iommufd_check_iova_range(struct iommufd_ioas *ioas,
+			     struct iommufd_dirty_data *bitmap)
+{
+	unsigned long pgshift, npages;
+	size_t iommu_pgsize;
+	int rc = -EINVAL;
+
+	pgshift = __ffs(bitmap->page_size);
+	npages = bitmap->length >> pgshift;
+
+	if (!npages || (npages > ULONG_MAX))
+		return rc;
+
+	iommu_pgsize = 1 << __ffs(ioas->iopt.iova_alignment);
+
+	/* allow only smallest supported pgsize */
+	if (bitmap->page_size != iommu_pgsize)
+		return rc;
+
+	if (bitmap->iova & (iommu_pgsize - 1))
+		return rc;
+
+	if (!bitmap->length || bitmap->length & (iommu_pgsize - 1))
+		return rc;
+
+	return 0;
+}
+
+int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_hwpt_get_dirty_iova *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_ioas *ioas;
+	int rc = -EOPNOTSUPP;
+
+	if ((cmd->flags || cmd->__reserved))
+		return -EOPNOTSUPP;
+
+	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	ioas = hwpt->ioas;
+	rc = iommufd_check_iova_range(ioas, &cmd->bitmap);
+	if (rc)
+		goto out_put;
+
+	rc = iopt_read_and_clear_dirty_data(&ioas->iopt, hwpt->domain,
+					    cmd->flags, &cmd->bitmap);
+
+out_put:
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 1101a1914513..608bb6eae64b 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -73,13 +73,6 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length, unsigned long *unmapped);
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);
 
-struct iommufd_dirty_data {
-	unsigned long iova;
-	unsigned long length;
-	unsigned long page_size;
-	unsigned long long *data;
-};
-
 int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
 				   struct iommu_domain *domain,
 				   unsigned long flags,
@@ -239,6 +232,8 @@ int iommufd_option_rlimit_mode(struct iommu_option *cmd,
 			       struct iommufd_ctx *ictx);
 
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
+int iommufd_check_iova_range(struct iommufd_ioas *ioas,
+			     struct iommufd_dirty_data *bitmap);
 
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
@@ -265,6 +260,8 @@ static inline struct iommufd_hw_pagetable *iommufd_get_hwpt(
 			    struct iommufd_hw_pagetable, obj);
 }
 int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd);
+int iommufd_hwpt_get_dirty_iova(struct iommufd_ucmd *ucmd);
+
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			   struct iommufd_device *idev, u32 flags,
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index ec0c34086af3..17e356ffdf31 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -316,6 +316,7 @@ union ucmd_buffer {
 	struct iommu_option option;
 	struct iommu_vfio_ioas vfio_ioas;
 	struct iommu_hwpt_set_dirty set_dirty;
+	struct iommu_hwpt_get_dirty_iova get_dirty_iova;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
@@ -361,6 +362,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
 		 struct iommu_hwpt_set_dirty, __reserved),
+	IOCTL_OP(IOMMU_HWPT_GET_DIRTY_IOVA, iommufd_hwpt_get_dirty_iova,
+		 struct iommu_hwpt_get_dirty_iova, bitmap.data),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 37079e72d243..b35b7d0c4be0 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -48,6 +48,7 @@ enum {
 	IOMMUFD_CMD_HWPT_ALLOC,
 	IOMMUFD_CMD_GET_HW_INFO,
 	IOMMUFD_CMD_HWPT_SET_DIRTY,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
 };
 
 /**
@@ -481,4 +482,39 @@ struct iommu_hwpt_set_dirty {
 	__u32 __reserved;
 };
 #define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
+
+/**
+ * struct iommufd_dirty_bitmap - Dirty IOVA tracking bitmap
+ * @iova: base IOVA of the bitmap
+ * @length: IOVA size
+ * @page_size: page size granularity of each bit in the bitmap
+ * @data: bitmap where to set the dirty bits. The bitmap bits each
+ * represent a page_size which you deviate from an arbitrary iova.
+ * Checking a given IOVA is dirty:
+ *
+ *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
+ */
+struct iommufd_dirty_data {
+	__aligned_u64 iova;
+	__aligned_u64 length;
+	__aligned_u64 page_size;
+	__aligned_u64 *data;
+};
+
+/**
+ * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
+ * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
+ * @flags: Flags to control dirty tracking status.
+ * @bitmap: Bitmap of the range of IOVA to read out
+ */
+struct iommu_hwpt_get_dirty_iova {
+	__u32 size;
+	__u32 hwpt_id;
+	__u32 flags;
+	__u32 __reserved;
+	struct iommufd_dirty_data bitmap;
+};
+#define IOMMU_HWPT_GET_DIRTY_IOVA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA)
+
 #endif
-- 
2.17.2

