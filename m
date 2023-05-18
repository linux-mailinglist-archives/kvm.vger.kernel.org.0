Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E797089D0
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjERUtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjERUtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:49:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C2110E9
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:48:43 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx5mj025244;
        Thu, 18 May 2023 20:48:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Zo1jLF/mimg0CRENi9hdWwSatdNwv2JQ/hbvjLQOaQk=;
 b=R5y+MfQeheDzytVuFdVjovz0EYXqco4w5hDnxvb4iTfIFE3lKs2ioOKkiN/hvLtFexVi
 0jeaKbVmGUAoL2RhupvDBkExDYZXFmSbJCAlvsmQ3J2J/cbXS01SLRhXlJVtVlLnWWqF
 Lzo/i2RqodXXHM6gVjzunLka06/EFdRNdTqw+6UkJ8La960wWmTQKgSrSD+oqFs6PBuS
 qwdJNttJvgrBP8wqsOiXk/Xp+RQRHGfvQk5crE+CyBTHdzK7kI6xI3IwH5/7E6NccJ8R
 OwaGF6tOl67ck+5fl3gIxB8fGrisE2d8wYrOayELyPLhTdkPwgnNvj9WHPgfql+HjCu3 RQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fc97dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IKXqwQ032130;
        Thu, 18 May 2023 20:48:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10daeyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE35033533;
        Thu, 18 May 2023 20:48:20 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-10;
        Thu, 18 May 2023 20:48:19 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH RFCv2 09/24] iommufd: Add IOMMU_HWPT_SET_DIRTY
Date:   Thu, 18 May 2023 21:46:35 +0100
Message-Id: <20230518204650.14541-10-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-1-joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=881 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180171
X-Proofpoint-ORIG-GUID: wDOjp4O33BkPZTujXR17B-FiRDBN-kVe
X-Proofpoint-GUID: wDOjp4O33BkPZTujXR17B-FiRDBN-kVe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Internally we will ensure the leftover dirty state is cleared /right
before/ we start dirty tracking. This is also useful for iommu drivers
which may decide that dirty tracking is always-enabled without being
able to disable it via iommu domain op.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 24 +++++++++++++++++
 drivers/iommu/iommufd/io_pagetable.c    | 36 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h | 11 ++++++++
 drivers/iommu/iommufd/main.c            |  3 +++
 include/uapi/linux/iommufd.h            | 27 +++++++++++++++++++
 5 files changed, 101 insertions(+)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 4f0b72737ae2..7acbd88d05b7 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -200,3 +200,27 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
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
+	if (!hwpt->enforce_dirty)
+		return -EOPNOTSUPP;
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
index 187626e5f2bc..01adb0f7e4d0 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -479,6 +479,42 @@ int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
 	down_read(&iopt->iova_rwsem);
 	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
 	up_read(&iopt->iova_rwsem);
+
+	return ret;
+}
+
+int iopt_set_dirty_tracking(struct io_pagetable *iopt,
+			    struct iommu_domain *domain, bool enable)
+{
+	const struct iommu_domain_ops *ops = domain->ops;
+	struct iommu_dirty_bitmap dirty;
+	struct iommu_iotlb_gather gather;
+	struct iopt_area *area;
+	int ret = 0;
+
+	if (!ops->set_dirty_tracking)
+		return -EOPNOTSUPP;
+
+	iommu_dirty_bitmap_init(&dirty, NULL, &gather);
+
+	down_write(&iopt->iova_rwsem);
+	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX);
+	     area && enable;
+	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+		ret = ops->read_and_clear_dirty(domain,
+						iopt_area_iova(area),
+						iopt_area_length(area), 0,
+						&dirty);
+		if (ret)
+			goto out_unlock;
+	}
+
+	iommu_iotlb_sync(domain, &gather);
+
+	ret = ops->set_dirty_tracking(domain, enable);
+
+out_unlock:
+	up_write(&iopt->iova_rwsem);
 	return ret;
 }
 
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 2259b15340e4..e902197a6a42 100644
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
@@ -267,6 +270,14 @@ struct iommufd_hw_pagetable {
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
 			   struct iommufd_device *idev, bool immediate_attach,
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 3932fe26522b..8c4640df0547 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -277,6 +277,7 @@ union ucmd_buffer {
 	struct iommu_ioas_unmap unmap;
 	struct iommu_option option;
 	struct iommu_vfio_ioas vfio_ioas;
+	struct iommu_hwpt_set_dirty set_dirty;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
@@ -318,6 +319,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 val64),
 	IOCTL_OP(IOMMU_VFIO_IOAS, iommufd_vfio_ioas, struct iommu_vfio_ioas,
 		 __reserved),
+	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
+		 struct iommu_hwpt_set_dirty, __reserved),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 1cd9c54d0f64..85498f14b3ae 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -46,6 +46,7 @@ enum {
 	IOMMUFD_CMD_OPTION,
 	IOMMUFD_CMD_VFIO_IOAS,
 	IOMMUFD_CMD_HWPT_ALLOC,
+	IOMMUFD_CMD_HWPT_SET_DIRTY,
 };
 
 /**
@@ -379,4 +380,30 @@ struct iommu_hwpt_alloc {
 	__u32 __reserved;
 };
 #define IOMMU_HWPT_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_ALLOC)
+
+/**
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

