Return-Path: <kvm+bounces-61840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA75EC2C656
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 15:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3524D424230
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 14:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A4A35962;
	Mon,  3 Nov 2025 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KtfOGWVO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5708130DD1D
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762179453; cv=none; b=XQ16QEKaHzbF6S5wQLBQyGH5MKEsv3j4/D7neXCh5qIXSLuVqNMawWkgwzHZL8C0F0GTiAoPNvYD48gwK7dvxUijYR5p5hsc4WysLKfzIgDvwMABS2ODsEs6rLiGMOw46Obr8Q3LWFXEhuLrSnOMWZKD7Qj4bw1Aj/ashz4/2jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762179453; c=relaxed/simple;
	bh=hcG1U7lseZfMJxZhcqnHfEl/KJd0wYevq0I/puDxKQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qUN4EH8qW/hGyvF+m2LLFz5gPuDJU/pJJ8WQA5rrGD/1Y6c8fA0Hb8Xnn/qZy20TFcxi5++Ua+6d82SPlz2VYFrXG2pfxtyD9U6iZCR+aUT6W6P5vfWPHCgT+m+l2DqcGRiK5WgwTD5jUrOrYR4+POymPnYm2RU/qmr6jLVCV/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KtfOGWVO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762179450;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q3Gz5RPi7t/fiKLwIbkCJ/zKbkuLlW2r6E/NdmyNkaY=;
	b=KtfOGWVOsMInoqAdXU633zhVX9C+ET+oaJ8iLWU0suhliH+RI9XEna87z2qhEmvtm5Gsf+
	ie/jitf0OBO69VSJZgkFyspA1WG6MZKN/qRTzanUQf44ArML79cUdtQGPOvdQrDt+WYhil
	K2YHTmflImfNPNuHDMDxKt/bexcTo7M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-kiItsSp7Puqn0l1xbOEQuQ-1; Mon, 03 Nov 2025 09:17:29 -0500
X-MC-Unique: kiItsSp7Puqn0l1xbOEQuQ-1
X-Mimecast-MFC-AGG-ID: kiItsSp7Puqn0l1xbOEQuQ_1762179447
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-475dca91610so23843065e9.3
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 06:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762179447; x=1762784247;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q3Gz5RPi7t/fiKLwIbkCJ/zKbkuLlW2r6E/NdmyNkaY=;
        b=w72QgZN30iGdoUsEAtFHTDzhl0O/sxJnI6e1GeWzCZM123HBVebRYra7WoXvnve//9
         Ov4Y4IaC5cehtikBx7qKAtToJoIIeQKrkq7z5ZrCQCuJn+MJ27wgdk59/69fRuqlcN9j
         1clSSXhSgAxLQ3GaaBQ5pZwI2XnpgrtBG96X2tjnKlHnFVnW5iVjAtJ5bra62leBMCML
         AerIFWtUkAjSt0jkRvivjsFPc1IqAClHyVQoWyx4C3kZZL1Dm6bRrP7a3OtKMER3/H7O
         J/2fx5qbdlbmOHxCYqQFXzkS3X9oUDIzYVT2cC9XOf/jaAajxJwnrnntt7q3+lT6n3Z0
         1TqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIbSHNxyTEmjpZv+TCL9HB/aqZqSiATLoU0RZqYEW/wdtyoyKRwG6fL7HitzeRcZ6AdoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2cYamtGUvZY9xoENYptZmLIsRckaCAgklZnaiTYhi2n+QGKZb
	sjg6AH3cQ934RUYgnSpBuRK3X7PZzj8HTiqUYhyIvDu1FpMiSboFwTCVSxlt8zqcbJJRuoQ+P34
	dsoIzdHl6azA5qTS8gTmHPltm69nVc5JGkxUccFLEmzPxDWJpc6P0tw==
X-Gm-Gg: ASbGncvsBpZmK+TZr7RQdgRvMsRC9/3wJP0tZtLJmtSSDjLsQ9Zusbzsn2tf9c4G58M
	rM7ncWuxJKMq6BA+r6bN7EJGRuZCzJ+Ggvq0X76oUVd4CIh0e7WwqboJc2D7hoiSdXelgRVWBEK
	49NCAUWp55cv0MgZlN2uvaBHKmEjEogRT+rpzUq0pGx95BZY8/cduqVb8fq3io0T4aiIBZ54gvr
	c+KuIL8J0J95odJM4gYGWbFEBQXepX2zMNGHWhyB9SV1/WbB9DBKYsRRkY1o4fKqrKqnHAgBKOx
	B0OtWOxN3BcxyiGFYhdz2Vflmf3qjRIAoLuI1jmiOT0PhrLy295EzI4Pni+MMSYz/Z7QEtJh7/p
	5dPbYnozxErjt6Bu/6549URRZ20PetwMS2pipJ1j44r9mQg==
X-Received: by 2002:a05:600c:3d9b:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-477307e2946mr105146565e9.15.1762179446700;
        Mon, 03 Nov 2025 06:17:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7QGWcsduqExlRNuo08vTbmBrCDPz7B6tz31rAn7ZiwWVaD9KVEKB25Zj5jP4j1A/9yO4aiQ==
X-Received: by 2002:a05:600c:3d9b:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-477307e2946mr105146315e9.15.1762179446219;
        Mon, 03 Nov 2025 06:17:26 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fcf38c6sm87824145e9.11.2025.11.03.06.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 06:17:25 -0800 (PST)
Message-ID: <c766564c-66a2-46d6-ab6f-b817f3b2e616@redhat.com>
Date: Mon, 3 Nov 2025 15:17:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 01/22] vfio: Provide a get_region_info op
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
References: <1-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <1-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jason,

On 10/24/25 1:09 AM, Jason Gunthorpe wrote:
> Instead of hooking the general ioctl op, have the core code directly
> decode VFIO_DEVICE_GET_REGION_INFO and call an op just for it.
>
> This is intended to allow mechanical changes to the drivers to pull their
> VFIO_DEVICE_GET_REGION_INFO int oa function. Later patches will improve
in a
> the function signature to consolidate more code.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 9 ++++++---
>  drivers/vfio/vfio_main.c         | 7 +++++++
>  include/linux/vfio.h             | 2 ++
>  include/linux/vfio_pci_core.h    | 2 ++
>  4 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7dcf5439dedc9d..1dc350003f075c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -996,9 +996,11 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>  	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>  }
>  
> -static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
> -					  struct vfio_region_info __user *arg)
> +int vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +				   struct vfio_region_info __user *arg)
>  {
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
>  	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_region_info info;
> @@ -1132,6 +1134,7 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
>  
>  	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pci_ioctl_get_region_info);
>  
>  static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
>  				       struct vfio_irq_info __user *arg)
> @@ -1458,7 +1461,7 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
>  		return vfio_pci_ioctl_get_pci_hot_reset_info(vdev, uarg);
>  	case VFIO_DEVICE_GET_REGION_INFO:
> -		return vfio_pci_ioctl_get_region_info(vdev, uarg);
> +		return vfio_pci_ioctl_get_region_info(core_vdev, uarg);
>  	case VFIO_DEVICE_IOEVENTFD:
>  		return vfio_pci_ioctl_ioeventfd(vdev, uarg);
>  	case VFIO_DEVICE_PCI_HOT_RESET:
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 38c8e9350a60ec..a390163ce706c4 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1296,7 +1296,14 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  		ret = vfio_ioctl_device_feature(device, uptr);
>  		break;
>  
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +		if (!device->ops->get_region_info)
> +			goto ioctl_fallback;
> +		ret = device->ops->get_region_info(device, uptr);
> +		break;
> +
>  	default:
> +ioctl_fallback:
>  		if (unlikely(!device->ops->ioctl))
>  			ret = -EINVAL;
>  		else
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index eb563f538dee51..be5fcf8432e8d5 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -132,6 +132,8 @@ struct vfio_device_ops {
>  			 size_t count, loff_t *size);
>  	long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
>  			 unsigned long arg);
> +	int	(*get_region_info)(struct vfio_device *vdev,
> +				   struct vfio_region_info __user *arg);
>  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
>  	void	(*request)(struct vfio_device *vdev, unsigned int count);
>  	int	(*match)(struct vfio_device *vdev, char *buf);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index f541044e42a2ad..160bc2e31ece75 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -115,6 +115,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  		unsigned long arg);
>  int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  				void __user *arg, size_t argsz);
> +int vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +				   struct vfio_region_info __user *arg);
looks like an inconsistent naming. all other functions declared here
have "_core".

The change of proto + export of vfio_pci_ioctl_get_region_info could
have been put in a separate patch than the one introducing the
get_region_info cb especially since the change is not documented in the
commit msg

Thanks

Eric
>  ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
>  		size_t count, loff_t *ppos);
>  ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,


