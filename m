Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14E1550025
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 00:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiFQWr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 18:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbiFQWr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 18:47:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09AE2E0CC
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 15:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655506076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RKxbMuSx84e0qKVho6q+J9unBV9pl4MxbJagk7m/J3c=;
        b=BgznQmuWg1D2aQsuMuGZBBHclCjULCOgHsHoYany7kk3lcILgb6THtcBUwkqRYO3ZWKZDi
        s3J1mrbuW0a1nbtohqRJeY3lRC3P+EFUej0A4r4Lk2kk4QtVok9F5m9kvBS2o9+o2WklNJ
        Iimp25+FWyBBOGRxn2CYJ1mz4qzWa7U=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-XiFfkFT8OvGrx8SeOCcw2g-1; Fri, 17 Jun 2022 18:47:55 -0400
X-MC-Unique: XiFfkFT8OvGrx8SeOCcw2g-1
Received: by mail-io1-f70.google.com with SMTP id e195-20020a6bb5cc000000b0066cc9ece80fso3260543iof.5
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 15:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RKxbMuSx84e0qKVho6q+J9unBV9pl4MxbJagk7m/J3c=;
        b=CvB4h6QhtwsWGvbMUlt3w+wKTNwL8VzfYu6SlKXK6yvPLmoTNaR2DXiiczzW3daG7E
         1Rll0U3iqfZNy6nF7zqxhppSP6gn1pkFdqlFgrFSVMqxY53mE0E6FtmaMfh3tr029YE8
         T5hnK3Jatq8RkzHCyohJON39QrcXAnglSjDYNM6DUO3w0dIXWhIXGGgCJoIBfx1eWgc3
         mROHC2z/OehTZZ9l2o45/s9hVf8KpWebQe97mm6lY0RsYJcKHYjkethmY+UD7EbTqHYw
         4A/yCfBFqpVRRGDnMHWFpht6KfV0EiihHcG0i/A7HXE4+dQ39QoQXiKqzust/lDAEQ+z
         xpEA==
X-Gm-Message-State: AJIora8RNUvxOkyViHzXco0A/gR8S0/xJiNwoyREpWDZyF3ykhfszE7a
        oNvGe30XJaprnzTeLEPOVb+dCJ8ofPOGSp5AfcIMWAK2FDtJiVne52mSKu+WycMLHIPrFzHcsEe
        Wzx9gVgGDurKt
X-Received: by 2002:a05:6638:c4b:b0:333:f06b:3b6c with SMTP id g11-20020a0566380c4b00b00333f06b3b6cmr6634479jal.46.1655506074174;
        Fri, 17 Jun 2022 15:47:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vz6Dt5FCCT3d+qged2m5qipE/eA4GR95e3L00ajT9WkKXttWTsiMH12QmfHfxKOxu1jO6Tkw==
X-Received: by 2002:a05:6638:c4b:b0:333:f06b:3b6c with SMTP id g11-20020a0566380c4b00b00333f06b3b6cmr6634459jal.46.1655506073726;
        Fri, 17 Jun 2022 15:47:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g19-20020a925213000000b002d8f1269e97sm510242ilb.42.2022.06.17.15.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 15:47:53 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:47:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/2] vfio: Replace the DMA unmapping notifier with a
 callback
Message-ID: <20220617164751.7ceaac6e.alex.williamson@redhat.com>
In-Reply-To: <20220617164230.049c59f4.alex.williamson@redhat.com>
References: <0-v2-80aa110d03ce+24b-vfio_unmap_notif_jgg@nvidia.com>
        <1-v2-80aa110d03ce+24b-vfio_unmap_notif_jgg@nvidia.com>
        <20220617164230.049c59f4.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Jun 2022 16:42:30 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue,  7 Jun 2022 20:02:11 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 61e71c1154be67..f005b644ab9e69 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -1077,8 +1077,20 @@ static void vfio_device_unassign_container(struct vfio_device *device)
> >  	up_write(&device->group->group_rwsem);
> >  }
> >  
> > +static int vfio_iommu_notifier(struct notifier_block *nb, unsigned long action,
> > +			       void *data)
> > +{
> > +	struct vfio_device *vfio_device =
> > +		container_of(nb, struct vfio_device, iommu_nb);
> > +	struct vfio_iommu_type1_dma_unmap *unmap = data;
> > +
> > +	vfio_device->ops->dma_unmap(vfio_device, unmap->iova, unmap->size);
> > +	return NOTIFY_OK;
> > +}
> > +
> >  static struct file *vfio_device_open(struct vfio_device *device)
> >  {
> > +	struct vfio_iommu_driver *iommu_driver;
> >  	struct file *filep;
> >  	int ret;
> >  
> > @@ -1109,6 +1121,18 @@ static struct file *vfio_device_open(struct vfio_device *device)
> >  			if (ret)
> >  				goto err_undo_count;
> >  		}
> > +
> > +		iommu_driver = device->group->container->iommu_driver;
> > +		if (device->ops->dma_unmap && iommu_driver &&
> > +		    iommu_driver->ops->register_notifier) {
> > +			unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
> > +
> > +			device->iommu_nb.notifier_call = vfio_iommu_notifier;
> > +			iommu_driver->ops->register_notifier(
> > +				device->group->container->iommu_data, &events,
> > +				&device->iommu_nb);
> > +		}
> > +
> >  		up_read(&device->group->group_rwsem);
> >  	}
> >  	mutex_unlock(&device->dev_set->lock);
> > @@ -1143,8 +1167,16 @@ static struct file *vfio_device_open(struct vfio_device *device)
> >  err_close_device:
> >  	mutex_lock(&device->dev_set->lock);
> >  	down_read(&device->group->group_rwsem);
> > -	if (device->open_count == 1 && device->ops->close_device)
> > +	if (device->open_count == 1 && device->ops->close_device) {
> >  		device->ops->close_device(device);
> > +
> > +		iommu_driver = device->group->container->iommu_driver;
> > +		if (device->ops->dma_unmap && iommu_driver &&
> > +		    iommu_driver->ops->register_notifier)  
> 
> Test for register_notifier callback...
> 
> > +			iommu_driver->ops->unregister_notifier(
> > +				device->group->container->iommu_data,
> > +				&device->iommu_nb);  
> 
> use unregister_notifier callback.  Same below.
> 
> > +	}
> >  err_undo_count:
> >  	device->open_count--;
> >  	if (device->open_count == 0 && device->kvm)
> > @@ -1339,12 +1371,20 @@ static const struct file_operations vfio_group_fops = {
> >  static int vfio_device_fops_release(struct inode *inode, struct file *filep)
> >  {
> >  	struct vfio_device *device = filep->private_data;
> > +	struct vfio_iommu_driver *iommu_driver;
> >  
> >  	mutex_lock(&device->dev_set->lock);
> >  	vfio_assert_device_open(device);
> >  	down_read(&device->group->group_rwsem);
> >  	if (device->open_count == 1 && device->ops->close_device)
> >  		device->ops->close_device(device);
> > +
> > +	iommu_driver = device->group->container->iommu_driver;
> > +	if (device->ops->dma_unmap && iommu_driver &&
> > +	    iommu_driver->ops->register_notifier)
> > +		iommu_driver->ops->unregister_notifier(
> > +			device->group->container->iommu_data,
> > +			&device->iommu_nb);
> >  	up_read(&device->group->group_rwsem);
> >  	device->open_count--;
> >  	if (device->open_count == 0)
> > @@ -2027,90 +2067,6 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova, void *data,
> >  }
> >  EXPORT_SYMBOL(vfio_dma_rw);
> >  
> > -static int vfio_register_iommu_notifier(struct vfio_group *group,
> > -					unsigned long *events,
> > -					struct notifier_block *nb)
> > -{
> > -	struct vfio_container *container;
> > -	struct vfio_iommu_driver *driver;
> > -	int ret;
> > -
> > -	lockdep_assert_held_read(&group->group_rwsem);
> > -
> > -	container = group->container;
> > -	driver = container->iommu_driver;
> > -	if (likely(driver && driver->ops->register_notifier))
> > -		ret = driver->ops->register_notifier(container->iommu_data,
> > -						     events, nb);
> > -	else
> > -		ret = -ENOTTY;
> > -
> > -	return ret;
> > -}
> > -
> > -static int vfio_unregister_iommu_notifier(struct vfio_group *group,
> > -					  struct notifier_block *nb)
> > -{
> > -	struct vfio_container *container;
> > -	struct vfio_iommu_driver *driver;
> > -	int ret;
> > -
> > -	lockdep_assert_held_read(&group->group_rwsem);
> > -
> > -	container = group->container;
> > -	driver = container->iommu_driver;
> > -	if (likely(driver && driver->ops->unregister_notifier))
> > -		ret = driver->ops->unregister_notifier(container->iommu_data,
> > -						       nb);
> > -	else
> > -		ret = -ENOTTY;
> > -
> > -	return ret;
> > -}
> > -
> > -int vfio_register_notifier(struct vfio_device *device,
> > -			   enum vfio_notify_type type, unsigned long *events,
> > -			   struct notifier_block *nb)
> > -{
> > -	struct vfio_group *group = device->group;
> > -	int ret;
> > -
> > -	if (!nb || !events || (*events == 0) ||
> > -	    !vfio_assert_device_open(device))
> > -		return -EINVAL;
> > -
> > -	switch (type) {
> > -	case VFIO_IOMMU_NOTIFY:
> > -		ret = vfio_register_iommu_notifier(group, events, nb);
> > -		break;
> > -	default:
> > -		ret = -EINVAL;
> > -	}
> > -	return ret;
> > -}
> > -EXPORT_SYMBOL(vfio_register_notifier);
> > -
> > -int vfio_unregister_notifier(struct vfio_device *device,
> > -			     enum vfio_notify_type type,
> > -			     struct notifier_block *nb)
> > -{
> > -	struct vfio_group *group = device->group;
> > -	int ret;
> > -
> > -	if (!nb || !vfio_assert_device_open(device))
> > -		return -EINVAL;
> > -
> > -	switch (type) {
> > -	case VFIO_IOMMU_NOTIFY:
> > -		ret = vfio_unregister_iommu_notifier(group, nb);
> > -		break;
> > -	default:
> > -		ret = -EINVAL;
> > -	}
> > -	return ret;
> > -}
> > -EXPORT_SYMBOL(vfio_unregister_notifier);
> > -
> >  /*
> >   * Module/class support
> >   */
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index a6713022115155..cb2e4e9baa8fe8 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -33,6 +33,11 @@ enum vfio_iommu_notify_type {
> >  	VFIO_IOMMU_CONTAINER_CLOSE = 0,
> >  };
> >  
> > +/* events for register_notifier() */
> > +enum {
> > +	VFIO_IOMMU_NOTIFY_DMA_UNMAP = 1,
> > +};  
> 
> Can't say I understand why this changed from BIT(0) to an enum, the
> event mask is meant to be a bitfield.  Using the notifier all the way
> to the device was meant to avoid future callbacks on the device.  If we
> now have a dma_unmap on the device, should the whole infrastructure be
> tailored to that one task?  For example a dma_unmap_nb on the device,
> {un}register_dma_unmap_notifier on the iommu ops,
> vfio_dma_unmap_notifier, etc?  Thanks,

Ok, this all seems cleared up in the next patch, maybe there's a better
intermediate step, but not worth bike shedding.  Thanks,

Alex

> > +
> >  /**
> >   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
> >   */
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index aa888cc517578e..b76623e3b92fca 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -44,6 +44,7 @@ struct vfio_device {
> >  	unsigned int open_count;
> >  	struct completion comp;
> >  	struct list_head group_next;
> > +	struct notifier_block iommu_nb;
> >  };
> >  
> >  /**
> > @@ -60,6 +61,8 @@ struct vfio_device {
> >   * @match: Optional device name match callback (return: 0 for no-match, >0 for
> >   *         match, -errno for abort (ex. match with insufficient or incorrect
> >   *         additional args)
> > + * @dma_unmap: Called when userspace unmaps IOVA from the container
> > + *             this device is attached to.
> >   * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
> >   * @migration_set_state: Optional callback to change the migration state for
> >   *         devices that support migration. It's mandatory for
> > @@ -85,6 +88,7 @@ struct vfio_device_ops {
> >  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
> >  	void	(*request)(struct vfio_device *vdev, unsigned int count);
> >  	int	(*match)(struct vfio_device *vdev, char *buf);
> > +	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
> >  	int	(*device_feature)(struct vfio_device *device, u32 flags,
> >  				  void __user *arg, size_t argsz);
> >  	struct file *(*migration_set_state)(
> > @@ -154,23 +158,6 @@ extern int vfio_unpin_pages(struct vfio_device *device, unsigned long *user_pfn,
> >  extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
> >  		       void *data, size_t len, bool write);
> >  
> > -/* each type has independent events */
> > -enum vfio_notify_type {
> > -	VFIO_IOMMU_NOTIFY = 0,
> > -};
> > -
> > -/* events for VFIO_IOMMU_NOTIFY */
> > -#define VFIO_IOMMU_NOTIFY_DMA_UNMAP	BIT(0)
> > -
> > -extern int vfio_register_notifier(struct vfio_device *device,
> > -				  enum vfio_notify_type type,
> > -				  unsigned long *required_events,
> > -				  struct notifier_block *nb);
> > -extern int vfio_unregister_notifier(struct vfio_device *device,
> > -				    enum vfio_notify_type type,
> > -				    struct notifier_block *nb);
> > -
> > -
> >  /*
> >   * Sub-module helpers
> >   */  
> 

