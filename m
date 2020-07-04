Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2780C214520
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 13:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgGDLVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 07:21:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:48343 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgGDLT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 07:19:57 -0400
IronPort-SDR: TJuap96Ay5nhwnBfXTnIwi4tbtgth6ALLKx8shm06p9oZKMJT2rJkzZ9DxR7Z8xkJGLoHRiaBl
 G9C0GNYgz7pg==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="145371340"
X-IronPort-AV: E=Sophos;i="5.75,311,1589266800"; 
   d="scan'208";a="145371340"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2020 04:19:53 -0700
IronPort-SDR: L15y2vG3UsE+XWaimdnf8l6cDbOTF0aE0QA1obhYtwy3xnxNjKD5lKG5kq6QvCa3BpurXSVtk8
 DGQAFTkH0HRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,311,1589266800"; 
   d="scan'208";a="282521415"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 04 Jul 2020 04:19:52 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v4 03/15] iommu/smmu: Report empty domain nesting info
Date:   Sat,  4 Jul 2020 04:26:17 -0700
Message-Id: <1593861989-35920-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iommu/arm-smmu-v3.c | 29 +++++++++++++++++++++++++++--
 drivers/iommu/arm-smmu.c    | 29 +++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index f578677..0c45d4d 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
+static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
+					void *data)
+{
+	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
+	u32 size;
+
+	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -ENODEV;
+
+	size = sizeof(struct iommu_nesting_info);
+
+	/*
+	 * if provided buffer size is not equal to the size, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->size != size) {
+		info->size = size;
+		return 0;
+	}
+
+	/* report an empty iommu_nesting_info for now */
+	memset(info, 0x0, size);
+	info->size = size;
+	return 0;
+}
+
 static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
@@ -3028,8 +3054,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	case IOMMU_DOMAIN_UNMANAGED:
 		switch (attr) {
 		case DOMAIN_ATTR_NESTING:
-			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
-			return 0;
+			return arm_smmu_domain_nesting_info(smmu_domain, data);
 		default:
 			return -ENODEV;
 		}
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 243bc4c..908607d 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1506,6 +1506,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
+static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
+					void *data)
+{
+	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
+	u32 size;
+
+	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -ENODEV;
+
+	size = sizeof(struct iommu_nesting_info);
+
+	/*
+	 * if provided buffer size is not equal to the size, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->size != size) {
+		info->size = size;
+		return 0;
+	}
+
+	/* report an empty iommu_nesting_info for now */
+	memset(info, 0x0, size);
+	info->size = size;
+	return 0;
+}
+
 static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
@@ -1515,8 +1541,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 	case IOMMU_DOMAIN_UNMANAGED:
 		switch (attr) {
 		case DOMAIN_ATTR_NESTING:
-			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
-			return 0;
+			return arm_smmu_domain_nesting_info(smmu_domain, data);
 		default:
 			return -ENODEV;
 		}
-- 
2.7.4

