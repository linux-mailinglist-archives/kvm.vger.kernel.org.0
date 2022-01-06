Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230A5485E99
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344702AbiAFCWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:22:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:10004 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344746AbiAFCWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:22:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435738; x=1672971738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8AHskV6R7ecHOW1ezHMh2nWxqBL3edvB+iZHHwk5/6w=;
  b=iN5SikttukiMicRQj1Uxxjy6lm0BTFGMQCLc5BXckzclicyrF6HNAGGx
   W9CIYt3WN4seYw76YZRouttcjFcvhzdw46LHPbEAT6Sjwfj79FpTgf8sz
   5vxu+9d2R0f+RIHXsuNB8+chyVSttEjvwJC6Qkf1p67OdLBqm9PUweD6q
   wg7wQxBfwAUhBpPshzjbb29UvxPSA5Bud8+YOz7kWttnwL0W8dxa6zjb4
   X9rJFRpkOGSpidiP11mWe7QklhJCR5jpP5OFyGuKIEs5QYp7hc2q4Rhmb
   0d8Ig34k7dvQWDA3Wcz0DVobm/FgL2jVkd6LU10LiHdApOf+Bm4VPi5cp
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242371376"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="242371376"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:22:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794374"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:22:10 -0800
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
Subject: [PATCH v1 4/8] drm/tegra: Use iommu_attach/detatch_device()
Date:   Thu,  6 Jan 2022 10:20:49 +0800
Message-Id: <20220106022053.2406748-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

Tegra joins many platform devices onto the same iommu_domain and builds
sort-of a DMA API on top of it.

Given that iommu_attach/detatch_device() has supported this usage model,
each device that wants to use the special domain could set the
no_kernel_api_dma field of the driver structure and call
iommu_attach/detach_device() directly which will use dma owner framework
to lock out other usages of the group and refcount the domain attachment.

When the last device calls detatch the domain will be disconnected.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/gpu/drm/tegra/dc.c   |  1 +
 drivers/gpu/drm/tegra/drm.c  | 47 ++++++++++++------------------------
 drivers/gpu/drm/tegra/gr2d.c |  1 +
 drivers/gpu/drm/tegra/gr3d.c |  1 +
 drivers/gpu/drm/tegra/vic.c  |  1 +
 5 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index a29d64f87563..0da50b39ce00 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -3111,4 +3111,5 @@ struct platform_driver tegra_dc_driver = {
 	},
 	.probe = tegra_dc_probe,
 	.remove = tegra_dc_remove,
+	.no_kernel_api_dma = true,
 };
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 8d37d6b00562..d6c57a40b772 100644
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
@@ -941,48 +944,30 @@ int host1x_client_iommu_attach(struct host1x_client *client)
 	 * not the shared IOMMU domain, don't try to attach it to a different
 	 * domain. This allows using the IOMMU-backed DMA API.
 	 */
-	if (domain && domain != tegra->domain)
-		return 0;
-
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
-
-		tegra->use_explicit_iommu = true;
-	}
+	client->group = NULL;
+	if (!client->dev->iommu_group || (domain && domain != tegra->domain))
+		return iommu_device_use_dma_api(client->dev);
 
-	client->group = group;
+	err = iommu_attach_device(tegra->domain, client->dev);
+	if (err)
+		return err;
 
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
+		iommu_detach_device(tegra->domain, client->dev);
 		client->group = NULL;
+	} else {
+		iommu_device_unuse_dma_api(client->dev);
 	}
 }
 
diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
index de288cba3905..6fd502c1cdbf 100644
--- a/drivers/gpu/drm/tegra/gr2d.c
+++ b/drivers/gpu/drm/tegra/gr2d.c
@@ -271,4 +271,5 @@ struct platform_driver tegra_gr2d_driver = {
 	},
 	.probe = gr2d_probe,
 	.remove = gr2d_remove,
+	.no_kernel_api_dma = true,
 };
diff --git a/drivers/gpu/drm/tegra/gr3d.c b/drivers/gpu/drm/tegra/gr3d.c
index 24442ade0da3..d47794b6394f 100644
--- a/drivers/gpu/drm/tegra/gr3d.c
+++ b/drivers/gpu/drm/tegra/gr3d.c
@@ -400,4 +400,5 @@ struct platform_driver tegra_gr3d_driver = {
 	},
 	.probe = gr3d_probe,
 	.remove = gr3d_remove,
+	.no_kernel_api_dma = true,
 };
diff --git a/drivers/gpu/drm/tegra/vic.c b/drivers/gpu/drm/tegra/vic.c
index c02010ff2b7f..167de5509c3b 100644
--- a/drivers/gpu/drm/tegra/vic.c
+++ b/drivers/gpu/drm/tegra/vic.c
@@ -527,6 +527,7 @@ struct platform_driver tegra_vic_driver = {
 	},
 	.probe = vic_probe,
 	.remove = vic_remove,
+	.no_kernel_api_dma = true,
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_124_SOC)
-- 
2.25.1

