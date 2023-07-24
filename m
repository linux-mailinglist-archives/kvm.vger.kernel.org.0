Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB7A75EB37
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 08:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjGXGGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 02:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjGXGF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 02:05:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C98CF;
        Sun, 23 Jul 2023 23:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690178757; x=1721714757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FoCKkcydOPQOX0aL5oEhPhvaQzzIMHxM6fkbC36piNA=;
  b=N6k9vMxdSwK9RQoafJXXGzOzmYH1y0+cgpy6G8PQJESlo1/fr90PItMI
   g5HJSY4YQpivJJ1RECUr6xu3tHPeCNmz0XTJTXewqSZNsS7/bDODOjHX3
   51TEwhpx4Lxv6d+JGa6eEGKe+iCHkynREAlhC0051npG9FwzvQe9dgmVm
   TlNSE7EjCfFqCzq70NJmY67aWq1A2c4veKhMOD0foHLPxh8v3xdHE78tJ
   wy1gzWhaVSHLANBRkGmpreU2/BEYfsESeCZbZGefn1rUJTZo/VqYYxvCx
   Ilbv7af4b6HJpjKrQt43BClEOofB1DCua4bPQCFqWI6l/JuyYlYifRK8S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="346955258"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="346955258"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 23:05:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="972134575"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="972134575"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jul 2023 23:05:54 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 1/2] iommu: Prevent RESV_DIRECT devices from blocking domains
Date:   Mon, 24 Jul 2023 14:03:51 +0800
Message-Id: <20230724060352.113458-2-baolu.lu@linux.intel.com>
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/iommu.h |  2 ++
 drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b1dcb1b9b170..07377fe7b72c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -410,6 +410,7 @@ struct iommu_fault_param {
  * @max_pasids:  number of PASIDs this device can consume
  * @attach_deferred: the dma domain attachment is deferred
  * @pci_32bit_workaround: Limit DMA allocations to 32-bit IOVAs
+ * @require_direct: device requires IOMMU_RESV_DIRECT regions
  *
  * TODO: migrate other per device data pointers under iommu_dev_data, e.g.
  *	struct iommu_group	*iommu_group;
@@ -424,6 +425,7 @@ struct dev_iommu {
 	u32				max_pasids;
 	u32				attach_deferred:1;
 	u32				pci_32bit_workaround:1;
+	u32				require_direct:1;
 };
 
 int iommu_device_register(struct iommu_device *iommu,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 4352a149a935..1283460bfa33 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1014,14 +1014,12 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
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
@@ -1029,13 +1027,17 @@ static int iommu_create_device_direct_mappings(struct iommu_domain *domain,
 		dma_addr_t start, end, addr;
 		size_t map_size = 0;
 
+		if (entry->type == IOMMU_RESV_DIRECT)
+			dev->iommu->require_direct = 1;
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
 
@@ -2135,6 +2137,21 @@ static int __iommu_device_set_domain(struct iommu_group *group,
 {
 	int ret;
 
+	/*
+	 * If the device requires IOMMU_RESV_DIRECT then we cannot allow
+	 * the blocking domain to be attached as it does not contain the
+	 * required 1:1 mapping. This test effectively excludes the device
+	 * being used with iommu_group_claim_dma_owner() which will block
+	 * vfio and iommufd as well.
+	 */
+	if (dev->iommu->require_direct &&
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

