Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C477273AD9
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 08:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgIVG05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 02:26:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:45992 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728136AbgIVG05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 02:26:57 -0400
IronPort-SDR: 9jLNz8htZR2NY0oRVBIkcdeg99bP4u4HGcFb0COjA6t11BeQtAfQHONZ1hY/f2kQcttveiFpe0
 zRqela92PWjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="140023323"
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="140023323"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 23:17:07 -0700
IronPort-SDR: 7daS5tNwrWWqpl3taPoJ6/0qgFYro8nsiX7I+NgbHENCuINJfavq8dK3F4n2FXE0i0OMqRTjE+
 mTe4v5vFj90Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="334877460"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 21 Sep 2020 23:17:03 -0700
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
Subject: [PATCH v5 4/5] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
Date:   Tue, 22 Sep 2020 14:10:41 +0800
Message-Id: <20200922061042.31633-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922061042.31633-1-baolu.lu@linux.intel.com>
References: <20200922061042.31633-1-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace iommu_aux_at(de)tach_device() with iommu_at(de)tach_subdev_group().

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 43 +++++----------------------------
 1 file changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c255a6683f31..869a71c258d1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1690,45 +1690,13 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
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
+		return iommu_attach_subdev_group(domain->domain,
+						 group->iommu_group,
+						 vfio_mdev_get_iommu_device);
 	else
 		return iommu_attach_group(domain->domain, group->iommu_group);
 }
@@ -1737,8 +1705,9 @@ static void vfio_iommu_detach_group(struct vfio_domain *domain,
 				    struct vfio_group *group)
 {
 	if (group->mdev_group)
-		iommu_group_for_each_dev(group->iommu_group, domain->domain,
-					 vfio_mdev_detach_domain);
+		iommu_detach_subdev_group(domain->domain,
+					  group->iommu_group,
+					  vfio_mdev_get_iommu_device);
 	else
 		iommu_detach_group(domain->domain, group->iommu_group);
 }
-- 
2.17.1

