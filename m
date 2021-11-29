Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9DF46128A
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 11:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244604AbhK2KkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 05:40:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44306 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbhK2KiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 05:38:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848AF61257;
        Mon, 29 Nov 2021 10:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF91C004E1;
        Mon, 29 Nov 2021 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638182082;
        bh=nsUtuRmqSAZRV1KPWJ/+I0Ioj0cagz0JXdcAo35Ew4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bKx6n4W8Hl5/MY40EORD0pKOk49Qj+zzSZ1XiYB2e6CWBPHA3Yj20wSC2c4oujZZS
         9OGj+NNIpXp73UDrmyxQD7emWWQu6MYggvcI8LLBhJQCC9CsacRPxu+qCkMBka+eT1
         mUB7O6bQsu12OCzw4VBrjGpU8NgxDz2wE9tOdIQ4=
Date:   Mon, 29 Nov 2021 11:34:39 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/17] driver core: platform: Add driver dma ownership
 management
Message-ID: <YaSsv5Z1WS7ldgu3@kroah.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
 <20211128025051.355578-5-baolu.lu@linux.intel.com>
 <YaM5Zv1RrdidycKe@kroah.com>
 <20211128231509.GA966332@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128231509.GA966332@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 28, 2021 at 07:15:09PM -0400, Jason Gunthorpe wrote:
> On Sun, Nov 28, 2021 at 09:10:14AM +0100, Greg Kroah-Hartman wrote:
> > On Sun, Nov 28, 2021 at 10:50:38AM +0800, Lu Baolu wrote:
> > > Multiple platform devices may be placed in the same IOMMU group because
> > > they cannot be isolated from each other. These devices must either be
> > > entirely under kernel control or userspace control, never a mixture. This
> > > checks and sets DMA ownership during driver binding, and release the
> > > ownership during driver unbinding.
> > > 
> > > Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
> > > claiming DMA_OWNER_DMA_API ownership in the binding process. For instance,
> > > the userspace framework drivers (vfio etc.) which need to manually claim
> > > DMA_OWNER_PRIVATE_DOMAIN_USER when assigning a device to userspace.
> > 
> > Why would any vfio driver be a platform driver?  
> 
> Why not? VFIO implements drivers for most physical device types
> these days. Why wouldn't platform be included?

Because "platform" is not a real device type.  It's a catch-all for
devices that are only described by firmware, so why would you have a
virtual device for that?  Why would that be needed?

> > > diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> > > index 7c96f169d274..779bcf2a851c 100644
> > > +++ b/include/linux/platform_device.h
> > > @@ -210,6 +210,7 @@ struct platform_driver {
> > >  	struct device_driver driver;
> > >  	const struct platform_device_id *id_table;
> > >  	bool prevent_deferred_probe;
> > > +	bool suppress_auto_claim_dma_owner;
> > 
> > What platform driver needs this change?
> 
> It is in patch 12:
> 
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c

Ok, nevermind, you do have a virtual platform device, which personally,
I find crazy as why would firmware export a "virtual device"?

> @@ -76,6 +76,7 @@ static struct platform_driver vfio_platform_driver = {
>         .driver = {
>                 .name   = "vfio-platform",
>         },
> +       .suppress_auto_claim_dma_owner = true,
>  };
> 
> Which is how VFIO provides support to DPDK for some Ethernet
> controllers embedded in a few ARM SOCs.

Ick.  Where does the DT file for these devices live that describe a
"virtual device" to match with this driver?

> It is also used in patch 17 in five tegra platform_drivers to make
> their sharing of an iommu group between possibly related
> platform_driver's safer.

Safer how?

> > >  	USE_PLATFORM_PM_SLEEP_OPS
> > > @@ -1478,7 +1505,8 @@ struct bus_type platform_bus_type = {
> > >  	.probe		= platform_probe,
> > >  	.remove		= platform_remove,
> > >  	.shutdown	= platform_shutdown,
> > > -	.dma_configure	= platform_dma_configure,
> > > +	.dma_configure	= _platform_dma_configure,
> > 
> > What happened to the original platform_dma_configure() function?
> 
> It is still called. The issue here is that platform_dma_configure has
> nothing to do with platform and is being re-used by AMBA.

Ick, why?  AMBA needs to be a real bus type and use their own functions
if needed.  There is nothing here that makes this obvious that someone
else is using those functions and that the platform bus should only be
using these "new" functions.

> Probably the resolution to both remarks is to rename
> platform_dma_configure to something sensible (firwmare dma configure
> maybe?) and use it in all places that do the of & acpi stuff -
> pci/amba/platform at least.

That would be better than what is being proposed here.

thanks,

greg k-h
