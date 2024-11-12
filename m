Return-Path: <kvm+bounces-31543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7049C4A97
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 01:22:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D7E4B34D89
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 00:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3315C70812;
	Tue, 12 Nov 2024 00:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KyQJOD2P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4444CB5B
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731369775; cv=none; b=BLKMOMnQnP8VoBLHObCywQyuHtexyWQFfWNhbG7Ox2TauljdcuFTcwjUpokbXjalfUDcQUoL4kg37A4RkBV/KPwEnWYkDv/lKTMKqPgUhJQFg+PoMLJOh0oKSrHCQEtp1NUWH0CK3UyrxJ471LUhAc5kygJikkjSmaa7SoDQgVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731369775; c=relaxed/simple;
	bh=cZAg2EqB75YimmfrEchTIw2jOo4pYMJs3Wb5upto+vs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdVSpztzQKEWv/KL4dJhlrE3pbPxVQrhRzXhSmeq4HmoX2UnuW3MnJNPW5IUXU6U31roPw/FniRHdpCliIUAM0cRg2gTIpZcPfD6+nEJwPlg4IX1Um2a9sJdj2c/9jKWsbdcaW+VOQaNuc2lLgxbLsw11JVLisz6MZ9GNPMgSe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KyQJOD2P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731369771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=89FIo7UvsDF/ZarI1D5bCpVmTGnFV24jt7G4dh9TRSM=;
	b=KyQJOD2PQVf56QORc10SFTWC3xWt9iQ36xS6ejPz1UoRuldvkPZOIl+PhxAaFnPRqw3VE1
	W0W+pxorjMm81lfMusPa9BwdhFSxb8ohFnC6WGcu8LOawLQzQk1jplKE+rk1/oB7XCpjJQ
	IPnI+Uxs9I4ZCZfDm9kjn/7pA0v6tyY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-oVeA8waAMqa1jnAJ0HnSpQ-1; Mon, 11 Nov 2024 19:02:50 -0500
X-MC-Unique: oVeA8waAMqa1jnAJ0HnSpQ-1
X-Mimecast-MFC-AGG-ID: oVeA8waAMqa1jnAJ0HnSpQ
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ab645ca84so2482839f.1
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 16:02:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731369770; x=1731974570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89FIo7UvsDF/ZarI1D5bCpVmTGnFV24jt7G4dh9TRSM=;
        b=E78JayWXMVYuBB6TxVEZJBQyZbUJzW3SHkjrNnXKBP9fhap4hv4BEvFPcu+ebY/Ors
         AlEn0hNC8oY68LjMajL3LGNaEQ/BkiUs6lm7sEu7Scs1DVS1W4bihLeB48g25Umj84pQ
         9ZzRtMy0aF0FyD4af3Rb8PkYjOROZ0MZzK4lyx4fpgLODm2cvofWWQdRYbc+wocgu6ZV
         1inyAAtgXzuP11EZ7oQiME9ElOg+Mk4Ms46RoGtEIIaBWxkEPbW2ZKV9FLIJvBdvcup7
         VWmmGlRikTX63qC1ES+RuSYmj9BZ2RufCwJnMDReVDXz0FxxGyjN3EmpmFDBzXQcvFKP
         DUxA==
X-Forwarded-Encrypted: i=1; AJvYcCWFmV8RZA0S7XNp/k91C/vaq6JkPRgQlOkTjn57fO6db8q/gCpGN3Etaxy5UD02//fyFlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMGDwVVmKKJMhIvBnIi5kPe1ffXB4MmE6zijhvMS+hywESOYml
	ADDKC6niQ+Cd8pfzNzC3faElxbbkDgUI0YOCuzhEfctYiuipXWlCmUftMEx44j4xxKofvJwgErd
	IwPu2CcdX+n1VRGWgg8BeDxLLK5LjcolV++6c0msuxJV8W7QyhA==
X-Received: by 2002:a05:6602:3fd0:b0:834:f671:4700 with SMTP id ca18e2360f4ac-83e032dcf6fmr414626739f.2.1731369769660;
        Mon, 11 Nov 2024 16:02:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEb5LaOUGQ2uXDY8SuNMZMHuGyDb1BHOJP88PZEUkgsKrJsKxKusrJK9EdeLkmtHR9+tZGpAg==
X-Received: by 2002:a05:6602:3fd0:b0:834:f671:4700 with SMTP id ca18e2360f4ac-83e032dcf6fmr414626339f.2.1731369769238;
        Mon, 11 Nov 2024 16:02:49 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83e1324af33sm152458839f.11.2024.11.11.16.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 16:02:48 -0800 (PST)
Date: Mon, 11 Nov 2024 17:02:47 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, baolu.lu@linux.intel.com,
 joro@8bytes.org, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v5 3/5] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
Message-ID: <20241111170247.01f5314e.alex.williamson@redhat.com>
In-Reply-To: <20241108121742.18889-4-yi.l.liu@intel.com>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
	<20241108121742.18889-4-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  8 Nov 2024 04:17:40 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
> a given pasid of a vfio device to/from an IOAS/HWPT.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 69 +++++++++++++++++++++++++++++++++-----
>  include/uapi/linux/vfio.h  | 29 ++++++++++------
>  2 files changed, 80 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index bb1817bd4ff3..4519f482e212 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -162,9 +162,9 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
>  int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  			    struct vfio_device_attach_iommufd_pt __user *arg)
>  {
> -	struct vfio_device *device = df->device;
>  	struct vfio_device_attach_iommufd_pt attach;
> -	unsigned long minsz;
> +	struct vfio_device *device = df->device;
> +	unsigned long minsz, xend = 0;
>  	int ret;
>  
>  	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> @@ -172,11 +172,38 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  	if (copy_from_user(&attach, arg, minsz))
>  		return -EFAULT;
>  
> -	if (attach.argsz < minsz || attach.flags)
> +	if (attach.argsz < minsz)
>  		return -EINVAL;
>  
> +	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
> +		return -EINVAL;
> +
> +	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
> +		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
> +
> +	/*
> +	 * xend may be equal to minsz if a flag is defined for reusing a
> +	 * reserved field or a special usage of an existing field.
> +	 */
> +	if (xend > minsz) {
> +		if (attach.argsz < xend)
> +			return -EINVAL;
> +
> +		if (copy_from_user((void *)&attach + minsz,
> +				   (void __user *)arg + minsz, xend - minsz))
> +			return -EFAULT;
> +	}
> +
> +	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
> +	    !device->ops->pasid_attach_ioas)
> +		return -EOPNOTSUPP;
> +
>  	mutex_lock(&device->dev_set->lock);
> -	ret = device->ops->attach_ioas(device, &attach.pt_id);
> +	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)

I'd just do the ops test here:
							{
		if (!device->ops->pasid_attach_ios)
			ret = -EOPNOTSUPP;
		else...

> +		ret = device->ops->pasid_attach_ioas(device, attach.pasid,
> +						     &attach.pt_id);

	} else {

(Obviously if we weren't about to generalize the prior chunk of code,
we'd test ops before the 2nd copy_from_user)  Thanks,

Alex

> +	else
> +		ret = device->ops->attach_ioas(device, &attach.pt_id);
>  	if (ret)
>  		goto out_unlock;
>  
> @@ -198,20 +225,46 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
>  			    struct vfio_device_detach_iommufd_pt __user *arg)
>  {
> -	struct vfio_device *device = df->device;
>  	struct vfio_device_detach_iommufd_pt detach;
> -	unsigned long minsz;
> +	struct vfio_device *device = df->device;
> +	unsigned long minsz, xend = 0;
>  
>  	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
>  
>  	if (copy_from_user(&detach, arg, minsz))
>  		return -EFAULT;
>  
> -	if (detach.argsz < minsz || detach.flags)
> +	if (detach.argsz < minsz)
> +		return -EINVAL;
> +
> +	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
>  		return -EINVAL;
>  
> +	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
> +		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
> +
> +	/*
> +	 * xend may be equal to minsz if a flag is defined for reusing a
> +	 * reserved field or a special usage of an existing field.
> +	 */
> +	if (xend > minsz) {
> +		if (detach.argsz < xend)
> +			return -EINVAL;
> +
> +		if (copy_from_user((void *)&detach + minsz,
> +				   (void __user *)arg + minsz, xend - minsz))
> +			return -EFAULT;
> +	}
> +
> +	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
> +	    !device->ops->pasid_detach_ioas)
> +		return -EOPNOTSUPP;
> +
>  	mutex_lock(&device->dev_set->lock);
> -	device->ops->detach_ioas(device);
> +	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
> +		device->ops->pasid_detach_ioas(device, detach.pasid);
> +	else
> +		device->ops->detach_ioas(device);
>  	mutex_unlock(&device->dev_set->lock);
>  
>  	return 0;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index c8dbf8219c4f..6899da70b929 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -931,29 +931,34 @@ struct vfio_device_bind_iommufd {
>   * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 19,
>   *					struct vfio_device_attach_iommufd_pt)
>   * @argsz:	User filled size of this data.
> - * @flags:	Must be 0.
> + * @flags:	Flags for attach.
>   * @pt_id:	Input the target id which can represent an ioas or a hwpt
>   *		allocated via iommufd subsystem.
>   *		Output the input ioas id or the attached hwpt id which could
>   *		be the specified hwpt itself or a hwpt automatically created
>   *		for the specified ioas by kernel during the attachment.
> + * @pasid:	The pasid to be attached, only meaningful when
> + *		VFIO_DEVICE_ATTACH_PASID is set in @flags
>   *
>   * Associate the device with an address space within the bound iommufd.
>   * Undo by VFIO_DEVICE_DETACH_IOMMUFD_PT or device fd close.  This is only
>   * allowed on cdev fds.
>   *
> - * If a vfio device is currently attached to a valid hw_pagetable, without doing
> - * a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl
> - * passing in another hw_pagetable (hwpt) id is allowed. This action, also known
> - * as a hw_pagetable replacement, will replace the device's currently attached
> - * hw_pagetable with a new hw_pagetable corresponding to the given pt_id.
> + * If a vfio device or a pasid of this device is currently attached to a valid
> + * hw_pagetable (hwpt), without doing a VFIO_DEVICE_DETACH_IOMMUFD_PT, a second
> + * VFIO_DEVICE_ATTACH_IOMMUFD_PT ioctl passing in another hwpt id is allowed.
> + * This action, also known as a hw_pagetable replacement, will replace the
> + * currently attached hwpt of the device or the pasid of this device with a new
> + * hwpt corresponding to the given pt_id.
>   *
>   * Return: 0 on success, -errno on failure.
>   */
>  struct vfio_device_attach_iommufd_pt {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_DEVICE_ATTACH_PASID	(1 << 0)
>  	__u32	pt_id;
> +	__u32	pasid;
>  };
>  
>  #define VFIO_DEVICE_ATTACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 19)
> @@ -962,17 +967,21 @@ struct vfio_device_attach_iommufd_pt {
>   * VFIO_DEVICE_DETACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE + 20,
>   *					struct vfio_device_detach_iommufd_pt)
>   * @argsz:	User filled size of this data.
> - * @flags:	Must be 0.
> + * @flags:	Flags for detach.
> + * @pasid:	The pasid to be detached, only meaningful when
> + *		VFIO_DEVICE_DETACH_PASID is set in @flags
>   *
> - * Remove the association of the device and its current associated address
> - * space.  After it, the device should be in a blocking DMA state.  This is only
> - * allowed on cdev fds.
> + * Remove the association of the device or a pasid of the device and its current
> + * associated address space.  After it, the device or the pasid should be in a
> + * blocking DMA state.  This is only allowed on cdev fds.
>   *
>   * Return: 0 on success, -errno on failure.
>   */
>  struct vfio_device_detach_iommufd_pt {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_DEVICE_DETACH_PASID	(1 << 0)
> +	__u32	pasid;
>  };
>  
>  #define VFIO_DEVICE_DETACH_IOMMUFD_PT		_IO(VFIO_TYPE, VFIO_BASE + 20)


