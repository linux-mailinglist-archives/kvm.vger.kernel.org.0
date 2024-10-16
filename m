Return-Path: <kvm+bounces-29010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7945B9A0F6A
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8293E1C2161C
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 16:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68CBA20FA84;
	Wed, 16 Oct 2024 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FdRsxKzR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8619208D95
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729095107; cv=none; b=nTnLsit3sFE+5KBZaR0gY5s4MnlE3oLGsqlZrb7IgYVAiGas9QRCxRSnK78//NIRIvJqJYMfxt5Ws1kuaxRmdOygBFY58gtROGtoFkQWNzI4CJmgvQNI1CHiHeh5D1Mc7dJ/8BoN+q+uzoUwpX61JyhasycBvDi/Bq13gO5Wr2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729095107; c=relaxed/simple;
	bh=ZJddraRpE2pxAFj6YJWK053D0DIiVolRxSMNqHcfirc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gs61AMLwOXSRpfgtiMH0LfMSG8cPm07VUgBCvd7giu5U3LGw7xHRVRHW8Oh3XycBEyYHcxtk0+gfHw1dmyUJbPwUN5GuOvSNgwN8D0NBQO1U4ZNINYM7Sj/OmT1qCQ7NmzJugSN9CTE3YU5j0m6WNRHJW5OGh+ZvlzebWj7ao6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FdRsxKzR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729095103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rRMfjAF57X/SMNhOCLh40ENkceq08n9jyoxHKXUNIME=;
	b=FdRsxKzR+FZmqPzw209OjN3gz0wtDYKukFVgC+CFzVbupFyfx1J5AERFsR6QJx2KtKXIDQ
	S0V7ymfzNCU76z+TVoxt/EcZrR7y0yqWkI5tVQ6SGBv1nrkfEtnhdynLo+F99TOKIg8mzc
	DE2YAXa20RX6BwHVTRKoKMvZ8oowpMY=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-_OMpTWlHOsyhXsZvsBwOeA-1; Wed, 16 Oct 2024 12:11:38 -0400
X-MC-Unique: _OMpTWlHOsyhXsZvsBwOeA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3b026f467so73715ab.2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 09:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729095097; x=1729699897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rRMfjAF57X/SMNhOCLh40ENkceq08n9jyoxHKXUNIME=;
        b=elrwshE8UkQVWHA9yd7SeueY37bsdDSAMRZweslY6foBD2y1FevivBu4ArQ1nqd9xD
         o8+qgNLGNTPYG3S2XfWxdZ2kA43fUgFja/CXyNISGpzwIoCmPwzWoXMusU7hqESqwAFh
         vbTHWmz0ULv4QhbNflAtAeix49D004v2J7Y7o8qTUKpLUheaQQIXIcJY7u5ZHuhX1BWO
         dSfSnGSVK2hWcVDYFSw6kTod/z31Opuu6m9h+VvepdwzEVXAvMLRE3Zt3HyA1CWdxwSp
         TwBy7NMlYNflMHZ87EB5szjB8y/MLHbAl90dHOC87oCmWS26nVmLLGHblumX7EU2JFGW
         WmYA==
X-Forwarded-Encrypted: i=1; AJvYcCU3GHqWKHBMX2WHnMBtximmkJ4xUGkkjtKdRFJtTfXKP6SNg1DC8ZrTMRSw+fkPIn+NpW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8FjJAOyeqhFoYr65cgXKkLYYy/brFnVK3tFo1S9ADue8uwfGL
	fJuFsUECfYuxx2HJ6u5VNhh9J/tm4qblAIMvGBbuDNYL0IkQAt6I/Z++cyjEWY0czjTp+SzNCKH
	dEBmKRKpE28OJC0vNrW6mWk8r7gUDDKvnT0WZvy7EU0YRAJMYvA==
X-Received: by 2002:a05:6e02:1c29:b0:3a1:f549:7290 with SMTP id e9e14a558f8ab-3a3b6081a7bmr45946595ab.6.1729095097152;
        Wed, 16 Oct 2024 09:11:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEh/7Dr6ZkhWvZq5ydO1Hmr+ALlfhIO2nfCJO3kMADakzeUcmW+0x6jUlunyH3mffBxiRVR7g==
X-Received: by 2002:a05:6e02:1c29:b0:3a1:f549:7290 with SMTP id e9e14a558f8ab-3a3b6081a7bmr45946525ab.6.1729095096688;
        Wed, 16 Oct 2024 09:11:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbecb3a53csm862401173.96.2024.10.16.09.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 09:11:36 -0700 (PDT)
Date: Wed, 16 Oct 2024 10:11:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "eric.auger@redhat.com"
 <eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: Re: [PATCH v3 3/4] vfio: Add
 VFIO_DEVICE_PASID_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <20241016101134.0e13f7d7.alex.williamson@redhat.com>
In-Reply-To: <e76e4dec-f4d7-4a69-a670-88a2f4e10dd7@intel.com>
References: <20240912131729.14951-1-yi.l.liu@intel.com>
	<20240912131729.14951-4-yi.l.liu@intel.com>
	<BN9PR11MB5276D2D0EEAC2904EDB60B048C762@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20241001121126.GC1365916@nvidia.com>
	<a435de20-2c25-46f5-a883-f10d425ef37e@intel.com>
	<20241014094911.46fba20e.alex.williamson@redhat.com>
	<2e5733a2-560e-4e8f-b547-ed75618afca5@intel.com>
	<20241015102215.05cd16c7.alex.williamson@redhat.com>
	<e76e4dec-f4d7-4a69-a670-88a2f4e10dd7@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Oct 2024 11:35:05 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/10/16 00:22, Alex Williamson wrote:
> > On Tue, 15 Oct 2024 19:07:52 +0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> >> On 2024/10/14 23:49, Alex Williamson wrote:  
> >>> On Sat, 12 Oct 2024 21:49:05 +0800
> >>> Yi Liu <yi.l.liu@intel.com> wrote:
> >>>      
> >>>> On 2024/10/1 20:11, Jason Gunthorpe wrote:  
> >>>>> On Mon, Sep 30, 2024 at 07:55:08AM +0000, Tian, Kevin wrote:
> >>>>>         
> >>>>>>> +struct vfio_device_pasid_attach_iommufd_pt {
> >>>>>>> +	__u32	argsz;
> >>>>>>> +	__u32	flags;
> >>>>>>> +	__u32	pasid;
> >>>>>>> +	__u32	pt_id;
> >>>>>>> +};
> >>>>>>> +
> >>>>>>> +#define VFIO_DEVICE_PASID_ATTACH_IOMMUFD_PT	_IO(VFIO_TYPE,
> >>>>>>> VFIO_BASE + 21)  
> >>>>>>
> >>>>>> Not sure whether this was discussed before. Does it make sense
> >>>>>> to reuse the existing VFIO_DEVICE_ATTACH_IOMMUFD_PT
> >>>>>> by introducing a new pasid field and a new flag bit?  
> >>>>>
> >>>>> Maybe? I don't have a strong feeling either way.
> >>>>>
> >>>>> There is somewhat less code if you reuse the ioctl at least  
> >>>>
> >>>> I had a rough memory that I was suggested to add a separate ioctl for
> >>>> PASID. Let's see Alex's opinion.  
> >>>
> >>> I don't recall any previous arguments for separate ioctls, but it seems
> >>> to make a lot of sense to me to extend the existing ioctls with a flag
> >>> to indicate pasid cscope and id.  Thanks,  
> >>
> >> thanks for the confirmation. How about the below?
> >>
> >> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> >> index bb1817bd4ff3..c78533bce3c6 100644
> >> --- a/drivers/vfio/device_cdev.c
> >> +++ b/drivers/vfio/device_cdev.c
> >> @@ -162,21 +162,34 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
> >>    int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
> >>    			    struct vfio_device_attach_iommufd_pt __user *arg)
> >>    {
> >> -	struct vfio_device *device = df->device;
> >> +	unsigned long minsz = offsetofend(
> >> +			struct vfio_device_attach_iommufd_pt, pt_id);
> >>    	struct vfio_device_attach_iommufd_pt attach;
> >> -	unsigned long minsz;
> >> +	struct vfio_device *device = df->device;
> >> +	u32 user_size;
> >>    	int ret;
> >>
> >> -	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> >> +	ret = get_user(user_size, (u32 __user *)arg);
> >> +	if (ret)
> >> +		return ret;
> >>
> >> -	if (copy_from_user(&attach, arg, minsz))
> >> -		return -EFAULT;
> >> +	ret = copy_struct_from_user(&attach, sizeof(attach), arg, user_size);
> >> +	if (ret)
> >> +		return ret;  
> > 
> > I think this could break current users.   
> 
> not quite get here. My understanding is as the below:
> 
> If the current user (compiled with the existing uapi struct), it will
> provide less data that the new kernel knows. The copy_struct_from_user()
> would zero the trailing bytes. And such user won't set the new flag, so
> it should be fine.

You're making an assumption that the user is passing exactly the
existing struct size as argsz, which is not a requirement.  The user
could allocate a buffer page, argsz might be 4K.
 
> So to me, the trailing bytes concern comes when user is compiled with the
> new uapi struct but running on an eld kernel (say <= 6.12).But the eld
> kernel uses copy_from_user(), so even there is non-zero trailing bytes in
> the user buffer, the eld kernel just ignores them. So this seems not an
> issue to me so far.

That's new userspace, old kernel.  I'm referencing an issue with old
userspace, new kernel, where old userspace has no requirement that
argsz is exactly the structure size, nor that the trailing bytes from
the structure size to argsz are zero'd.
 
> > For better or worse, we don't
> > currently have any requirements for the remainder of the user buffer,
> > whereas copy_struct_from_user() returns an error for non-zero trailing
> > bytes.  
> 
> This seems to be a general requirement when using copy_struct_from_user().
> User needs to zero the fields that it does not intend to use. If there is
> no such requirement for user, then the trailing bytes can be a concern in
> the future but not this time as the existing kernel uses copy_from_user().

Exactly, the current implementation makes no requirement on trailing
non-zero bytes, copy_struct_from_user() does.
 
> > I think we need to monotonically increase the structure size,
> > but maybe something more like below, using flags.  The expectation
> > would be that if we add another flag that extends the structure, we'd
> > test that flag after PASID and clobber xend to a new value further into
> > the new structure.  We'd also add that flag to the flags mask, but we'd
> > share the copy code.  
> 
> agree, this share code might be needed for other path as well. Some macros
> I guess.
> 
> > 
> > 	if (attach.argsz < minsz)
> > 		return -EINVAL;
> > 
> > 	if (attach.flags & (~VFIO_DEVICE_ATTACH_PASID))
> > 		return -EINVAL;
> > 
> > 	if (attach.flags & VFIO_DEVICE_ATTACH_PASID)
> > 		xend = offsetofend(struct vfio_device_attach_iommufd_pt, pasid);
> > 
> > 	if (xend) {
> > 		if (attach.argsz < xend)
> > 			return -EINVAL;
> > 	
> > 		if (copy_from_user((void *)&attach + minsz,
> > 				    (void __user *)arg + minsz, xend - minsz))
> > 			return -EFAULT;
> > 	}  
> 
> I think it might need to zero the trailing bytes if the user does not set
> the extended flag. is it?

We could zero initialize the attach structure for safety, but the kernel
side code should also be driven by flags.  We should never look at a
field beyond the base structure that isn't indicated by flags and copied
from the user.

> > Maybe there are still more elegant options available.
> > 
> > We also generally try to label flags with FLAGS in the name, but it
> > does get rather unwieldy, so I'm open to suggestions.  Thanks,  
> 
> There is already examples that new field added to a kernel-to-user uapi
> struct like the vfio_region_info::cap_offset and
> vfio_device_info::cap_offset. But it might be a little bit different
> with the case we face here as it's user-to-kernel struct. It's a time for
> you to set a rule for such extensions. :)

That's a returned structure, so it's a bit different, but the same
philosophy, we don't break userspace.  In that case we used argsz as an
output field and flags to indicate there are capabilities.  Old
userspace ignores the flag and argsz semantics and continues to work.
New userspace checks the flag, reallocs the buffer with argsz and
retries.  This is however an example of userspace providing an argsz
value that exceeds the ioctl structure, with no requirement to zero the
buffer, though it is an output structure rather than the input
structure here.

I think the same holds here, our policy is to not break userspace.  We
potentially do break userspace if we impose a requirement that the
trailing buffer size must now be zero.  We have the flags field so that
we don't need to blindly base the structure version on the size of the
user buffer.  We should use the flags field to determine relevant and
valid fields beyond the base structure without imposing new
requirements to userspace.  Thanks,

Alex


