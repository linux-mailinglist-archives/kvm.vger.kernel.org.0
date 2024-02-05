Return-Path: <kvm+bounces-8052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E31784A969
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F5701C268E0
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A5A4EB24;
	Mon,  5 Feb 2024 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ftSovYn/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FF03B18D
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 22:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707172585; cv=none; b=ObUfxWLIJllMC26pZFtMM9Dkic4aYiEA5WDNPJVAPkZhe00pSvmIb4BWr4ZzCr2najVtGUi9jeNuzB9qQsswTuF9fVNxFsB1ZGKpIDCYCJIfhLiAZFdKFY0Zk2owSz/eIuznFVA/MJfnF0I88trljAYoGD5egAXQMP8USeoZ1bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707172585; c=relaxed/simple;
	bh=tQYzp9SdXUzG0xLurc/XHpBlZgBc1bnK/04i7jWikjU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O990t7XcjQK+DVMuvfR3CLc3U0EbGvOVmSZ5PSo2yr9PwBAXwXleNQC/npJcr66RQYDhpZ7LzliFkQT5axVUhwqEy6TIxntNpYCFnuToJ8z+R/EWP10IVH6rXpgos+e/1ouHxh44kMwTh6cvdYAl8ySDqbpJIleGTdsmm1ZJ7zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ftSovYn/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707172582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YUN+bXoLMWNzCpIOoKPYpB5Mi94BSsgEo9d5vZmJz2U=;
	b=ftSovYn/nBn54UCBhBA2AOmQ1CHKeJfeh2LPAMUT11X6bAsPumEReSqZThf6q19ocmFi/G
	PxnMTQlnojSeLm+SBQEcjqSMLToYtvfdrrs7FS1r6i0B7Crep/Z+GxN0+VQVXSXSSSJnNo
	3T2tAjqzqeMMrD6cLjJkBHh8KveGsMg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-VKCbcujdO-eT_UKVR_SSLA-1; Mon, 05 Feb 2024 17:36:21 -0500
X-MC-Unique: VKCbcujdO-eT_UKVR_SSLA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7bc2b7bef65so416721339f.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 14:36:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707172580; x=1707777380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YUN+bXoLMWNzCpIOoKPYpB5Mi94BSsgEo9d5vZmJz2U=;
        b=iQLsPMSEBvKrV/5+gMeWwgmGQCbe1plE1t+xgAkArYPALXrO/PgwzkLwnaK3AeKw+b
         GQyIU1wr3RM+Yl5PMKpuNG7lf1J1CXCcGzHRxN+N0uUAhoVtoGPzwG3Mn3NdG6edvPcx
         vgxqtMg+WPqPqMGGiypXz7mRgWSuThKWeyDTJ8opQLhHGXJZT9nbXpBjA0i8N6/41JeQ
         nsvztkHxzIJzzqEsx3+BwNDzNZ9V/C0m+aOihff6idAwSpS3Eix9ffIOuXhq4x+adopG
         9N4+Y8m8EdhwYg2+T2VwB8S15mS0XaMpHWA5IgZYxrbn7u2sH8gY0hHYAVmQxB5yfIBW
         7pIg==
X-Gm-Message-State: AOJu0YyQ6Y8hnFcqEP769fFKSevJjrf930D4eVsnho1ox3sGivx6/kFO
	B3xVw9xERgjZdZdVosjtyEUVLhSSbXVY+v9a0u/za39vJCCit5xnhOA6uFb+0p3zVDMN0Ei5mfG
	fxXHC6Nnzreej54mzAuZZrNNAw5uwh9wrkly1wvbL4d9niPMZJQ==
X-Received: by 2002:a5d:994e:0:b0:7c0:d720:feeb with SMTP id v14-20020a5d994e000000b007c0d720feebmr1073324ios.10.1707172580227;
        Mon, 05 Feb 2024 14:36:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwz6HmhbIt6edQt8YMo/85UARzI/3+ayNSEB4R0oXk3pXsiSh8haZ3BrQjhZeECtJ7oGe/tQ==
X-Received: by 2002:a5d:994e:0:b0:7c0:d720:feeb with SMTP id v14-20020a5d994e000000b007c0d720feebmr1073303ios.10.1707172579918;
        Mon, 05 Feb 2024 14:36:19 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWrm/Dm1MS08KOfOvLtnlig9zrsigeFkEQ8Zv9KuOrRp5W0uBSZ2A7pjjpefihjYqzFWgaweuErD419DHAsT9dOoL4JaXJh9nV4IgNmUJhHn6y3SaxiK/p0V1mGPBN5q4gOGdfsB2SKKfAjZjh520eVJpMBETkSqsQVCEtTgw0YJAktg7uZ3I0oDOZyEaKJy+IFru99HgluEZsJnFZnqVbqkM4vEnTJkF8p21P7/dl+uQaBZfIVMLM1QJKDi/y7Z86oJvkPd5iU29XGJbPR9zyB5BkmrjQCeykhmyO5B2/vYstIqDmFjHi+v0Lfbo6MZNmevcfktA==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 25-20020a0566380a5900b00471374f17a3sm190892jap.136.2024.02.05.14.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 14:36:18 -0800 (PST)
Date: Mon, 5 Feb 2024 15:35:09 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 kvm@vger.kernel.org, dave.jiang@intel.com, ashok.raj@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 07/17] vfio/pci: Preserve per-interrupt contexts
Message-ID: <20240205153509.333c2c95.alex.williamson@redhat.com>
In-Reply-To: <d6e32e0e7adaf61da39fb6cd2863298b15a2663e.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<d6e32e0e7adaf61da39fb6cd2863298b15a2663e.1706849424.git.reinette.chatre@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Feb 2024 20:57:01 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> MSI and MSI-X interrupt management for PCI passthrough devices create
> a new per-interrupt context every time an interrupt is allocated,
> freeing it when the interrupt is freed.
> 
> The per-interrupt context contains the properties of a particular
> interrupt. Without a property that persists across interrupt allocation
> and free it is acceptable to always create a new per-interrupt context.
> 
> INTx interrupt context has a "masked" property that persists across
> allocation and free and thus preserves its interrupt context
> across interrupt allocation and free calls.
> 
> MSI and MSI-X interrupts already remain allocated across interrupt
> allocation and free requests, additionally maintaining the
> individual interrupt context is a reflection of this existing
> behavior and matches INTx behavior so that more code can be shared.
> 
> An additional benefit is that maintaining interrupt context supports
> a potential future use case of emulated interrupts, where the
> "is this interrupt emulated" is a property that needs to persist
> across allocation and free requests.
> 
> Persistent interrupt contexts means that existence of per-interrupt
> context no longer implies a valid trigger, pointers to freed memory
> should be cleared, and a new per-interrupt context cannot be assumed
> needing allocation when an interrupt is allocated.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Note to maintainers:
> This addition originally formed part of the IMS work below that mostly
> ignored INTx. This work focuses on INTx, MSI, MSI-X where this addition
> is relevant.
> https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com
> 
>  drivers/vfio/pci/vfio_pci_intrs.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 31f73c70fcd2..7ca2b983b66e 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -427,7 +427,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  
>  	ctx = vfio_irq_ctx_get(vdev, vector);
>  
> -	if (ctx) {
> +	if (ctx && ctx->trigger) {
>  		irq_bypass_unregister_producer(&ctx->producer);
>  		irq = pci_irq_vector(pdev, vector);
>  		cmd = vfio_pci_memory_lock_and_enable(vdev);
> @@ -435,8 +435,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  		vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  		/* Interrupt stays allocated, will be freed at MSI-X disable. */
>  		kfree(ctx->name);
> +		ctx->name = NULL;

Setting ctx->name = NULL is not strictly necessary and does not match
the INTx code that we're claiming to try to emulate.  ctx->name is only
tested immediately after allocation below, otherwise it can be inferred
from ctx->trigger.  Thanks,

Alex

>  		eventfd_ctx_put(ctx->trigger);
> -		vfio_irq_ctx_free(vdev, ctx, vector);
> +		ctx->trigger = NULL;
>  	}
>  
>  	if (fd < 0)
> @@ -449,16 +450,17 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  			return irq;
>  	}
>  
> -	ctx = vfio_irq_ctx_alloc(vdev, vector);
> -	if (!ctx)
> -		return -ENOMEM;
> +	/* Per-interrupt context remain allocated. */
> +	if (!ctx) {
> +		ctx = vfio_irq_ctx_alloc(vdev, vector);
> +		if (!ctx)
> +			return -ENOMEM;
> +	}
>  
>  	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
>  			      msix ? "x" : "", vector, pci_name(pdev));
> -	if (!ctx->name) {
> -		ret = -ENOMEM;
> -		goto out_free_ctx;
> -	}
> +	if (!ctx->name)
> +		return -ENOMEM;
>  
>  	trigger = eventfd_ctx_fdget(fd);
>  	if (IS_ERR(trigger)) {
> @@ -502,8 +504,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  	eventfd_ctx_put(trigger);
>  out_free_name:
>  	kfree(ctx->name);
> -out_free_ctx:
> -	vfio_irq_ctx_free(vdev, ctx, vector);
> +	ctx->name = NULL;
>  	return ret;
>  }
>  
> @@ -539,6 +540,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
>  		vfio_virqfd_disable(&ctx->unmask);
>  		vfio_virqfd_disable(&ctx->mask);
>  		vfio_msi_set_vector_signal(vdev, i, -1, index);
> +		vfio_irq_ctx_free(vdev, ctx, i);
>  	}
>  
>  	cmd = vfio_pci_memory_lock_and_enable(vdev);
> @@ -694,7 +696,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  
>  	for (i = start; i < start + count; i++) {
>  		ctx = vfio_irq_ctx_get(vdev, i);
> -		if (!ctx)
> +		if (!ctx || !ctx->trigger)
>  			continue;
>  		if (flags & VFIO_IRQ_SET_DATA_NONE) {
>  			eventfd_signal(ctx->trigger);


