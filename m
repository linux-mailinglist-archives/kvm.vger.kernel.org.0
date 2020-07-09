Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873FD21AAFA
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 00:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgGIWxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 18:53:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54200 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726773AbgGIWxc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 18:53:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594335210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i1INxgto+D5Y2oZMGBhvrqyvzD6Mkg+QqFtK0D1z/D4=;
        b=Q9WMiXJDMA6xVyA+N394yjoJ5sQpVWcFdOg1EaUd1UTTwJ7U7rv8cHakt4LmhYykiBSbcf
        UF+x/GcCT9EbgRsVPelkeSNeBj3vNvWE7DNI1n9yEEzHGHkZY4c+6zpbnMH2quw/Bd9UN8
        +UuhtPNbf6/R8x4L+pMn2D8y6c+Swiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-AvYNFt9gNSCCJe_xKIP91A-1; Thu, 09 Jul 2020 18:53:28 -0400
X-MC-Unique: AvYNFt9gNSCCJe_xKIP91A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FE00192FDA0;
        Thu,  9 Jul 2020 22:53:27 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4B4D60BE2;
        Thu,  9 Jul 2020 22:53:26 +0000 (UTC)
Date:   Thu, 9 Jul 2020 16:53:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, bharatb.linux@gmail.com,
        linux-kernel@vger.kernel.org, laurentiu.tudor@nxp.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: Re: [PATCH v3 4/9] vfio/fsl-mc: Implement
 VFIO_DEVICE_GET_REGION_INFO ioctl call
Message-ID: <20200709165326.72d43d0c@x1.home>
In-Reply-To: <20200706154153.11477-5-diana.craciun@oss.nxp.com>
References: <20200706154153.11477-1-diana.craciun@oss.nxp.com>
        <20200706154153.11477-5-diana.craciun@oss.nxp.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  6 Jul 2020 18:41:48 +0300
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> Expose to userspace information about the memory regions.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 77 ++++++++++++++++++++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h | 19 ++++++
>  2 files changed, 95 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 937b6eddc71a..10bd9f78b8de 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -17,16 +17,72 @@
>  
>  static struct fsl_mc_driver vfio_fsl_mc_driver;
>  
> +static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int count = mc_dev->obj_desc.region_count;
> +	int i;
> +
> +	vdev->regions = kcalloc(count, sizeof(struct vfio_fsl_mc_region),
> +				GFP_KERNEL);
> +	if (!vdev->regions)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < count; i++) {
> +		struct resource *res = &mc_dev->regions[i];
> +
> +		vdev->regions[i].addr = res->start;
> +		vdev->regions[i].size = resource_size(res);
> +		vdev->regions[i].flags = 0;
> +	}
> +
> +	vdev->num_regions = mc_dev->obj_desc.region_count;
> +	return 0;
> +}
> +
> +static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
> +{
> +	vdev->num_regions = 0;
> +	kfree(vdev->regions);
> +}
> +
>  static int vfio_fsl_mc_open(void *device_data)
>  {
> +	struct vfio_fsl_mc_device *vdev = device_data;
> +	int ret;
> +
>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>  
> +	mutex_lock(&vdev->driver_lock);
> +	if (!vdev->refcnt) {
> +		ret = vfio_fsl_mc_regions_init(vdev);
> +		if (ret)
> +			goto err_reg_init;
> +	}
> +	vdev->refcnt++;
> +
> +	mutex_unlock(&vdev->driver_lock);
> +
>  	return 0;
> +
> +err_reg_init:
> +	mutex_unlock(&vdev->driver_lock);
> +	module_put(THIS_MODULE);
> +	return ret;
>  }
>  
>  static void vfio_fsl_mc_release(void *device_data)
>  {
> +	struct vfio_fsl_mc_device *vdev = device_data;
> +
> +	mutex_lock(&vdev->driver_lock);
> +
> +	if (!(--vdev->refcnt))
> +		vfio_fsl_mc_regions_cleanup(vdev);
> +
> +	mutex_unlock(&vdev->driver_lock);
> +
>  	module_put(THIS_MODULE);
>  }
>  
> @@ -59,7 +115,25 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  	}
>  	case VFIO_DEVICE_GET_REGION_INFO:
>  	{
> -		return -ENOTTY;
> +		struct vfio_region_info info;
> +
> +		minsz = offsetofend(struct vfio_region_info, offset);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index >= vdev->num_regions)
> +			return -EINVAL;
> +
> +		/* map offset to the physical address  */
> +		info.offset = VFIO_FSL_MC_INDEX_TO_OFFSET(info.index);
> +		info.size = vdev->regions[info.index].size;
> +		info.flags = vdev->regions[info.index].flags;
> +
> +		return copy_to_user((void __user *)arg, &info, minsz);
>  	}
>  	case VFIO_DEVICE_GET_IRQ_INFO:
>  	{
> @@ -201,6 +275,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  		vfio_iommu_group_put(group, dev);
>  		return ret;
>  	}
> +	mutex_init(&vdev->driver_lock);


Consider all calling mutex_destory() in the remove callback, it's only
used for lock debugging, so we're only partially successful in calling
it.  Thanks,

Alex

>  
>  	return ret;
>  }
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index 37d61eaa58c8..818dfd3df4db 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -7,9 +7,28 @@
>  #ifndef VFIO_FSL_MC_PRIVATE_H
>  #define VFIO_FSL_MC_PRIVATE_H
>  
> +#define VFIO_FSL_MC_OFFSET_SHIFT    40
> +#define VFIO_FSL_MC_OFFSET_MASK (((u64)(1) << VFIO_FSL_MC_OFFSET_SHIFT) - 1)
> +
> +#define VFIO_FSL_MC_OFFSET_TO_INDEX(off) ((off) >> VFIO_FSL_MC_OFFSET_SHIFT)
> +
> +#define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
> +	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
> +
> +struct vfio_fsl_mc_region {
> +	u32			flags;
> +	u32			type;
> +	u64			addr;
> +	resource_size_t		size;
> +};
> +
>  struct vfio_fsl_mc_device {
>  	struct fsl_mc_device		*mc_dev;
>  	struct notifier_block        nb;
> +	int				refcnt;
> +	u32				num_regions;
> +	struct vfio_fsl_mc_region	*regions;
> +	struct mutex driver_lock;
>  };
>  
>  #endif /* VFIO_FSL_MC_PRIVATE_H */

