Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D030946053D
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 09:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244852AbhK1IPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 03:15:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42918 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244052AbhK1INh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 03:13:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2252B80B58;
        Sun, 28 Nov 2021 08:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FC9C004E1;
        Sun, 28 Nov 2021 08:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638087019;
        bh=Jh73NsijwFN5QPrga4uDXyFTpW6yedRJeVQ94xz/BvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r8dqk03D2jeiNpbJLBgCBKZqW0HDJ5Tm6QLq+9y6d6qfyxcrdfgUx428Ks8OXlp00
         DFMNAg0jGMqvpHaytnxROgOKNdVnYWbWHi7Cvni3o9RcgZZbTFm+1iRq/chyaLAgqQ
         Fug0KlfEBeP61C9AXRDp1L1G0lUVzzX8IelrbImA=
Date:   Sun, 28 Nov 2021 09:10:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
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
        Li Yang <leoyang.li@nxp.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/17] driver core: platform: Add driver dma ownership
 management
Message-ID: <YaM5Zv1RrdidycKe@kroah.com>
References: <20211128025051.355578-1-baolu.lu@linux.intel.com>
 <20211128025051.355578-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128025051.355578-5-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 28, 2021 at 10:50:38AM +0800, Lu Baolu wrote:
> Multiple platform devices may be placed in the same IOMMU group because
> they cannot be isolated from each other. These devices must either be
> entirely under kernel control or userspace control, never a mixture. This
> checks and sets DMA ownership during driver binding, and release the
> ownership during driver unbinding.
> 
> Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
> claiming DMA_OWNER_DMA_API ownership in the binding process. For instance,
> the userspace framework drivers (vfio etc.) which need to manually claim
> DMA_OWNER_PRIVATE_DOMAIN_USER when assigning a device to userspace.

Why would any vfio driver be a platform driver?  That should never be
the case as they obviously are not platform drivers, they are virtual
ones.

> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/platform_device.h |  1 +
>  drivers/base/platform.c         | 30 +++++++++++++++++++++++++++++-
>  2 files changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 7c96f169d274..779bcf2a851c 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -210,6 +210,7 @@ struct platform_driver {
>  	struct device_driver driver;
>  	const struct platform_device_id *id_table;
>  	bool prevent_deferred_probe;
> +	bool suppress_auto_claim_dma_owner;

What platform driver needs this change?

>  };
>  
>  #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 598acf93a360..df4b385c8a52 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -30,6 +30,7 @@
>  #include <linux/property.h>
>  #include <linux/kmemleak.h>
>  #include <linux/types.h>
> +#include <linux/iommu.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -1465,6 +1466,32 @@ int platform_dma_configure(struct device *dev)
>  	return ret;
>  }
>  
> +static int _platform_dma_configure(struct device *dev)
> +{
> +	struct platform_driver *drv = to_platform_driver(dev->driver);
> +	int ret;
> +
> +	if (!drv->suppress_auto_claim_dma_owner) {
> +		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = platform_dma_configure(dev);
> +	if (ret && !drv->suppress_auto_claim_dma_owner)
> +		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
> +
> +	return ret;
> +}
> +
> +static void _platform_dma_unconfigure(struct device *dev)
> +{
> +	struct platform_driver *drv = to_platform_driver(dev->driver);
> +
> +	if (!drv->suppress_auto_claim_dma_owner)
> +		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
> +}
> +
>  static const struct dev_pm_ops platform_dev_pm_ops = {
>  	SET_RUNTIME_PM_OPS(pm_generic_runtime_suspend, pm_generic_runtime_resume, NULL)
>  	USE_PLATFORM_PM_SLEEP_OPS
> @@ -1478,7 +1505,8 @@ struct bus_type platform_bus_type = {
>  	.probe		= platform_probe,
>  	.remove		= platform_remove,
>  	.shutdown	= platform_shutdown,
> -	.dma_configure	= platform_dma_configure,
> +	.dma_configure	= _platform_dma_configure,

What happened to the original platform_dma_configure() function?

And single "_" prefixes are odd, please just spell out what the
difference is in the function name, "_" gives us no hint at all.

thnaks,

greg k-h
