Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAE4515B4
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347394AbhKOUtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352644AbhKOUr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 15:47:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675F763240;
        Mon, 15 Nov 2021 20:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637009100;
        bh=MQTFTpLy1DUXgbPj+fyTCEmPUUNZRsXNkWnZU16fcpY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=rZx5UIHF5logW4gHVcEgXUyevjPivURMroo650Fdw/AUpY0n/l1Bb6ap+gevHX6+6
         mIeO9tE3QD8U15KkS4T2WWO3OPw4gxlMXQVAYBmI8C/P1EbaIDCpB/lMoA4SjcJess
         0lWBWcPb7L01ARzsX2ppPjRYDP56tva1CTFp22W/xurRlmmEhHGivUasoQL0R4Ga0Z
         QiHfxHMf48coxqbWa1v41OMddgit7Bg/dqPToSW5VROvX8yPhuLLgcaPn9OeCjSWIm
         vuFDCcdPPrdy4iofvybgGIDko9rhUscWHj7Ku3ondcbE2sixuL4oB1odVITHqnnGt9
         uIfVjtbAjNbVQ==
Date:   Mon, 15 Nov 2021 14:44:59 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        rafael@kernel.org, Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20211115204459.GA1585166@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-5-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:45AM +0800, Lu Baolu wrote:
> IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
> then all of the downstream devices will be part of the same IOMMU group
> as the bridge.

I think this means something like: "If a PCIe Switch Downstream Port
lacks <a specific set of ACS capabilities>, all downstream devices
will be part of the same IOMMU group as the switch," right?

If so, can you fill in the details to make it specific and concrete?

> As long as the bridge kernel driver doesn't map and
> access any PCI mmio bar, it's safe to bind it to the device in a USER-
> owned group. Hence, safe to suppress the kernel DMA ownership auto-
> claiming.

s/mmio/MMIO/ (also below)
s/bar/BAR/ (also below)

I don't understand what "kernel DMA ownership auto-claiming" means.
Presumably that's explained in previous patches and a code comment
near "suppress_auto_claim_dma_owner".

> The commit 5f096b14d421b ("vfio: Whitelist PCI bridges") permitted a
> class of kernel drivers. 

Permitted them to do what?

> This is not always safe. For example, the SHPC
> system design requires that it must be integrated into a PCI-to-PCI
> bridge or a host bridge.

If this SHPC example is important, it would be nice to have a citation
to the spec section that requires this.

> The shpchp_core driver relies on the PCI mmio
> bar access for the controller functionality. Binding it to the device
> belonging to a USER-owned group will allow the user to change the
> controller via p2p transactions which is unknown to the hot-plug driver
> and could lead to some unpredictable consequences.
> 
> Now that we have driver self-declaration of safety we should rely on that.

Can you spell out what drivers are self-declaring?  Are they declaring
that they don't program their devices to do DMA?

> This change may cause regression on some platforms, since all bridges were
> exempted before, but now they have to be manually audited before doing so.
> This is actually the desired outcome anyway.

Please spell out what regression this may cause and how users would
recognize it.  Also, please give a hint about why that is desirable.

> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/pci/pcie/portdrv_pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 35eca6277a96..1285862a9aa8 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -203,6 +203,8 @@ static struct pci_driver pcie_portdriver = {
>  	.err_handler	= &pcie_portdrv_err_handler,
>  
>  	.driver.pm	= PCIE_PORTDRV_PM_OPS,
> +
> +	.driver.suppress_auto_claim_dma_owner = true,
>  };
>  
>  static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
> -- 
> 2.25.1
> 
