Return-Path: <kvm+bounces-61839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D84FC2C4F2
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 15:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 016E94F4C96
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 14:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3468B30F7ED;
	Mon,  3 Nov 2025 13:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsTQAlbT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3DB30C610
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762178379; cv=none; b=r5yluEQRVGt3wGALNXBbaC8czhbuIYOSQ/D4aosZl8WViIMaiDWnYhtWZh6zMb9HbxrSOxMqT/F3y4YqnydEF1CqVLgh5LMwf4nutQAbtc+QFXErIQs018P+KSTcaeRZeQgoOZHuGhYOkCm05wq0G2pUml/k5T94qDcREdy840E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762178379; c=relaxed/simple;
	bh=OXyZ9JYBNGHxLdfTkXhQDxzS13sXQv5trq+Gy8pkZes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BPcLKA8O/3i0URe2bS308AzTkDmLlBfhQlQYAYlsLdewKc0Bov9KNZU7qQnqX8Bp6pjRC/jScS5MYxRZpFg21wl3DcacEcmFCeQVZh9K71f/CTeHzrbxwFTusuMbJdo1+xarKhUQ/grWphHWLwx5nnvF6vIOjvF1lVveQh399lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsTQAlbT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762178375;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsxzOKYHqHXC5PUWfDfFaZwNataXiFJtKNUMBtRzjIc=;
	b=LsTQAlbTKrE8RMQx3Aw8HB650kiRo5yWwXCbpN+2hhGZ3I8ILaCLSeDjuvQih9zJy5Fzob
	eUCINbG6UXcv3brhsttOpwT4rF7fOeGzi0Z5lPj+z4dSqJ4WNuAM/rSlAy/w+47NVyWoQ9
	LxGDgXtBVIhQqhsZGXkONrxhN5UMHTM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-Rbf3s1CWMru0bwxnArlaYQ-1; Mon, 03 Nov 2025 08:59:34 -0500
X-MC-Unique: Rbf3s1CWMru0bwxnArlaYQ-1
X-Mimecast-MFC-AGG-ID: Rbf3s1CWMru0bwxnArlaYQ_1762178374
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47113dfdd20so19598425e9.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 05:59:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762178373; x=1762783173;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsxzOKYHqHXC5PUWfDfFaZwNataXiFJtKNUMBtRzjIc=;
        b=B/vxLYjB1zaFsokoC4YZmUxNb1UfLNJMwjNgpPvUBHNgqO+XuTnZtfrsv/ECHUPkYJ
         kVoiPsyEyQzxI5OM+yEtedIX8jiAIgGThBKUtMr0/RIgnrraUTLMqRIqdb2joN1Hkmvc
         /oqJB9K7d6DHRVH1t75XJtl/LCqkV0XBPm8AIkNjyMUws6UJAE2YUcDXxifYjH/tNVqk
         ZqvsnAOkFXODRRhyJRMlp2FGKe6wADoU9S5HBS1CX8nSNFFs6Hj4e0IRhrTLsmQemfGN
         0tV9G9viVBj9TJBmXqvzZAnLYw2nXi1r9kSKRzS7/yxeHOtff9+gtemeZT7dMKvftQ9b
         5DMw==
X-Forwarded-Encrypted: i=1; AJvYcCUpybxEog+LrW6/19bchPnkK/UFfv2HezRU9nBjwNGWcFmjVj8pBo5z889txqvsQ5pSEtc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfWy3xAUn5HDyt5A5vQfcOFP5AmpEzvx2Jiv7NWgByfH3pE3HC
	B73TZsjo04OJ4GWyqD7ax/yxOLDXJFv/BTUA2jcl1k6YrLwuenzc0ixsZdoZIsgDhOomJWH/A6b
	6d9R9iDnC1nWVc89DS1G3ASwiGhrImtgq+789GLnTjFEHWdtcaEid/Q==
X-Gm-Gg: ASbGncvrz2Fq+51AU8nDM177bsEueLUeKQyHEVAMsC3CT7ldi4bII+zEglR/ae2/dh1
	Z4hMsYDyV96vXBPBCncKGoglxajITNYCgTMBckhj3om8wNGCSU10Sp8Se6U+kdyhbjTDQSBaZo2
	GBvruEEyo2aKDdQ9dAGXQ1VoTogyJQYbcQOUoL9FnAohtQnoakllTsb5C2W5SvG/U3pwh0Jbln6
	jiwq564r+wzP1YH72HbGWmTPnPOLpTgzr1sqkfBs/9WpCyQaoa/sHtkzhITZvOIdyDZTVJ5pQV8
	hMsE5EalkO2m6NKn3qW0coUVnabj9Mxjx0RhdoVL3TKd9WdauQyEMB7oX/o2SCHE8WLjfBkrZsI
	yLRTCCT/4gQpGuQM2jz3/+8fbms+KMT7HBKzeG+hwLriW0Q==
X-Received: by 2002:a05:600c:3b15:b0:46e:48fd:a1a9 with SMTP id 5b1f17b1804b1-4773089cd1amr118452215e9.33.1762178373399;
        Mon, 03 Nov 2025 05:59:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKpOeJ3OCF2vnsxcvEkg/1eMNuJuaakX/5JjRbkHK8VRtwHXD8pikxeGoOHXlvFPGq9VVSPQ==
X-Received: by 2002:a05:600c:3b15:b0:46e:48fd:a1a9 with SMTP id 5b1f17b1804b1-4773089cd1amr118451615e9.33.1762178372957;
        Mon, 03 Nov 2025 05:59:32 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c2e6771sm156241435e9.2.2025.11.03.05.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 05:59:32 -0800 (PST)
Message-ID: <0815321f-00d5-402c-b84d-99bc862b4575@redhat.com>
Date: Mon, 3 Nov 2025 14:59:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 09/22] vfio/platform: Provide a get_region_info op
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, David Airlie
 <airlied@gmail.com>, Alex Williamson <alex.williamson@redhat.com>,
 Ankit Agrawal <ankita@nvidia.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Brett Creeley <brett.creeley@amd.com>, dri-devel@lists.freedesktop.org,
 Eric Farman <farman@linux.ibm.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 intel-gfx@lists.freedesktop.org, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
 Longfang Liu <liulongfang@huawei.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>,
 Nikhil Agarwal <nikhil.agarwal@amd.com>, Nipun Gupta <nipun.gupta@amd.com>,
 Peter Oberparleiter <oberpar@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, Pranjal Shrivastava <praan@google.com>,
 qat-linux@intel.com, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Simona Vetter <simona@ffwll.ch>, Shameer Kolothum <skolothumtho@nvidia.com>,
 Mostafa Saleh <smostafa@google.com>, Sven Schnelle <svens@linux.ibm.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, virtualization@lists.linux.dev,
 Vineeth Vijayan <vneethv@linux.ibm.com>, Yishai Hadas <yishaih@nvidia.com>,
 Zhenyu Wang <zhenyuw.linux@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>
Cc: patches@lists.linux.dev
References: <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jason,

On 10/24/25 1:09 AM, Jason Gunthorpe wrote:
> Move it out of vfio_platform_ioctl() and re-indent it. Add it to all
> platform drivers.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
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
Any rationale behind why using _ioctl naming in some drivers and not in
some others?

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
Besides Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


