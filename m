Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B77177AF27
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 03:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjHNBVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 21:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjHNBUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 21:20:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B72E75;
        Sun, 13 Aug 2023 18:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691976035; x=1723512035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=277c02PzldzlnRnH2jM0ESjUVEL/whZkd2HGaLLh2vY=;
  b=MrspJpInasTenaA2hCo/inKO4d/avRNFMUOSiPLb82QNmcj33UBG6udA
   ol5MzsfKHPt7gkChUZwECEzxDDeabyAsIQGPK5hfWMhyIje2JSrqQd3YS
   snPTKpMxIDR4coxd2KXwE+Ycj/4cpFTd6wsI6ChRQRzT1aHu4h0dThJCz
   fhR5bvzoQ8HSonD3HYnO/uIcqp28KsHRV0q6ATV/eZLFZ3pewyV9aOv85
   zt0gOdJLC8AGdsNDWTWRHoW6aZLIc3NzmR6OIquDqwpuPrLc9nFBhwa69
   UNDkssJAMg1gLfxXWuhipbsAOmxepnEGneh933wwH540mU9AJ/j4ttb7k
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="375645319"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="375645319"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 18:20:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="726842296"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="726842296"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 13 Aug 2023 18:20:31 -0700
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
Subject: [PATCH v2 2/3] iommu: Consolidate pasid dma ownership check
Date:   Mon, 14 Aug 2023 09:17:58 +0800
Message-Id: <20230814011759.102089-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230814011759.102089-1-baolu.lu@linux.intel.com>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
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

When switching device DMA ownership, it is required that all the device's
pasid DMA be disabled. This is done by checking if the pasid array of the
group is empty. Consolidate all the open code into a single helper. No
intentional functionality change.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f1eba60e573f..d4a06a37ce39 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3127,6 +3127,19 @@ static bool iommu_is_default_domain(struct iommu_group *group)
 	return false;
 }
 
+/*
+ * Assert no PASID DMA when claiming or releasing group's DMA ownership.
+ * The device pasid interfaces are only for device drivers that have
+ * claimed the DMA ownership. Return true if no pasid DMA setup, otherwise
+ * return false with a WARN().
+ */
+static bool assert_pasid_dma_ownership(struct iommu_group *group)
+{
+	lockdep_assert_held(&group->mutex);
+
+	return !WARN_ON(!xa_empty(&group->pasid_array));
+}
+
 /**
  * iommu_device_use_default_domain() - Device driver wants to handle device
  *                                     DMA through the kernel DMA API.
@@ -3147,7 +3160,7 @@ int iommu_device_use_default_domain(struct device *dev)
 	mutex_lock(&group->mutex);
 	if (group->owner_cnt) {
 		if (group->owner || !iommu_is_default_domain(group) ||
-		    !xa_empty(&group->pasid_array)) {
+		    !assert_pasid_dma_ownership(group)) {
 			ret = -EBUSY;
 			goto unlock_out;
 		}
@@ -3177,7 +3190,7 @@ void iommu_device_unuse_default_domain(struct device *dev)
 		return;
 
 	mutex_lock(&group->mutex);
-	if (!WARN_ON(!group->owner_cnt || !xa_empty(&group->pasid_array)))
+	if (!WARN_ON(!group->owner_cnt) && assert_pasid_dma_ownership(group))
 		group->owner_cnt--;
 
 	mutex_unlock(&group->mutex);
@@ -3211,7 +3224,7 @@ static int __iommu_take_dma_ownership(struct iommu_group *group, void *owner)
 	int ret;
 
 	if ((group->domain && group->domain != group->default_domain) ||
-	    !xa_empty(&group->pasid_array))
+	    !assert_pasid_dma_ownership(group))
 		return -EBUSY;
 
 	ret = __iommu_group_alloc_blocking_domain(group);
@@ -3296,8 +3309,8 @@ EXPORT_SYMBOL_GPL(iommu_device_claim_dma_owner);
 
 static void __iommu_release_dma_ownership(struct iommu_group *group)
 {
-	if (WARN_ON(!group->owner_cnt || !group->owner ||
-		    !xa_empty(&group->pasid_array)))
+	if (WARN_ON(!group->owner_cnt || !group->owner) ||
+	    !assert_pasid_dma_ownership(group))
 		return;
 
 	group->owner_cnt = 0;
-- 
2.34.1

