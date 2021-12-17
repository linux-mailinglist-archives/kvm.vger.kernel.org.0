Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE4E478533
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 07:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhLQGjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 01:39:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:61855 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhLQGjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 01:39:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="237232563"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="237232563"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 22:39:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="519623456"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 16 Dec 2021 22:39:09 -0800
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
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 13/13] drm/tegra: Use the iommu dma_owner mechanism
Date:   Fri, 17 Dec 2021 14:37:08 +0800
Message-Id: <20211217063708.1740334-14-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
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
Tested-by: Dmitry Osipenko <digetx@gmail.com> # Nexus7 T30
---
 drivers/gpu/drm/tegra/dc.c   |  1 +
 drivers/gpu/drm/tegra/drm.c  | 54 +++++++++++++++++-------------------
 drivers/gpu/drm/tegra/gr2d.c |  1 +
 drivers/gpu/drm/tegra/gr3d.c |  1 +
 drivers/gpu/drm/tegra/vic.c  |  3 +-
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index a29d64f87563..8fd7a083cc44 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -3108,6 +3108,7 @@ struct platform_driver tegra_dc_driver = {
 	.driver = {
 		.name = "tegra-dc",
 		.of_match_table = tegra_dc_of_match,
+		.suppress_auto_claim_dma_owner = true,
 	},
 	.probe = tegra_dc_probe,
 	.remove = tegra_dc_remove,
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 8d37d6b00562..8a5fd390f85f 100644
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
@@ -941,48 +944,41 @@ int host1x_client_iommu_attach(struct host1x_client *client)
 	 * not the shared IOMMU domain, don't try to attach it to a different
 	 * domain. This allows using the IOMMU-backed DMA API.
 	 */
-	if (domain && domain != tegra->domain)
-		return 0;
+	client->group = NULL;
+	if (!client->dev->iommu_group || (domain && domain != tegra->domain))
+		return iommu_device_set_dma_owner(client->dev,
+						  DMA_OWNER_DMA_API, NULL);
 
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
 
 	if (client->group) {
-		/*
-		 * Devices that are part of the same group may no longer be
-		 * attached to a domain at this point because their group may
-		 * have been detached by an earlier client.
-		 */
-		domain = iommu_get_domain_for_dev(client->dev);
-		if (domain)
-			iommu_detach_group(tegra->domain, client->group);
-
-		iommu_group_put(client->group);
+		iommu_detach_device_shared(tegra->domain, client->dev);
+		iommu_device_release_dma_owner(client->dev,
+					       DMA_OWNER_PRIVATE_DOMAIN);
 		client->group = NULL;
+	} else {
+		iommu_device_release_dma_owner(client->dev, DMA_OWNER_DMA_API);
 	}
 }
 
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index de288cba3905..2e8bb9342da2 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -268,6 +268,7 @@ struct platform_driver tegra_gr2d_driver = {
 	.driver = {
 		.name = "tegra-gr2d",
 		.of_match_table = gr2d_match,
+		.suppress_auto_claim_dma_owner = true,
 	},
 	.probe = gr2d_probe,
 	.remove = gr2d_remove,
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index 24442ade0da3..20133ac59e78 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -397,6 +397,7 @@ struct platform_driver tegra_gr3d_driver = {
 	.driver = {
 		.name = "tegra-gr3d",
 		.of_match_table = tegra_gr3d_match,
+		.suppress_auto_claim_dma_owner = true,
 	},
 	.probe = gr3d_probe,
 	.remove = gr3d_remove,
diff --git a/drivers/gpu/drm/tegra/vic.c b/drivers/gpu/drm/tegra/vic.c
index c02010ff2b7f..b4f65574e36f 100644
--- a/drivers/gpu/drm/tegra/vic.c
+++ b/drivers/gpu/drm/tegra/vic.c
@@ -523,7 +523,8 @@ struct platform_driver tegra_vic_driver = {
 	.driver = {
 		.name = "tegra-vic",
 		.of_match_table = tegra_vic_of_match,
-		.pm = &vic_pm_ops
+		.pm = &vic_pm_ops,
+		.suppress_auto_claim_dma_owner = true,
 	},
 	.probe = vic_probe,
 	.remove = vic_remove,
-- 
2.25.1

