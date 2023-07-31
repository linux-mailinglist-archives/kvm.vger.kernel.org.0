Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2981F76A247
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 22:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjGaU6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 16:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjGaU6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 16:58:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758B210C0
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690837050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uYoc78i2yN33KHdNspwzw45SDNy7M22frEBBENIdzn8=;
        b=JMpNlnX9PnslIErhw2RGYSjFOCmwKon+azlDQXPsD+1V7YgygzCbbiMdF2uKpgYIMO2wd7
        VK6PSbFrL9UZ6rP6UybqoQzNrAJRO1Xz7fdTfhDawagfv1h0bMbp/8m9FFQsAbN5U7NjKs
        z0TZKPP9UYcNv1vvJPngUR5AEr+MeEI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-oDeY5JsFM4aSgszMzZQtTQ-1; Mon, 31 Jul 2023 16:57:28 -0400
X-MC-Unique: oDeY5JsFM4aSgszMzZQtTQ-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-78704050adbso557700939f.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 13:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690837048; x=1691441848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uYoc78i2yN33KHdNspwzw45SDNy7M22frEBBENIdzn8=;
        b=BdDa7SMDVUgsvXkoDjS+m0pCdJcJ6I2BZEv9oUssM5dP7ow7nUZgPgH0M2QjRQLNxv
         Di1G8sIvmOnBHyG+jWUqkcMgFYdCRnOhaC6u9cVGgD79kNMZHz/TM4iAdYwJl0u+jxGP
         cvuSIOATeVVAH/XeRkofFeFLnm4Z6HYraD3uZ8KgP/ckaUA6utd2j2FK+R0tMHUSYwwk
         QSlcQ8v77ahqGTbytJQiDIuHtqeuCedV1wdl+ZfULL9cAhkaRkNG0D7B8u4l4kRcX9sl
         kBQ+bf1BmtHl51WIrAXcl9E7jnqI8zCvZCTUv+VjypoTGd8D/uMfOEaBV/AXL1ggGrGH
         otfw==
X-Gm-Message-State: ABy/qLbkzXc7DHi+KQx8EeWS3lAT3+GdcEXE9cZVtk3WlcyTU4Z0Yy4/
        +sbRecVK+5LTh+/aBv8KdYXmsn1kI55jsQ6908vd3UYubNgQcIPsDGCu40LD4tZ4Jm2N+5OTy2v
        7hdbIQzqvTDhU
X-Received: by 2002:a6b:7311:0:b0:783:62af:fbdf with SMTP id e17-20020a6b7311000000b0078362affbdfmr9851019ioh.14.1690837048016;
        Mon, 31 Jul 2023 13:57:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHjHbSxM9Drj7LKQ0OGofs1mezS4RwyQXegIVsUXy2skXRrNWxfds11W7Cs1rI3L4G6hTAMqQ==
X-Received: by 2002:a6b:7311:0:b0:783:62af:fbdf with SMTP id e17-20020a6b7311000000b0078362affbdfmr9851003ioh.14.1690837047739;
        Mon, 31 Jul 2023 13:57:27 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id g2-20020a5ec742000000b0078647b08ab0sm3463732iop.6.2023.07.31.13.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 13:57:27 -0700 (PDT)
Date:   Mon, 31 Jul 2023 14:57:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>, <simon.horman@corigine.com>,
        <shannon.nelson@amd.com>
Subject: Re: [PATCH v13 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <20230731145725.1c81e802.alex.williamson@redhat.com>
In-Reply-To: <20230725214025.9288-4-brett.creeley@amd.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
        <20230725214025.9288-4-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Jul 2023 14:40:21 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> The pds_core driver will supply adminq services, so find the PF
> and register with the DSC services.
> 
> Use the following commands to enable a VF:
> echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/pds/Makefile   |  1 +
>  drivers/vfio/pci/pds/cmds.c     | 44 +++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/cmds.h     | 10 ++++++++
>  drivers/vfio/pci/pds/pci_drv.c  | 19 ++++++++++++++
>  drivers/vfio/pci/pds/pci_drv.h  |  9 +++++++
>  drivers/vfio/pci/pds/vfio_dev.c | 13 +++++++++-
>  drivers/vfio/pci/pds/vfio_dev.h |  6 +++++
>  include/linux/pds/pds_common.h  |  3 ++-
>  8 files changed, 103 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/pci/pds/cmds.c
>  create mode 100644 drivers/vfio/pci/pds/cmds.h
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.h
> 
> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
> index e5e53a6d86d1..91587c7fe8f9 100644
> --- a/drivers/vfio/pci/pds/Makefile
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -4,5 +4,6 @@
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds-vfio-pci.o
>  
>  pds-vfio-pci-y := \
> +	cmds.o		\
>  	pci_drv.o	\
>  	vfio_dev.o
> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
> new file mode 100644
> index 000000000000..198e8e2ed002
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/io.h>
> +#include <linux/types.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +
> +#include "vfio_dev.h"
> +#include "cmds.h"
> +
> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
> +	char devname[PDS_DEVNAME_LEN];
> +	int ci;
> +
> +	snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_VFIO_LM_DEV_NAME,
> +		 pci_domain_nr(pdev->bus),
> +		 PCI_DEVID(pdev->bus->number, pdev->devfn));
> +
> +	ci = pds_client_register(pci_physfn(pdev), devname);
> +	if (ci < 0)
> +		return ci;
> +
> +	pds_vfio->client_id = ci;

Not to be solved in this series, but the documentation is wrong:

/**
 * pds_client_register - Link the client to the firmware
 * @pf_pdev:    ptr to the PF driver struct
 * @devname:    name that includes service into, e.g. pds_core.vDPA
 *
 * Return: 0 on success, or
 *         negative for error
 */

But obviously it does return the client ID and cannot return 0.  Thanks,

Alex

> +
> +	return 0;
> +}
> +
> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
> +	int err;
> +
> +	err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
> +	if (err)
> +		dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
> +			ERR_PTR(err));
> +
> +	pds_vfio->client_id = 0;
> +}
> diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
> new file mode 100644
> index 000000000000..4c592afccf89
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/cmds.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _CMDS_H_
> +#define _CMDS_H_
> +
> +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
> +void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
> +
> +#endif /* _CMDS_H_ */
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> index 4670ddda603a..928903a84f27 100644
> --- a/drivers/vfio/pci/pds/pci_drv.c
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -8,9 +8,13 @@
>  #include <linux/types.h>
>  #include <linux/vfio.h>
>  
> +#include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
>  
>  #include "vfio_dev.h"
> +#include "pci_drv.h"
> +#include "cmds.h"
>  
>  #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
>  #define PCI_VENDOR_ID_PENSANDO		0x1dd8
> @@ -27,13 +31,27 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
>  		return PTR_ERR(pds_vfio);
>  
>  	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
> +	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
> +	if (IS_ERR_OR_NULL(pds_vfio->pdsc)) {
> +		err = PTR_ERR(pds_vfio->pdsc) ?: -ENODEV;
> +		goto out_put_vdev;
> +	}
>  
>  	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
>  	if (err)
>  		goto out_put_vdev;
>  
> +	err = pds_vfio_register_client_cmd(pds_vfio);
> +	if (err) {
> +		dev_err(&pdev->dev, "failed to register as client: %pe\n",
> +			ERR_PTR(err));
> +		goto out_unregister_coredev;
> +	}
> +
>  	return 0;
>  
> +out_unregister_coredev:
> +	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>  out_put_vdev:
>  	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>  	return err;
> @@ -43,6 +61,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
>  {
>  	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
>  
> +	pds_vfio_unregister_client_cmd(pds_vfio);
>  	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
>  	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
>  }
> diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
> new file mode 100644
> index 000000000000..e79bed12ed14
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/pci_drv.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _PCI_DRV_H
> +#define _PCI_DRV_H
> +
> +#include <linux/pci.h>
> +
> +#endif /* _PCI_DRV_H */
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index 6d7ff1e07373..ce42f0b461b3 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -6,6 +6,11 @@
>  
>  #include "vfio_dev.h"
>  
> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
> +{
> +	return pds_vfio->vfio_coredev.pdev;
> +}
> +
>  struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
>  {
>  	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> @@ -20,7 +25,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
>  		container_of(vdev, struct pds_vfio_pci_device,
>  			     vfio_coredev.vdev);
>  	struct pci_dev *pdev = to_pci_dev(vdev->dev);
> -	int err, vf_id;
> +	int err, vf_id, pci_id;
>  
>  	vf_id = pci_iov_vf_id(pdev);
>  	if (vf_id < 0)
> @@ -32,6 +37,12 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
>  
>  	pds_vfio->vf_id = vf_id;
>  
> +	pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
> +	dev_dbg(&pdev->dev,
> +		"%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
> +		__func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
> +		pci_domain_nr(pdev->bus), pds_vfio);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
> index a4d4b65778d1..824832aa1513 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.h
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -7,13 +7,19 @@
>  #include <linux/pci.h>
>  #include <linux/vfio_pci_core.h>
>  
> +struct pdsc;
> +
>  struct pds_vfio_pci_device {
>  	struct vfio_pci_core_device vfio_coredev;
> +	struct pdsc *pdsc;
>  
>  	int vf_id;
> +	u16 client_id;
>  };
>  
>  const struct vfio_device_ops *pds_vfio_ops_info(void);
>  struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
>  
> +struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
> +
>  #endif /* _VFIO_DEV_H_ */
> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
> index 435c8e8161c2..1295ff2518a6 100644
> --- a/include/linux/pds/pds_common.h
> +++ b/include/linux/pds/pds_common.h
> @@ -34,12 +34,13 @@ enum pds_core_vif_types {
>  
>  #define PDS_DEV_TYPE_CORE_STR	"Core"
>  #define PDS_DEV_TYPE_VDPA_STR	"vDPA"
> -#define PDS_DEV_TYPE_VFIO_STR	"VFio"
> +#define PDS_DEV_TYPE_VFIO_STR	"vfio"
>  #define PDS_DEV_TYPE_ETH_STR	"Eth"
>  #define PDS_DEV_TYPE_RDMA_STR	"RDMA"
>  #define PDS_DEV_TYPE_LM_STR	"LM"
>  
>  #define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
> +#define PDS_VFIO_LM_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR "." PDS_DEV_TYPE_VFIO_STR
>  
>  int pdsc_register_notify(struct notifier_block *nb);
>  void pdsc_unregister_notify(struct notifier_block *nb);

