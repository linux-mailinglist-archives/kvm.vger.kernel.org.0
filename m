Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F017B1CCDB
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 18:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfENQVr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 14 May 2019 12:21:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28387 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfENQVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 12:21:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F317C0624DF;
        Tue, 14 May 2019 16:21:43 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB18A600C5;
        Tue, 14 May 2019 16:21:38 +0000 (UTC)
Date:   Tue, 14 May 2019 10:21:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yamada.masahiro@socionext.com, iommu@lists.linux-foundation.org
Subject: Re: [RFC v3 1/3] vfio_pci: split vfio_pci.c into two source files
Message-ID: <20190514102138.13bf7de0@x1.home>
In-Reply-To: <1556021680-2911-2-git-send-email-yi.l.liu@intel.com>
References: <1556021680-2911-1-git-send-email-yi.l.liu@intel.com>
        <1556021680-2911-2-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 14 May 2019 16:21:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Apr 2019 20:14:38 +0800
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> This patch splits the non-module specific codes from original
> drivers/vfio/pci/vfio_pci.c into a common.c under drivers/vfio/pci.
> This is for potential code sharing. e.g. vfio-mdev-pci driver
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu, Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/Makefile           |    2 +-
>  drivers/vfio/pci/common.c           | 1511 +++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci.c         | 1476 +---------------------------------
>  drivers/vfio/pci/vfio_pci_private.h |   27 +
>  4 files changed, 1551 insertions(+), 1465 deletions(-)
>  create mode 100644 drivers/vfio/pci/common.c
> 
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 9662c06..813f6b3 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -1,5 +1,5 @@
>  
> -vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
> +vfio-pci-y := vfio_pci.o common.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
>  vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
>  vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
>  
> diff --git a/drivers/vfio/pci/common.c b/drivers/vfio/pci/common.c
> new file mode 100644
> index 0000000..847e2e4
> --- /dev/null
> +++ b/drivers/vfio/pci/common.c

Nit, I realize that our file naming scheme includes a lot of
redundancy, but better to have redundancy than inconsistency imo.
Perhaps vfio_pci_common.c.

> @@ -0,0 +1,1511 @@
> +/*
> + * Copyright © 2019 Intel Corporation.
> + *     Author: Liu, Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Derived from original vfio_pci.c:
> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> + *     Author: Alex Williamson <alex.williamson@redhat.com>
> + *
> + * Derived from original vfio:
> + * Copyright 2010 Cisco Systems, Inc.  All rights reserved.
> + * Author: Tom Lyon, pugs@cisco.com
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/device.h>
> +#include <linux/eventfd.h>
> +#include <linux/file.h>
> +#include <linux/interrupt.h>
> +#include <linux/iommu.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/pci.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/vfio.h>
> +#include <linux/vgaarb.h>
> +#include <linux/nospec.h>
> +
> +#include "vfio_pci_private.h"
> +

[snip faithful code moves]

> +void vfio_pci_vga_probe(struct vfio_pci_device *vdev)
> +{
> +	vga_client_register(vdev->pdev, vdev, NULL, vfio_pci_set_vga_decode);
> +	vga_set_legacy_decoding(vdev->pdev,
> +				vfio_pci_set_vga_decode(vdev, false));
> +}
> +
> +void vfio_pci_vga_remove(struct vfio_pci_device *vdev)
> +{
> +	vga_client_register(vdev->pdev, NULL, NULL, NULL);
> +	vga_set_legacy_decoding(vdev->pdev,
> +			VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> +			VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
> +}

Two new functions, though the names don't really match their purpose.

[snip more faithful code moves]
> +
> +void vfio_pci_probe_idle_d3(struct vfio_pci_device *vdev)
> +{
> +
> +	/*
> +	 * pci-core sets the device power state to an unknown value at
> +	 * bootup and after being removed from a driver.  The only
> +	 * transition it allows from this unknown state is to D0, which
> +	 * typically happens when a driver calls pci_enable_device().
> +	 * We're not ready to enable the device yet, but we do want to
> +	 * be able to get to D3.  Therefore first do a D0 transition
> +	 * before going to D3.
> +	 */
> +	vfio_pci_set_power_state(vdev, PCI_D0);
> +	vfio_pci_set_power_state(vdev, PCI_D3hot);
> +}

Another new function.  This also doesn't really match function name to
purpose.

[snip more faithful code moves]
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 3fa20e9..6ce1a81 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
[en masse code deletes]
> @@ -1324,6 +147,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	spin_lock_init(&vdev->irqlock);
>  	mutex_init(&vdev->ioeventfds_lock);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> +	vdev->nointxmask = nointxmask;
> +#ifdef CONFIG_VFIO_PCI_VGA
> +	vdev->disable_vga = disable_vga;
> +#endif
> +	vdev->disable_idle_d3 = disable_idle_d3;
>  
>  	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
>  	if (ret) {
> @@ -1340,27 +168,13 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return ret;
>  	}
>  
> -	if (vfio_pci_is_vga(pdev)) {
> -		vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
> -		vga_set_legacy_decoding(pdev,
> -					vfio_pci_set_vga_decode(vdev, false));
> -	}
> +	if (vfio_pci_is_vga(pdev))
> +		vfio_pci_vga_probe(vdev);
>  
>  	vfio_pci_probe_power_state(vdev);
>  
> -	if (!disable_idle_d3) {
> -		/*
> -		 * pci-core sets the device power state to an unknown value at
> -		 * bootup and after being removed from a driver.  The only
> -		 * transition it allows from this unknown state is to D0, which
> -		 * typically happens when a driver calls pci_enable_device().
> -		 * We're not ready to enable the device yet, but we do want to
> -		 * be able to get to D3.  Therefore first do a D0 transition
> -		 * before going to D3.
> -		 */
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> -		vfio_pci_set_power_state(vdev, PCI_D3hot);
> -	}
> +	if (!disable_idle_d3)
> +		vfio_pci_probe_idle_d3(vdev);
>  
>  	return ret;
>  }
> @@ -1383,48 +197,14 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>  
>  	kfree(vdev->pm_save);
> -	kfree(vdev);
>  
>  	if (vfio_pci_is_vga(pdev)) {
> -		vga_client_register(pdev, NULL, NULL, NULL);
> -		vga_set_legacy_decoding(pdev,
> -				VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
> -				VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM);
> -	}
> -}
> -
> -static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
> -						  pci_channel_state_t state)
> -{
> -	struct vfio_pci_device *vdev;
> -	struct vfio_device *device;
> -
> -	device = vfio_device_get_from_dev(&pdev->dev);
> -	if (device == NULL)
> -		return PCI_ERS_RESULT_DISCONNECT;
> -
> -	vdev = vfio_device_data(device);
> -	if (vdev == NULL) {
> -		vfio_device_put(device);
> -		return PCI_ERS_RESULT_DISCONNECT;
> +		vfio_pci_vga_remove(vdev);
>  	}
>  
> -	mutex_lock(&vdev->igate);
> -
> -	if (vdev->err_trigger)
> -		eventfd_signal(vdev->err_trigger, 1);
> -
> -	mutex_unlock(&vdev->igate);
> -
> -	vfio_device_put(device);
> -
> -	return PCI_ERS_RESULT_CAN_RECOVER;
> +	kfree(vdev);
>  }

All of the above refactoring should occur in a preceding patch(es).
This patch should be 100% unchanged code moves plus support
includes/defines and comment header in the new file.

> @@ -1685,7 +233,7 @@ static int __init vfio_pci_init(void)
>  	if (ret)
>  		goto out_driver;
>  
> -	vfio_pci_fill_ids();
> +	vfio_pci_fill_ids(&ids[0], &vfio_pci_driver);

For instance I missed this change.

>  
>  	return 0;
>  
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 1812cf2..9bbf22c 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -125,6 +125,11 @@ struct vfio_pci_device {
>  	struct list_head	dummy_resources_list;
>  	struct mutex		ioeventfds_lock;
>  	struct list_head	ioeventfds_list;
> +	bool			nointxmask;
> +#ifdef CONFIG_VFIO_PCI_VGA
> +	bool			disable_vga;
> +#endif
> +	bool			disable_idle_d3;

More refactoring, do these separately so they can be properly reviewed
without trying to spot changes in 3000 lines of diff.  I think what
you've done is sound, it just needs to be refactored separate from the
code moves so that it can be reviewed.  Thanks!

Alex
