Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8799946034E
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 03:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356600AbhK1C6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 21:58:21 -0500
Received: from mga14.intel.com ([192.55.52.115]:46183 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240916AbhK1C4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 21:56:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="236040305"
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="236040305"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2021 18:53:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,270,1631602800"; 
   d="scan'208";a="652489221"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 27 Nov 2021 18:52:54 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v2 17/17] drm/tegra: Use the iommu dma_owner mechanism
Date:   Sun, 28 Nov 2021 10:50:51 +0800
Message-Id: <20211128025051.355578-18-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128025051.355578-1-baolu.lu@linux.intel.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Tegra joins many platform devices onto the same iommu_domain and builds
sort-of a DMA API on top of it.

Given that iommu_attach/detatch_device_shared() has supported this usage
model. Each device that wants to use the special domain will use
suppress_auto_claim_dma_owner and call iommu_attach_device_shared() which
will use dma owner framework to lock out other usages of the group and
refcount the domain attachment.

When the last device calls detatch the domain will be disconnected.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/gpu/drm/tegra/dc.c   |  1 +
 drivers/gpu/drm/tegra/drm.c  | 55 ++++++++++++++++++------------------
 drivers/gpu/drm/tegra/gr2d.c |  1 +
 drivers/gpu/drm/tegra/gr3d.c |  1 +
 drivers/gpu/drm/tegra/vic.c  |  1 +
 5 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index a29d64f87563..3a2458f56fbc 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -3111,4 +3111,5 @@ struct platform_driver tegra_dc_driver = {
 	},
 	.probe = tegra_dc_probe,
 	.remove = tegra_dc_remove,
+	.suppress_auto_claim_dma_owner = true,
 };
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 8d37d6b00562..e6e2da799674 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -928,12 +928,15 @@ int tegra_drm_unregister_client(struct tegra_drm *tegra,
 	return 0;
 }
 
+/*
+ * Clients which use this function must set suppress_auto_claim_dma_owner in
+ * their platform_driver's device_driver struct.
+ */
 int host1x_client_iommu_attach(struct host1x_client *client)
 {
 	struct iommu_domain *domain = iommu_get_domain_for_dev(client->dev);
 	struct drm_device *drm = dev_get_drvdata(client->host);
 	struct tegra_drm *tegra = drm->dev_private;
-	struct iommu_group *group = NULL;
 	int err;
 
 	/*
@@ -941,47 +944,45 @@ int host1x_client_iommu_attach(struct host1x_client *client)
 	 * not the shared IOMMU domain, don't try to attach it to a different
 	 * domain. This allows using the IOMMU-backed DMA API.
 	 */
+	client->group = NULL;
 	if (domain && domain != tegra->domain)
+		return iommu_device_set_dma_owner(client->dev,
+						  DMA_OWNER_DMA_API, NULL);
+
+	if (!tegra->domain)
 		return 0;
 
-	if (tegra->domain) {
-		group = iommu_group_get(client->dev);
-		if (!group)
-			return -ENODEV;
-
-		if (domain != tegra->domain) {
-			err = iommu_attach_group(tegra->domain, group);
-			if (err < 0) {
-				iommu_group_put(group);
-				return err;
-			}
-		}
+	err = iommu_device_set_dma_owner(client->dev,
+					 DMA_OWNER_PRIVATE_DOMAIN, NULL);
+	if (err)
+		return err;
 
-		tegra->use_explicit_iommu = true;
+	err = iommu_attach_device_shared(tegra->domain, client->dev);
+	if (err) {
+		iommu_device_release_dma_owner(client->dev,
+					       DMA_OWNER_PRIVATE_DOMAIN);
+		return err;
 	}
 
-	client->group = group;
-
+	tegra->use_explicit_iommu = true;
+	client->group = client->dev->iommu_group;
 	return 0;
 }
 
 void host1x_client_iommu_detach(struct host1x_client *client)
 {
+	struct iommu_domain *domain = iommu_get_domain_for_dev(client->dev);
 	struct drm_device *drm = dev_get_drvdata(client->host);
 	struct tegra_drm *tegra = drm->dev_private;
-	struct iommu_domain *domain;
 
-	if (client->group) {
-		/*
-		 * Devices that are part of the same group may no longer be
-		 * attached to a domain at this point because their group may
-		 * have been detached by an earlier client.
-		 */
-		domain = iommu_get_domain_for_dev(client->dev);
-		if (domain)
-			iommu_detach_group(tegra->domain, client->group);
+	if (domain && domain != tegra->domain)
+		return iommu_device_release_dma_owner(client->dev,
+						      DMA_OWNER_DMA_API);
 
-		iommu_group_put(client->group);
+	if (client->group) {
+		iommu_detach_device_shared(tegra->domain, client->dev);
+		iommu_device_release_dma_owner(client->dev,
+					       DMA_OWNER_PRIVATE_DOMAIN);
 		client->group = NULL;
 	}
 }
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index de288cba3905..8d92141c3c86 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -271,4 +271,5 @@ struct platform_driver tegra_gr2d_driver = {
 	},
 	.probe = gr2d_probe,
 	.remove = gr2d_remove,
+	.suppress_auto_claim_dma_owner = true,
 };
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index 24442ade0da3..33c4954977ab 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -400,4 +400,5 @@ struct platform_driver tegra_gr3d_driver = {
 	},
 	.probe = gr3d_probe,
 	.remove = gr3d_remove,
+	.suppress_auto_claim_dma_owner = true,
 };
diff --git a/drivers/gpu/drm/tegra/vic.c b/drivers/gpu/drm/tegra/vic.c
index c02010ff2b7f..114df067ea00 100644
--- a/drivers/gpu/drm/tegra/vic.c
+++ b/drivers/gpu/drm/tegra/vic.c
@@ -527,6 +527,7 @@ struct platform_driver tegra_vic_driver = {
 	},
 	.probe = vic_probe,
 	.remove = vic_remove,
+	.suppress_auto_claim_dma_owner = true,
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_124_SOC)
-- 
2.25.1

