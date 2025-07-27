Return-Path: <kvm+bounces-53519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29CF0B13136
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 20:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 532F0175D58
	for <lists+kvm@lfdr.de>; Sun, 27 Jul 2025 18:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691B6220F49;
	Sun, 27 Jul 2025 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QbTCAAmG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E61137923
	for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753641175; cv=none; b=avpNs8mXb8W5olCp8VFQpBmB385nRXJvyw32muH8vJH+Xa5DdAhcjnocVnrJGQxR2P86b6HUz764gVq55PiP/Ma/Vt8UY59+7FjBGeZ70j/k52K2Z8PIZOvzKf835d349md6bFYkbNvNLSFTbaxQDi3Q0SOBG1f0qxmqCIeDI1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753641175; c=relaxed/simple;
	bh=LDpwYyQCyXffC130lgOopwKCIPJE+T8WiS+8Agish50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmAyIoa5m36vAjdmklPanq0O+q/dXglAE6ewKRtsga7hGN4gVMPqFFa2dB4Hka/u4EMdTOsOHoZ1rHfw/Or0hO2oMj2QJ2KudDM6gmFzuRqYIth13SX1h5+CX80oySrMXcilJut7J3ml2PxZD83nmQeORWZllrAl2hlbpHeciYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QbTCAAmG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4562b2d98bcso43035e9.1
        for <kvm@vger.kernel.org>; Sun, 27 Jul 2025 11:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753641172; x=1754245972; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jeZpJ8EEi2Tf/Eb59bmLaMalnmZjm8ddvHoZCTjkcXo=;
        b=QbTCAAmGaGmhIl3BdxPLd2QFGVx+OnC8Sv2nxLNAwU7NttMjZVB3oj6NF2EwSmP06j
         7FybkXHS7huDo3Rsgk8rPOPWAfcvZa8LtdpDGuRKlPXJJBgapzHzsN7UX+IT34VJJOhh
         gFk20mYN0MyMY6xEmu18uwQof+Pn9dFsZwMdrK97TNtLEp1RmaQhVHty5feqVWYGKI8l
         /Lr8NjjB610ZZh/8tYaPdglaMhampGVkxf0Q/8OAcomgaTXWWMsgwIYNwLMG4vgjMcRr
         +SqC2bZd71FWlt3+YSman3MuP0R05ntGl60RG8jAAfqXmjBqOM+DIaI5j5XFVIEcn/kq
         WCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753641172; x=1754245972;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jeZpJ8EEi2Tf/Eb59bmLaMalnmZjm8ddvHoZCTjkcXo=;
        b=FWVEvICYj+KOLeCzmyfOtuglZP4OiQPpmOQ12RpqckGKHoKQ4BOV/mwh3vauGx5Dhh
         snunWLH5FPG2ZjsGyZk2nsjnb6SAnORIAxiP0wfNFsKXr7CYzx7UDzGmdrh3m0FBVmTK
         gnlxijHyi4We5p9kjyStT54In2SDSVKoc1zRMKc7y2zvGueShykME1RbBPgJoQaE0VYb
         vQJeGHPh/emDYyxwX/TEc+cxSLKnNwwhRs7ehovCs7mJby7/3sF/rbE4rF+nw0iUHSQl
         HOY3UEg6JBvruXQu+vLki8CsQj1TkleBQlVxA7lU5yU8U0eZvafF5ip2SCdeXnNVXE1e
         7tdQ==
X-Gm-Message-State: AOJu0YwVDvJCe32iaWNenMLJpka5WPjaR0G4KPusjg2qwgQ/FySW3qHQ
	DWehZ30s27bmiLVU2Deb/BtbwFIR2ePduOypgZvny4deiNXkmfGpGPsq+YDifN39SQ==
X-Gm-Gg: ASbGnctW8V3ToyJFf8g07zw3xxGa2WwetWSQUA3D87OfV3Zxud/NMb0Ntx00m7KXQ2o
	LqkS4KfBYOdE5FMlsJ2j1Epmb9JvuSmcRu+NEdWxnHjTHrfCMCGF5KKfe/eoQnk2rHju5veYaWM
	G0rLCGLA5GnqG5vefqkrNYxmJuaKkzT5aGTcig64kWNRxCegfAAnXUNurWHt8JhJqeD+vsH0LDG
	X5NUQDCYQmyOHJNgwbnK1oFRyJl8xyFsmYN+Tqg/zlLRDUUEACuBSPU337qBMK47g0MHhTQV3yW
	XWydUBniRJxMc/42U5zOGFptARnYqgI87RdPC6S7Sc4OAki2UQKUHn72vkHx7t1/oxUnTNyWoPl
	tsRnIcN3VfsJi/9fH4siu2qL1Dj8noyOkPag5j268WR77GOGYlATXoWz+ASbbgnMB28Wh7Eo=
X-Google-Smtp-Source: AGHT+IHvR0LwsGiDHKkA6/LgH7PJohXpWnPVpBeJWWXwUsxZg7ZE3lJorebcw5PVSuNVkN/6E95KSA==
X-Received: by 2002:a05:600c:1389:b0:450:ceac:62cf with SMTP id 5b1f17b1804b1-4587c9987bbmr2284655e9.5.1753641171792;
        Sun, 27 Jul 2025 11:32:51 -0700 (PDT)
Received: from google.com (232.38.195.35.bc.googleusercontent.com. [35.195.38.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b781d2fc1csm4302433f8f.5.2025.07.27.11.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 11:32:51 -0700 (PDT)
Date: Sun, 27 Jul 2025 18:32:48 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 08/10] vfio/iommufd: Move the hwpt allocation
 to helper
Message-ID: <aIZw0DnAniP5G6KG@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-8-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250525074917.150332-8-aneesh.kumar@kernel.org>

On Sun, May 25, 2025 at 01:19:14PM +0530, Aneesh Kumar K.V (Arm) wrote:
> alloc_hwpt.flags = 0; implies we prefer stage1 translation. Hence name
> the helper iommufd_alloc_s2bypass_hwpt().

This patch moves the recently added code into a new function,
can't this be squashed?
Also, I believe that with “IOMMU_HWPT_DATA_NONE”, we shouldn’t make
any assumptions in userspace about which stage is used.

The only guarantee is that IOMMU_IOAS_MAP/IOMMU_IOAS_UNMAP works.

So, I believe the naming for "s2bypass" is not accurate.

> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  vfio/iommufd.c | 86 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 50 insertions(+), 36 deletions(-)
> 
> diff --git a/vfio/iommufd.c b/vfio/iommufd.c
> index 3728a06cb318..742550705746 100644
> --- a/vfio/iommufd.c
> +++ b/vfio/iommufd.c
> @@ -60,6 +60,54 @@ err_close_device:
>  	return ret;
>  }
>  
> +static int iommufd_alloc_s2bypass_hwpt(struct vfio_device *vdev)
> +{
> +	int ret;
> +	struct iommu_hwpt_alloc alloc_hwpt;
> +	struct vfio_device_bind_iommufd bind;
> +	struct vfio_device_attach_iommufd_pt attach_data;
> +
> +	bind.argsz = sizeof(bind);
> +	bind.flags = 0;
> +	bind.iommufd = iommu_fd;
> +
> +	/* now bind the iommufd */
> +	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to get info");
> +		goto err_out;
> +	}
> +
> +	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
> +	/* stage1 translate stage 2 bypass table if stage1 is supported */
> +	alloc_hwpt.flags = 0;
> +	alloc_hwpt.dev_id = bind.out_devid;
> +	alloc_hwpt.pt_id = ioas_id;
> +	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
> +	alloc_hwpt.data_len = 0;
> +	alloc_hwpt.data_uptr = 0;
> +
> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
> +		ret = -errno;
> +		pr_err("Failed to allocate HWPT");
> +		goto err_out;
> +	}
> +
> +	attach_data.argsz = sizeof(attach_data);
> +	attach_data.flags = 0;
> +	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
> +
> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
> +		ret = -errno;
> +		vfio_dev_err(vdev, "failed to attach to IOAS ");
> +		goto err_out;
> +	}
> +	return 0;
> +
> +err_out:
> +	return ret;
> +}
> +
>  static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>  {
>  	int ret;
> @@ -68,9 +116,6 @@ static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>  	bool found_dev = false;
>  	char pci_dev_path[PATH_MAX];
>  	char vfio_dev_path[PATH_MAX];
> -	struct iommu_hwpt_alloc alloc_hwpt;
> -	struct vfio_device_bind_iommufd bind;
> -	struct vfio_device_attach_iommufd_pt attach_data;
>  
>  	ret = snprintf(pci_dev_path, PATH_MAX, "%s/vfio-dev/", vdev->sysfs_path);
>  	if (ret < 0 || ret == PATH_MAX)
> @@ -115,40 +160,9 @@ static int iommufd_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>  		goto err_close_device;
>  	}
>  
> -	bind.argsz = sizeof(bind);
> -	bind.flags = 0;
> -	bind.iommufd = iommu_fd;
> -
> -	/* now bind the iommufd */
> -	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
> -		ret = -errno;
> -		vfio_dev_err(vdev, "failed to get info");
> -		goto err_close_device;
> -	}
> -
> -	alloc_hwpt.size = sizeof(struct iommu_hwpt_alloc);
> -	alloc_hwpt.flags = 0;
> -	alloc_hwpt.dev_id = bind.out_devid;
> -	alloc_hwpt.pt_id = ioas_id;
> -	alloc_hwpt.data_type = IOMMU_HWPT_DATA_NONE;
> -	alloc_hwpt.data_len = 0;
> -	alloc_hwpt.data_uptr = 0;
> -
> -	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
> -		ret = -errno;
> -		pr_err("Failed to allocate HWPT");
> -		goto err_close_device;
> -	}
> -
> -	attach_data.argsz = sizeof(attach_data);
> -	attach_data.flags = 0;
> -	attach_data.pt_id = alloc_hwpt.out_hwpt_id;
> -
> -	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
> -		ret = -errno;
> -		vfio_dev_err(vdev, "failed to attach to IOAS ");
> +	ret = iommufd_alloc_s2bypass_hwpt(vdev);
> +	if (ret)
>  		goto err_close_device;
> -	}
>  
>  	closedir(dir);
>  	return __iommufd_configure_device(kvm, vdev);
> -- 
> 2.43.0
> 

