Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158B828191F
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJBRYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:24:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgJBRYs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 13:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601659486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wyu/6NebhFiG1x2CbhG734h8rPbGSszDRSh0XvBsFik=;
        b=MUDIjAzUL37TdRVzLTrfnuTWtIajiEnONgt4Zd+VrsuvveJxisvkGJFd3oFZbRCn8HsiSo
        aMQWYVVKb+NRyUXlvuh5Sfl/PElWW+jwJLa/ls8VblzZkCmHP2W6L5sK6/8bi5S4e/gn6v
        kswj2pdI2ow970gzeEsiSTA1o5UVr78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-_NWWWqabOnGv48SMm1Q4Nw-1; Fri, 02 Oct 2020 13:24:43 -0400
X-MC-Unique: _NWWWqabOnGv48SMm1Q4Nw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A62D801ABD;
        Fri,  2 Oct 2020 17:24:42 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E9EA60CD1;
        Fri,  2 Oct 2020 17:24:38 +0000 (UTC)
Date:   Fri, 2 Oct 2020 11:24:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, bharatb.linux@gmail.com,
        linux-kernel@vger.kernel.org, eric.auger@redhat.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: Re: [PATCH v5 02/10] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc
 driver bind
Message-ID: <20201002112437.0b15a986@x1.home>
In-Reply-To: <20200929090339.17659-3-diana.craciun@oss.nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
        <20200929090339.17659-3-diana.craciun@oss.nxp.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 12:03:31 +0300
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> The DPRC (Data Path Resource Container) device is a bus device and has
> child devices attached to it. When the vfio-fsl-mc driver is probed
> the DPRC is scanned and the child devices discovered and initialized.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 90 +++++++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
>  2 files changed, 91 insertions(+)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index a7a483a1e90b..ba44d6d01cc9 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -15,6 +15,8 @@
>  
>  #include "vfio_fsl_mc_private.h"
>  
> +static struct fsl_mc_driver vfio_fsl_mc_driver;
> +
>  static int vfio_fsl_mc_open(void *device_data)
>  {
>  	if (!try_module_get(THIS_MODULE))
> @@ -84,6 +86,79 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
>  	.mmap		= vfio_fsl_mc_mmap,
>  };
>  
> +static int vfio_fsl_mc_bus_notifier(struct notifier_block *nb,
> +				    unsigned long action, void *data)
> +{
> +	struct vfio_fsl_mc_device *vdev = container_of(nb,
> +					struct vfio_fsl_mc_device, nb);
> +	struct device *dev = data;
> +	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
> +	struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
> +
> +	if (action == BUS_NOTIFY_ADD_DEVICE &&
> +	    vdev->mc_dev == mc_cont) {
> +		mc_dev->driver_override = kasprintf(GFP_KERNEL, "%s",
> +						    vfio_fsl_mc_ops.name);
> +		if (!mc_dev->driver_override)
> +			dev_warn(dev, "VFIO_FSL_MC: Setting driver override for device in dprc %s failed\n",
> +			     dev_name(&mc_cont->dev));
> +		else
> +			dev_info(dev, "VFIO_FSL_MC: Setting driver override for device in dprc %s\n",
> +			 dev_name(&mc_cont->dev));

Nit, some whitespace inconsistencies on the second line of each of
these.  I can fixup on commit if we don't find anything else worth a
respin.

> +	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
> +		vdev->mc_dev == mc_cont) {
> +		struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
> +
> +		if (mc_drv && mc_drv != &vfio_fsl_mc_driver)
> +			dev_warn(dev, "VFIO_FSL_MC: Object %s bound to driver %s while DPRC bound to vfio-fsl-mc\n",
> +				 dev_name(dev), mc_drv->driver.name);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int ret;
> +
> +	/* Non-dprc devices share mc_io from parent */
> +	if (!is_fsl_mc_bus_dprc(mc_dev)) {
> +		struct fsl_mc_device *mc_cont = to_fsl_mc_device(mc_dev->dev.parent);
> +
> +		mc_dev->mc_io = mc_cont->mc_io;
> +		return 0;
> +	}
> +
> +	vdev->nb.notifier_call = vfio_fsl_mc_bus_notifier;
> +	ret = bus_register_notifier(&fsl_mc_bus_type, &vdev->nb);
> +	if (ret)
> +		return ret;
> +
> +	/* open DPRC, allocate a MC portal */
> +	ret = dprc_setup(mc_dev);
> +	if (ret) {
> +		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Failed to setup DPRC (%d)\n", ret);
> +		goto out_nc_unreg;
> +	}
> +
> +	ret = dprc_scan_container(mc_dev, false);
> +	if (ret) {
> +		dev_err(&mc_dev->dev, "VFIO_FSL_MC: Container scanning failed (%d)\n", ret);
> +		goto out_dprc_cleanup;
> +	}

If I understand this correctly, we've setup the bus notifier to write
the driver override as each sub-devices appear on the bus from this
scan.  When non-dprc devices are removed below, it appears we remove all
their sub-devices.  Is there a chance here that an error from the scan
leaves residual sub-devices, ie. should we proceed the below
dprc_cleanup() with a call to dprc_remove_devices() to be certain none
remain?  Thanks,

Alex


> +
> +	return 0;
> +
> +out_dprc_cleanup:
> +	dprc_cleanup(mc_dev);
> +out_nc_unreg:
> +	bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +	vdev->nb.notifier_call = NULL;
> +
> +	return ret;
> +}
> +
>  static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  {
>  	struct iommu_group *group;
> @@ -110,8 +185,15 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
>  		goto out_group_put;
>  	}
> +
> +	ret = vfio_fsl_mc_init_device(vdev);
> +	if (ret)
> +		goto out_group_dev;
> +
>  	return 0;
>  
> +out_group_dev:
> +	vfio_del_group_dev(dev);
>  out_group_put:
>  	vfio_iommu_group_put(group, dev);
>  	return ret;
> @@ -126,6 +208,14 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  	if (!vdev)
>  		return -EINVAL;
>  
> +	if (is_fsl_mc_bus_dprc(mc_dev)) {
> +		dprc_remove_devices(mc_dev, NULL, 0);
> +		dprc_cleanup(mc_dev);
> +	}
> +
> +	if (vdev->nb.notifier_call)
> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +
>  	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>  
>  	return 0;
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index e79cc116f6b8..37d61eaa58c8 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -9,6 +9,7 @@
>  
>  struct vfio_fsl_mc_device {
>  	struct fsl_mc_device		*mc_dev;
> +	struct notifier_block        nb;
>  };
>  
>  #endif /* VFIO_FSL_MC_PRIVATE_H */

