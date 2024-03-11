Return-Path: <kvm+bounces-11516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E91A3877C6C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC30C1C206A8
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75BA1BDE5;
	Mon, 11 Mar 2024 09:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oxyu17tc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A7E30333
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710148536; cv=none; b=LSGFxOp0O6lte0kqfxCh8K+UREgZoPS37bamn67IeliKqWnr6E6M8TlynKm//gXEn6RM/bkH7fZ3S12Ae/AZ6/GZZSu1C9Jzzl60R4SPZh4Pu0ybKi841j4HCMMIHxhr6YEOgtO4DDOnGht1DxWqgVZWwhHo/inU0o5/2mUuqoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710148536; c=relaxed/simple;
	bh=OljCXpTTC9xEaAZuuMjFKsBZIOGdHba4C+7wKVG9xqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f5OlJK2ApxEiIdg4ZUg+gY+T0DGRt55BTF2UKZXbLlSjHXHM07Cxba830B7yJixCydQQWP5jOHW0+QYMuGG9cuKV0p3+evbR2Myl5VV2OR49NvNVR/GJk1b+WCLQFjf9dCAsWZ+oX0OzJtWsWrCV7857uonNGodKzvj1Yqyg4Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oxyu17tc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710148533;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rq057kQqGxIYfRwHYU+lAiC5V15R+aNnjhBGpM/TJFk=;
	b=Oxyu17tcjnvHh81kuVLXFyB8KOkUJGkvwNQ8nCzfKRP/WhJ5pYjPEtaiUoM5hiY+l9i/49
	xPslZLe/xQjEi5gbjScyNb0T6jBQFzd0Rs7upMy18niO9LVYn9ImN7f6M3zikd8fjwk9Ol
	2nEtBi9H9AO6vD0pfEmWz74imxVx8po=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-VsmFb18UMEWOa8b68z7Xlg-1; Mon, 11 Mar 2024 05:15:31 -0400
X-MC-Unique: VsmFb18UMEWOa8b68z7Xlg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4131d4949a3so13039195e9.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 02:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710148530; x=1710753330;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rq057kQqGxIYfRwHYU+lAiC5V15R+aNnjhBGpM/TJFk=;
        b=aJCAUn8iLVaR/7gfJlgT9ZVmQLIwK9f+i8zyr4Bq5ey0+poLXCJyzwvlTF+ovlJrWA
         PFGyeTpL0NKzjROxoDCWCezF/OrtmruW+P0KnTmDZahApBREYeXwrej/GdafMDVhM0+G
         Jxl7Cjgjs2oCFER0QQ8S/XPLhNHIfVFL3YUCoYSFwLVdViOuTZbE025vnrCcmPbomxUY
         Y31JSKdI08Gjd6BGvHsZM+yIOAGv1dlk294ksozRG5xSixBp1iEIzjxuJyPaSnBXVLJc
         lWmznf2NuFHNEJqEj9tDB5xSud5CZClG9QzlEQkg8nmxJQ82VYko+hyEsz7XeYnsfbMl
         Gv/w==
X-Gm-Message-State: AOJu0YzCLygwnHzkj09zCE0hlkOJWtdTr8P08tFSXL8cbCzd5wp3RyMR
	2uiM9EF0E3UcT8VeiL4454pn4At2FvPCvLMacosQLB9STLaLe0pWbzBWDBOETN6uef7FFi9hUKS
	VeglnCemGIB5fAgfTkE+SCVqGWM1AXvu49CrHSflC4/n04aOLkA==
X-Received: by 2002:a05:600c:1e17:b0:413:2f3b:1d42 with SMTP id ay23-20020a05600c1e1700b004132f3b1d42mr159626wmb.18.1710148530146;
        Mon, 11 Mar 2024 02:15:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECTj7+qhQBRTz6RPuyxVPemGxXBcSMWnmrmKwsBP1VHKV5OyEHl4RI88jsU4vFl5t0vOWYFg==
X-Received: by 2002:a05:600c:1e17:b0:413:2f3b:1d42 with SMTP id ay23-20020a05600c1e1700b004132f3b1d42mr159608wmb.18.1710148529725;
        Mon, 11 Mar 2024 02:15:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n4-20020a05600c4f8400b00412ff941abasm14934328wmq.21.2024.03.11.02.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 02:15:29 -0700 (PDT)
Message-ID: <39b0ed62-58e0-4e71-ac22-6426d9ded2e7@redhat.com>
Date: Mon, 11 Mar 2024 10:15:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 4/7] vfio/pci: Create persistent INTx handler
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, clg@redhat.com, reinette.chatre@intel.com,
 linux-kernel@vger.kernel.org, kevin.tian@intel.com, stable@vger.kernel.org
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-5-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240308230557.805580-5-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/9/24 00:05, Alex Williamson wrote:
> A vulnerability exists where the eventfd for INTx signaling can be
> deconfigured, which unregisters the IRQ handler but still allows
> eventfds to be signaled with a NULL context through the SET_IRQS ioctl
> or through unmask irqfd if the device interrupt is pending.
>
> Ideally this could be solved with some additional locking; the igate
> mutex serializes the ioctl and config space accesses, and the interrupt
> handler is unregistered relative to the trigger, but the irqfd path
> runs asynchronous to those.  The igate mutex cannot be acquired from the
> atomic context of the eventfd wake function.  Disabling the irqfd
> relative to the eventfd registration is potentially incompatible with
> existing userspace.
>
> As a result, the solution implemented here moves configuration of the
> INTx interrupt handler to track the lifetime of the INTx context object
> and irq_type configuration, rather than registration of a particular
> trigger eventfd.  Synchronization is added between the ioctl path and
> eventfd_signal() wrapper such that the eventfd trigger can be
> dynamically updated relative to in-flight interrupts or irqfd callbacks.
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
>  drivers/vfio/pci/vfio_pci_intrs.c | 145 ++++++++++++++++--------------
>  1 file changed, 78 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 75c85eec21b3..fb5392b749ff 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -90,11 +90,15 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
>  
>  	if (likely(is_intx(vdev) && !vdev->virq_disabled)) {
>  		struct vfio_pci_irq_ctx *ctx;
> +		struct eventfd_ctx *trigger;
>  
>  		ctx = vfio_irq_ctx_get(vdev, 0);
>  		if (WARN_ON_ONCE(!ctx))
>  			return;
> -		eventfd_signal(ctx->trigger);
> +
> +		trigger = READ_ONCE(ctx->trigger);
> +		if (likely(trigger))
> +			eventfd_signal(trigger);
>  	}
>  }
>  
> @@ -253,100 +257,100 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
>  	return ret;
>  }
>  
> -static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
> +static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
> +			    struct eventfd_ctx *trigger)
>  {
> +	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_irq_ctx *ctx;
> +	unsigned long irqflags;
> +	char *name;
> +	int ret;
>  
>  	if (!is_irq_none(vdev))
>  		return -EINVAL;
>  
> -	if (!vdev->pdev->irq)
> +	if (!pdev->irq)
>  		return -ENODEV;
>  
> +	name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
> +	if (!name)
> +		return -ENOMEM;
> +
>  	ctx = vfio_irq_ctx_alloc(vdev, 0);
>  	if (!ctx)
>  		return -ENOMEM;
>  
> +	ctx->name = name;
> +	ctx->trigger = trigger;
> +
>  	/*
> -	 * If the virtual interrupt is masked, restore it.  Devices
> -	 * supporting DisINTx can be masked at the hardware level
> -	 * here, non-PCI-2.3 devices will have to wait until the
> -	 * interrupt is enabled.
> +	 * Fill the initial masked state based on virq_disabled.  After
> +	 * enable, changing the DisINTx bit in vconfig directly changes INTx
> +	 * masking.  igate prevents races during setup, once running masked
> +	 * is protected via irqlock.
> +	 *
> +	 * Devices supporting DisINTx also reflect the current mask state in
> +	 * the physical DisINTx bit, which is not affected during IRQ setup.
> +	 *
> +	 * Devices without DisINTx support require an exclusive interrupt.
> +	 * IRQ masking is performed at the IRQ chip.  Again, igate protects
> +	 * against races during setup and IRQ handlers and irqfds are not
> +	 * yet active, therefore masked is stable and can be used to
> +	 * conditionally auto-enable the IRQ.
> +	 *
> +	 * irq_type must be stable while the IRQ handler is registered,
> +	 * therefore it must be set before request_irq().
>  	 */
>  	ctx->masked = vdev->virq_disabled;
> -	if (vdev->pci_2_3)
> -		pci_intx(vdev->pdev, !ctx->masked);
> +	if (vdev->pci_2_3) {
> +		pci_intx(pdev, !ctx->masked);
> +		irqflags = IRQF_SHARED;
> +	} else {
> +		irqflags = ctx->masked ? IRQF_NO_AUTOEN : 0;
> +	}
>  
>  	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
>  
> +	ret = request_irq(pdev->irq, vfio_intx_handler,
> +			  irqflags, ctx->name, vdev);
> +	if (ret) {
> +		vdev->irq_type = VFIO_PCI_NUM_IRQS;
> +		kfree(name);
> +		vfio_irq_ctx_free(vdev, ctx, 0);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>  
> -static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
> +static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
> +				struct eventfd_ctx *trigger)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> -	unsigned long irqflags = IRQF_SHARED;
>  	struct vfio_pci_irq_ctx *ctx;
> -	struct eventfd_ctx *trigger;
> -	unsigned long flags;
> -	int ret;
> +	struct eventfd_ctx *old;
>  
>  	ctx = vfio_irq_ctx_get(vdev, 0);
>  	if (WARN_ON_ONCE(!ctx))
>  		return -EINVAL;
>  
> -	if (ctx->trigger) {
> -		free_irq(pdev->irq, vdev);
> -		kfree(ctx->name);
> -		eventfd_ctx_put(ctx->trigger);
> -		ctx->trigger = NULL;
> -	}
> -
> -	if (fd < 0) /* Disable only */
> -		return 0;
> -
> -	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)",
> -			      pci_name(pdev));
> -	if (!ctx->name)
> -		return -ENOMEM;
> -
> -	trigger = eventfd_ctx_fdget(fd);
> -	if (IS_ERR(trigger)) {
> -		kfree(ctx->name);
> -		return PTR_ERR(trigger);
> -	}
> +	old = ctx->trigger;
>  
> -	ctx->trigger = trigger;
> +	WRITE_ONCE(ctx->trigger, trigger);
>  
> -	/*
> -	 * Devices without DisINTx support require an exclusive interrupt,
> -	 * IRQ masking is performed at the IRQ chip.  The masked status is
> -	 * protected by vdev->irqlock. Setup the IRQ without auto-enable and
> -	 * unmask as necessary below under lock.  DisINTx is unmodified by
> -	 * the IRQ configuration and may therefore use auto-enable.
> -	 */
> -	if (!vdev->pci_2_3)
> -		irqflags = IRQF_NO_AUTOEN;
> -
> -	ret = request_irq(pdev->irq, vfio_intx_handler,
> -			  irqflags, ctx->name, vdev);
> -	if (ret) {
> -		ctx->trigger = NULL;
> -		kfree(ctx->name);
> -		eventfd_ctx_put(trigger);
> -		return ret;
> +	/* Releasing an old ctx requires synchronizing in-flight users */
> +	if (old) {
> +		synchronize_irq(pdev->irq);
> +		vfio_virqfd_flush_thread(&ctx->unmask);
> +		eventfd_ctx_put(old);
>  	}
>  
> -	spin_lock_irqsave(&vdev->irqlock, flags);
> -	if (!vdev->pci_2_3 && !ctx->masked)
> -		enable_irq(pdev->irq);
> -	spin_unlock_irqrestore(&vdev->irqlock, flags);
> -
>  	return 0;
>  }
>  
>  static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
>  {
> +	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_irq_ctx *ctx;
>  
>  	ctx = vfio_irq_ctx_get(vdev, 0);
> @@ -354,10 +358,13 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
>  	if (ctx) {
>  		vfio_virqfd_disable(&ctx->unmask);
>  		vfio_virqfd_disable(&ctx->mask);
> +		free_irq(pdev->irq, vdev);
> +		if (ctx->trigger)
> +			eventfd_ctx_put(ctx->trigger);
> +		kfree(ctx->name);
> +		vfio_irq_ctx_free(vdev, ctx, 0);
>  	}
> -	vfio_intx_set_signal(vdev, -1);
>  	vdev->irq_type = VFIO_PCI_NUM_IRQS;
> -	vfio_irq_ctx_free(vdev, ctx, 0);
>  }
>  
>  /*
> @@ -641,19 +648,23 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  		return -EINVAL;
>  
>  	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +		struct eventfd_ctx *trigger = NULL;
>  		int32_t fd = *(int32_t *)data;
>  		int ret;
>  
> -		if (is_intx(vdev))
> -			return vfio_intx_set_signal(vdev, fd);
> +		if (fd >= 0) {
> +			trigger = eventfd_ctx_fdget(fd);
> +			if (IS_ERR(trigger))
> +				return PTR_ERR(trigger);
> +		}
>  
> -		ret = vfio_intx_enable(vdev);
> -		if (ret)
> -			return ret;
> +		if (is_intx(vdev))
> +			ret = vfio_intx_set_signal(vdev, trigger);
> +		else
> +			ret = vfio_intx_enable(vdev, trigger);
>  
> -		ret = vfio_intx_set_signal(vdev, fd);
> -		if (ret)
> -			vfio_intx_disable(vdev);
> +		if (ret && trigger)
> +			eventfd_ctx_put(trigger);
>  
>  		return ret;
>  	}


