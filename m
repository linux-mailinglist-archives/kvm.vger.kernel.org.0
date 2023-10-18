Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F0A7CE8E5
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 22:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjJRU3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 16:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbjJRU3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 16:29:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5800DD59
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 13:28:57 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IIn0jU011264;
        Wed, 18 Oct 2023 20:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=PK6EWkZidMqXWeIobnNeBSOV3HaSPzZ1qC/WTS/bf2c=;
 b=jw2rMT1+BFF8XSx4Tr0Cy/YfAuiYd5FORpnuD8yf4lOvxBSu+Bos7WY5MKHW2Q0ENlC8
 lNIjRhmCxxlP6rokFxqAqRosx3TxSp26m/qcVvd1jcVnHQymWxXhblpdkv/KIQ89OWJu
 Q7xyE3aT2d1YZnPyc1quE1HV7oEWt2kKiMogH9vco1HBfMpLzDDop1k5GA6WCLwopvvx
 tOI6Ab6pWjmqvfJvxYigu9lKOw2thdlvMDChupC90gNSkGFTMf3lW9PnECXVOsh8NlHA
 rVJrA+U10FqV19DhzpXu1NTeFABUitDxlXXIrCE1LwghizJOyfho6N3YSxoS9jfZSyzt 7w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cgngy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39IJs8J4009825;
        Wed, 18 Oct 2023 20:28:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ps7av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 20:28:03 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IKRP5h040635;
        Wed, 18 Oct 2023 20:28:02 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-176-41.vpn.oracle.com [10.175.176.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3trg0ps6qp-11;
        Wed, 18 Oct 2023 20:28:02 +0000
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
Subject: [PATCH v4 10/18] iommu/amd: Add domain_alloc_user based domain allocation
Date:   Wed, 18 Oct 2023 21:27:07 +0100
Message-Id: <20231018202715.69734-11-joao.m.martins@oracle.com>
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
 definitions=main-2310180169
X-Proofpoint-ORIG-GUID: LVSVSKx-lUJgPdwVWaYSOQGWkcS61r0p
X-Proofpoint-GUID: LVSVSKx-lUJgPdwVWaYSOQGWkcS61r0p
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
 drivers/iommu/amd/iommu.c | 47 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 95bd7c25ba6f..292a09b2fbbf 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -37,6 +37,7 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 #include <asm/dma.h>
+#include <uapi/linux/iommufd.h>
 
 #include "amd_iommu.h"
 #include "../dma-iommu.h"
@@ -2155,28 +2156,67 @@ static inline u64 dma_max_address(void)
 	return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
 }
 
-static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
+static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
+						  struct device *dev,
+						  u32 flags)
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
+		domain->domain.pgsize_bitmap =
+			iommu->iommu.ops->pgsize_bitmap;
+		domain->domain.ops =
+			iommu->iommu.ops->default_domain_ops;
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
+	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return do_iommu_domain_alloc(type, dev, flags);
+}
+
 static void amd_iommu_domain_free(struct iommu_domain *dom)
 {
 	struct protection_domain *domain;
@@ -2464,6 +2504,7 @@ static bool amd_iommu_enforce_cache_coherency(struct iommu_domain *domain)
 const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
 	.domain_alloc = amd_iommu_domain_alloc,
+	.domain_alloc_user = amd_iommu_domain_alloc_user,
 	.probe_device = amd_iommu_probe_device,
 	.release_device = amd_iommu_release_device,
 	.probe_finalize = amd_iommu_probe_finalize,
-- 
2.17.2

