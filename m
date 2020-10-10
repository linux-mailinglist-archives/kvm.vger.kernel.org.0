Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF6428A196
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgJJVpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:45:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731334AbgJJTLE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Oct 2020 15:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602357061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g0YHzF3N7UlRQvHceEw2x+p6W2gVOK6jWalKblol9xk=;
        b=CaMrZbVM7f50rS1JAnulb+OvYnPZaAuQxvB9PPooTePtEDT9VsqfppP0+ebKsCra5sgE2q
        s+NBnKy0Hk6fLY0tg0T9sAySQsIq930FsipFuNeFvRJ/rJIn+fYuE/fS6tr9WSM//90K+Y
        fEb+xQEWz3xwe8rBCzVpFWTxcV94IRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-CXtd83SmMSuUkfuMO24xDA-1; Sat, 10 Oct 2020 13:42:13 -0400
X-MC-Unique: CXtd83SmMSuUkfuMO24xDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 473BF8015A5;
        Sat, 10 Oct 2020 17:42:12 +0000 (UTC)
Received: from [10.36.113.210] (ovpn-113-210.ams2.redhat.com [10.36.113.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9009E6EF58;
        Sat, 10 Oct 2020 17:42:07 +0000 (UTC)
Subject: Re: [PATCH v6 07/10] vfio/fsl-mc: Add irq infrastructure for fsl-mc
 devices
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
 <20201005173654.31773-8-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <264ecdb6-6cc7-16d7-b398-ad27adb189a6@redhat.com>
Date:   Sat, 10 Oct 2020 19:42:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201005173654.31773-8-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 10/5/20 7:36 PM, Diana Craciun wrote:
> This patch adds the skeleton for interrupt support
> for fsl-mc devices. The interrupts are not yet functional,
> the functionality will be added by subsequent patches.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/fsl-mc/Makefile              |  2 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 52 ++++++++++++++++++++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 34 +++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  6 +++
>  4 files changed, 91 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> 
> diff --git a/drivers/vfio/fsl-mc/Makefile b/drivers/vfio/fsl-mc/Makefile
> index 0c6e5d2ddaae..cad6dbf0b735 100644
> --- a/drivers/vfio/fsl-mc/Makefile
> +++ b/drivers/vfio/fsl-mc/Makefile
> @@ -1,4 +1,4 @@
>  # SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
>  
> -vfio-fsl-mc-y := vfio_fsl_mc.o
> +vfio-fsl-mc-y := vfio_fsl_mc.o vfio_fsl_mc_intr.o
>  obj-$(CONFIG_VFIO_FSL_MC) += vfio-fsl-mc.o
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index b52407c4e1ea..7803a9d6bfd9 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -217,11 +217,55 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  	}
>  	case VFIO_DEVICE_GET_IRQ_INFO:
>  	{
> -		return -ENOTTY;
> +		struct vfio_irq_info info;
> +
> +		minsz = offsetofend(struct vfio_irq_info, count);
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index >= mc_dev->obj_desc.irq_count)
> +			return -EINVAL;
> +
> +		info.flags = VFIO_IRQ_INFO_EVENTFD;
> +		info.count = 1;
> +
> +		return copy_to_user((void __user *)arg, &info, minsz);
>  	}
>  	case VFIO_DEVICE_SET_IRQS:
>  	{
> -		return -ENOTTY;
> +		struct vfio_irq_set hdr;
> +		u8 *data = NULL;
> +		int ret = 0;
> +		size_t data_size = 0;
> +
> +		minsz = offsetofend(struct vfio_irq_set, count);
> +
> +		if (copy_from_user(&hdr, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		ret = vfio_set_irqs_validate_and_prepare(&hdr, mc_dev->obj_desc.irq_count,
> +					mc_dev->obj_desc.irq_count, &data_size);
> +		if (ret)
> +			return ret;
> +
> +		if (data_size) {
> +			data = memdup_user((void __user *)(arg + minsz),
> +				   data_size);
> +			if (IS_ERR(data))
> +				return PTR_ERR(data);
> +		}
> +
> +		mutex_lock(&vdev->igate);
> +		ret = vfio_fsl_mc_set_irqs_ioctl(vdev, hdr.flags,
> +						 hdr.index, hdr.start,
> +						 hdr.count, data);
> +		mutex_unlock(&vdev->igate);
> +		kfree(data);
> +
> +		return ret;
>  	}
>  	case VFIO_DEVICE_RESET:
>  	{
> @@ -423,6 +467,8 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  	if (ret)
>  		goto out_reflck;
>  
> +	mutex_init(&vdev->igate);
> +
>  	return 0;
>  
>  out_reflck:
> @@ -443,6 +489,8 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  	if (!vdev)
>  		return -EINVAL;
>  
> +	mutex_destroy(&vdev->igate);
> +
>  	vfio_fsl_mc_reflck_put(vdev->reflck);
>  
>  	if (is_fsl_mc_bus_dprc(mc_dev)) {
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> new file mode 100644
> index 000000000000..5232f208e361
> --- /dev/null
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> @@ -0,0 +1,34 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/*
> + * Copyright 2013-2016 Freescale Semiconductor Inc.
> + * Copyright 2019 NXP
> + */
> +
> +#include <linux/vfio.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/eventfd.h>
> +#include <linux/msi.h>
> +
> +#include "linux/fsl/mc.h"
> +#include "vfio_fsl_mc_private.h"
> +
> +static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
> +				       unsigned int index, unsigned int start,
> +				       unsigned int count, u32 flags,
> +				       void *data)
> +{
> +	return -EINVAL;
> +}
> +
> +int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
> +			       u32 flags, unsigned int index,
> +			       unsigned int start, unsigned int count,
> +			       void *data)
> +{
> +	if (flags & VFIO_IRQ_SET_ACTION_TRIGGER)
> +		return  vfio_fsl_mc_set_irq_trigger(vdev, index, start,
> +			  count, flags, data);
> +	else
> +		return -EINVAL;
> +}
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index d47ef6215429..2c3f625a3240 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -33,6 +33,12 @@ struct vfio_fsl_mc_device {
>  	int				refcnt;
>  	struct vfio_fsl_mc_region	*regions;
>  	struct vfio_fsl_mc_reflck   *reflck;
> +	struct mutex         igate;
>  };
>  
> +extern int vfio_fsl_mc_set_irqs_ioctl(struct vfio_fsl_mc_device *vdev,
> +			       u32 flags, unsigned int index,
> +			       unsigned int start, unsigned int count,
> +			       void *data);
> +
>  #endif /* VFIO_FSL_MC_PRIVATE_H */
> 

