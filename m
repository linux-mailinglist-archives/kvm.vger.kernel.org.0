Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5437ABD03
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjIWB2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjIWB2a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F3AF7
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:19 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MLYV49008435;
        Sat, 23 Sep 2023 01:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=pcCBNWVtNoufNEQIzycws+hZ5WXj+fEMgBEdjt4Pn3o=;
 b=j52Rir4QhLkCclRiVHBXEUJUNAWPNsQmOkEUTwiDvc1eRSV4j7RtsbWB+bXkBMY4wNeG
 a+Wp6RkUyZOGkb9x8vUT89CQJ4Mu2J8p+clIVJpAsgbJ9b9MxszmmRvzXJ6zftTIxAug
 7liEHp4V6drnxK1UgPdOkNKew5j+sqfbnRDkCe/lH3j15toWRFokWWkC0qPERoVbVqAe
 Ofw5mBROiWFIUKWw1EnBLK9VS1vrPbF5mC9EtrWg4YwXmSYxTDROfDgAxCI1XZQpiWFG
 qk0EO8yLX5t5HIxCooSbZ4GaQHowh51hVwRGCWZrwbD7iEhrLfQxAnMdM4joUophMOLF fA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsvu31a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:28:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38MNLcPH007665;
        Sat, 23 Sep 2023 01:27:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhqkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:58 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3hS040930;
        Sat, 23 Sep 2023 01:27:58 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-17;
        Sat, 23 Sep 2023 01:27:58 +0000
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
Subject: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain allocation
Date:   Sat, 23 Sep 2023 02:25:08 +0100
Message-Id: <20230923012511.10379-17-joao.m.martins@oracle.com>
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
X-Proofpoint-ORIG-GUID: QqWZpKQvsSq8K8IsWikFbGci4_jTNRu1
X-Proofpoint-GUID: QqWZpKQvsSq8K8IsWikFbGci4_jTNRu1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the domain_alloc_user op implementation. To that end, refactor
amd_iommu_domain_alloc() to receive a dev pointer and flags, while
renaming it to .. such that it becomes a common function shared with
domain_alloc_user() implementation. The sole difference with
domain_alloc_user() is that we initialize also other fields that
iommu_domain_alloc() does. It lets it return the iommu domain
correctly initialized in one function.

This is in preparation to add dirty enforcement on AMD implementation
of domain_alloc_user.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/amd/iommu.c | 46 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 95bd7c25ba6f..af36c627022f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -37,6 +37,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/dma.h>
+#include <uapi/linux/iommufd.h>
 
 #include "amd_iommu.h"
 #include "../dma-iommu.h"
@@ -2155,7 +2156,10 @@ static inline u64 dma_max_address(void)
 	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
 }
 
-static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
+static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
+						  struct amd_iommu *iommu,
+						  struct device *dev,
+						  u32 flags)
 {
 	struct protection_domain *domain;
 
@@ -2164,19 +2168,54 @@ static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
 	 * default to use IOMMU_DOMAIN_DMA[_FQ].
 	 */
 	if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	domain = protection_domain_alloc(type);
 	if (!domain)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	domain->domain.geometry.aperture_start = 0;
 	domain->domain.geometry.aperture_end   = dma_max_address();
 	domain->domain.geometry.force_aperture = true;
 
+	if (dev) {
+		domain->domain.type = type;
+		domain->domain.pgsize_bitmap =
+			iommu->iommu.ops->pgsize_bitmap;
+		domain->domain.ops =
+			iommu->iommu.ops->default_domain_ops;
+	}
+
 	return &domain->domain;
 }
 
+static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
+{
+	struct iommu_domain *domain;
+
+	domain = do_iommu_domain_alloc(type, NULL, NULL, 0);
+	if (IS_ERR(domain))
+		return NULL;
+
+	return domain;
+}
+
+static struct iommu_domain *amd_iommu_domain_alloc_user(struct device *dev,
+							u32 flags)
+{
+	unsigned int type = IOMMU_DOMAIN_UNMANAGED;
+	struct amd_iommu *iommu;
+
+	iommu = rlookup_amd_iommu(dev);
+	if (!iommu)
+		return ERR_PTR(-ENODEV);
+
+	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return do_iommu_domain_alloc(type, iommu, dev, flags);
+}
+
 static void amd_iommu_domain_free(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
@@ -2464,6 +2503,7 @@ static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
+	.domain_alloc_user = amd_iommu_domain_alloc_user,
 	.probe_device = amd_iommu_probe_device,
 	.release_device = amd_iommu_release_device,
 	.probe_finalize = amd_iommu_probe_finalize,
-- 
2.17.2

