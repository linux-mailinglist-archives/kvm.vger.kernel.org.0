Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07995500A2
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 01:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383576AbiFQXUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 19:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiFQXTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 19:19:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 605F566AE3
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 16:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655507967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8OYUdYr/7uStGpTxjJZh8hjqGzxQdQwhj1gZ+QVtJE=;
        b=eZlsyIE5AU8hLI59WlpjW6yHCy+QoiNulU2wldL/0rjOkjNzt8URdekSez0apgDihGrIOt
        SMkRhCbrMLcaujw0ff2tWc/90sjZyLiFst7LKNT8f6uXvIqvMeAKGDKFEbSAfb4XHZaENe
        S7JFneFv688e+Qm29TV2Udn+D3TYg7s=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-2vgD3aJVMl-u4ySVE5Dkig-1; Fri, 17 Jun 2022 19:19:26 -0400
X-MC-Unique: 2vgD3aJVMl-u4ySVE5Dkig-1
Received: by mail-io1-f72.google.com with SMTP id l7-20020a6b7007000000b00669b2a0d497so3314990ioc.0
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 16:19:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=m8OYUdYr/7uStGpTxjJZh8hjqGzxQdQwhj1gZ+QVtJE=;
        b=oxY7P8j8sjx/1bCGdO5rjJcL1Z5yfQ1ZImGaSVrsgIOIj4vucHjCn/X5fZF5udEto3
         pNV1qA/JpGEjlTavAO7QqKEmj2mHVTLXQRppFHoYiwfdQUwvuYnS4OPIV8gvOnF8Yx8R
         m+PlEUHOJFrXxINsf9wHRma0CpR/IRCPO4JdyZbVQXhWPIMCP4K8mZlKb1iIYRBWKikT
         2y0RjJSSJjQBGbTkIujeU9HmqwkDbqdAzzPKkwfckvT+YY+eBcVAGqXJGQq/4l4lVmZl
         m7RPuLakeqz4cHoX+k6fKVm5TZB08nexqBrkaCtTXYMus5UIhBjTIZbjc3qFNWoy+up3
         okDA==
X-Gm-Message-State: AJIora9xb28pmrGlkssc1bikSdQbW6/X8Y462u3K1kY1RH/DqKXy6HTP
        yzIpmI+ka4ivahW5uiZ2IVvH9vnbbRJtsB5/2f/NrNoGgBQy7WAQyuoj9AWQLKFmKQUCFE/O2Ew
        Vgncqf1UVRCR6
X-Received: by 2002:a05:6638:2049:b0:332:2e25:b209 with SMTP id t9-20020a056638204900b003322e25b209mr6885229jaj.168.1655507965220;
        Fri, 17 Jun 2022 16:19:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sCG9F5wCUnZcfDU16ZrtjA3XJrMwC/YqMJLGo64XHczgVeVe/vKg5OeDVsE9LxpSvMfdyeFQ==
X-Received: by 2002:a05:6638:2049:b0:332:2e25:b209 with SMTP id t9-20020a056638204900b003322e25b209mr6885198jaj.168.1655507964960;
        Fri, 17 Jun 2022 16:19:24 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g91-20020a028564000000b0032e75bfe344sm2757808jai.171.2022.06.17.16.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 16:19:24 -0700 (PDT)
Date:   Fri, 17 Jun 2022 17:19:23 -0600
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
Subject: Re: [PATCH v2 2/2] vfio: Replace the iommu notifier with a device
 list
Message-ID: <20220617171923.129f3bf7.alex.williamson@redhat.com>
In-Reply-To: <2-v2-80aa110d03ce+24b-vfio_unmap_notif_jgg@nvidia.com>
References: <0-v2-80aa110d03ce+24b-vfio_unmap_notif_jgg@nvidia.com>
        <2-v2-80aa110d03ce+24b-vfio_unmap_notif_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jun 2022 20:02:12 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Instead of bouncing the function call to the driver op through a blocking
> notifier just have the iommu layer call it directly.
> 
> Register each device that is being attached to the iommu with the lower
> driver which then threads them on a linked list and calls the appropriate
> driver op at the right time.
> 
> Currently the only use is if dma_unmap() is defined.
> 
> Also, fully lock all the debugging tests on the pinning path that a
> dma_unmap is registered.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c             |  42 ++++---------
>  drivers/vfio/vfio.h             |  14 ++---
>  drivers/vfio/vfio_iommu_type1.c | 103 ++++++++++++++++++++------------
>  include/linux/vfio.h            |   2 +-
>  4 files changed, 83 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index f005b644ab9e69..065b57e601bff7 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -619,6 +619,9 @@ EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>   */
>  int vfio_register_emulated_iommu_dev(struct vfio_device *device)
>  {
> +	if (WARN_ON(!device->ops->dma_unmap))
> +		return -EINVAL;
> +
>  	return __vfio_register_dev(device,
>  		vfio_noiommu_group_alloc(device->dev, VFIO_EMULATED_IOMMU));
>  }
> @@ -1077,17 +1080,6 @@ static void vfio_device_unassign_container(struct vfio_device *device)
>  	up_write(&device->group->group_rwsem);
>  }
>  
> -static int vfio_iommu_notifier(struct notifier_block *nb, unsigned long action,
> -			       void *data)
> -{
> -	struct vfio_device *vfio_device =
> -		container_of(nb, struct vfio_device, iommu_nb);
> -	struct vfio_iommu_type1_dma_unmap *unmap = data;
> -
> -	vfio_device->ops->dma_unmap(vfio_device, unmap->iova, unmap->size);
> -	return NOTIFY_OK;
> -}
> -
>  static struct file *vfio_device_open(struct vfio_device *device)
>  {
>  	struct vfio_iommu_driver *iommu_driver;
> @@ -1123,15 +1115,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  		}
>  
>  		iommu_driver = device->group->container->iommu_driver;
> -		if (device->ops->dma_unmap && iommu_driver &&
> -		    iommu_driver->ops->register_notifier) {
> -			unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
> -
> -			device->iommu_nb.notifier_call = vfio_iommu_notifier;
> -			iommu_driver->ops->register_notifier(
> -				device->group->container->iommu_data, &events,
> -				&device->iommu_nb);
> -		}
> +		if (iommu_driver && iommu_driver->ops->register_device)
> +			iommu_driver->ops->register_device(
> +				device->group->container->iommu_data, device);
>  
>  		up_read(&device->group->group_rwsem);
>  	}
> @@ -1171,11 +1157,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  		device->ops->close_device(device);
>  
>  		iommu_driver = device->group->container->iommu_driver;
> -		if (device->ops->dma_unmap && iommu_driver &&
> -		    iommu_driver->ops->register_notifier)
> -			iommu_driver->ops->unregister_notifier(
> -				device->group->container->iommu_data,
> -				&device->iommu_nb);
> +		if (iommu_driver && iommu_driver->ops->register_device)
> +			iommu_driver->ops->unregister_device(
> +				device->group->container->iommu_data, device);

But let's fix this in the next respin too, ie. test register but call
unregister.  Got it right below in this one.

>  	}
>  err_undo_count:
>  	device->open_count--;
> @@ -1380,11 +1364,9 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  		device->ops->close_device(device);
>  
>  	iommu_driver = device->group->container->iommu_driver;
> -	if (device->ops->dma_unmap && iommu_driver &&
> -	    iommu_driver->ops->register_notifier)
> -		iommu_driver->ops->unregister_notifier(
> -			device->group->container->iommu_data,
> -			&device->iommu_nb);
> +	if (iommu_driver && iommu_driver->ops->unregister_device)
> +		iommu_driver->ops->unregister_device(
> +			device->group->container->iommu_data, device);
>  	up_read(&device->group->group_rwsem);
>  	device->open_count--;
>  	if (device->open_count == 0)
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index cb2e4e9baa8fe8..4a7db1f3c33e7e 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -33,11 +33,6 @@ enum vfio_iommu_notify_type {
>  	VFIO_IOMMU_CONTAINER_CLOSE = 0,
>  };
>  
> -/* events for register_notifier() */
> -enum {
> -	VFIO_IOMMU_NOTIFY_DMA_UNMAP = 1,
> -};
> -
>  /**
>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
>   */
> @@ -60,11 +55,10 @@ struct vfio_iommu_driver_ops {
>  				     unsigned long *phys_pfn);
>  	int		(*unpin_pages)(void *iommu_data,
>  				       unsigned long *user_pfn, int npage);
> -	int		(*register_notifier)(void *iommu_data,
> -					     unsigned long *events,
> -					     struct notifier_block *nb);
> -	int		(*unregister_notifier)(void *iommu_data,
> -					       struct notifier_block *nb);
> +	void		(*register_device)(void *iommu_data,
> +					   struct vfio_device *vdev);
> +	void		(*unregister_device)(void *iommu_data,
> +					     struct vfio_device *vdev);
>  	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
>  				  void *data, size_t count, bool write);
>  	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c13b9290e35759..4ddb1f1abd238b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -67,7 +67,8 @@ struct vfio_iommu {
>  	struct list_head	iova_list;
>  	struct mutex		lock;
>  	struct rb_root		dma_list;
> -	struct blocking_notifier_head notifier;
> +	struct list_head	device_list;
> +	struct mutex		device_list_lock;
>  	unsigned int		dma_avail;
>  	unsigned int		vaddr_invalid_count;
>  	uint64_t		pgsize_bitmap;
> @@ -865,8 +866,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  		}
>  	}
>  
> -	/* Fail if notifier list is empty */
> -	if (!iommu->notifier.head) {
> +	/* Fail if no dma_umap notifier is registered */

No "notifier" anymore.

Should we even get here if this list is empty?  Seems like we can
restrict page pinning to devices supporting unmap_dma now and this
could be a WARN_ON.  Thanks,

Alex


> +	if (list_empty(&iommu->device_list)) {
>  		ret = -EINVAL;
>  		goto pin_done;
>  	}

