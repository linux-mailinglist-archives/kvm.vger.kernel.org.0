Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C27E483A38
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiADB6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:58:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:53589 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbiADB62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261508; x=1672797508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FFbJKeDPVHb8kgH5O4mqjg/xiGeNxb88z5tXC1GikVg=;
  b=VCwQV38gEnWFbKLbfzEGjl2W/s1dgZHcvDEtSCfL2M4a0WjOqePXceE8
   Q44xceitxjS/zH1aDaekfq+UsOOCl90/WfQe3IiBNcGnFI1z7cmVqf9Rv
   vACIBp3ZkaSGoJeKiVOF228V86h+69DuVkRJNulvwsbsN5czW8vWmLkDK
   tKOOeiN4sn2O0K//VAINmR5es4PdVr1wdG0xZhytr7eta76rHA5Q68t8U
   StGjH+tJCoVefUFpc9iQufiYG4RmtAxx2WfK7u+Alvfmb/SaBBjM6NmLn
   vNyiypaG5p1gbqT6viQEc1nYMYL6lzjZW6rn1SAPhG+MLYVdD6Key5dz1
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="302893840"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="302893840"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:58:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="667573301"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2022 17:58:21 -0800
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
Subject: [PATCH v5 09/14] PCI: portdrv: Suppress kernel DMA ownership auto-claiming
Date:   Tue,  4 Jan 2022 09:56:39 +0800
Message-Id: <20220104015644.2294354-10-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a switch lacks ACS P2P Request Redirect, a device below the switch can
bypass the IOMMU and DMA directly to other devices below the switch, so
all the downstream devices must be in the same IOMMU group as the switch
itself. The existing vfio framework allows the portdrv driver to be bound
to the bridge while its downstream devices are assigned to user space.
The pci_dma_configure() marks the iommu_group as containing only devices
with kernel drivers that manage DMA. Avoid this default behavior for the
portdrv driver in order for compatibility with the current vfio policy.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/pci/pcie/portdrv_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 35eca6277a96..2116f821c005 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -202,6 +202,8 @@ static struct pci_driver pcie_portdriver = {
 
 	.err_handler	= &pcie_portdrv_err_handler,
 
+	.no_kernel_api_dma = true,
+
 	.driver.pm	= PCIE_PORTDRV_PM_OPS,
 };
 
-- 
2.25.1

