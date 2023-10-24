Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED907D534B
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343673AbjJXNzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbjJXNzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0AB6A61
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:26 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCKD99017406;
        Tue, 24 Oct 2023 13:51:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=CHKg1G/BOToT6aNXYtNTeUtSiaPv8uegCtIcXCQmWRs=;
 b=QCohNs10xS4pN6TseWvK9nDaXPiHyZTUXCRkAhtlh9E4wyqxbsLPNnEkaJxNBUaTGzWk
 f6P+uKux35u1+NxDfI/89uAq2TCApVXD2v8TiXcPL8mA7ZzINu3EBsxFXUMThRo1USiF
 eQ7hkChG0VesC4nVJWl+5tS1o9j7vZkaGt2ZkIWxZ6IOZ9do8Y9F9Nu2hcemMm3uPcgi
 B1soffVEmQYwEDSxoQZP+WVZPhWaM/EnDGcBnqy/zOxL5QQI+CB4QcZ29rMIEfgPu7fV
 qpandX1zarV+0CkNEjQJAuspuiW5WzuiTGAYu3r+ervzOyxobDQyT7EjF00u34ouEcLj 3g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv6hanf10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCZWKH034685;
        Tue, 24 Oct 2023 13:51:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53592dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:54 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL96030007;
        Tue, 24 Oct 2023 13:51:53 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-9;
        Tue, 24 Oct 2023 13:51:53 +0000
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
Subject: [PATCH v6 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
Date:   Tue, 24 Oct 2023 14:50:59 +0100
Message-Id: <20231024135109.73787-9-joao.m.martins@oracle.com>
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_14,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=959 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240118
X-Proofpoint-GUID: GLT35yuH3-mx8pt8sTAL3MFCHfJVf_qf
X-Proofpoint-ORIG-GUID: GLT35yuH3-mx8pt8sTAL3MFCHfJVf_qf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
index dce38e32ca84..036ebc6c19cf 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -418,6 +418,20 @@ enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_INTEL_VTD,
 };
 
+/**
+ * enum iommufd_hw_capabilities
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
@@ -429,6 +443,8 @@ enum iommu_hw_info_type {
  *             the iommu type specific hardware information data
  * @out_data_type: Output the iommu hardware info type as defined in the enum
  *                 iommu_hw_info_type.
+ * @out_capabilities: Output the generic iommu capability info type as defined
+ *                    in the enum iommu_hw_capabilities.
  * @__reserved: Must be 0
  *
  * Query an iommu type specific hardware information data from an iommu behind
@@ -453,6 +469,7 @@ struct iommu_hw_info {
 	__aligned_u64 data_uptr;
 	__u32 out_data_type;
 	__u32 __reserved;
+	__aligned_u64 out_capabilities;
 };
 #define IOMMU_GET_HW_INFO _IO(IOMMUFD_TYPE, IOMMUFD_CMD_GET_HW_INFO)
 
-- 
2.17.2

