Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1DE4219F7
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhJDW1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhJDW1g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 18:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633386346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0XrEvIJIG3yDqrl81jUv2iF4KdqXRUY0/OEffoo+C+k=;
        b=Hp+VGx624+o9I/r9ScAZivjxGkxby1fNBFm8aTdXFwZf0b3c4BHYJJbkD25vcFJoNnizK2
        Njo55v6T21rwjquldQvHVpZb3OZjpOYKvxm3yLNlvS/ms6fBiw5GVFbnV+M/PfDpcIcR8P
        mE8ohzKdIfiP3tVXHDz9aFBTDvipp9c=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-97VrE74mNziGoGfrc6Ou9g-1; Mon, 04 Oct 2021 18:25:45 -0400
X-MC-Unique: 97VrE74mNziGoGfrc6Ou9g-1
Received: by mail-io1-f70.google.com with SMTP id g15-20020a05660226cf00b005d622712e45so17386649ioo.11
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 15:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0XrEvIJIG3yDqrl81jUv2iF4KdqXRUY0/OEffoo+C+k=;
        b=reeag8R+PRTDJRIzibAB1E8x/Pioil/qt0W+guw59grCoU21p9pWncLiB1uIeln+Zp
         ImwcGdfWx+lnTm1n+WtBw64c1Hc9dkOj75/4/7qwVVxK79xl9tYr/VYpBFg1eWbKEET2
         CBN3epqWO6rM/mliJ8+PvM1n7+kZdJ3nh61hZjF5pKNXcKZzHIDRSRYNovaw5ymMhP+c
         6hNxjum/wBSM3/gwC0uxDf3vu6lZCLQ90i8YaNhKDahV+hMfLhDxMXIX+WthMGFfSuUy
         d7EsZCI1IKEeAgaVX+FQrm2csOprBt4GZCxWoLo3ePL1SS4PltZhunEaBpKM7gWcsJLB
         DHDA==
X-Gm-Message-State: AOAM533YpcjPP9OACXS0ud7/hKd8wflmWy0ecp6azBq5yvgkqXFAOmzc
        pQSSpOIuw0Uaafqdmmlxsdz/FOGuyYNKC/lHtMvYgKjeFcpEufAdDKY6oaezBR8n4ouJ56kgLWN
        PjmFmgaLzSrZ/
X-Received: by 2002:a92:c605:: with SMTP id p5mr412443ilm.218.1633386345162;
        Mon, 04 Oct 2021 15:25:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgvhVJhKq6Ergdf5dqJMXidzep1nfZ70DVS+2yuEMMrcvulpz1ydVnMB2Yb3+cV22IrTVw5w==
X-Received: by 2002:a92:c605:: with SMTP id p5mr412435ilm.218.1633386345001;
        Mon, 04 Oct 2021 15:25:45 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id y2sm9715475ioj.12.2021.10.04.15.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 15:25:44 -0700 (PDT)
Date:   Mon, 4 Oct 2021 16:25:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 3/5] vfio: Don't leak a group reference if the group
 already exists
Message-ID: <20211004162543.0fff3a96.alex.williamson@redhat.com>
In-Reply-To: <3-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
        <3-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  1 Oct 2021 20:22:22 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> If vfio_create_group() searches the group list and returns an already
> existing group it does not put back the iommu_group reference that the
> caller passed in.
> 
> Change the semantic of vfio_create_group() to not move the reference in
> from the caller, but instead obtain a new reference inside and leave the
> caller's reference alone. The two callers must now call iommu_group_put().
> 
> This is an unlikely race as the only caller that could hit it has already
> searched the group list before attempting to create the group.
> 
> Fixes: cba3345cc494 ("vfio: VFIO core")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 1cb12033b02240..bf233943dc992f 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -338,6 +338,7 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
>  		list_del(&unbound->unbound_next);
>  		kfree(unbound);
>  	}
> +	iommu_group_put(group->iommu_group);
>  	kfree(group);
>  }
>  
> @@ -389,6 +390,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  	atomic_set(&group->opened, 0);
>  	init_waitqueue_head(&group->container_q);
>  	group->iommu_group = iommu_group;
> +	/* put in vfio_group_unlock_and_free() */
> +	iommu_group_ref_get(iommu_group);
>  	group->type = type;
>  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
>  
> @@ -396,8 +399,8 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  
>  	ret = iommu_group_register_notifier(iommu_group, &group->nb);
>  	if (ret) {
> -		kfree(group);
> -		return ERR_PTR(ret);
> +		group = ERR_PTR(ret);
> +		goto err_put_group;
>  	}
>  
>  	mutex_lock(&vfio.group_lock);
> @@ -432,6 +435,9 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  
>  	mutex_unlock(&vfio.group_lock);
>  
> +err_put_group:
> +	iommu_group_put(iommu_group);
> +	kfree(group);

????

In the non-error path we're releasing the caller's reference which is
now their responsibility to release, but in any case we're freeing the
object that we return?  That can't be right.

>  	return group;
>  }
>  
> @@ -439,7 +445,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  static void vfio_group_release(struct kref *kref)
>  {
>  	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
> -	struct iommu_group *iommu_group = group->iommu_group;
>  
>  	WARN_ON(!list_empty(&group->device_list));
>  	WARN_ON(atomic_read(&group->container_users));
> @@ -449,7 +454,6 @@ static void vfio_group_release(struct kref *kref)
>  	list_del(&group->vfio_next);
>  	vfio_free_group_minor(group->minor);
>  	vfio_group_unlock_and_free(group);
> -	iommu_group_put(iommu_group);
>  }
>  
>  static void vfio_group_put(struct vfio_group *group)
> @@ -734,7 +738,7 @@ static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
>  		ret = PTR_ERR(group);
>  		goto out_remove_device;
>  	}
> -
> +	iommu_group_put(iommu_group);
>  	return group;
>  
>  out_remove_device:
> @@ -776,10 +780,6 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  
>  	/* a newly created vfio_group keeps the reference. */

This comment is now incorrect.  Thanks,

Alex


>  	group = vfio_create_group(iommu_group, VFIO_IOMMU);
> -	if (IS_ERR(group))
> -		goto out_put;
> -	return group;
> -
>  out_put:
>  	iommu_group_put(iommu_group);
>  	return group;

