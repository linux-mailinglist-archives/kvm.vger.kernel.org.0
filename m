Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BF84C6058
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 01:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiB1AyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 19:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbiB1AyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 19:54:00 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD35743AFF;
        Sun, 27 Feb 2022 16:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646009597; x=1677545597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Sinm9F79Trbz2xG2vi/p9cQ3AApJUaGznjrG5yUk/Y=;
  b=LwJIOXHJTZm4EefvNIyCuj+N4oNjXxVVAv9f5B6e1SzOAk1jmUA8WMx7
   OQjuNo53Kf0RKT+faLrT08QLPXNlH8MjEdgOe/LPxWEj/jicAYcpOtVF5
   S00hHd85Zl0VzzwdBlIMD35Lyk24OW7djusr7dgPuhkcbfBHOJ1FIUWHD
   VNpMVkqlZr1BFVptpf88lB02qIbOpZqLWmywYilqG0O6MIBuxYnD4Lxi7
   FCQ+99ZUwpJSOdEGJXX9vydx2RbIdK/jW0fOyKrADeGUxdfu/VwwCPCeO
   Z/MT5VrMPJrxNvFgeVuTmPj7B1Wz3CtO0eeoy7OldEGxpDqGJbFMKss8F
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="313493017"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="313493017"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 16:53:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="550020232"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 27 Feb 2022 16:53:09 -0800
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
Subject: [PATCH v7 05/11] PCI: pci_stub: Set driver_managed_dma
Date:   Mon, 28 Feb 2022 08:50:50 +0800
Message-Id: <20220228005056.599595-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228005056.599595-1-baolu.lu@linux.intel.com>
References: <20220228005056.599595-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current VFIO implementation allows pci-stub driver to be bound to
a PCI device with other devices in the same IOMMU group being assigned
to userspace. The pci-stub driver has no dependencies on DMA or the
IOVA mapping of the device, but it does prevent the user from having
direct access to the device, which is useful in some circumstances.

The pci_dma_configure() marks the iommu_group as containing only devices
with kernel drivers that manage DMA. For compatibility with the VFIO
usage, avoid this default behavior for the pci_stub. This allows the
pci_stub still able to be used by the admin to block driver binding after
applying the DMA ownership to VFIO.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/pci-stub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index e408099fea52..d1f4c1ce7bd1 100644
--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -36,6 +36,7 @@ static struct pci_driver stub_driver = {
 	.name		= "pci-stub",
 	.id_table	= NULL,	/* only dynamic id's */
 	.probe		= pci_stub_probe,
+	.driver_managed_dma = true,
 };
 
 static int __init pci_stub_init(void)
-- 
2.25.1

