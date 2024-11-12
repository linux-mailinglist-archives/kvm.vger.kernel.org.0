Return-Path: <kvm+bounces-31617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA0B9C5992
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 14:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2DDE284BD6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 13:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFC01FBF62;
	Tue, 12 Nov 2024 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxO7OBU/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191FE1FBF47
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731419583; cv=none; b=koOxsMtrNN2kJ0UAcZzXmd4Zk66kSURFNk3MI5zmcY7d+rQljSzWAF6s6cvb9FYvjHUXq4uzk8zBp0Pa1mvrSSfYMz1Ah1lSd9ItNbflDQB1R/J52JgdyD7OCLyb5cGJ9fkBZBH2/EttQs3xbCKh1NLPERP2OiJq07/cntWg1qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731419583; c=relaxed/simple;
	bh=V6yiW1tA/Vf1d7UcjF7fOH3K4lhcWLGlFdgl2ctgBBo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qkX8153tNzrLYqjrrQvF44BuYl+Bu6iaOYu63lWFpy1kCbU4K3Q2CIfMxoiSoY//JK492cTTlj+M4iD3KXo+qwe5ObNsabuqRr1a/9oHBqB7CZ+aUuqp+Fki2R3KZhr1FjK58mZgLc57dkIFqDKGHzW3kAQNZPXp/nWNPQgmbss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CxO7OBU/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731419579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uVVPebOMyw8PeCCIM/obk2duSlCqD0RAMp9QPje7aYI=;
	b=CxO7OBU/IOTpDOQq53FQfNCunHL2nBLonsfYvNAvC6u8pcAXTKCIrRWg4bzR91fxyo4vbG
	VJaU9t6ZwonEpgTzer7avSKnttFRXSAY1QKrsG/Evd2z0IXrp4W25e0VKMFT26pd9uPLVX
	Ha9y82600nzBYJGBmHY/M3jVGjltmhc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-2wceStghMBaa36ZuuuD-sA-1; Tue, 12 Nov 2024 08:52:58 -0500
X-MC-Unique: 2wceStghMBaa36ZuuuD-sA-1
X-Mimecast-MFC-AGG-ID: 2wceStghMBaa36ZuuuD-sA
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ab645ca84so12715739f.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 05:52:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731419578; x=1732024378;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uVVPebOMyw8PeCCIM/obk2duSlCqD0RAMp9QPje7aYI=;
        b=EoAEWfqtLUGceDKRAUo+8kTtUgygWCFSAiomBIYoDUn21lSy/cSfZn/c/VmJQeNGBa
         YkZhyKgD94ljXrIJ1pG5gJM3Q8c/PcgTbN9Rxeq2Rdo1Z7WftnqeE075L5NsSDY0Nggb
         XoVSNyK0TFbi3dCrp23Vi9cYSWbhmmkgiJwPK9ZNvdncQVQIwNJAdRoQr/vaB4HuNpIj
         hUiav91k2Cm/MQPgCemXUIw0l1x5z5iEo+5GP/Ux9RujyGwdcsS4pWUCBOLaAYil2/bW
         Zmst3sCngvtgs2zrMPG4e+L1PVkuzRTTy8dUHj5+PNcmOWq6ZcOA9VUaJYw4s1dmikS+
         pN2w==
X-Forwarded-Encrypted: i=1; AJvYcCWsn92kG3/hrRSQHEf6pmz61/YVksrfnCXo4z62n/O3DXEZVhCG4weytd1q1v+QHmgs37E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi3b9eoqGTAmKtnfpqE/u+4RCDyacAz2nzqSf537Qwk+eaY3nD
	PIcr8sUEvIeNkjPKlPtjEKFj5yy6Lk85mG+iF+w0uMXjPH6mJ1sSeNM5HM5WSai/G2BlTu/FRb9
	jJ39Y82MpKPuBRtTuOvafEED4KM7jDdRWJ3mB4idPMY6KyBt4bg==
X-Received: by 2002:a05:6602:3cd:b0:83a:aa8c:4ebb with SMTP id ca18e2360f4ac-83e03080cf2mr478869839f.0.1731419577761;
        Tue, 12 Nov 2024 05:52:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIsjFDYc7xopH7PVnzIYwlmU6ZR1g8mFi12p18JraFK0rAztCtbc+uh6c0uZ2JHVEuHaUA9Q==
X-Received: by 2002:a05:6602:3cd:b0:83a:aa8c:4ebb with SMTP id ca18e2360f4ac-83e03080cf2mr478867839f.0.1731419577160;
        Tue, 12 Nov 2024 05:52:57 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de7870a22esm1929974173.8.2024.11.12.05.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 05:52:56 -0800 (PST)
Date: Tue, 12 Nov 2024 06:52:53 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: <jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
 <joro@8bytes.org>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
 <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
 <iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>,
 <vasant.hegde@amd.com>, <will@kernel.org>
Subject: Re: [PATCH v5 4/5] vfio: Add vfio_copy_user_data()
Message-ID: <20241112065253.6c9a38ac.alex.williamson@redhat.com>
In-Reply-To: <9d88a9b9-eeb5-49e5-9c59-e3b82336f3a6@intel.com>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
	<20241108121742.18889-5-yi.l.liu@intel.com>
	<20241111170308.0a14160f.alex.williamson@redhat.com>
	<9d88a9b9-eeb5-49e5-9c59-e3b82336f3a6@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Nov 2024 17:18:02 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/11/12 08:03, Alex Williamson wrote:
> > On Fri,  8 Nov 2024 04:17:41 -0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> >> This generalizes the logic of copying user data when the user struct
> >> Have new fields introduced. The helpers can be used by the vfio uapis
> >> that have the argsz and flags fields in the beginning 8 bytes.
> >>
> >> As an example, the vfio_device_{at|de}tach_iommufd_pt paths are updated
> >> to use the helpers.
> >>
> >> The flags may be defined to mark a new field in the structure, reuse
> >> reserved fields, or special handling of an existing field. The extended
> >> size would differ for different flags. Each user API that wants to use
> >> the generalized helpers should define an array to store the corresponding
> >> extended sizes for each defined flag.
> >>
> >> For example, we start out with the below, minsz is 12.
> >>
> >>    struct vfio_foo_struct {
> >>    	__u32   argsz;
> >>    	__u32   flags;
> >>    	__u32   pt_id;
> >>    };
> >>
> >> And then here it becomes:
> >>
> >>    struct vfio_foo_struct {
> >>    	__u32   argsz;
> >>    	__u32   flags;
> >>    #define VFIO_FOO_STRUCT_PASID   (1 << 0)
> >>    	__u32   pt_id;
> >>    	__u32   pasid;
> >>    };
> >>
> >> The array is { 16 }.
> >>
> >> If the next flag is simply related to the processing of @pt_id and
> >> doesn't require @pasid, then the extended size of the new flag is
> >> 12. The array become { 16, 12 }
> >>
> >>    struct vfio_foo_struct {
> >>    	__u32   argsz;
> >>    	__u32   flags;
> >>    #define VFIO_FOO_STRUCT_PASID   (1 << 0)
> >>    #define VFIO_FOO_STRUCT_SPECICAL_PTID   (1 << 1)
> >>    	__u32   pt_id;
> >>    	__u32   pasid;
> >>    };
> >>
> >> Similarly, rather than adding new field, we might have reused a previously
> >> reserved field, for instance what if we already expanded the structure
> >> as the below, array is already { 24 }.
> >>
> >>    struct vfio_foo_struct {
> >>    	__u32   argsz;
> >>    	__u32   flags;
> >>    #define VFIO_FOO_STRUCT_XXX     (1 << 0)
> >>    	__u32   pt_id;
> >>    	__u32   reserved;
> >>    	__u64   xxx;
> >>    };
> >>
> >> If we then want to add @pasid, we might really prefer to take advantage
> >> of that reserved field and the array becomes { 24, 16 }.
> >>
> >>    struct vfio_foo_struct {
> >>    	__u32   argsz;
> >>    	__u32   flags;
> >>    #define VFIO_FOO_STRUCT_XXX     (1 << 0)
> >>    #define VFIO_FOO_STRUCT_PASID   (1 << 1)
> >>    	__u32   pt_id;
> >>    	__u32   reserved;  
> > 
> > I think this was supposed to be s/reserved/pasid/  
> 
> you are right.
> 
> >>    	__u64   xxx;
> >>    };
> >>
> >> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> >> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> >> ---
> >>   drivers/vfio/device_cdev.c | 81 +++++++++++++-------------------------
> >>   drivers/vfio/vfio.h        | 18 +++++++++
> >>   drivers/vfio/vfio_main.c   | 55 ++++++++++++++++++++++++++
> >>   3 files changed, 100 insertions(+), 54 deletions(-)
> >>
> >> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> >> index 4519f482e212..35c7664b9a97 100644
> >> --- a/drivers/vfio/device_cdev.c
> >> +++ b/drivers/vfio/device_cdev.c
> >> @@ -159,40 +159,33 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
> >>   	vfio_device_unblock_group(device);
> >>   }
> >>   
> >> +#define VFIO_ATTACH_FLAGS_MASK VFIO_DEVICE_ATTACH_PASID
> >> +static unsigned long
> >> +vfio_attach_xends[ilog2(VFIO_ATTACH_FLAGS_MASK) + 1] = {
> >> +	XEND_SIZE(VFIO_DEVICE_ATTACH_PASID,
> >> +		  struct vfio_device_attach_iommufd_pt, pasid),
> >> +};
> >> +
> >> +#define VFIO_DETACH_FLAGS_MASK VFIO_DEVICE_DETACH_PASID
> >> +static unsigned long
> >> +vfio_detach_xends[ilog2(VFIO_DETACH_FLAGS_MASK) + 1] = {
> >> +	XEND_SIZE(VFIO_DEVICE_DETACH_PASID,
> >> +		  struct vfio_device_detach_iommufd_pt, pasid),
> >> +};
> >> +
> >>   int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
> >>   			    struct vfio_device_attach_iommufd_pt __user *arg)
> >>   {
> >>   	struct vfio_device_attach_iommufd_pt attach;
> >>   	struct vfio_device *device = df->device;
> >> -	unsigned long minsz, xend = 0;
> >>   	int ret;
> >>   
> >> -	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> >> -
> >> -	if (copy_from_user(&attach, arg, minsz))
> >> -		return -EFAULT;
> >> -
> >> -	if (attach.argsz < minsz)
> >> -		return -EINVAL;
> >> -
> >> -	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
> >> -		return -EINVAL;
> >> -
> >> -	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
> >> -		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
> >> -
> >> -	/*
> >> -	 * xend may be equal to minsz if a flag is defined for reusing a
> >> -	 * reserved field or a special usage of an existing field.
> >> -	 */
> >> -	if (xend > minsz) {
> >> -		if (attach.argsz < xend)
> >> -			return -EINVAL;
> >> -
> >> -		if (copy_from_user((void *)&attach + minsz,
> >> -				   (void __user *)arg + minsz, xend - minsz))
> >> -			return -EFAULT;
> >> -	}
> >> +	ret = vfio_copy_user_data((void __user *)arg, &attach,
> >> +				  struct vfio_device_attach_iommufd_pt,
> >> +				  pt_id, VFIO_ATTACH_FLAGS_MASK,
> >> +				  vfio_attach_xends);
> >> +	if (ret)
> >> +		return ret;
> >>   
> >>   	if ((attach.flags & VFIO_DEVICE_ATTACH_PASID) &&
> >>   	    !device->ops->pasid_attach_ioas)
> >> @@ -227,34 +220,14 @@ int vfio_df_ioctl_detach_pt(struct vfio_device_file *df,
> >>   {
> >>   	struct vfio_device_detach_iommufd_pt detach;
> >>   	struct vfio_device *device = df->device;
> >> -	unsigned long minsz, xend = 0;
> >> -
> >> -	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
> >> -
> >> -	if (copy_from_user(&detach, arg, minsz))
> >> -		return -EFAULT;
> >> -
> >> -	if (detach.argsz < minsz)
> >> -		return -EINVAL;
> >> -
> >> -	if (detach.flags & (~VFIO_DEVICE_DETACH_PASID))
> >> -		return -EINVAL;
> >> -
> >> -	if (detach.flags & VFIO_DEVICE_DETACH_PASID)
> >> -		xend = offsetofend(struct vfio_device_detach_iommufd_pt, pasid);
> >> -
> >> -	/*
> >> -	 * xend may be equal to minsz if a flag is defined for reusing a
> >> -	 * reserved field or a special usage of an existing field.
> >> -	 */
> >> -	if (xend > minsz) {
> >> -		if (detach.argsz < xend)
> >> -			return -EINVAL;
> >> +	int ret;
> >>   
> >> -		if (copy_from_user((void *)&detach + minsz,
> >> -				   (void __user *)arg + minsz, xend - minsz))
> >> -			return -EFAULT;
> >> -	}
> >> +	ret = vfio_copy_user_data((void __user *)arg, &detach,
> >> +				  struct vfio_device_detach_iommufd_pt,
> >> +				  flags, VFIO_DETACH_FLAGS_MASK,
> >> +				  vfio_detach_xends);
> >> +	if (ret)
> >> +		return ret;
> >>   
> >>   	if ((detach.flags & VFIO_DEVICE_DETACH_PASID) &&
> >>   	    !device->ops->pasid_detach_ioas)
> >> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> >> index 50128da18bca..87bed550c46e 100644
> >> --- a/drivers/vfio/vfio.h
> >> +++ b/drivers/vfio/vfio.h
> >> @@ -34,6 +34,24 @@ void vfio_df_close(struct vfio_device_file *df);
> >>   struct vfio_device_file *
> >>   vfio_allocate_device_file(struct vfio_device *device);
> >>   
> >> +int vfio_copy_from_user(void *buffer, void __user *arg,
> >> +			unsigned long minsz, u32 flags_mask,
> >> +			unsigned long *xend_array);
> >> +
> >> +#define vfio_copy_user_data(_arg, _local_buffer, _struct, _min_last,          \
> >> +			    _flags_mask, _xend_array)                         \
> >> +	vfio_copy_from_user(_local_buffer, _arg,                              \
> >> +			    offsetofend(_struct, _min_last) +                \
> >> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, argsz) !=     \
> >> +					      0) +                            \
> >> +			    BUILD_BUG_ON_ZERO(offsetof(_struct, flags) !=     \
> >> +					      sizeof(u32)),                   \
> >> +			    _flags_mask, _xend_array)
> >> +
> >> +#define XEND_SIZE(_flag, _struct, _xlast)                                    \
> >> +	[ilog2(_flag)] = offsetofend(_struct, _xlast) +                      \
> >> +			 BUILD_BUG_ON_ZERO(_flag == 0)                       \
> >> +
> >>   extern const struct file_operations vfio_device_fops;
> >>   
> >>   #ifdef CONFIG_VFIO_NOIOMMU
> >> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> >> index a5a62d9d963f..c61336ea5123 100644
> >> --- a/drivers/vfio/vfio_main.c
> >> +++ b/drivers/vfio/vfio_main.c
> >> @@ -1694,6 +1694,61 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
> >>   }
> >>   EXPORT_SYMBOL(vfio_dma_rw);
> >>   
> >> +/**
> >> + * vfio_copy_from_user - Copy the user struct that may have extended fields
> >> + *
> >> + * @buffer: The local buffer to store the data copied from user
> >> + * @arg: The user buffer pointer
> >> + * @minsz: The minimum size of the user struct
> >> + * @flags_mask: The combination of all the falgs defined
> >> + * @xend_array: The array that stores the xend size for set flags.
> >> + *
> >> + * This helper requires the user struct put the argsz and flags fields in
> >> + * the first 8 bytes.
> >> + *
> >> + * Return 0 for success, otherwise -errno
> >> + */
> >> +int vfio_copy_from_user(void *buffer, void __user *arg,  
> > 
> > This should probably be prefixed with an underscore and note that
> > callers should use the wrapper function to impose the parameter
> > checking.  
> 
> got it.
> 
> >   
> >> +			unsigned long minsz, u32 flags_mask,
> >> +			unsigned long *xend_array)
> >> +{
> >> +	unsigned long xend = minsz;
> >> +	struct user_header {
> >> +		u32 argsz;
> >> +		u32 flags;
> >> +	} *header;
> >> +	unsigned long flags;
> >> +	u32 flag;
> >> +
> >> +	if (copy_from_user(buffer, arg, minsz))
> >> +		return -EFAULT;
> >> +
> >> +	header = (struct user_header *)buffer;
> >> +	if (header->argsz < minsz)
> >> +		return -EINVAL;
> >> +
> >> +	if (header->flags & ~flags_mask)
> >> +		return -EINVAL;  
> > 
> > I'm already wrestling with whether this is an over engineered solution
> > to remove a couple dozen lines of mostly duplicate logic between attach
> > and detach, but a couple points that could make it more versatile:
> > 
> > (1) Test xend_array here:
> > 
> > 	if (!xend_array)
> > 		return 0;  
> 
> Perhaps we should return error if the header->flags has any bit set. Such
> cases require a valid xend_array.

I don't think that's true.  For example if we want to drop this into
existing cases where the structure size has not expanded and flags are
used for other things, I don't think we want the overhead of declaring
an xend_array.

> > (2) Return ssize_t/-errno for the caller to know the resulting copy
> > size.
> >   
> >> +
> >> +	/* Loop each set flag to decide the xend */
> >> +	flags = header->flags;
> >> +	for_each_set_bit(flag, &flags, BITS_PER_TYPE(u32)) {
> >> +		if (xend_array[flag] > xend)
> >> +			xend = xend_array[flag];  
> > 
> > Can we craft a BUILD_BUG in the wrapper to test that xend_array is at
> > least long enough to match the highest bit in flags?  Thanks,  
> 
> yes. I would add a BUILD_BUG like the below.
> 
> BUILD_BUG_ON(ARRAY_SIZE(_xend_array) < ilog2(_flags_mask));

So this would need to account that _xend_array can be NULL regardless
of _flags_mask.  Thanks,

Alex 


