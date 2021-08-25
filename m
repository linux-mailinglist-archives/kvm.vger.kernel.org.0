Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE03A3F797C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 17:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241469AbhHYPze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 11:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237144AbhHYPzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 11:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E8E6113C;
        Wed, 25 Aug 2021 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629906887;
        bh=TCaeqsA8D2KWuPxjsXVTeKWgWn8CA9TYMwTL+5QAHJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=CmIsEqZCC1jsEZ7r3VcgW8L+FXL1sLOX3x5iSFQ0togj5IV65JDSKOJk2yfkgSMaA
         bTH4LCLoV2/akZ5v3EtZzrzz8fo6L+cdg+ARSshOcHaFpPQDWnnPUhA2adkDagblWF
         oUh0GSXedq3u5pjxWWaFWkKXjoMZJjSDuxBzBDeb2lt/9fzRZQvdkfITEtxscVisCv
         /zAZ/WKPlvyq0Ix55JJZAN9S1+PbOW0pnsIayWcuSDH5GetjDu4dgA+3p/p8OPnmuQ
         JPTCGGF/5EruSMFfc643hB6QUJc5tXCbbB5k5XWPEH//z9VLXQxNfH2ICbKhV5CIm3
         LU53cX/Kf+Ugw==
Date:   Wed, 25 Aug 2021 10:54:46 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     bhelgaas@google.com, corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, jgg@nvidia.com, maorg@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH V4 09/13] PCI: Add 'override_only' field to struct
 pci_device_id
Message-ID: <20210825155446.GA3575423@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-10-yishaih@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:35PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> Add 'override_only' field to struct pci_device_id to be used as part of
> pci_match_device().
> 
> When set, it means that matching is true only when dev->driver_override
> is this driver.

Maybe:

  When set, a driver only matches the entry when dev->driver_override
  is set to that driver.

> In addition, add a helper macro named 'PCI_DEVICE_DRIVER_OVERRIDE' to
> enable setting some data on it.
> 
> Next patch from this series will use the above functionality.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---

>  Documentation/PCI/pci.rst       |  1 +
>  drivers/pci/pci-driver.c        | 28 +++++++++++++++++++++-------
>  include/linux/mod_devicetable.h |  2 ++
>  include/linux/pci.h             | 15 +++++++++++++++
>  4 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
> index fa651e25d98c..87c6f4a6ca32 100644
> --- a/Documentation/PCI/pci.rst
> +++ b/Documentation/PCI/pci.rst
> @@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
>    - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
>    - class and classmask fields default to 0
>    - driver_data defaults to 0UL.
> +  - override_only field defaults to 0.
>  
>  Note that driver_data must match the value used by any of the pci_device_id
>  entries defined in the driver. This makes the driver_data field mandatory
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 3a72352aa5cf..123c590ebe1d 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -136,7 +136,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  						    struct pci_dev *dev)
>  {
>  	struct pci_dynid *dynid;
> -	const struct pci_device_id *found_id = NULL;
> +	const struct pci_device_id *found_id = NULL, *ids;
>  
>  	/* When driver_override is set, only bind to the matching driver */
>  	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
> @@ -152,14 +152,28 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  	}
>  	spin_unlock(&drv->dynids.lock);
>  
> -	if (!found_id)
> -		found_id = pci_match_id(drv->id_table, dev);
> +	if (found_id)
> +		return found_id;
>  
> -	/* driver_override will always match, send a dummy id */
> -	if (!found_id && dev->driver_override)
> -		found_id = &pci_device_id_any;
> +	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
> +	     ids = found_id + 1) {
> +		/*
> +		 * The match table is split based on driver_override.
> +		 * In case override_only was set, enforce driver_override
> +		 * matching.
> +		 */
> +		if (found_id->override_only) {
> +			if (dev->driver_override)
> +				return found_id;
> +		} else {
> +			return found_id;
> +		}
> +	}
>  
> -	return found_id;
> +	/* driver_override will always match, send a dummy id */
> +	if (dev->driver_override)
> +		return &pci_device_id_any;
> +	return NULL;
>  }
>  
>  /**
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 8e291cfdaf06..2e3ba6d9ece0 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -34,12 +34,14 @@ typedef unsigned long kernel_ulong_t;
>   *			Best practice is to use driver_data as an index
>   *			into a static list of equivalent device types,
>   *			instead of using it as a pointer.
> + * @override_only:	Match only when dev->driver_override is this driver.
>   */
>  struct pci_device_id {
>  	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
>  	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
>  	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
>  	kernel_ulong_t driver_data;	/* Data private to the driver */
> +	__u32 override_only;
>  };
>  
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 540b377ca8f6..0506b1a8c921 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -901,6 +901,21 @@ struct pci_driver {
>  	.vendor = (vend), .device = (dev), \
>  	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
>  
> +/**
> + * PCI_DEVICE_DRIVER_OVERRIDE - macro used to describe a PCI device with
> + *                              override_only flags.
> + * @vend: the 16 bit PCI Vendor ID
> + * @dev: the 16 bit PCI Device ID
> + * @driver_override: the 32 bit PCI Device override_only
> + *
> + * This macro is used to create a struct pci_device_id that matches only a
> + * driver_override device. The subvendor and subdevice fields will be set to
> + * PCI_ANY_ID.
> + */
> +#define PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, driver_override) \
> +	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
> +	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
> +
>  /**
>   * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
>   * @vend: the 16 bit PCI Vendor ID
> -- 
> 2.18.1
> 
