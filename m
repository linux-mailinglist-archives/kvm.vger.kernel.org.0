Return-Path: <kvm+bounces-8049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD47684A963
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D13DB1C251BD
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 22:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E7F482CC;
	Mon,  5 Feb 2024 22:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXhc3sXQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB1E1EF1D
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 22:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707172580; cv=none; b=cXXlGNezNvYiKFD1MOKogZR6RZ996w4GfwUT3YnN/3wwPqU4iWGLqkL9sS5f32z3bjl5nDcrlrNXJapxxt8z4hGqOYFP+w2etP3mPmSkPfDhGDpYa/9SLvqawAh7Apoz2HL68DSfClnCzDoGD2IAuWlIVA8UtZbA8AubVZfnN+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707172580; c=relaxed/simple;
	bh=65VZqcI8OBYyezS/SkDpbLVIz1ao5vEb1GGI1u6RZ9I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lfF9oGnW6tXoNe1SVs5Et+L62SHofAQrScw77/g7wU6ZiMBOFq7XA23oBdqi5zA/ccJGn7XDipSG8esKDnEhTziiqE7bKSxLrpUTEWYvxR8hXOeDnud0E+ZBomr6IHnqpsj3w1u7tvTHiK7eCQcsIOcYLy1qDQ0zLyJ9sWplgys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXhc3sXQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707172576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrWATdsv9Jzyg9vM7+tgmPJwxqLwuEEi9F/It25NMr0=;
	b=EXhc3sXQ+O0LXxg1+exWPsF+MGWkJiKsN8g/YMG2hOe3dNlfJON3Mbb2vtvL0JAqnf6YET
	+x5o5ygzU1vCOQrNqj0L+2hHET2npDFRjn9ZGDOV9y/0V/BxRwfkQ8vo2R3Df72d0/sY2m
	ly1CTE7vALZHpIr1wB+uaDoc3WuIX+0=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-C2ip5_YPMEGg73gsuxiXLQ-1; Mon, 05 Feb 2024 17:36:15 -0500
X-MC-Unique: C2ip5_YPMEGg73gsuxiXLQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7bf7e0c973eso442715339f.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 14:36:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707172574; x=1707777374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DrWATdsv9Jzyg9vM7+tgmPJwxqLwuEEi9F/It25NMr0=;
        b=o2ifnfDrJ1xnr6QmjFQW4grBbc6QFPG7XhOlWd6eCmd4Z1unz4kqI+I0QMG971YPBQ
         9++wAVlUuB+0hXZsoF9gAVscuhcxNo+CcA9JcAcC3xqpYOGrslAlGi8F5wCD/kL3vnqs
         A/ga8t5mvNYhsdXBdB8ifaqRa1oSjKrapvDJ5+i9BWrs3ueXA9tlQnIdEjtxgIr83EZ7
         1Cm/8NpCDe22dB+t+T9LZhPfMzgEihvyQozWjDEDnsuz39qz0BTWfI7MwnPH4V246gEf
         8ZaDMiyjAsSifHW/ZwgHukafoc7Bj2NYLcnUPVdUR4vEnP1fWtkBL4p/d1g///tp5KpH
         11zw==
X-Gm-Message-State: AOJu0Yy3SX43w4ubmb7SNG57PKfVLaL5T4oqPHRfmW0RDQ/51X77Fy9C
	Ww8JeOIHpUTrc+LIXiDYlXtpFG0QpFaC404RSUrNDOhYlRB7zmgu4acg2PXSZKf7f+aHoPVQYq8
	r03Z4u8eMBlC5yZi+C1LxfaLimzkTzztUxMO1G+2fwAg5J7r1dg==
X-Received: by 2002:a6b:da08:0:b0:7bf:fe52:683f with SMTP id x8-20020a6bda08000000b007bffe52683fmr540845iob.8.1707172574670;
        Mon, 05 Feb 2024 14:36:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQWAIahfub6hm77mreRm7GYe/Dz7f7kDH7bXORnIVgzzMoYsIFNHpVbNKRUvnquD/8icXjCQ==
X-Received: by 2002:a6b:da08:0:b0:7bf:fe52:683f with SMTP id x8-20020a6bda08000000b007bffe52683fmr540831iob.8.1707172574401;
        Mon, 05 Feb 2024 14:36:14 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXj9YYEyHa6aI3wpgtiA14LMfn+g0H8W19QcRJqcoeOx5eK52pnBU5RI6YwSpywMlQu3f7PgnJ8bnRbB6Y88hxImu306ii8Nh3ZiFVDxdjbDcO6bQMKVxvV8whyDMK1eTUsDvhqdlwCjJKP/uwEbaOECUw1AFjSWrHCzsr8DccWGUmg8mTzQG9l9th5H8Nvsig2IgZOAI34B7Yu3gH2eCVUOzy5MA+iIXGufVP6NUBgd/eeUNhGtWiHHIW/3JEVTcuHBCPhBvnf6/xgbq8FCxViWRNkResj5hq31xzjorMfacikGDYItOX5365kdbdJlt5/jwcKBg==
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 25-20020a0566380a5900b00471374f17a3sm190892jap.136.2024.02.05.14.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 14:36:13 -0800 (PST)
Date: Mon, 5 Feb 2024 15:35:02 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 kvm@vger.kernel.org, dave.jiang@intel.com, ashok.raj@intel.com,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 06/17] vfio/pci: Remove interrupt index interpretation
 from wrappers
Message-ID: <20240205153502.051ff2bf.alex.williamson@redhat.com>
In-Reply-To: <ca249ad459c07a36cd64137ee1cc107dcd8b6f4c.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
	<ca249ad459c07a36cd64137ee1cc107dcd8b6f4c.1706849424.git.reinette.chatre@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Feb 2024 20:57:00 -0800
Reinette Chatre <reinette.chatre@intel.com> wrote:

> vfio_pci_set_intx_trigger() and vfio_pci_set_msi_trigger() have similar
> enough flows that can be converged into one shared flow instead of
> duplicated.
> 
> To share code between management of interrupt types it is necessary that
> the type of the interrupt is only interpreted by the code specific to
> the interrupt type being managed.
> 
> Remove interrupt type interpretation from what will eventually be
> shared code (vfio_pci_set_msi_trigger(), vfio_msi_set_block()) by
> pushing this interpretation to be within the interrupt
> type specific code (vfio_msi_enable(),
> (temporary) vfio_msi_set_vector_signal()).
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Note to maintainers:
> Originally formed part of the IMS submission below, but is not
> specific to IMS.
> https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com
> 
>  drivers/vfio/pci/vfio_pci_intrs.c | 38 +++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 97a3bb22b186..31f73c70fcd2 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -346,16 +346,19 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
>  	return IRQ_HANDLED;
>  }
>  
> -static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msix)
> +static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec,
> +			   unsigned int index)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> -	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
> +	unsigned int flag;
>  	int ret;
>  	u16 cmd;
>  
>  	if (!is_irq_none(vdev))
>  		return -EINVAL;
>  
> +	flag = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
> +
>  	/* return the number of supported vectors if we can't get all: */
>  	cmd = vfio_pci_memory_lock_and_enable(vdev);
>  	ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
> @@ -367,10 +370,9 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
>  	}
>  	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  
> -	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
> -				VFIO_PCI_MSI_IRQ_INDEX;
> +	vdev->irq_type = index;
>  
> -	if (!msix) {
> +	if (index == VFIO_PCI_MSI_IRQ_INDEX) {
>  		/*
>  		 * Compute the virtual hardware field for max msi vectors -
>  		 * it is the log base 2 of the number of vectors.
> @@ -413,8 +415,10 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
>  }
>  
>  static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
> -				      unsigned int vector, int fd, bool msix)
> +				      unsigned int vector, int fd,
> +				      unsigned int index)
>  {
> +	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;

Cleanup the unnecessary ternary while here, this can just be:

	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX);

Thanks,

Alex

>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_irq_ctx *ctx;
>  	struct eventfd_ctx *trigger;
> @@ -505,25 +509,26 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  
>  static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
>  			      unsigned int start, unsigned int count,
> -			      int32_t *fds, bool msix)
> +			      int32_t *fds, unsigned int index)
>  {
>  	unsigned int i, j;
>  	int ret = 0;
>  
>  	for (i = 0, j = start; i < count && !ret; i++, j++) {
>  		int fd = fds ? fds[i] : -1;
> -		ret = vfio_msi_set_vector_signal(vdev, j, fd, msix);
> +		ret = vfio_msi_set_vector_signal(vdev, j, fd, index);
>  	}
>  
>  	if (ret) {
>  		for (i = start; i < j; i++)
> -			vfio_msi_set_vector_signal(vdev, i, -1, msix);
> +			vfio_msi_set_vector_signal(vdev, i, -1, index);
>  	}
>  
>  	return ret;
>  }
>  
> -static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
> +static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
> +			     unsigned int index)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_irq_ctx *ctx;
> @@ -533,7 +538,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
>  	xa_for_each(&vdev->ctx, i, ctx) {
>  		vfio_virqfd_disable(&ctx->unmask);
>  		vfio_virqfd_disable(&ctx->mask);
> -		vfio_msi_set_vector_signal(vdev, i, -1, msix);
> +		vfio_msi_set_vector_signal(vdev, i, -1, index);
>  	}
>  
>  	cmd = vfio_pci_memory_lock_and_enable(vdev);
> @@ -656,10 +661,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  {
>  	struct vfio_pci_irq_ctx *ctx;
>  	unsigned int i;
> -	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
>  
>  	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
> -		vfio_msi_disable(vdev, msix);
> +		vfio_msi_disable(vdev, index);
>  		return 0;
>  	}
>  
> @@ -672,15 +676,15 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
>  
>  		if (vdev->irq_type == index)
>  			return vfio_msi_set_block(vdev, start, count,
> -						  fds, msix);
> +						  fds, index);
>  
> -		ret = vfio_msi_enable(vdev, start + count, msix);
> +		ret = vfio_msi_enable(vdev, start + count, index);
>  		if (ret)
>  			return ret;
>  
> -		ret = vfio_msi_set_block(vdev, start, count, fds, msix);
> +		ret = vfio_msi_set_block(vdev, start, count, fds, index);
>  		if (ret)
> -			vfio_msi_disable(vdev, msix);
> +			vfio_msi_disable(vdev, index);
>  
>  		return ret;
>  	}


