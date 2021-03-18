Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2613D340219
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 10:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhCRJcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 05:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhCRJcf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 05:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616059948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzmvOFYyhdKH4Hq1n07t/xm6UA0pgEWz5UpHRQtMk/w=;
        b=iP/6/z9fo4dfqA7RO0JCTCoY49kwkSxmQp4dkx1F1BHYLQUlU6gCi1AVLKMIyp/+BGdu0L
        wFjJsN89UrEhdscKx1H2b3O/PlYDGAKIsEbHg+fWWDZRa7UNtMb+ynuVE8F/as42wEYNzc
        tyXH6ZBhoyaRzA7VpAil6OlOqe/zJlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-S78n606HPXCgPGoECDAaTw-1; Thu, 18 Mar 2021 05:32:24 -0400
X-MC-Unique: S78n606HPXCgPGoECDAaTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C96FA10866A0;
        Thu, 18 Mar 2021 09:32:22 +0000 (UTC)
Received: from [10.36.112.6] (ovpn-112-6.ams2.redhat.com [10.36.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AE0217D04;
        Thu, 18 Mar 2021 09:32:15 +0000 (UTC)
Subject: Re: [PATCH v2 01/14] vfio: Remove extra put/gets around
 vfio_device->group
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
References: <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c5551f77-3071-06bc-ff15-1c606185c9ee@redhat.com>
Date:   Thu, 18 Mar 2021 10:32:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 3/13/21 1:55 AM, Jason Gunthorpe wrote:
> The vfio_device->group value has a get obtained during
> vfio_add_group_dev() which gets moved from the stack to vfio_device->group
> in vfio_group_create_device().
> 
> The reference remains until we reach the end of vfio_del_group_dev() when
> it is put back.
> 
> Thus anything that already has a kref on the vfio_device is guaranteed a
> valid group pointer. Remove all the extra reference traffic.
> 
> It is tricky to see, but the get at the start of vfio_del_group_dev() is
> actually pairing with the put hidden inside vfio_device_put() a few lines
> below.
> 
> A later patch merges vfio_group_create_device() into vfio_add_group_dev()
> which makes the ownership and error flow on the create side easier to
> follow.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/vfio.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 38779e6fd80cb4..15d8e678e5563a 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -546,14 +546,12 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>  
>  	kref_init(&device->kref);
>  	device->dev = dev;
> +	/* Our reference on group is moved to the device */
>  	device->group = group;
>  	device->ops = ops;
>  	device->device_data = device_data;
>  	dev_set_drvdata(dev, device);
>  
> -	/* No need to get group_lock, caller has group reference */
> -	vfio_group_get(group);
> -
>  	mutex_lock(&group->device_lock);
>  	list_add(&device->group_next, &group->device_list);
>  	group->dev_counter++;
> @@ -585,13 +583,11 @@ void vfio_device_put(struct vfio_device *device)
>  {
>  	struct vfio_group *group = device->group;
>  	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
> -	vfio_group_put(group);
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_put);
>  
>  static void vfio_device_get(struct vfio_device *device)
>  {
> -	vfio_group_get(device->group);
>  	kref_get(&device->kref);
>  }
>  
> @@ -841,14 +837,6 @@ int vfio_add_group_dev(struct device *dev,
>  		vfio_group_put(group);
>  		return PTR_ERR(device);
>  	}
> -
> -	/*
> -	 * Drop all but the vfio_device reference.  The vfio_device holds
> -	 * a reference to the vfio_group, which holds a reference to the
> -	 * iommu_group.
> -	 */
> -	vfio_group_put(group);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_add_group_dev);
> @@ -928,12 +916,6 @@ void *vfio_del_group_dev(struct device *dev)
>  	unsigned int i = 0;
>  	bool interrupted = false;
>  
> -	/*
> -	 * The group exists so long as we have a device reference.  Get
> -	 * a group reference and use it to scan for the device going away.
> -	 */
> -	vfio_group_get(group);
> -
>  	/*
>  	 * When the device is removed from the group, the group suddenly
>  	 * becomes non-viable; the device has a driver (until the unbind
> @@ -1008,6 +990,7 @@ void *vfio_del_group_dev(struct device *dev)
>  	if (list_empty(&group->device_list))
>  		wait_event(group->container_q, !group->container);
>  
> +	/* Matches the get in vfio_group_create_device() */
>  	vfio_group_put(group);
>  
>  	return device_data;
> 

