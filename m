Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877DF485EA1
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344770AbiAFCWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:22:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:40662 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344734AbiAFCW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 21:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641435746; x=1672971746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rk6a+5igN4LBX3L4wUsmQbl/BtWrVs0e5Y+7ihAeHL8=;
  b=hVTBORazkuSD8onwYqW6Nk/Pkdvi2sKvgBb9QSPtil4MfBavvbbUQ/vl
   x5PxpNpOGNc5MwQVVztcio5hLdZL6cmKysAnAE50LseYT8ZMT0leXfVe8
   4bqqbL3A9gy9n8nHW8RjXdGJ8HegV0bmEQbXKBl6jTTGJ2JHKwZeeDPAd
   kQj6uCJjqzWH9FozI29oOYHYtdejAuheT1eclwVIsS9Mv9/UzX+JIEouo
   7IHzXJk42S3tBbXBtcYtqD1ELoin5ixoN5DPI/CRphGvLTyPWGXTmrvUz
   OoB0/5OdWoDN6p5GKOGbQL+BhrszAWCUlxpT3xG//12+RxX4WSkqG3Lp2
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303325635"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="303325635"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 18:22:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526794416"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 18:22:17 -0800
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
Subject: [PATCH v1 5/8] iommu/amd: Use iommu_attach/detach_device()
Date:   Thu,  6 Jan 2022 10:20:50 +0800
Message-Id: <20220106022053.2406748-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The individual device driver should use iommu_attach/detach_device()
for domain attachment/detachment.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/amd/iommu_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/iommu_v2.c b/drivers/iommu/amd/iommu_v2.c
index 58da08cc3d01..7d9d0fe89064 100644
--- a/drivers/iommu/amd/iommu_v2.c
+++ b/drivers/iommu/amd/iommu_v2.c
@@ -133,7 +133,7 @@ static void free_device_state(struct device_state *dev_state)
 	if (WARN_ON(!group))
 		return;
 
-	iommu_detach_group(dev_state->domain, group);
+	iommu_detach_device(dev_state->domain, &dev_state->pdev->dev);
 
 	iommu_group_put(group);
 
@@ -791,7 +791,7 @@ int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
 		goto out_free_domain;
 	}
 
-	ret = iommu_attach_group(dev_state->domain, group);
+	ret = iommu_attach_device(dev_state->domain, &pdev->dev);
 	if (ret != 0)
 		goto out_drop_group;
 
-- 
2.25.1

