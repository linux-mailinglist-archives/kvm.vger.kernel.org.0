Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BAD7089CA
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjERUsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjERUsG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:48:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831AB189
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:48:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIxeiR012540;
        Thu, 18 May 2023 20:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=QcIsCoHtQ7tdFGqnxoNBNnKAFVBbCL6Lhv33lo+g6fU=;
 b=nIzaPt4rqGDzI6yOUWmN+fTE2/eiW2EiHpXUuJ3aQuOOCMCNCpdWBcmrrDcop2IkcPAO
 GHewE9Yagz8nf8i1Qk1BEopWRC/61evLxV5kaDidSJl7BJ+l85zwdmhWKF6UDeI/EMDo
 KgAtOGWpUMEv3scOn9dW6I4DrRaoO7fitUGvxNanvW41h/t/oLTN1csVGsZezwf7+cqY
 pv0gAoCESyfzWPQAQdtNaD0a9QQmbTDEjPrAr7HgKmYgu5LDwBQNgv5IYXAc9J/2MJJf
 ukFsoI0Y6Blckedlg/ZinJygeRaj+/vfNlc2W/LvoptEMbaY9ZL/1/ewWKTnFn3h2rVo dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxfc3jx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJ2W5a032112;
        Thu, 18 May 2023 20:47:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10daedy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE2v033533;
        Thu, 18 May 2023 20:47:35 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-6;
        Thu, 18 May 2023 20:47:35 +0000
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
Subject: [PATCH RFCv2 05/24] iommufd: Add a flag to enforce dirty tracking on attach
Date:   Thu, 18 May 2023 21:46:31 +0100
Message-Id: <20230518204650.14541-6-joao.m.martins@oracle.com>
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
 engine=8.12.0-2304280000 definitions=main-2305180170
X-Proofpoint-GUID: -JeeAC5ISuAFikfuevNFnqcc00JsaYFW
X-Proofpoint-ORIG-GUID: -JeeAC5ISuAFikfuevNFnqcc00JsaYFW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Throughout IOMMU domain lifetime that wants to use dirty tracking, some
guarantees are needed such that any device attached to the iommu_domain
supports dirty tracking.

The idea is to handle a case where IOMMUs are assymetric feature-wise and
thus the capability may not be advertised for all devices.  This is done by
adding a flag into HWPT_ALLOC namely:

	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY

.. Passed in HWPT_ALLOC ioctl flags. The enforcement is done by creating a
iommu_domain and setting the associated flags (via iommu_domain_set_flags)
cross-checking with IOMMU driver advertised flags (and failing if it's not
advertised). Advertising the new IOMMU domain feature flag requires that
the individual iommu driver capability is supported when we attach a new
device to the iommu_domain or otherwise fail the attachment if the
capability is not set in the device.  Userspace will have also the option
of checking which that dirty tracking is supported in the IOMMU behind the
device.

Link: https://lore.kernel.org/kvm/20220721142421.GB4609@nvidia.com/
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/iommufd/device.c          |  2 +-
 drivers/iommu/iommufd/hw_pagetable.c    | 29 ++++++++++++++++++++++---
 drivers/iommu/iommufd/iommufd_private.h |  4 +++-
 include/uapi/linux/iommufd.h            |  9 ++++++++
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 989bd485f92f..48d1300f0350 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -511,7 +511,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	}
 
 	hwpt = iommufd_hw_pagetable_alloc(idev->ictx, ioas, idev,
-					  immediate_attach);
+					  immediate_attach, false);
 	if (IS_ERR(hwpt)) {
 		destroy_hwpt = ERR_CAST(hwpt);
 		goto out_unlock;
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index cf2c1504e20d..4f0b72737ae2 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -55,12 +55,26 @@ int iommufd_hw_pagetable_enforce_cc(struct iommufd_hw_pagetable *hwpt)
 	return 0;
 }
 
+int iommufd_hw_pagetable_enforce_dirty(struct iommufd_hw_pagetable *hwpt,
+				       struct iommufd_device *idev)
+{
+	hwpt->enforce_dirty =
+		!iommu_domain_set_flags(hwpt->domain, idev->dev->bus,
+					IOMMU_DOMAIN_F_ENFORCE_DIRTY);
+	if (!hwpt->enforce_dirty)
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * iommufd_hw_pagetable_alloc() - Get an iommu_domain for a device
  * @ictx: iommufd context
  * @ioas: IOAS to associate the domain with
  * @idev: Device to get an iommu_domain for
  * @immediate_attach: True if idev should be attached to the hwpt
+ * @enforce_dirty: True if dirty tracking support should be enforce
+ * 		   on device attach
  *
  * Allocate a new iommu_domain and return it as a hw_pagetable. The HWPT
  * will be linked to the given ioas and upon return the underlying iommu_domain
@@ -72,7 +86,8 @@ int iommufd_hw_pagetable_enforce_cc(struct iommufd_hw_pagetable *hwpt)
  */
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
-			   struct iommufd_device *idev, bool immediate_attach)
+			   struct iommufd_device *idev, bool immediate_attach,
+			   bool enforce_dirty)
 {
 	struct iommufd_hw_pagetable *hwpt;
 	int rc;
@@ -107,6 +122,12 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
 			goto out_abort;
 	}
 
+	if (enforce_dirty) {
+		rc = iommufd_hw_pagetable_enforce_dirty(hwpt, idev);
+		if (rc)
+			goto out_abort;
+	}
+
 	/*
 	 * immediate_attach exists only to accommodate iommu drivers that cannot
 	 * directly allocate a domain. These drivers do not finish creating the
@@ -141,7 +162,8 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	struct iommufd_ioas *ioas;
 	int rc;
 
-	if (cmd->flags || cmd->__reserved)
+	if ((cmd->flags & ~(IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) ||
+	    cmd->__reserved)
 		return -EOPNOTSUPP;
 
 	idev = iommufd_get_device(ucmd, cmd->dev_id);
@@ -155,7 +177,8 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
 	}
 
 	mutex_lock(&ioas->mutex);
-	hwpt = iommufd_hw_pagetable_alloc(ucmd->ictx, ioas, idev, false);
+	hwpt = iommufd_hw_pagetable_alloc(ucmd->ictx, ioas, idev, false,
+				  cmd->flags & IOMMU_HWPT_ALLOC_ENFORCE_DIRTY);
 	if (IS_ERR(hwpt)) {
 		rc = PTR_ERR(hwpt);
 		goto out_unlock;
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index dba730129b8c..2552eb44d83a 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -247,6 +247,7 @@ struct iommufd_hw_pagetable {
 	struct iommu_domain *domain;
 	bool auto_domain : 1;
 	bool enforce_cache_coherency : 1;
+	bool enforce_dirty : 1;
 	bool msi_cookie : 1;
 	/* Head at iommufd_ioas::hwpt_list */
 	struct list_head hwpt_item;
@@ -254,7 +255,8 @@ struct iommufd_hw_pagetable {
 
 struct iommufd_hw_pagetable *
 iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
-			   struct iommufd_device *idev, bool immediate_attach);
+			   struct iommufd_device *idev, bool immediate_attach,
+			   bool enforce_dirty);
 int iommufd_hw_pagetable_enforce_cc(struct iommufd_hw_pagetable *hwpt);
 int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
 				struct iommufd_device *idev);
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 8245c01adca6..1cd9c54d0f64 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -346,6 +346,15 @@ struct iommu_vfio_ioas {
 };
 #define IOMMU_VFIO_IOAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_VFIO_IOAS)
 
+/**
+ * enum iommufd_hwpt_alloc_flags - Flags for alloc hwpt
+ * @IOMMU_HWPT_ALL_ENFORCE_DIRTY: Dirty tracking support for device IOMMU is
+ *                                enforced on device attachment
+ */
+enum iommufd_hwpt_alloc_flags {
+	IOMMU_HWPT_ALLOC_ENFORCE_DIRTY = 1 << 0,
+};
+
 /**
  * struct iommu_hwpt_alloc - ioctl(IOMMU_HWPT_ALLOC)
  * @size: sizeof(struct iommu_hwpt_alloc)
-- 
2.17.2

