Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CE14219F8
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhJDW1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234251AbhJDW1q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 18:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633386356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5XDDWjt0kJldf4a5QMgqSmAndxHGsTGojY5jPo1x5U8=;
        b=OGyBki7V+qF/qn55U6r2f8/v5cRXKSoxbGzxU80VfTgwquM7xPwMKLfGT+C+qf7dIF10KY
        tdAzOrkxK60LpzzdcSjbBIZjWiOSl2y50HnXCJHIG17ft7aDhsOSxmqgz4gsaCF/K6wCzg
        Ha+SCdJzThRvML22IKy4Ckfs790GD9M=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-ltufIM99OlSbgV7M7xq_eg-1; Mon, 04 Oct 2021 18:25:54 -0400
X-MC-Unique: ltufIM99OlSbgV7M7xq_eg-1
Received: by mail-io1-f71.google.com with SMTP id t6-20020a6b0906000000b005d9a34ee5b9so17398063ioi.8
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 15:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5XDDWjt0kJldf4a5QMgqSmAndxHGsTGojY5jPo1x5U8=;
        b=yPgIcFa4NTQ+N6XMWgh38zkMzjqTdn0bGCup1H7PdvmRCdQW33Y+S2Q2NcSALBuBMG
         HoAUdpkS2+E9yMwOnbIhKrUUaYkI87V9I54f0yL5BSAPVhWCNxeoszFjWjCcQM5RlYpN
         VWF5iPVym9L8wns93XCuJ2mHo3Tabtenoob6gK2SVZNKw3zAHWNQ8s++sbAeMJCVDR5A
         luogo8y8BxV26bXp+WVJTAinwsH4FJwNwW5JtU82FgK/d9x5CJjocs99A5Mvpe59XHeA
         2+t48XtJtkrBC0jwTqOIdBpSn4RsB1C+RMtxjXWApbHhJYW/Ro+UQ4aulTzxaTcpw1oq
         orKw==
X-Gm-Message-State: AOAM532ADP0bq4bsCz+sfNOY8sL2qdFVLwdv4RHqYQqcNJK2lNCbB8Ud
        Z0PTtv5eRUlbmidW2+1NQXpo3aEAT58Zyyef4ZDiFDHOPpLBYBJNatMAE/Yur+euxqLnwjbuQR4
        xcA2jJtmzumIy
X-Received: by 2002:a02:b708:: with SMTP id g8mr12902163jam.107.1633386353592;
        Mon, 04 Oct 2021 15:25:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw73IGYwaCuNnO+sIJo33t2p9H1M/v89O2Ge3Dk//gsvAdJKQXvI+FTFDWZNPtZqz/swT9pGQ==
X-Received: by 2002:a02:b708:: with SMTP id g8mr12902151jam.107.1633386353383;
        Mon, 04 Oct 2021 15:25:53 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id z187sm9743406iof.49.2021.10.04.15.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 15:25:53 -0700 (PDT)
Date:   Mon, 4 Oct 2021 16:25:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio: Use a refcount_t instead of a kref in the
 vfio_group
Message-ID: <20211004162551.2a37dfd0.alex.williamson@redhat.com>
In-Reply-To: <4-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
        <4-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  1 Oct 2021 20:22:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The next patch adds a struct device to the struct vfio_group, and it is
> confusing/bad practice to have two krefs in the same struct. This kref is
> controlling the period when the vfio_group is registered in sysfs, and
> visible in the internal lookup. Switch it to a refcount_t instead.
> 
> The refcount_dec_and_mutex_lock() is still required because we need
> atomicity of the list searches and sysfs presence.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index bf233943dc992f..dbe7edd88ce35c 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -69,7 +69,7 @@ struct vfio_unbound_dev {
>  };
>  
>  struct vfio_group {
> -	struct kref			kref;
> +	refcount_t users;

Follow indenting for existing structs please.  The next patch even
mixes following and changing formatting, so I'm not sure what rule is
being used here.  Thanks,

Alex

>  	int				minor;
>  	atomic_t			container_users;
>  	struct iommu_group		*iommu_group;
> @@ -381,7 +381,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  	if (!group)
>  		return ERR_PTR(-ENOMEM);
>  
> -	kref_init(&group->kref);
> +	refcount_set(&group->users, 1);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	INIT_LIST_HEAD(&group->unbound_list);
> @@ -441,10 +441,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  	return group;
>  }
>  
> -/* called with vfio.group_lock held */
> -static void vfio_group_release(struct kref *kref)
> +static void vfio_group_put(struct vfio_group *group)
>  {
> -	struct vfio_group *group = container_of(kref, struct vfio_group, kref);
> +	if (!refcount_dec_and_mutex_lock(&group->users, &vfio.group_lock))
> +		return;
>  
>  	WARN_ON(!list_empty(&group->device_list));
>  	WARN_ON(atomic_read(&group->container_users));
> @@ -456,15 +456,9 @@ static void vfio_group_release(struct kref *kref)
>  	vfio_group_unlock_and_free(group);
>  }
>  
> -static void vfio_group_put(struct vfio_group *group)
> -{
> -	kref_put_mutex(&group->kref, vfio_group_release, &vfio.group_lock);
> -}
> -
> -/* Assume group_lock or group reference is held */
>  static void vfio_group_get(struct vfio_group *group)
>  {
> -	kref_get(&group->kref);
> +	refcount_inc(&group->users);
>  }
>  
>  static struct vfio_group *vfio_group_get_from_minor(int minor)
> @@ -1662,6 +1656,7 @@ struct vfio_group *vfio_group_get_external_user(struct file *filep)
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> +	/* Since the caller holds the fget on the file users must be >= 1 */
>  	vfio_group_get(group);
>  
>  	return group;

