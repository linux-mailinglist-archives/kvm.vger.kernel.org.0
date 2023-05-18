Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80D87089D3
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjERUtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjERUtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:49:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107B4EE
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:48:56 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIxAnN015445;
        Thu, 18 May 2023 20:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=CY7DPvw82imjKSegForCze2+T0wx2g71jXQTjdS3kYg=;
 b=yvwl24vgUG6Vclh39wgaMI7zyrY0fRZn6yhn5oPU1oDOi/knfoswgXMFSlpVhGth4JRc
 Jcj6QQDo/y31EthnCVwuq+6yxunWQLAvqHlLo0z3s7YMj0DSnvJpPR/cJDksSd1S0xNt
 i2LLtrB4Qe27aSPhqFGDkAIxwboc/YWYU0n2ayP6RG50W7JsshNr0Dj8OUzfOqUsWe8O
 m5XRsWqZ18xfUOPVPMlafVaRSHcCZydFDII06aVP7K8o9zPw+mfVHXfORJ7+/IYkWhGt
 i6B+vZReH79Mc0nbO29Q+/OPR8GSkKedCifcR7nyrjRgVWalRK6amqC0SI6c+aXjBvbs UA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j3n57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJPApx032227;
        Thu, 18 May 2023 20:48:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10daf8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:48:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE3D033533;
        Thu, 18 May 2023 20:48:36 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-14;
        Thu, 18 May 2023 20:48:36 +0000
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
Subject: [PATCH RFCv2 13/24] iommufd: Add IOMMU_DEVICE_GET_CAPS
Date:   Thu, 18 May 2023 21:46:39 +0100
Message-Id: <20230518204650.14541-14-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-1-joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180171
X-Proofpoint-GUID: flZONY3ZXnpcPSNEL-7abX4_ZBbdmyhy
X-Proofpoint-ORIG-GUID: flZONY3ZXnpcPSNEL-7abX4_ZBbdmyhy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add IOMMU_DEVICE_GET_CAPS op for querying iommu capabilities for a given
device.

Capabilities are IOMMU agnostic and use device_iommu_capable() API passing
one of the IOMMU_CAP_*. Enumerate IOMMU_CAP_DIRTY for now in the out_caps
field returned back to userspace.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/device.c          | 26 +++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  1 +
 drivers/iommu/iommufd/main.c            |  3 +++
 include/uapi/linux/iommufd.h            | 23 ++++++++++++++++++++++
 4 files changed, 53 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 48d1300f0350..63e2ffe21653 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -263,6 +263,32 @@ u32 iommufd_device_to_id(struct iommufd_device *idev)
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
 
+int iommufd_device_get_caps(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_device_get_caps *cmd = ucmd->cmd;
+	struct iommufd_object *obj;
+	struct iommufd_device *idev;
+	int rc;
+
+	obj = iommufd_get_object(ucmd->ictx, cmd->dev_id, IOMMUFD_OBJ_DEVICE);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	idev = container_of(obj, struct iommufd_device, obj);
+
+	cmd->out_caps = 0;
+	if (device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY))
+		cmd->out_caps |= IOMMUFD_CAP_DIRTY_TRACKING;
+
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_put;
+
+out_put:
+	iommufd_put_object(obj);
+	return rc;
+}
+
 static int iommufd_group_setup_msi(struct iommufd_group *igroup,
 				   struct iommufd_hw_pagetable *hwpt)
 {
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 3de8046fee07..e5782459e4aa 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -246,6 +246,7 @@ int iommufd_option_rlimit_mode(struct iommu_option *cmd,
 int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
 int iommufd_check_iova_range(struct iommufd_ioas *ioas,
 			     struct iommufd_dirty_data *bitmap);
+int iommufd_device_get_caps(struct iommufd_ucmd *ucmd);
 
 /*
  * A HW pagetable is called an iommu_domain inside the kernel. This user object
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index f34b309a1baf..c4c6f900ef0a 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -279,6 +279,7 @@ union ucmd_buffer {
 	struct iommu_vfio_ioas vfio_ioas;
 	struct iommu_hwpt_set_dirty set_dirty;
 	struct iommu_hwpt_get_dirty_iova get_dirty_iova;
+	struct iommu_device_get_caps get_caps;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
@@ -324,6 +325,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 		 struct iommu_hwpt_set_dirty, __reserved),
 	IOCTL_OP(IOMMU_HWPT_GET_DIRTY_IOVA, iommufd_hwpt_get_dirty_iova,
 		 struct iommu_hwpt_get_dirty_iova, bitmap.data),
+	IOCTL_OP(IOMMU_DEVICE_GET_CAPS, iommufd_device_get_caps,
+		 struct iommu_device_get_caps, out_caps),
 #ifdef CONFIG_IOMMUFD_TEST
 	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
 #endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 44f9ddcfda58..c256f7354867 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -48,6 +48,7 @@ enum {
 	IOMMUFD_CMD_HWPT_ALLOC,
 	IOMMUFD_CMD_HWPT_SET_DIRTY,
 	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
+	IOMMUFD_CMD_DEVICE_GET_CAPS,
 };
 
 /**
@@ -442,4 +443,26 @@ struct iommu_hwpt_get_dirty_iova {
 };
 #define IOMMU_HWPT_GET_DIRTY_IOVA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA)
 
+
+/**
+ * enum iommufd_device_caps
+ * @IOMMU_CAP_DIRTY_TRACKING: IOMMU device support for dirty tracking
+ */
+enum iommufd_device_caps {
+	IOMMUFD_CAP_DIRTY_TRACKING = 1 << 0,
+};
+
+/*
+ * struct iommu_device_caps - ioctl(IOMMU_DEVICE_GET_CAPS)
+ * @size: sizeof(struct iommu_device_caps)
+ * @dev_id: the device to query
+ * @caps: IOMMU capabilities of the device
+ */
+struct iommu_device_get_caps {
+       __u32 size;
+       __u32 dev_id;
+       __aligned_u64 out_caps;
+};
+#define IOMMU_DEVICE_GET_CAPS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_GET_CAPS)
+
 #endif
-- 
2.17.2

