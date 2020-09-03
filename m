Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B0925C3DD
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgICO75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 10:59:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41779 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729089AbgICOGe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 10:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599141992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=97hdsnnZ4GbWP8eed+eYgrQb2JFScZShE0F37/Qm1n0=;
        b=bxNDILwZTC4cnOuY1Ze6g8I3hKeI0VR9O0rCxOHEgJEsk+m49NVUiI5eNUc7hbc86P9B12
        9em7ol9Z8iNIP808r7dk30GJriqHtUEBjG4n43vY888RdTqMaP0quKEQDpZ4QqsxvV19/W
        3835I/RSurXO+PBB9pWvwvFwkzh5Qas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-qDHTOUNvNsWqyoX7gkfuTQ-1; Thu, 03 Sep 2020 10:06:29 -0400
X-MC-Unique: qDHTOUNvNsWqyoX7gkfuTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0C3A1007C88;
        Thu,  3 Sep 2020 14:06:26 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1947A78B20;
        Thu,  3 Sep 2020 14:06:24 +0000 (UTC)
Subject: Re: [PATCH v4 02/10] vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc
 driver bind
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-3-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <5eb09826-c5d9-7092-3a96-722ae57887a8@redhat.com>
Date:   Thu, 3 Sep 2020 16:06:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-3-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 8/26/20 11:33 AM, Diana Craciun wrote:
> The DPRC (Data Path Resource Container) device is a bus device and has
> child devices attached to it. When the vfio-fsl-mc driver is probed
> the DPRC is scanned and the child devices discovered and initialized.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 84 +++++++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
>  2 files changed, 85 insertions(+)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 8b53c2a25b32..85e007be3a5d 100644
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
> @@ -84,6 +86,72 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
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
> +			dev_warn(dev, "Setting driver override for device in dprc %s failed\n",
> +			     dev_name(&mc_cont->dev));
> +		dev_info(dev, "Setting driver override for device in dprc %s\n",
> +			 dev_name(&mc_cont->dev));
Don't you miss an else here?
> +	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
> +		vdev->mc_dev == mc_cont) {
> +		struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
> +
> +		if (mc_drv && mc_drv != &vfio_fsl_mc_driver)
> +			dev_warn(dev, "Object %s bound to driver %s while DPRC bound to vfio-fsl-mc\n",
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
> +	if (ret < 0) {
if (ret) here and in other places? or are there any > returned values
> +		dev_err(&mc_dev->dev, "Failed to setup DPRC (error = %d)\n", ret);
nit: maybe align your error messages. Before you were using __func__,
here you don't. Maybe don't? also you may consider using strerror(-ret)
> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +		return ret;
> +	}
> +
> +	ret = dprc_scan_container(mc_dev, false);
> +	if (ret < 0) {
> +		dev_err(&mc_dev->dev, "Container scanning failed: %d\n", ret);
> +		dprc_cleanup(mc_dev);
I see dprc_cleanup is likely to fail. Generally cleanup shouldn't.
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2283433.html
> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
nit: here also you can factorize code doing goto unregister;
shouldn't you reset vdev->nb.notifier_call to NULL as well. I see it is
tested in other places.
> +	}
> +
> +	return ret;
> +}
> +
>  static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  {
>  	struct iommu_group *group;
> @@ -112,6 +180,12 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  		return ret;
>  	}
>  
> +	ret = vfio_fsl_mc_init_device(vdev);
> +	if (ret < 0) {
I think you also need to call vfio_del_group_dev(&pdev->dev)
> +		vfio_iommu_group_put(group, dev);
> +		return ret;
nit: goto put_group;
> +	}
> +
>  	return ret;
>  }
>  
> @@ -124,6 +198,16 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  	if (!vdev)
>  		return -EINVAL;
>  
> +	if (vdev->nb.notifier_call)
> +		bus_unregister_notifier(&fsl_mc_bus_type, &vdev->nb);
> +
> +	if (is_fsl_mc_bus_dprc(mc_dev)) {
> +		dprc_remove_devices(mc_dev, NULL, 0);
> +		dprc_cleanup(mc_dev);
> +	}
you may consider doing the tear down in opposite order than
vfio_fsl_mc_init_device, ie. bus_unregister_notifier after the
dprc_cleanup? That's also what is done in vfio_fsl_mc_init_device error
path handling.
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
>  #endif /* VFIO_FSL_MC_PRIVATE_H */>
Thanks

Eric

