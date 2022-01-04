Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14AF483A3C
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiADB6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:58:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:41218 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232144AbiADB6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261514; x=1672797514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wQci6HBpv6XvqYLNbzg26Elb7J8EsCGKUpoMwBN076A=;
  b=PnBQLEy5jCaKzKcb8R4GKD0b+jsdP4yEY/h0+mVOzFiEUlyGUGv988FO
   loDrdKNRYOCPRZiQ0FsxOGrR3cELIGv5/b753nQdyk7WI5HUXcAnbKQ9X
   UaeHwcKHyoHU1DkiiZFhXahiMCEz7OzSjEiomMd/uqqEYSH5I8oFuG1RS
   CDp+YcdlEvPuA0xcWv2GOaZD7PUuOR19VRB3eI0lCJOCCiseGC/XXY+tB
   +TJozgnQOXtfi7GqDGKniPB2Hs0XvxbnJWHCUOlltvhEzQ7R25JEbn0U0
   uBH6fX1xXPz+XbQW6pnzQqfp0fx+D2U72ufqTlAx4NkBk90CEaoP5Io49
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="239682507"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="239682507"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="667573315"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2022 17:58:28 -0800
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
Subject: [PATCH v5 10/14] vfio: Set DMA ownership for VFIO devices
Date:   Tue,  4 Jan 2022 09:56:40 +0800
Message-Id: <20220104015644.2294354-11-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claim group dma ownership when an iommu group is set to a container,
and release DMA_OWNER_USER once the iommu group is unset from the
container.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c     |  1 +
 drivers/vfio/pci/vfio_pci.c           |  1 +
 drivers/vfio/platform/vfio_amba.c     |  1 +
 drivers/vfio/platform/vfio_platform.c |  1 +
 drivers/vfio/vfio.c                   | 10 +++++++++-
 5 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 6e2e62c6f47a..f133971d1c1f 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -588,6 +588,7 @@ static struct fsl_mc_driver vfio_fsl_mc_driver = {
 		.name	= "vfio-fsl-mc",
 		.owner	= THIS_MODULE,
 	},
+	.no_kernel_api_dma = true,
 };
 
 static int __init vfio_fsl_mc_driver_init(void)
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a5ce92beb655..8cd1e5a855da 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -193,6 +193,7 @@ static struct pci_driver vfio_pci_driver = {
 	.remove			= vfio_pci_remove,
 	.sriov_configure	= vfio_pci_sriov_configure,
 	.err_handler		= &vfio_pci_core_err_handlers,
+	.no_kernel_api_dma = true,
 };
 
 static void __init vfio_pci_fill_ids(void)
diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index badfffea14fb..39407ca143d5 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -95,6 +95,7 @@ static struct amba_driver vfio_amba_driver = {
 		.name = "vfio-amba",
 		.owner = THIS_MODULE,
 	},
+	.no_kernel_api_dma = true,
 };
 
 module_amba_driver(vfio_amba_driver);
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 68a1c87066d7..46848a58fc99 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -76,6 +76,7 @@ static struct platform_driver vfio_platform_driver = {
 	.driver	= {
 		.name	= "vfio-platform",
 	},
+	.no_kernel_api_dma = true,
 };
 
 module_platform_driver(vfio_platform_driver);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 735d1d344af9..ef22fa312c2a 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1198,6 +1198,8 @@ static void __vfio_group_unset_container(struct vfio_group *group)
 		driver->ops->detach_group(container->iommu_data,
 					  group->iommu_group);
 
+	iommu_group_release_dma_owner(group->iommu_group);
+
 	group->container = NULL;
 	wake_up(&group->container_q);
 	list_del(&group->container_next);
@@ -1282,13 +1284,19 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
 		goto unlock_out;
 	}
 
+	ret = iommu_group_set_dma_owner(group->iommu_group, f.file);
+	if (ret)
+		goto unlock_out;
+
 	driver = container->iommu_driver;
 	if (driver) {
 		ret = driver->ops->attach_group(container->iommu_data,
 						group->iommu_group,
 						group->type);
-		if (ret)
+		if (ret) {
+			iommu_group_release_dma_owner(group->iommu_group);
 			goto unlock_out;
+		}
 	}
 
 	group->container = container;
-- 
2.25.1

