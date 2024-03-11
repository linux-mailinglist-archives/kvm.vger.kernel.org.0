Return-Path: <kvm+bounces-11514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F262877C5E
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B34901C20BA4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FC015AF6;
	Mon, 11 Mar 2024 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFNOEvD2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C72B9BE
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710148482; cv=none; b=bNIyuvyzZ1wyvh199CfKcYxKQ8DVkMFaHr93SOpH2WMz14rSkKCxDZYGNuBqSt2UeC5bEdqiZLh5bZ25dM9FWAEFrHqY91GkGqwpLqmFR4+74+rTT66ST49qOgoYghWBudoXOlnSaiowbVDtt/wdGdNaZxkx9DGM9O3BK8stiy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710148482; c=relaxed/simple;
	bh=GKXb8uyTmcX+BoM9FWSbMbug4mOmav/ZtgYdiStOX8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TUzW1aNeyrWRk5utW4dBZmM8XDMFZDlrgX6WT4z328sjYqhG2n4z5PnejpYR4OaM+LsXnigPBzLRadr7f5ScikBDw7Dg+BonPw/PcyU9mYg35MTdv2zfExmG70BjjJqXido0uloHCEF9YrXGoFDMfeSQbX5rDSJS0pdPnrl0mMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFNOEvD2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710148479;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FTy099VqA5Yt0EUdnyLsR3RmVIsDYGIfwYRs4grpYk4=;
	b=PFNOEvD2JIsJEF7NFgfr/EAbedM3VL3l8hkpZBGXX5ofva1eMoWwYLySyk+0R8C0ryb+nq
	0V3QerDonp4oC8oc+IIsWQNgHyAdPI/tAvoPatlWi4AHEkqLR0vUxIXG0nL0ZPRHx/vvEG
	TK/VpAcndRTxnnpkIekfHeGVMFvdIpY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-q1gdOPKvMKmm3AFQhZ6rQQ-1; Mon, 11 Mar 2024 05:14:37 -0400
X-MC-Unique: q1gdOPKvMKmm3AFQhZ6rQQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-412fb99c892so20717845e9.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 02:14:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710148476; x=1710753276;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FTy099VqA5Yt0EUdnyLsR3RmVIsDYGIfwYRs4grpYk4=;
        b=A0DkfjUoWI16CkozfxoagYEFJiY7Ay12Ee2b7SeOPdylyt147o2BmOHwXFl2QSAvWS
         E0kZ8oj9taQX7PZGhTbK4YSgwpPJHvKnrsOGq5peMYXu5Cl7usgOoiPBnYO7YhpjLBO0
         oVGoI20ehCHP7jsjHOnjdFeDVqSaY9PDEpZbO5xJ0DYMvg8oxWKyK158vBqcUFJ0SEm0
         I3ej3JTqXnYUcyej9YmrPnr9tWVRoEEpmeXeh5TL11nvblfmQSkzLjDaQByYwQvBbpIc
         tAExqAjgSohKWy+OPeJg07vmUp9NW8jKtWdTwlXjwsKLqf6/CgI4gZHiz/ccCXHEAAEY
         eCcA==
X-Gm-Message-State: AOJu0YyzpGXyN0b00HbQ1Xllubfq4Yu9TbIWh8DjiVLroc/z9SEslqBv
	meXX07UMInW1BygcKlBRuj3WDGmEd+rcFBfX0WhuL5csSuqOdlP/C4JH8L/SAvCC9I6mfEa6o3K
	LsJEorIV4QYvXWwtW2Z61frkr6xHpNEu2brBSYvU5zNArH2ZCGg==
X-Received: by 2002:a05:600c:35c8:b0:412:f481:e38b with SMTP id r8-20020a05600c35c800b00412f481e38bmr4730522wmq.30.1710148475874;
        Mon, 11 Mar 2024 02:14:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHejfzMsvYA/m0zkMfBeSAVYajGwbqM2gdt7nx0CBADchCylS+VWyZ4B2x0VYvIdXoWqEfQvA==
X-Received: by 2002:a05:600c:35c8:b0:412:f481:e38b with SMTP id r8-20020a05600c35c800b00412f481e38bmr4730508wmq.30.1710148475553;
        Mon, 11 Mar 2024 02:14:35 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n4-20020a05600c4f8400b00412ff941abasm14934328wmq.21.2024.03.11.02.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 02:14:34 -0700 (PDT)
Message-ID: <2e2ec36a-3d48-48f0-8019-f1c1b320a477@redhat.com>
Date: Mon, 11 Mar 2024 10:14:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/7] vfio/pci: Lock external INTx masking ops
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, clg@redhat.com, reinette.chatre@intel.com,
 linux-kernel@vger.kernel.org, kevin.tian@intel.com, stable@vger.kernel.org
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-3-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240308230557.805580-3-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/9/24 00:05, Alex Williamson wrote:
> Mask operations through config space changes to DisINTx may race INTx
> configuration changes via ioctl.  Create wrappers that add locking for
> paths outside of the core interrupt code.
>
> In particular, irq_type is updated holding igate, therefore testing
> is_intx() requires holding igate.  For example clearing DisINTx from
> config space can otherwise race changes of the interrupt configuration.
>
> This aligns interfaces which may trigger the INTx eventfd into two
> camps, one side serialized by igate and the other only enabled while
> INTx is configured.  A subsequent patch introduces synchronization for
> the latter flows.
>
> Cc: stable@vger.kernel.org
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 34 +++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 136101179fcb..75c85eec21b3 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -99,13 +99,15 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
>  }
>  
>  /* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
> -bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
> +static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_irq_ctx *ctx;
>  	unsigned long flags;
>  	bool masked_changed = false;
>  
> +	lockdep_assert_held(&vdev->igate);
> +
>  	spin_lock_irqsave(&vdev->irqlock, flags);
>  
>  	/*
> @@ -143,6 +145,17 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
>  	return masked_changed;
>  }
>  
> +bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
> +{
> +	bool mask_changed;
> +
> +	mutex_lock(&vdev->igate);
> +	mask_changed = __vfio_pci_intx_mask(vdev);
> +	mutex_unlock(&vdev->igate);
> +
> +	return mask_changed;
> +}
> +
>  /*
>   * If this is triggered by an eventfd, we can't call eventfd_signal
>   * or else we'll deadlock on the eventfd wait queue.  Return >0 when
> @@ -194,12 +207,21 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
>  	return ret;
>  }
>  
> -void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
> +static void __vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
>  {
> +	lockdep_assert_held(&vdev->igate);
> +
>  	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
>  		vfio_send_intx_eventfd(vdev, NULL);
>  }
>  
> +void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
> +{
> +	mutex_lock(&vdev->igate);
> +	__vfio_pci_intx_unmask(vdev);
> +	mutex_unlock(&vdev->igate);
> +}
> +
>  static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
>  {
>  	struct vfio_pci_core_device *vdev = dev_id;
> @@ -563,11 +585,11 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
>  		return -EINVAL;
>  
>  	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> -		vfio_pci_intx_unmask(vdev);
> +		__vfio_pci_intx_unmask(vdev);
>  	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>  		uint8_t unmask = *(uint8_t *)data;
>  		if (unmask)
> -			vfio_pci_intx_unmask(vdev);
> +			__vfio_pci_intx_unmask(vdev);
>  	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>  		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
>  		int32_t fd = *(int32_t *)data;
> @@ -594,11 +616,11 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
>  		return -EINVAL;
>  
>  	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> -		vfio_pci_intx_mask(vdev);
> +		__vfio_pci_intx_mask(vdev);
>  	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>  		uint8_t mask = *(uint8_t *)data;
>  		if (mask)
> -			vfio_pci_intx_mask(vdev);
> +			__vfio_pci_intx_mask(vdev);
>  	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>  		return -ENOTTY; /* XXX implement me */
>  	}


