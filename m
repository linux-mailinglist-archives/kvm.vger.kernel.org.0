Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF6E25864A
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 05:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIADkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 23:40:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:62487 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgIADkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 23:40:13 -0400
IronPort-SDR: Ouwm8mi3EjYZswVXAjDRuIzqQZfYUsAzlZ2PzM3ElSKQhDhZGSpqgWRu6y2L313TyG8o+i9nkm
 gLRa1dKg73SA==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="136620920"
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="136620920"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 20:40:12 -0700
IronPort-SDR: 1kfNDpxVZ6PjA9CK/YbklI2otaiSCxb5Hzrt0nE6YVckEQ9BAy5kwhn0hOaSxj3FTWfku0VgS4
 ccCggZH6ZUZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="325180863"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 31 Aug 2020 20:40:09 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 1/5] iommu: Add optional subdev in aux_at(de)tach ops
Date:   Tue,  1 Sep 2020 11:34:18 +0800
Message-Id: <20200901033422.22249-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200901033422.22249-1-baolu.lu@linux.intel.com>
References: <20200901033422.22249-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the vfio/mdev use case of aux-domain, the subdevices are created from
the physical devices with IOMMU_DEV_FEAT_AUX enabled and the aux-domains
are attached to the subdevices through the iommu_ops.aux_attach_dev()
interface.

Current iommu_ops.aux_at(de)tach_dev() design only takes the aux-domain
and the physical device as the parameters, this is insufficient if we
want the vendor iommu drivers to learn the knowledge about relationships
between the aux-domains and the subdevices. Add a @subdev parameter to
iommu_ops.aux_at(de)tach_dev() interfaces so that a subdevice could be
opt-in.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 10 ++++++----
 drivers/iommu/iommu.c       |  4 ++--
 include/linux/iommu.h       |  6 ++++--
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index bce158468abf..3c12fd06856c 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5338,8 +5338,9 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	return domain_add_dev_info(to_dmar_domain(domain), dev);
 }
 
-static int intel_iommu_aux_attach_device(struct iommu_domain *domain,
-					 struct device *dev)
+static int
+intel_iommu_aux_attach_device(struct iommu_domain *domain,
+			      struct device *dev, struct device *subdev)
 {
 	int ret;
 
@@ -5359,8 +5360,9 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 	dmar_remove_one_dev_info(dev);
 }
 
-static void intel_iommu_aux_detach_device(struct iommu_domain *domain,
-					  struct device *dev)
+static void
+intel_iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev,
+			      struct device *subdev)
 {
 	aux_domain_remove_dev(to_dmar_domain(domain), dev);
 }
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 609bd25bf154..38cdfeb887e1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2728,7 +2728,7 @@ int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
 	int ret = -ENODEV;
 
 	if (domain->ops->aux_attach_dev)
-		ret = domain->ops->aux_attach_dev(domain, dev);
+		ret = domain->ops->aux_attach_dev(domain, dev, NULL);
 
 	if (!ret)
 		trace_attach_device_to_domain(dev);
@@ -2740,7 +2740,7 @@ EXPORT_SYMBOL_GPL(iommu_aux_attach_device);
 void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
 {
 	if (domain->ops->aux_detach_dev) {
-		domain->ops->aux_detach_dev(domain, dev);
+		domain->ops->aux_detach_dev(domain, dev, NULL);
 		trace_detach_device_from_domain(dev);
 	}
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index fee209efb756..871267104915 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -279,8 +279,10 @@ struct iommu_ops {
 	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
 
 	/* Aux-domain specific attach/detach entries */
-	int (*aux_attach_dev)(struct iommu_domain *domain, struct device *dev);
-	void (*aux_detach_dev)(struct iommu_domain *domain, struct device *dev);
+	int (*aux_attach_dev)(struct iommu_domain *domain, struct device *dev,
+			      struct device *subdev);
+	void (*aux_detach_dev)(struct iommu_domain *domain, struct device *dev,
+			       struct device *subdev);
 	int (*aux_get_pasid)(struct iommu_domain *domain, struct device *dev);
 
 	struct iommu_sva *(*sva_bind)(struct device *dev, struct mm_struct *mm,
-- 
2.17.1

