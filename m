Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8287C79FF4B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbjINJAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbjINJAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:00:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84271BEF;
        Thu, 14 Sep 2023 02:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694682004; x=1726218004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vq80RMhcUIbwEqjdHizJvzxJdJ9rE7JxKJmGUY3+Nz4=;
  b=Y0k+flCCY4STyxURGityH0cB0uCk03dA29WVvOnGI6QOrrFa0VHwQCmm
   RC/UiJ/36txz9CVnE8vMCL82Un6aOLeXoPbWMWZmmvGeZGQnHtcF4A93X
   8brv+BbQJuoEqg0EjoNddfcIfVT1c4RfIa5t55V3GgOb2OPVEdYxhyhyK
   1ri0Y9h7CoiQSU4KF9ixyC+DQmk0NXSJCu2TcPrqCGI0/TQND+dcx7Iyq
   TUtrEw5qZHyyRJ+VMkt143F2YChVilNspWXbqkD75MK5nNfAE2ReaaaS6
   dYkxPVQuIjlfkDtnVtwBNPkoybCDKA7xNXDLppb85xe2wsyw/xXD2w/ye
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465266312"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465266312"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 01:59:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="859612753"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="859612753"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 14 Sep 2023 01:59:49 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 02/12] iommu/arm-smmu-v3: Remove unrecoverable faults reporting
Date:   Thu, 14 Sep 2023 16:56:28 +0800
Message-Id: <20230914085638.17307-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914085638.17307-1-baolu.lu@linux.intel.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No device driver registers fault handler to handle the reported
unrecoveraable faults. Remove it to avoid dead code.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 46 ++++++---------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e82bf1c449a3..90b281eda73f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1469,7 +1469,6 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 {
 	int ret;
-	u32 reason;
 	u32 perm = 0;
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
@@ -1479,16 +1478,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 
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
@@ -1498,6 +1490,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	if (evt[1] & EVTQ_1_S2)
 		return -EFAULT;
 
+	if (!(evt[1] & EVTQ_1_STALL))
+		return -EOPNOTSUPP;
+
 	if (evt[1] & EVTQ_1_RnW)
 		perm |= IOMMU_FAULT_PERM_READ;
 	else
@@ -1509,32 +1504,17 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
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

