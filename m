Return-Path: <kvm+bounces-54617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5D6B25711
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 00:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEFB87BBE4A
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 22:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA582D979B;
	Wed, 13 Aug 2025 22:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TWbQgMTz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB6E2FB98D
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 22:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755125802; cv=none; b=l1TszIs8qv4IBA7dmKXXZBMI9hyDemlUi3N6OkKHtFcYqx2W554RufGMD1FprlRWQl7/pYREF7FSjH15ImjcyhN5I7+GQ0cF93qGlWiVpBFEHyeuf7Q/Zbvm4AYTtC0KMwDt/5HAPiidjV6HnppoZcO3g638WegCJOB8l2A8K0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755125802; c=relaxed/simple;
	bh=4e0l/gwaTIMLD9bL4migSckiVZwpKkWavSLci6fpGpM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/ZuIR+5fQ2sWw31AZgVrFvFe+UldREClOtRemLyiwq9fpBJVRUeqAZTaRsmGx0XhPgSHHYnc5ZEKMiJbSo6PtfgLCQisPkCY0tPpUyyiko913a76fRoq+v+PzFdTXPh0E130xv/p9tSePa3sXD/IlyLKmb+eHBk+IdWJXaLwTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TWbQgMTz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755125799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aLeTfhKhkO7buQ+Gq1sRAvaCeEwy+ke7zDoFKoCbE0A=;
	b=TWbQgMTzmYew0pYZVFk/N2pA36avigBwnC8srRnHyFSu+N6QXHFzKRL2KyAJydzrXDCYjd
	UFiyRwsEwDgbK2GAJFaDYeZDRwFKjDBxrj77kjESxkHztvPGrSUDocI6z1sCvHhQanKDXC
	Dt3T4H8SBcZAHK5KL8zYFkPFdnyv1Ik=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-4r3LBBDvO-q13LiPybO7ag-1; Wed, 13 Aug 2025 18:56:37 -0400
X-MC-Unique: 4r3LBBDvO-q13LiPybO7ag-1
X-Mimecast-MFC-AGG-ID: 4r3LBBDvO-q13LiPybO7ag_1755125797
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e57003c19aso946685ab.3
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 15:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755125796; x=1755730596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLeTfhKhkO7buQ+Gq1sRAvaCeEwy+ke7zDoFKoCbE0A=;
        b=JYe9ZAfnA3xVDERa/abNhTgo6gZkFXuBpPknbxIGTLKe1oKmC6Dk0Tgm5y6rvfMMDr
         mEvgTCdr+bPGIO+fv+weG6CSYO8dx0dvEuAYdFlD9GooJCCuaBQk8VlEEu1ExgjoKgLG
         Pn2xnCWnNZ8/AF5cEKjF/g1NnM3TFxUfvetavhZVWHkfAcslXU87shi7srHNtLyZ2bit
         wQVTzk1Y//4RTtShlkevM/sl1czl9/v5SfoOCqpx57uBZggYBWobsH9maJFIRujnIfRs
         qHvJ5ci7gVRO+tj3vM+ZaRWdtkxTeEHKRBVqykr0tOOXB1mNMUgvBoItbIFSFtyxjZ8N
         brfA==
X-Forwarded-Encrypted: i=1; AJvYcCVyD3m1YyKD8w6vJxoCleqFmWvFqo0ArCaswhz0arHNh0qwNoSKJnyYhGTFMNB5DbLQ/nw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy6c2HsRfCVmOIR8OWXqmu1Ws/DsvMmKf2TzB3ZQCKzkUqe2lB
	FaXXde6RA66V1g/R9Dt67ys6CHG8GrClXQ4gvdd9/mHIHmrOHnmH+6h5yuCkIZrwY2HD0mCYS6T
	mTeqNgR3Epw5uwXRy7QoI8zlffRZNyrU/XpcOFkQ7A8CXGRD3e2i3ztc/FtLazQ==
X-Gm-Gg: ASbGnctbPcHA0Brf3Mt+6uve68jXsezcNk6lkSRNOPzg4rfo8CUlmPgx9c3hmd02IT7
	sJ1Uej2N5Yntn+h0i2txPwr56JAMOasRCO3G1cYlmdiQy6W9IX/n1K6RMsn3z4Y6H1HD2EZ2Sw3
	ZbgloDKADhqwHWrx+ZrdW6FRg9vLu5UDmhkm7UKUb1qBqzRBMmEH1Yh+kyT8W2SqPpgLqXAbtgz
	qF/SWo1NKLpoEDf0yU0/w2Xk/EBimtA5gSDjwoYA0Xu0ViGWV18/T20t09k1IH4uYEEKRMau2p1
	m1vuQV6dzbkTnLrFTEZKU5pBMxfu90o9dyjEn0TXi+o=
X-Received: by 2002:a05:6e02:216a:b0:3e5:151e:6652 with SMTP id e9e14a558f8ab-3e57077bac5mr4982765ab.2.1755125796308;
        Wed, 13 Aug 2025 15:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGktdX8bRcKWgKmUrfDsEuQvcB5qH6b2PxIASOhiJyxcRZsecjKLRc1k18NJ79Q05dhZSHjaQ==
X-Received: by 2002:a05:6e02:216a:b0:3e5:151e:6652 with SMTP id e9e14a558f8ab-3e57077bac5mr4982635ab.2.1755125795883;
        Wed, 13 Aug 2025 15:56:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e533cc1bb3sm60160555ab.32.2025.08.13.15.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 15:56:34 -0700 (PDT)
Date: Wed, 13 Aug 2025 16:56:31 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, schnelle@linux.ibm.com,
 mjrosato@linux.ibm.com
Subject: Re: [PATCH v1 5/6] vfio-pci/zdev: Perform platform specific
 function reset for zPCI
Message-ID: <20250813165631.7c22ef0f.alex.williamson@redhat.com>
In-Reply-To: <7059025f-f337-493d-a50c-ccce8fb4beee@linux.ibm.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
	<20250813170821.1115-6-alifm@linux.ibm.com>
	<20250813143034.36f8c3a4.alex.williamson@redhat.com>
	<7059025f-f337-493d-a50c-ccce8fb4beee@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 Aug 2025 14:52:24 -0700
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 8/13/2025 1:30 PM, Alex Williamson wrote:
> > On Wed, 13 Aug 2025 10:08:19 -0700
> > Farhan Ali <alifm@linux.ibm.com> wrote:
> >  
> >> For zPCI devices we should drive a platform specific function reset
> >> as part of VFIO_DEVICE_RESET. This reset is needed recover a zPCI device
> >> in error state.
> >>
> >> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >> ---
> >>   arch/s390/pci/pci.c              |  1 +
> >>   drivers/vfio/pci/vfio_pci_core.c |  4 ++++
> >>   drivers/vfio/pci/vfio_pci_priv.h |  5 ++++
> >>   drivers/vfio/pci/vfio_pci_zdev.c | 39 ++++++++++++++++++++++++++++++++
> >>   4 files changed, 49 insertions(+)
> >>
> >> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> >> index f795e05b5001..860a64993b58 100644
> >> --- a/arch/s390/pci/pci.c
> >> +++ b/arch/s390/pci/pci.c
> >> @@ -788,6 +788,7 @@ int zpci_hot_reset_device(struct zpci_dev *zdev)
> >>   
> >>   	return rc;
> >>   }
> >> +EXPORT_SYMBOL_GPL(zpci_hot_reset_device);
> >>   
> >>   /**
> >>    * zpci_create_device() - Create a new zpci_dev and add it to the zbus
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> >> index 7dcf5439dedc..7220a22135a9 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -1227,6 +1227,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
> >>   	 */
> >>   	vfio_pci_set_power_state(vdev, PCI_D0);
> >>   
> >> +	ret = vfio_pci_zdev_reset(vdev);
> >> +	if (ret && ret != -ENODEV)
> >> +		return ret;
> >> +
> >>   	ret = pci_try_reset_function(vdev->pdev);
> >>   	up_write(&vdev->memory_lock);  
> > You're going to be very unhappy if this lock isn't released.
> >  
> Ah yes, thanks for catching that. Will fix this.
> 
> >  
> >>   
> >> diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
> >> index a9972eacb293..5288577b3170 100644
> >> --- a/drivers/vfio/pci/vfio_pci_priv.h
> >> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> >> @@ -86,6 +86,7 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
> >>   				struct vfio_info_cap *caps);
> >>   int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);
> >>   void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev);
> >> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev);
> >>   #else
> >>   static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
> >>   					      struct vfio_info_cap *caps)
> >> @@ -100,6 +101,10 @@ static inline int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
> >>   
> >>   static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
> >>   {}
> >> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
> >> +{
> >> +	return -ENODEV;
> >> +}
> >>   #endif
> >>   
> >>   static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
> >> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> >> index 818235b28caa..dd1919ccb3be 100644
> >> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> >> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> >> @@ -212,6 +212,45 @@ static int vfio_pci_zdev_setup_err_region(struct vfio_pci_core_device *vdev)
> >>   	return ret;
> >>   }
> >>   
> >> +int vfio_pci_zdev_reset(struct vfio_pci_core_device *vdev)
> >> +{
> >> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> >> +	int rc = -EIO;
> >> +
> >> +	if (!zdev)
> >> +		return -ENODEV;
> >> +
> >> +	/*
> >> +	 * If we can't get the zdev->state_lock the device state is
> >> +	 * currently undergoing a transition and we bail out - just
> >> +	 * the same as if the device's state is not configured at all.
> >> +	 */
> >> +	if (!mutex_trylock(&zdev->state_lock))
> >> +		return rc;
> >> +
> >> +	/* We can reset only if the function is configured */
> >> +	if (zdev->state != ZPCI_FN_STATE_CONFIGURED)
> >> +		goto out;
> >> +
> >> +	rc = zpci_hot_reset_device(zdev);
> >> +	if (rc != 0)
> >> +		goto out;
> >> +
> >> +	if (!vdev->pci_saved_state) {
> >> +		pci_err(vdev->pdev, "No saved available for the device");
> >> +		rc = -EIO;
> >> +		goto out;
> >> +	}
> >> +
> >> +	pci_dev_lock(vdev->pdev);
> >> +	pci_load_saved_state(vdev->pdev, vdev->pci_saved_state);
> >> +	pci_restore_state(vdev->pdev);
> >> +	pci_dev_unlock(vdev->pdev);
> >> +out:
> >> +	mutex_unlock(&zdev->state_lock);
> >> +	return rc;
> >> +}  
> > This looks like it should be a device or arch specific reset
> > implemented in drivers/pci, not vfio.  Thanks,
> >
> > Alex  
> 
> Are you suggesting to move this to an arch specific function? One thing 
> we need to do after the zpci_hot_reset_device, is to correctly restore 
> the config space of the device. And for vfio-pci bound devices we want 
> to restore the state of the device to when it was initially opened.

We generally rely on the abstraction of pci_reset_function() to select
the correct type of reset for a function scope reset.  We've gone to
quite a bit of effort to implement all device specific resets and
quirks in the PCI core to be re-used across the kernel.

Calling zpci_hot_reset_device() directly seems contradictory to those
efforts.  Should pci_reset_function() call this universally on s390x
rather than providing access to FLR/PM/SBR reset?  Why is it
universally correct here given the ioctl previously made use of
standard reset mechanisms?

The DEVICE_RESET ioctl is simply an in-place reset of the device,
without restoring the original device state.  So we're also subtly
changing that behavior here, presumably because we're targeting the
specific error recovery case.  Have you considered how this might
break non-error-recovery use cases?

I wonder if we want a different reset mechanism for this use case
rather than these subtle semantic changes.  Thanks,

Alex


