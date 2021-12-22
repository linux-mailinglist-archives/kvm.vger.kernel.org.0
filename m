Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D905D47D26E
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 13:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbhLVMri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 07:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbhLVMrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 07:47:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857ABC061574;
        Wed, 22 Dec 2021 04:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23C5661A36;
        Wed, 22 Dec 2021 12:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86F6C36AEB;
        Wed, 22 Dec 2021 12:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640177256;
        bh=qZ5Me6WI7mkDi0azDBPQq5dSpsFYy5Bph6HB3I2DDz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AcvTYGw/SzfCslxuTb0DnXeiXRptpHokYrNiFvO00bOd87s7zOWmIrZu53i1WWVN5
         NI8Yo8M3YRytp4C3Bo0sZcBWeaY2GOfSVn8HKiaHKAXVB+OLomcypI4oxR3cvgXRS7
         JQ7zwu8Uhw7hM6wCp4CIT9Bj8LSOQuda7PHW5Prc=
Date:   Wed, 22 Dec 2021 13:47:34 +0100
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
Subject: Re: [PATCH v4 02/13] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <YcMeZlN3798noycN@kroah.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217063708.1740334-3-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 17, 2021 at 02:36:57PM +0800, Lu Baolu wrote:
> This extends really_probe() to allow checking for dma ownership conflict
> during the driver binding process. By default, the DMA_OWNER_DMA_API is
> claimed for the bound driver before calling its .probe() callback. If this
> operation fails (e.g. the iommu group of the target device already has the
> DMA_OWNER_USER set), the binding process is aborted to avoid breaking the
> security contract for devices in the iommu group.
> 
> Without this change, the vfio driver has to listen to a bus BOUND_DRIVER
> event and then BUG_ON() in case of dma ownership conflict. This leads to
> bad user experience since careless driver binding operation may crash the
> system if the admin overlooks the group restriction. Aside from bad design,
> this leads to a security problem as a root user can force the kernel to
> BUG() even with lockdown=integrity.
> 
> Driver may set a new flag (suppress_auto_claim_dma_owner) to disable auto
> claim in the binding process. Examples include kernel drivers (pci_stub,
> PCI bridge drivers, etc.) which don't trigger DMA at all thus can be safely
> exempted in DMA ownership check and userspace framework drivers (vfio/vdpa
> etc.) which need to manually claim DMA_OWNER_USER when assigning a device
> to userspace.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/linux-iommu/20210922123931.GI327412@nvidia.com/
> Link: https://lore.kernel.org/linux-iommu/20210928115751.GK964074@nvidia.com/
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/device/driver.h |  2 ++
>  drivers/base/dd.c             | 37 ++++++++++++++++++++++++++++++-----
>  2 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
> index a498ebcf4993..f5bf7030c416 100644
> --- a/include/linux/device/driver.h
> +++ b/include/linux/device/driver.h
> @@ -54,6 +54,7 @@ enum probe_type {
>   * @owner:	The module owner.
>   * @mod_name:	Used for built-in modules.
>   * @suppress_bind_attrs: Disables bind/unbind via sysfs.
> + * @suppress_auto_claim_dma_owner: Disable kernel dma auto-claim.
>   * @probe_type:	Type of the probe (synchronous or asynchronous) to use.
>   * @of_match_table: The open firmware table.
>   * @acpi_match_table: The ACPI match table.
> @@ -100,6 +101,7 @@ struct device_driver {
>  	const char		*mod_name;	/* used for built-in modules */
>  
>  	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
> +	bool suppress_auto_claim_dma_owner;
>  	enum probe_type probe_type;
>  
>  	const struct of_device_id	*of_match_table;
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 68ea1f949daa..b04eec5dcefa 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -28,6 +28,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/pinctrl/devinfo.h>
>  #include <linux/slab.h>
> +#include <linux/iommu.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -538,6 +539,32 @@ static int call_driver_probe(struct device *dev, struct device_driver *drv)
>  	return ret;
>  }
>  
> +static int device_dma_configure(struct device *dev, struct device_driver *drv)
> +{
> +	int ret;
> +
> +	if (!dev->bus->dma_configure)
> +		return 0;
> +
> +	ret = dev->bus->dma_configure(dev);
> +	if (ret)
> +		return ret;
> +
> +	if (!drv->suppress_auto_claim_dma_owner)
> +		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_DMA_API, NULL);

Wait, the busses that wanted to configure the device, just did so in
their dma_configure callback, so why not do this type of
iommu_device_set_dma_owner() in the few busses that will want this to
happen?

Right now we only have 4 different "busses" that care about this.  Out
of the following callbacks:
	fsl_mc_dma_configure
	host1x_dma_configure
	pci_dma_configure
	platform_dma_configure

Which one will actually care about the iommu_device_set_dma_owner()
call?  All of them?  None of them?  Some of them?

Again, why can't this just happen in the (very few) bus callbacks that
care about this?  In following patches in this series, you turn off this
for the pci_dma_configure users, so what is left?  3 odd bus types that
are not used often.  How well did you test devices of those types with
this patchset?

It's fine to have "suppress" fields when they are the minority, but here
it's a _very_ tiny tiny number of actual devices in a system that will
ever get the chance to have this check happen for them and trigger,
right?

I know others told you to put this in the driver core, but I fail to see
how adding this call to the 3 busses that care about it is a lot more
work than this driver core functionality that we all will have to
maintain for forever?

> +
> +	return ret;
> +}
> +
> +static void device_dma_cleanup(struct device *dev, struct device_driver *drv)
> +{
> +	if (!dev->bus->dma_configure)
> +		return;
> +
> +	if (!drv->suppress_auto_claim_dma_owner)
> +		iommu_device_release_dma_owner(dev, DMA_OWNER_DMA_API);
> +}
> +
>  static int really_probe(struct device *dev, struct device_driver *drv)
>  {
>  	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
> @@ -574,11 +601,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  	if (ret)
>  		goto pinctrl_bind_failed;
>  
> -	if (dev->bus->dma_configure) {
> -		ret = dev->bus->dma_configure(dev);
> -		if (ret)
> -			goto probe_failed;
> -	}
> +	if (device_dma_configure(dev, drv))
> +		goto pinctrl_bind_failed;

Are you sure you are jumping to the proper error path here?  It is not
obvious why you changed this.

thanks,

greg k-h
