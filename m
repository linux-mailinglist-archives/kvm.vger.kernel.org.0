Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2AF7ABCF5
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjIWB2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjIWB2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2617519B
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:27:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLXxMf023239;
        Sat, 23 Sep 2023 01:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=HCsh+LbRgvSIQPpbx8Nhxow9zhLf9uyvPiSaXl2fNiQ=;
 b=BAsargYwk5EjBhfstayfQjH7OfjZnGkx56KnEAkOXIk3GBL6UEj80iDKLEKpyedt3q9B
 vLyiEBg0kuUHKVyXwzx+6EuXWzy/xwD8a4A/FjzdbrGCm1D3Tu67BFSiIXjb0SQnOYUv
 d6we1rXruKyEwV/6Q2c5SYmI32KGyYvBJnQeMpVfUrn3RtcwAwTLotNRhM4BjVSZO3bf
 uA9Y96XiS2dVrbEVh0lsvbyltFYgaxJBl6PWJAcRpnCBX376w5GWprbPp21eApM5LKuZ
 gcsWb/PJmSy80L+b425XXjgtR9n92yYJbYn2JjtwpZCabSesuTx3mKte0jIyG+9b/qGp 0w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt034n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0ulGh007887;
        Sat, 23 Sep 2023 01:27:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hC040930;
        Sat, 23 Sep 2023 01:27:31 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-9;
        Sat, 23 Sep 2023 01:27:30 +0000
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
Subject: [PATCH v3 08/19] iommufd: Add IOMMU_HWPT_SET_DIRTY
Date:   Sat, 23 Sep 2023 02:25:00 +0100
Message-Id: <20230923012511.10379-9-joao.m.martins@oracle.com>
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=962 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-GUID: fEO5Fh8kDDh4hZnY4zvq2oVHxEBr2n7a
X-Proofpoint-ORIG-GUID: fEO5Fh8kDDh4hZnY4zvq2oVHxEBr2n7a
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every IOMMU driver should be able to implement the needed iommu domain ops
to control dirty tracking.

Connect a hw_pagetable to the IOMMU core dirty tracking ops, specifically
the ability to enable/disable dirty tracking on an IOMMU domain
(hw_pagetable id). To that end add an io_pagetable kernel API to toggle
dirty tracking:

* iopt_set_dirty_tracking(iopt, [domain], state)

The intended caller of this is via the hw_pagetable object that is created.

Internally it will ensure the leftover dirty state is cleared /right
before/ dirty tracking starts. This is also useful for iommu drivers
which may decide that dirty tracking is always-enabled at boot without
wanting to toggle dynamically via corresponding iommu domain op.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 21 ++++++++++
 drivers/iommu/iommufd/io_pagetable.c    | 56 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h | 11 +++++
 drivers/iommu/iommufd/main.c            |  3 ++
 include/uapi/linux/iommufd.h            | 27 ++++++++++++
 5 files changed, 118 insertions(+)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 32e259245314..22354b0ba554 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -198,3 +198,24 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	iommufd_put_object(&idev->obj);
 	return rc;
 }
+
+int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_hwpt_set_dirty *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct iommufd_ioas *ioas;
+	int rc = -EOPNOTSUPP;
+	bool enable;
+
+	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	ioas = hwpt->ioas;
+	enable = cmd->flags & IOMMU_DIRTY_TRACKING_ENABLED;
+
+	rc = iopt_set_dirty_tracking(&ioas->iopt, hwpt->domain, enable);
+
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index d70617447392..b9e58601d1d4 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -479,6 +479,62 @@ int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
 	down_read(&iopt->iova_rwsem);
 	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
 	up_read(&iopt->iova_rwsem);
+
+	return ret;
+}
+
+static int iopt_clear_dirty_data(struct io_pagetable *iopt,
+				 struct iommu_domain *domain)
+{
+	const struct iommu_dirty_ops *ops = domain->dirty_ops;
+	struct iommu_iotlb_gather gather;
+	struct iommu_dirty_bitmap dirty;
+	struct iopt_area *area;
+	int ret = 0;
+
+	lockdep_assert_held_read(&iopt->iova_rwsem);
+
+	iommu_dirty_bitmap_init(&dirty, NULL, &gather);
+
+	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+		if (!area->pages)
+			continue;
+
+		ret = ops->read_and_clear_dirty(domain,
+						iopt_area_iova(area),
+						iopt_area_length(area), 0,
+						&dirty);
+		if (ret)
+			break;
+	}
+
+	iommu_iotlb_sync(domain, &gather);
+	return ret;
+}
+
+int iopt_set_dirty_tracking(struct io_pagetable *iopt,
+			    struct iommu_domain *domain, bool enable)
+{
+	const struct iommu_dirty_ops *ops = domain->dirty_ops;
+	int ret = 0;
+
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	down_read(&iopt->iova_rwsem);
+
+	/* Clear dirty bits from PTEs to ensure a clean snapshot */
+	if (enable) {
+		ret = iopt_clear_dirty_data(iopt, domain);
+		if (ret)
+			goto out_unlock;
+	}
+
+	ret = ops->set_dirty_tracking(domain, enable);
+
+out_unlock:
+	up_read(&iopt->iova_rwsem);
 	return ret;
 }
 
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 84ec1df29074..1101a1914513 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -10,6 +10,7 @@
 #include <linux/uaccess.h>
 #include <linux/iommu.h>
 #include <linux/iova_bitmap.h>
+#include <uapi/linux/iommufd.h>
 
 struct iommu_domain;
 struct iommu_group;
@@ -83,6 +84,8 @@ int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
 				   struct iommu_domain *domain,
 				   unsigned long flags,
 				   struct iommufd_dirty_data *bitmap);
+int iopt_set_dirty_tracking(struct io_pagetable *iopt,
+			    struct iommu_domain *domain, bool enable);
 
 void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
 				 unsigned long length);
@@ -254,6 +257,14 @@ struct iommufd_hw_pagetable {
 	struct list_head hwpt_item;
 };
 
+static inline struct iommufd_hw_pagetable *iommufd_get_hwpt(
+					struct iommufd_ucmd *ucmd, u32 id)
+{
+	return container_of(iommufd_get_object(ucmd->ictx, id,
+					       IOMMUFD_OBJ_HW_PAGETABLE),
+			    struct iommufd_hw_pagetable, obj);
+}
+int iommufd_hwpt_set_dirty(struct iommufd_ucmd *ucmd);
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			   struct iommufd_device *idev, u32 flags,
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index e71523cbd0de..ec0c34086af3 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -315,6 +315,7 @@ union ucmd_buffer {
 	struct iommu_ioas_unmap unmap;
 	struct iommu_option option;
 	struct iommu_vfio_ioas vfio_ioas;
+	struct iommu_hwpt_set_dirty set_dirty;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
@@ -358,6 +359,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 val64),
 	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
 		 __reserved),
+	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
+		 struct iommu_hwpt_set_dirty, __reserved),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index cd94a9d8ce66..37079e72d243 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -47,6 +47,7 @@ enum {
 	IOMMUFD_CMD_VFIO_IOAS,
 	IOMMUFD_CMD_HWPT_ALLOC,
 	IOMMUFD_CMD_GET_HW_INFO,
+	IOMMUFD_CMD_HWPT_SET_DIRTY,
 };
 
 /**
@@ -454,4 +455,30 @@ struct iommu_hw_info {
 	__u32 __reserved;
 };
 #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
+
+/*
+ * enum iommufd_set_dirty_flags - Flags for steering dirty tracking
+ * @IOMMU_DIRTY_TRACKING_DISABLED: Disables dirty tracking
+ * @IOMMU_DIRTY_TRACKING_ENABLED: Enables dirty tracking
+ */
+enum iommufd_hwpt_set_dirty_flags {
+	IOMMU_DIRTY_TRACKING_DISABLED = 0,
+	IOMMU_DIRTY_TRACKING_ENABLED = 1,
+};
+
+/**
+ * struct iommu_hwpt_set_dirty - ioctl(IOMMU_HWPT_SET_DIRTY)
+ * @size: sizeof(struct iommu_hwpt_set_dirty)
+ * @flags: Flags to control dirty tracking status.
+ * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
+ *
+ * Toggle dirty tracking on an HW pagetable.
+ */
+struct iommu_hwpt_set_dirty {
+	__u32 size;
+	__u32 flags;
+	__u32 hwpt_id;
+	__u32 __reserved;
+};
+#define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
 #endif
-- 
2.17.2

