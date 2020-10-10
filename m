Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24C828A199
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgJJVtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:49:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732121AbgJJTkK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Oct 2020 15:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602358807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQFSaxFuk1HrOdnP/tIwPADQWpH5sGjCu3VVvGeltPY=;
        b=ifmiSnxSLP0sy6nvNPHB50YXS5s8ohcUJjHFJ/Qh3d/LEwoubIcPKvvzOcHbfdVGoKx1FK
        2eM1vi45/3Osx3MpLWrAhH9HIQSDcmZxSAJFqVH4//2hlZ90GvUfza77V/cwCE5qstSwEn
        h25Icgobgi/hIoetP+91a1Qj5823MhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-DRXA0H7PNziMs5S8cyBOqA-1; Sat, 10 Oct 2020 13:08:37 -0400
X-MC-Unique: DRXA0H7PNziMs5S8cyBOqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AC98805F09;
        Sat, 10 Oct 2020 17:08:36 +0000 (UTC)
Received: from [10.36.113.210] (ovpn-113-210.ams2.redhat.com [10.36.113.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB1535D9CA;
        Sat, 10 Oct 2020 17:08:31 +0000 (UTC)
Subject: Re: [PATCH v6 04/10] vfio/fsl-mc: Implement
 VFIO_DEVICE_GET_REGION_INFO ioctl call
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
 <20201005173654.31773-5-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9e657a87-c683-4e93-1ba2-fa8dd020c9b1@redhat.com>
Date:   Sat, 10 Oct 2020 19:08:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201005173654.31773-5-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 10/5/20 7:36 PM, Diana Craciun wrote:
> Expose to userspace information about the memory regions.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 79 ++++++++++++++++++++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h | 18 ++++++
>  2 files changed, 96 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 161c2cbe07dc..05dace5ddc2c 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -17,16 +17,71 @@
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
> +		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
> +	}
> +
> +	return 0;
> +}
> +
> +static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
> +{
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
> @@ -59,7 +114,25 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
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
> +		if (info.index >= mc_dev->obj_desc.region_count)
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
> @@ -210,6 +283,8 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  	if (ret)
>  		goto out_group_dev;
>  
> +	mutex_init(&vdev->driver_lock);
> +
>  	return 0;
>  
>  out_group_dev:
> @@ -228,6 +303,8 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  	if (!vdev)
>  		return -EINVAL;
>  
> +	mutex_destroy(&vdev->driver_lock);
> +
>  	if (is_fsl_mc_bus_dprc(mc_dev)) {
>  		dprc_remove_devices(mc_dev, NULL, 0);
>  		dprc_cleanup(mc_dev);
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index 37d61eaa58c8..be60f41af30f 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -7,9 +7,27 @@
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
> +	struct vfio_fsl_mc_region	*regions;
> +	struct mutex driver_lock;
>  };
>  
>  #endif /* VFIO_FSL_MC_PRIVATE_H */
> 

