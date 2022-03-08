Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0AD4D0F5F
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 06:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343759AbiCHFrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 00:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343870AbiCHFrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 00:47:42 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF633BF9C;
        Mon,  7 Mar 2022 21:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646718402; x=1678254402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6K2eWlxOyc65iXu8zh1miLOHRYvCLILUgOV92SuDu+w=;
  b=K+hhRZjfhKXaKotsZO1UTRlm6+tmNsKvx27qmzp26TeushcVwCU8H5fl
   bvD1GVd+Wi1d7zzIYlb0nK+m6QRUh5JqZ3MRXgGJtP2Bfx8t2ljmVTQnF
   WZAmKEpS0D9LE5PkPvCbU47J4NolZidYu12SnkdTR8kdFTI+fSuLVub6A
   u0yO01SfWSFebIPNc/l73Z2Barjpmr5cZI8pqq/fKi7ITb2gYK+qdl/I7
   Vxcky8cZKx9qMTD+ttwaoOizw8tLnUg3rvwISGM9jn8H6Om2eyU7rFnFy
   uJO5AIx+em05Z2PWLqrF5ZHRHlV4c9hA4uKwDJy6gCZRp8HI9z20Mg0zQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="341031131"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="341031131"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 21:46:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="537430208"
Received: from allen-box.sh.intel.com ([10.239.159.48])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 21:46:35 -0800
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
Subject: [PATCH v8 05/11] PCI: pci_stub: Set driver_managed_dma
Date:   Tue,  8 Mar 2022 13:44:15 +0800
Message-Id: <20220308054421.847385-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308054421.847385-1-baolu.lu@linux.intel.com>
References: <20220308054421.847385-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
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

