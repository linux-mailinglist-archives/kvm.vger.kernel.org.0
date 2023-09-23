Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AB27ABCFD
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjIWB2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjIWB2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A487E8
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:06 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLYkNx010127;
        Sat, 23 Sep 2023 01:27:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=6IB9dl0KkU7ns1baLsRIGk/jhhMJ8XBlcAo3u3d9ttU=;
 b=DGoytt2Gp14DTD3tZCL8Kow8l7VNIWXpYKG/gJv0vfRF/yU/WmfB4gmA2y1pzAB5QhR7
 jv6r2Ek1YfWaxDcgchEIp6Nczp2sRw4uUQCzW2O3IYfn9wzRFshKc0M964cAslupQXEc
 ddK+C2N8FrARTKusb2XnyQwdlixAqRS75k/McJjk6D3yJgyTyuIlbvHuzvxZJ1Z4yat5
 5wOkPpvvuqz2Kr/Bzsv+KDPuM9MhlHqSuu5w4FBcGUydPQc0tmjqMvALTWAUUPcPGojX
 0nV2ZZ4tj1CnwbF+9hyI2C0QDlkqLANiE1eRFLFn1uAcwxTTllGnKYRxp/Z7xDOUQMIk bg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvu314-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0dTxX007693;
        Sat, 23 Sep 2023 01:27:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:45 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hK040930;
        Sat, 23 Sep 2023 01:27:44 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-13;
        Sat, 23 Sep 2023 01:27:44 +0000
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
Subject: [PATCH v3 12/19] iommufd: Add capabilities to IOMMU_GET_HW_INFO
Date:   Sat, 23 Sep 2023 02:25:04 +0100
Message-Id: <20230923012511.10379-13-joao.m.martins@oracle.com>
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
X-Proofpoint-ORIG-GUID: yIJ_uIIK2tPHl-Jel4Z-DE1X-EeWjTz8
X-Proofpoint-GUID: yIJ_uIIK2tPHl-Jel4Z-DE1X-EeWjTz8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend IOMMUFD_CMD_GET_HW_INFO op to query generic iommu capabilities
for a given device.

Capabilities are IOMMU agnostic and use device_iommu_capable() API passing
one of the IOMMU_CAP_*. Enumerate IOMMU_CAP_DIRTY for now in the
out_capabilities field returned back to userspace.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/device.c |  4 ++++
 include/uapi/linux/iommufd.h   | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index e88fa73a45e6..71ee22dc1a85 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -1185,6 +1185,10 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 	 */
 	cmd->data_len = data_len;
 
+	cmd->out_capabilities = 0;
+	if (device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY))
+		cmd->out_capabilities |= IOMMU_HW_CAP_DIRTY_TRACKING;
+
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 out_free:
 	kfree(data);
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b35b7d0c4be0..34703683eb8e 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -419,6 +419,14 @@ enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_INTEL_VTD,
 };
 
+/**
+ * enum iommufd_hw_info_capabilities
+ * @IOMMU_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
+ */
+enum iommufd_hw_capabilities {
+	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
+};
+
 /**
  * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
  * @size: sizeof(struct iommu_hw_info)
@@ -430,6 +438,8 @@ enum iommu_hw_info_type {
  *             the iommu type specific hardware information data
  * @out_data_type: Output the iommu hardware info type as defined in the enum
  *                 iommu_hw_info_type.
+ * @out_capabilities: Output the iommu capability info type as defined in the
+ *                    enum iommu_hw_capabilities.
  * @__reserved: Must be 0
  *
  * Query an iommu type specific hardware information data from an iommu behind
@@ -454,6 +464,7 @@ struct iommu_hw_info {
 	__aligned_u64 data_uptr;
 	__u32 out_data_type;
 	__u32 __reserved;
+	__aligned_u64 out_capabilities;
 };
 #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
 
-- 
2.17.2

