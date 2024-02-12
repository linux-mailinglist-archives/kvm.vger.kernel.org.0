Return-Path: <kvm+bounces-8525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6797A850CA2
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 02:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 234412845CE
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 01:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8D8C8FF;
	Mon, 12 Feb 2024 01:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BE9P3s/c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE873C12F;
	Mon, 12 Feb 2024 01:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707701313; cv=none; b=QIaHvLSoJbuQBUrknXYZ6uofwmOPHd9dkddR3d+A5+AEPXFa+D0OErCR+AUip49lYKoNttubuzZlPs1wtrLBOorH/r8cTFYSTCYD6dZwD0MOCq0h2drNhQHEoGjeEEsdib8JrU525qDByYIMjnJBjAITpZlrUm7P+p0vtDKQp8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707701313; c=relaxed/simple;
	bh=MT7X8flPCso7J/6cAQd7DCOM9kj/WSB6pfh3BOfN+IY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qyIQZtWdr5L/t7ap1S3NZTDl/vNuAwbMQwQ5QlthGEbzw3YYMYvSsg4B/tlTf1JWat/+eM+NUGBtCVF7dpRTM9+v237NvVkH1+SFjN6K6yifEW6XQvAT6jSoi/4WSwLOTNezc4OAzSd0EUV+r4JwgM0ptHHlkDIiU9+lS8xelJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BE9P3s/c; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707701312; x=1739237312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MT7X8flPCso7J/6cAQd7DCOM9kj/WSB6pfh3BOfN+IY=;
  b=BE9P3s/cBW6CBotqUV67AHzX55SMITaootxAed16yZo2HcOFCNUxCyG9
   MsnXhdlsJY8Dp2KYlmuA3r0VrD2FNPu0/31A57V7CJnMyc9mEcORJXr19
   YPN351UvVD+9zZAI5tlmXG9CFVF5vb1W+7H5II+c6bhKWts/5gEQrGDeC
   QOnpgMzEJ7FuJVcZAOjnuTbAb23L/pTTAgCqMXurUoGJym3GFHiSV/uHD
   8pdfLiL54N2ilzlpxXQt4Eo5GPfwq02mw7ba3Oe4cgc2UpXeKd/878a/Q
   eyY5VpTX9zBWlAiuFu6Hu5RCwu73Fa8miYx++rEXrk69qnPzvZv8z8oiU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10981"; a="5502090"
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="5502090"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2024 17:28:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,261,1701158400"; 
   d="scan'208";a="7132164"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orviesa005.jf.intel.com with ESMTP; 11 Feb 2024 17:28:28 -0800
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
Subject: [PATCH v13 04/16] iommu: Cleanup iopf data structure definitions
Date: Mon, 12 Feb 2024 09:22:15 +0800
Message-Id: <20240212012227.119381-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240212012227.119381-1-baolu.lu@linux.intel.com>
References: <20240212012227.119381-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct iommu_fault_page_request and struct iommu_page_response are not
part of uAPI anymore. Convert them to data structures for kAPI.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h      | 27 +++++++++++----------------
 drivers/iommu/io-pgfault.c |  1 -
 drivers/iommu/iommu.c      |  4 ----
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 68ffbbacaaad..1c97f7515297 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -71,12 +71,12 @@ struct iommu_fault_page_request {
 #define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
 #define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
 #define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
-	__u32	flags;
-	__u32	pasid;
-	__u32	grpid;
-	__u32	perm;
-	__u64	addr;
-	__u64	private_data[2];
+	u32	flags;
+	u32	pasid;
+	u32	grpid;
+	u32	perm;
+	u64	addr;
+	u64	private_data[2];
 };
 
 /**
@@ -85,7 +85,7 @@ struct iommu_fault_page_request {
  * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
  */
 struct iommu_fault {
-	__u32	type;
+	u32 type;
 	struct iommu_fault_page_request prm;
 };
 
@@ -106,8 +106,6 @@ enum iommu_page_response_code {
 
 /**
  * struct iommu_page_response - Generic page response information
- * @argsz: User filled size of this data
- * @version: API version of this structure
  * @flags: encodes whether the corresponding fields are valid
  *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
  * @pasid: Process Address Space ID
@@ -115,14 +113,11 @@ enum iommu_page_response_code {
  * @code: response code from &enum iommu_page_response_code
  */
 struct iommu_page_response {
-	__u32	argsz;
-#define IOMMU_PAGE_RESP_VERSION_1	1
-	__u32	version;
 #define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
-	__u32	flags;
-	__u32	pasid;
-	__u32	grpid;
-	__u32	code;
+	u32	flags;
+	u32	pasid;
+	u32	grpid;
+	u32	code;
 };
 
 
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index e5b8b9110c13..24b5545352ae 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -56,7 +56,6 @@ static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
 			       enum iommu_page_response_code status)
 {
 	struct iommu_page_response resp = {
-		.version		= IOMMU_PAGE_RESP_VERSION_1,
 		.pasid			= iopf->fault.prm.pasid,
 		.grpid			= iopf->fault.prm.grpid,
 		.code			= status,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8309e634977e..e9ce4dd78edc 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1513,10 +1513,6 @@ int iommu_page_response(struct device *dev,
 	if (!param || !param->fault_param)
 		return -EINVAL;
 
-	if (msg->version != IOMMU_PAGE_RESP_VERSION_1 ||
-	    msg->flags & ~IOMMU_PAGE_RESP_PASID_VALID)
-		return -EINVAL;
-
 	/* Only send response if there is a fault report pending */
 	mutex_lock(&param->fault_param->lock);
 	if (list_empty(&param->fault_param->faults)) {
-- 
2.34.1


