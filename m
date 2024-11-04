Return-Path: <kvm+bounces-30569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA3F9BBF1C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 21:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62E3F28294E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 20:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CFA1F7547;
	Mon,  4 Nov 2024 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAOwe6Wt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CC31F709B
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730753985; cv=none; b=KbPNzxMxTkamcsiewRtfNdmytR6Fw9EU7OmN5tyZzNxgDvodiJBP5e7z9w146PlIpkk8W0Kg8yIHLKWkOgnWUdrWxf+5cawf+eCQMjB1Qu2SCyEwLq5rILuZXuHr7TEq7H5rYRWCqn0MrfgboSCgikp05RLGMVfGCLD22imtCxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730753985; c=relaxed/simple;
	bh=306BLGQenNBgxPaCp96PS+qFMWOEoG2saXI4tg3jtOc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GOyH3Ftb4noaEN2zHOo14dUzN8O+cyGeQeYm8eflb8PL9ld7Ns15TiNjTKnz57X7OxNCbPxXM/XPF8FB+jx2G+Of2XaZLOBF9PfaTcWqaVy+BNeRH5LWbN9RoEPjeX6GzI6PfstbQr4FJab/6L/b542TlIvxQq9+WoT97M74bj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SAOwe6Wt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730753982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDEHgj73EdOsIrwNTNGFZqHh+ek5B3xMp5/xUX0pdrU=;
	b=SAOwe6WtobfY4Qj4VqZJKqIonunH5vxVATj+38sLeuZUkL9mNLX0vznT24hmO3M7ouQlYI
	yMaOBsFUcm2mYYTIibVv+ey9tSUv1SRdkKjXRQHk9DWjrbB0gCwSjJZj3+y4z1WVkYQFJM
	YG/zgFL1TpFBPBmhN9wCyN59q8ZmVkU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-4Wtl7KMXN0a3v8Sp89mh9Q-1; Mon, 04 Nov 2024 15:59:41 -0500
X-MC-Unique: 4Wtl7KMXN0a3v8Sp89mh9Q-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83ab75ce25bso51398339f.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 12:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730753980; x=1731358780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sDEHgj73EdOsIrwNTNGFZqHh+ek5B3xMp5/xUX0pdrU=;
        b=iSQ1k1imuyvwgjyqbGvsxFNaVVlDIgZmoHX7bd4iyT9/scwagC9GTUT+lx/qMRN82g
         fjNqhlZw6hMgX8pqSIDoJl86NnMmYro+KDlDqnrK6q6d/lep6MmjReTjZbi3s06NeG31
         lUNqY1QqwaRPjV7abKJr0DEQz3b46CI1Jwl7ISenKpT+WQzzBkRJu9nnpWfSaQoKMz5I
         7/VFUGN5ZB+WOZZOKrOHR1iotfNXVQDkh/6M06vcwdwQOyde5nC2Y7J+y+peifvmhhoI
         OUqFkGjJQFQ4LEqbQOt0IXnsFOz3ifmWkICvUv//Q7FIqZmAYLq+KRFuOLTjaYwjcdnm
         ncwg==
X-Forwarded-Encrypted: i=1; AJvYcCVprGOPAnLO+zy+EORcmw8wz+ZWNzH7qqpOHUoWuyoQXqF/+gJRixkOUBhRJtJhjMDLv2w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpVk8tj5Lg1Za5aOeakqa9tQTtoY8GllCvEa4Mw527yLLy9Qpw
	NyU8/iwTEwf2carvj+PjzsV04p6LAE+r03jOFMv4K3X+MNUowj/WSjSBS4oCAHdoKaMQEvCeYrq
	F6WE2Z+bboKacZYPLg1KZgeTps6cyEqP3y+6CdywROl9JrsKspQ==
X-Received: by 2002:a05:6e02:190d:b0:3a6:af24:b8be with SMTP id e9e14a558f8ab-3a6af24bf4cmr42270935ab.6.1730753980405;
        Mon, 04 Nov 2024 12:59:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYDmHayMFj8DusHXFYl+9gp2PxNlz9n+tfUXzs6lmBYKaG//thKL5bF9D5iU0Xu1hnSB4/zA==
X-Received: by 2002:a05:6e02:190d:b0:3a6:af24:b8be with SMTP id e9e14a558f8ab-3a6af24bf4cmr42270775ab.6.1730753980006;
        Mon, 04 Nov 2024 12:59:40 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6aa5d0fc4sm24325595ab.50.2024.11.04.12.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2024 12:59:39 -0800 (PST)
Date: Mon, 4 Nov 2024 13:59:36 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
 eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 baolu.lu@linux.intel.com, zhenzhong.duan@intel.com, vasant.hegde@amd.com,
 willy@infradead.org
Subject: Re: [PATCH v4 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Message-ID: <20241104135936.22f7a18b.alex.williamson@redhat.com>
In-Reply-To: <20241104132732.16759-3-yi.l.liu@intel.com>
References: <20241104132732.16759-1-yi.l.liu@intel.com>
	<20241104132732.16759-3-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  4 Nov 2024 05:27:30 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This adds pasid_at|de]tach_ioas ops for attaching hwpt to pasid of a
> device and the helpers for it. For now, only vfio-pci supports pasid
> attach/detach.
> 
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/iommufd.c      | 50 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci.c |  2 ++
>  include/linux/vfio.h        | 11 ++++++++
>  3 files changed, 63 insertions(+)
> 
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 82eba6966fa5..2f5cb4f616ce 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -119,14 +119,22 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>  	if (IS_ERR(idev))
>  		return PTR_ERR(idev);
>  	vdev->iommufd_device = idev;
> +	ida_init(&vdev->pasids);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_iommufd_physical_bind);
>  
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
>  {
> +	int pasid;
> +
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> +	while ((pasid = ida_find_first(&vdev->pasids)) >= 0) {
> +		iommufd_device_pasid_detach(vdev->iommufd_device, pasid);
> +		ida_free(&vdev->pasids, pasid);
> +	}
> +
>  	if (vdev->iommufd_attached) {
>  		iommufd_device_detach(vdev->iommufd_device);
>  		vdev->iommufd_attached = false;
> @@ -168,6 +176,48 @@ void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_iommufd_physical_detach_ioas);
>  
> +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
> +					    u32 pasid, u32 *pt_id)
> +{
> +	int rc;
> +
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device))
> +		return -EINVAL;
> +
> +	if (ida_exists(&vdev->pasids, pasid))
> +		return iommufd_device_pasid_replace(vdev->iommufd_device,
> +						    pasid, pt_id);
> +
> +	rc = ida_alloc_range(&vdev->pasids, pasid, pasid, GFP_KERNEL);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = iommufd_device_pasid_attach(vdev->iommufd_device, pasid, pt_id);
> +	if (rc)
> +		ida_free(&vdev->pasids, pasid);
> +
> +	return 0;

I think you meant to return rc here.  Thanks,

Alex

> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_pasid_attach_ioas);
> +
> +void vfio_iommufd_physical_pasid_detach_ioas(struct vfio_device *vdev,
> +					     u32 pasid)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device))
> +		return;
> +
> +	if (!ida_exists(&vdev->pasids, pasid))
> +		return;
> +
> +	iommufd_device_pasid_detach(vdev->iommufd_device, pasid);
> +	ida_free(&vdev->pasids, pasid);
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_pasid_detach_ioas);
> +
>  /*
>   * The emulated standard ops mean that vfio_device is going to use the
>   * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using this
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index e727941f589d..6f7ae7e5b7b0 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -144,6 +144,8 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
>  	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
> +	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
> +	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
>  };
>  
>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 000a6cab2d31..11b3b453752e 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -67,6 +67,7 @@ struct vfio_device {
>  	struct inode *inode;
>  #if IS_ENABLED(CONFIG_IOMMUFD)
>  	struct iommufd_device *iommufd_device;
> +	struct ida pasids;
>  	u8 iommufd_attached:1;
>  #endif
>  	u8 cdev_opened:1;
> @@ -91,6 +92,8 @@ struct vfio_device {
>   *		 bound iommufd. Undo in unbind_iommufd if @detach_ioas is not
>   *		 called.
>   * @detach_ioas: Opposite of attach_ioas
> + * @pasid_attach_ioas: The pasid variation of attach_ioas
> + * @pasid_detach_ioas: Opposite of pasid_attach_ioas
>   * @open_device: Called when the first file descriptor is opened for this device
>   * @close_device: Opposite of open_device
>   * @read: Perform read(2) on device file descriptor
> @@ -115,6 +118,8 @@ struct vfio_device_ops {
>  	void	(*unbind_iommufd)(struct vfio_device *vdev);
>  	int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
>  	void	(*detach_ioas)(struct vfio_device *vdev);
> +	int	(*pasid_attach_ioas)(struct vfio_device *vdev, u32 pasid, u32 *pt_id);
> +	void	(*pasid_detach_ioas)(struct vfio_device *vdev, u32 pasid);
>  	int	(*open_device)(struct vfio_device *vdev);
>  	void	(*close_device)(struct vfio_device *vdev);
>  	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
> @@ -139,6 +144,8 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
>  int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev);
> +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev, u32 pasid, u32 *pt_id);
> +void vfio_iommufd_physical_pasid_detach_ioas(struct vfio_device *vdev, u32 pasid);
>  int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
>  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
> @@ -166,6 +173,10 @@ vfio_iommufd_get_dev_id(struct vfio_device *vdev, struct iommufd_ctx *ictx)
>  	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
>  #define vfio_iommufd_physical_detach_ioas \
>  	((void (*)(struct vfio_device *vdev)) NULL)
> +#define vfio_iommufd_physical_pasid_attach_ioas \
> +	((int (*)(struct vfio_device *vdev, u32 pasid, u32 *pt_id)) NULL)
> +#define vfio_iommufd_physical_pasid_detach_ioas \
> +	((void (*)(struct vfio_device *vdev, u32 pasid)) NULL)
>  #define vfio_iommufd_emulated_bind                                      \
>  	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
>  		  u32 *out_device_id)) NULL)


