Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3697089E5
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjERUu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjERUut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:50:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403981986
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:50:31 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIx3RR018492;
        Thu, 18 May 2023 20:49:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=LQKbjMN345OghwKCC/x/MrOorlZAr2BYoI+k4BaQA+Y=;
 b=sGHL2F+8xs6TCPX9puedXFBKd19Dsatyq5wQ5myWqPwZ1n1Q3rdcGTfKfRUjUIe4PMN2
 Fwi0247qu4rlEeBp0sGPYuy4MV4PeHOO5bzG5etWLa8fMTcgYiB8/Z7wwNE6z9XWItqt
 XRur3415EPCU5Iw8PimfdpFK5DXVxT8yMQoeaerG7sOP+w8l6O4MzqleUPoeDPYPSILd
 8qVp7dXaTrJfHMvdkHMqm4xMv04W2qmQXJMIdaD/ORAI/J5qncdrKdcz5Yj/EU6IYIA/
 deNwI4PJOyvzmfkL8sOSuySepPUltwKdUA4iUmMMQCxa21QuyYPzJsg4zA+2TGsSdBrI Dg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2kds9ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:49:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJV8dK032116;
        Thu, 18 May 2023 20:49:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dafy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:49:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE3Z033533;
        Thu, 18 May 2023 20:49:23 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-25;
        Thu, 18 May 2023 20:49:23 +0000
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
Subject: [PATCH RFCv2 24/24] iommu/arm-smmu-v3: Advertise IOMMU_DOMAIN_F_ENFORCE_DIRTY
Date:   Thu, 18 May 2023 21:46:50 +0100
Message-Id: <20230518204650.14541-25-joao.m.martins@oracle.com>
In-Reply-To: <20230518204650.14541-1-joao.m.martins@oracle.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=902 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180171
X-Proofpoint-GUID: YKl1ERjnwCeW7oQrrjbN608uKWTdMhdh
X-Proofpoint-ORIG-GUID: YKl1ERjnwCeW7oQrrjbN608uKWTdMhdh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we probe, and handle the DBM bit modifier, unblock
the kAPI usage by exposing the IOMMU_DOMAIN_F_ENFORCE_DIRTY
and implement it's requirement of revoking device attachment
in the iommu_capable. Finally expose the IOMMU_CAP_DIRTY to
users (IOMMUFD_DEVICE_GET_CAPS).

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bf0aac333725..71dd95a687fd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2014,6 +2014,8 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
 	case IOMMU_CAP_NOEXEC:
 		return true;
+	case IOMMU_CAP_DIRTY:
+		return arm_smmu_dbm_capable(master->smmu);
 	default:
 		return false;
 	}
@@ -2430,6 +2432,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
+	if (domain->flags & IOMMU_DOMAIN_F_ENFORCE_DIRTY &&
+	    !arm_smmu_dbm_capable(smmu))
+		return -EINVAL;
+
+
 	/*
 	 * Checking that SVA is disabled ensures that this device isn't bound to
 	 * any mm, and can be safely detached from its old domain. Bonds cannot
@@ -2913,6 +2920,7 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 }
 
 static struct iommu_ops arm_smmu_ops = {
+	.supported_flags	= IOMMU_DOMAIN_F_ENFORCE_DIRTY,
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
-- 
2.17.2

