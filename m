Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A24E70CDA0
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjEVWQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjEVWQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:16:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFC8FE
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684793738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/wpX6oIs/hyRRACUSQVIZ8LfVgaDNLnjGaFoeGml7/c=;
        b=hcdmb/ItbsBuARkxaNN+Go0uzuRl7i3cTHfOZTMqfFRRdKvFhlDS5LpvUfrwmbs2H0v4EV
        JaR9F28ebi6l8AwCZVGm6IVfyYa57ic1aY9Av50naB9Jv+z6EnZUC6/9p+w2wVHrSS6BiH
        FG254oj+m7yQw5ukbINmTWS8/MIoHQM=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-nj_vBLNHMwSpsMby3WDk7w-1; Mon, 22 May 2023 18:15:37 -0400
X-MC-Unique: nj_vBLNHMwSpsMby3WDk7w-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3381af7e466so2148195ab.2
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684793736; x=1687385736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wpX6oIs/hyRRACUSQVIZ8LfVgaDNLnjGaFoeGml7/c=;
        b=QuvC4hSMn0dPfZmkoqTBlExXZCd8pblIMFwBdbrVE3FDuhb4KVMsJS3bN1Gl4TTkFx
         m0LOfnjFkkJLMLMwsp8omjK3cvA5030Ch5RzrE4dADP2iNYPtgUo8lqFzlqdxcIiu+de
         qXCyita9t5iFtVLFmLrh46DHS0nglITw4+UyR7U8hkF6keHaWl4Tz1spJBoRFyJbCUVY
         lMNjUXcH/UmF8kgRUzOjvnbgh70H6Mekdy3Nbj63MlKKKFzmweO8KeWgqyxG2snSuXMn
         IO5GnhXSupqbM8EMNPQ3xOB9+oWtXIEuUtWfHpJkFGwRNoV4PJMeEj2YS0hbfd81OZ/G
         JNSg==
X-Gm-Message-State: AC+VfDxCuquEAfXXTwc7gUoTnWsc2QEwtyuCh07mfyVoY00Jjwcevv3C
        JLNGAXOK7QBovr1iF3YeBu5MCJSd1DcGQMHHjE9SqgIZF59A+e5njs7skNv59vCQgUscJwNQlH6
        so/8e+WKBqjiB
X-Received: by 2002:a92:d301:0:b0:337:3577:2862 with SMTP id x1-20020a92d301000000b0033735772862mr6980749ila.16.1684793736238;
        Mon, 22 May 2023 15:15:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ55jCuKlbq3Ozr4tNWRn1NofklXnvZPB1Fi8hI05bjBLPnb/B4ra87IZXI1ZUIBlA4SWm9/2w==
X-Received: by 2002:a92:d301:0:b0:337:3577:2862 with SMTP id x1-20020a92d301000000b0033735772862mr6980731ila.16.1684793735820;
        Mon, 22 May 2023 15:15:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o4-20020a92c684000000b0033842c3f6b4sm2018805ilg.83.2023.05.22.15.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 15:15:35 -0700 (PDT)
Date:   Mon, 22 May 2023 16:15:34 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v11 20/23] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <20230522161534.32f3bf8e.alex.williamson@redhat.com>
In-Reply-To: <20230513132827.39066-21-yi.l.liu@intel.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-21-yi.l.liu@intel.com>
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

On Sat, 13 May 2023 06:28:24 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This adds ioctl for userspace to attach device cdev fd to and detach
> from IOAS/hw_pagetable managed by iommufd.
> 
>     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS, hw_pagetable
> 				   managed by iommufd. Attach can be
> 				   undo by VFIO_DEVICE_DETACH_IOMMUFD_PT
> 				   or device fd close.
>     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the current attached
> 				   IOAS or hw_pagetable managed by iommufd.
> 
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 66 ++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/iommufd.c     | 18 +++++++++++
>  drivers/vfio/vfio.h        | 18 +++++++++++
>  drivers/vfio/vfio_main.c   |  8 +++++
>  include/uapi/linux/vfio.h  | 52 ++++++++++++++++++++++++++++++
>  5 files changed, 162 insertions(+)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 291cc678a18b..3f14edb80a93 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -174,6 +174,72 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
>  	return ret;
>  }
>  
> +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> +			     struct vfio_device_attach_iommufd_pt __user *arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_attach_iommufd_pt attach;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> +
> +	if (copy_from_user(&attach, arg, minsz))
> +		return -EFAULT;
> +
> +	if (attach.argsz < minsz || attach.flags)
> +		return -EINVAL;
> +
> +	/* ATTACH only allowed for cdev fds */
> +	if (df->group)
> +		return -EINVAL;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	ret = vfio_iommufd_attach(device, &attach.pt_id);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = copy_to_user(&arg->pt_id, &attach.pt_id,
> +			   sizeof(attach.pt_id)) ? -EFAULT : 0;
> +	if (ret)
> +		goto out_detach;
> +	mutex_unlock(&device->dev_set->lock);
> +
> +	return 0;
> +
> +out_detach:
> +	vfio_iommufd_detach(device);
> +out_unlock:
> +	mutex_unlock(&device->dev_set->lock);
> +	return ret;
> +}
> +
> +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> +			     struct vfio_device_detach_iommufd_pt __user *arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_detach_iommufd_pt detach;
> +	unsigned long minsz;
> +
> +	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
> +
> +	if (copy_from_user(&detach, arg, minsz))
> +		return -EFAULT;
> +
> +	if (detach.argsz < minsz || detach.flags)
> +		return -EINVAL;
> +
> +	/* DETACH only allowed for cdev fds */
> +	if (df->group)
> +		return -EINVAL;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	vfio_iommufd_detach(device);
> +	mutex_unlock(&device->dev_set->lock);
> +
> +	return 0;
> +}
> +
>  static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
>  {
>  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 83575b65ea01..799ea322a7d4 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -112,6 +112,24 @@ void vfio_iommufd_unbind(struct vfio_device_file *df)
>  		vdev->ops->unbind_iommufd(vdev);
>  }
>  
> +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (vfio_device_is_noiommu(vdev))
> +		return 0;

Isn't this an invalid operation for a noiommu cdev, ie. -EINVAL?  We
return success and copy back the provided pt_id, why would a user not
consider it a bug that they can't use whatever value was there with
iommufd?

> +
> +	return vdev->ops->attach_ioas(vdev, pt_id);
> +}
> +
> +void vfio_iommufd_detach(struct vfio_device *vdev)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (!vfio_device_is_noiommu(vdev))
> +		vdev->ops->detach_ioas(vdev);
> +}
> +
>  struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
>  {
>  	if (vdev->iommufd_device)
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 8b359a7794be..50553f67600f 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -241,6 +241,8 @@ int vfio_iommufd_bind(struct vfio_device_file *df);
>  void vfio_iommufd_unbind(struct vfio_device_file *df);
>  int vfio_iommufd_compat_attach_ioas(struct vfio_device *device,
>  				    struct iommufd_ctx *ictx);
> +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id);
> +void vfio_iommufd_detach(struct vfio_device *vdev);
>  #else
>  static inline int
>  vfio_iommufd_compat_probe_noiommu(struct vfio_device *device,
> @@ -282,6 +284,10 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
>  void vfio_device_cdev_close(struct vfio_device_file *df);
>  long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
>  				    struct vfio_device_bind_iommufd __user *arg);
> +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> +			     struct vfio_device_attach_iommufd_pt __user *arg);
> +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> +			     struct vfio_device_detach_iommufd_pt __user *arg);
>  int vfio_cdev_init(struct class *device_class);
>  void vfio_cdev_cleanup(void);
>  #else
> @@ -315,6 +321,18 @@ static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int vfio_ioctl_device_attach(struct vfio_device_file *df,
> +					   struct vfio_device_attach_iommufd_pt __user *arg)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int vfio_ioctl_device_detach(struct vfio_device_file *df,
> +					   struct vfio_device_detach_iommufd_pt __user *arg)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline int vfio_cdev_init(struct class *device_class)
>  {
>  	return 0;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index c9fa39ac4b02..8c3f26b4929b 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1165,6 +1165,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  		ret = vfio_ioctl_device_feature(device, (void __user *)arg);
>  		break;
>  
> +	case VFIO_DEVICE_ATTACH_IOMMUFD_PT:
> +		ret = vfio_ioctl_device_attach(df, (void __user *)arg);
> +		break;
> +
> +	case VFIO_DEVICE_DETACH_IOMMUFD_PT:
> +		ret = vfio_ioctl_device_detach(df, (void __user *)arg);
> +		break;
> +
>  	default:
>  		if (unlikely(!device->ops->ioctl))
>  			ret = -EINVAL;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 07c917de31e9..770f5f949929 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -222,6 +222,58 @@ struct vfio_device_bind_iommufd {
>  
>  #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
>  
> +/*
> + * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
> + *					struct vfio_device_attach_iommufd_pt)
> + *
> + * Attach a vfio device to an iommufd address space specified by IOAS
> + * id or hw_pagetable (hwpt) id.
> + *
> + * Available only after a device has been bound to iommufd via
> + * VFIO_DEVICE_BIND_IOMMUFD
> + *
> + * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.
> + *
> + * @argsz:	User filled size of this data.
> + * @flags:	Must be 0.
> + * @pt_id:	Input the target id which can represent an ioas or a hwpt
> + *		allocated via iommufd subsystem.
> + *		Output the input ioas id or the attached hwpt id which could
> + *		be the specified hwpt itself or a hwpt automatically created
> + *		for the specified ioas by kernel during the attachment.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_attach_iommufd_pt {
> +	__u32	argsz;
> +	__u32	flags;
> +	__u32	pt_id;
> +};
> +
> +#define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)
> +
> +/*
> + * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 21,
> + *					struct vfio_device_detach_iommufd_pt)
> + *
> + * Detach a vfio device from the iommufd address space it has been
> + * attached to. After it, device should be in a blocking DMA state.
> + *
> + * Available only after a device has been bound to iommufd via
> + * VFIO_DEVICE_BIND_IOMMUFD.

These "[a]vailable only after" comments are meaningless, if the user
has the file descriptor the ioctl is available.  We can say that ATTACH
should be used after BIND to associate the device with an address space
within the bound iommufd and DETACH removes that association, but the
user is welcome to call everything in the wrong order and we need to be
prepared for that anyway.  Thanks,

Alex

> + *
> + * @argsz:	User filled size of this data.
> + * @flags:	Must be 0.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_detach_iommufd_pt {
> +	__u32	argsz;
> +	__u32	flags;
> +};
> +
> +#define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 21)
> +
>  /**
>   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
>   *						struct vfio_device_info)

