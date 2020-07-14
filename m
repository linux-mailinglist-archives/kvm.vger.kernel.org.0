Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D977821E7D0
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 08:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgGNGCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 02:02:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:3745 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgGNGCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 02:02:02 -0400
IronPort-SDR: SgZvQydhEvoCWj3cQ8nk0SwqF9yZCcXHq6bvLM4Pemhs43drDwzAdlWo48BBfSzZUpZnUqQm8g
 XRRXbHy7i5uA==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148812793"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="148812793"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 23:02:02 -0700
IronPort-SDR: sROqWG6d4AFrPOSmY+gwkD+CtO1ZhCUGL8UHxl19xBSHuzj7kxFNhObfuFz5vi4aN0TkNYscBU
 i2Wd11r1qm1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="324450220"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jul 2020 23:01:58 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
Date:   Tue, 14 Jul 2020 13:57:03 +0800
Message-Id: <20200714055703.5510-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714055703.5510-1-baolu.lu@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the
vfio_group data structure so that it could be reused in other places.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 44 ++++++---------------------------
 1 file changed, 7 insertions(+), 37 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5e556ac9102a..f8812e68de77 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,7 @@ struct vfio_dma {
 struct vfio_group {
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
+	struct device		*iommu_device;
 	bool			mdev_group;	/* An mdev group */
 	bool			pinned_page_dirty_scope;
 };
@@ -1627,45 +1628,13 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
 	return NULL;
 }
 
-static int vfio_mdev_attach_domain(struct device *dev, void *data)
-{
-	struct iommu_domain *domain = data;
-	struct device *iommu_device;
-
-	iommu_device = vfio_mdev_get_iommu_device(dev);
-	if (iommu_device) {
-		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
-			return iommu_aux_attach_device(domain, iommu_device);
-		else
-			return iommu_attach_device(domain, iommu_device);
-	}
-
-	return -EINVAL;
-}
-
-static int vfio_mdev_detach_domain(struct device *dev, void *data)
-{
-	struct iommu_domain *domain = data;
-	struct device *iommu_device;
-
-	iommu_device = vfio_mdev_get_iommu_device(dev);
-	if (iommu_device) {
-		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
-			iommu_aux_detach_device(domain, iommu_device);
-		else
-			iommu_detach_device(domain, iommu_device);
-	}
-
-	return 0;
-}
-
 static int vfio_iommu_attach_group(struct vfio_domain *domain,
 				   struct vfio_group *group)
 {
 	if (group->mdev_group)
-		return iommu_group_for_each_dev(group->iommu_group,
-						domain->domain,
-						vfio_mdev_attach_domain);
+		return iommu_aux_attach_group(domain->domain,
+					      group->iommu_group,
+					      group->iommu_device);
 	else
 		return iommu_attach_group(domain->domain, group->iommu_group);
 }
@@ -1674,8 +1643,8 @@ static void vfio_iommu_detach_group(struct vfio_domain *domain,
 				    struct vfio_group *group)
 {
 	if (group->mdev_group)
-		iommu_group_for_each_dev(group->iommu_group, domain->domain,
-					 vfio_mdev_detach_domain);
+		iommu_aux_detach_group(domain->domain, group->iommu_group,
+				       group->iommu_device);
 	else
 		iommu_detach_group(domain->domain, group->iommu_group);
 }
@@ -2007,6 +1976,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			return 0;
 		}
 
+		group->iommu_device = iommu_device;
 		bus = iommu_device->bus;
 	}
 
-- 
2.17.1

