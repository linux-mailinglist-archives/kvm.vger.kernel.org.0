Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDFF7CE8D7
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbjJRU2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjJRU2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:28:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899D5D5F
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:28:06 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIn0Ln011270;
        Wed, 18 Oct 2023 20:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=rLUtQekzpFTB5p+HDomm27CcdrV/PU0co9zd2oIprts=;
 b=ND0PQi+v9v3/XFqeMarDmXIYEs7v8rQ+MGpXcdxdYeSckhssNtz0vf26iKQFxR3ebugU
 WZTQ8TkKIUTTYwIybsE5B8IddoxPzyYKvUpqda4coBL06y0NryutTy6lJw9KiIHbpZTN
 4qUyIDT14SCL2iId9OM5wA9Qz75tFwqdsnz0w9hJeNp99ceDQZuOw4V+5yZeE2WqWfG6
 oRWUq4JlI9CFSbRZx0sUQu5p0APMC5LvL6jiKspsxjEkBDNx4GY+zNT2FoG9olq7MlFz
 2kJrRCgq4FVCgLk7Te04dBJIutV2TQr/wALaqkaVO25aP27DiWuusZqYDxYAOC8Ni1Ad jw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cgng8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IJU4Cm009149;
        Wed, 18 Oct 2023 20:27:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps74s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:48 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5Z040635;
        Wed, 18 Oct 2023 20:27:47 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-7;
        Wed, 18 Oct 2023 20:27:47 +0000
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
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Date:   Wed, 18 Oct 2023 21:27:03 +0100
Message-Id: <20231018202715.69734-7-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-1-joao.m.martins@oracle.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=899 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180168
X-Proofpoint-ORIG-GUID: uE539rOCSM1Uvb1I9Rd0DjJr1v2-D0go
X-Proofpoint-GUID: uE539rOCSM1Uvb1I9Rd0DjJr1v2-D0go
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
before/ dirty tracking starts. This is also useful for iommu drivers which
may decide that dirty tracking is always-enabled at boot without wanting to
toggle dynamically via corresponding iommu domain op.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c    | 24 +++++++++++
 drivers/iommu/iommufd/io_pagetable.c    | 55 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h | 12 ++++++
 drivers/iommu/iommufd/main.c            |  3 ++
 include/uapi/linux/iommufd.h            | 25 +++++++++++
 5 files changed, 119 insertions(+)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 2b9ff3850bb8..85a0f696c744 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -196,3 +196,27 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
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
+	if (cmd->flags & ~IOMMU_DIRTY_TRACKING_ENABLE)
+		return rc;
+
+	hwpt = iommufd_get_hwpt(ucmd, cmd->hwpt_id);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	ioas = hwpt->ioas;
+	enable = cmd->flags & IOMMU_DIRTY_TRACKING_ENABLE;
+
+	rc = iopt_set_dirty_tracking(&ioas->iopt, hwpt->domain, enable);
+
+	iommufd_put_object(&hwpt->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 3a598182b761..535d73466e15 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -412,6 +412,61 @@ int iopt_map_user_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 	return 0;
 }
 
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
+	return ret;
+}
+
 int iopt_get_pages(struct io_pagetable *iopt, unsigned long iova,
 		   unsigned long length, struct list_head *pages_list)
 {
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 3064997a0181..d42e01cc1105 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -8,6 +8,7 @@
 #include <linux/xarray.h>
 #include <linux/refcount.h>
 #include <linux/uaccess.h>
+#include <uapi/linux/iommufd.h>
 
 struct iommu_domain;
 struct iommu_group;
@@ -70,6 +71,9 @@ int iopt_unmap_iova(struct io_pagetable *iopt, unsigned long iova,
 		    unsigned long length, unsigned long *unmapped);
 int iopt_unmap_all(struct io_pagetable *iopt, unsigned long *unmapped);
 
+int iopt_set_dirty_tracking(struct io_pagetable *iopt,
+			    struct iommu_domain *domain, bool enable);
+
 void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
 				 unsigned long length);
 int iopt_table_add_domain(struct io_pagetable *iopt,
@@ -240,6 +244,14 @@ struct iommufd_hw_pagetable {
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
index e71523cbd0de..2e625b280d61 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -307,6 +307,7 @@ union ucmd_buffer {
 	struct iommu_destroy destroy;
 	struct iommu_hw_info info;
 	struct iommu_hwpt_alloc hwpt;
+	struct iommu_hwpt_set_dirty set_dirty;
 	struct iommu_ioas_alloc alloc;
 	struct iommu_ioas_allow_iovas allow_iovas;
 	struct iommu_ioas_copy ioas_copy;
@@ -342,6 +343,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 __reserved),
 	IOCTL_OP(IOMMU_HWPT_ALLOC, iommufd_hwpt_alloc, struct iommu_hwpt_alloc,
 		 __reserved),
+	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
+		 struct iommu_hwpt_set_dirty, __reserved),
 	IOCTL_OP(IOMMU_IOAS_ALLOC, iommufd_ioas_alloc_ioctl,
 		 struct iommu_ioas_alloc, out_ioas_id),
 	IOCTL_OP(IOMMU_IOAS_ALLOW_IOVAS, iommufd_ioas_allow_iovas,
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index cd94a9d8ce66..9e1721e38819 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -47,6 +47,7 @@ enum {
 	IOMMUFD_CMD_VFIO_IOAS,
 	IOMMUFD_CMD_HWPT_ALLOC,
 	IOMMUFD_CMD_GET_HW_INFO,
+	IOMMUFD_CMD_HWPT_SET_DIRTY,
 };
 
 /**
@@ -454,4 +455,28 @@ struct iommu_hw_info {
 	__u32 __reserved;
 };
 #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
+
+/*
+ * enum iommufd_set_dirty_flags - Flags for steering dirty tracking
+ * @IOMMU_DIRTY_TRACKING_ENABLE: Enables dirty tracking
+ */
+enum iommufd_hwpt_set_dirty_flags {
+	IOMMU_DIRTY_TRACKING_ENABLE = 1,
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

