Return-Path: <kvm+bounces-33677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA8D9EFFB8
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 00:00:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2394618860B8
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8801DE893;
	Thu, 12 Dec 2024 23:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DftIFAD/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500401B07AE
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 23:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734044438; cv=none; b=BfQIYaXgG+mPr32ODf2cC2az5cE5dCVRZnBaILnVCe+u06Pn1r93r148rL2GRYyDsRXhwq61wga+LcMkx6ZB5jZbTbzmhRb3ZxEbW+JmKVPjmoq7JWvk9hgDyZgrUVAkblhWg9rZ5hosG+dyA2ikNtnBFiVnCTnz3jK56B6IxHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734044438; c=relaxed/simple;
	bh=8Ky/PdCBxFxodcj+lZAwZxUspbI7FtF0gc31WFjA3/I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=reMXrqLRaF7d1q6P8K/cHJIIp1Z3ojEJgGmxBDqok7COelFbTG2g+wVIvM6aoeJSv4S7F4ilMBLw+9ErXs8l6p/xNNJ5iBo0kzvPo1bvYRH3CqwPZUFvozLHptzkHwAFjR1vc5DvEmMD/uI2scR/akSsBpvsOgE51jtsPciUG/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DftIFAD/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734044434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/xngq+2LNLNGBD36koAj/Cnj8lCa6WRTkp0zEvxqRU=;
	b=DftIFAD/gpkuddAWlFaHu5WV2MikZYnrYeTtm6gBC7sFtXv/1lH5zzdWqY0aEEMm4dKxNG
	sMTeLE5UAYEfiMUdvzVwdogIS4f+25f8ozp2HF+f/Xzn0Sv5C2b6Mm/78wlUeGFq0TASAF
	MIHODeBgkSY+D131PbAnp8aZV7koaIQ=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-bZLpVEbpM4qHrAHWXYHOig-1; Thu, 12 Dec 2024 18:00:33 -0500
X-MC-Unique: bZLpVEbpM4qHrAHWXYHOig-1
X-Mimecast-MFC-AGG-ID: bZLpVEbpM4qHrAHWXYHOig
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-844de07263bso7708039f.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 15:00:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734044432; x=1734649232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/xngq+2LNLNGBD36koAj/Cnj8lCa6WRTkp0zEvxqRU=;
        b=IKXMZiuv1RTCe+8eTT/H/0eiUi6UhjNSFMLQiQtsQtCEexuMnjUX7fdm+H1DeWDnJq
         9ZNeGWaxB1MxuSbSdM9jhmJS99XHekwzQJ2sh0ddVbS9fcRv1rjMQVjjAoJslUMybXZC
         B2h73lJb0SBR+m+8YdOmYucsBNnKReIUiSXUKjRKBMJAj/HFoptujTFlNcBFihXHn6Rw
         F719iejhhmd1CWTQAtLn6sVcYIzDvBIucnKa2HS3s9w0kkIN0U82pIVKrSltmkbB5sb1
         2Lzm8WOv34F1zU7906qz3PJQIEf49PRBaeYYk50OMBNmCjRjcMUqHQBpooCmrd+tVM08
         yNCA==
X-Gm-Message-State: AOJu0Ywqul+2Eyyt99SrbppMqVyHciWwyBkmS5FBTo3XsB6bx6JS09Rx
	5QAomSc/6u1kARAPVhKOy2i7cVMmJV8o/Ck0WsVUG+IEv7F8JOvrlAQg/XqGTXeA2vk549Xebsq
	i/POEqLEWk+nkcQLuyqKXAWQca4WPMqseviNCMM+u03D4ACeDiQ==
X-Gm-Gg: ASbGncuG5/ug9UyF+erd0eFaOaWqt9xdMBEjgtsqSELZlIKWUQUE6u4+gEKWCjI8xey
	94y0+ZmVHk3U0cpl3w818gM5SlTV6i/ZRQ8vFPYqUDNPmjQyfLYwFJ+tMpey+Yn2vBtap8JzutQ
	l+t510FAA/Sb87WZDAKE/17c8JOzNR5eJqGzw6FgjmLl8V9xUAgbJWO9gxmPrKfOWLiQDudvNL4
	NTuX3EdK+BWLiHdH7oWJaJYgGXplRfSO8vSO8JxMJORCSMaLJ7AHo8J6XR8
X-Received: by 2002:a05:6e02:1529:b0:3a7:c5bd:a5f4 with SMTP id e9e14a558f8ab-3afe87a6614mr1939675ab.0.1734044432210;
        Thu, 12 Dec 2024 15:00:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjk1lOCezhjb2FzYXTYNB8LRTr0Sefilu6Bk9IU4DTKysh3Af9MJAMfKx8EQ1tFXf+vDpOOw==
X-Received: by 2002:a05:6e02:1529:b0:3a7:c5bd:a5f4 with SMTP id e9e14a558f8ab-3afe87a6614mr1939595ab.0.1734044431878;
        Thu, 12 Dec 2024 15:00:31 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2bb66b0d7sm2480590173.91.2024.12.12.15.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 15:00:31 -0800 (PST)
Date: Thu, 12 Dec 2024 16:00:30 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yunxiang Li <Yunxiang.Li@amd.com>
Cc: <kvm@vger.kernel.org>, <kevin.tian@intel.com>, <yishaih@nvidia.com>,
 <ankita@nvidia.com>, <jgg@ziepe.ca>
Subject: Re: [PATCH 2/3] vfio/pci: refactor vfio_pci_bar_rw
Message-ID: <20241212160030.18b376fa.alex.williamson@redhat.com>
In-Reply-To: <20241212205050.5737-2-Yunxiang.Li@amd.com>
References: <20241212205050.5737-1-Yunxiang.Li@amd.com>
	<20241212205050.5737-2-Yunxiang.Li@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Dec 2024 15:50:49 -0500
Yunxiang Li <Yunxiang.Li@amd.com> wrote:

> In the next patch the logic for reading ROM will get more complicated,
> so decouple the ROM path from the normal path. Also check that for ROM
> write is not allowed.

This is already enforced by the caller.  Vague references to the next
patch don't make a lot of sense once commits are in the tree, this
should describe what you're preparing for.

> 
> Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 47 ++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index a1eeacad82120..4bed9fd5af50f 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -236,10 +236,9 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  	struct pci_dev *pdev = vdev->pdev;
>  	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>  	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> -	size_t x_start = 0, x_end = 0;
> +	size_t x_start, x_end;
>  	resource_size_t end;
>  	void __iomem *io;
> -	struct resource *res = &vdev->pdev->resource[bar];
>  	ssize_t done;
>  
>  	if (pci_resource_start(pdev, bar))
> @@ -253,41 +252,43 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  	count = min(count, (size_t)(end - pos));
>  
>  	if (bar == PCI_ROM_RESOURCE) {
> +		if (iswrite)
> +			return -EINVAL;
>  		/*
>  		 * The ROM can fill less space than the BAR, so we start the
>  		 * excluded range at the end of the actual ROM.  This makes
>  		 * filling large ROM BARs much faster.
>  		 */
>  		io = pci_map_rom(pdev, &x_start);
> -		if (!io) {
> -			done = -ENOMEM;
> -			goto out;
> -		}
> +		if (!io)
> +			return -ENOMEM;
>  		x_end = end;
> +
> +		done = vfio_pci_core_do_io_rw(vdev, 1, io, buf, pos,
> +					      count, x_start, x_end, 0);
> +
> +		pci_unmap_rom(pdev, io);
>  	} else {
> -		int ret = vfio_pci_core_setup_barmap(vdev, bar);
> -		if (ret) {
> -			done = ret;
> -			goto out;
> -		}
> +		done = vfio_pci_core_setup_barmap(vdev, bar);
> +		if (done)
> +			return done;
>  
>  		io = vdev->barmap[bar];
> -	}
>  
> -	if (bar == vdev->msix_bar) {
> -		x_start = vdev->msix_offset;
> -		x_end = vdev->msix_offset + vdev->msix_size;
> -	}
> +		if (bar == vdev->msix_bar) {
> +			x_start = vdev->msix_offset;
> +			x_end = vdev->msix_offset + vdev->msix_size;
> +		} else {
> +			x_start = 0;
> +			x_end = 0;
> +		}

There's a lot of semantic preference noise that obscures what you're
actually trying to accomplish here, effectively this has only
refactored the code to have separate calls to ..do_io_rw() for the ROM
vs other case and therefore pushed the unmap into the ROM case,
introducing various new exit paths.

>  
> -	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
> +		done = vfio_pci_core_do_io_rw(vdev, pci_resource_flags(pdev, bar) & IORESOURCE_MEM, io, buf, pos,

The line is too long already, now it's indented further and the
wrapping needs to be adjusted.

>  				      count, x_start, x_end, iswrite);
> -
> -	if (done >= 0)
> -		*ppos += done;
> -
> -	if (bar == PCI_ROM_RESOURCE)
> -		pci_unmap_rom(pdev, io);
> +	}
>  out:

Both goto's to this label were removed above, none added.  Thanks,

Alex

> +	if (done > 0)
> +		*ppos += done;
>  	return done;
>  }
>  


