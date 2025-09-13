Return-Path: <kvm+bounces-57495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 034F9B55FBD
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 11:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2C5CA08211
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 09:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7442EAB7E;
	Sat, 13 Sep 2025 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cuNfOMHl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959BA2EA468
	for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 09:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757754389; cv=none; b=CMhQ9f3fZpgCd58JImd9u1UjNuLf2FtK0ro4kchxvnWNF2gB51ZdcxeOMYEjqElXW6dKwzjIHLmycp6P0dJqoU9Ew9yIWSkUw1z3FoE+I/okzqGp91+rFjaMQuBF/GX17fYNYe1rpzoaHTB8pL1V4QT+UCJ3Iuv8+qjOfH+f9p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757754389; c=relaxed/simple;
	bh=8dEp1AU6wmo+g+BbWCezxqlLsb7zc0IB8g7OnuHFGSE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUjsn9xaZxSG8U4IPOyp1dsFyUm1nuyu13CtBYZqti3OekklW5He+Pvw640t60xa8ypJ/IqRd7kWdDlClMBYVdyA/n8yr/efwvODn3ZQk4nURCog8+IR27dCMhhbFgxtYM2oG9tsUSzmCGv1GpjM9d0cUGgmJRTFOsq1aR73Oa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cuNfOMHl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757754386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOsyKEsT4d7f0MxqTpsXQLTyDPQ6JiWR10VEY3czRBY=;
	b=cuNfOMHlFQqk4cnlFMA7Qtd6Ab66+A1XcciArAcsuUrYTRXittziaJL2NimU1esJ6Q5w/8
	pAfJSuvVmSI5zLdy/yDhPAb7p5bkZMgxWarNH4Ah5+8+HCoElcAsNenYj5EenaiVkqODTP
	35NZ7hhc4n5Z9gSo0t2uPzR/HJbUv7I=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-ocETM416O0atyETeCM0fvA-1; Sat, 13 Sep 2025 05:06:24 -0400
X-MC-Unique: ocETM416O0atyETeCM0fvA-1
X-Mimecast-MFC-AGG-ID: ocETM416O0atyETeCM0fvA_1757754383
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4198fcc4a80so6677065ab.3
        for <kvm@vger.kernel.org>; Sat, 13 Sep 2025 02:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757754383; x=1758359183;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uOsyKEsT4d7f0MxqTpsXQLTyDPQ6JiWR10VEY3czRBY=;
        b=M2o8AsCFGvrhHNjQMP9X/+5/+w/xBqcKQK2BFxUZbjQZROyInMzV7/FBribXKBnJzS
         vZnsGalpPr2PrWWkZqOopsd1zxtl1W8vSuTttBSHuzGqq4yTHMSz6BpMFGVq3z8bmOBO
         iX57nDduEpaHu3jpXgTLJStZzPLDFyu7C6XhPpaLeaImrIRXAS2xIpf8ZBikQjlHZ+LL
         7Cvo0t/0vYSbbVTpj3nrj/CSlUnHGW295/750TRgoddPGRu91wsHTWWtwQCaItPdp5WH
         wuRRtNzxo8+DPNq5UNB4H7WnzXjL/bJqyJM1G3yu6yZmQ61fpyfYQrLm5yW+TDKQZdiQ
         pwAg==
X-Forwarded-Encrypted: i=1; AJvYcCUL7QGFj2q/PZnQWw8JRTKgMK9ByrCuLbbLl+Oh9JeAgVtiC39IRwDxLPkbzEpi6sRyrJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRouDZRtkci2zt/4sFNOMNEzE0M2nMz9yiljaKR2B4UfmFq97m
	AupnnMGDi0x9omwDMgpI+xBx68Xbp9fFNkS7/V40j9m49jClPbqXC5VAeBuddHPJfggfOShVt/o
	M3UT/okDPAJMLNP6/EeJ8okPMLLhwi407c0c5mrbutJO78RjYekscHA==
X-Gm-Gg: ASbGnctSTU7V7JCpTtUhNUQ0fqMFRW1t5CL8whR6Pbfa6imWTYGwTCBXJg+TAcWQgVC
	p3ql2P0z64lzdgCao1+R33hYRidC3s+eBTOykxjFErwrk4JKTpqcNhp6EWYcegs1a0uGtBzaCPj
	B0L2jtNl19dBmW4e4XW7OcRxil4WWE54HsGUePdd+Eq5z6mEFal36PkEuQDm1vKs6MkIFNFO3kD
	tMVNWgq7hmTEuFO6yA7JOS3oUroQ7N7AGVNUVIiBRa2DIRY7QCz7iGeYSuu72iOxiBsO3YO6hUR
	V55W7k+Vg4SAnyegoZL/Ug6KhqqsYhMkO39u2kxBdRY=
X-Received: by 2002:a92:ca4d:0:b0:419:de32:2d01 with SMTP id e9e14a558f8ab-420a1bf0e2amr28604245ab.4.1757754383432;
        Sat, 13 Sep 2025 02:06:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENFwGsYCj5we8cqrgqcps0vU//BTqxnSv90KfRfiVLx0DBHmLiooNtsdQvyKhq4QCqGgNKww==
X-Received: by 2002:a92:ca4d:0:b0:419:de32:2d01 with SMTP id e9e14a558f8ab-420a1bf0e2amr28604185ab.4.1757754383024;
        Sat, 13 Sep 2025 02:06:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-41deede6d15sm31335025ab.7.2025.09.13.02.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 02:06:21 -0700 (PDT)
Date: Sat, 13 Sep 2025 10:04:57 +0100
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 helgaas@kernel.org, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH v3 08/10] vfio-pci/zdev: Add a device feature for error
 information
Message-ID: <20250913100457.1af13cd7.alex.williamson@redhat.com>
In-Reply-To: <20250911183307.1910-9-alifm@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
	<20250911183307.1910-9-alifm@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Sep 2025 11:33:05 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> For zPCI devices, we have platform specific error information. The platform
> firmware provides this error information to the operating system in an
> architecture specific mechanism. To enable recovery from userspace for
> these devices, we want to expose this error information to userspace. Add a
> new device feature to expose this information.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c |  2 ++
>  drivers/vfio/pci/vfio_pci_priv.h |  8 ++++++++
>  drivers/vfio/pci/vfio_pci_zdev.c | 34 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h        | 14 +++++++++++++
>  4 files changed, 58 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7dcf5439dedc..378adb3226db 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1514,6 +1514,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> +	case VFIO_DEVICE_FEATURE_ZPCI_ERROR:
> +		return vfio_pci_zdev_feature_err(device, flags, arg, argsz);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index a9972eacb293..a4a7f97fdc2e 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -86,6 +86,8 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  				struct vfio_info_cap *caps);
>  int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
>  void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
> +int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
> +			      void __user *arg, size_t argsz);
>  #else
>  static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  					      struct vfio_info_cap *caps)
> @@ -100,6 +102,12 @@ static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>  
>  static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>  {}
> +
> +static int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
> +				     void __user *arg, size_t argsz);
> +{
> +	return -ENODEV;
> +}
>  #endif
>  
>  static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 2be37eab9279..261954039aa9 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -141,6 +141,40 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  	return ret;
>  }
>  
> +int vfio_pci_zdev_feature_err(struct vfio_device *device, u32 flags,
> +			      void __user *arg, size_t argsz)
> +{
> +	struct vfio_device_feature_zpci_err err;
> +	struct vfio_pci_core_device *vdev =
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	int ret;
> +	int head = 0;
> +
> +	if (!zdev)
> +		return -ENODEV;
> +
> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(err));
> +	if (ret != 1)
> +		return ret;
> +
> +	mutex_lock(&zdev->pending_errs_lock);
> +	if (zdev->pending_errs.count) {
> +		head = zdev->pending_errs.head % ZPCI_ERR_PENDING_MAX;
> +		err.pec = zdev->pending_errs.err[head].pec;
> +		zdev->pending_errs.head++;
> +		zdev->pending_errs.count--;
> +		err.pending_errors = zdev->pending_errs.count;
> +	}
> +	mutex_unlock(&zdev->pending_errs_lock);
> +
> +	if (copy_to_user(arg, &err, sizeof(err)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>  {
>  	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 75100bf009ba..a950c341602d 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1478,6 +1478,20 @@ struct vfio_device_feature_bus_master {
>  };
>  #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
>  
> +/**
> + * VFIO_DEVICE_FEATURE_ZPCI_ERROR feature provides PCI error information to
> + * userspace for vfio-pci devices on s390x. On s390x PCI error recovery involves
> + * platform firmware and notification to operating system is done by
> + * architecture specific mechanism.  Exposing this information to userspace
> + * allows userspace to take appropriate actions to handle an error on the
> + * device.
> + */
> +struct vfio_device_feature_zpci_err {
> +	__u16 pec;
> +	int pending_errors;
> +};

This should have some explicit alignment.  Thanks,

Alex

> +#define VFIO_DEVICE_FEATURE_ZPCI_ERROR 11
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**


