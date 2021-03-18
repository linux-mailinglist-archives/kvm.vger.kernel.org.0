Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076F73406B7
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhCRNTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:19:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhCRNSy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616073533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSK0USnuX6KxDknSRR5qIweideljzaAZoiXntoUaHMs=;
        b=evXInKdSW3x4eoCO+4AlCUydUSJ4WUhlYor4xgHQCWAFW5I6nnUuf1ZkhKjD+KIivxTI0k
        lFkb2OyDX6j7iLt0Y6cSjAbEdmuGvrwRlCjcVUQuP6SeMfaK9AP5oyImFLIDU8mTLHXhyq
        qWz0PrpvBQjiaeZwiqscxTifYSHoKrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-yeiMFZBmN4uP8LEmXyuuuQ-1; Thu, 18 Mar 2021 09:18:49 -0400
X-MC-Unique: yeiMFZBmN4uP8LEmXyuuuQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEBD563CCB;
        Thu, 18 Mar 2021 13:18:47 +0000 (UTC)
Received: from [10.36.112.6] (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 55F995D6AB;
        Thu, 18 Mar 2021 13:18:38 +0000 (UTC)
Subject: Re: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
References: <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <5d8e4901-6798-e7be-8109-ef704971c8dd@redhat.com>
Date:   Thu, 18 Mar 2021 14:18:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 3/13/21 1:55 AM, Jason Gunthorpe wrote:
> This makes the struct vfio_pci_device part of the public interface so it
> can be used with container_of and so forth, as is typical for a Linux
> subystem.
> 
> This is the first step to bring some type-safety to the vfio interface by
> allowing the replacement of 'void *' and 'struct device *' inputs with a
> simple and clear 'struct vfio_pci_device *'
> 
> For now the self-allocating vfio_add_group_dev() interface is kept so each
> user can be updated as a separate patch.
> 
> The expected usage pattern is
> 
>   driver core probe() function:
>      my_device = kzalloc(sizeof(*mydevice));
>      vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
>      /* other driver specific prep */
>      vfio_register_group_dev(&my_device->vdev);
>      dev_set_drvdata(my_device);
> 
>   driver core remove() function:
>      my_device = dev_get_drvdata(dev);
>      vfio_unregister_group_dev(&my_device->vdev);
>      /* other driver specific tear down */
>      kfree(my_device);
> 
> Allowing the driver to be able to use the drvdata and vifo_device to go
> to/from its own data.
> 
> The pattern also makes it clear that vfio_register_group_dev() must be
> last in the sequence, as once it is called the core code can immediately
> start calling ops. The init/register gap is provided to allow for the
> driver to do setup before ops can be called and thus avoid races.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
With previously commit msg and comment fixes,

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  Documentation/driver-api/vfio.rst |  31 ++++----
>  drivers/vfio/vfio.c               | 123 ++++++++++++++++--------------
>  include/linux/vfio.h              |  16 ++++
>  3 files changed, 98 insertions(+), 72 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index f1a4d3c3ba0bb1..d3a02300913a7f 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -249,18 +249,23 @@ VFIO bus driver API
>  
>  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
>  into VFIO core.  When devices are bound and unbound to the driver,
> -the driver should call vfio_add_group_dev() and vfio_del_group_dev()
> -respectively::
> -
> -	extern int vfio_add_group_dev(struct device *dev,
> -				      const struct vfio_device_ops *ops,
> -				      void *device_data);
> -
> -	extern void *vfio_del_group_dev(struct device *dev);
> -
> -vfio_add_group_dev() indicates to the core to begin tracking the
> -iommu_group of the specified dev and register the dev as owned by
> -a VFIO bus driver.  The driver provides an ops structure for callbacks
> +the driver should call vfio_register_group_dev() and
> +vfio_unregister_group_dev() respectively::
> +
> +	void vfio_init_group_dev(struct vfio_device *device,
> +				struct device *dev,
> +				const struct vfio_device_ops *ops,
> +				void *device_data);
> +	int vfio_register_group_dev(struct vfio_device *device);
> +	void vfio_unregister_group_dev(struct vfio_device *device);
> +
> +The driver should embed the vfio_device in its own structure and call
> +vfio_init_group_dev() to pre-configure it before going to registration.
> +vfio_register_group_dev() indicates to the core to begin tracking the
> +iommu_group of the specified dev and register the dev as owned by a VFIO bus
> +driver. Once vfio_register_group_dev() returns it is possible for userspace to
> +start accessing the driver, thus the driver should ensure it is completely
> +ready before calling it. The driver provides an ops structure for callbacks
>  similar to a file operations structure::
>  
>  	struct vfio_device_ops {
> @@ -276,7 +281,7 @@ similar to a file operations structure::
>  	};
>  
>  Each function is passed the device_data that was originally registered
> -in the vfio_add_group_dev() call above.  This allows the bus driver
> +in the vfio_register_group_dev() call above.  This allows the bus driver
>  an easy place to store its opaque, private data.  The open/release
>  callbacks are issued when a new file descriptor is created for a
>  device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 32660e8a69ae20..cfa06ae3b9018b 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -89,16 +89,6 @@ struct vfio_group {
>  	struct blocking_notifier_head	notifier;
>  };
>  
> -struct vfio_device {
> -	refcount_t			refcount;
> -	struct completion		comp;
> -	struct device			*dev;
> -	const struct vfio_device_ops	*ops;
> -	struct vfio_group		*group;
> -	struct list_head		group_next;
> -	void				*device_data;
> -};
> -
>  #ifdef CONFIG_VFIO_NOIOMMU
>  static bool noiommu __read_mostly;
>  module_param_named(enable_unsafe_noiommu_mode,
> @@ -532,35 +522,6 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
>  /**
>   * Device objects - create, release, get, put, search
>   */
> -static
> -struct vfio_device *vfio_group_create_device(struct vfio_group *group,
> -					     struct device *dev,
> -					     const struct vfio_device_ops *ops,
> -					     void *device_data)
> -{
> -	struct vfio_device *device;
> -
> -	device = kzalloc(sizeof(*device), GFP_KERNEL);
> -	if (!device)
> -		return ERR_PTR(-ENOMEM);
> -
> -	refcount_set(&device->refcount, 1);
> -	init_completion(&device->comp);
> -	device->dev = dev;
> -	/* Our reference on group is moved to the device */
> -	device->group = group;
> -	device->ops = ops;
> -	device->device_data = device_data;
> -	dev_set_drvdata(dev, device);
> -
> -	mutex_lock(&group->device_lock);
> -	list_add(&device->group_next, &group->device_list);
> -	group->dev_counter++;
> -	mutex_unlock(&group->device_lock);
> -
> -	return device;
> -}
> -
>  /* Device reference always implies a group reference */
>  void vfio_device_put(struct vfio_device *device)
>  {
> @@ -779,14 +740,23 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
>  /**
>   * VFIO driver API
>   */
> -int vfio_add_group_dev(struct device *dev,
> -		       const struct vfio_device_ops *ops, void *device_data)
> +void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> +			 const struct vfio_device_ops *ops, void *device_data)
> +{
> +	init_completion(&device->comp);
> +	device->dev = dev;
> +	device->ops = ops;
> +	device->device_data = device_data;
> +}
> +EXPORT_SYMBOL_GPL(vfio_init_group_dev);
> +
> +int vfio_register_group_dev(struct vfio_device *device)
>  {
> +	struct vfio_device *existing_device;
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> -	struct vfio_device *device;
>  
> -	iommu_group = iommu_group_get(dev);
> +	iommu_group = iommu_group_get(device->dev);
>  	if (!iommu_group)
>  		return -EINVAL;
>  
> @@ -805,21 +775,50 @@ int vfio_add_group_dev(struct device *dev,
>  		iommu_group_put(iommu_group);
>  	}
>  
> -	device = vfio_group_get_device(group, dev);
> -	if (device) {
> -		dev_WARN(dev, "Device already exists on group %d\n",
> +	existing_device = vfio_group_get_device(group, device->dev);
> +	if (existing_device) {
> +		dev_WARN(device->dev, "Device already exists on group %d\n",
>  			 iommu_group_id(iommu_group));
> -		vfio_device_put(device);
> +		vfio_device_put(existing_device);
>  		vfio_group_put(group);
>  		return -EBUSY;
>  	}
>  
> -	device = vfio_group_create_device(group, dev, ops, device_data);
> -	if (IS_ERR(device)) {
> -		vfio_group_put(group);
> -		return PTR_ERR(device);
> -	}
> +	/* Our reference on group is moved to the device */
> +	device->group = group;
> +
> +	/* Refcounting can't start until the driver calls register */
> +	refcount_set(&device->refcount, 1);
> +
> +	mutex_lock(&group->device_lock);
> +	list_add(&device->group_next, &group->device_list);
> +	group->dev_counter++;
> +	mutex_unlock(&group->device_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_register_group_dev);
> +
> +int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops *ops,
> +		       void *device_data)
> +{
> +	struct vfio_device *device;
> +	int ret;
> +
> +	device = kzalloc(sizeof(*device), GFP_KERNEL);
> +	if (!device)
> +		return -ENOMEM;
> +
> +	vfio_init_group_dev(device, dev, ops, device_data);
> +	ret = vfio_register_group_dev(device);
> +	if (ret)
> +		goto err_kfree;
> +	dev_set_drvdata(dev, device);
>  	return 0;
> +
> +err_kfree:
> +	kfree(device);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vfio_add_group_dev);
>  
> @@ -887,11 +886,9 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
>  /*
>   * Decrement the device reference count and wait for the device to be
>   * removed.  Open file descriptors for the device... */
> -void *vfio_del_group_dev(struct device *dev)
> +void vfio_unregister_group_dev(struct vfio_device *device)
>  {
> -	struct vfio_device *device = dev_get_drvdata(dev);
>  	struct vfio_group *group = device->group;
> -	void *device_data = device->device_data;
>  	struct vfio_unbound_dev *unbound;
>  	unsigned int i = 0;
>  	bool interrupted = false;
> @@ -908,7 +905,7 @@ void *vfio_del_group_dev(struct device *dev)
>  	 */
>  	unbound = kzalloc(sizeof(*unbound), GFP_KERNEL);
>  	if (unbound) {
> -		unbound->dev = dev;
> +		unbound->dev = device->dev;
>  		mutex_lock(&group->unbound_lock);
>  		list_add(&unbound->unbound_next, &group->unbound_list);
>  		mutex_unlock(&group->unbound_lock);
> @@ -919,7 +916,7 @@ void *vfio_del_group_dev(struct device *dev)
>  	rc = try_wait_for_completion(&device->comp);
>  	while (rc <= 0) {
>  		if (device->ops->request)
> -			device->ops->request(device_data, i++);
> +			device->ops->request(device->device_data, i++);
>  
>  		if (interrupted) {
>  			rc = wait_for_completion_timeout(&device->comp,
> @@ -929,7 +926,7 @@ void *vfio_del_group_dev(struct device *dev)
>  				&device->comp, HZ * 10);
>  			if (rc < 0) {
>  				interrupted = true;
> -				dev_warn(dev,
> +				dev_warn(device->dev,
>  					 "Device is currently in use, task"
>  					 " \"%s\" (%d) "
>  					 "blocked until device is released",
> @@ -962,9 +959,17 @@ void *vfio_del_group_dev(struct device *dev)
>  
>  	/* Matches the get in vfio_group_create_device() */
>  	vfio_group_put(group);
> +}
> +EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
> +
> +void *vfio_del_group_dev(struct device *dev)
> +{
> +	struct vfio_device *device = dev_get_drvdata(dev);
> +	void *device_data = device->device_data;
> +
> +	vfio_unregister_group_dev(device);
>  	dev_set_drvdata(dev, NULL);
>  	kfree(device);
> -
>  	return device_data;
>  }
>  EXPORT_SYMBOL_GPL(vfio_del_group_dev);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b7e18bde5aa8b3..ad8b579d67d34a 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -15,6 +15,18 @@
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
>  
> +struct vfio_device {
> +	struct device *dev;
> +	const struct vfio_device_ops *ops;
> +	struct vfio_group *group;
> +
> +	/* Members below here are private, not for driver use */
> +	refcount_t refcount;
> +	struct completion comp;
> +	struct list_head group_next;
> +	void *device_data;
> +};
> +
>  /**
>   * struct vfio_device_ops - VFIO bus driver device callbacks
>   *
> @@ -48,11 +60,15 @@ struct vfio_device_ops {
>  extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
>  extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
>  
> +void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> +			 const struct vfio_device_ops *ops, void *device_data);
> +int vfio_register_group_dev(struct vfio_device *device);
>  extern int vfio_add_group_dev(struct device *dev,
>  			      const struct vfio_device_ops *ops,
>  			      void *device_data);
>  
>  extern void *vfio_del_group_dev(struct device *dev);
> +void vfio_unregister_group_dev(struct vfio_device *device);
>  extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
>  extern void vfio_device_put(struct vfio_device *device);
>  extern void *vfio_device_data(struct vfio_device *device);
> 

