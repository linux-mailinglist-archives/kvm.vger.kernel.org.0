Return-Path: <kvm+bounces-25418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1201E96535F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 01:21:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8B892844F8
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 23:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5308F18EFE6;
	Thu, 29 Aug 2024 23:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuFfkqyn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E618A6DF
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 23:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724973707; cv=none; b=oAgIH3V35ivk8Hoj1sP0qkmOzwyWt6h0Sa0r3CHxiRYAImMjRL6kuaU0TMubk9w3A5AyaJwxHsSqqL4Ic0YJUmeiV/B2ypoPOvZtSyKAHEE49RhnHTCjh+1Zs5acyhiqayxZpxbA73wL/BMp8cYaj3FwH9uDu23rIvAQVRZlDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724973707; c=relaxed/simple;
	bh=AqHcWtuqCNAT29wDBP4vmDe6sFzp23LVp9gIvFYdeR0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Md5qtGZrm7Z0urRaDLlAMjjvZu7ekHeIGD9bjqG9vFq7j1oVryvMKbEG8hbMKfFAahUJ07o+ouIjvp47gqA4Cz7iUoMUFGb3mmpdZgYwt0pbciX/pFAO0c+Yxfy2WnUA1+m1nGJNi20FJuFdY+AbEqVqRW+xeW+cozOU4jwkbZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JuFfkqyn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724973704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WkLW/GJXW025vC/zR7s6KWdbSZfTOu9zBPKEdmJOkMc=;
	b=JuFfkqyn+ou3Iv+Qj+HAfdYX8XHeDoKAq8NFA+LN1A9xuQGC7lztPF3I5s//N9yv9u2bEq
	4lBdaaa4LoITOP85M4Tk3vk3sur/i+QmBibKJaWTMK7CdMEkrDOPO7vWmn7s6wZ8wUee7r
	TYcyn0GeRj5+7myxBfz1JbYtPJTqbM0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-dJBqZibpM1q5v1DU4SbI-w-1; Thu, 29 Aug 2024 19:21:43 -0400
X-MC-Unique: dJBqZibpM1q5v1DU4SbI-w-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82787896c05so12470439f.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 16:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724973702; x=1725578502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkLW/GJXW025vC/zR7s6KWdbSZfTOu9zBPKEdmJOkMc=;
        b=SWPlXW0VnL1Lr9hi/zHoGrSJfFfemIly8XAfRqm0/VaCR1jS6giDVTeEhEZBJhFB8S
         24pdr1VTbZYxXnyXPXsrtXiUz9nSoaXKEbs+rA6A6eFzat31XqfqDwiHQvqn6qNXBEGY
         YMuEpxoLoyFqYK2q5Brrx4yCUeyvVCvUyFfHHCTsIlNFR/JJNQ9EJ6RbCSPtB8jgzfs3
         n28bl7W54MRHbkR32+T8rcqc5VxlVjye1MKvyyP0NUXbfA6UHh9euZ4NJOFDWMM9Txsb
         8CC7FxUlL/Y5LF62p2i/Yui7HOV1jmpTcF1xS3SKfDS0D+llA9Y/ZtwxGrimSj2DYAZu
         GBXA==
X-Forwarded-Encrypted: i=1; AJvYcCXNNtyieZpbjxq2THy9PRCc7/9YefAlgvLP/h63WOAnUF0GEN/+yp990aJ6LBektSc9DoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBGgf15n1qA+C81lUd1sTKZZvUE52sjkfPKT0ZOYwIXTXsTFv2
	BcyVLTK/qrJhWZ9166qhw29ozqsU1BzMLoUkgoKxbOt0DcTQk6Ba+TnUK5lsl5Yx6FxcATOUQK0
	+ypnOMsbsz0jydS0PTGXgh7l6+TTUgYV/Q6guFrlt73OBHhsa0Q==
X-Received: by 2002:a5d:9c51:0:b0:81f:7f2d:8391 with SMTP id ca18e2360f4ac-82a262e0480mr34008239f.3.1724973702395;
        Thu, 29 Aug 2024 16:21:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaZvSkwWJar4Rqj8+g17+VPHiiSCIGu68s1hSoMmlVtVZB3E0uN+OY128eFxMU3Jp0pN94Cg==
X-Received: by 2002:a5d:9c51:0:b0:81f:7f2d:8391 with SMTP id ca18e2360f4ac-82a262e0480mr34006639f.3.1724973701954;
        Thu, 29 Aug 2024 16:21:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2e18812sm456400173.83.2024.08.29.16.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 16:21:41 -0700 (PDT)
Date: Thu, 29 Aug 2024 17:21:40 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, treding@nvidia.com, vbhadram@nvidia.com,
 jonathanh@nvidia.com, mperttunen@nvidia.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, clg@redhat.com, alexandre.torgue@foss.st.com,
 joabreu@synopsys.com, msalter@redhat.com
Subject: Re: [RFC PATCH 3/5] vfio_platform: reset: Introduce new open and
 close callbacks
Message-ID: <20240829172140.686a7aa7.alex.williamson@redhat.com>
In-Reply-To: <20240829161302.607928-4-eric.auger@redhat.com>
References: <20240829161302.607928-1-eric.auger@redhat.com>
	<20240829161302.607928-4-eric.auger@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Aug 2024 18:11:07 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> Some devices may require resources such as clocks and resets
> which cannot be handled in the vfio_platform agnostic code. Let's
> add 2 new callbacks to handle those resources. Those new callbacks
> are optional, as opposed to the reset callback. In case they are
> implemented, both need to be.
> 
> They are not implemented by the existing reset modules.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c  | 28 ++++++++++++++++++-
>  drivers/vfio/platform/vfio_platform_private.h |  6 ++++
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 3be08e58365b..2174e402dc70 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -228,6 +228,23 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
>  	return -EINVAL;
>  }
>  
> +static void vfio_platform_reset_module_close(struct vfio_platform_device *vpdev)
> +{
> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
> +		return;
> +	if (vpdev->reset_ops && vpdev->reset_ops->close)
> +		vpdev->reset_ops->close(vpdev);
> +}
> +
> +static int vfio_platform_reset_module_open(struct vfio_platform_device *vpdev)
> +{
> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
> +		return 0;
> +	if (vpdev->reset_ops && vpdev->reset_ops->open)
> +		return vpdev->reset_ops->open(vpdev);
> +	return 0;
> +}

Hi Eric,

I didn't get why these are no-op'd on an ACPI platform.  Shouldn't it
be up to the reset ops to decide whether to implement something based
on the system firmware rather than vfio-platform-common?

> +
>  void vfio_platform_close_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_platform_device *vdev =
> @@ -242,6 +259,7 @@ void vfio_platform_close_device(struct vfio_device *core_vdev)
>  			"reset driver is required and reset call failed in release (%d) %s\n",
>  			ret, extra_dbg ? extra_dbg : "");
>  	}
> +	vfio_platform_reset_module_close(vdev);
>  	pm_runtime_put(vdev->device);
>  	vfio_platform_regions_cleanup(vdev);
>  	vfio_platform_irq_cleanup(vdev);
> @@ -265,7 +283,13 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>  
>  	ret = pm_runtime_get_sync(vdev->device);
>  	if (ret < 0)
> -		goto err_rst;
> +		goto err_rst_open;
> +
> +	ret = vfio_platform_reset_module_open(vdev);
> +	if (ret) {
> +		dev_info(vdev->device, "reset module load failed (%d)\n", ret);
> +		goto err_rst_open;
> +	}
>  
>  	ret = vfio_platform_call_reset(vdev, &extra_dbg);
>  	if (ret && vdev->reset_required) {
> @@ -278,6 +302,8 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>  	return 0;
>  
>  err_rst:
> +	vfio_platform_reset_module_close(vdev);
> +err_rst_open:
>  	pm_runtime_put(vdev->device);
>  	vfio_platform_irq_cleanup(vdev);
>  err_irq:
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 90c99d2e70f4..528b01c56de6 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -74,9 +74,13 @@ struct vfio_platform_device {
>   * struct vfio_platform_reset_ops - reset ops
>   *
>   * @reset:	reset function (required)
> + * @open:	Called when the first fd is opened for this device (optional)
> + * @close:	Called when the last fd is closed for this device (optional)

This doesn't note any platform firmware dependency.  We should probably
also note here the XOR requirement enforced below here.  Thanks,

Alex

>   */
>  struct vfio_platform_reset_ops {
>  	int (*reset)(struct vfio_platform_device *vdev);
> +	int (*open)(struct vfio_platform_device *vdev);
> +	void (*close)(struct vfio_platform_device *vdev);
>  };
>  
>  
> @@ -129,6 +133,8 @@ __vfio_platform_register_reset(&__ops ## _node)
>  MODULE_ALIAS("vfio-reset:" compat);				\
>  static int __init reset ## _module_init(void)			\
>  {								\
> +	if (!!ops.open ^ !!ops.close)				\
> +		return -EINVAL;					\
>  	vfio_platform_register_reset(compat, ops);		\
>  	return 0;						\
>  };								\


