Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355E26FFCDA
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbjEKWyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238802AbjEKWyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:54:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA358E42
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683845628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6v379jPF6D5Q151gpVNdXLOZQeza7CybafuKz64qus=;
        b=FIKLC2OsVMqCvMPTUJCM6wyGfqUiHbVshrs47uOYe2FRQ688hGWFtekqkThnZqSUWOzNXC
        YTDJs1B/rIJHPG+/1rqG7bHy/MOZVux2EomTniv8xGFxMIArPD+SmCM6sv72tp5d732vY0
        cazcn+3sPINI76S/vAdqtm74sjHG3eE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-CG2MMr0GNyiL2B4whVwupw-1; Thu, 11 May 2023 18:53:47 -0400
X-MC-Unique: CG2MMr0GNyiL2B4whVwupw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-76c48b53e16so344434039f.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845627; x=1686437627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6v379jPF6D5Q151gpVNdXLOZQeza7CybafuKz64qus=;
        b=kl0Jxd7m3cHd8R7RJ2YwVpAfMNQmB9SFW5jyVTH2DzLH8eaZZQL7nhLLPRW+mJ928v
         G451A8Sy0OgBkEbC43DRMmMOGjDc3hMa7UI8+uoSpSgGTzOEy56T0lcOSBMqPrPwpiI3
         zDh4ZZ704jYI3t0a2inTJP3bNwpO0EQwTvdAWjaQbzKcXc3Kpv7JFYe4SRezKnmo03WR
         Qod9+rgbh73nZNBlor/vEzC0gdVye/btfJrTzU1hQTyL7Imskphz7AEsituioc4i6hp9
         uDGyU6l4Lj/259D0/XvIxdk46Km58shfQP5PKdMiTilWDpY6NOlZvJgPUgtWZ6QoxUlg
         CD6Q==
X-Gm-Message-State: AC+VfDyIXB0tfYoKunP623m+ldW41amhCTKuzicnDpQFMRfmdfxxRQkV
        k3lfgR1D2K4z8IMt/iabCDnSup383YuWV2lJfjNofBw+pLR32e+rk/pOyv4u14MdgCpJ7Z5TZFS
        /m1mm0W6QyfqP
X-Received: by 2002:a6b:d114:0:b0:763:dbe5:c718 with SMTP id l20-20020a6bd114000000b00763dbe5c718mr15591156iob.4.1683845626708;
        Thu, 11 May 2023 15:53:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6NpsbcWS7XZ9aFZG3gdKiUdWNMk/cpOIx9FFm5eawz2CJshDYRwOLNhc+7mffoLgJfbzTIKQ==
X-Received: by 2002:a6b:d114:0:b0:763:dbe5:c718 with SMTP id l20-20020a6bd114000000b00763dbe5c718mr15591139iob.4.1683845626383;
        Thu, 11 May 2023 15:53:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f66-20020a0284c8000000b0040380d7c768sm4748907jai.106.2023.05.11.15.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:53:45 -0700 (PDT)
Date:   Thu, 11 May 2023 16:53:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 3/3] vfio: Make the group FD disassociate from the
 iommu_group
Message-ID: <20230511165342.6fd5b04e.alex.williamson@redhat.com>
In-Reply-To: <3-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
References: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
        <3-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Oct 2022 11:04:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Allow the vfio_group struct to exist with a NULL iommu_group pointer. When
> the pointer is NULL the vfio_group users promise not to touch the
> iommu_group. This allows a driver to be hot unplugged while userspace is
> keeping the group FD open.
> 
> Remove all the code waiting for the group FD to close.
> 
> This fixes a userspace regression where we learned that virtnodedevd
> leaves a group FD open even though the /dev/ node for it has been deleted
> and all the drivers for it unplugged.
> 
> Fixes: ca5f21b25749 ("vfio: Follow a strict lifetime for struct iommu_group")
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Eric Farman <farman@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.h      |  1 -
>  drivers/vfio/vfio_main.c | 67 ++++++++++++++++++++++++++--------------
>  2 files changed, 44 insertions(+), 24 deletions(-)

I'm not sure we're out of the woods on this one.  QE found a regression
when unbinding a device assigned to a QEMU VM resulting in errors from
VFIO_UNMAP_DMA and VFIO_GROUP_UNSET_CONTAINER.

When finalizing the vfio object in QEMU, it will first release the
device and close the device fd before iterating the container address
space to do unmaps and finally unset the container for the group.

Meanwhile the vfio-pci remove callback is sitting in
vfio_device_put_registration() waiting for the device completion.  Once
that occurs, it enters vfio_device_remove_group() where this patch
removed the open file barrier that we can't have and also detaches the
group from the container, destroying the container.  The unmaps from
userspace were always redundant at this point since removing the last
device from a container removes the mappings and de-privileges the
container, but unmaps of nonexistent mappings didn't fail, nor did the
unset container operations.

None of these are hard failures for QEMU, the regression is that we're
logging new errors due to unintended changes to the API.  Do we need to
gut the container but still keep the group-container association?
Thanks,

Alex

> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 4a1bac1359a952..bcad54bbab08c4 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -59,7 +59,6 @@ struct vfio_group {
>  	struct mutex			group_lock;
>  	struct kvm			*kvm;
>  	struct file			*opened_file;
> -	struct swait_queue_head		opened_file_wait;
>  	struct blocking_notifier_head	notifier;
>  };
>  
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 911ee1abdff074..04099a839a52ad 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -133,6 +133,10 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
>  {
>  	struct vfio_group *group;
>  
> +	/*
> +	 * group->iommu_group from the vfio.group_list cannot be NULL
> +	 * under the vfio.group_lock.
> +	 */
>  	list_for_each_entry(group, &vfio.group_list, vfio_next) {
>  		if (group->iommu_group == iommu_group) {
>  			refcount_inc(&group->drivers);
> @@ -159,7 +163,7 @@ static void vfio_group_release(struct device *dev)
>  
>  	mutex_destroy(&group->device_lock);
>  	mutex_destroy(&group->group_lock);
> -	iommu_group_put(group->iommu_group);
> +	WARN_ON(group->iommu_group);
>  	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
>  	kfree(group);
>  }
> @@ -189,7 +193,6 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
>  
>  	refcount_set(&group->drivers, 1);
>  	mutex_init(&group->group_lock);
> -	init_swait_queue_head(&group->opened_file_wait);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	group->iommu_group = iommu_group;
> @@ -248,6 +251,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
>  static void vfio_device_remove_group(struct vfio_device *device)
>  {
>  	struct vfio_group *group = device->group;
> +	struct iommu_group *iommu_group;
>  
>  	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
>  		iommu_group_remove_device(device->dev);
> @@ -265,31 +269,29 @@ static void vfio_device_remove_group(struct vfio_device *device)
>  	 */
>  	cdev_device_del(&group->cdev, &group->dev);
>  
> -	/*
> -	 * Before we allow the last driver in the group to be unplugged the
> -	 * group must be sanitized so nothing else is or can reference it. This
> -	 * is because the group->iommu_group pointer should only be used so long
> -	 * as a device driver is attached to a device in the group.
> -	 */
> -	while (group->opened_file) {
> -		mutex_unlock(&vfio.group_lock);
> -		swait_event_idle_exclusive(group->opened_file_wait,
> -					   !group->opened_file);
> -		mutex_lock(&vfio.group_lock);
> -	}
> -	mutex_unlock(&vfio.group_lock);
> -
> +	mutex_lock(&group->group_lock);
>  	/*
>  	 * These data structures all have paired operations that can only be
> -	 * undone when the caller holds a live reference on the group. Since all
> -	 * pairs must be undone these WARN_ON's indicate some caller did not
> +	 * undone when the caller holds a live reference on the device. Since
> +	 * all pairs must be undone these WARN_ON's indicate some caller did not
>  	 * properly hold the group reference.
>  	 */
>  	WARN_ON(!list_empty(&group->device_list));
> -	WARN_ON(group->container || group->container_users);
>  	WARN_ON(group->notifier.head);
> +
> +	/*
> +	 * Revoke all users of group->iommu_group. At this point we know there
> +	 * are no devices active because we are unplugging the last one. Setting
> +	 * iommu_group to NULL blocks all new users.
> +	 */
> +	if (group->container)
> +		vfio_group_detach_container(group);
> +	iommu_group = group->iommu_group;
>  	group->iommu_group = NULL;
> +	mutex_unlock(&group->group_lock);
> +	mutex_unlock(&vfio.group_lock);
>  
> +	iommu_group_put(iommu_group);
>  	put_device(&group->dev);
>  }
>  
> @@ -531,6 +533,10 @@ static int __vfio_register_dev(struct vfio_device *device,
>  
>  	existing_device = vfio_group_get_device(group, device->dev);
>  	if (existing_device) {
> +		/*
> +		 * group->iommu_group is non-NULL because we hold the drivers
> +		 * refcount.
> +		 */
>  		dev_WARN(device->dev, "Device already exists on group %d\n",
>  			 iommu_group_id(group->iommu_group));
>  		vfio_device_put_registration(existing_device);
> @@ -702,6 +708,11 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  		ret = -EINVAL;
>  		goto out_unlock;
>  	}
> +	if (!group->iommu_group) {
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
>  	container = vfio_container_from_file(f.file);
>  	ret = -EINVAL;
>  	if (container) {
> @@ -862,6 +873,11 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
>  	status.flags = 0;
>  
>  	mutex_lock(&group->group_lock);
> +	if (!group->iommu_group) {
> +		mutex_unlock(&group->group_lock);
> +		return -ENODEV;
> +	}
> +
>  	if (group->container)
>  		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
>  				VFIO_GROUP_FLAGS_VIABLE;
> @@ -947,8 +963,6 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
>  		vfio_group_detach_container(group);
>  	group->opened_file = NULL;
>  	mutex_unlock(&group->group_lock);
> -	swake_up_one(&group->opened_file_wait);
> -
>  	return 0;
>  }
>  
> @@ -1559,14 +1573,21 @@ static const struct file_operations vfio_device_fops = {
>  struct iommu_group *vfio_file_iommu_group(struct file *file)
>  {
>  	struct vfio_group *group = file->private_data;
> +	struct iommu_group *iommu_group = NULL;
>  
>  	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
>  		return NULL;
>  
>  	if (!vfio_file_is_group(file))
>  		return NULL;
> -	iommu_group_ref_get(group->iommu_group);
> -	return group->iommu_group;
> +
> +	mutex_lock(&group->group_lock);
> +	if (group->iommu_group) {
> +		iommu_group = group->iommu_group;
> +		iommu_group_ref_get(iommu_group);
> +	}
> +	mutex_unlock(&group->group_lock);
> +	return iommu_group;
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
>  

