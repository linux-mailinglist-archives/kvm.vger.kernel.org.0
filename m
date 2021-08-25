Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E443F7985
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 17:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbhHYP40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 11:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240495AbhHYP4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 11:56:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A8F461151;
        Wed, 25 Aug 2021 15:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629906939;
        bh=V9s9KJfOQtTa6v8mYQHZaDcryO1e0OuOtnamjdvnDW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=j48Eos7dG1irfytts2VXxMQlEKVsprLOBBgHDV3Ke2GU5I+HG+NxN6NED0G+RBwR1
         reNklRdpyDciCXFAItYXzKe4nz+n+M6UVjYszJ0Oq+ciOT5XA95Q5HhnKN0Lam1lMF
         AqamKFiBc9g1iuIQanioHWG3eOwETCdO/QIgfgZKqSMy3+Tr4uSwnlPFjw9267fe/W
         uNiSrp2XpF9dOFIyqXhVF7CoZM+1dFWsVW6Z9YM+YAOnlbGIf+n1hnWYZu4WD0yjln
         AH46VkxDg9bry8APkUAsKeDSHIdo+D3We7r6+9eWqoBYn6EkDmiFtPQg1teKQyaD1Z
         feR2+12oRRprg==
Date:   Wed, 25 Aug 2021 10:55:38 -0500
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
Subject: Re: [PATCH V4 10/13] PCI / VFIO: Add 'override_only' support for
 VFIO PCI sub system
Message-ID: <20210825155538.GA3575783@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825135139.79034-11-yishaih@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 04:51:36PM +0300, Yishai Hadas wrote:
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> Expose an 'override_only' helper macro (i.e.
> PCI_DRIVER_OVERRIDE_DEVICE_VFIO) for VFIO PCI sub system and add the
> required code to prefix its matching entries with "vfio_" in
> modules.alias file.
> 
> It allows VFIO device drivers to include match entries in the
> modules.alias file produced by kbuild that are not used for normal
> driver autoprobing and module autoloading. Drivers using these match
> entries can be connected to the PCI device manually, by userspace, using
> the existing driver_override sysfs.
> 
> For example the resulting modules.alias may have:
> 
>   alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
>   alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>   alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
> 
> In this example mlx5_core and mlx5_vfio_pci match to the same PCI
> device. The kernel will autoload and autobind to mlx5_core but the
> kernel and udev mechanisms will ignore mlx5_vfio_pci.
> 
> When userspace wants to change a device to the VFIO subsystem it can
> implement a generic algorithm:
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
>      echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
> 
>    8) probe PCI drivers (or explicitly bind to mlx5_vfio_pci)
>     echo 0000:01:00.0 > /sys/bus/pci/drivers_probe
> 
> The algorithm is independent of bus type. In future the other buses with
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

Acked-by: Bjorn Helgaas <bhelgaas@google.com>  # for pci.h

> ---
>  drivers/vfio/pci/vfio_pci.c       |  9 ++++++++-
>  include/linux/mod_devicetable.h   |  4 ++++
>  include/linux/pci.h               | 14 ++++++++++++++
>  scripts/mod/devicetable-offsets.c |  1 +
>  scripts/mod/file2alias.c          |  8 ++++++--
>  5 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 163e560c4495..85fd638a5955 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -178,9 +178,16 @@ static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
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
> index 2e3ba6d9ece0..f0325a172f87 100644
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
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 0506b1a8c921..527a1dfd1d06 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -916,6 +916,20 @@ struct pci_driver {
>  	.vendor = (vend), .device = (dev), .subvendor = PCI_ANY_ID, \
>  	.subdevice = PCI_ANY_ID, .override_only = (driver_override)
>  
> +/**
> + * PCI_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
> + *                                   "driver_override" PCI device.
> + * @vend: the 16 bit PCI Vendor ID
> + * @dev: the 16 bit PCI Device ID
> + *
> + * This macro is used to create a struct pci_device_id that matches a
> + * specific device. The subvendor and subdevice fields will be set to
> + * PCI_ANY_ID and the driver_override will be set to
> + * PCI_ID_F_VFIO_DRIVER_OVERRIDE.
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
