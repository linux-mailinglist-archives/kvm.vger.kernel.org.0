Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1325CA0C
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 22:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgICUPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 16:15:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729173AbgICUPm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 16:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599164139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VqFui9oj1cM5DRlG5bU+EfxWGLYe7oYtwPI4hKaTr4c=;
        b=akAJRBG5aPBvBB2C81jfK3XkZHI/s8oicvxmTot54LiHoODSXQmOwfIGSVOLmp82i0ESK2
        IyrW/oHf2xIeoj5Z0eJzFF6XVLLB5Kp4IxXofCE7aJUY7HjyiLpt7Kch7ZG8N2FX0IAZ0L
        mEM2dkD5oraVnrzq04ooZJ+GI4l3V+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-ZU22fIEkNEGmc00k0RIb2A-1; Thu, 03 Sep 2020 16:15:37 -0400
X-MC-Unique: ZU22fIEkNEGmc00k0RIb2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DA3D801AEA;
        Thu,  3 Sep 2020 20:15:36 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05EC8702ED;
        Thu,  3 Sep 2020 20:15:31 +0000 (UTC)
Subject: Re: [PATCH v4 07/10] vfio/fsl-mc: Add irq infrastructure for fsl-mc
 devices
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-8-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9dacbfc8-32a6-54c9-ce0c-50538ee588bf@redhat.com>
Date:   Thu, 3 Sep 2020 22:15:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-8-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 8/26/20 11:33 AM, Diana Craciun wrote:
> This patch adds the skeleton for interrupt support
> for fsl-mc devices. The interrupts are not yet functional,
> the functionality will be added by subsequent patches.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/Makefile              |  2 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 75 ++++++++++++++++++++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 63 +++++++++++++++++++
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  7 ++-
>  4 files changed, 143 insertions(+), 4 deletions(-)
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
> index bbd3365e877e..42014297b484 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -209,11 +209,79 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
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
shouldn't it be MASKABLE as well? I see skeletons for MASK.
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
> +
> +		minsz = offsetofend(struct vfio_irq_set, count);
> +
> +		if (copy_from_user(&hdr, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (hdr.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (hdr.index >= mc_dev->obj_desc.irq_count)
> +			return -EINVAL;
> +
> +		if (hdr.start != 0 || hdr.count > 1)
> +			return -EINVAL;
> +
> +		if (hdr.count == 0 &&
> +		    (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE) ||
> +		    !(hdr.flags & VFIO_IRQ_SET_ACTION_TRIGGER)))
> +			return -EINVAL;
> +
> +		if (hdr.flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
> +				  VFIO_IRQ_SET_ACTION_TYPE_MASK))
> +			return -EINVAL;
> +
> +		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
> +			size_t size;
> +
> +			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
> +				size = sizeof(uint8_t);
> +			else if (hdr.flags & VFIO_IRQ_SET_DATA_EVENTFD)
> +				size = sizeof(int32_t);
> +			else
> +				return -EINVAL;
> +
> +			if (hdr.argsz - minsz < hdr.count * size)
> +				return -EINVAL;
> +
> +			data = memdup_user((void __user *)(arg + minsz),
> +					   hdr.count * size);
> +			if (IS_ERR(data))
> +				return PTR_ERR(data);
> +		}
can't you reuse vfio_set_irqs_validate_and_prepare()?
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
> @@ -413,6 +481,8 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  		return ret;
>  	}
>  
> +	mutex_init(&vdev->igate);
> +
>  	return ret;
>  }
>  
> @@ -436,6 +506,7 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  	mc_dev->mc_io = NULL;
>  
>  	vfio_fsl_mc_reflck_put(vdev->reflck);
> +	mutex_destroy(&vdev->igate);
>  
>  	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>  
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> new file mode 100644
> index 000000000000..058aa97aa54a
> --- /dev/null
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> @@ -0,0 +1,63 @@
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
> +static int vfio_fsl_mc_irq_mask(struct vfio_fsl_mc_device *vdev,
> +				unsigned int index, unsigned int start,
> +				unsigned int count, u32 flags,
> +				void *data)
> +{
> +	return -EINVAL;
> +}
> +
> +static int vfio_fsl_mc_irq_unmask(struct vfio_fsl_mc_device *vdev,
> +				unsigned int index, unsigned int start,
> +				unsigned int count, u32 flags,
> +				void *data)
> +{
> +	return -EINVAL;
> +}
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
> +	int ret = -ENOTTY;
> +
> +	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +	case VFIO_IRQ_SET_ACTION_MASK:
> +		ret = vfio_fsl_mc_irq_mask(vdev, index, start, count,
> +					   flags, data);
> +		break;
> +	case VFIO_IRQ_SET_ACTION_UNMASK:
> +		ret = vfio_fsl_mc_irq_unmask(vdev, index, start, count,
> +					     flags, data);
> +		break;
> +	case VFIO_IRQ_SET_ACTION_TRIGGER:
> +		ret = vfio_fsl_mc_set_irq_trigger(vdev, index, start,
> +						  count, flags, data);
> +		break;
> +	}
> +
> +	return ret;
> +}
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index 3b85d930e060..d5b6fe891a48 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -34,7 +34,12 @@ struct vfio_fsl_mc_device {
>  	u32				num_regions;
>  	struct vfio_fsl_mc_region	*regions;
>  	struct vfio_fsl_mc_reflck   *reflck;
> -
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
Thanks

Eric

