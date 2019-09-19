Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A0FB7E1B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 17:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390298AbfISPZS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 19 Sep 2019 11:25:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbfISPZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 11:25:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82AB181DE7;
        Thu, 19 Sep 2019 15:25:17 +0000 (UTC)
Received: from gondolin (dhcp-192-230.str.redhat.com [10.33.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBCE860C18;
        Thu, 19 Sep 2019 15:25:07 +0000 (UTC)
Date:   Thu, 19 Sep 2019 17:25:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     sebott@linux.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        pmorel@linux.ibm.com
Subject: Re: [PATCH v4 4/4] vfio: pci: Using a device region to retrieve
 zPCI information
Message-ID: <20190919172505.2eb075f8.cohuck@redhat.com>
In-Reply-To: <1567815231-17940-5-git-send-email-mjrosato@linux.ibm.com>
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
        <1567815231-17940-5-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 19 Sep 2019 15:25:17 +0000 (UTC)
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

From that description, I'd have no idea whether I'd want that or not.
Is there any downside to enabling it?

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

If you really want to have this configurable, why not just return 0
here and skip the IS_ENABLED check above?

> +}
> +#endif
> +
>  #endif /* VFIO_PCI_PRIVATE_H */

(...)
