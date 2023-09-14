Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F7779FF4F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbjINJAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbjINJAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:00:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D824CC7;
        Thu, 14 Sep 2023 02:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694682005; x=1726218005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3swk2kXJoM2a1PqfcTU8QJMMZhHalASP/3K35w+Kct8=;
  b=bYoHD3kzqqo4+DtwQS2eDhQnQ4RKjH+iCnOe0fB71q73fpcYbJcnHLr5
   55cMM2eyy7qlLFFfA2g0j6toC9FBEHqDh78eIUoEA3lKdvKpPgsZODuRy
   ZTULNko7p+iyEtsgHICJb2FLNUUdCWuZHnLglRm01U4b4EgAOEkmnmJGE
   j/4zF1Mndg6V2/hSXcnSwOgkT5+T/D4RNmrIB64WV34YIqdw3OhMAOBwv
   wOoVHCOHbasKD7dCaQ0RGSQUgfBIkRX9/KsRAfFOmOAhoEZY7/5qVV3ij
   udcz+2+VhiFIqwMcJGHmLW/5nk1Z09HYGP7kyc5VmRI798GfHULU48xwr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465266334"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465266334"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 01:59:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="859612834"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="859612834"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 14 Sep 2023 01:59:55 -0700
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
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v5 04/12] iommu: Cleanup iopf data structure definitions
Date:   Thu, 14 Sep 2023 16:56:30 +0800
Message-Id: <20230914085638.17307-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914085638.17307-1-baolu.lu@linux.intel.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct iommu_fault_page_request and struct iommu_page_response are not
part of uAPI anymore. Convert them to data structures for kAPI.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/iommu.h      | 27 +++++++++++----------------
 drivers/iommu/io-pgfault.c |  1 -
 drivers/iommu/iommu.c      |  4 ----
 3 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1040047982aa..db13ebaabcf7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -69,12 +69,12 @@ struct iommu_fault_page_request {
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
@@ -83,7 +83,7 @@ struct iommu_fault_page_request {
  * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
  */
 struct iommu_fault {
-	__u32	type;
+	u32 type;
 	struct iommu_fault_page_request prm;
 };
 
@@ -104,8 +104,6 @@ enum iommu_page_response_code {
 
 /**
  * struct iommu_page_response - Generic page response information
- * @argsz: User filled size of this data
- * @version: API version of this structure
  * @flags: encodes whether the corresponding fields are valid
  *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
  * @pasid: Process Address Space ID
@@ -113,14 +111,11 @@ enum iommu_page_response_code {
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
index 3bfc56df4f78..ccad2131f49d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1458,10 +1458,6 @@ int iommu_page_response(struct device *dev,
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

