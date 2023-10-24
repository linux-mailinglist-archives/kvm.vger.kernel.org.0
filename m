Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7867D534D
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbjJXNzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbjJXNzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360C165A8
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCJPwo003626;
        Tue, 24 Oct 2023 13:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=gjCVfWXlLnDh9LiMbo9Gpsimh7Byx9I5zxCgAGk/js4=;
 b=CNnoRmenYK0mh11FrelYqFJsrnulivC6NtxNCdv//Jb7ShbalKu4/HQyp2LzpUU/woMk
 Y54DR+eVLgLDc1D4YgZNr/JDRVrdchdwEP0tmC87eHguCUQVsN5pwe38oLjE2rLm2euO
 vtjW2yHDXlhfzHYXafisnrPgX5drp44wWIkROA6ZyqmuBmpLCanoSZU138Ewbm5z6cbm
 Lm0bnuaLYm7b++fRyfzRvG9Pg1Q0wRNx/5venx+P3XiNN4kAkhW717KnVrgBmVEeSnqD
 doFIBaLcOASaiiSoHA6OkvcpsyMqJRnG/DqyB9hq4Xtk+lFu0S9oCDvzIZVMDNpqZKkn 1w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv52dwgmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCrT1h034687;
        Tue, 24 Oct 2023 13:51:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv5359278-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL90030007;
        Tue, 24 Oct 2023 13:51:41 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-6;
        Tue, 24 Oct 2023 13:51:41 +0000
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
Subject: [PATCH v6 05/18] iommufd: Add a flag to enforce dirty tracking on attach
Date:   Tue, 24 Oct 2023 14:50:56 +0100
Message-Id: <20231024135109.73787-6-joao.m.martins@oracle.com>
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_14,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240118
X-Proofpoint-ORIG-GUID: eg14uLA70F8aTm8l_ylWMlCSZC00HdVz
X-Proofpoint-GUID: eg14uLA70F8aTm8l_ylWMlCSZC00HdVz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Throughout IOMMU domain lifetime that wants to use dirty tracking, some
guarantees are needed such that any device attached to the iommu_domain
supports dirty tracking.

The idea is to handle a case where IOMMU in the system are assymetric
feature-wise and thus the capability may not be supported for all devices.
The enforcement is done by adding a flag into HWPT_ALLOC namely:

	IOMMU_HWPT_ALLOC_DIRTY_TRACKING

.. Passed in HWPT_ALLOC ioctl() flags. The enforcement is done by creating
a iommu_domain via domain_alloc_user() and validating the requested flags
with what the device IOMMU supports (and failing accordingly) advertised).
Advertising the new IOMMU domain feature flag requires that the individual
iommu driver capability is supported when a future device attachment
happens.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/iommufd/hw_pagetable.c | 4 +++-
 include/uapi/linux/iommufd.h         | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 8b3d2875d642..dd50ca9e2c09 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -157,7 +157,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	struct iommufd_ioas *ioas;
 	int rc;
 
-	if ((cmd->flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT)) || cmd->__reserved)
+	if ((cmd->flags & ~(IOMMU_HWPT_ALLOC_NEST_PARENT |
+			    IOMMU_HWPT_ALLOC_DIRTY_TRACKING)) ||
+	    cmd->__reserved)
 		return -EOPNOTSUPP;
 
 	idev = iommufd_get_device(ucmd, cmd->dev_id);
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index be7a95042677..c76248410120 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -351,9 +351,12 @@ struct iommu_vfio_ioas {
  * enum iommufd_hwpt_alloc_flags - Flags for HWPT allocation
  * @IOMMU_HWPT_ALLOC_NEST_PARENT: If set, allocate a HWPT that can serve as
  *                                the parent HWPT in a nesting configuration.
+ * @IOMMU_HWPT_ALLOC_DIRTY_TRACKING: Dirty tracking support for device IOMMU is
+ *                                   enforced on device attachment
  */
 enum iommufd_hwpt_alloc_flags {
 	IOMMU_HWPT_ALLOC_NEST_PARENT = 1 << 0,
+	IOMMU_HWPT_ALLOC_DIRTY_TRACKING = 1 << 1,
 };
 
 /**
-- 
2.17.2

