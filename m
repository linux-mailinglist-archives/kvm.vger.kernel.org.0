Return-Path: <kvm+bounces-61805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72481C2ADFA
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:54:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D13D1892BD3
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD5E92FABF9;
	Mon,  3 Nov 2025 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sUA4uFzh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AF62F9DBB
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762163634; cv=none; b=UaYFxdxyncWDJG7Mq2qxzX2vVSfXA7hlI5IccM9JW9RR2v1H5UHFI247vJhblh1cj3/Qjde9zzYNhkBRt3IJs+ptwWV2S1IRw951h0ZP0/r5t9WBWUWbTR2PXzilmAAZCi5d4qsaqtzOpiafX6mPDl3uP67QRDZCfcDs9tZIlmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762163634; c=relaxed/simple;
	bh=N52BuQPS4ZYwLzXT/a19PEi5ZrFoF956jOdQxPeM1SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9FfD22J8XIIvZmnGsJGj/Pmb/Khlxjp+gKE3YywjbZ3D6LzOIU+lA1XrFbCVURighLSg2JByoWkFvaapP5i+eRx6kJkXAF0h0ZidsyViyO2m+1YsGhg7/AzLAVm0/3gRH3uoou0h65an7rdHd/MVN3PoJrh+pbSje+gpUdb8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sUA4uFzh; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47105bbb8d9so71525e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 01:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762163629; x=1762768429; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D423dPTmNpGJKcSjJTsDfI/X/hTMvomXahsqpyIMTdY=;
        b=sUA4uFzhNzTtwWdpZgkH/lKVT5+d2KmSMmlqn7G8tL4S1dx3OJK9ks5O+C4mRDSr06
         50z8bN0MnM7z1mbvzab8H1ayiPvzb4l6B6kEaNOHWudOCBwHdzj9+NUrgln+2FutOdKz
         QHwRAw/VaeeuXg3JyaJTaObAFom4A/ls0pvDot9qNbeN7mVMv/QGnv0ahgLvqjATSgP4
         Db1LcY0xsvvAxVoXVzmtZRV6lI6ZoAguIf2K9UFocLNPcBuFGGwi8pcsIDJmGg9s/Vvc
         Vj26lvhvCFWU7ZI7qG5hcRkNpiGgeJYupGesHUKbneVwADnhQwAn1t4WRjfgfVwZfYZO
         OQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762163629; x=1762768429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D423dPTmNpGJKcSjJTsDfI/X/hTMvomXahsqpyIMTdY=;
        b=BXtp/Pl1zfT26PpAO+KmHlk9I3lJEbz8kXQfZe0q2ZFs7NJr+e2JMGAX18VyGwrrXt
         2dsVfo32v1Z5bpCv/XkLv1lzEM/lZXgW6i1GMrPvgG3m2ds8Zni95hd1BqopN85wSNM8
         kLbXXTmuzh38I5kgEroEsetpr35VoaatBC7MwS4FBOqWAg/RlNjjXhocNf2Aq/MYVlia
         wKwVXTuYWk+zpbBmDFNZgOOSv/AGypsO/U0UNGTl1OCE2ngy7lEBUtDVmmYdc49VAGcy
         INsE0Q/uLBxnQMV6BS5dOEK7T24eZLNzlkdLNRjspOYHERIchoKkj9kTc+fomqT3HzsA
         gNKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4RWiDJ5snidi391w3onY2eOy+e/JsKXlQQGFqfvXCKwavHXq/jPVwwdFyDY4SjX19yrE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqg5hO/M0dH7lnWH1x3RF1JWucAZyYl5vTwH+roXadSZ5MKDSu
	7dIQxiGa1u891VmfHu2TabRi/PDwijXaAKQ7QGbvqA6ergpTWfwgSAJu8ieIEFb/nQ==
X-Gm-Gg: ASbGncv6Ih3w2RQj3t6k1Mwbr5Y0GESZTIBn7SZLG6c6LwHTCcHkxJnqawuUAC12YSs
	LLNWrYXCBgOT1D28PorBVMukKrd41bH2AvZnPbDnr+AfdK610yrKEIYPGR/iYm2bKV5iIh1spiQ
	SqmZ8IoZjeHGD3rdX1GfuVASu4f/dga55fQ24Od8D0u4FgUOp1TFHnmIEvsTsJpl3DsUCIrjBxe
	viQb51h5EWw5MoIVpOSKyr1d/A9cpS3h8SbeuVfbsJ+6L8wncjnb1mR6V5XvrbkZSNFyXAOG6Bv
	zJ/8AanKuM3seh5P3og8XmU18JGTwZlpZWI8c+84rRFaBg60xd+uFsAJaJW5KQ2UtpDpChDIEl7
	nmiUR5ggpiidgjCH1z1lW7UEgqK6QROboPWHCh9fBNg44OC5KB47DrwC4dXUwzCWh4TyrWjqWEH
	s6+dxt46s/xMloMVf28zERp0ePO0/UMVu3BfVy/OG+EHntpx9De5XZCCF2iGkn
X-Google-Smtp-Source: AGHT+IGPSKpaT0Ddsg2x/WOeGEJojnpupEDLfdcNfDHxyjySRpAR+bkp9FY0Epu5UNDkS8vExhWcRA==
X-Received: by 2002:a05:600c:8711:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-4773cdce892mr7221205e9.2.1762163629307;
        Mon, 03 Nov 2025 01:53:49 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c374f84sm144508145e9.0.2025.11.03.01.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 01:53:48 -0800 (PST)
Date: Mon, 3 Nov 2025 09:53:45 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Pranjal Shrivastava <praan@google.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 09/22] vfio/platform: Provide a get_region_info op
Message-ID: <aQh7qbe_lcNysroo@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:23PM -0300, Jason Gunthorpe wrote:
> Move it out of vfio_platform_ioctl() and re-indent it. Add it to all
> platform drivers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/vfio/platform/vfio_amba.c             |  1 +
>  drivers/vfio/platform/vfio_platform.c         |  1 +
>  drivers/vfio/platform/vfio_platform_common.c  | 50 +++++++++++--------
>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>  4 files changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index 9f5c527baa8a36..d600deaf23b6d7 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -115,6 +115,7 @@ static const struct vfio_device_ops vfio_amba_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> +	.get_region_info = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 512533501eb7f3..0e85c914b65105 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -101,6 +101,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> +	.get_region_info = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 3bf1043cd7957c..3ebd50fb78fbb7 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -272,6 +272,34 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_open_device);
>  
> +int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					struct vfio_region_info __user *arg)
> +{
> +	struct vfio_platform_device *vdev =
> +		container_of(core_vdev, struct vfio_platform_device, vdev);
> +	struct vfio_region_info info;
> +	unsigned long minsz;
> +
> +	minsz = offsetofend(struct vfio_region_info, offset);
> +
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	if (info.index >= vdev->num_regions)
> +		return -EINVAL;
> +
> +	/* map offset to the physical address  */
> +	info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> +	info.size = vdev->regions[info.index].size;
> +	info.flags = vdev->regions[info.index].flags;
> +
> +	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_platform_ioctl_get_region_info);
> +
>  long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  			 unsigned int cmd, unsigned long arg)
>  {
> @@ -300,28 +328,6 @@ long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
>  
> -	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> -		struct vfio_region_info info;
> -
> -		minsz = offsetofend(struct vfio_region_info, offset);
> -
> -		if (copy_from_user(&info, (void __user *)arg, minsz))
> -			return -EFAULT;
> -
> -		if (info.argsz < minsz)
> -			return -EINVAL;
> -
> -		if (info.index >= vdev->num_regions)
> -			return -EINVAL;
> -
> -		/* map offset to the physical address  */
> -		info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> -		info.size = vdev->regions[info.index].size;
> -		info.flags = vdev->regions[info.index].flags;
> -
> -		return copy_to_user((void __user *)arg, &info, minsz) ?
> -			-EFAULT : 0;
> -
>  	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>  		struct vfio_irq_info info;
>  
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 8d8fab51684909..a6008320e77bae 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -85,6 +85,8 @@ int vfio_platform_open_device(struct vfio_device *core_vdev);
>  void vfio_platform_close_device(struct vfio_device *core_vdev);
>  long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  			 unsigned int cmd, unsigned long arg);
> +int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					struct vfio_region_info __user *arg);
>  ssize_t vfio_platform_read(struct vfio_device *core_vdev,
>  			   char __user *buf, size_t count,
>  			   loff_t *ppos);
> -- 
> 2.43.0
> 

