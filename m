Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82867485EAC
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344905AbiAFCX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:23:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:3335 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344796AbiAFCWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435770; x=1672971770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rJCHc+7rEGzzzZ26n+LFYyMzqMy4eMF/FP0CIBhFlrQ=;
  b=SGfXpxd5qSC07R+OUutcwmIaPCNy4ucqI2ie6pYbWnnzpW+HcXllrlpF
   svEqf77IByGegIly9V3oYs0w5h6JZRa//VQq7Q0JE45qyNBCTf7Z0RU1I
   8n4HMATaqIc8JB7RES+k8KYRjX7GknjbVnK8W6iOAERVdBcMD2LgdgGDS
   nFCTwyRqBPslNHzJQqrJsi0f9ihX9nAKExJph0vCb7QrI6pITivT3/ozY
   X93bjBpJF8aG7wjh9Gz/6HnCgNTQdFJsMRa0F8TTiasv6ZjoSEwmNqOZV
   by3StD86ajQGv/jNXqlVwnadXhDYNP6wML/+aJb9cUYMHWAFygD18/oxD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222571003"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="222571003"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:22:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794519"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:22:31 -0800
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
Subject: [PATCH v1 7/8] media: staging: media: tegra-vde: Use iommu_attach/detach_device()
Date:   Thu,  6 Jan 2022 10:20:52 +0800
Message-Id: <20220106022053.2406748-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ordinary drivers should use iommu_attach/detach_device() for domain
attaching and detaching.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/staging/media/tegra-vde/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/tegra-vde/iommu.c b/drivers/staging/media/tegra-vde/iommu.c
index adf8dc7ee25c..a6e6eb28f1e3 100644
--- a/drivers/staging/media/tegra-vde/iommu.c
+++ b/drivers/staging/media/tegra-vde/iommu.c
@@ -91,7 +91,7 @@ int tegra_vde_iommu_init(struct tegra_vde *vde)
 	order = __ffs(vde->domain->pgsize_bitmap);
 	init_iova_domain(&vde->iova, 1UL << order, 0);
 
-	err = iommu_attach_group(vde->domain, vde->group);
+	err = iommu_attach_device(vde->domain, dev);
 	if (err)
 		goto put_iova;
 
@@ -129,7 +129,7 @@ int tegra_vde_iommu_init(struct tegra_vde *vde)
 unreserve_iova:
 	__free_iova(&vde->iova, vde->iova_resv_static_addresses);
 detach_group:
-	iommu_detach_group(vde->domain, vde->group);
+	iommu_detach_device(vde->domain, dev);
 put_iova:
 	put_iova_domain(&vde->iova);
 	iova_cache_put();
@@ -146,7 +146,7 @@ void tegra_vde_iommu_deinit(struct tegra_vde *vde)
 	if (vde->domain) {
 		__free_iova(&vde->iova, vde->iova_resv_last_page);
 		__free_iova(&vde->iova, vde->iova_resv_static_addresses);
-		iommu_detach_group(vde->domain, vde->group);
+		iommu_detach_device(vde->domain, vde->miscdev.parent);
 		put_iova_domain(&vde->iova);
 		iova_cache_put();
 		iommu_domain_free(vde->domain);
-- 
2.25.1

