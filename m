Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FCD34070A
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhCRNkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:40:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26401 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229960AbhCRNkl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616074840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMkyzKTe9tka5T6LnvOSZ3KS8hyP7oKwlgQOiztQmPQ=;
        b=LxqWsifWn6PPh0uWjmvyWeUmWvLOoTrTRUKtxjnAusp3cRX3xdG/P3TOull5PEtS+OrDEW
        zs9iio+w/EdHvG3CurCCoAfzJu+DGN/+ABt6XeaHgObVHOadLWid6Ozhh4RrEAFdRCsyDp
        XG9kh3wtGFc4/TcQrNfD87EpJ52/9UU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-dhUGY4bFNsKz_SHckZtt1A-1; Thu, 18 Mar 2021 09:40:36 -0400
X-MC-Unique: dhUGY4bFNsKz_SHckZtt1A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6018A1922021;
        Thu, 18 Mar 2021 13:40:35 +0000 (UTC)
Received: from [10.36.112.6] (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD79960C13;
        Thu, 18 Mar 2021 13:40:26 +0000 (UTC)
Subject: Re: [PATCH v2 04/14] vfio/platform: Use
 vfio_init/register/unregister_group_dev
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <503cb05f-3064-ffc6-4159-b96dfbb8880b@redhat.com>
Date:   Thu, 18 Mar 2021 14:40:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <4-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/13/21 1:55 AM, Jason Gunthorpe wrote:
> platform already allocates a struct vfio_platform_device with exactly
> the same lifetime as vfio_device, switch to the new API and embed
> vfio_device in vfio_platform_device.

Without "kfree(vdev->name);" pointed out by Alex,

Acked-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>


Thanks

Eric

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/platform/vfio_amba.c             |  8 ++++---
>  drivers/vfio/platform/vfio_platform.c         | 21 ++++++++---------
>  drivers/vfio/platform/vfio_platform_common.c  | 23 +++++++------------
>  drivers/vfio/platform/vfio_platform_private.h |  5 ++--
>  4 files changed, 26 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index 3626c21501017e..f970eb2a999f29 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -66,16 +66,18 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>  	if (ret) {
>  		kfree(vdev->name);
>  		kfree(vdev);
> +		return ret;
>  	}
>  
> -	return ret;
> +	dev_set_drvdata(&adev->dev, vdev);
> +	return 0;
>  }
>  
>  static void vfio_amba_remove(struct amba_device *adev)
>  {
> -	struct vfio_platform_device *vdev =
> -		vfio_platform_remove_common(&adev->dev);
> +	struct vfio_platform_device *vdev = dev_get_drvdata(&adev->dev);
>  
> +	vfio_platform_remove_common(vdev);
>  	kfree(vdev->name);
>  	kfree(vdev);
>  }
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 9fb6818cea12cb..f7b3f64ecc7f6c 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -54,23 +54,22 @@ static int vfio_platform_probe(struct platform_device *pdev)
>  	vdev->reset_required = reset_required;
>  
>  	ret = vfio_platform_probe_common(vdev, &pdev->dev);
> -	if (ret)
> +	if (ret) {
>  		kfree(vdev);
> -
> -	return ret;
> +		return ret;
> +	}
> +	dev_set_drvdata(&pdev->dev, vdev);
> +	return 0;
>  }
>  
>  static int vfio_platform_remove(struct platform_device *pdev)
>  {
> -	struct vfio_platform_device *vdev;
> -
> -	vdev = vfio_platform_remove_common(&pdev->dev);
> -	if (vdev) {
> -		kfree(vdev);
> -		return 0;
> -	}
> +	struct vfio_platform_device *vdev = dev_get_drvdata(&pdev->dev);
>  
> -	return -EINVAL;
> +	vfio_platform_remove_common(vdev);
> +	kfree(vdev->name);
> +	kfree(vdev);
> +	return 0;
>  }
>  
>  static struct platform_driver vfio_platform_driver = {
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index fb4b385191f288..6eb749250ee41c 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -659,8 +659,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>  	struct iommu_group *group;
>  	int ret;
>  
> -	if (!vdev)
> -		return -EINVAL;
> +	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops, vdev);
>  
>  	ret = vfio_platform_acpi_probe(vdev, dev);
>  	if (ret)
> @@ -685,13 +684,13 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>  		goto put_reset;
>  	}
>  
> -	ret = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
> +	ret = vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
>  		goto put_iommu;
>  
>  	mutex_init(&vdev->igate);
>  
> -	pm_runtime_enable(vdev->device);
> +	pm_runtime_enable(dev);
>  	return 0;
>  
>  put_iommu:
> @@ -702,19 +701,13 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
>  
> -struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
> +void vfio_platform_remove_common(struct vfio_platform_device *vdev)
>  {
> -	struct vfio_platform_device *vdev;
> -
> -	vdev = vfio_del_group_dev(dev);
> +	vfio_unregister_group_dev(&vdev->vdev);
>  
> -	if (vdev) {
> -		pm_runtime_disable(vdev->device);
> -		vfio_platform_put_reset(vdev);
> -		vfio_iommu_group_put(dev->iommu_group, dev);
> -	}
> -
> -	return vdev;
> +	pm_runtime_disable(vdev->device);
> +	vfio_platform_put_reset(vdev);
> +	vfio_iommu_group_put(vdev->vdev.dev->iommu_group, vdev->vdev.dev);
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
>  
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 289089910643ac..a5ba82c8cbc354 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -9,6 +9,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/interrupt.h>
> +#include <linux/vfio.h>
>  
>  #define VFIO_PLATFORM_OFFSET_SHIFT   40
>  #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
> @@ -42,6 +43,7 @@ struct vfio_platform_region {
>  };
>  
>  struct vfio_platform_device {
> +	struct vfio_device		vdev;
>  	struct vfio_platform_region	*regions;
>  	u32				num_regions;
>  	struct vfio_platform_irq	*irqs;
> @@ -80,8 +82,7 @@ struct vfio_platform_reset_node {
>  
>  extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>  				      struct device *dev);
> -extern struct vfio_platform_device *vfio_platform_remove_common
> -				     (struct device *dev);
> +void vfio_platform_remove_common(struct vfio_platform_device *vdev);
>  
>  extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
>  extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
> 

