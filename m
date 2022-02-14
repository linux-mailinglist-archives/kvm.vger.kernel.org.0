Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FAF4B4D11
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349179AbiBNKtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 05:49:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349119AbiBNKtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 05:49:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AADBF94E;
        Mon, 14 Feb 2022 02:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B937961027;
        Mon, 14 Feb 2022 10:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D3CC340E9;
        Mon, 14 Feb 2022 10:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833541;
        bh=4e6jacegMudm5QOO5r4b8aXUbKWQ/KZagciGyXk0tFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dWgOCaq9LwmLUWtMT7HPrs1K+hIb25M6y5lmPLlGADQIWn+ktjprZPDD4AHsRsFdP
         22C5wQvlEiUCP2TIBNNZG0gJ+dQ4/5WAaA8UbkTfOuU3UVef1Kj4DZOkHgKPZU6q51
         6mKzlynGQpisdWw3qFqtDq7e6e382gjSAm2McVts=
Date:   Mon, 14 Feb 2022 10:59:50 +0100
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
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/14] driver core: platform: Add driver dma ownership
 management
Message-ID: <YgooFjSWLTSapuIs@kroah.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-5-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104015644.2294354-5-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 09:56:34AM +0800, Lu Baolu wrote:
> Multiple platform devices may be placed in the same IOMMU group because
> they cannot be isolated from each other. These devices must either be
> entirely under kernel control or userspace control, never a mixture. This
> checks and sets DMA ownership during driver binding, and release the
> ownership during driver unbinding.
> 
> The device driver may set a new flag (no_kernel_api_dma) to skip calling
> iommu_device_use_dma_api() during the binding process. For instance, the
> userspace framework drivers (vfio etc.) which need to manually claim
> their own dma ownership when assigning the device to userspace.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/platform_device.h |  1 +
>  drivers/base/platform.c         | 20 ++++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 17fde717df68..8f0eaafcef47 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -210,6 +210,7 @@ struct platform_driver {
>  	struct device_driver driver;
>  	const struct platform_device_id *id_table;
>  	bool prevent_deferred_probe;
> +	bool no_kernel_api_dma;
>  };
>  
>  #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index b4d36b46ab2e..d5171e44d903 100644
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
> @@ -1451,9 +1452,16 @@ static void platform_shutdown(struct device *_dev)
>  
>  static int platform_dma_configure(struct device *dev)
>  {
> +	struct platform_driver *drv = to_platform_driver(dev->driver);
>  	enum dev_dma_attr attr;
>  	int ret = 0;
>  
> +	if (!drv->no_kernel_api_dma) {
> +		ret = iommu_device_use_dma_api(dev);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	if (dev->of_node) {
>  		ret = of_dma_configure(dev, dev->of_node, true);
>  	} else if (has_acpi_companion(dev)) {
> @@ -1461,9 +1469,20 @@ static int platform_dma_configure(struct device *dev)
>  		ret = acpi_dma_configure(dev, attr);
>  	}
>  
> +	if (ret && !drv->no_kernel_api_dma)
> +		iommu_device_unuse_dma_api(dev);

So you are now going to call this for every platform driver _unless_
they set this flag?

And having "negative" flags is rough to parse at times.  Yes, we have
"prevent_deferred_probe" already here, so maybe keep this in the same
nameing scheme and use "prevent_dma_api"?

And it would be good to document this somewhere as to what this means.

thanks,

greg k-h
