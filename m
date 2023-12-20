Return-Path: <kvm+bounces-4878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4708181963B
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C63EC1F25B5E
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9155CC121;
	Wed, 20 Dec 2023 01:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dT7HpBZj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A4EBA2B;
	Wed, 20 Dec 2023 01:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703035719; x=1734571719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bQjTjgCLfYsPH5p+7Al5Zy19r6O5Dl9UPL8NgLDT+B4=;
  b=dT7HpBZjpxMHwSTJ2Aii73Q00OouX5DgmKC0DpLwOM4SdvupSY4xhp1X
   kMNxZAMz2kKmm8bvoKxGaY5XZfqD5r2nLJhrRPaksEQsUgsGYof/LU5gL
   Y99PenfQkREMHwy8Xl3Uwg9oTG99fXsjHHu0l2ntvdkyn2aBDK5hoWi/7
   zoInbpKbnRuFCQN109d/Y6V+RRkES8OiUBc/FTrlTLe0Ub1xyycG8QQMM
   tgLj68xvCswR7bQjcRgwRowwpJxUM85vMSDIospYEIYPvPDc0V41v0m/G
   wmP6XVV2aHzJf0eZgMPPqPTWY8z7duNvIQIP+7Qoy5o4JxVfvazjJrzj4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2965738"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="2965738"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:28:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="1023319063"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="1023319063"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2023 17:28:35 -0800
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
Subject: [PATCH v9 02/14] iommu/arm-smmu-v3: Remove unrecoverable faults reporting
Date: Wed, 20 Dec 2023 09:23:20 +0800
Message-Id: <20231220012332.168188-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220012332.168188-1-baolu.lu@linux.intel.com>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
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
index 0ffb1cf17e0b..4cf1054ed321 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1461,7 +1461,6 @@ arm_smmu_find_master(struct arm_smmu_device *smmu, u32 sid)
 static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 {
 	int ret;
-	u32 reason;
 	u32 perm = 0;
 	struct arm_smmu_master *master;
 	bool ssid_valid = evt[0] & EVTQ_0_SSV;
@@ -1471,16 +1470,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 
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
@@ -1490,6 +1482,9 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
 	if (evt[1] & EVTQ_1_S2)
 		return -EFAULT;
 
+	if (!(evt[1] & EVTQ_1_STALL))
+		return -EOPNOTSUPP;
+
 	if (evt[1] & EVTQ_1_RnW)
 		perm |= IOMMU_FAULT_PERM_READ;
 	else
@@ -1501,32 +1496,17 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
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


