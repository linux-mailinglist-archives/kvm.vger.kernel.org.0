Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F4D3F1C76
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 17:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbhHSPQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 11:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239794AbhHSPQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 11:16:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B251560E76;
        Thu, 19 Aug 2021 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629386151;
        bh=i1VsQzbWxkLiM4lRhcPbE6ZrAU7xTQ0DnEcnhBk918k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=BCDvHR9020/3JsfA181x32CkqWtrZ0eEFmFXBMyuX5O5Jualf8RB6mb4JJx5UPksM
         ogzqtEszZLP9hEBTtRlIzFi/3BU80Z9r8j9/hyaLW4d3RKlTFgL3Llqns9+bxrziRH
         Vi8hkLpnCgVNbgq04TEf4KzTjE6D/ri5+DqqYva1GrIdHzrqh+VEeBWfuWpyTq780e
         soOfGGDyApjs8an8iSqSrmZg7FLIUw4ViPaeTMfHQRIP83nf7ULjYUgvMmsHQ0gkt1
         eCHDd98yq4UAJ7qsoGEycOqqtSUJ36SkSgcg05i/edgRoIdvtJWhJf8p9WOu1BzbT1
         x+XJkH81YdD3w==
Date:   Thu, 19 Aug 2021 10:15:49 -0500
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
Subject: Re: [PATCH V2 09/12] PCI: Add 'override_only' bitmap to struct
 pci_device_id
Message-ID: <20210819151549.GA3128368@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818151606.202815-10-yishaih@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 06:16:03PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> Allow device drivers to include match entries in the modules.alias file
> produced by kbuild that are not used for normal driver autoprobing and
> module autoloading. Drivers using these match entries can be connected
> to the PCI device manually, by userspace, using the existing
> driver_override sysfs.
> 
> To achieve it, we add the 'override_only' bitmap to struct pci_device_id
> and a helper macro named 'PCI_DEVICE_DRIVER_OVERRIDE' to enable setting
> specific bits on it.
> 
> The first bit (i.e. 'PCI_ID_F_VFIO_DRIVER_OVERRIDE') indicates that the
> match entry is for the VFIO subsystem, it can be set by another helper
> macro named 'PCI_DRIVER_OVERRIDE_DEVICE_VFIO'.
> 
> These match entries are prefixed with "vfio_" in the modules.alias.
> 
> For example the resulting modules.alias may have:
> 
>   alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
>   alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>   alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
> 
> In this example mlx5_core and mlx5_vfio_pci match to the same PCI
> device. The kernel will autoload and autobind to mlx5_core but the kernel
> and udev mechanisms will ignore mlx5_vfio_pci.
> 
> When userspace wants to change a device to the VFIO subsystem userspace
> can implement a generic algorithm:
> 
>    1) Identify the sysfs path to the device:
>     /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0
> 
>    2) Get the modalias string from the kernel:
>     $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
>     pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
> 
>    3) Prefix it with vfio_:
>     vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
> 
>    4) Search modules.alias for the above string and select the entry that
>       has the fewest *'s:
>     alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
> 
>    5) modprobe the matched module name:
>     $ modprobe mlx5_vfio_pci
> 
>    6) cat the matched module name to driver_override:
>     echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
> 
>    7) unbind device from original module
>     echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
> 
>    8) probe PCI drivers (or explicitly bind to mlx5_vfio_pci)
>     echo 0000:01:00.0 > /sys/bus/pci/drivers_probe
> 
> The algorithm is independent of bus type. In future the other buses's with

s/buses's/buses/

> VFIO device drivers, like platform and ACPI, can use this algorithm as
> well.
> 
> This patch is the infrastructure to provide the information in the
> modules.alias to userspace. Convert the only VFIO pci_driver which results
> in one new line in the modules.alias:
> 
>   alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
> 
> Later series introduce additional HW specific VFIO PCI drivers, such as
> mlx5_vfio_pci.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  Documentation/PCI/pci.rst         |  1 +
>  drivers/pci/pci-driver.c          | 27 ++++++++++++++++++++-------
>  drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
>  include/linux/mod_devicetable.h   |  6 ++++++
>  include/linux/pci.h               | 28 ++++++++++++++++++++++++++++
>  scripts/mod/devicetable-offsets.c |  1 +
>  scripts/mod/file2alias.c          |  8 ++++++--
>  7 files changed, 70 insertions(+), 10 deletions(-)
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
> index 3a72352aa5cf..8a6bd3364127 100644
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
> @@ -152,14 +152,27 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
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
> +		 * The match table is split based on driver_override. Check the
> +		 * override_only as well so that any matching entry is
> +		 * returned.
> +		 */
> +		if (!found_id->override_only || dev->driver_override)
> +			return found_id;

The negation makes this short, but IMO, makes this harder to read.
I'd rather test for the special case directly instead of testing for
the *absence* of the special case, e.g.,

  if (found_id->override_only) {
    if (dev->driver_override)
      return found_id;
  } else
    return found_id;

> +	}
>  
> -	return found_id;
> +	/*
> +	 * if no static match, driver_override will always match, send a dummy
> +	 * id.

I think the original comment was better.  This comment implies that we
only checked for static matches above, but we actually checked for
*both* dynamic IDs and static IDs.

> +	 */
> +	if (dev->driver_override)
> +		return &pci_device_id_any;
> +	return NULL;
>  }
>  
>  /**
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 07edddf7e6ca..c52620ac5e70 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -180,9 +180,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>  	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
>  }
>  
> +static const struct pci_device_id vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, vfio_pci_table);
> +
>  static struct pci_driver vfio_pci_driver = {
>  	.name			= "vfio-pci",
> -	.id_table		= NULL, /* only dynamic ids */
> +	.id_table		= vfio_pci_table,
>  	.probe			= vfio_pci_probe,
>  	.remove			= vfio_pci_remove,
>  	.sriov_configure	= vfio_pci_sriov_configure,
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 8e291cfdaf06..39c229a7ab8c 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -16,6 +16,10 @@ typedef unsigned long kernel_ulong_t;
>  
>  #define PCI_ANY_ID (~0)
>  
> +enum {
> +	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
> +};
> +
>  /**
>   * struct pci_device_id - PCI device ID structure
>   * @vendor:		Vendor ID to match (or PCI_ANY_ID)
> @@ -34,12 +38,14 @@ typedef unsigned long kernel_ulong_t;
>   *			Best practice is to use driver_data as an index
>   *			into a static list of equivalent device types,
>   *			instead of using it as a pointer.
> + * @override_only:	Bitmap for override_only PCI drivers.

"Match only when dev->driver_override is this driver"?

As far as PCI core is concerned there's no need for this to be a
bitmap.

I think this would make more sense if split into two patches.  The
first would add override_only and change pci_match_device().  Then
there's no confusion about whether this is specific to VFIO.

The second can add PCI_ID_F_VFIO_DRIVER_OVERRIDE and make the
file2alias.c changes.  Most of the commit log applies to this part.

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
> index 540b377ca8f6..57f9aa60f3b4 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -901,6 +901,34 @@ struct pci_driver {
>  	.vendor = (vend), .device = (dev), \
>  	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
>  
> +/**
> + * PCI_DEVICE_DRIVER_OVERRIDE - macro used to describe a PCI device with
> + *                              override_only flags.
> + * @vend: the 16 bit PCI Vendor ID
> + * @dev: the 16 bit PCI Device ID
> + * @driver_override: PCI Device override_only bitmap
> + *
> + * This macro is used to create a struct pci_device_id that matches a
> + * specific device. The subvendor and subdevice fields will be set to
> + * PCI_ANY_ID.
> + */
> +#define PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, driver_override) \
> +	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
> +	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
> +
> +/**
> + * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
> + *                                   "driver_override" PCI device.
> + * @vend: the 16 bit PCI Vendor ID
> + * @dev: the 16 bit PCI Device ID
> + *
> + * This macro is used to create a struct pci_device_id that matches a
> + * specific device. The subvendor and subdevice fields will be set to
> + * PCI_ANY_ID and the flags will be set to PCI_ID_F_VFIO_DRIVER_OVERRIDE.
> + */
> +#define PCI_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
> +	PCI_DEVICE_DRIVER_OVERRIDE(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> +
>  /**
>   * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
>   * @vend: the 16 bit PCI Vendor ID
> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
> index 9bb6c7edccc4..cc3625617a0e 100644
> --- a/scripts/mod/devicetable-offsets.c
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -42,6 +42,7 @@ int main(void)
>  	DEVID_FIELD(pci_device_id, subdevice);
>  	DEVID_FIELD(pci_device_id, class);
>  	DEVID_FIELD(pci_device_id, class_mask);
> +	DEVID_FIELD(pci_device_id, override_only);
>  
>  	DEVID(ccw_device_id);
>  	DEVID_FIELD(ccw_device_id, match_flags);
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 7c97fa8e36bc..c3edbf73157e 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
>  	return 1;
>  }
>  
> -/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
> +/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
>  static int do_pci_entry(const char *filename,
>  			void *symval, char *alias)
>  {
> @@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
>  	DEF_FIELD(symval, pci_device_id, subdevice);
>  	DEF_FIELD(symval, pci_device_id, class);
>  	DEF_FIELD(symval, pci_device_id, class_mask);
> +	DEF_FIELD(symval, pci_device_id, override_only);
>  
> -	strcpy(alias, "pci:");
> +	if (override_only & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> +		strcpy(alias, "vfio_pci:");
> +	else
> +		strcpy(alias, "pci:");
>  	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
>  	ADD(alias, "d", device != PCI_ANY_ID, device);
>  	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
> -- 
> 2.18.1
> 
