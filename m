Return-Path: <kvm+bounces-30570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 055549BBF1F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 22:00:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8891281028
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 21:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00EC91F6664;
	Mon,  4 Nov 2024 21:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MhApvu0B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EBD18DF8F
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730754029; cv=none; b=qfaP11ymxqqqsUqlXZzfs0uEpoaqtIfcmhmTpfDugGfYjmuwosV8mSV/kCDEFCA5nBJL6syoj7IdhSibcinV0vXHOLmF4gUv5cjEcbvUEQn73Wz6fTF4UAFMpzQcB0eikLfZg3ZgxvApdnjm6ZZozL4q0ApnyEUYAQwz3Qphgqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730754029; c=relaxed/simple;
	bh=fH9DOcZIN6KrouwJ4Na0nIH8hwy6801OQVEMkB3+8/E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/wEj6KTbehSbUbOeZYDiTRHCVEw9WkrZpZmH7IyMqOmdCwhYFQJ9Mnk9nPFHUMeGj3qfahxmKdWyt2GLlRM1VFW06TrIt/bVSvvXbRejysdhjG5F02UtlNeQkRsPWOuUqWCUfr8RvrwVmcsvDL7lwzaBqtKIzg6D0beMhl5OWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MhApvu0B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730754026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0kJxxRCCEfEbeQIwL5Mxw8/qanc3RzewdzQ6otXVf4=;
	b=MhApvu0BI1gUuQvTfwPIeFiVXWYoyqmyHCFxcn+Lbn8gKrKDAaewBql9+JFR2xgKVtT0f1
	TQuElYyyagLp6yDGu9SY4sAombbpj0BzKcpN1yWIMCtesULW5yf4ZC3b03g6GI4yNhKoUm
	s8v7pzNMPS31NEtP9iTpxc9/7hyvJ5E=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-eTMwratpN_6tzlFIgxyqFA-1; Mon, 04 Nov 2024 16:00:25 -0500
X-MC-Unique: eTMwratpN_6tzlFIgxyqFA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83aab538da1so28884339f.3
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 13:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730754024; x=1731358824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W0kJxxRCCEfEbeQIwL5Mxw8/qanc3RzewdzQ6otXVf4=;
        b=DMqf9OfVH8dAMV9lHLJeEYG8ndqq4ognr4KwvCwjnd/novbkPgZuR2R3dN9EQHczSa
         Z0Zs/PLiEIAwz5vic+OTosn7nDLLiQlxO6JJ+vowkxGbUiW3O4iN/9puDexjHj3gCiqn
         4pEeCOPbhkEqfatU7la2q2qF04EIjQa5fxP3G4UVPauY8G9SlMUgMhRQ/0kTs6jfXlso
         FgRIUxRG1CIfG67RqDDcKW/7EBV/2XA691gG53Psos+idLu55JAUEecBeCNCFrU2k9WZ
         BdvqVNry2XHNtLWYSmNsky6F3xTDOcD6DFt3EEwy9t1rVS+2EfzFkpMTl8ApnfO9Syoz
         so9g==
X-Forwarded-Encrypted: i=1; AJvYcCUuFPZv4I1jjGvC24+amoa/n0Ci/KC8u45AleJcvr8FzfX6YO1cuz0xOHCc49aIrGOfZWs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn2Z+RbtOgZPZMojG/I7+ngViCi0G+pULHBBW26ZN708pjtJ31
	sz+g+Z9Kr/KibzH4uysUCE/Ya/ry1CUJO093ail6+GxSnVnydxMawhnFwaJuFDWBVxA5baofFnd
	WbjLjBV52P/Xq7Bw4DcW3Y/d0MD/2o30lJiDPTjJE9P7jvnUjBQ==
X-Received: by 2002:a05:6e02:b2d:b0:3a6:ac17:13e3 with SMTP id e9e14a558f8ab-3a6ac1717famr46511105ab.7.1730754023808;
        Mon, 04 Nov 2024 13:00:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbxfUphMg8cgfql51cfo+wxy0qNwJ/yuahw0BRYmuZKEcAns6NGqXZ57E+yi9YGoh/pdar+g==
X-Received: by 2002:a05:6e02:b2d:b0:3a6:ac17:13e3 with SMTP id e9e14a558f8ab-3a6ac1717famr46510805ab.7.1730754023138;
        Mon, 04 Nov 2024 13:00:23 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de048be972sm2117119173.45.2024.11.04.13.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 13:00:22 -0800 (PST)
Date: Mon, 4 Nov 2024 14:00:20 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
 eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 baolu.lu@linux.intel.com, zhenzhong.duan@intel.com, vasant.hegde@amd.com,
 willy@infradead.org
Subject: Re: [PATCH v4 3/4] vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support
 pasid
Message-ID: <20241104140020.2c98173d.alex.williamson@redhat.com>
In-Reply-To: <20241104132732.16759-4-yi.l.liu@intel.com>
References: <20241104132732.16759-1-yi.l.liu@intel.com>
	<20241104132732.16759-4-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  4 Nov 2024 05:27:31 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This extends the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT ioctls to attach/detach
> a given pasid of a vfio device to/from an IOAS/HWPT.
> 
> vfio_copy_from_user() is added to copy the user data for the case in which
> the existing user struct has introduced new fields. The rule is not breaking
> the existing usersapce. The kernel only copies the new fields when the
> corresponding flag is set by the userspace. For the case that has multiple
> new fields marked by different flags, kernel checks the flags one by one to
> get the correct size to copy besides the minsz. Such logics can be shared by
> the other uapi extensions, hence add a helper for it.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 62 +++++++++++++++++++++++++++-----------
>  drivers/vfio/vfio.h        | 18 +++++++++++
>  drivers/vfio/vfio_main.c   | 55 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h  | 29 ++++++++++++------
>  4 files changed, 136 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index bb1817bd4ff3..bd13ddbfb9e3 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -159,24 +159,44 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
>  	vfio_device_unblock_group(device);
>  }
>  
> +#define VFIO_ATTACH_FLAGS_MASK VFIO_DEVICE_ATTACH_PASID
> +static unsigned long
> +vfio_attach_xends[ilog2(VFIO_ATTACH_FLAGS_MASK) + 1] = {
> +	XEND_SIZE(VFIO_DEVICE_ATTACH_PASID,
> +		  struct vfio_device_attach_iommufd_pt, pasid),
> +};
> +
> +#define VFIO_DETACH_FLAGS_MASK VFIO_DEVICE_DETACH_PASID
> +static unsigned long
> +vfio_detach_xends[ilog2(VFIO_DETACH_FLAGS_MASK) + 1] = {
> +	XEND_SIZE(VFIO_DEVICE_DETACH_PASID,
> +		  struct vfio_device_detach_iommufd_pt, pasid),
> +};

Doesn't this rather imply that every valid flag bit indicates some new
structure field?

For example, we start out with:

struct vfio_device_attach_iommufd_pt {
        __u32   argsz;
        __u32   flags;
        __u32   pt_id;
};

And then here it becomes:

struct vfio_device_attach_iommufd_pt {
	__u32	argsz;
	__u32	flags;
#define VFIO_DEVICE_ATTACH_PASID	(1 << 0)
	__u32	pt_id;
	__u32	pasid;
};

What if the next flag is simply related to the processing of @pt_id and
doesn't require @pasid?

The xend array necessarily expands, but what's the value?  Logically it
would be offsetofend(, pt_id), so the array becomes { 16, 12 }.

Similarly, rather than pasid we might have reused a previously
reserved field, for instance what if we already expanded the structure
as:

struct vfio_device_attach_iommufd_pt {
	__u32	argsz;
	__u32	flags;
#define VFIO_DEVICE_ATTACH_FOO		(1 << 0)
	__u32	pt_id;
	__u32	reserved;
	__u64	foo;
};

If we then want to add @pasid, we might really prefer to take advantage
of that reserved field and the array becomes { 24, 16 }.

I think these can work (see below), but this seems like a pretty
complicated generalization.  It might make sense to initially open code
the handling for @pasid with a follow-on patch with this sort of
generalization so we can evaluate them separately.

BTW, don't feel obligated to use "xend" based on my email sample code.

> +
>  int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  			    struct vfio_device_attach_iommufd_pt __user *arg)
>  {
> -	struct vfio_device *device = df->device;
>  	struct vfio_device_attach_iommufd_pt attach;
> -	unsigned long minsz;
> +	struct vfio_device *device = df->device;
>  	int ret;
>  
> -	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> -
> -	if (copy_from_user(&attach, arg, minsz))
> -		return -EFAULT;
> +	ret = VFIO_COPY_USER_DATA((void __user *)arg, &attach,
> +				  struct vfio_device_attach_iommufd_pt,
> +				  pt_id, VFIO_ATTACH_FLAGS_MASK,
> +				  vfio_attach_xends);
> +	if (ret)
> +		return ret;
>  
> -	if (attach.argsz < minsz || attach.flags)
> -		return -EINVAL;
> +	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
> +	    !device->ops->pasid_attach_ioas)
> +		return -EOPNOTSUPP;
>  
>  	mutex_lock(&device->dev_set->lock);
> -	ret = device->ops->attach_ioas(device, &attach.pt_id);
> +	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
> +		ret = device->ops->pasid_attach_ioas(device, attach.pasid,
> +						     &attach.pt_id);
> +	else
> +		ret = device->ops->attach_ioas(device, &attach.pt_id);
>  	if (ret)
>  		goto out_unlock;
>  
> @@ -198,20 +218,26 @@ int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
>  			    struct vfio_device_detach_iommufd_pt __user *arg)
>  {
> -	struct vfio_device *device = df->device;
>  	struct vfio_device_detach_iommufd_pt detach;
> -	unsigned long minsz;
> -
> -	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
> +	struct vfio_device *device = df->device;
> +	int ret;
>  
> -	if (copy_from_user(&detach, arg, minsz))
> -		return -EFAULT;
> +	ret = VFIO_COPY_USER_DATA((void __user *)arg, &detach,
> +				  struct vfio_device_detach_iommufd_pt,
> +				  flags, VFIO_DETACH_FLAGS_MASK,
> +				  vfio_detach_xends);
> +	if (ret)
> +		return ret;
>  
> -	if (detach.argsz < minsz || detach.flags)
> -		return -EINVAL;
> +	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
> +	    !device->ops->pasid_detach_ioas)
> +		return -EOPNOTSUPP;
>  
>  	mutex_lock(&device->dev_set->lock);
> -	device->ops->detach_ioas(device);
> +	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
> +		device->ops->pasid_detach_ioas(device, detach.pasid);
> +	else
> +		device->ops->detach_ioas(device);
>  	mutex_unlock(&device->dev_set->lock);
>  
>  	return 0;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 50128da18bca..9f081cf01c5a 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -34,6 +34,24 @@ void vfio_df_close(struct vfio_device_file *df);
>  struct vfio_device_file *
>  vfio_allocate_device_file(struct vfio_device *device);
>  
> +int vfio_copy_from_user(void *buffer, void __user *arg,
> +			unsigned long minsz, u32 flags_mask,
> +			unsigned long *xend_array);
> +
> +#define VFIO_COPY_USER_DATA(_arg, _local_buffer, _struct, _min_last,          \
> +			    _flags_mask, _xend_array)                         \
> +	vfio_copy_from_user(_local_buffer, _arg,                              \
> +			    offsetofend(_struct, _min_last) +                \
> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, argsz) !=     \
> +					      0) +                            \
> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, flags) !=     \
> +					      sizeof(u32)),                   \
> +			    _flags_mask, _xend_array)

We have a precedence in vfio_alloc_device() that macros wrapping
functions don't need to be all caps.

> +
> +#define XEND_SIZE(_flag, _struct, _xlast)                                    \
> +	[ilog2(_flag)] = offsetofend(_struct, _xlast) +                      \
> +			 BUILD_BUG_ON_ZERO(_flag == 0)                       \
> +
>  extern const struct file_operations vfio_device_fops;
>  
>  #ifdef CONFIG_VFIO_NOIOMMU
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a5a62d9d963f..7df94bf121fd 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1694,6 +1694,61 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
>  }
>  EXPORT_SYMBOL(vfio_dma_rw);
>  
> +/**
> + * vfio_copy_from_user - Copy the user struct that may have extended fields
> + *
> + * @buffer: The local buffer to store the data copied from user
> + * @arg: The user buffer pointer
> + * @minsz: The minimum size of the user struct, it should never bump up.
> + * @flags_mask: The combination of all the falgs defined
> + * @xend_array: The array that stores the xend size for set flags.
> + *
> + * This helper requires the user struct put the argsz and flags fields in
> + * the first 8 bytes.
> + *
> + * Return 0 for success, otherwise -errno
> + */
> +int vfio_copy_from_user(void *buffer, void __user *arg,
> +			unsigned long minsz, u32 flags_mask,
> +			unsigned long *xend_array)
> +{
> +	unsigned long xend = 0;
> +	struct user_header {
> +		u32 argsz;
> +		u32 flags;
> +	} *header;
> +	unsigned long flags;
> +	u32 flag;
> +
> +	if (copy_from_user(buffer, arg, minsz))
> +		return -EFAULT;
> +
> +	header = (struct user_header *)buffer;
> +	if (header->argsz < minsz)
> +		return -EINVAL;
> +
> +	if (header->flags & ~flags_mask)
> +		return -EINVAL;
> +
> +	/* Loop each set flag to decide the xend */
> +	flags = header->flags;
> +	for_each_set_bit(flag, &flags, BITS_PER_LONG) {

I suppose it doesn't matter, but there's a logical inconsistency
searching BITS_PER_LONG on a buffer initialized by a u32.

> +		if (xend_array[flag])

Given the earlier concern, this should be:

		if (xend_array[flags] > xend)

Thanks,
Alex

> +			xend = xend_array[flag];
> +	}
> +
> +	if (xend) {
> +		if (header->argsz < xend)
> +			return -EINVAL;
> +
> +		if (copy_from_user(buffer + minsz,
> +				   arg + minsz, xend - minsz))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Module/class support
>   */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2b68e6cdf190..40b414e642f5 100644
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


