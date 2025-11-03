Return-Path: <kvm+bounces-61816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D80C2B2C9
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 11:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0161A3ABF83
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 10:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C4C3009E1;
	Mon,  3 Nov 2025 10:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tgVQ5rGf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A3F2FDC5B
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 10:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167141; cv=none; b=PIUQ+EwhO9oVp4H3vxhW2OGgWSHJQjwW/YnAhXsyeCo+w4MSjGIesvOwAFT8JhuxaBFsKj+cYOXuduz7c8o7gs+wOy37KsnlBu3vveDGh+oIrCmW/6jzi2ihwiB/fT8JRgDYi8ujxPaLf02K1ldT/pLx4g8xMTstK7SWqZwPAhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167141; c=relaxed/simple;
	bh=mvE+DUWqyOq8EZSNgDW4VO8ZUoDnjwG4bmh01CUVPv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MZkNWtXB6gtxnUDoQi6utVc0MjAhDO16Cn6W0xa4wCkQlRWObma/ic8QiCeASMYMeQocvfpDsWXLWyk0dhH7I+S8JF92uKDCBCKGQEyf06wfrgYw5nbK2PwbVnAKRMM4mlE9IxOavLhv1bQIwQKOjMZ8ADeh2FJUFmwrH0XsnIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tgVQ5rGf; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2959197b68eso235695ad.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 02:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762167139; x=1762771939; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WwKprwTirCt4i5Js91Sl+ZyTThwVs5kTlEuvLY+kPJk=;
        b=tgVQ5rGfvOoa+FTTecpjeXTkKtLOL8EhaSfkAKNOGwV5/NNWvTRE7NwH8/oKqooaRf
         mCmNilbebWGQTKyn7vr5Lul2cYXVO48C+dBcCKRgQWrq73ASs46e2F2KWzSXpkWhOTyz
         AX686p0MVQd9nKXhpkhlViJDlxeltdEvwBmWTKjoGH9e3XQgJnKwJXfCOsWC36WBWb3q
         ytDLszOKPL3v8itFgcLWh1kjovMiR/d0a1Teh/qvhORpxJF2Tx/s/qgYFt/5q++dNtVV
         Kz735OKnpWWQGV/MRINR97LJRNxC8sPhdEOOMd27ifvq1Z7RdBmoQpcgI/zQATLq1pan
         67XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762167139; x=1762771939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwKprwTirCt4i5Js91Sl+ZyTThwVs5kTlEuvLY+kPJk=;
        b=VLEkT0wRcM6RjlBKjtR9//Ephi4B1fPWC8Dxkn8pYKVU7YZdkI6wC5J7unrw5TSJpM
         CT3aETOdvatP4aZTHO1tr2GtfuU2rmak/Yi98baS5q5YM7E/+Z/yikMc44cTsM+nqfh9
         tCCCuzt3M//T2jtaypryrCMH0aftQ0+ITmY28gNGAnMfm3bbYBXI2VVrjrx4dDEQTXjn
         3XxRZeXDfP2Egcu6WVlz+KI9nLRjd052f6bwPf+w5m4hA3GJIygY7pECRasklg3EB0Mu
         mz8zSyrwnS8BUxsunuFzunkok/lJMjXpc/60z2yuhsSprI5gEN8A/DNZ+YwQWhs7BNTD
         mX2w==
X-Forwarded-Encrypted: i=1; AJvYcCUJOE2etzao7L2lIKYWDybypSTB86xNn8GCgoaNmaW0OdAMcnt9F8Ua2iGZ7vV9GP5NbAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGSSoABCwQWuxub/10OhbRLzL8qLpmYaYzLc6+2xBvNowv8jpG
	tUS9UachABgMhKQ0qAE2YzC4oWiwOhVCkxD9i11LMkTYJzRcWUbn2FXf+XW3keG1vg==
X-Gm-Gg: ASbGncvIELg980AvgAemRrbh5jWeHMFfnIfclPWijT7PIL3gBJtkoo2VjGILnbksRxr
	RD1xtLwnNMYMqp6Xq5Zs6tlFH5SajxPfN43T9jM8qlH+rV2HA6wEV5M0oVpWUypHTbuVOk9Wg/s
	XIIZ4aui3ivoRo3GOGXoUSTS7Tq9T4vQE6yO6/+32DzvN5vkPPHX2YThkAzLus+5x0GPqV0f1wC
	+H91JBfUWlUelrZUAgR0mXduFPpTt1cafMy1eGGmTlN6hQBS6+Wu13ddTXw6CXMTtG88TT/EvZ6
	1aHJ5X4FgSx2wdkNnwnmt6RGVp1sUth8VPjc/uLS6gmzNA1MKu1Q0cmnzDEDRPKo1NSvHMQ2/gw
	B+i+y7xym0S5EJ5crxZe+HT4NKgqO5wg4IWLgcLsqkzWIf12QYi3xGmZniWX1aauKJN4I3Mx98c
	FZFR1Csw6wHIxYJQPgkm23aPLrVxh4lgSdJgOLQA==
X-Google-Smtp-Source: AGHT+IHPuCzOHK+gl1PDmhIoWt8nQcQHNMFtOu890fqfdIsVUQlawn89pKWjl6bN9nnq4lv2uM5QPg==
X-Received: by 2002:a17:902:c411:b0:295:3f35:a315 with SMTP id d9443c01a7336-2955658e37fmr6124875ad.5.1762167138172;
        Mon, 03 Nov 2025 02:52:18 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3415994181esm651172a91.5.2025.11.03.02.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:52:17 -0800 (PST)
Date: Mon, 3 Nov 2025 10:52:07 +0000
From: Pranjal Shrivastava <praan@google.com>
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
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 22/22] vfio: Remove the get_region_info op
Message-ID: <aQiJV4p3AKZSDH08@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <22-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:36PM -0300, Jason Gunthorpe wrote:
> No driver uses it now, all are using get_region_info_caps().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 50 +++++++++++++++++-----------------------
>  include/linux/vfio.h     |  2 --
>  2 files changed, 21 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 82e7d79b1f9fe2..f911c1980c9420 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1263,48 +1263,40 @@ static long vfio_get_region_info(struct vfio_device *device,
>  				 struct vfio_region_info __user *arg)
>  {
>  	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
>  	struct vfio_region_info info = {};
>  	int ret;
>  
> +	if (unlikely(!device->ops->get_region_info_caps))
> +		return -EINVAL;
> +
>  	if (copy_from_user(&info, arg, minsz))
>  		return -EFAULT;
>  	if (info.argsz < minsz)
>  		return -EINVAL;
>  
> -	if (device->ops->get_region_info_caps) {
> -		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +	ret = device->ops->get_region_info_caps(device, &info, &caps);
> +	if (ret)
> +		return ret;

Shall we kfree(caps.buf); before returning?

> -		ret = device->ops->get_region_info_caps(device, &info, &caps);
> -		if (ret)
> -			return ret;
> -
> -		if (caps.size) {
> -			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> -			if (info.argsz < sizeof(info) + caps.size) {
> -				info.argsz = sizeof(info) + caps.size;
> -				info.cap_offset = 0;
> -			} else {
> -				vfio_info_cap_shift(&caps, sizeof(info));
> -				if (copy_to_user(arg + 1, caps.buf,
> -						 caps.size)) {
> -					kfree(caps.buf);
> -					return -EFAULT;
> -				}
> -				info.cap_offset = sizeof(info);
> +	if (caps.size) {
> +		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +		if (info.argsz < sizeof(info) + caps.size) {
> +			info.argsz = sizeof(info) + caps.size;
> +			info.cap_offset = 0;
> +		} else {
> +			vfio_info_cap_shift(&caps, sizeof(info));
> +			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
> +				kfree(caps.buf);
> +				return -EFAULT;
>  			}
> -			kfree(caps.buf);
> +			info.cap_offset = sizeof(info);
>  		}
> -
> -		if (copy_to_user(arg, &info, minsz))
> -			return -EFAULT;
> -	} else if (device->ops->get_region_info) {
> -		ret = device->ops->get_region_info(device, arg);
> -		if (ret)
> -			return ret;
> -	} else {
> -		return -EINVAL;
> +		kfree(caps.buf);
>  	}
>  
> +	if (copy_to_user(arg, &info, minsz))
> +		return -EFAULT;
>  	return 0;
>  }
>  
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 6311ddc837701d..8e1ddb48b9b54e 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -133,8 +133,6 @@ struct vfio_device_ops {
>  			 size_t count, loff_t *size);
>  	long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
>  			 unsigned long arg);
> -	int	(*get_region_info)(struct vfio_device *vdev,
> -				   struct vfio_region_info __user *arg);
>  	int	(*get_region_info_caps)(struct vfio_device *vdev,
>  					struct vfio_region_info *info,
>  					struct vfio_info_cap *caps);

Thanks,
Praan

