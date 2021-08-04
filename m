Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5ED53E096D
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 22:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhHDUe2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 16:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231249AbhHDUe1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 16:34:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE79960F10;
        Wed,  4 Aug 2021 20:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628109254;
        bh=JC3A2IM667lBAomihs47PQQa7OiPNm77RashY2lC3qc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=NpQnaCkF4cbIFp0g4GARDzrsn63eO87qjDr4cSnmk0VtAyYFx5b25S5M2c3xayaSd
         iNiyqRoWqbMMT0r6nYS53N3lJt7pXrVgEQurIlJokLskv9X1S0G2nNF/Xk+1tN4kdD
         4xsK+KXfAjTXBXbclM6XdHwcqG5RFZx/1lUX/Fd6cxS6ErnxzTwRNx4TK7tuNBQdj7
         FtI5PbHotaHBWx5ZeFq1tnyKGCdK7MFbXzNNlj9s443iZVEG3lcUYr/LOe6wJSYBPB
         ExfS+Fi8OkT0i5LLcEpsDj6ixCJK2XGoA1BcIah33GSk3PW2Ss7V5ffiXXBMNzOovk
         8DII2hRYhphwQ==
Date:   Wed, 4 Aug 2021 15:34:12 -0500
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
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210804203412.GA1663387@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721161609.68223-10-yishaih@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021 at 07:16:06PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> The new flag field is be used to allow PCI drivers to signal the core code
> during driver matching and when generating the modules.alias information.

This needs to read as a complete idea even without the subject line.
The subject is the *title*; it's not the first sentence of the essay.

It's OK to repeat the subject line in the commit log, but I don't
think that would solve the problem here because "signal core code" and
"when generating ..." doesn't get to the point of the patch.

What's the objective here?

> The first use will be to define a VFIO flag that indicates the PCI driver
> is a VFIO driver.

Is there such a thing as a "VFIO driver" today?  Maybe this patch is
introducing that concept?  If so, maybe lead off by motivating and
defining what it is, then follow up with the details that go into
implementing it.

> VFIO drivers have a few special properties compared to normal PCI drivers:
>  - They do not automatically bind. VFIO drivers are used to swap out the
>    normal driver for a device and convert the PCI device to the VFIO
>    subsystem.

The comment below says "... any matching PCI_ID_F_DRIVER_OVERRIDE
[sic] entry is returned," which sounds like the opposite of "do not
automatically bind."  Might be exposing my VFIO ignorance here.

>    The admin must make this choice and following the current uAPI this is
>    usually done by using the driver_override sysfs.

I'm not sure "converting PCI device to the VFIO subsystem" is the
right way to phrase this, but whatever it is, make this idea specific,
e.g., by "echo pci-stub > /sys/.../driver_override" or whatever.

>  - The modules.alias includes the IDs of the VFIO PCI drivers, prefixing
>    them with 'vfio_pci:' instead of the normal 'pci:'.
> 
>    This allows the userspace machinery that switches devices to VFIO to
>    know what kernel drivers support what devices and allows it to trigger
>    the proper device_override.

What does "switch device to VFIO" mean?  I could be reading this too
literally (in my defense, I'm not a VFIO expert), but AFAICT this is
not something you do to the *device*.  I guess maybe this is something
like "prevent the normal driver from claiming the device so we can use
VFIO instead"?  Does "using VFIO" mean getting vfio-pci to claim the
device?

> As existing tools do not recognize the "vfio_pci:" mod-alias prefix this
> keeps todays behavior the same. VFIO remains on the side, is never
> autoloaded and can only be activated by direct admin action.

s/todays/today's/

> This patch is the infrastructure to provide the information in the
> modules.alias to userspace and enable the only PCI VFIO driver. Later
> series introduce additional HW specific VFIO PCI drivers.

s/the only/only the/ ?  (Not sure what you intend, but "the only"
doesn't seem right)

Sorry, I know I'm totally missing the point here.

> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  Documentation/PCI/pci.rst         |  1 +
>  drivers/pci/pci-driver.c          | 25 +++++++++++++++++++++----
>  drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
>  include/linux/mod_devicetable.h   |  7 +++++++
>  include/linux/pci.h               | 27 +++++++++++++++++++++++++++
>  scripts/mod/devicetable-offsets.c |  1 +
>  scripts/mod/file2alias.c          |  8 ++++++--
>  7 files changed, 71 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/PCI/pci.rst b/Documentation/PCI/pci.rst
> index fa651e25d98c..24e70a386887 100644
> --- a/Documentation/PCI/pci.rst
> +++ b/Documentation/PCI/pci.rst
> @@ -103,6 +103,7 @@ need pass only as many optional fields as necessary:
>    - subvendor and subdevice fields default to PCI_ANY_ID (FFFFFFFF)
>    - class and classmask fields default to 0
>    - driver_data defaults to 0UL.
> +  - flags field defaults to 0.
>  
>  Note that driver_data must match the value used by any of the pci_device_id
>  entries defined in the driver. This makes the driver_data field mandatory
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 3a72352aa5cf..1ed8a4ab96f1 100644
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
> @@ -152,10 +152,27 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
>  	}
>  	spin_unlock(&drv->dynids.lock);
>  
> -	if (!found_id)
> -		found_id = pci_match_id(drv->id_table, dev);
> +	if (found_id)
> +		return found_id;
> +
> +	ids = drv->id_table;
> +	while ((found_id = pci_match_id(ids, dev))) {
> +		/*
> +		 * The match table is split based on driver_override. Check the
> +		 * flags as well so that any matching PCI_ID_F_DRIVER_OVERRIDE

s/PCI_ID_F_DRIVER_OVERRIDE/PCI_ID_F_VFIO_DRIVER_OVERRIDE/ ?

> +		 * entry is returned.
> +		 */
> +		if ((found_id->flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE) &&
> +		    !dev->driver_override)
> +			ids = found_id + 1;
> +		else
> +			break;

Isn't this break the same as "return found_id"?

> +	}
>  
> -	/* driver_override will always match, send a dummy id */
> +	/*
> +	 * if no static match, driver_override will always match, send a dummy

AFAICT this patch did not change dynamic matching, so I don't know why
you changed this comment.  Previously driver_override matched if there
was no dynamic or static match.  Now it's the same except that we skip
static matches with PCI_ID_F_VFIO_DRIVER_OVERRIDE.

> +	 * id.
> +	 */
>  	if (!found_id && dev->driver_override)
>  		found_id = &pci_device_id_any;
>  
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0272b95d9c5f..7a43edbe8618 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -181,9 +181,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>  	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
>  }
>  
> +static const struct pci_device_id vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_ANY_ID, PCI_ANY_ID) }, /* match all by default */
> +	{ 0, }
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
> index 8e291cfdaf06..cd256d9c60d2 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -16,6 +16,11 @@ typedef unsigned long kernel_ulong_t;
>  
>  #define PCI_ANY_ID (~0)
>  
> +

Spurious blank line.

> +enum pci_id_flags {
> +	PCI_ID_F_VFIO_DRIVER_OVERRIDE	= 1 << 0,
> +};

Why an enum?  Is the enum and the name following some similar style
elsewhere?

> +
>  /**
>   * struct pci_device_id - PCI device ID structure
>   * @vendor:		Vendor ID to match (or PCI_ANY_ID)
> @@ -34,12 +39,14 @@ typedef unsigned long kernel_ulong_t;
>   *			Best practice is to use driver_data as an index
>   *			into a static list of equivalent device types,
>   *			instead of using it as a pointer.
> + * @flags:		PCI flags of the driver. Bitmap of pci_id_flags enum.
>   */
>  struct pci_device_id {
>  	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
>  	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
>  	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
>  	kernel_ulong_t driver_data;	/* Data private to the driver */
> +	__u32 flags;
>  };
>  
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 540b377ca8f6..fd84609ff06b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -901,6 +901,33 @@ struct pci_driver {
>  	.vendor = (vend), .device = (dev), \
>  	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
>  
> +/**
> + * PCI_DEVICE_FLAGS - macro used to describe a PCI device with specific flags.
> + * @vend: the 16 bit PCI Vendor ID
> + * @dev: the 16 bit PCI Device ID
> + * @fl: PCI Device flags as a bitmap of pci_id_flags enum
> + *
> + * This macro is used to create a struct pci_device_id that matches a
> + * specific device. The subvendor and subdevice fields will be set to
> + * PCI_ANY_ID.
> + */
> +#define PCI_DEVICE_FLAGS(vend, dev, fl) \
> +	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
> +	.subdevice = PCI_ANY_ID, .flags = (fl)
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
> +	PCI_DEVICE_FLAGS(vend, dev, PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> +
>  /**
>   * PCI_DEVICE_SUB - macro used to describe a specific PCI device with subsystem
>   * @vend: the 16 bit PCI Vendor ID
> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
> index 9bb6c7edccc4..b927c36b8333 100644
> --- a/scripts/mod/devicetable-offsets.c
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -42,6 +42,7 @@ int main(void)
>  	DEVID_FIELD(pci_device_id, subdevice);
>  	DEVID_FIELD(pci_device_id, class);
>  	DEVID_FIELD(pci_device_id, class_mask);
> +	DEVID_FIELD(pci_device_id, flags);
>  
>  	DEVID(ccw_device_id);
>  	DEVID_FIELD(ccw_device_id, match_flags);
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 7c97fa8e36bc..f53b38e8f696 100644
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
> +	DEF_FIELD(symval, pci_device_id, flags);

I'm a little bit wary of adding a new field to this kernel/user
interface just for this single bit.  Maybe it's justified but feels
like it's worth being careful.

> -	strcpy(alias, "pci:");
> +	if (flags & PCI_ID_F_VFIO_DRIVER_OVERRIDE)
> +		strcpy(alias, "vfio_pci:");
> +	else
> +		strcpy(alias, "pci:");
>  	ADD(alias, "v", vendor != PCI_ANY_ID, vendor);
>  	ADD(alias, "d", device != PCI_ANY_ID, device);
>  	ADD(alias, "sv", subvendor != PCI_ANY_ID, subvendor);
> -- 
> 2.18.1
> 
