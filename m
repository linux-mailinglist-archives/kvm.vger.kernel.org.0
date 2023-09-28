Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3447B118D
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 06:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjI1EbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 00:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjI1EbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 00:31:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBA21AB;
        Wed, 27 Sep 2023 21:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695875473; x=1727411473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vf95LZG+Z/RY+5AhNHzTi/EmrITFl3460aqCEJnFT94=;
  b=IU4mlajZUd544Y/eodtosaR18/OrksYi22Zqs7mYIODbnjIYXnBW1VeN
   mB4f2OiYAGAHZSYOiOwBGhCRtf0xg59YaQnTIgm7OJdVUllHiD5aaJXc7
   mursXHGPAT4ijYOCXwE4fKGGuCiaMRmnArmEr0ZKjtr1itHJvnul3DLNH
   fYNfVz9TByNFBKuHG6+o/i+3Sju4I9RjdJZB7B1ARTo+p5q1RbWEUwKzi
   h5p2IVXvR/IDVv3VHPgEWQSi18avOt6aZbULEfkOaNuioozgWysrTnmVf
   T/jsbTe7BTLQL7MoYdMPsd1Z+WjyX1BqQ3/+NYpeCTeM8bzsfc7wETXbI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="379260455"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="379260455"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 21:31:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="923068858"
X-IronPort-AV: E=Sophos;i="6.03,182,1694761200"; 
   d="scan'208";a="923068858"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga005.jf.intel.com with ESMTP; 27 Sep 2023 21:31:08 -0700
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
Subject: [PATCH v6 04/12] iommu: Cleanup iopf data structure definitions
Date:   Thu, 28 Sep 2023 12:27:26 +0800
Message-Id: <20230928042734.16134-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928042734.16134-1-baolu.lu@linux.intel.com>
References: <20230928042734.16134-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 8be9e9cd6576..41384009e217 100644
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
index 1ecac2b5c54f..cb3ace7bbfa6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1464,10 +1464,6 @@ int iommu_page_response(struct device *dev,
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

