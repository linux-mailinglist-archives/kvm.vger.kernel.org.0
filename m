Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B8B87DD
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 00:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391411AbfISW5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 18:57:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389376AbfISW5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 18:57:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96E313DE04;
        Thu, 19 Sep 2019 22:57:51 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84E775D6B2;
        Thu, 19 Sep 2019 22:57:50 +0000 (UTC)
Date:   Thu, 19 Sep 2019 16:57:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     sebott@linux.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com
Subject: Re: [PATCH v4 4/4] vfio: pci: Using a device region to retrieve
 zPCI information
Message-ID: <20190919165750.73675997@x1.home>
In-Reply-To: <1567815231-17940-5-git-send-email-mjrosato@linux.ibm.com>
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
        <1567815231-17940-5-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 19 Sep 2019 22:57:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  6 Sep 2019 20:13:51 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> We define a new configuration entry for VFIO/PCI, VFIO_PCI_ZDEV
> 
> When the VFIO_PCI_ZDEV feature is configured we initialize
> a new device region, VFIO_REGION_SUBTYPE_ZDEV_CLP, to hold
> the information from the ZPCI device the use
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig            |  7 +++
>  drivers/vfio/pci/Makefile           |  1 +
>  drivers/vfio/pci/vfio_pci.c         |  9 ++++
>  drivers/vfio/pci/vfio_pci_private.h | 10 +++++
>  drivers/vfio/pci/vfio_pci_zdev.c    | 85 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 112 insertions(+)
>  create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index ac3c1dd..d4562a8 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -45,3 +45,10 @@ config VFIO_PCI_NVLINK2
>  	depends on VFIO_PCI && PPC_POWERNV
>  	help
>  	  VFIO PCI support for P9 Witherspoon machine with NVIDIA V100 GPUs
> +
> +config VFIO_PCI_ZDEV
> +	bool "VFIO PCI Generic for ZPCI devices"
> +	depends on VFIO_PCI && S390
> +	default y
> +	help
> +	  VFIO PCI support for S390 Z-PCI devices
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index f027f8a..781e080 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -3,5 +3,6 @@
>  vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>  vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
> +vfio-pci-$(CONFIG_VFIO_PCI_ZDEV) += vfio_pci_zdev.o
>  
>  obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 703948c..b40544a 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -356,6 +356,15 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  		}
>  	}
>  
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV)) {
> +		ret = vfio_pci_zdev_init(vdev);
> +		if (ret) {
> +			dev_warn(&vdev->pdev->dev,
> +				 "Failed to setup ZDEV regions\n");
> +			goto disable_exit;
> +		}
> +	}
> +
>  	vfio_pci_probe_mmaps(vdev);
>  
>  	return 0;
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index ee6ee91..08e02f5 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -186,4 +186,14 @@ static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
>  	return -ENODEV;
>  }
>  #endif
> +
> +#ifdef CONFIG_VFIO_PCI_ZDEV
> +extern int vfio_pci_zdev_init(struct vfio_pci_device *vdev);
> +#else
> +static inline int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
>  #endif /* VFIO_PCI_PRIVATE_H */
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> new file mode 100644
> index 0000000..22e2b60
> --- /dev/null
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * VFIO ZPCI devices support
> + *
> + * Copyright (C) IBM Corp. 2019.  All rights reserved.
> + *	Author: Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/io.h>
> +#include <linux/pci.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/vfio_zdev.h>
> +
> +#include "vfio_pci_private.h"
> +
> +static size_t vfio_pci_zdev_rw(struct vfio_pci_device *vdev,
> +			       char __user *buf, size_t count, loff_t *ppos,
> +			       bool iswrite)
> +{
> +	struct vfio_region_zpci_info *region;
> +	struct zpci_dev *zdev;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +
> +	if (!vdev->pdev->bus)
> +		return -ENODEV;
> +
> +	zdev = vdev->pdev->bus->sysdata;
> +	if (!zdev)
> +		return -ENODEV;
> +
> +	if (pos >= sizeof(*region) || iswrite)
> +		return -EINVAL;
> +
> +	region = vdev->region[index - VFIO_PCI_NUM_REGIONS].data;
> +	region->dasm = zdev->dma_mask;
> +	region->start_dma = zdev->start_dma;
> +	region->end_dma = zdev->end_dma;
> +	region->msi_addr = zdev->msi_addr;
> +	region->flags = VFIO_PCI_ZDEV_FLAGS_REFRESH;

Even more curious what this means, why do we need a flag that's always
set?  Maybe NOREFRESH if it were ever to exist.

> +	region->gid = zdev->pfgid;
> +	region->mui = zdev->fmb_update;
> +	region->noi = zdev->max_msi;
> +	memcpy(region->util_str, zdev->util_str, CLP_UTIL_STR_LEN);

Just checking, I assume this is dynamic based on it being recreated
every time, otherwise you'd have created it in the init function and
just do the below on read, right?  The fields that I can guess what they
might be don't seem like they'd change.  Comments would be good.
Thanks,

Alex

> +
> +	count = min(count, (size_t)(sizeof(*region) - pos));
> +	if (copy_to_user(buf, region, count))
> +		return -EFAULT;
> +
> +	return count;
> +}
> +
> +static void vfio_pci_zdev_release(struct vfio_pci_device *vdev,
> +				  struct vfio_pci_region *region)
> +{
> +	kfree(region->data);
> +}
> +
> +static const struct vfio_pci_regops vfio_pci_zdev_regops = {
> +	.rw		= vfio_pci_zdev_rw,
> +	.release	= vfio_pci_zdev_release,
> +};
> +
> +int vfio_pci_zdev_init(struct vfio_pci_device *vdev)
> +{
> +	struct vfio_region_zpci_info *region;
> +	int ret;
> +
> +	region = kmalloc(sizeof(*region) + CLP_UTIL_STR_LEN, GFP_KERNEL);
> +	if (!region)
> +		return -ENOMEM;
> +
> +	ret = vfio_pci_register_dev_region(vdev,
> +		PCI_VENDOR_ID_IBM | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
> +		VFIO_REGION_SUBTYPE_ZDEV_CLP,
> +		&vfio_pci_zdev_regops, sizeof(*region) + CLP_UTIL_STR_LEN,
> +		VFIO_REGION_INFO_FLAG_READ, region);
> +
> +	return ret;
> +}

