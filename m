Return-Path: <kvm+bounces-3801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C23E808103
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:48:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 166471F21301
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 06:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D4D134D9;
	Thu,  7 Dec 2023 06:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FZwHDjQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B86137;
	Wed,  6 Dec 2023 22:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701931688; x=1733467688;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8HruJAoKbOqwaNGcie+K2FNu38IQJY0ZfRkunAESKds=;
  b=FZwHDjQ4+TIRFNslykqawCaDKBhuslpymiDEbUyjE1omDS2nH6WM7CMK
   soReen7F6P6w1ynBd+k/scWSlztORrVs/4Qy0X3Sja7cxanaBbsUMsj8R
   Cc101W6C0EsDrCnnXjWjVEWvzVuPmoF/FhtO+Sa7sm+xp93M3s/kGb+/5
   YpyZIJvVW3C1k8oBuU0tVhHYn5qn08ijbw3w91hI8tHF80+Z9y3h/wRtG
   qGO91gDw/lfBy8yMCIMcqkk2ydBiOhcELcz39iN3upJ2rvTPwwgJ1+5i3
   S9inhzIVHTc1QMYnRnxOn1XcIJbPH0WCFPuq/BF2aSssN60l1ChohvaVu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1014908"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1014908"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 22:48:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="771611438"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="771611438"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga002.jf.intel.com with ESMTP; 06 Dec 2023 22:48:01 -0800
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v8 02/12] iommu/arm-smmu-v3: Remove unrecoverable faults reporting
Date: Thu,  7 Dec 2023 14:42:58 +0800
Message-Id: <20231207064308.313316-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231207064308.313316-1-baolu.lu@linux.intel.com>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No device driver registers fault handler to handle the reported
unrecoveraable faults. Remove it to avoid dead code.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 46 ++++++---------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fc4317c25b6d..0f33b212ca28 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1463,7 +1463,6 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 {
 	int ret;
-	u32 reason;
 	u32 perm = 0;
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
@@ -1473,16 +1472,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 
 	switch (FIELD_GET(EVTQ_0_ID, evt[0])) {
 	case EVT_ID_TRANSLATION_FAULT:
-		reason = IOMMU_FAULT_REASON_PTE_FETCH;
-		break;
 	case EVT_ID_ADDR_SIZE_FAULT:
-		reason = IOMMU_FAULT_REASON_OOR_ADDRESS;
-		break;
 	case EVT_ID_ACCESS_FAULT:
-		reason = IOMMU_FAULT_REASON_ACCESS;
-		break;
 	case EVT_ID_PERMISSION_FAULT:
-		reason = IOMMU_FAULT_REASON_PERMISSION;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1492,6 +1484,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	if (evt[1] & EVTQ_1_S2)
 		return -EFAULT;
 
+	if (!(evt[1] & EVTQ_1_STALL))
+		return -EOPNOTSUPP;
+
 	if (evt[1] & EVTQ_1_RnW)
 		perm |= IOMMU_FAULT_PERM_READ;
 	else
@@ -1503,32 +1498,17 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	if (evt[1] & EVTQ_1_PnU)
 		perm |= IOMMU_FAULT_PERM_PRIV;
 
-	if (evt[1] & EVTQ_1_STALL) {
-		flt->type = IOMMU_FAULT_PAGE_REQ;
-		flt->prm = (struct iommu_fault_page_request) {
-			.flags = IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE,
-			.grpid = FIELD_GET(EVTQ_1_STAG, evt[1]),
-			.perm = perm,
-			.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
-		};
+	flt->type = IOMMU_FAULT_PAGE_REQ;
+	flt->prm = (struct iommu_fault_page_request) {
+		.flags = IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE,
+		.grpid = FIELD_GET(EVTQ_1_STAG, evt[1]),
+		.perm = perm,
+		.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
+	};
 
-		if (ssid_valid) {
-			flt->prm.flags |= IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
-			flt->prm.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
-		}
-	} else {
-		flt->type = IOMMU_FAULT_DMA_UNRECOV;
-		flt->event = (struct iommu_fault_unrecoverable) {
-			.reason = reason,
-			.flags = IOMMU_FAULT_UNRECOV_ADDR_VALID,
-			.perm = perm,
-			.addr = FIELD_GET(EVTQ_2_ADDR, evt[2]),
-		};
-
-		if (ssid_valid) {
-			flt->event.flags |= IOMMU_FAULT_UNRECOV_PASID_VALID;
-			flt->event.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
-		}
+	if (ssid_valid) {
+		flt->prm.flags |= IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
+		flt->prm.pasid = FIELD_GET(EVTQ_0_SSID, evt[0]);
 	}
 
 	mutex_lock(&smmu->streams_mutex);
-- 
2.34.1


