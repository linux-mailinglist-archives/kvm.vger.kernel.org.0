Return-Path: <kvm+bounces-8173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC8584C1FE
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 02:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A6DAB25F1B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 01:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4FF13AC5;
	Wed,  7 Feb 2024 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fzJ0XlDN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E5711718;
	Wed,  7 Feb 2024 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707269971; cv=none; b=P01fT8LZNTeT1ZPD0/NpOGszIVx/L6Z2naEDMRI889RGJtxJhj0Y+K+THU4x01RJWP3wO5OvJcY/STjlDNum/2qFlWIfucB/y1Kf4MC6f3it7IZl8IRYtbLmw6uyrhGLM7RZxxEtqq1SVk8ngqZVeRH4Hja2Pm+qb0pWfTJYq/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707269971; c=relaxed/simple;
	bh=xL8pjHdaGxPkR2/g4/ri8cXR4C1q58Lorji2uwOVwNg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=daHAjHxZ3IXnc7wHdQ/Y1vq7cIVc63xsvwIojKp+y3i/JyVjCU7PMxnrKUVFpTGjwpqKFeZ+or1djLf9W5qEaDvqSS7NW+TZLNMQwRxOGz+lcG8qMD5NR2qQ4Ufwp3oaLzW1x+mtr2kpS26XMhZD3oNjDDgeNwbLH9BGFLulgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fzJ0XlDN; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707269970; x=1738805970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xL8pjHdaGxPkR2/g4/ri8cXR4C1q58Lorji2uwOVwNg=;
  b=fzJ0XlDNZx75oXUCyi3gWvmi+SSMYrGaWnjdyWJbgRBO52OY8LFdu5o2
   DIiMlQWevcCGV5wRiTimu9gcZnDsYjw5zprbN4vgAM0PK07rrv2asyuwL
   V0IjOtRVAPbcUyG/Q7SDiJp2JPoIEEW3wwVV81qoJheNg/g/jN3f9YNh2
   5YXDHvRPcpd6kwE5OhCuOhfvfUD9XpXCWRmQQUM1iiZZqVzDpJFAljRl6
   Cn64T8lC3vQYBX/nLKlSClGFZgjXgPH4tUJ2zkqQ0qZYn47pBVAh2G15m
   ZWd//WXisPHVj9yxwqY0lV5SSWqq4hhD2mRjN2zaEna7P/NDQy/kaGsqt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="11534039"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="11534039"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 17:39:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1190611"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmviesa010.fm.intel.com with ESMTP; 06 Feb 2024 17:39:23 -0800
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
Subject: [PATCH v12 04/16] iommu: Cleanup iopf data structure definitions
Date: Wed,  7 Feb 2024 09:33:13 +0800
Message-Id: <20240207013325.95182-5-baolu.lu@linux.intel.com>
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
index c960c4fae3bc..829bcb5a8e23 100644
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
index d14413916f93..6a4d9bc0641d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1494,10 +1494,6 @@ int iommu_page_response(struct device *dev,
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


