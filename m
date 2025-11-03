Return-Path: <kvm+bounces-61807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7162CC2AE34
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 10:58:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 229631890E97
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 09:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF36A2FABF7;
	Mon,  3 Nov 2025 09:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i1s4PZDN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C972F9DBC
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762163864; cv=none; b=hpr2iUWt4ISDBeChVJSDdGLooJdMf/M3IkI4RIrFwZ3y6th6lWqZbVML7r6ogrqtQO9znKd6DQOomXVyzdTHa50O3HalKJgOb4P0lu3jowtrwyCj6b2N47uYMaEBnNByWFPx1OeidAhcfOoanLiTe2S7jVmYxDNLZLfweoMz2fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762163864; c=relaxed/simple;
	bh=j9P0kJvHthnqO2tx4rHoHS+OgDbwMwn9qSk75uLg2Os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlLZqfHUnE6ORClVMzER5fAFMTqX51Snpb748idvXA4TzoKp2Q7BiEgSHRFNjme0S9BusfJddM39gnQJVg7NlFBD7E9nym/4SSs+McOvAzu9zgAcRfqtMYLt4Lk6bkVJYII09vQq+PDVRg3VlSVVQYFN6DG3ZH0XgAIKz280Itk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i1s4PZDN; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47105bbb8d9so72405e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 01:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762163860; x=1762768660; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Gxg1uZruJtA4YMzZuNynPGAWW8m9xdZihRPr7yINg8=;
        b=i1s4PZDNPFKv5xSnn/nHd5sHoQjnIsCEpx3eh/92JMdLsQWLpInFrT+o3hfxth5esU
         aPOJfsyc9xth674t/eQ5Z1dhuqfWbxBGMYmqigs0nzSdFjjw/xlNJmNha4P/ciqMrwie
         G7JbAfgemqUnwfDiFSvxpaixCtlDBIi8An0hnSUHWUjUhxYqiXyWlQuugmwddqlzkiPA
         kbxTfLieVCF43J0qniegKcYpWiSP6SwtbwkDysJefLloP/HVclfovUoR6j+Mkj7CTMWI
         zXZ4+tb/TDzgRLg+w3/1DpjU8/DzB+QHZeLqHvqCiQBYJDBRibg2Kzrz1VbL3s9cAIQx
         u7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762163860; x=1762768660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Gxg1uZruJtA4YMzZuNynPGAWW8m9xdZihRPr7yINg8=;
        b=iN/IdmZzY8zgKlkxasYl84Hyf4tyD/7hfq5MSyMIQx+celyP4tBmWAu6wRhdrTnMxZ
         p5V8EDBm7MvjBxG9gDEetnAa6VUmFl6hAOYUA1gA2M/d1KS4kzFds4p2HmtAMShBQXLG
         WWrpMTAh3jbJAdBMu4JByYzVUCuGuB5IqRcTlaPN+tHWHgY1ikGAwRPbCnKjTfvPWqT7
         qliru2xGCJfpITRyl1iZR6DjuJYDL74Rblt5n9yu18L1/Bb+hZqjdl6b3nCVyyy3ekTh
         UFBNDM8KV6q3VYMq15BYoZOb3adkyaBbGz6aNUB4RX1GMjSQzbdnTUWo8swcCztlnrUV
         MItg==
X-Forwarded-Encrypted: i=1; AJvYcCVrpakvrj471pONxg/t47MRTbQIYwyc/R/Bc5MB+mj96GZnnO8jFxknRuB4YkEH/rcdd4Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV4pyZtbplSzUc93NfqeBitzi9iOM90awZHHmIlGvT9kURKn9Y
	8qNAvR1CxyAbRU+By3PbL800P7VM71I3an0ikIwumSt8C0RrUV62BTunpZiBGL1Rjg==
X-Gm-Gg: ASbGncsIzPbEUNlxu8gbTEm9upkwDP5KZtsxt7vAOTdfsfv1xUiDoV0/+otdMF+zBFU
	iyiKJujFg0Dylv/InuBvuNPH4YnhCH4NsorgYNGutzjJHscUNQ4+l+EVVowplkVwfjxc2aC+6MY
	iCbBMps/yp0OezUwI4SNN+YFMhaJGWFZNN2iDUQVsS+zAgHZcWXf5StSaLQkQQxpoZy8uPsgL5V
	sSgHrSuT6O5rqv458OAxp/B3RLnV4aa2Z8WWFWgV+iEGrPEhpy9xhqOqWXW2VpZR82Aimia57TW
	lJoS+fMV0WOw/UPbVX4Oy5JwR6zr94WBRuWjw55cfA0Dm39iQkBsQlXPQsJlufKuq/IflLqCtjp
	37STfI479ywRsRE2tlKl5PEkT0uSBie3UYNY5b+nMFie9fZSN53YTS5CDScv4HTxMC7DvyURKDS
	OQsbyjDuoSwscPare/M2xs/MRJawjN8ZCNHR5SAAmmAo4xH6OiPQ==
X-Google-Smtp-Source: AGHT+IGLdHq84lPWuC9+6LJzgqfOJA4DO6nS6TVGXk5Ftt4X8sQj+LIHdpfQT0AOQR/zxEXR5CFwjw==
X-Received: by 2002:a05:600c:8711:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-4773cdce892mr7234625e9.2.1762163860205;
        Mon, 03 Nov 2025 01:57:40 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c11182e3sm19786186f8f.11.2025.11.03.01.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 01:57:39 -0800 (PST)
Date: Mon, 3 Nov 2025 09:57:36 +0000
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
Subject: Re: [PATCH 20/22] vfio/platform: Convert to get_region_info_caps
Message-ID: <aQh8kE9DrbxS2x1e@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <20-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:34PM -0300, Jason Gunthorpe wrote:
> Remove the duplicate code and change info to a pointer. caps are not used.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Also, I smoke tested this on Qemu.

Thanks,
Mostafa

> ---
>  drivers/vfio/platform/vfio_amba.c             |  2 +-
>  drivers/vfio/platform/vfio_platform.c         |  2 +-
>  drivers/vfio/platform/vfio_platform_common.c  | 24 ++++++-------------
>  drivers/vfio/platform/vfio_platform_private.h |  3 ++-
>  4 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index d600deaf23b6d7..fa754f203b2dfc 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -115,7 +115,7 @@ static const struct vfio_device_ops vfio_amba_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> -	.get_region_info = vfio_platform_ioctl_get_region_info,
> +	.get_region_info_caps = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 0e85c914b65105..a4d3ace3e02dda 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -101,7 +101,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> -	.get_region_info = vfio_platform_ioctl_get_region_info,
> +	.get_region_info_caps = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 3ebd50fb78fbb7..c2990b7e900fa5 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -273,30 +273,20 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>  EXPORT_SYMBOL_GPL(vfio_platform_open_device);
>  
>  int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> -					struct vfio_region_info __user *arg)
> +					struct vfio_region_info *info,
> +					struct vfio_info_cap *caps)
>  {
>  	struct vfio_platform_device *vdev =
>  		container_of(core_vdev, struct vfio_platform_device, vdev);
> -	struct vfio_region_info info;
> -	unsigned long minsz;
>  
> -	minsz = offsetofend(struct vfio_region_info, offset);
> -
> -	if (copy_from_user(&info, arg, minsz))
> -		return -EFAULT;
> -
> -	if (info.argsz < minsz)
> -		return -EINVAL;
> -
> -	if (info.index >= vdev->num_regions)
> +	if (info->index >= vdev->num_regions)
>  		return -EINVAL;
>  
>  	/* map offset to the physical address  */
> -	info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> -	info.size = vdev->regions[info.index].size;
> -	info.flags = vdev->regions[info.index].flags;
> -
> -	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
> +	info->offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info->index);
> +	info->size = vdev->regions[info->index].size;
> +	info->flags = vdev->regions[info->index].flags;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_ioctl_get_region_info);
>  
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index a6008320e77bae..05084212a76eb6 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -86,7 +86,8 @@ void vfio_platform_close_device(struct vfio_device *core_vdev);
>  long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  			 unsigned int cmd, unsigned long arg);
>  int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> -					struct vfio_region_info __user *arg);
> +					struct vfio_region_info *info,
> +					struct vfio_info_cap *caps);
>  ssize_t vfio_platform_read(struct vfio_device *core_vdev,
>  			   char __user *buf, size_t count,
>  			   loff_t *ppos);
> -- 
> 2.43.0
> 

