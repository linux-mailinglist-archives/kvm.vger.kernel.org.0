Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E37751789
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 06:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbjGMEeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 00:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbjGMEer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 00:34:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC052E69;
        Wed, 12 Jul 2023 21:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689222886; x=1720758886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/qWNNFdf7RmjwCwpIRIp2QIj/P5FBdLOofsL04ks3Q=;
  b=OXL7JpVvy2vPwg09rYRQH67ow4Xtx0emRWMhAhpvhKTaKi5VIUc3x9Qr
   QjSiAAAblxeN/ZuyxcLFdkDnJgIN1GpDIn8SEkui6ekyUTmX9W6H5KNNe
   o+lutEEs3C/0oSILBSWK5sfbPLVLWuhWEK4IQWBtcY2O8SfygWjelB8HH
   H6Ri4mFsYGF8uJZYPWwt2dV3CpLRL7ubYXHPBg5xorgUtb5moxK3Pjf83
   YjJkeqt1NMYabEutYSwM+OiKP+wiVefUvEqGPmIMO2+n5FkAfHuETjbZj
   7IszNE4PnbslZWDKNzxA0hoDj2LCb2nxoCSI72Xu49Z9ZLo0uq0wjOLYx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="344677984"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="344677984"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 21:34:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="866400219"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="866400219"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jul 2023 21:34:43 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 1/2] iommu: Prevent RESV_DIRECT devices from blocking domains
Date:   Thu, 13 Jul 2023 12:32:47 +0800
Message-Id: <20230713043248.41315-2-baolu.lu@linux.intel.com>
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

The IOMMU_RESV_DIRECT flag indicates that a memory region must be mapped
1:1 at all times. This means that the region must always be accessible to
the device, even if the device is attached to a blocking domain. This is
equal to saying that IOMMU_RESV_DIRECT flag prevents devices from being
attached to blocking domains.

This also implies that devices that implement RESV_DIRECT regions will be
prevented from being assigned to user space since taking the DMA ownership
immediately switches to a blocking domain.

The rule of preventing devices with the IOMMU_RESV_DIRECT regions from
being assigned to user space has existed in the Intel IOMMU driver for
a long time. Now, this rule is being lifted up to a general core rule,
as other architectures like AMD and ARM also have RMRR-like reserved
regions. This has been discussed in the community mailing list and refer
to below link for more details.

Other places using unmanaged domains for kernel DMA must follow the
iommu_get_resv_regions() and setup IOMMU_RESV_DIRECT - we do not restrict
them in the core code.

Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/linux-iommu/BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h |  2 ++
 drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d31642596675..fd18019ac951 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -409,6 +409,7 @@ struct iommu_fault_param {
  * @priv:	 IOMMU Driver private data
  * @max_pasids:  number of PASIDs this device can consume
  * @attach_deferred: the dma domain attachment is deferred
+ * @requires_direct: The driver requested IOMMU_RESV_DIRECT
  *
  * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
  *	struct iommu_group	*iommu_group;
@@ -422,6 +423,7 @@ struct dev_iommu {
 	void				*priv;
 	u32				max_pasids;
 	u32				attach_deferred:1;
+	u32				requires_direct:1;
 };
 
 int iommu_device_register(struct iommu_device *iommu,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index da340f11c5f5..db9494f8cf75 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -959,14 +959,12 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
 	unsigned long pg_size;
 	int ret = 0;
 
-	if (!iommu_is_dma_domain(domain))
-		return 0;
-
-	BUG_ON(!domain->pgsize_bitmap);
-
-	pg_size = 1UL << __ffs(domain->pgsize_bitmap);
+	pg_size = domain->pgsize_bitmap ? 1UL << __ffs(domain->pgsize_bitmap) : 0;
 	INIT_LIST_HEAD(&mappings);
 
+	if (WARN_ON_ONCE(iommu_is_dma_domain(domain) && !pg_size))
+		return -EINVAL;
+
 	iommu_get_resv_regions(dev, &mappings);
 
 	/* We need to consider overlapping regions for different devices */
@@ -974,13 +972,17 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
 		dma_addr_t start, end, addr;
 		size_t map_size = 0;
 
+		if (entry->type == IOMMU_RESV_DIRECT)
+			dev->iommu->requires_direct = 1;
+
+		if ((entry->type != IOMMU_RESV_DIRECT &&
+		     entry->type != IOMMU_RESV_DIRECT_RELAXABLE) ||
+		    !iommu_is_dma_domain(domain))
+			continue;
+
 		start = ALIGN(entry->start, pg_size);
 		end   = ALIGN(entry->start + entry->length, pg_size);
 
-		if (entry->type != IOMMU_RESV_DIRECT &&
-		    entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
-			continue;
-
 		for (addr = start; addr <= end; addr += pg_size) {
 			phys_addr_t phys_addr;
 
@@ -2121,6 +2123,21 @@ static int __iommu_device_set_domain(struct iommu_group *group,
 {
 	int ret;
 
+	/*
+	 * If the driver has requested IOMMU_RESV_DIRECT then we cannot allow
+	 * the blocking domain to be attached as it does not contain the
+	 * required 1:1 mapping. This test effectively exclusive the device from
+	 * being used with iommu_group_claim_dma_owner() which will block vfio
+	 * and iommufd as well.
+	 */
+	if (dev->iommu->requires_direct &&
+	    (new_domain->type == IOMMU_DOMAIN_BLOCKED ||
+	     new_domain == group->blocking_domain)) {
+		dev_warn(dev,
+			 "Firmware has requested this device have a 1:1 IOMMU mapping, rejecting configuring the device without a 1:1 mapping. Contact your platform vendor.\n");
+		return -EINVAL;
+	}
+
 	if (dev->iommu->attach_deferred) {
 		if (new_domain == group->default_domain)
 			return 0;
-- 
2.34.1

