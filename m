Return-Path: <kvm+bounces-11519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3035D877CAC
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AEEE1F21075
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52AB7179B7;
	Mon, 11 Mar 2024 09:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOO+QX60"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BD617557
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710149229; cv=none; b=kyir81CvfmziSKldW+W6neD1eh1tvd9cX5A8k/y4T8oisyEfaaCFODr8Cr+k2Yw+T5TVFJ1FC5XBFisR+T4b5Cxdx+TshQLH7cGSLMPxZJVUT6S8tO6Sy2MGKJdLJO8FYNrO3i92J344wDo06MgCN+5RviELvPALl9ygQyMr9YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710149229; c=relaxed/simple;
	bh=lyEY/kP190mfWCxRhA4Oiyr095aRh4xG/WCZTghyHcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m0cWuwKeRIrIEWTmcjyRUoWoQeGGcfNGRkyUm/CfKAZvuIZBDwzUmpNtTj7boLtKKb7oEY054qaC9hWkMto8udIDkFX7BO37wbmdUh60nsSOwUoVytdPJDR9YYcGbqJQxzjFASel5iJiqwGbYGfTTVL54p38EjajbV00ajx2fWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOO+QX60; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710149226;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5yK1M+EQEYTnE/zk2rGApS6nKk3ISA1rDe7r5ZZ70CI=;
	b=jOO+QX60We7QT/tgVF9Ni5epgxy/ar8h85ntiAGpph6g9An7oJ3Inm1MIQZEVS48uAtjOs
	7mxy+5tJ3Mvt/RiW1OLaZouDPDg5ch7MS6QkOUvwJe5vecJ/0w0XJpnk+eN43D27HpqplT
	Mm+GWpTOrZAQldLcF+q1T3LED1k6gY4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-2DH7XhtMOzSu4JQRju_nnQ-1; Mon, 11 Mar 2024 05:27:05 -0400
X-MC-Unique: 2DH7XhtMOzSu4JQRju_nnQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-41312d583dfso17105075e9.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 02:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710149224; x=1710754024;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5yK1M+EQEYTnE/zk2rGApS6nKk3ISA1rDe7r5ZZ70CI=;
        b=hfoc9NcSD/faoM1kBg12SYzT/19Bq8gt3Wep1e69L1QpiSSGdN/N/zW9sDdYR+VhY6
         SEuoi5XXHIaeSfV8JYtVreAH+W8Hnc3fYfxQ5GSetSbvNySnyMw/oh5qy8vk2R15BtZl
         twNQav0sdAnofWrUalZaKL4FA8x5//QzW4ED0TjFosEBDBd33ZlJFmeIQoLVlACqV0Q0
         eOTns/g2DCnNzR/2JQQfR+nvt1gUcyMXj9h4pM9OUEGsUGDnbU0qi6FKXa1WTaeVtkzG
         3aDyGmwMunH7M0XCUWGjOm31oK/jo44RAN7gM72ZLksrXn9Tyx6qU/pjRSVc/Rn0QRpj
         nJwQ==
X-Gm-Message-State: AOJu0YxvS2iffmH5UhtNVvvEE4PchI9YhB4lgqiZVruDCUpiez7ZzvFV
	wigFK+58BMFtbVj5dpXjjjVJZYjbielzTsecvS1lM12bR/su3m8OiTNTiFBULxA82pRbN5tZaZn
	KZWngPY9D8cwAaLiOfZuL8V5vQh6iloNBDqJsOe3KGEY+NX7Khw==
X-Received: by 2002:a05:600c:19ca:b0:412:de1f:dd23 with SMTP id u10-20020a05600c19ca00b00412de1fdd23mr5105502wmq.7.1710149223830;
        Mon, 11 Mar 2024 02:27:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6lHRoMDaUX46Za4AIWLIXmVSXv2bmIdYL7n/uCeWGowZ1rgcWN1qvTVWvXr6sqdGSrCOevQ==
X-Received: by 2002:a05:600c:19ca:b0:412:de1f:dd23 with SMTP id u10-20020a05600c19ca00b00412de1fdd23mr5105485wmq.7.1710149223461;
        Mon, 11 Mar 2024 02:27:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id fs20-20020a05600c3f9400b004132b1385aesm1909711wmb.15.2024.03.11.02.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 02:27:02 -0700 (PDT)
Message-ID: <15cccca9-aeb7-4886-b560-b116e2613901@redhat.com>
Date: Mon, 11 Mar 2024 10:27:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 6/7] vfio/platform: Create persistent IRQ handlers
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, clg@redhat.com, reinette.chatre@intel.com,
 linux-kernel@vger.kernel.org, kevin.tian@intel.com, stable@vger.kernel.org
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-7-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240308230557.805580-7-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alex,

On 3/9/24 00:05, Alex Williamson wrote:
> The vfio-platform SET_IRQS ioctl currently allows loopback triggering of
> an interrupt before a signaling eventfd has been configured by the user,
> which thereby allows a NULL pointer dereference.
>
> Rather than register the IRQ relative to a valid trigger, register all
> IRQs in a disabled state in the device open path.  This allows mask
> operations on the IRQ to nest within the overall enable state governed
> by a valid eventfd signal.  This decouples @masked, protected by the
> @locked spinlock from @trigger, protected via the @igate mutex.
>
> In doing so, it's guaranteed that changes to @trigger cannot race the
> IRQ handlers because the IRQ handler is synchronously disabled before
> modifying the trigger, and loopback triggering of the IRQ via ioctl is
> safe due to serialization with trigger changes via igate.
>
> For compatibility, request_irq() failures are maintained to be local to
> the SET_IRQS ioctl rather than a fatal error in the open device path.
> This allows, for example, a userspace driver with polling mode support
> to continue to work regardless of moving the request_irq() call site.
> This necessarily blocks all SET_IRQS access to the failed index.
>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 57f972e2b341 ("vfio/platform: trigger an interrupt via eventfd")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric
> ---
>  drivers/vfio/platform/vfio_platform_irq.c | 100 +++++++++++++++-------
>  1 file changed, 68 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index e5dcada9e86c..ef41ecef83af 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -136,6 +136,16 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>  	return 0;
>  }
>  
> +/*
> + * The trigger eventfd is guaranteed valid in the interrupt path
> + * and protected by the igate mutex when triggered via ioctl.
> + */
> +static void vfio_send_eventfd(struct vfio_platform_irq *irq_ctx)
> +{
> +	if (likely(irq_ctx->trigger))
> +		eventfd_signal(irq_ctx->trigger);
> +}
> +
>  static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
>  {
>  	struct vfio_platform_irq *irq_ctx = dev_id;
> @@ -155,7 +165,7 @@ static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
>  	spin_unlock_irqrestore(&irq_ctx->lock, flags);
>  
>  	if (ret == IRQ_HANDLED)
> -		eventfd_signal(irq_ctx->trigger);
> +		vfio_send_eventfd(irq_ctx);
>  
>  	return ret;
>  }
> @@ -164,52 +174,40 @@ static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>  {
>  	struct vfio_platform_irq *irq_ctx = dev_id;
>  
> -	eventfd_signal(irq_ctx->trigger);
> +	vfio_send_eventfd(irq_ctx);
>  
>  	return IRQ_HANDLED;
>  }
>  
>  static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
> -			    int fd, irq_handler_t handler)
> +			    int fd)
>  {
>  	struct vfio_platform_irq *irq = &vdev->irqs[index];
>  	struct eventfd_ctx *trigger;
> -	int ret;
>  
>  	if (irq->trigger) {
> -		irq_clear_status_flags(irq->hwirq, IRQ_NOAUTOEN);
> -		free_irq(irq->hwirq, irq);
> -		kfree(irq->name);
> +		disable_irq(irq->hwirq);
>  		eventfd_ctx_put(irq->trigger);
>  		irq->trigger = NULL;
>  	}
>  
>  	if (fd < 0) /* Disable only */
>  		return 0;
> -	irq->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-irq[%d](%s)",
> -			      irq->hwirq, vdev->name);
> -	if (!irq->name)
> -		return -ENOMEM;
>  
>  	trigger = eventfd_ctx_fdget(fd);
> -	if (IS_ERR(trigger)) {
> -		kfree(irq->name);
> +	if (IS_ERR(trigger))
>  		return PTR_ERR(trigger);
> -	}
>  
>  	irq->trigger = trigger;
>  
> -	irq_set_status_flags(irq->hwirq, IRQ_NOAUTOEN);
> -	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
> -	if (ret) {
> -		kfree(irq->name);
> -		eventfd_ctx_put(trigger);
> -		irq->trigger = NULL;
> -		return ret;
> -	}
> -
> -	if (!irq->masked)
> -		enable_irq(irq->hwirq);
> +	/*
> +	 * irq->masked effectively provides nested disables within the overall
> +	 * enable relative to trigger.  Specifically request_irq() is called
> +	 * with NO_AUTOEN, therefore the IRQ is initially disabled.  The user
> +	 * may only further disable the IRQ with a MASK operations because
> +	 * irq->masked is initially false.
> +	 */
> +	enable_irq(irq->hwirq);
>  
>  	return 0;
>  }
> @@ -228,7 +226,7 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>  		handler = vfio_irq_handler;
>  
>  	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
> -		return vfio_set_trigger(vdev, index, -1, handler);
> +		return vfio_set_trigger(vdev, index, -1);
>  
>  	if (start != 0 || count != 1)
>  		return -EINVAL;
> @@ -236,7 +234,7 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>  	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
>  		int32_t fd = *(int32_t *)data;
>  
> -		return vfio_set_trigger(vdev, index, fd, handler);
> +		return vfio_set_trigger(vdev, index, fd);
>  	}
>  
>  	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> @@ -260,6 +258,14 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  		    unsigned start, unsigned count, uint32_t flags,
>  		    void *data) = NULL;
>  
> +	/*
> +	 * For compatibility, errors from request_irq() are local to the
> +	 * SET_IRQS path and reflected in the name pointer.  This allows,
> +	 * for example, polling mode fallback for an exclusive IRQ failure.
> +	 */
> +	if (IS_ERR(vdev->irqs[index].name))
> +		return PTR_ERR(vdev->irqs[index].name);
> +
>  	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>  	case VFIO_IRQ_SET_ACTION_MASK:
>  		func = vfio_platform_set_irq_mask;
> @@ -280,7 +286,7 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  
>  int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  {
> -	int cnt = 0, i;
> +	int cnt = 0, i, ret = 0;
>  
>  	while (vdev->get_irq(vdev, cnt) >= 0)
>  		cnt++;
> @@ -292,29 +298,54 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  
>  	for (i = 0; i < cnt; i++) {
>  		int hwirq = vdev->get_irq(vdev, i);
> +		irq_handler_t handler = vfio_irq_handler;
>  
> -		if (hwirq < 0)
> +		if (hwirq < 0) {
> +			ret = -EINVAL;
>  			goto err;
> +		}
>  
>  		spin_lock_init(&vdev->irqs[i].lock);
>  
>  		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
>  
> -		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
> +		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK) {
>  			vdev->irqs[i].flags |= VFIO_IRQ_INFO_MASKABLE
>  						| VFIO_IRQ_INFO_AUTOMASKED;
> +			handler = vfio_automasked_irq_handler;
> +		}
>  
>  		vdev->irqs[i].count = 1;
>  		vdev->irqs[i].hwirq = hwirq;
>  		vdev->irqs[i].masked = false;
> +		vdev->irqs[i].name = kasprintf(GFP_KERNEL_ACCOUNT,
> +					       "vfio-irq[%d](%s)", hwirq,
> +					       vdev->name);
> +		if (!vdev->irqs[i].name) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +
> +		ret = request_irq(hwirq, handler, IRQF_NO_AUTOEN,
> +				  vdev->irqs[i].name, &vdev->irqs[i]);
> +		if (ret) {
> +			kfree(vdev->irqs[i].name);
> +			vdev->irqs[i].name = ERR_PTR(ret);
> +		}
>  	}
>  
>  	vdev->num_irqs = cnt;
>  
>  	return 0;
>  err:
> +	for (--i; i >= 0; i--) {
> +		if (!IS_ERR(vdev->irqs[i].name)) {
> +			free_irq(vdev->irqs[i].hwirq, &vdev->irqs[i]);
> +			kfree(vdev->irqs[i].name);
> +		}
> +	}
>  	kfree(vdev->irqs);
> -	return -EINVAL;
> +	return ret;
>  }
>  
>  void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
> @@ -324,7 +355,12 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>  	for (i = 0; i < vdev->num_irqs; i++) {
>  		vfio_virqfd_disable(&vdev->irqs[i].mask);
>  		vfio_virqfd_disable(&vdev->irqs[i].unmask);
> -		vfio_set_trigger(vdev, i, -1, NULL);
> +		if (!IS_ERR(vdev->irqs[i].name)) {
> +			free_irq(vdev->irqs[i].hwirq, &vdev->irqs[i]);
> +			if (vdev->irqs[i].trigger)
> +				eventfd_ctx_put(vdev->irqs[i].trigger);
> +			kfree(vdev->irqs[i].name);
> +		}
>  	}
>  
>  	vdev->num_irqs = 0;


