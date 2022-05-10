Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B89522521
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 22:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiEJUAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 16:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiEJUAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 16:00:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD57A29839E
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 13:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652212806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fu+8FpTNNNO8ze8f8Eh8Gm4vSBYGdQAvUH/n+NM4m7k=;
        b=ODauK25ieqnZuEPX/ONUOe9L15r++PsgKHY1jNysyOP8NQP41v3DX07x7rutA2hHyVaOPm
        2OyIhdsyyEX+wOGOyVR35OxL6JS7njBUlriS8LGimeE6W/aSRIQTIWSybhNetbr5GNx6WG
        dQSXXhHkDpe2kn6yqoijB2S4Qt8t1tc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-BzWrnZvDOEyqy4445A-Ovw-1; Tue, 10 May 2022 16:00:02 -0400
X-MC-Unique: BzWrnZvDOEyqy4445A-Ovw-1
Received: by mail-il1-f197.google.com with SMTP id q9-20020a056e02106900b002cbc8d479eeso63628ilj.1
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 13:00:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fu+8FpTNNNO8ze8f8Eh8Gm4vSBYGdQAvUH/n+NM4m7k=;
        b=gEsqV+iV+AJFcTr58i+cRQsUOVYLTIkcsOHxaG368al/6fyMRGTDjTDV14IgQHol5W
         K0F4CrMWKAkC3MnJxYSaw6+ralshsozwXfT7Pbkzj7e/8/TOrvg59KfHDTVLNhU8KJF9
         feR61OwQInb/yO8FGOPW1eXpAd5bSG4SKj9ql5lb2tEDF7MuFBaEMpnItioO6u1LPgvH
         CebZIKr1l1UkJZwp/7IjfiDoCbAhvcatChGxGG35oMpMnR8hhC4mxlbXX00T8TUfoqHM
         TalTDrJ2O49Tc6IR/G5CKYB8bEMZRNI+56WRZ/8qFWx0JFtJV/uCmpggvmEToRhpKoMT
         Cx5Q==
X-Gm-Message-State: AOAM533o4ckS+4leVe3DQoENvTBHQmeo2MfqZ747iBCgMkIMe592+DDD
        75seTgWY+HhOD0OC2fl972GNaFVlSgdk0MgiDH6DYIMU8LK5vuetww9Hr4hVNEMbzD0G9r/LpbT
        wE8HA8SSLAPEz
X-Received: by 2002:a05:6e02:1a0e:b0:2cf:66ae:aec0 with SMTP id s14-20020a056e021a0e00b002cf66aeaec0mr10204747ild.75.1652212800588;
        Tue, 10 May 2022 13:00:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzV1o8BfomQ93UVVscM/lZFuHR2uzluzQ3UQnprzzXgkl+ogD44LQXTXDFspv2LrNBudbRS/A==
X-Received: by 2002:a05:6e02:1a0e:b0:2cf:66ae:aec0 with SMTP id s14-20020a056e021a0e00b002cf66aeaec0mr10204733ild.75.1652212800333;
        Tue, 10 May 2022 13:00:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i20-20020a926d14000000b002cde6e352f4sm75084ilc.62.2022.05.10.12.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 12:59:59 -0700 (PDT)
Date:   Tue, 10 May 2022 13:59:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] vfio: Simplify the life cycle of the group FD
Message-ID: <20220510135959.20266cfd.alex.williamson@redhat.com>
In-Reply-To: <5-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
        <5-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
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

On Thu,  5 May 2022 21:25:05 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Once userspace opens a group FD it is prevented from opening another
> instance of that same group FD until all the prior group FDs and users of
> the container are done.
> 
> The first is done trivially by checking the group->owned during group FD
> open.
> 
> However, things get a little weird if userspace creates a device FD and
> then closes the group FD. The group FD still cannot be re-opened, but this
> time it is because the group->container is still set and container_users
> is elevated by the device FD.
> 
> Due to this mismatched lifecycle we have the
> vfio_group_try_dissolve_container() which tries to auto-free a container
> after the group FD is closed but the device FD remains open.
> 
> Instead have the device FD hold onto a reference to the single group
> FD. This directly prevents vfio_group_fops_release() from being called
> when any device FD exists and makes the lifecycle model more
> understandable.
> 
> vfio_group_try_dissolve_container() is removed as the only place a
> container is auto-deleted is during vfio_group_fops_release(). At this
> point the container_users is either 1 or 0 since all device FDs must be
> closed.
> 
> Change group->owner to group->singleton_filep which points to the single
> struct file * that is open for the group. If the group->singleton_filep is
> NULL then group->container == NULL.
> 
> If all device FDs have closed then the group's notifier list must be
> empty.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 49 +++++++++++++++++++--------------------------
>  1 file changed, 21 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 63f7fa872eae60..94ab415190011d 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -73,12 +73,12 @@ struct vfio_group {
>  	struct mutex			device_lock;
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
> -	bool				opened;
>  	wait_queue_head_t		container_q;
>  	enum vfio_group_type		type;
>  	unsigned int			dev_counter;
>  	struct rw_semaphore		group_rwsem;
>  	struct kvm			*kvm;
> +	struct file			*singleton_file;

I'm not really a fan of this name, if we have a single struct file
pointer on the group, it's necessarily singleton.  Maybe just
"opened_file"?

>  	struct blocking_notifier_head	notifier;
>  };
>  
> @@ -987,20 +987,6 @@ static int vfio_group_unset_container(struct vfio_group *group)
>  	return 0;
>  }
>  
> -/*
> - * When removing container users, anything that removes the last user
> - * implicitly removes the group from the container.  That is, if the
> - * group file descriptor is closed, as well as any device file descriptors,
> - * the group is free.
> - */
> -static void vfio_group_try_dissolve_container(struct vfio_group *group)
> -{
> -	down_write(&group->group_rwsem);
> -	if (0 == atomic_dec_if_positive(&group->container_users))
> -		__vfio_group_unset_container(group);
> -	up_write(&group->group_rwsem);
> -}
> -
>  static int vfio_group_set_container(struct vfio_group *group, int container_fd)
>  {
>  	struct fd f;
> @@ -1093,10 +1079,19 @@ static int vfio_device_assign_container(struct vfio_device *device)
>  			 current->comm, task_pid_nr(current));
>  	}
>  
> +	get_file(group->singleton_file);
>  	atomic_inc(&group->container_users);
>  	return 0;
>  }
>  
> +static void vfio_device_unassign_container(struct vfio_device *device)
> +{
> +	down_write(&device->group->group_rwsem);
> +	atomic_dec(&device->group->container_users);
> +	fput(device->group->singleton_file);
> +	up_write(&device->group->group_rwsem);
> +}
> +
>  static struct file *vfio_device_open(struct vfio_device *device)
>  {
>  	struct file *filep;
> @@ -1155,7 +1150,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  	mutex_unlock(&device->dev_set->lock);
>  	module_put(device->dev->driver->owner);
>  err_unassign_container:
> -	vfio_group_try_dissolve_container(device->group);
> +	vfio_device_unassign_container(device);
>  	return ERR_PTR(ret);
>  }
>  
> @@ -1286,18 +1281,12 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  
>  	/*
>  	 * Do we need multiple instances of the group open?  Seems not.
> -	 * Is something still in use from a previous open?
>  	 */
> -	if (group->opened || group->container) {
> +	if (group->singleton_file) {
>  		ret = -EBUSY;
>  		goto err_put;
>  	}
> -	group->opened = true;
> -
> -	/* Warn if previous user didn't cleanup and re-init to drop them */
> -	if (WARN_ON(group->notifier.head))
> -		BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> -
> +	group->singleton_file = filep;
>  	filep->private_data = group;
>  
>  	up_write(&group->group_rwsem);
> @@ -1315,10 +1304,14 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
>  
>  	filep->private_data = NULL;
>  
> -	vfio_group_try_dissolve_container(group);
> -
>  	down_write(&group->group_rwsem);
> -	group->opened = false;
> +	/* All device FDs must be released before the group fd releases. */

This sounds more like a user directive as it's phrased, maybe something
like:

	/*
	 * Device FDs hold a group file reference, therefore the group
	 * release is only called when there are no open devices.
	 */

Thanks,
Alex

> +	WARN_ON(group->notifier.head);
> +	if (group->container) {
> +		WARN_ON(atomic_read(&group->container_users) != 1);
> +		__vfio_group_unset_container(group);
> +	}
> +	group->singleton_file = NULL;
>  	up_write(&group->group_rwsem);
>  
>  	vfio_group_put(group);
> @@ -1350,7 +1343,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	module_put(device->dev->driver->owner);
>  
> -	vfio_group_try_dissolve_container(device->group);
> +	vfio_device_unassign_container(device);
>  
>  	vfio_device_put(device);
>  

