Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158DE75EB39
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 08:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjGXGGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 02:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjGXGGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 02:06:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCA71BC;
        Sun, 23 Jul 2023 23:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690178760; x=1721714760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HLjU3QgSA6TPGmviy//Ll0K/qMQxNQQQeUIIIynZXqY=;
  b=A5rcAAHbMTRHAThYmgmotRJFrICJY+5M8cx6j2OMQE4HrHOcXjNFKJUi
   MFMQ5SLlMm4H0GKN+Uq+8u5FXXGTDr2ygruAXHnmZsTrqNUBlpQJ2Gjno
   H0J5oJu5ScRZ3aOCxDLxEVZAFYcna6D1xBAIgirrwpj6MDjOtYio6yDhd
   3m1U3fikzqfaT5bYbeaQWou7CivqRhvknZAMe8W/Yassn0VWw+Eiiq1N1
   OnKUDHMoa/GZUd7WTmD/Kqdwh8RCsfmrjtXAX+Ft0bRgutbHmpN6lgbHJ
   oywS6VNgCsLv3JEKybfzPu2EwOKeqI7+4debHyQj++79rZyCwMO5vTYe9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="346955274"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="346955274"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 23:06:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="972134581"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="972134581"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jul 2023 23:05:57 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 2/2] iommu/vt-d: Remove rmrr check in domain attaching device path
Date:   Mon, 24 Jul 2023 14:03:52 +0800
Message-Id: <20230724060352.113458-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230724060352.113458-1-baolu.lu@linux.intel.com>
References: <20230724060352.113458-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/iommu/intel/iommu.c | 58 -------------------------------------
 1 file changed, 58 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d5ca2387e65c..de529d522b03 100644
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
@@ -4132,12 +4080,6 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
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

