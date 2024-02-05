Return-Path: <kvm+bounces-8048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7DAC84A960
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AD0F1F253D9
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FE92C1B9;
	Mon,  5 Feb 2024 22:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBzFp770"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A551EB49
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 22:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707172578; cv=none; b=QW6IYF9U9S1ycXBuxqhgIZOr20iV8dlB0Ac0/grCifsiNyBfrN0jdlME/qhx5EMd8dcY8c24F3Hnitk5LM6M58AgoFHQr8I37Ee/aR9dSWQwBsItIM4XzsnOZW4G+rBOCzxtnrBjxzRShLduTeen83UtxhYjjsnNZ8QxB2ilImQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707172578; c=relaxed/simple;
	bh=YfcVwTdvsAFjLJ7bKvK6o7HK5jBfK7DuYGaXvtDcedI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufcREou4SXfpox2LYT1klACb0CYRGP/QQoH/exr3CAJs9tcMqu88ebBbgyvYWy2byvS4UpawvfonP67fvsQuI0i6+5Dgt40AqB8Nx/NRjy9+Ivf+kOg0XkHWVpB0IQkvnjiJqyigFHjI9gxYisZiQBK3JF9wUfwq6aZZGp4ZWg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBzFp770; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707172574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b/wNE6tBX1rJP2YgS+TTAYHWSHylnSq7QWSxIGxGiQU=;
	b=WBzFp770OM+Vi3Fl+dvdDJbH5q3V1vk9t20460q51cY2Dx3NCpPemsxaVE1Zaqf40dlCuS
	Kxyn5r+bsVtKt1zZQll2eW3AM08BwqqR69F5BEzyEyju58viTQUWLCmBjpg2CuH5y1key8
	M6/OzV+ZD9ENfHkHVVIeeRvDywc9iqA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-845Ko9v_MUKCnPsArCvSAw-1; Mon, 05 Feb 2024 17:36:13 -0500
X-MC-Unique: 845Ko9v_MUKCnPsArCvSAw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7bfffd9b47fso16098339f.1
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 14:36:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707172572; x=1707777372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/wNE6tBX1rJP2YgS+TTAYHWSHylnSq7QWSxIGxGiQU=;
        b=gNR770YteFae8a38psWK8EdT/60tBwgciQLJeIrpEb16Zp98S/4ghLmFAZ0FoZ0YLe
         +kaa68dXndZnAKz8muMnBCE0MA66FJVdiAxTJechxkHCT2Bg6QMaLLROOIHVlVFSqml1
         imrKWsYRqMbjPLDJSYSIHh3X19xZyAI5YZDSuA3jtLAZdk41F105N1Y421bbrjk3mKDQ
         YzKuLFRUst8kmCoVNN5pt+xnSV0nxHAfJFrNxbp9beVNA1/zp0WWApFxypBe0smvkNXU
         Ie2Ut/TBD4DICicByjsXx+OuyED44F+ENhpbz2jDAqtfL01N0khXf5Xsk3Q8UNpLOr6t
         N2YA==
X-Gm-Message-State: AOJu0Yxy7siCbqTiMtWTAAKR760dJLtPGD+ep3NAhUEPiDHJ2JvOKDka
	eBiostgffpgnnEuPjB+Ocms5Zf9J32hAMhKRYZuxPMbKV2qPgg1gTF88iS4DnyEqoTQz8qBv/yY
	USr9iAiMXJngTnznZCB1eBUFUaNb4O3QWrySSaaxzKTRQZAss5Q==
X-Received: by 2002:a6b:7319:0:b0:7bc:3ceb:6552 with SMTP id e25-20020a6b7319000000b007bc3ceb6552mr1154904ioh.5.1707172572385;
        Mon, 05 Feb 2024 14:36:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtVaTOnvJXbtI7Z0LmCNhuS4b4H75P6HvsKq3NUMpcOrnRrwioOYZJ9zRQS2wuftp2ln8C+g==
X-Received: by 2002:a6b:7319:0:b0:7bc:3ceb:6552 with SMTP id e25-20020a6b7319000000b007bc3ceb6552mr1154887ioh.5.1707172572139;
        Mon, 05 Feb 2024 14:36:12 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUxCfQVCbR6pJ43tYfgys9BBxKwFqEwjwo0/e6nDvW1ISVo8+mYOlffXtXJFJ14F5XcWgVsTOM0/lWGsGjCeeNchPDFH6U3hjMlvIG1E/RpYzwQGn0Vv4F4oxP1aj4rqM92Q0HFDG4zjxmMcBz1AO3qedBjQNf04lKdRX9wtMIZvpMUjWdZ93DF52L0/dCbRRKYFW+JiFR04cUr4o+fnRJuTIfaB+MMf/ib0D8Ss4mZDeEpB642IQV1ncmLOznxeLucxdn4e4erxQ0Evji5NNA7dQciS5FDGurXe85llqZsv85H1mngThVSQ08NPoGTn9iVie8QFA==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 25-20020a0566380a5900b00471374f17a3sm190892jap.136.2024.02.05.14.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 14:36:11 -0800 (PST)
Date: Mon, 5 Feb 2024 15:34:52 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 kvm@vger.kernel.org, dave.jiang@intel.com, ashok.raj@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 03/17] vfio/pci: Consistently acquire mutex for
 interrupt management
Message-ID: <20240205153452.4a9bddfd.alex.williamson@redhat.com>
In-Reply-To: <e7d35d7730f3f83417e757bc264a470f8c2671ed.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <e7d35d7730f3f83417e757bc264a470f8c2671ed.1706849424.git.reinette.chatre@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Feb 2024 20:56:57 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> vfio_pci_set_irqs_ioctl() is the entrypoint for interrupt management
> via the VFIO_DEVICE_SET_IRQS ioctl(). The igate mutex is obtained
> before calling vfio_pci_set_irqs_ioctl() for management of all interrupt
> types to protect against concurrent changes to the eventfds associated
> with device request notification and error interrupts.
> 
> The igate mutex is not acquired consistently. The mutex is always
> (for all interrupt types) acquired from within vfio_pci_ioctl_set_irqs()
> before calling vfio_pci_set_irqs_ioctl(), but vfio_pci_set_irqs_ioctl() is
> called via vfio_pci_core_disable() without the mutex held. The latter
> is expected to be correct if the code flow can be guaranteed that
> the provided interrupt type is not a device request notification or error
> interrupt.

The latter is correct because it's always a physical interrupt type
(INTx/MSI/MSIX), vdev->irq_type dictates this, and the interrupt code
prevents the handler from being called after the interrupt is disabled.
It's intentional that we don't acquire igate here since we only need to
prevent a race with concurrent user access, which cannot occur in the
fd release path.  The igate mutex is acquired consistently, where it's
required. 

It would be more forthcoming to describe that potential future emulated
device interrupts don't make the same guarantees, but if that's true,
why can't they?

> Move igate mutex acquire and release into vfio_pci_set_irqs_ioctl()
> to make the locking consistent irrespective of interrupt type.
> This is one step closer to contain the interrupt management locking
> internals within the interrupt management code so that the VFIO PCI
> core can trigger management of the eventfds associated with device
> request notification and error interrupts without needing to access
> and manipulate VFIO interrupt management locks and data.

If all we want to do is move the mutex into vfio_pci_intr.c then we
could rename to __vfio_pci_set_irqs_ioctl() and create a wrapper around
it that grabs the mutex.  The disable path could use the lockless
version and we wouldn't need to clutter the exit path unlocking the
mutex as done below.  Thanks,

Alex

> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Note to maintainers:
> Originally formed part of the IMS submission below, but is not
> specific to IMS.
> https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com
> 
>  drivers/vfio/pci/vfio_pci_core.c  |  3 ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 10 ++++++++--
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..d2847ca2f0cb 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1214,12 +1214,9 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
>  			return PTR_ERR(data);
>  	}
>  
> -	mutex_lock(&vdev->igate);
> -
>  	ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start,
>  				      hdr.count, data);
>  
> -	mutex_unlock(&vdev->igate);
>  	kfree(data);
>  
>  	return ret;
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 69ab11863282..97a3bb22b186 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -793,7 +793,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
>  		    unsigned int start, unsigned int count, uint32_t flags,
>  		    void *data) = NULL;
> +	int ret = -ENOTTY;
>  
> +	mutex_lock(&vdev->igate);
>  	switch (index) {
>  	case VFIO_PCI_INTX_IRQ_INDEX:
>  		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> @@ -838,7 +840,11 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
>  	}
>  
>  	if (!func)
> -		return -ENOTTY;
> +		goto out_unlock;
> +
> +	ret = func(vdev, index, start, count, flags, data);
> +out_unlock:
> +	mutex_unlock(&vdev->igate);
> +	return ret;
>  
> -	return func(vdev, index, start, count, flags, data);
>  }


