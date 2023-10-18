Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA187CE8D3
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjJRU2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjJRU2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:28:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133CAD5E
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:28:04 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IInBQo013673;
        Wed, 18 Oct 2023 20:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Town9GbQlTo+/FlK56P7nT+8MX0TtLr4U610AKUuE58=;
 b=EBFjwnRhJTb9Ck2LnxPDLHlxRkBA81fBqSgaJ120H3xHWrfIG9H1FCHZIXKYt43y4QnC
 lBK+Rin03/IN+SsbtyQ7WDQAUef5xacNiQuAHPNBCWU2yyvb/O345xBB/4w+DwVgfs3I
 67h2ygG3tQ1Rd/AvtO+N6EfUEbww60OkGLsPU6bbzYl2LjjMThpwytYnsMHWW7BnLJ/P
 8mJLq8DBugvDZaCrCOdsL4r9cenD/JslZEDuVCkplSLshrOjTe8WqHJaskZZPdEoma00
 hhcYdPb2x6ODQAET5tinPyq8ciFZ98VjqyqnJ0YEBBn7rHImLgJwcNgM3vieEBSfdti7 DA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1d0hbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IKQKr5010606;
        Wed, 18 Oct 2023 20:27:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps73f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:27:44 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5X040635;
        Wed, 18 Oct 2023 20:27:44 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-6;
        Wed, 18 Oct 2023 20:27:44 +0000
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
Subject: [PATCH v4 05/18] iommufd: Add a flag to enforce dirty tracking on attach
Date:   Wed, 18 Oct 2023 21:27:02 +0100
Message-Id: <20231018202715.69734-6-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-1-joao.m.martins@oracle.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_18,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180168
X-Proofpoint-GUID: bSCO16vPXQVZ3LsHyI6fSqQtsK-s05VC
X-Proofpoint-ORIG-GUID: bSCO16vPXQVZ3LsHyI6fSqQtsK-s05VC
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

	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY

.. Passed in HWPT_ALLOC ioctl() flags. The enforcement is done by creating
a iommu_domain via domain_alloc_user() and validating the requested flags
with what the device IOMMU supports (and failing accordingly) advertised).
Advertising the new IOMMU domain feature flag requires that the individual
iommu driver capability is supported when a future device attachment
happens.

Link: https://lore.kernel.org/kvm/20220721142421.GB4609@nvidia.com/
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/hw_pagetable.c | 4 +++-
 include/uapi/linux/iommufd.h         | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 8b3d2875d642..2b9ff3850bb8 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -157,7 +157,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	struct iommufd_ioas *ioas;
 	int rc;
 
-	if ((cmd->flags & (~IOMMU_HWPT_ALLOC_NEST_PARENT)) || cmd->__reserved)
+	if ((cmd->flags &
+	    ~(IOMMU_HWPT_ALLOC_NEST_PARENT|IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) ||
+	    cmd->__reserved)
 		return -EOPNOTSUPP;
 
 	idev = iommufd_get_device(ucmd, cmd->dev_id);
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 4a7c5c8fdbb4..cd94a9d8ce66 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -352,9 +352,12 @@ struct iommu_vfio_ioas {
  * @IOMMU_HWPT_ALLOC_NEST_PARENT: If set, allocate a domain which can serve
  *                                as the parent domain in the nesting
  *                                configuration.
+ * @IOMMU_HWPT_ALLOC_ENFORCE_DIRTY: Dirty tracking support for device IOMMU is
+ *                                enforced on device attachment
  */
 enum iommufd_hwpt_alloc_flags {
 	IOMMU_HWPT_ALLOC_NEST_PARENT = 1 << 0,
+	IOMMU_HWPT_ALLOC_ENFORCE_DIRTY = 1 << 1,
 };
 
 /**
-- 
2.17.2

