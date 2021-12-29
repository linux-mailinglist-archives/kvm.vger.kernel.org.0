Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7AE4816B5
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 21:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhL2UmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 15:42:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42830 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhL2UmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 15:42:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F28B1B81A0C;
        Wed, 29 Dec 2021 20:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4842CC36AEA;
        Wed, 29 Dec 2021 20:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640810523;
        bh=Rw2gOb2/8KzlEQNxczhYbxeUYfMz9rcfWKTvcBef+uU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Z8libg51KX2kY+CIF2+bXUsg0EIcNN5yMgxTuiaYdAhsx5bwEoib7kJks3+pCa4tH
         EpOL6ai2kwnLyrXdG6uD93x+1IaXqDX8sHPxD8RVGF6K9c8qySePI19RLG2NCr9aTU
         dap8mwqCB1JHL1MXEG4LcXJooB3Jwt0RGlWNIXftfvgABMADN/tSR0Z53Lh1Emo1dj
         /XgphNYqxVU4RAE8i7+DSqpogbiH3+2+K5WMl3bqkwbtTvPk4wtlayEyvi/0/yuMJj
         y2FDN1dzMmy++2YtlZDujx+6DwDo8DalV/gJKTydVtRP7aUcTpCIpdJdKMT8XG/i3v
         o+SRMFCe8Uk2Q==
Date:   Wed, 29 Dec 2021 14:42:02 -0600
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
Subject: Re: [PATCH v4 03/13] PCI: pci_stub: Suppress kernel DMA ownership
 auto-claiming
Message-ID: <20211229204202.GA1700874@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217063708.1740334-4-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17, 2021 at 02:36:58PM +0800, Lu Baolu wrote:
> The pci_dma_configure() marks the iommu_group as containing only devices
> with kernel drivers that manage DMA.

I'm looking at pci_dma_configure(), and I don't see the connection to
iommu_groups.

> Avoid this default behavior for the
> pci_stub because it does not program any DMA itself.  This allows the
> pci_stub still able to be used by the admin to block driver binding after
> applying the DMA ownership to vfio.

> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/pci/pci-stub.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
> index e408099fea52..6324c68602b4 100644
> --- a/drivers/pci/pci-stub.c
> +++ b/drivers/pci/pci-stub.c
> @@ -36,6 +36,9 @@ static struct pci_driver stub_driver = {
>  	.name		= "pci-stub",
>  	.id_table	= NULL,	/* only dynamic id's */
>  	.probe		= pci_stub_probe,
> +	.driver		= {
> +		.suppress_auto_claim_dma_owner = true,

The new .suppress_auto_claim_dma_owner controls whether we call
iommu_device_set_dma_owner().  I guess you added
.suppress_auto_claim_dma_owner because iommu_device_set_dma_owner()
must be done *before* we call the driver's .probe() method?

Otherwise, we could call some new interface from .probe() instead of
adding the flag to struct device_driver.

> +	},
>  };
>  
>  static int __init pci_stub_init(void)
> -- 
> 2.25.1
> 
