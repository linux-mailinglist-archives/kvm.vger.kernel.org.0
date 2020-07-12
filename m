Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DD421C8DD
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 13:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgGLLP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 07:15:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:45844 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgGLLOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 07:14:34 -0400
IronPort-SDR: FmDYk0EAT5l95v9LztjAFEq7FAqvJ88/EOupoFIdowsnHRlxvB9qaAR7udzLYXYhl+chHRADce
 UCcJc/ZacP6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9679"; a="149952683"
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="149952683"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 04:14:29 -0700
IronPort-SDR: jjP0MuKAHKwAXA3uFxxCWdecUbY6L8yVu8c4ud4pHE4/+/147nPn6DlAc3R9DYyaMoAHmT5Ht6
 Jo8AgZkORvEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="315788558"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 12 Jul 2020 04:14:29 -0700
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
Subject: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Date:   Sun, 12 Jul 2020 04:20:58 -0700
Message-Id: <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is added as instead of returning a boolean for DOMAIN_ATTR_NESTING,
iommu_domain_get_attr() should return an iommu_nesting_info handle.

Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v4 -> v5:
*) address comments from Eric Auger.
---
 drivers/iommu/arm-smmu-v3.c | 29 +++++++++++++++++++++++++++--
 drivers/iommu/arm-smmu.c    | 29 +++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index f578677..ec815d7 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
+static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
+					void *data)
+{
+	struct iommu_nesting_info *info = (struct iommu_nesting_info *)data;
+	unsigned int size;
+
+	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -ENODEV;
+
+	size = sizeof(struct iommu_nesting_info);
+
+	/*
+	 * if provided buffer size is smaller than expected, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->size < size) {
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
index 243bc4c..09e2f1b 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1506,6 +1506,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	return group;
 }
 
+static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
+					void *data)
+{
+	struct iommu_nesting_info *info = (struct iommu_nesting_info *)data;
+	unsigned int size;
+
+	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -ENODEV;
+
+	size = sizeof(struct iommu_nesting_info);
+
+	/*
+	 * if provided buffer size is smaller than expected, should
+	 * return 0 and also the expected buffer size to caller.
+	 */
+	if (info->size < size) {
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

