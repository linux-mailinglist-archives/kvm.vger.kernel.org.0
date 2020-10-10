Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16E28A1AA
	for <lists+kvm@lfdr.de>; Sun, 11 Oct 2020 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgJJVo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:44:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728544AbgJJS5F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Oct 2020 14:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602356222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7eRQLnISIyqDaG1yH2WwS+dwfKeCwcQNsRaLeAN3dk=;
        b=gLy2vL6rMhuuoyZ0kV90bezxQlKvidDI8nZOO80RqAHnqFmY7BjbDi4zaghlOCiyA1KR9L
        np3ayBvRrIn3Ekv28sDYiV2cpUBahp3LN8ixdk3cNfbTARMpH9/tx2sLJt6IiE9UxJXvbW
        Sry9Rz+xGpblaSoy4M6d7WUYUBRvzD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-i3hr7HcIOymKG0HU6aSP8w-1; Sat, 10 Oct 2020 13:39:20 -0400
X-MC-Unique: i3hr7HcIOymKG0HU6aSP8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 745BE1DDE1;
        Sat, 10 Oct 2020 17:39:19 +0000 (UTC)
Received: from [10.36.113.210] (ovpn-113-210.ams2.redhat.com [10.36.113.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCA566EF58;
        Sat, 10 Oct 2020 17:39:14 +0000 (UTC)
Subject: Re: [PATCH v6 06/10] vfio/fsl-mc: Added lock support in preparation
 for interrupt handling
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
 <20201005173654.31773-7-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ac58c7ea-6fe3-05dc-ee6d-19475a383736@redhat.com>
Date:   Sat, 10 Oct 2020 19:39:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201005173654.31773-7-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,
On 10/5/20 7:36 PM, Diana Craciun wrote:
> Only the DPRC object allocates interrupts from the MSI
> interrupt domain. The interrupts are managed by the DPRC in
> a pool of interrupts. The access to this pool of interrupts
> has to be protected with a lock.
> This patch extends the current lock implementation to have a
> lock per DPRC.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 92 +++++++++++++++++++++--
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  7 +-
>  2 files changed, 90 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 55190a2730fb..b52407c4e1ea 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -17,6 +17,78 @@
>  
>  static struct fsl_mc_driver vfio_fsl_mc_driver;
>  
> +static DEFINE_MUTEX(reflck_lock);
> +
> +static void vfio_fsl_mc_reflck_get(struct vfio_fsl_mc_reflck *reflck)
> +{
> +	kref_get(&reflck->kref);
> +}
> +
> +static void vfio_fsl_mc_reflck_release(struct kref *kref)
> +{
> +	struct vfio_fsl_mc_reflck *reflck = container_of(kref,
> +						      struct vfio_fsl_mc_reflck,
> +						      kref);
> +
> +	mutex_destroy(&reflck->lock);
> +	kfree(reflck);
> +	mutex_unlock(&reflck_lock);
> +}
> +
> +static void vfio_fsl_mc_reflck_put(struct vfio_fsl_mc_reflck *reflck)
> +{
> +	kref_put_mutex(&reflck->kref, vfio_fsl_mc_reflck_release, &reflck_lock);
> +}
> +
> +static struct vfio_fsl_mc_reflck *vfio_fsl_mc_reflck_alloc(void)
> +{
> +	struct vfio_fsl_mc_reflck *reflck;
> +
> +	reflck = kzalloc(sizeof(*reflck), GFP_KERNEL);
> +	if (!reflck)
> +		return ERR_PTR(-ENOMEM);
> +
> +	kref_init(&reflck->kref);
> +	mutex_init(&reflck->lock);
> +
> +	return reflck;
> +}
> +
> +static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
> +{
> +	int ret;
> +
> +	mutex_lock(&reflck_lock);
> +	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
> +		vdev->reflck = vfio_fsl_mc_reflck_alloc();
> +		ret = PTR_ERR_OR_ZERO(vdev->reflck);
> +	} else {
> +		struct device *mc_cont_dev = vdev->mc_dev->dev.parent;
> +		struct vfio_device *device;
> +		struct vfio_fsl_mc_device *cont_vdev;
> +
> +		device = vfio_device_get_from_dev(mc_cont_dev);
> +		if (!device) {
> +			ret = -ENODEV;
> +			goto unlock;
> +		}
> +
> +		cont_vdev = vfio_device_data(device);
> +		if (!cont_vdev || !cont_vdev->reflck) {
> +			vfio_device_put(device);
> +			ret = -ENODEV;
> +			goto unlock;
> +		}
> +		vfio_fsl_mc_reflck_get(cont_vdev->reflck);
> +		vdev->reflck = cont_vdev->reflck;
> +		vfio_device_put(device);
> +	}
> +
> +unlock:
> +	mutex_unlock(&reflck_lock);
> +	return ret;
> +}
> +
>  static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>  {
>  	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> @@ -62,7 +134,7 @@ static int vfio_fsl_mc_open(void *device_data)
>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>  
> -	mutex_lock(&vdev->driver_lock);
> +	mutex_lock(&vdev->reflck->lock);
>  	if (!vdev->refcnt) {
>  		ret = vfio_fsl_mc_regions_init(vdev);
>  		if (ret)
> @@ -70,12 +142,12 @@ static int vfio_fsl_mc_open(void *device_data)
>  	}
>  	vdev->refcnt++;
>  
> -	mutex_unlock(&vdev->driver_lock);
> +	mutex_unlock(&vdev->reflck->lock);
>  
>  	return 0;
>  
>  err_reg_init:
> -	mutex_unlock(&vdev->driver_lock);
> +	mutex_unlock(&vdev->reflck->lock);
>  	module_put(THIS_MODULE);
>  	return ret;
>  }
> @@ -84,12 +156,12 @@ static void vfio_fsl_mc_release(void *device_data)
>  {
>  	struct vfio_fsl_mc_device *vdev = device_data;
>  
> -	mutex_lock(&vdev->driver_lock);
> +	mutex_lock(&vdev->reflck->lock);
>  
>  	if (!(--vdev->refcnt))
>  		vfio_fsl_mc_regions_cleanup(vdev);
>  
> -	mutex_unlock(&vdev->driver_lock);
> +	mutex_unlock(&vdev->reflck->lock);
>  
>  	module_put(THIS_MODULE);
>  }
> @@ -343,14 +415,18 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  		goto out_group_put;
>  	}
>  
> -	ret = vfio_fsl_mc_init_device(vdev);
> +	ret = vfio_fsl_mc_reflck_attach(vdev);
>  	if (ret)
>  		goto out_group_dev;
>  
> -	mutex_init(&vdev->driver_lock);
> +	ret = vfio_fsl_mc_init_device(vdev);
> +	if (ret)
> +		goto out_reflck;
>  
>  	return 0;
>  
> +out_reflck:
> +	vfio_fsl_mc_reflck_put(vdev->reflck);
>  out_group_dev:
>  	vfio_del_group_dev(dev);
>  out_group_put:
> @@ -367,7 +443,7 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  	if (!vdev)
>  		return -EINVAL;
>  
> -	mutex_destroy(&vdev->driver_lock);
> +	vfio_fsl_mc_reflck_put(vdev->reflck);
>  
>  	if (is_fsl_mc_bus_dprc(mc_dev)) {
>  		dprc_remove_devices(mc_dev, NULL, 0);
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index be60f41af30f..d47ef6215429 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -15,6 +15,11 @@
>  #define VFIO_FSL_MC_INDEX_TO_OFFSET(index)	\
>  	((u64)(index) << VFIO_FSL_MC_OFFSET_SHIFT)
>  
> +struct vfio_fsl_mc_reflck {
> +	struct kref		kref;
> +	struct mutex		lock;
> +};
> +
>  struct vfio_fsl_mc_region {
>  	u32			flags;
>  	u32			type;
> @@ -27,7 +32,7 @@ struct vfio_fsl_mc_device {
>  	struct notifier_block        nb;
>  	int				refcnt;
>  	struct vfio_fsl_mc_region	*regions;
> -	struct mutex driver_lock;
> +	struct vfio_fsl_mc_reflck   *reflck;
>  };
>  
>  #endif /* VFIO_FSL_MC_PRIVATE_H */
> 

