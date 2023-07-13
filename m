Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED31F75178C
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 06:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbjGMEew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 00:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbjGMEeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 00:34:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7902712F;
        Wed, 12 Jul 2023 21:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689222889; x=1720758889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cRzfvAiOqEbmCFSTbcVQKw4zrRuJSvtgRbGD2txDVfY=;
  b=QZiQbnDbditJz2FlouSLe07SDGOxbJwA8LInrh+G1rerwDJ9hygQoJWk
   mnrrCTJIYtmFPmEvZGniJ+rsuAdt3jo7S1GMjnNUpEZmmZaJ8HEPLaeZv
   Z1j37JVosdc01gLIrvZwWHBBMlheddhKMjJZ/PWzl9paTHzmCqnCN2BHN
   kBbu7fM1vaNEcCQwHiaY269MFhaWvbMrnRtR4vUd4DXQOmJQ/FMcJpHDi
   uQ3Gqs6Sumwo6ec5q06xM/z5VJA0UtlewnKJ5FT7ljKtf1FciLsT4tors
   1GwxdUE8hPt3HOoQBmn0np873UlZGO67mtSWwfuZlxN9SQE1w1swl/IPG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="344677994"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="344677994"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 21:34:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="866400244"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="866400244"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jul 2023 21:34:46 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 2/2] iommu/vt-d: Remove rmrr check in domain attaching device path
Date:   Thu, 13 Jul 2023 12:32:48 +0800
Message-Id: <20230713043248.41315-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230713043248.41315-1-baolu.lu@linux.intel.com>
References: <20230713043248.41315-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The core code now prevents devices with RMRR regions from being assigned
to user space. There is no need to check for this condition in individual
drivers. Remove it to avoid duplicate code.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c | 58 -------------------------------------
 1 file changed, 58 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5c8c5cdc36cf..43a28bc60ce1 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2446,30 +2446,6 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 	return 0;
 }
 
-static bool device_has_rmrr(struct device *dev)
-{
-	struct dmar_rmrr_unit *rmrr;
-	struct device *tmp;
-	int i;
-
-	rcu_read_lock();
-	for_each_rmrr_units(rmrr) {
-		/*
-		 * Return TRUE if this RMRR contains the device that
-		 * is passed in.
-		 */
-		for_each_active_dev_scope(rmrr->devices,
-					  rmrr->devices_cnt, i, tmp)
-			if (tmp == dev ||
-			    is_downstream_to_pci_bridge(dev, tmp)) {
-				rcu_read_unlock();
-				return true;
-			}
-	}
-	rcu_read_unlock();
-	return false;
-}
-
 /**
  * device_rmrr_is_relaxable - Test whether the RMRR of this device
  * is relaxable (ie. is allowed to be not enforced under some conditions)
@@ -2499,34 +2475,6 @@ static bool device_rmrr_is_relaxable(struct device *dev)
 		return false;
 }
 
-/*
- * There are a couple cases where we need to restrict the functionality of
- * devices associated with RMRRs.  The first is when evaluating a device for
- * identity mapping because problems exist when devices are moved in and out
- * of domains and their respective RMRR information is lost.  This means that
- * a device with associated RMRRs will never be in a "passthrough" domain.
- * The second is use of the device through the IOMMU API.  This interface
- * expects to have full control of the IOVA space for the device.  We cannot
- * satisfy both the requirement that RMRR access is maintained and have an
- * unencumbered IOVA space.  We also have no ability to quiesce the device's
- * use of the RMRR space or even inform the IOMMU API user of the restriction.
- * We therefore prevent devices associated with an RMRR from participating in
- * the IOMMU API, which eliminates them from device assignment.
- *
- * In both cases, devices which have relaxable RMRRs are not concerned by this
- * restriction. See device_rmrr_is_relaxable comment.
- */
-static bool device_is_rmrr_locked(struct device *dev)
-{
-	if (!device_has_rmrr(dev))
-		return false;
-
-	if (device_rmrr_is_relaxable(dev))
-		return false;
-
-	return true;
-}
-
 /*
  * Return the required default domain type for a specific device.
  *
@@ -4139,12 +4087,6 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	int ret;
 
-	if (domain->type == IOMMU_DOMAIN_UNMANAGED &&
-	    device_is_rmrr_locked(dev)) {
-		dev_warn(dev, "Device is ineligible for IOMMU domain attach due to platform RMRR requirement.  Contact your platform vendor.\n");
-		return -EPERM;
-	}
-
 	if (info->domain)
 		device_block_translation(dev);
 
-- 
2.34.1

