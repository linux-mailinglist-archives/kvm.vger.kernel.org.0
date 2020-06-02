Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD651EB420
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 06:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgFBEM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 00:12:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52010 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbgFBEM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 00:12:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591071145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ayiLISqhpukWIeWMrDjPyoahGbwH5C6Y31y3ZuKK5gg=;
        b=TAeN4sD/QAYXMwNsFyEQpRqcL+NReC5VNtcao7d6IOI541QSNWSBK6ZCTSO7Vyfik9Z2Hs
        K6H8jEj20P+DP8m9njWypBHqQGvCmMyhbgeMKvRRsMy0Lq3zbEg7dpOyZSdsB/3TpY5DjA
        8Qoj4mvisXW2MgQlriqTjEA5MrIvn5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-ZTaONuorN-e4dtOkbW-DXg-1; Tue, 02 Jun 2020 00:12:21 -0400
X-MC-Unique: ZTaONuorN-e4dtOkbW-DXg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A41F7461;
        Tue,  2 Jun 2020 04:12:19 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 382F7D021C;
        Tue,  2 Jun 2020 04:12:19 +0000 (UTC)
Date:   Mon, 1 Jun 2020 22:12:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com, bharatb.linux@gmail.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: Re: [PATCH v2 2/9] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc
 driver bind
Message-ID: <20200601221218.5527d3b7@x1.home>
In-Reply-To: <20200508072039.18146-3-diana.craciun@oss.nxp.com>
References: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
        <20200508072039.18146-3-diana.craciun@oss.nxp.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  8 May 2020 10:20:32 +0300
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> The DPRC (Data Path Resource Container) device is a bus device and has
> child devices attached to it. When the vfio-fsl-mc driver is probed
> the DPRC is scanned and the child devices discovered and initialized.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 106 ++++++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |   1 +
>  2 files changed, 107 insertions(+)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 8b53c2a25b32..ea301ba81225 100644
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
> @@ -84,6 +86,69 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
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
> +		dev_info(dev, "Setting driver override for device in dprc %s\n",
> +			 dev_name(&mc_cont->dev));
> +	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
> +		vdev->mc_dev == mc_cont) {
> +		struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
> +
> +		if (mc_drv && mc_drv != &vfio_fsl_mc_driver)
> +			dev_warn(dev, "Object %s bound to driver %s while DPRC bound to vfio-fsl-mc\n",
> +				 dev_name(dev), mc_drv->driver.name);
> +		}
> +
> +	return 0;
> +}
> +
> +static int vfio_fsl_mc_init_device(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int ret = 0;
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
> +	if (ret < 0) {
> +		dev_err(&mc_dev->dev, "Failed to setup DPRC (error = %d)\n", ret);
> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +		return ret;
> +	}
> +
> +	ret = dprc_scan_container(mc_dev, false);
> +	if (ret < 0) {
> +		dev_err(&mc_dev->dev, "Container scanning failed: %d\n", ret);
> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +		dprc_cleanup(mc_dev);
> +	}
> +
> +	return 0;


The last error branch falls through, did you intend to return 'ret'
here to capture that?  Also, nit, ret doesn't need to be initialized.


> +}
> +
>  static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  {
>  	struct iommu_group *group;
> @@ -112,9 +177,42 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  		return ret;
>  	}
>  
> +	ret = vfio_fsl_mc_init_device(vdev);
> +	if (ret) {
> +		vfio_iommu_group_put(group, dev);
> +		return ret;
> +	}


The error condition value is a bit inconsistent between
vfio_fs_mc_init_device() and here, <0 vs !0.  Thanks,

Alex


> +
>  	return ret;
>  }
>  
> +static int vfio_fsl_mc_device_remove(struct device *dev, void *data)
> +{
> +	struct fsl_mc_device *mc_dev;
> +
> +	WARN_ON(!dev);
> +	mc_dev = to_fsl_mc_device(dev);
> +	if (WARN_ON(!mc_dev))
> +		return -ENODEV;
> +
> +	kfree(mc_dev->driver_override);
> +	mc_dev->driver_override = NULL;
> +
> +	/*
> +	 * The device-specific remove callback will get invoked by device_del()
> +	 */
> +	device_del(&mc_dev->dev);
> +	put_device(&mc_dev->dev);
> +
> +	return 0;
> +}
> +
> +static void vfio_fsl_mc_cleanup_dprc(struct fsl_mc_device *mc_dev)
> +{
> +	device_for_each_child(&mc_dev->dev, NULL, vfio_fsl_mc_device_remove);
> +	dprc_cleanup(mc_dev);
> +}
> +
>  static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  {
>  	struct vfio_fsl_mc_device *vdev;
> @@ -124,6 +222,14 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  	if (!vdev)
>  		return -EINVAL;
>  
> +	if (vdev->nb.notifier_call)
> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +
> +	if (is_fsl_mc_bus_dprc(mc_dev))
> +		vfio_fsl_mc_cleanup_dprc(vdev->mc_dev);
> +
> +	mc_dev->mc_io = NULL;
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

