Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E4D7D534F
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343725AbjJXNzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjJXNz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ABC6A78
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:52:33 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCJVwe014279;
        Tue, 24 Oct 2023 13:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=5F4VOcNQMaayrBa1oPMRcPdEfGKf6gyLNvsbGQwJrlM=;
 b=dgN2Rcrd/ybOMdBZCAsOSjAcA8OPQd18bcoFR7jfC9cpWLsdaOfWEplUcCSjjMJcpVE9
 mGcFYL4rIRv19nLApbh9lQiGB8F8Z27mwD8A62ufa/x15w2YfyU2AO0yoZw5GL+xHOiN
 u1W8XkNSd4iMNEdLLzlujyS70qEytxuFg25Mb0t7EizVTHDIP8NUb21o5HR3ivJxhWAC
 XvRAg7WwaepM1CFNT75pc+yBErcWy5NzaQ1IzX/CGMR9cGm53wjV/yQOLmkkb2kINNOe
 rEmMh2Vs026poceNcJHVqxlC0e83zB4HDTyF2+pOXX3FJZZYxCrExXIckAg7lJPo81qS 5w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv6pcwg74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39ODCCq9034774;
        Tue, 24 Oct 2023 13:52:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53592jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:52:02 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL9A030007;
        Tue, 24 Oct 2023 13:52:01 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-11;
        Tue, 24 Oct 2023 13:52:01 +0000
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
Subject: [PATCH v6 10/18] iommu/amd: Add domain_alloc_user based domain allocation
Date:   Tue, 24 Oct 2023 14:51:01 +0100
Message-Id: <20231024135109.73787-11-joao.m.martins@oracle.com>
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
X-Proofpoint-GUID: m2_oNDwdNirOZk8id7YTTiXg1IkkmsZJ
X-Proofpoint-ORIG-GUID: m2_oNDwdNirOZk8id7YTTiXg1IkkmsZJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the domain_alloc_user op implementation. To that end, refactor
amd_iommu_domain_alloc() to receive a dev pointer and flags, while renaming
it too, such that it becomes a common function shared with
domain_alloc_user() implementation. The sole difference with
domain_alloc_user() is that we initialize also other fields that
iommu_domain_alloc() does. It lets it return the iommu domain correctly
initialized in one function.

This is in preparation to add dirty enforcement on AMD implementation of
domain_alloc_user.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/iommu.c | 44 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 95bd7c25ba6f..667e23b0ab0d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -37,6 +37,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/dma.h>
+#include <uapi/linux/iommufd.h>
 
 #include "amd_iommu.h"
 #include "../dma-iommu.h"
@@ -2155,28 +2156,64 @@ static inline u64 dma_max_address(void)
 	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
 }
 
-static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
+static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
+						  struct device *dev, u32 flags)
 {
 	struct protection_domain *domain;
+	struct amd_iommu *iommu = NULL;
+
+	if (dev) {
+		iommu = rlookup_amd_iommu(dev);
+		if (!iommu)
+			return ERR_PTR(-ENODEV);
+	}
 
 	/*
 	 * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
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
 
+	if (iommu) {
+		domain->domain.type = type;
+		domain->domain.pgsize_bitmap = iommu->iommu.ops->pgsize_bitmap;
+		domain->domain.ops = iommu->iommu.ops->default_domain_ops;
+	}
+
 	return &domain->domain;
 }
 
+static struct iommu_domain *amd_iommu_domain_alloc(unsigned int type)
+{
+	struct iommu_domain *domain;
+
+	domain = do_iommu_domain_alloc(type, NULL, 0);
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
+
+	if (flags)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return do_iommu_domain_alloc(type, dev, flags);
+}
+
 static void amd_iommu_domain_free(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
@@ -2464,6 +2501,7 @@ static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
+	.domain_alloc_user = amd_iommu_domain_alloc_user,
 	.probe_device = amd_iommu_probe_device,
 	.release_device = amd_iommu_release_device,
 	.probe_finalize = amd_iommu_probe_finalize,
-- 
2.17.2

