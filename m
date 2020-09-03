Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D9925C9CB
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 21:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgICTzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 15:55:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55560 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728312AbgICTzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 15:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599162919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hkD8HfSlaP2Xxtnq/zUyNSli/Rr08ovCTsAkBQvzE9w=;
        b=BTOQx3teCOKnwlQP4TiG7PVp10+yv8uf6U3XfH7DFDJfchlwey/AxrySXDb2ZUx26S5O6h
        3b7cTQPSTK+V5VRKNwUcSkxzUPQTU8y9U5ZN9qWRJkMygqtkrjcDPAtD63VC7TOZt7SV1w
        r4oy/WVNOdkzXmxO+A4p1PfwMS3radc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-cf-sKM-xP-Wn54caHK8VEQ-1; Thu, 03 Sep 2020 15:55:17 -0400
X-MC-Unique: cf-sKM-xP-Wn54caHK8VEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 559168010C7;
        Thu,  3 Sep 2020 19:55:16 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA4781A4D6;
        Thu,  3 Sep 2020 19:55:07 +0000 (UTC)
Subject: Re: [PATCH v4 06/10] vfio/fsl-mc: Added lock support in preparation
 for interrupt handling
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-7-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <6b847d37-ecad-83ab-ae98-96cdd8123591@redhat.com>
Date:   Thu, 3 Sep 2020 21:55:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-7-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana

On 8/26/20 11:33 AM, Diana Craciun wrote:
> Only the DPRC object allocates interrupts from the MSI
> interrupt domain. The interrupts are managed by the DPRC in
> a pool of interrupts. The access to this pool of interrupts
> has to be protected with a lock.
> This patch extends the current lock implementation to have a
> lock per DPRC.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 91 +++++++++++++++++++++--
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  8 +-
>  2 files changed, 91 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 64d5c1fff51f..bbd3365e877e 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -17,6 +17,77 @@
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
> +	int ret = 0;
> +
> +	mutex_lock(&reflck_lock);
> +	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
> +		vdev->reflck = vfio_fsl_mc_reflck_alloc();
this can fail and if this happens I guess you shouldn't return 0.
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
are we sure cont_mdev always is != NULL?
> +		if (!cont_vdev->reflck) {
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
> @@ -55,7 +126,7 @@ static int vfio_fsl_mc_open(void *device_data)
>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>  
> -	mutex_lock(&vdev->driver_lock);
> +	mutex_lock(&vdev->reflck->lock);
>  	if (!vdev->refcnt) {
>  		ret = vfio_fsl_mc_regions_init(vdev);
>  		if (ret)
> @@ -63,12 +134,12 @@ static int vfio_fsl_mc_open(void *device_data)
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
> @@ -77,12 +148,12 @@ static void vfio_fsl_mc_release(void *device_data)
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
> @@ -329,12 +400,18 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  		return ret;
>  	}
>  
> +	ret = vfio_fsl_mc_reflck_attach(vdev);
> +	if (ret) {
> +		vfio_iommu_group_put(group, dev);
> +		return ret;
> +	}
> +
>  	ret = vfio_fsl_mc_init_device(vdev);
>  	if (ret < 0) {
> +		vfio_fsl_mc_reflck_put(vdev->reflck);
>  		vfio_iommu_group_put(group, dev);
>  		return ret;
>  	}
> -	mutex_init(&vdev->driver_lock);
>  
>  	return ret;
>  }
> @@ -358,7 +435,7 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
>  
>  	mc_dev->mc_io = NULL;
>  
> -	mutex_destroy(&vdev->driver_lock);
> +	vfio_fsl_mc_reflck_put(vdev->reflck);
>  
>  	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
>  
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index 818dfd3df4db..3b85d930e060 100644
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
> @@ -28,7 +33,8 @@ struct vfio_fsl_mc_device {
>  	int				refcnt;
>  	u32				num_regions;
>  	struct vfio_fsl_mc_region	*regions;
> -	struct mutex driver_lock;
> +	struct vfio_fsl_mc_reflck   *reflck;
> +
>  };
>  
>  #endif /* VFIO_FSL_MC_PRIVATE_H */
> 
Thanks

Eric

