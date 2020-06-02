Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23DF1EB422
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 06:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgFBEMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 00:12:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37968 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726012AbgFBEMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 00:12:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591071157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcqaBV1INa4ipTslqPIM6KcQKZk3Yq+AQXLd9x9rQbw=;
        b=IYwDxpQLcm6Yt/JstaEivK+6p0jK0g9TZqlIPhASyJX/VxGKDMArzt+om+EloJuiwjn4fL
        zNLUibGvECIfGOppgX7NWMlVm0l67L8KrDK5bNZtHT3dzfkGcSjvRYvCJRFODadlSIwcwV
        KyF6UaffK8YkJSQhstLK4I/7xsmDqwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-69crdeqAO1O-lODoon5jxg-1; Tue, 02 Jun 2020 00:12:33 -0400
X-MC-Unique: 69crdeqAO1O-lODoon5jxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E36F6107ACCA;
        Tue,  2 Jun 2020 04:12:31 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B6485C1D0;
        Tue,  2 Jun 2020 04:12:31 +0000 (UTC)
Date:   Mon, 1 Jun 2020 22:12:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurentiu.tudor@nxp.com, bharatb.linux@gmail.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: Re: [PATCH v2 4/9] vfio/fsl-mc: Implement
 VFIO_DEVICE_GET_REGION_INFO ioctl call
Message-ID: <20200601221231.7527f50b@x1.home>
In-Reply-To: <20200508072039.18146-5-diana.craciun@oss.nxp.com>
References: <20200508072039.18146-1-diana.craciun@oss.nxp.com>
        <20200508072039.18146-5-diana.craciun@oss.nxp.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  8 May 2020 10:20:34 +0300
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
> index 8a4d3203b176..c162fa27c02c 100644
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
> +		vdev->regions[i].size = PAGE_ALIGN((resource_size(res)));


Why do we need this page alignment to resource_size()?  It makes me
worry that we're actually giving the user access to an extended size
that might overlap another device or to MMIO that's not backed by any
device and might trigger a fault when accessed.  In vfio-pci we make
some effort to reserve resources when we want to allow mmap of sub-page
ranges.  Thanks,

Alex


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

