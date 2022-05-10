Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B854F522522
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiEJUAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 16:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiEJUAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 16:00:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 807682983AE
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 13:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652212807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tjirfzysjY35qNF2viW2FllS9tA4vbKRLHE6+8/z6KM=;
        b=L32nIM1vMRAAUDKTJU8qjUWsxuoR0+xvLloWToxqbb4PFND4zWyFHuQCG/YJPTEp6+0U6Z
        WyHbsIymwOOlpw5nbI7nyvrFt7LoWG69Fl5YcPXyfqsWb8NfHAoPLdPqbgvyW4n9y8wNgt
        tx3I5rhHJeUCSKZF+jR7SEK+fPujQP0=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-VfKG9T1sM2alm9OWQ-qGEg-1; Tue, 10 May 2022 15:59:59 -0400
X-MC-Unique: VfKG9T1sM2alm9OWQ-qGEg-1
Received: by mail-io1-f72.google.com with SMTP id ay38-20020a5d9da6000000b0065adc1f932bso5980897iob.11
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 12:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tjirfzysjY35qNF2viW2FllS9tA4vbKRLHE6+8/z6KM=;
        b=Kd2stiuocrAiv0S33DghhVl3/taVkzaU4xxusaAxczD5gFo8rTMsr6xygtHmSyFNhF
         0wrvhwl7g8DLgh4mmFNHxFcGSxMVauhF63F/6YMNw9o/ZRNVpzJ61Xf0QdwpizCydwcU
         VAAQtqEEt6vD+gn3qNbTD7TH/xrlWqYo6yqiYyxphy3LJr/+rOdJvETFKsablp6Pi6BM
         LGm0/X4pb+Gmhd0D4Lcb/Qk0wO3cFcl6SB32Vz7edshLD7Rq+rTdz8ZbcdZQPyyqNGR/
         uT7buCs9YVChiIOQrk5SEAdmQZMJBKTVG2kwsXwp7vwg7AGrqizuwB+vx+Av4PFFi4oS
         MTjQ==
X-Gm-Message-State: AOAM532MbJ8EPz+Pt6BBWulMl+vtL24jbCg/9pBXhhZjpEAoqDN3vMxr
        ul+Jl+H3I4B5CpEKMLyaSp5UXforRXrSXstFWtB90Vxbvzgcbs+uRnDNgAQn/dlTcVwGr4742+u
        ornnMDAWiu/Um
X-Received: by 2002:a05:6638:3894:b0:32b:7ec7:9106 with SMTP id b20-20020a056638389400b0032b7ec79106mr10763638jav.255.1652212798162;
        Tue, 10 May 2022 12:59:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpPgFcfLsVkcGLaFh69eRGa4T42W5zvkNBdN60NDA7+iTUTka7ZJ3KqHV0hMomuE49GuQHNA==
X-Received: by 2002:a05:6638:3894:b0:32b:7ec7:9106 with SMTP id b20-20020a056638389400b0032b7ec79106mr10763620jav.255.1652212797927;
        Tue, 10 May 2022 12:59:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q8-20020a056e02096800b002cde6e352d9sm85964ilt.35.2022.05.10.12.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 12:59:57 -0700 (PDT)
Date:   Tue, 10 May 2022 13:59:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/6] vfio: Split up vfio_group_get_device_fd()
Message-ID: <20220510135956.7b894c27.alex.williamson@redhat.com>
In-Reply-To: <3-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
        <3-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
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

On Thu,  5 May 2022 21:25:03 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The split follows the pairing with the destroy functions:
> 
>  - vfio_group_get_device_fd() destroyed by close()
> 
>  - vfio_device_open() destroyed by vfio_device_fops_release()
> 
>  - vfio_device_assign_container() destroyed by
>    vfio_group_try_dissolve_container()
> 
> The next patch will put a lock around vfio_device_assign_container().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 89 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 62 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index a5584131648765..d8d14e528ab795 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1084,27 +1084,38 @@ static bool vfio_assert_device_open(struct vfio_device *device)
>  	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
>  }
>  
> -static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
> +static int vfio_device_assign_container(struct vfio_device *device)
>  {
> -	struct vfio_device *device;
> -	struct file *filep;
> -	int fdno;
> -	int ret = 0;
> +	struct vfio_group *group = device->group;
>  
>  	if (0 == atomic_read(&group->container_users) ||
>  	    !group->container->iommu_driver)
>  		return -EINVAL;
>  
> -	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
> -		return -EPERM;
> +	if (group->type == VFIO_NO_IOMMU) {
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		dev_warn(device->dev,
> +			 "vfio-noiommu device opened by user (%s:%d)\n",
> +			 current->comm, task_pid_nr(current));

I don't see why this was moved.  It was previously ordered such that we
would not emit a warning unless the device is actually opened.  Now
there are various error cases that could make this a false warning.
Thanks,

Alex

> +	}
>  
> -	device = vfio_device_get_from_name(group, buf);
> -	if (IS_ERR(device))
> -		return PTR_ERR(device);
> +	atomic_inc(&group->container_users);
> +	return 0;
> +}
> +
> +static struct file *vfio_device_open(struct vfio_device *device)
> +{
> +	struct file *filep;
> +	int ret;
> +
> +	ret = vfio_device_assign_container(device);
> +	if (ret)
> +		return ERR_PTR(ret);
>  
>  	if (!try_module_get(device->dev->driver->owner)) {
>  		ret = -ENODEV;
> -		goto err_device_put;
> +		goto err_unassign_container;
>  	}
>  
>  	mutex_lock(&device->dev_set->lock);
> @@ -1120,15 +1131,11 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  	 * We can't use anon_inode_getfd() because we need to modify
>  	 * the f_mode flags directly to allow more than just ioctls
>  	 */
> -	fdno = ret = get_unused_fd_flags(O_CLOEXEC);
> -	if (ret < 0)
> -		goto err_close_device;
> -
>  	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
>  				   device, O_RDWR);
>  	if (IS_ERR(filep)) {
>  		ret = PTR_ERR(filep);
> -		goto err_fd;
> +		goto err_close_device;
>  	}
>  
>  	/*
> @@ -1138,17 +1145,12 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  	 */
>  	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
>  
> -	atomic_inc(&group->container_users);
> +	/*
> +	 * On success the ref of device is moved to the file and
> +	 * put in vfio_device_fops_release()
> +	 */
> +	return filep;
>  
> -	fd_install(fdno, filep);
> -
> -	if (group->type == VFIO_NO_IOMMU)
> -		dev_warn(device->dev, "vfio-noiommu device opened by user "
> -			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> -	return fdno;
> -
> -err_fd:
> -	put_unused_fd(fdno);
>  err_close_device:
>  	mutex_lock(&device->dev_set->lock);
>  	if (device->open_count == 1 && device->ops->close_device)
> @@ -1157,7 +1159,40 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  	device->open_count--;
>  	mutex_unlock(&device->dev_set->lock);
>  	module_put(device->dev->driver->owner);
> -err_device_put:
> +err_unassign_container:
> +	vfio_group_try_dissolve_container(device->group);
> +	return ERR_PTR(ret);
> +}
> +
> +static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
> +{
> +	struct vfio_device *device;
> +	struct file *filep;
> +	int fdno;
> +	int ret;
> +
> +	device = vfio_device_get_from_name(group, buf);
> +	if (IS_ERR(device))
> +		return PTR_ERR(device);
> +
> +	fdno = get_unused_fd_flags(O_CLOEXEC);
> +	if (fdno < 0) {
> +		ret = fdno;
> +		goto err_put_device;
> +	}
> +
> +	filep = vfio_device_open(device);
> +	if (IS_ERR(filep)) {
> +		ret = PTR_ERR(filep);
> +		goto err_put_fdno;
> +	}
> +
> +	fd_install(fdno, filep);
> +	return fdno;
> +
> +err_put_fdno:
> +	put_unused_fd(fdno);
> +err_put_device:
>  	vfio_device_put(device);
>  	return ret;
>  }

