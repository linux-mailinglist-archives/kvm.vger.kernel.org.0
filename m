Return-Path: <kvm+bounces-31544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D219C4AAD
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 01:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49706B34F19
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 00:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D298F4C98;
	Tue, 12 Nov 2024 00:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XIVDq/KO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0D23FC2
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 00:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731369798; cv=none; b=q6C2MXA5PuWH3oyHPN5XcAhfRbOAhfMaK42T2Ci87HktEowGeIAxscCvWwugm2LeqxWvHj7U8+Z/6SbGikTKD+fqAk2kRbBW3mi+3jrTw6nbqrVcuEsWwzdko7KeqN5LzPQtGR58/IRGUpaPEKeQzNs94F0T7Zff4p1ks9hYRJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731369798; c=relaxed/simple;
	bh=LnXyPKY2IyZxYBCdDm3Lz+iKuwOmQlzw6lO505QTA64=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEmzFQ9i/xFo3/UsF8F1IfWeL5Krn7ZbDUY4ZzHzFO/LELkEBICHujdyqrIdJNqE+oyNZWKETEAoRVJOzAEKFZzhD9lFCPjaoHX9bNX9r42RnhD3Zf4Md2h/OMFSeNLoInUN6H0ZAaJ7Ld09CdbCtk2EGw6Ueel9HfE/MaEL0yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XIVDq/KO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731369793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3pBdOWCPRmncVQk4ueck/gairwtTj/00dz1e3lH3oI=;
	b=XIVDq/KOPc/pOJ5y1uv5XN9Bfu+vgiLgrzW7myigPDzCH+FfT3xoy7PxWaYcnUq3bSXMU/
	T8sI4aL/pwoTGenxw7EDMhsfuxidSt7r8kQD1+kcrlJX0K304WWjUGTIT6r755gwDhR+MY
	/74gEWZpCKFjtyRMxs/O4eCWEFG4fWk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-p7ghzvsXM4SPk9J9wcNBCg-1; Mon, 11 Nov 2024 19:03:11 -0500
X-MC-Unique: p7ghzvsXM4SPk9J9wcNBCg-1
X-Mimecast-MFC-AGG-ID: p7ghzvsXM4SPk9J9wcNBCg
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ac0a1c419so28439439f.2
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 16:03:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731369791; x=1731974591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3pBdOWCPRmncVQk4ueck/gairwtTj/00dz1e3lH3oI=;
        b=eHCOI70a6O0LQlpm5fkWVUM83EdpbEwKVPMNTMvLOmn/Wa5ACQYeoeG8QZB1jh5uHb
         7ydTTTStW0ydilz+xVwG1T5XR8owIXBbYP3Vy9xgNZimMu5itoEtKJ3AOW2/sqQmFLle
         jAjc4UlaOWJPVDNfhfxpxpHSZFsArzxqwA3HgC1pLgHxgjjwDfx3pbPZRThwUl6ISgqS
         7wWgHWJWe1knORLwqcUX+f3a4ZMw3oHkZr7zwo9t9Sk9zUefv9xBpXtWssXQuCP5K4q6
         G45csVbAE4q1Ajhuo/8n+KGf8blAMKqXyqPfXqgcv0mNWoG9UU6GvQf9nOVKcRflPFXz
         c/iA==
X-Forwarded-Encrypted: i=1; AJvYcCWgOuKK4YeEpbnLvWPnnofhvy1mbXr4p1XA4S4dWEyi0hLQadeDOU4VAlOg87lJkS7euRw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWPSdV6T4ugJV63Vjo+2tr/r7OQCYFq/D+E0NkIVy/9vjg+61P
	I8TOam7zAiesqBTyJRyV+7dK0Ij5EIJ16fXM4W2xvND2b2mnAQ7+HFN5JeZ4lpT58TSB269M3M3
	Vz2S8wnv7G0Yen3iFqeexT6IDenJteStN1Gf1VK4EnDjCN4J9Gg==
X-Received: by 2002:a05:6e02:1fc9:b0:3a0:9c8e:9647 with SMTP id e9e14a558f8ab-3a6f198ae93mr44116285ab.1.1731369790786;
        Mon, 11 Nov 2024 16:03:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFSfv9JNmgETpx4sRcFf2+uMjT/XRUSwgIK+TUgZlYDRMx0/JaQ+HFFjfQsVdnrQsm/GKYoxg==
X-Received: by 2002:a05:6e02:1fc9:b0:3a0:9c8e:9647 with SMTP id e9e14a558f8ab-3a6f198ae93mr44116095ab.1.1731369790191;
        Mon, 11 Nov 2024 16:03:10 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6f98437b9sm17573635ab.38.2024.11.11.16.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 16:03:09 -0800 (PST)
Date: Mon, 11 Nov 2024 17:03:08 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, baolu.lu@linux.intel.com,
 joro@8bytes.org, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v5 4/5] vfio: Add vfio_copy_user_data()
Message-ID: <20241111170308.0a14160f.alex.williamson@redhat.com>
In-Reply-To: <20241108121742.18889-5-yi.l.liu@intel.com>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
	<20241108121742.18889-5-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  8 Nov 2024 04:17:41 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This generalizes the logic of copying user data when the user struct
> Have new fields introduced. The helpers can be used by the vfio uapis
> that have the argsz and flags fields in the beginning 8 bytes.
> 
> As an example, the vfio_device_{at|de}tach_iommufd_pt paths are updated
> to use the helpers.
> 
> The flags may be defined to mark a new field in the structure, reuse
> reserved fields, or special handling of an existing field. The extended
> size would differ for different flags. Each user API that wants to use
> the generalized helpers should define an array to store the corresponding
> extended sizes for each defined flag.
> 
> For example, we start out with the below, minsz is 12.
> 
>   struct vfio_foo_struct {
>   	__u32   argsz;
>   	__u32   flags;
>   	__u32   pt_id;
>   };
> 
> And then here it becomes:
> 
>   struct vfio_foo_struct {
>   	__u32   argsz;
>   	__u32   flags;
>   #define VFIO_FOO_STRUCT_PASID   (1 << 0)
>   	__u32   pt_id;
>   	__u32   pasid;
>   };
> 
> The array is { 16 }.
> 
> If the next flag is simply related to the processing of @pt_id and
> doesn't require @pasid, then the extended size of the new flag is
> 12. The array become { 16, 12 }
> 
>   struct vfio_foo_struct {
>   	__u32   argsz;
>   	__u32   flags;
>   #define VFIO_FOO_STRUCT_PASID   (1 << 0)
>   #define VFIO_FOO_STRUCT_SPECICAL_PTID   (1 << 1)
>   	__u32   pt_id;
>   	__u32   pasid;
>   };
> 
> Similarly, rather than adding new field, we might have reused a previously
> reserved field, for instance what if we already expanded the structure
> as the below, array is already { 24 }.
> 
>   struct vfio_foo_struct {
>   	__u32   argsz;
>   	__u32   flags;
>   #define VFIO_FOO_STRUCT_XXX     (1 << 0)
>   	__u32   pt_id;
>   	__u32   reserved;
>   	__u64   xxx;
>   };
> 
> If we then want to add @pasid, we might really prefer to take advantage
> of that reserved field and the array becomes { 24, 16 }.
> 
>   struct vfio_foo_struct {
>   	__u32   argsz;
>   	__u32   flags;
>   #define VFIO_FOO_STRUCT_XXX     (1 << 0)
>   #define VFIO_FOO_STRUCT_PASID   (1 << 1)
>   	__u32   pt_id;
>   	__u32   reserved;

I think this was supposed to be s/reserved/pasid/

>   	__u64   xxx;
>   };
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 81 +++++++++++++-------------------------
>  drivers/vfio/vfio.h        | 18 +++++++++
>  drivers/vfio/vfio_main.c   | 55 ++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 4519f482e212..35c7664b9a97 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -159,40 +159,33 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
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
> +
>  int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
>  			    struct vfio_device_attach_iommufd_pt __user *arg)
>  {
>  	struct vfio_device_attach_iommufd_pt attach;
>  	struct vfio_device *device = df->device;
> -	unsigned long minsz, xend = 0;
>  	int ret;
>  
> -	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> -
> -	if (copy_from_user(&attach, arg, minsz))
> -		return -EFAULT;
> -
> -	if (attach.argsz < minsz)
> -		return -EINVAL;
> -
> -	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
> -		return -EINVAL;
> -
> -	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
> -		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
> -
> -	/*
> -	 * xend may be equal to minsz if a flag is defined for reusing a
> -	 * reserved field or a special usage of an existing field.
> -	 */
> -	if (xend > minsz) {
> -		if (attach.argsz < xend)
> -			return -EINVAL;
> -
> -		if (copy_from_user((void *)&attach + minsz,
> -				   (void __user *)arg + minsz, xend - minsz))
> -			return -EFAULT;
> -	}
> +	ret = vfio_copy_user_data((void __user *)arg, &attach,
> +				  struct vfio_device_attach_iommufd_pt,
> +				  pt_id, VFIO_ATTACH_FLAGS_MASK,
> +				  vfio_attach_xends);
> +	if (ret)
> +		return ret;
>  
>  	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
>  	    !device->ops->pasid_attach_ioas)
> @@ -227,34 +220,14 @@ int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
>  {
>  	struct vfio_device_detach_iommufd_pt detach;
>  	struct vfio_device *device = df->device;
> -	unsigned long minsz, xend = 0;
> -
> -	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
> -
> -	if (copy_from_user(&detach, arg, minsz))
> -		return -EFAULT;
> -
> -	if (detach.argsz < minsz)
> -		return -EINVAL;
> -
> -	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
> -		return -EINVAL;
> -
> -	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
> -		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
> -
> -	/*
> -	 * xend may be equal to minsz if a flag is defined for reusing a
> -	 * reserved field or a special usage of an existing field.
> -	 */
> -	if (xend > minsz) {
> -		if (detach.argsz < xend)
> -			return -EINVAL;
> +	int ret;
>  
> -		if (copy_from_user((void *)&detach + minsz,
> -				   (void __user *)arg + minsz, xend - minsz))
> -			return -EFAULT;
> -	}
> +	ret = vfio_copy_user_data((void __user *)arg, &detach,
> +				  struct vfio_device_detach_iommufd_pt,
> +				  flags, VFIO_DETACH_FLAGS_MASK,
> +				  vfio_detach_xends);
> +	if (ret)
> +		return ret;
>  
>  	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
>  	    !device->ops->pasid_detach_ioas)
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 50128da18bca..87bed550c46e 100644
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
> +#define vfio_copy_user_data(_arg, _local_buffer, _struct, _min_last,          \
> +			    _flags_mask, _xend_array)                         \
> +	vfio_copy_from_user(_local_buffer, _arg,                              \
> +			    offsetofend(_struct, _min_last) +                \
> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, argsz) !=     \
> +					      0) +                            \
> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, flags) !=     \
> +					      sizeof(u32)),                   \
> +			    _flags_mask, _xend_array)
> +
> +#define XEND_SIZE(_flag, _struct, _xlast)                                    \
> +	[ilog2(_flag)] = offsetofend(_struct, _xlast) +                      \
> +			 BUILD_BUG_ON_ZERO(_flag == 0)                       \
> +
>  extern const struct file_operations vfio_device_fops;
>  
>  #ifdef CONFIG_VFIO_NOIOMMU
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a5a62d9d963f..c61336ea5123 100644
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
> + * @minsz: The minimum size of the user struct
> + * @flags_mask: The combination of all the falgs defined
> + * @xend_array: The array that stores the xend size for set flags.
> + *
> + * This helper requires the user struct put the argsz and flags fields in
> + * the first 8 bytes.
> + *
> + * Return 0 for success, otherwise -errno
> + */
> +int vfio_copy_from_user(void *buffer, void __user *arg,

This should probably be prefixed with an underscore and note that
callers should use the wrapper function to impose the parameter
checking.

> +			unsigned long minsz, u32 flags_mask,
> +			unsigned long *xend_array)
> +{
> +	unsigned long xend = minsz;
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

I'm already wrestling with whether this is an over engineered solution
to remove a couple dozen lines of mostly duplicate logic between attach
and detach, but a couple points that could make it more versatile:

(1) Test xend_array here:

	if (!xend_array)
		return 0;

(2) Return ssize_t/-errno for the caller to know the resulting copy
size.

> +
> +	/* Loop each set flag to decide the xend */
> +	flags = header->flags;
> +	for_each_set_bit(flag, &flags, BITS_PER_TYPE(u32)) {
> +		if (xend_array[flag] > xend)
> +			xend = xend_array[flag];

Can we craft a BUILD_BUG in the wrapper to test that xend_array is at
least long enough to match the highest bit in flags?  Thanks,

Alex

> +	}
> +
> +	if (xend > minsz) {
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


