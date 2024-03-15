Return-Path: <kvm+bounces-11919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A94A287D141
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:37:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 376BF1F21C8E
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B893BB28;
	Fri, 15 Mar 2024 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L1Qrw7EN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240F61E4A1
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710520614; cv=none; b=eI8tjtlJaW2fucPGQaiEDI6ML1NaXYl/e6HlR0MchsdWjADua/IF1wMh83UUUC8hjqVM3qLn/DLaiJ2D/oCTGdM0W6itVBWVXA0ywkEdDVia4jW9ESCeIpR2w7GX1xNREDvvSbmV/hqLxHNfiVd8e27eDGeon8lSbwaoPlxAdsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710520614; c=relaxed/simple;
	bh=iwGxO6cxEtXAQo1Lngzsu+O09CGlaIMRBvKyYlye9sA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RdjmDbR5pK6uFwwfWBvr+rt5L96COX8pX8m1bPmB+AIN/1SzkheOeUIwH5pQQBSnS/Qj9vUpo2ZAzb51gmTX/BBMS8Xzt1YHwYUmkMxMw4nDE1fWYaohC9S45RXcqKy7D8ccD420zdyXqidmB0Ziw5hYPxbb/eRRLTv4hs35Wts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L1Qrw7EN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710520611;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LoEZpnSdB/ZldqxVxDwhD5has2xOLA/LrYBq0K/q2lU=;
	b=L1Qrw7ENyTDhsnuLd2j0FIxQJq05j71494mNgzhdSveMnc63JV+7cblCkf4qYydT827Eqi
	5u+bV46iFz4P6t7s6Xu9P1SKlCLXJosw6sshwbSSxqxG3ESWEsYt4hl29Pa1J/4CfiawZn
	jAIcM8VACknd16pF0GoP9NuIWDgTFDQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-dgMNuXKqP1q6iRT0nzNVwQ-1; Fri, 15 Mar 2024 12:36:50 -0400
X-MC-Unique: dgMNuXKqP1q6iRT0nzNVwQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-78823bb1fcbso361199085a.1
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 09:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710520609; x=1711125409;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LoEZpnSdB/ZldqxVxDwhD5has2xOLA/LrYBq0K/q2lU=;
        b=TOPctO1yvfsQg/s7ri9hNASud1HooKrxABluobafyVHsfdgGbkBblLx1Rp9QVHJQsj
         idj9MaYkVPSC713729LD0XGYYI36h1Ins64UExayu9M9o5tfcVCaKiiniCY4+Cv3c6EB
         4CMKImmXps03VKFbXNJdFtuetTdsgz+tOT9P0m8ElW7Yzx/EFpT6gpsFMxgtC4U8DAnz
         gLXl6SFsZbCrISLPjJacaUP3xSMkdHub+Uo72aN792LwA2fewpxDJobLfDHwGIkgc3c2
         gSD38tg/sKXwEQyZwRD5x78jFf7gsBfAjCp9DPhEf+Pq8vTvy7VgZ9yCOpqLiSJQz2id
         Fq7A==
X-Gm-Message-State: AOJu0YwU8DpPX/L3MwUhoX468G/+UrBa9YU5Whw/YHK3FkXk3jrBjo06
	uSU0gwmV1Ew5Goa2E628GLwTdhQe+ItdgWlFEYC1fiSzHgVpyvbrrQ4cCYgeRZm3zPSRqxycijF
	vqtJ7HYFLe/K3oypCodaROZxd7w0f19g6tLXa3RYj5x/UQY0Y2g==
X-Received: by 2002:a05:620a:55ba:b0:789:e71c:207d with SMTP id vr26-20020a05620a55ba00b00789e71c207dmr2147704qkn.27.1710520609197;
        Fri, 15 Mar 2024 09:36:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZdJtnjhNiBM7Iq0IRojnfEffkjOnRqTKDWzfrFq0IHzyJPKGsV4no+KlsFMtZsDFEv6UoCA==
X-Received: by 2002:a05:620a:55ba:b0:789:e71c:207d with SMTP id vr26-20020a05620a55ba00b00789e71c207dmr2147675qkn.27.1710520608765;
        Fri, 15 Mar 2024 09:36:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c27-20020a05620a11bb00b007882fe32acasm2185902qkk.3.2024.03.15.09.36.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:36:48 -0700 (PDT)
Message-ID: <d141c24d-4d88-45ec-b8cf-5697c91cc6a5@redhat.com>
Date: Fri, 15 Mar 2024 17:36:44 +0100
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
Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks

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


