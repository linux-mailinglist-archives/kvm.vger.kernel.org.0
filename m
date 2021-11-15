Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E51844FEE9
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 07:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhKOHCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 02:02:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230166AbhKOHCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 02:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1323763218;
        Mon, 15 Nov 2021 06:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636959553;
        bh=luIbbrf+LzBgsq1Go6fjN5SrA/F8WMRXUbE4fwqbwaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hrHE7vAk9f+9cu3ciMZN1IeE8B/nOoBK5QdMMQW6QfsL6ynlGKHtPbh42Sn/7o2nO
         ckWInmEMUTG3joNbBg71N3N0nuYz6i3HCgHFGqg3gij0L4vA/cvwSARDeM0aBk+3JY
         zvz+GzdhOCTUpJEOEbTHv7x2uSVveGQkoScDVTa4=
Date:   Mon, 15 Nov 2021 07:59:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <YZIFPv7BpsTibxE/@kroah.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-3-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:43AM +0800, Lu Baolu wrote:
> This extends really_probe() to allow checking for dma ownership conflict
> during the driver binding process. By default, the DMA_OWNER_KERNEL is
> claimed for the bound driver before calling its .probe() callback. If this
> operation fails (e.g. the iommu group of the target device already has the
> DMA_OWNER_USER set), the binding process is aborted to avoid breaking the
> security contract for devices in the iommu group.
> 
> Without this change, the vfio driver has to listen to a bus BOUND_DRIVER
> event and then BUG_ON() in case of dma ownership conflict. This leads to
> bad user experience since careless driver binding operation may crash the
> system if the admin overlooks the group restriction.
> 
> Aside from bad design, this leads to a security problem as a root user,
> even with lockdown=integrity, can force the kernel to BUG.
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
>  include/linux/device/driver.h |  7 ++++++-
>  drivers/base/dd.c             | 12 ++++++++++++
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
> index a498ebcf4993..25d39c64c4d9 100644
> --- a/include/linux/device/driver.h
> +++ b/include/linux/device/driver.h
> @@ -54,6 +54,10 @@ enum probe_type {
>   * @owner:	The module owner.
>   * @mod_name:	Used for built-in modules.
>   * @suppress_bind_attrs: Disables bind/unbind via sysfs.
> + * @suppress_auto_claim_dma_owner: Disable auto claiming of kernel DMA owner.
> + *		Drivers which don't require DMA or want to manually claim the
> + *		owner type (e.g. userspace driver frameworks) could set this
> + *		flag.
>   * @probe_type:	Type of the probe (synchronous or asynchronous) to use.
>   * @of_match_table: The open firmware table.
>   * @acpi_match_table: The ACPI match table.
> @@ -99,7 +103,8 @@ struct device_driver {
>  	struct module		*owner;
>  	const char		*mod_name;	/* used for built-in modules */
>  
> -	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
> +	bool suppress_bind_attrs:1;	/* disables bind/unbind via sysfs */
> +	bool suppress_auto_claim_dma_owner:1;

Can a bool be a bitfield?  Is that valid C?

And why is that even needed?

>  	enum probe_type probe_type;
>  
>  	const struct of_device_id	*of_match_table;
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 68ea1f949daa..ab3333351f19 100644
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
> @@ -566,6 +567,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  		goto done;
>  	}
>  
> +	if (!drv->suppress_auto_claim_dma_owner) {
> +		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_KERNEL, NULL);
> +		if (ret)
> +			return ret;
> +	}
> +

This feels wrong to be doing it in the driver core, why doesn't the bus
that cares about this handle it instead?

You just caused all drivers in the kernel today to set and release this
ownership, as none set this flag.  Shouldn't it be the other way around?

And again, why not in the bus that cares?

You only have problems with 1 driver out of thousands, this feels wrong
to abuse the driver core this way for just that one.

thanks,

greg k-h
