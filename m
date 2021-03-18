Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE31334068C
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhCRNK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:10:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231281AbhCRNKZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616073024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6o6reARlIilafLO9a/wNJL1a7idpLiAeBV+WQ1/MRc=;
        b=YRm3/JtyIe6hODDOJj8K6v4AFYiq2H/HM2zNiNu77N6HpxuJAerOjOneu77AmMWI0vy+E0
        rA+JBZOgijtl2JYSdQaVC3JQwQq2K29LiAjDe7Ozu0wgCZfM5zm0CYjbwkVJFn4oiZfi3G
        6xtD9www3fR/j5v3i5Otpfgm6ux5YbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-luo3D5NYNdyyo51VqoGbgA-1; Thu, 18 Mar 2021 09:10:20 -0400
X-MC-Unique: luo3D5NYNdyyo51VqoGbgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD278801817;
        Thu, 18 Mar 2021 13:10:18 +0000 (UTC)
Received: from [10.36.112.6] (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C47660862;
        Thu, 18 Mar 2021 13:10:08 +0000 (UTC)
Subject: Re: [PATCH v2 02/14] vfio: Simplify the lifetime logic for
 vfio_device
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
References: <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f3c09162-89f0-43fb-0dc2-1c0f0bca482d@redhat.com>
Date:   Thu, 18 Mar 2021 14:10:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <2-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 3/13/21 1:55 AM, Jason Gunthorpe wrote:
> The vfio_device is using a 'sleep until all refs go to zero' pattern for
> its lifetime, but it is indirectly coded by repeatedly scanning the group
> list waiting for the device to be removed on its own.
> 
> Switch this around to be a direct representation, use a refcount to count
> the number of places that are blocking destruction and sleep directly on a
> completion until that counter goes to zero. kfree the device after other
> accesses have been excluded in vfio_del_group_dev(). This is a fairly
> common Linux idiom.
> 
> Due to this we can now remove kref_put_mutex(), which is very rarely used
> in the kernel. Here it is being used to prevent a zero ref device from
> being seen in the group list. Instead allow the zero ref device to
> continue to exist in the device_list and use refcount_inc_not_zero() to
> exclude it once refs go to zero.
> 
> This patch is organized so the next patch will be able to alter the API to
> allow drivers to provide the kfree.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/vfio.c | 79 ++++++++++++++-------------------------------
>  1 file changed, 25 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 15d8e678e5563a..32660e8a69ae20 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -46,7 +46,6 @@ static struct vfio {
>  	struct mutex			group_lock;
>  	struct cdev			group_cdev;
>  	dev_t				group_devt;
> -	wait_queue_head_t		release_q;
>  } vfio;
>  
>  struct vfio_iommu_driver {
> @@ -91,7 +90,8 @@ struct vfio_group {
>  };
>  
>  struct vfio_device {
> -	struct kref			kref;
> +	refcount_t			refcount;
> +	struct completion		comp;
>  	struct device			*dev;
>  	const struct vfio_device_ops	*ops;
>  	struct vfio_group		*group;
> @@ -544,7 +544,8 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>  	if (!device)
>  		return ERR_PTR(-ENOMEM);
>  
> -	kref_init(&device->kref);
> +	refcount_set(&device->refcount, 1);
> +	init_completion(&device->comp);
>  	device->dev = dev;
>  	/* Our reference on group is moved to the device */
>  	device->group = group;
> @@ -560,35 +561,17 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>  	return device;
>  }
>  
> -static void vfio_device_release(struct kref *kref)
> -{
> -	struct vfio_device *device = container_of(kref,
> -						  struct vfio_device, kref);
> -	struct vfio_group *group = device->group;
> -
> -	list_del(&device->group_next);
> -	group->dev_counter--;
> -	mutex_unlock(&group->device_lock);
> -
> -	dev_set_drvdata(device->dev, NULL);
> -
> -	kfree(device);
> -
> -	/* vfio_del_group_dev may be waiting for this device */
> -	wake_up(&vfio.release_q);
> -}
> -
>  /* Device reference always implies a group reference */
>  void vfio_device_put(struct vfio_device *device)
>  {
> -	struct vfio_group *group = device->group;
> -	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
> +	if (refcount_dec_and_test(&device->refcount))
> +		complete(&device->comp);
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_put);
>  
> -static void vfio_device_get(struct vfio_device *device)
> +static bool vfio_device_try_get(struct vfio_device *device)
>  {
> -	kref_get(&device->kref);
> +	return refcount_inc_not_zero(&device->refcount);
>  }
>  
>  static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
> @@ -598,8 +581,7 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
>  
>  	mutex_lock(&group->device_lock);
>  	list_for_each_entry(device, &group->device_list, group_next) {
> -		if (device->dev == dev) {
> -			vfio_device_get(device);
> +		if (device->dev == dev && vfio_device_try_get(device)) {
>  			mutex_unlock(&group->device_lock);
>  			return device;
>  		}
> @@ -883,9 +865,8 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
>  			ret = !strcmp(dev_name(it->dev), buf);
>  		}
>  
> -		if (ret) {
> +		if (ret && vfio_device_try_get(it)) {
>  			device = it;
> -			vfio_device_get(device);
>  			break;
>  		}
>  	}
> @@ -908,13 +889,13 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
>   * removed.  Open file descriptors for the device... */
>  void *vfio_del_group_dev(struct device *dev)
>  {
> -	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  	struct vfio_device *device = dev_get_drvdata(dev);
>  	struct vfio_group *group = device->group;
>  	void *device_data = device->device_data;
>  	struct vfio_unbound_dev *unbound;
>  	unsigned int i = 0;
>  	bool interrupted = false;
> +	long rc;
>  
>  	/*
>  	 * When the device is removed from the group, the group suddenly
> @@ -935,32 +916,18 @@ void *vfio_del_group_dev(struct device *dev)
>  	WARN_ON(!unbound);
>  
>  	vfio_device_put(device);
> -
> -	/*
> -	 * If the device is still present in the group after the above
> -	 * 'put', then it is in use and we need to request it from the
> -	 * bus driver.  The driver may in turn need to request the
> -	 * device from the user.  We send the request on an arbitrary
> -	 * interval with counter to allow the driver to take escalating
> -	 * measures to release the device if it has the ability to do so.
> -	 */
> -	add_wait_queue(&vfio.release_q, &wait);
> -
> -	do {
> -		device = vfio_group_get_device(group, dev);
> -		if (!device)
> -			break;
> -
> +	rc = try_wait_for_completion(&device->comp);
> +	while (rc <= 0) {
>  		if (device->ops->request)
>  			device->ops->request(device_data, i++);
>  
> -		vfio_device_put(device);
> -
>  		if (interrupted) {
> -			wait_woken(&wait, TASK_UNINTERRUPTIBLE, HZ * 10);
> +			rc = wait_for_completion_timeout(&device->comp,
> +							 HZ * 10);
>  		} else {
> -			wait_woken(&wait, TASK_INTERRUPTIBLE, HZ * 10);
> -			if (signal_pending(current)) {
> +			rc = wait_for_completion_interruptible_timeout(
> +				&device->comp, HZ * 10);
> +			if (rc < 0) {
>  				interrupted = true;
>  				dev_warn(dev,
>  					 "Device is currently in use, task"
> @@ -969,10 +936,13 @@ void *vfio_del_group_dev(struct device *dev)
>  					 current->comm, task_pid_nr(current));
>  			}
>  		}
> +	}
>  
> -	} while (1);
> +	mutex_lock(&group->device_lock);
> +	list_del(&device->group_next);
> +	group->dev_counter--;
> +	mutex_unlock(&group->device_lock);
>  
> -	remove_wait_queue(&vfio.release_q, &wait);
>  	/*
>  	 * In order to support multiple devices per group, devices can be
>  	 * plucked from the group while other devices in the group are still
> @@ -992,6 +962,8 @@ void *vfio_del_group_dev(struct device *dev)
>  
>  	/* Matches the get in vfio_group_create_device() */
>  	vfio_group_put(group);
> +	dev_set_drvdata(dev, NULL);
> +	kfree(device);
>  
>  	return device_data;
>  }
> @@ -2362,7 +2334,6 @@ static int __init vfio_init(void)
>  	mutex_init(&vfio.iommu_drivers_lock);
>  	INIT_LIST_HEAD(&vfio.group_list);
>  	INIT_LIST_HEAD(&vfio.iommu_drivers_list);
> -	init_waitqueue_head(&vfio.release_q);
>  
>  	ret = misc_register(&vfio_dev);
>  	if (ret) {
> 

