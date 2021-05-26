Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA846391E4C
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 19:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhEZRnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 13:43:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhEZRnq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 13:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622050934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ef+OapKGBjRUlGm+Utdh6dG0R6hk8VqyLqW0kegg6o=;
        b=WI3vdJmeDXWOkXwm6q3TO/Uoepg/cgupH8Nu38/gJPY/Fq9H4ukWM/lvWBVXykyhHNOD/P
        RCYJTNmPoZXsUDWemie3dbmdLZuMbYe3nNrwnO3S5ul4yr/dDapjAssa4lOLDBi+RfhdZh
        aaX1Wing+kBjOie/L6Ks0X3x8l3i1dk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-k55J4es1NNqQYk8YIrxEPQ-1; Wed, 26 May 2021 13:42:10 -0400
X-MC-Unique: k55J4es1NNqQYk8YIrxEPQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1390B802575;
        Wed, 26 May 2021 17:42:09 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F9E55C22A;
        Wed, 26 May 2021 17:42:07 +0000 (UTC)
Subject: Re: [PATCH 2/3] vfio: centralize module refcount in subsystem layer
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        cohuck@redhat.com, kvm@vger.kernel.org, alex.williamson@redhat.com
Cc:     oren@nvidia.com
References: <20210518192133.59195-1-mgurtovoy@nvidia.com>
 <20210518192133.59195-2-mgurtovoy@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1689191a-075b-d14f-9364-aef0f3f54f2a@redhat.com>
Date:   Wed, 26 May 2021 19:42:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210518192133.59195-2-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Max,

On 5/18/21 9:21 PM, Max Gurtovoy wrote:
> Remove code duplication and move module refcounting to the subsystem
> module.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 16 +++-------------
>  drivers/vfio/mdev/vfio_mdev.c                | 13 +------------
>  drivers/vfio/pci/vfio_pci.c                  |  7 -------
>  drivers/vfio/platform/vfio_platform_common.c |  6 ------
>  drivers/vfio/vfio.c                          | 10 ++++++++++
>  5 files changed, 14 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 980e59551301..90cad109583b 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -140,26 +140,18 @@ static int vfio_fsl_mc_open(struct vfio_device *core_vdev)
>  {
>  	struct vfio_fsl_mc_device *vdev =
>  		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
> -	int ret;
> -
> -	if (!try_module_get(THIS_MODULE))
> -		return -ENODEV;
> +	int ret = 0;
>  
>  	mutex_lock(&vdev->reflck->lock);
>  	if (!vdev->refcnt) {
>  		ret = vfio_fsl_mc_regions_init(vdev);
>  		if (ret)
> -			goto err_reg_init;
> +			goto out;
>  	}
>  	vdev->refcnt++;
> -
> +out:
>  	mutex_unlock(&vdev->reflck->lock);
>  
> -	return 0;
> -
> -err_reg_init:
> -	mutex_unlock(&vdev->reflck->lock);
> -	module_put(THIS_MODULE);
>  	return ret;
>  }
>  
> @@ -196,8 +188,6 @@ static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
>  	}
>  
>  	mutex_unlock(&vdev->reflck->lock);
> -
> -	module_put(THIS_MODULE);
>  }
>  
>  static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index 922729071c5a..5ef4815609ed 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -26,19 +26,10 @@ static int vfio_mdev_open(struct vfio_device *core_vdev)
>  	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
>  	struct mdev_parent *parent = mdev->type->parent;
>  
> -	int ret;
> -
>  	if (unlikely(!parent->ops->open))
>  		return -EINVAL;
>  
> -	if (!try_module_get(THIS_MODULE))
> -		return -ENODEV;
> -
> -	ret = parent->ops->open(mdev);
> -	if (ret)
> -		module_put(THIS_MODULE);
> -
> -	return ret;
> +	return parent->ops->open(mdev);
>  }
>  
>  static void vfio_mdev_release(struct vfio_device *core_vdev)
> @@ -48,8 +39,6 @@ static void vfio_mdev_release(struct vfio_device *core_vdev)
>  
>  	if (likely(parent->ops->release))
>  		parent->ops->release(mdev);
> -
> -	module_put(THIS_MODULE);
>  }
>  
>  static long vfio_mdev_unlocked_ioctl(struct vfio_device *core_vdev,
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index bd7c482c948a..f6729baa1bf4 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -558,8 +558,6 @@ static void vfio_pci_release(struct vfio_device *core_vdev)
>  	}
>  
>  	mutex_unlock(&vdev->reflck->lock);
> -
> -	module_put(THIS_MODULE);
>  }
>  
>  static int vfio_pci_open(struct vfio_device *core_vdev)
> @@ -568,9 +566,6 @@ static int vfio_pci_open(struct vfio_device *core_vdev)
>  		container_of(core_vdev, struct vfio_pci_device, vdev);
>  	int ret = 0;
>  
> -	if (!try_module_get(THIS_MODULE))
> -		return -ENODEV;
> -
>  	mutex_lock(&vdev->reflck->lock);
>  
>  	if (!vdev->refcnt) {
> @@ -584,8 +579,6 @@ static int vfio_pci_open(struct vfio_device *core_vdev)
>  	vdev->refcnt++;
>  error:
>  	mutex_unlock(&vdev->reflck->lock);
> -	if (ret)
> -		module_put(THIS_MODULE);
>  	return ret;
>  }
>  
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 470fcf7dac56..703164df7637 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -241,8 +241,6 @@ static void vfio_platform_release(struct vfio_device *core_vdev)
>  	}
>  
>  	mutex_unlock(&driver_lock);
> -
> -	module_put(vdev->parent_module);
>  }
>  
>  static int vfio_platform_open(struct vfio_device *core_vdev)
> @@ -251,9 +249,6 @@ static int vfio_platform_open(struct vfio_device *core_vdev)
>  		container_of(core_vdev, struct vfio_platform_device, vdev);
>  	int ret;
>  
> -	if (!try_module_get(vdev->parent_module))
> -		return -ENODEV;
> -
>  	mutex_lock(&driver_lock);
>  
>  	if (!vdev->refcnt) {
> @@ -291,7 +286,6 @@ static int vfio_platform_open(struct vfio_device *core_vdev)
>  	vfio_platform_regions_cleanup(vdev);
>  err_reg:
>  	mutex_unlock(&driver_lock);
> -	module_put(vdev->parent_module);
>  	return ret;
>  }
>  
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 5e631c359ef2..02cc51ce6891 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1369,8 +1369,14 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  	if (IS_ERR(device))
>  		return PTR_ERR(device);
>  
> +	if (!try_module_get(device->dev->driver->owner)) {
> +		vfio_device_put(device);
> +		return -ENODEV;
> +	}
> +
>  	ret = device->ops->open(device);
>  	if (ret) {
> +		module_put(device->dev->driver->owner);
>  		vfio_device_put(device);
>  		return ret;
>  	}
> @@ -1382,6 +1388,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  	ret = get_unused_fd_flags(O_CLOEXEC);
>  	if (ret < 0) {
>  		device->ops->release(device);
> +		module_put(device->dev->driver->owner);
>  		vfio_device_put(device);
>  		return ret;
>  	}
> @@ -1392,6 +1399,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  		put_unused_fd(ret);
>  		ret = PTR_ERR(filep);
>  		device->ops->release(device);
> +		module_put(device->dev->driver->owner);
>  		vfio_device_put(device);
>  		return ret;
>  	}
> @@ -1550,6 +1558,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	device->ops->release(device);
>  
> +	module_put(device->dev->driver->owner);
> +
>  	vfio_group_try_dissolve_container(device->group);
>  
>  	vfio_device_put(device);
> 

