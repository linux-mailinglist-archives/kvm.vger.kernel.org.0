Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC6C7D1924
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjJTW3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjJTW3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:29:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DA219E
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:29:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KL4Krk008377;
        Fri, 20 Oct 2023 22:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=4y9peB+ghT5k2lHTFyUnVaQgmQ7u725sxtbleI4x8sA=;
 b=EctBxAL/WUi8OPAXppJkK0sBgOB8LHDubDXqCVRxIZeMCGi7IWzQFr4JscUfIRF9q6H3
 h+HqvOwoTTz0YCegqVwfmfmIB0HCd+bq1abeKt/voKFzApWAF31Arfb0xywghEHMG1Mt
 l7e0hqH9mc/vakKUzMXwxkpAbg4JmOm3CGeUmXe0DQ8rfOnd/sfh4kEQcj3/TsQGJph/
 UeiN8Xh7tiXytMYGQasibtcBzb7H0/DOQ3l37ORmK4/plppq5mEdfMstm6ICfhXsq73M
 DrTH8pTs277kUMh4X2eQ6n4aIPtFkWymweh+rmOiR1/ZGZQnYcUv1+EO7DH6roQoctcp 4g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwcjttw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KLn2CX025733;
        Fri, 20 Oct 2023 22:28:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwducuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 22:28:40 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KMSAsA018735;
        Fri, 20 Oct 2023 22:28:40 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-179-153.vpn.oracle.com [10.175.179.153])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3tubwduch3-9;
        Fri, 20 Oct 2023 22:28:39 +0000
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
Subject: [PATCH v5 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
Date:   Fri, 20 Oct 2023 23:27:54 +0100
Message-Id: <20231020222804.21850-9-joao.m.martins@oracle.com>
In-Reply-To: <20231020222804.21850-1-joao.m.martins@oracle.com>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=959 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200191
X-Proofpoint-ORIG-GUID: i_SZa3S9XJXtUGikdnWVeKYWCeoLlKB2
X-Proofpoint-GUID: i_SZa3S9XJXtUGikdnWVeKYWCeoLlKB2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend IOMMUFD_CMD_GET_HW_INFO op to query generic iommu capabilities for a
given device.

Capabilities are IOMMU agnostic and use device_iommu_capable() API passing
one of the IOMMU_CAP_*. Enumerate IOMMU_CAP_DIRTY_TRACKING for now in the
out_capabilities field returned back to userspace.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/iommufd/device.c |  4 ++++
 include/uapi/linux/iommufd.h   | 17 +++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index e88fa73a45e6..2a41fd2b6ef8 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -1185,6 +1185,10 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
 	 */
 	cmd->data_len = data_len;
 
+	cmd->out_capabilities = 0;
+	if (device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY_TRACKING))
+		cmd->out_capabilities |= IOMMU_HW_CAP_DIRTY_TRACKING;
+
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 out_free:
 	kfree(data);
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 06724bbe8af3..b8b3d7edfcb9 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -419,6 +419,20 @@ enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_INTEL_VTD,
 };
 
+/**
+ * enum iommufd_hw_info_capabilities
+ * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
+ *                               If available, it means the following APIs
+ *                               are supported:
+ *
+ *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
+ *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
+ *
+ */
+enum iommufd_hw_capabilities {
+	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
+};
+
 /**
  * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
  * @size: sizeof(struct iommu_hw_info)
@@ -430,6 +444,8 @@ enum iommu_hw_info_type {
  *             the iommu type specific hardware information data
  * @out_data_type: Output the iommu hardware info type as defined in the enum
  *                 iommu_hw_info_type.
+ * @out_capabilities: Output the generic iommu capability info type as defined
+ *                    in the enum iommu_hw_capabilities.
  * @__reserved: Must be 0
  *
  * Query an iommu type specific hardware information data from an iommu behind
@@ -454,6 +470,7 @@ struct iommu_hw_info {
 	__aligned_u64 data_uptr;
 	__u32 out_data_type;
 	__u32 __reserved;
+	__aligned_u64 out_capabilities;
 };
 #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
 
-- 
2.17.2

