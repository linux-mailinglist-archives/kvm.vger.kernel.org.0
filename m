Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A2D481705
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 22:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhL2VQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 16:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhL2VQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 16:16:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6DBC061574;
        Wed, 29 Dec 2021 13:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E73FCB81A10;
        Wed, 29 Dec 2021 21:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEF2C36AE9;
        Wed, 29 Dec 2021 21:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640812587;
        bh=cjyr8peC0EwKteN+JSIctBlIqiolVktDfzhMSIQZ+DE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Vgjmo1GhUSsmFHn1ckCJL8DqIveMa8+rBwPsRn5zv8bVRjfHGKxuXoTqGU7lkBDcH
         VxbG80fnd8XvvOHDQrOfcxku0d0kA7WCKHxhu1xWCJV3N9TBgcT3niy8ikUAbvm99R
         eU1BQX2u8bfnOCGnANyuGPryT4/Ewh7P1kCLMoOo6OFhb0wMNPbN9iDsVGi8QZfMUG
         hraBTiBhEB0ReFcNZfltH+Eja2O+oRLVWJbrBgx43iW7ZKkft1V1bNo/JfvCAY8gwb
         0vX25amhqPnnn/8AI2Ngh6pUNxjlpbo75eFj5F1tK9Tnbv86AFwdGy+NarfhfhNkw9
         wJOJpc9lzNytA==
Date:   Wed, 29 Dec 2021 15:16:26 -0600
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
Subject: Re: [PATCH v4 04/13] PCI: portdrv: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20211229211626.GA1701512@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217063708.1740334-5-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17, 2021 at 02:36:59PM +0800, Lu Baolu wrote:
> IOMMU grouping on PCI necessitates that if we lack isolation on a bridge
> then all of the downstream devices will be part of the same IOMMU group
> as the bridge. The existing vfio framework allows the portdrv driver to
> be bound to the bridge while its downstream devices are assigned to user
> space. The pci_dma_configure() marks the iommu_group as containing only
> devices with kernel drivers that manage DMA. Avoid this default behavior
> for the portdrv driver in order for compatibility with the current vfio
> policy.

A word about the isolation would be useful.  I think you're referring
to some specific ACS controls, probably P2P Request Redirect?

I guess this is just a wording issue, but I think it's actually the
*lack* of some ACS controls that forces us to put several devices in
the same IOMMU group, isn't it?  It's not that we start with "IOMMU
grouping" and that necessitates something else.

Maybe something like this?

  If a switch lacks ACS P2P Request Redirect (and possibly other
  controls?), a device below the switch can bypass the IOMMU and DMA
  directly to other devices below the switch, so all the downstream
  devices must be in the same IOMMU group as the switch itself.

> The commit 5f096b14d421b ("vfio: Whitelist PCI bridges") extended above
> policy to all kernel drivers of bridge class. This is not always safe.
> For example, The shpchp_core driver relies on the PCI MMIO access for the
> controller functionality. With its downstream devices assigned to the
> userspace, the MMIO might be changed through user initiated P2P accesses
> without any notification. This might break the kernel driver integrity
> and lead to some unpredictable consequences.
> 
> For any bridge driver, in order to avoiding default kernel DMA ownership
> claiming, we should consider:
> 
>  1) Does the bridge driver use DMA? Calling pci_set_master() or
>     a dma_map_* API is a sure indicate the driver is doing DMA
> 
>  2) If the bridge driver uses MMIO, is it tolerant to hostile
>     userspace also touching the same MMIO registers via P2P DMA
>     attacks?
> 
> Conservatively if the driver maps an MMIO region at all, we can say that
> it fails the test.

I'm not sure what all this explanation is telling me.  It says
something done by 5f096b14d421 is not always safe, but this patch
doesn't fix any of those unsafe things.

If it doesn't explain why we need this patch or how this patch works,
I don't think we need it in the commit log.

Maybe this is an explanation for why you didn't set
.suppress_auto_claim_dma_owner for shpc_driver?

Minor typos above:
  s/in order to avoiding default/before avoiding default/
  s/relies on the PCI MMIO access/relies on PCI MMIO access/
  s/For example, The/For example, the/
  s/is a sure indicate the/is a sure indication the/

> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/pci/pcie/portdrv_pci.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 35eca6277a96..c48a8734f9c4 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -202,7 +202,10 @@ static struct pci_driver pcie_portdriver = {
>  
>  	.err_handler	= &pcie_portdrv_err_handler,
>  
> -	.driver.pm	= PCIE_PORTDRV_PM_OPS,
> +	.driver		= {
> +		.pm = PCIE_PORTDRV_PM_OPS,
> +		.suppress_auto_claim_dma_owner = true,
> +	},
>  };
>  
>  static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
> -- 
> 2.25.1
> 
