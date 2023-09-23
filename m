Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294787ABCF3
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjIWB14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjIWB1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:27:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA95E8
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:27:49 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLY96D002051;
        Sat, 23 Sep 2023 01:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=bqjjAhkXtgDwGd8zr20csj0Uai5l2qkpqBXoDA8Gddc=;
 b=L1WfoK2NC/Xnd0MqHeTjngks1dJm4f4iUCu4NO/SNjACmRBxlpnPGMRlfENRNVrkJQ/J
 JeL8XeYu/g/edQsMf/sH4lA6jgmMOqL5GYyjEKbFqbGa5j+5Bcfabpv4+eC/OrTrRwZq
 5NDxeAAiLy0VhHDSOlLgyb/Pnra63wh3m3NQvY8YPH0/8z++msA4SYJLTdwCPKTlWlkl
 S1H+pxEDc/1+LGjwOuYJUuXo2rNXccLrvB6kZPBXz6n6Fg6K5NRGE0Zq21yGeVY6bc16
 wj86A7K876VVvf1UMFP4Sz7DBE+L297fd53A5blEgopMABAk4EO7AO4zrG0idNZXyO0Q Bw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt0b2qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0Zu2G007691;
        Sat, 23 Sep 2023 01:27:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:18 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3h4040930;
        Sat, 23 Sep 2023 01:27:17 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-5;
        Sat, 23 Sep 2023 01:27:17 +0000
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
Subject: [PATCH v3 04/19] iommufd: Add a flag to enforce dirty tracking on attach
Date:   Sat, 23 Sep 2023 02:24:56 +0100
Message-Id: <20230923012511.10379-5-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: rrQBZ8nWCriPM6nYwyzS26qF5qiHXItv
X-Proofpoint-ORIG-GUID: rrQBZ8nWCriPM6nYwyzS26qF5qiHXItv
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/iommu/iommufd/hw_pagetable.c | 8 ++++++--
 include/uapi/linux/iommufd.h         | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index 26a8a818ffa3..32e259245314 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -83,7 +83,9 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 
 	lockdep_assert_held(&ioas->mutex);
 
-	if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ops->domain_alloc_user)
+	if ((flags & (IOMMU_HWPT_ALLOC_NEST_PARENT|
+		      IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) &&
+	    !ops->domain_alloc_user)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
@@ -157,7 +159,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	struct iommufd_ioas *ioas;
 	int rc;
 
-	if (cmd->flags & ~IOMMU_HWPT_ALLOC_NEST_PARENT || cmd->__reserved)
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

