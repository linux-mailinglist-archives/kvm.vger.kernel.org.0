Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE12D4846A7
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiADRHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:07:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40260 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiADRGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:06:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 314BAB811B1;
        Tue,  4 Jan 2022 17:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDC2C36AED;
        Tue,  4 Jan 2022 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641315993;
        bh=s92lHlV9B1y8sS9ImfgWApRrW8AUqJJMtnEF5Ev1DqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=j7P0q9nXAg/o99t9HPCrgze9DFgTvDvgqJsT5ucepqaFZzZff9B4kgE0E/Iqt202m
         L9p+eS2zTii/RLR6lzZ7htDhw14iYE4hswug3mZH7T9hlrkYXa/slzlRyQwI8hyElJ
         kW9V+c6DJGh+Vge2J0+PHqhruF9lMTh5G1Oduf9DGVAyX1Ukf12kHr7qVIVgUKRvni
         yavpxTvIr66Xgvtl4/wr2SK7CdAE86V54P4RmLuc9dtiUbCff0pAFG2Ay793w7USA6
         H7bbx5IrpRSSb39U839eTI4eqy6XRo3BPK1wHuLN9qAA2xjCT3c388KS+nMcJw+qNd
         Kw0Vb9qYzStzg==
Date:   Tue, 4 Jan 2022 11:06:31 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/14] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20220104170631.GA99771@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104015644.2294354-10-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 09:56:39AM +0800, Lu Baolu wrote:
> If a switch lacks ACS P2P Request Redirect, a device below the switch can
> bypass the IOMMU and DMA directly to other devices below the switch, so
> all the downstream devices must be in the same IOMMU group as the switch
> itself.

Help me think through what's going on here.  IIUC, we put devices in
the same IOMMU group when they can interfere with each other in any
way (DMA, config access, etc).

(We said "DMA" above, but I guess this would also apply to config
requests, right?)

*This* patch doesn't check for any ACS features.  Can you connect the
dots for me?  I guess the presence or absence of P2P Request Redirect
determines the size of the IOMMU group.  And the following says
something about what is allowed in the group?  And .no_kernel_api_dma
allows an exception to the general rule?

> The existing vfio framework allows the portdrv driver to be bound
> to the bridge while its downstream devices are assigned to user space.

I.e., the existing VFIO framework allows a switch to be in the same
IOMMU group as the devices below it, even though the switch has a
kernel driver and the other devices may have userspace drivers?

Is this a function of VFIO design or of the IOMMU driver?

> The pci_dma_configure() marks the iommu_group as containing only devices
> with kernel drivers that manage DMA. Avoid this default behavior for the
> portdrv driver in order for compatibility with the current vfio policy.

I assume "IOMMU group" means the same as "iommu_group"; maybe we can
use one of them consistently?

> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/pci/pcie/portdrv_pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 35eca6277a96..2116f821c005 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -202,6 +202,8 @@ static struct pci_driver pcie_portdriver = {
>  
>  	.err_handler	= &pcie_portdrv_err_handler,
>  
> +	.no_kernel_api_dma = true,
> +
>  	.driver.pm	= PCIE_PORTDRV_PM_OPS,
>  };
>  
> -- 
> 2.25.1
> 
