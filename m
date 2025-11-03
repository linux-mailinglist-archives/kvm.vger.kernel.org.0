Return-Path: <kvm+bounces-61794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 349E3C2A5EA
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 08:40:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2336A4E3468
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 07:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A222BF00B;
	Mon,  3 Nov 2025 07:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4xbSGM1m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B972C15B7
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 07:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762155590; cv=none; b=ql06+Zg5FKbDrgj0HNVayRc1vFiWhlaFodsdasbrPJvwmLQiSpIQnLVUkjhOvUh1pniboe/vAmq7sQ/G42Sd7JwfuZPgainKg3uB3ljwWNgdsyRM3KOkpxWeBl4cGX0MS2A7AWnBt4Jfb0BaeiPTlHzdBmXGQeEOFAR4S4dq5yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762155590; c=relaxed/simple;
	bh=30R4PwwoDn0ue1N2GS0GOY1SWIFA7GBPa8q4kx5mc+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSIVNg8trAbnLZBkC9qVkO6+qQjjq50rDX2IpJi98KONlJoMF4Ir6rNL4lISMIItSH8jEs1xITXh9ScszPoytpr0CENlV7coI4vGk7UZEvk5pm1z9scOe60LsRQgFAr04dTdPtTQfOagZRIVlpEwkvJ2pfE3ngMuGnsSXIcQzPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4xbSGM1m; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-294f3105435so343775ad.1
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 23:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762155588; x=1762760388; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzwh3KfEQpKPksD5Xn4ZAd8EEqdDZL8lWisUmSvX4T0=;
        b=4xbSGM1mPiF/5mRata4Qedj/4eMBsRxrlBvOyJ/WRxJmYaaudM9u/jHawCavHJy5zS
         zNajQolEqAOlkri6Y9CYfPH+Xz1QidD1HKDek4zBj0H4+/tTWlB26MuDTKkUaJx8h7sV
         P2V8EOfUxIX82cSMk/UpbFQNAidfIwJPcXMJZwOhAhEz3UWc5LhY1FplbXJlk5DlZtdI
         R9pLstQWJi9iwyAmV/TG60n8N/419R61sruPSBuh8zMksPHKd5cQ1vJ2YNVqm3I6uM49
         Vb5SIwDOGLz5Wlzb/ka/p3RpES6a+ruAN/bIuoeVjeTXr403latneInTCizTGfrihLqB
         IeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762155588; x=1762760388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzwh3KfEQpKPksD5Xn4ZAd8EEqdDZL8lWisUmSvX4T0=;
        b=bi/sdCzM/yT5+NAu+jcxKXabiMilbKfhuISH4yQ++CFgIRwUKQFJ+/FPypHftI0KMP
         0bHTALVApjcj3kO9AkRmN+IASaKrJBBIWv2418y/8dsax27S61+PHVJ6cVYL5mqaCBMF
         lzzX7Z0y2LnMKC3qwwxLuZxYKjm9/HLyvaiH4U9r1wHB7v1tZ2+LD1xw0TpdTs7hlQWy
         3kTiyqVfoJexDfNK9bo30zm33dfWBI06l/QAgRbLJS5XMwAGdBRkQd37epEXZgBz1cJT
         NnNAP+lzlpgG9J4IrpSq5oHz7XvO418uBSuYCZSOQWphP8BsgnZ6LlQ6FXB5rzFeHEVn
         sttA==
X-Forwarded-Encrypted: i=1; AJvYcCU8EDK0sqse7BovpXJgXPUZvp660NS9SusCtZcR6Mt29qF3VuxveZBFxfCgfDLYpS2NKXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnCVw+ynYoJLvVW5C3NVKKSGOjtBg3FQrWSPzHdcab3RcUPMG7
	k3fae021LGZiiuQJtRJ9Is4Vv287jq/1hRI+LmAU+3H2/rmgqUuOVskaedpg6BpvKQ==
X-Gm-Gg: ASbGncv/rFihwQqDsvIp0XdzAnQSA1q9KwzzS30djDjYnUXQFy7iA1LGYYXsO0ALy/n
	aixcIo23MVU4sSinON10bXLULZ1NSjMA+utvR1EeCZgluNh1pM2CXlnsr5tHz5QliN1i/LdlliU
	yyOY0Blg3wSTuBtjJG969ya3ziTOA2C2SjuVL0e9eFuSJkgZljHydbuMD88p3MRXQ+efE7TBzWG
	KH/2jJchikgAIf1LzYRK6Q7ag15Tmae+4xiIgWFcaKBvBhh/fVLAScMOKVgg+quZoVD/mi1JDm1
	NeTBx0SsFI3kP1imeslbOVDdGZQnrsZK5Ly4WUJgfCECudJid3d157LuY5QpPahZ41J78ktn5Vu
	Y8YTYSjyORwxBX0bpHZYAXRFLmTF/Tk3Fs6a2lAXWFCczbbL8kbuqDA2YcguFchJsZPVdSovc7B
	QRhp8LO/dl7FA+f1sly1UJ02VI33IxMwsuzLKrn3LwetCHI4QS
X-Google-Smtp-Source: AGHT+IGoX/eRPHIgiRFzzACV20d0ftHJvRprPrWC1Oq8kyrn4muK0Mu+0fpj1flmH53tBH91iPLzGw==
X-Received: by 2002:a17:902:ea0d:b0:24b:1741:1a4c with SMTP id d9443c01a7336-295549f6bcbmr6601575ad.0.1762155587782;
        Sun, 02 Nov 2025 23:39:47 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952e9a399csm102714425ad.33.2025.11.02.23.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:39:47 -0800 (PST)
Date: Mon, 3 Nov 2025 07:39:37 +0000
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
Subject: Re: [PATCH 14/22] vfio: Require drivers to implement get_region_info
Message-ID: <aQhcOYVbY-LqOjW5@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <14-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:28PM -0300, Jason Gunthorpe wrote:
> Remove the fallback through the ioctl callback, no drivers use this now.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a390163ce706c4..f056e82ba35075 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1297,13 +1297,13 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  		break;
>  
>  	case VFIO_DEVICE_GET_REGION_INFO:
> -		if (!device->ops->get_region_info)
> -			goto ioctl_fallback;
> -		ret = device->ops->get_region_info(device, uptr);
> +		if (unlikely(!device->ops->get_region_info))
> +			ret = -EINVAL;

Nit: Let's also add a warn/err log here highliting that the device
doesn't populate the get_region_info op?

> +		else
> +			ret = device->ops->get_region_info(device, uptr);
>  		break;
>  
>  	default:
> -ioctl_fallback:
>  		if (unlikely(!device->ops->ioctl))
>  			ret = -EINVAL;
>  		else

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

