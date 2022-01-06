Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71746485EAF
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344916AbiAFCYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:24:04 -0500
Received: from mga12.intel.com ([192.55.52.136]:3337 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344722AbiAFCWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:22:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435771; x=1672971771;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AR5i2NMwGfSOdi+HLgKnhlt3tjHftmsXmPOft4wFOHU=;
  b=goOwz0FsPCDiwKiIIRNd6XvrIt+KHMOZuKcd5wpTo3Fpo/ZrRFpiseln
   aifPXPlKhCWy034PriWEDuE3hBwdjCLM99DSYNYAh2nAydLqcUdD2EXI1
   ak7U4h35oU3PYjaDW9dQW0N/JVyXX6NgiHSJuU0MBbsNWTW//A9YgXLMa
   AZ7uOG1T3iIyhAx9bM1sG5yN85WTRMEvfHlKlFsEIU7t3vvzzucD6rTfp
   EH5dgsXLGVcDhqKQ6ce3Es213mVkJjJ6S3sYaKsKpxTcK7gWdUrWgvbwT
   L9DtOribYaY3aCJj+/jolE2guCSWdZ0rR2eLoUarzJ71iXy60NmAfuLPi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222571011"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="222571011"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:22:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794556"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:22:40 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v1 8/8] iommu: Remove iommu_attach/detach_group()
Date:   Thu,  6 Jan 2022 10:20:53 +0800
Message-Id: <20220106022053.2406748-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu_attach/detach_group() interfaces have no reference in the tree
anymore. Remove them to avoid dead code.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 15 ---------------
 drivers/iommu/iommu.c | 20 --------------------
 2 files changed, 35 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 66ebce3d1e11..2568ab0d0872 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -457,10 +457,6 @@ iommu_alloc_resv_region(phys_addr_t start, size_t length, int prot,
 extern int iommu_get_group_resv_regions(struct iommu_group *group,
 					struct list_head *head);
 
-extern int iommu_attach_group(struct iommu_domain *domain,
-			      struct iommu_group *group);
-extern void iommu_detach_group(struct iommu_domain *domain,
-			       struct iommu_group *group);
 extern struct iommu_group *iommu_group_alloc(void);
 extern void *iommu_group_get_iommudata(struct iommu_group *group);
 extern void iommu_group_set_iommudata(struct iommu_group *group,
@@ -818,17 +814,6 @@ static inline bool iommu_default_passthrough(void)
 	return true;
 }
 
-static inline int iommu_attach_group(struct iommu_domain *domain,
-				     struct iommu_group *group)
-{
-	return -ENODEV;
-}
-
-static inline void iommu_detach_group(struct iommu_domain *domain,
-				      struct iommu_group *group)
-{
-}
-
 static inline struct iommu_group *iommu_group_alloc(void)
 {
 	return ERR_PTR(-ENODEV);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 2c9efd85e447..33f7027e677f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2308,18 +2308,6 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 	return ret;
 }
 
-int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
-{
-	int ret;
-
-	mutex_lock(&group->mutex);
-	ret = __iommu_attach_group(domain, group);
-	mutex_unlock(&group->mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(iommu_attach_group);
-
 static int iommu_group_do_detach_device(struct device *dev, void *data)
 {
 	struct iommu_domain *domain = data;
@@ -2357,14 +2345,6 @@ static void __iommu_detach_group(struct iommu_domain *domain,
 		group->domain = group->default_domain;
 }
 
-void iommu_detach_group(struct iommu_domain *domain, struct iommu_group *group)
-{
-	mutex_lock(&group->mutex);
-	__iommu_detach_group(domain, group);
-	mutex_unlock(&group->mutex);
-}
-EXPORT_SYMBOL_GPL(iommu_detach_group);
-
 phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
 {
 	if (domain->type == IOMMU_DOMAIN_IDENTITY)
-- 
2.25.1

