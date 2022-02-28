Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAE84C605C
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 01:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiB1AyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 19:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiB1AyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 19:54:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C5F4550A;
        Sun, 27 Feb 2022 16:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646009610; x=1677545610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4jk0c0xjR9fwFUZr9dOqxwTyTpKhy2X63dKiNs7wWd8=;
  b=eOmyHI64aPHeAo6z6nFLhpYMozRENY+ZDkiQZn4Aps2KIFjkuNa6NtBM
   OFrjl2oG/pTXecnzkh2xPkx2AfwIaqDqjAIYEQ+s1x58NbqzJCG/w8sHx
   v0Y8Cz7zW+/8No1wJqkRH5VcTDj8vYK/C+bxap+QY6Wwoh3ybmBB6xD1C
   hJxrG2ULFlr+CmEZ/q3okN5hE6clIo1548O2yb6gI+JER+bXanHNbx/Av
   m8a0pAoRQ8neatKJSvtB6rnvZfls5FPR52GvrWZ0lBRUpELI8GeXnB+iU
   yMo7tK1JdLUAOjmw7xy+SDj8kk1D4WSJBw4kyUjUPmQosgdNBBZo7gdPO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="277426194"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="277426194"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 16:53:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="550020255"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 27 Feb 2022 16:53:17 -0800
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
Subject: [PATCH v7 06/11] PCI: portdrv: Set driver_managed_dma
Date:   Mon, 28 Feb 2022 08:50:51 +0800
Message-Id: <20220228005056.599595-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228005056.599595-1-baolu.lu@linux.intel.com>
References: <20220228005056.599595-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a switch lacks ACS P2P Request Redirect, a device below the switch can
bypass the IOMMU and DMA directly to other devices below the switch, so
all the downstream devices must be in the same IOMMU group as the switch
itself.

The existing VFIO framework allows the portdrv driver to be bound to the
bridge while its downstream devices are assigned to user space. The
pci_dma_configure() marks the IOMMU group as containing only devices
with kernel drivers that manage DMA. Avoid this default behavior for the
portdrv driver in order for compatibility with the current VFIO usage.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/pcie/portdrv_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 35eca6277a96..6b2adb678c21 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -202,6 +202,8 @@ static struct pci_driver pcie_portdriver = {
 
 	.err_handler	= &pcie_portdrv_err_handler,
 
+	.driver_managed_dma = true,
+
 	.driver.pm	= PCIE_PORTDRV_PM_OPS,
 };
 
-- 
2.25.1

