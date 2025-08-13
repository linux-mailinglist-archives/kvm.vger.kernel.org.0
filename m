Return-Path: <kvm+bounces-54610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35883B2548E
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 22:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D40549A1D88
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 20:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEEBB1DE8BF;
	Wed, 13 Aug 2025 20:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XW6U96gE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737E878F2B
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 20:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755117043; cv=none; b=W9yX2n+rw9n6RRoZQhoWfrbEUur7jIfcL9nFs7hk3nf6h5NyuwAbv2uvxFc7ZVK6mj/yJW+erspEoMfGtQdeVZC6jrGEZziqAYhoeqaoVTMPan5r2GJQOtXPU52qTyQYdziG5NowaHYNUXOrVd4jN0Ma6/pwzC62+ee+3kS+JVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755117043; c=relaxed/simple;
	bh=mcdXn545T9iczKIurqQ/FlGNxvpjg61xSkqMywCy0lc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uNXWYKQfnjpbGSpJJit+c0UnDC54r1wuziDiRIqTpKHH9kmDvrBYdTn/wBq0p0FHBrEpD3eRHspfB/TrppKPUZcoIA365HtTwzBpJeL3LTIHBv1nH4ktEZKH55uEPYLn/d6sFBE09NcCDX8iPeyCpXyC1TimrBdG6p5V9DzSxd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XW6U96gE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755117040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BI+9iAXPQA3xNCjPJYTJgadfit0AjGO1DF6bqEY2VU=;
	b=XW6U96gEdlvRxRXCC7/U31lMBf75wOrpgHgQVLcPN3iS9Pq2c4QZFQWgiqj0nBt9rUTYiW
	dZTblHyPFurYF7xTHuI9fDjRM5py54/ZmF/12B3JfYQDMZTfDdCyaYEzLAyZspStQzFZMK
	Rsqsekc5882bAJuzwXGONz95U+9kbEY=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-QegLrD_hMECsMT60kIZ4OA-1; Wed, 13 Aug 2025 16:30:39 -0400
X-MC-Unique: QegLrD_hMECsMT60kIZ4OA-1
X-Mimecast-MFC-AGG-ID: QegLrD_hMECsMT60kIZ4OA_1755117038
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e5700a5525so696785ab.3
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 13:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755117037; x=1755721837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+BI+9iAXPQA3xNCjPJYTJgadfit0AjGO1DF6bqEY2VU=;
        b=owzaY1XjrzwQ4Iz4FRjgUakPxvX7VmfoDjwPnRxP8VKikXVkMwyVO5zLeiu9eiZb0P
         4ssVaXRJz/Iqa2muKT0a8KrsEtH45bmckyZv5Ua2VvYUIlLkJJI/yO4dTTmmSthBzd+d
         hmfmzjQCV/BMascPrXWqyevNpxOV8/qHdJyB8ZhMT4GEFtnIUVKsw/oF0ZGn994OvZFi
         fUS6nXX/nCHwr66N5jzkSXRPMXEAwy8F6wp55Qt7ff5b+fSIr6xajSodB/t0ye0agD81
         I3njl3p1p18L6vxhmsEEfJ0CqAVkwrHAHkUXFkqB7X8b1Hv/Pu+FvsdD244JblWqlVsq
         lyOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlVuPhRTqLa2VotzAwDTPbUzg9ecPFHPu5cvQYmD6k+GNgVAn1gFlqUR3rS7Io83UpZ+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoTjGfQrnm2gBKdmvxAXb5VspR1198zUxNHvgvDJz9JKINoZui
	LOCDPcdRLJB3lboeSmfyoWe0zeehFPeeAUGnXdGnoUXTcmZtyyoaP/OBTy+0oXsuF5QWWjGKYQm
	bVtL82VXpqtStylDqlCtWNL8DMU1YCoJIxztzdJhVKD2hI3/F3siY4TLzkyrT4g==
X-Gm-Gg: ASbGnctzUiRGGeDhnjbRJBZXi57pCq1IyDBnxMPzxltbPqGPS/TZIqid1uAdDmo+8ZL
	phT0TJcGEilclQ5vFSL43ZIu+Wk3K6KwTYtreTmwVQU8Eg/qDr6PFRst5LGcKEOpMJaIf86hh0q
	eLcl4tjUphpWcxHkUP0VKLfy1PqjijPMt2gMn0/5rrrQkaBoTlgsi7H02YEQ3cILUdmeDH1j3Z8
	0lHv2FSfwJdvKqijMZgAt+IB7M513szzt7nqfZ86mJ1R1F8iAaXGV0DDoyeWbrhCgP6gMzCYT/v
	qQTU2dFn9qTNBcF9pTYkNsM44a3tdPAGy7+m5A13DXg=
X-Received: by 2002:a05:6e02:b2e:b0:3e2:9275:60dc with SMTP id e9e14a558f8ab-3e56750457emr19692555ab.7.1755117037095;
        Wed, 13 Aug 2025 13:30:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWKByLUCJANfJjFdntgzUouQryuRTSs8eTS8v1GZ/BIcQp6Rqz8qHwqV82SCnUE7c5PEq/xA==
X-Received: by 2002:a05:6e02:b2e:b0:3e2:9275:60dc with SMTP id e9e14a558f8ab-3e56750457emr19692375ab.7.1755117036671;
        Wed, 13 Aug 2025 13:30:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae997b3acsm4070617173.13.2025.08.13.13.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 13:30:35 -0700 (PDT)
Date: Wed, 13 Aug 2025 14:30:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific
 function reset for zPCI
Message-ID: <20250813143034.36f8c3a4.alex.williamson@redhat.com>
In-Reply-To: <20250813170821.1115-6-alifm@linux.ibm.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
	<20250813170821.1115-6-alifm@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 Aug 2025 10:08:19 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> For zPCI devices we should drive a platform specific function reset
> as part of VFIO_DEVICE_RESET. This reset is needed recover a zPCI device
> in error state.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  arch/s390/pci/pci.c              |  1 +
>  drivers/vfio/pci/vfio_pci_core.c |  4 ++++
>  drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
>  drivers/vfio/pci/vfio_pci_zdev.c | 39 ++++++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
> 
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index f795e05b5001..860a64993b58 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -788,6 +788,7 @@ int zpci_hot_reset_device(struct zpci_dev *zdev)
>  
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(zpci_hot_reset_device);
>  
>  /**
>   * zpci_create_device() - Create a new zpci_dev and add it to the zbus
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7dcf5439dedc..7220a22135a9 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1227,6 +1227,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
>  	 */
>  	vfio_pci_set_power_state(vdev, PCI_D0);
>  
> +	ret = vfio_pci_zdev_reset(vdev);
> +	if (ret && ret != -ENODEV)
> +		return ret;
> +
>  	ret = pci_try_reset_function(vdev->pdev);
>  	up_write(&vdev->memory_lock);

You're going to be very unhappy if this lock isn't released.

>  
> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> index a9972eacb293..5288577b3170 100644
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -86,6 +86,7 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  				struct vfio_info_cap *caps);
>  int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
>  void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev);
>  #else
>  static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  					      struct vfio_info_cap *caps)
> @@ -100,6 +101,10 @@ static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>  
>  static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>  {}
> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
> +{
> +	return -ENODEV;
> +}
>  #endif
>  
>  static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 818235b28caa..dd1919ccb3be 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -212,6 +212,45 @@ static int vfio_pci_zdev_setup_err_region(struct vfio_pci_core_device *vdev)
>  	return ret;
>  }
>  
> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	int rc = -EIO;
> +
> +	if (!zdev)
> +		return -ENODEV;
> +
> +	/*
> +	 * If we can't get the zdev->state_lock the device state is
> +	 * currently undergoing a transition and we bail out - just
> +	 * the same as if the device's state is not configured at all.
> +	 */
> +	if (!mutex_trylock(&zdev->state_lock))
> +		return rc;
> +
> +	/* We can reset only if the function is configured */
> +	if (zdev->state != ZPCI_FN_STATE_CONFIGURED)
> +		goto out;
> +
> +	rc = zpci_hot_reset_device(zdev);
> +	if (rc != 0)
> +		goto out;
> +
> +	if (!vdev->pci_saved_state) {
> +		pci_err(vdev->pdev, "No saved available for the device");
> +		rc = -EIO;
> +		goto out;
> +	}
> +
> +	pci_dev_lock(vdev->pdev);
> +	pci_load_saved_state(vdev->pdev, vdev->pci_saved_state);
> +	pci_restore_state(vdev->pdev);
> +	pci_dev_unlock(vdev->pdev);
> +out:
> +	mutex_unlock(&zdev->state_lock);
> +	return rc;
> +}

This looks like it should be a device or arch specific reset
implemented in drivers/pci, not vfio.  Thanks,

Alex

> +
>  int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>  {
>  	struct zpci_dev *zdev = to_zpci(vdev->pdev);


