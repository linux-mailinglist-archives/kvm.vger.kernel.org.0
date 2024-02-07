Return-Path: <kvm+bounces-8171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8615184C1FA
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA3121F26531
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9846ADDA7;
	Wed,  7 Feb 2024 01:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k/wbroWT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F661094E;
	Wed,  7 Feb 2024 01:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707269965; cv=none; b=PkTw69m4PyzoHcFsEHgn0ncDewk6BiN4KhZgP+j0fPl3OVqA9/4QM/w6bQewnz74Ap0jkztHkYEimB/t3fArqq0h4sUIEa+XZxBqcVeuc3r4HRlqAsHPy7pq9/mRLmd8mZIWYC9TeOZJkNJQ5M7NpM+Y1X+SE7vbrPgOSBmT8l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707269965; c=relaxed/simple;
	bh=bQjTjgCLfYsPH5p+7Al5Zy19r6O5Dl9UPL8NgLDT+B4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UWcIGD/dupFmYgKpx3h6dZCRzbKnvGDlwU+0xThKLypXhAXg8dxaGQXHcTdkUbb1IMuWOSYQavVlLZRq1f3ODKrbultT00oEXg5vmY+/IoBvKe+vGYbSFFn20mvfm3wD3ZYJKIF8IIPtVDULSA5wlWcEFGKxNuNDofXpYe+8nbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k/wbroWT; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707269962; x=1738805962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bQjTjgCLfYsPH5p+7Al5Zy19r6O5Dl9UPL8NgLDT+B4=;
  b=k/wbroWTYdx5G8IYcrIs4DYH/jZde7R2usYeuXYOww3UOjxMhlLamBUz
   bmnZ3/8Yz75sCw19QrdNnB0Hxb0TGhDs9GtbrDlfo8RhXzA7oEtfMtJru
   pUm+Mtuh6lKSTU8DRh1ZVsQxRx5cvrcyYwXbSo2Sc3nXoSu00aie+82I7
   n+f1ohzMsI0USrUzynRl+06qmAXbQ7Sg7eQrsoYk9NTZdYMPAhGCWH/hq
   c87I4I4HrKgHbIMgMMuCPsZVUuCjU8YE7aaCTu8VzIcBOuYmSAMP7kzJe
   H3cn/c8cUA2veAQROCs8TkFhlIrdTrPsgUppU6rlZhKFUbSNNfIjqoYuL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11533988"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11533988"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:39:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190574"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:39:13 -0800
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
	Joel Granados <j.granados@samsung.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v12 02/16] iommu/arm-smmu-v3: Remove unrecoverable faults reporting
Date: Wed,  7 Feb 2024 09:33:11 +0800
Message-Id: <20240207013325.95182-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240207013325.95182-1-baolu.lu@linux.intel.com>
References: <20240207013325.95182-1-baolu.lu@linux.intel.com>
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


