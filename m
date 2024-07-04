Return-Path: <kvm+bounces-20963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA02927AF8
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 18:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B8BC282737
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 16:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658801B3757;
	Thu,  4 Jul 2024 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPy9yZqG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8EA1B3726
	for <kvm@vger.kernel.org>; Thu,  4 Jul 2024 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720109802; cv=none; b=RXDzL9HZD6K6sRJpTsRleuNlzRFUCrzoLmduIVRc4NkuZII7TTQz6xhXvFYahXdiYm7P0OTO5qRgweTEmig37kFwsIsQ210c5rAjJ8jW11JtJwquVuA8dRSeVGoad7WravMMDmlDusFt72ia1NS057okMaJ0MTz6nV5j3VCFOKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720109802; c=relaxed/simple;
	bh=Q64XgPXxdPyF8fceBZsqiK/ZwK9E+LeSQ35lbTiGvTs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S9tWKLVyQynuA4wZPCqwGY3hiu3RF6bfQgqWJb1UkYLulQAuK3HPPwxCGhiYTjheeAizNTj24i0+111F83qPyrex37dtqU27iC/Iay16GLagGIr0CRVaHxtwqqwQZx+LwfNDw1YPGFClj41ZeWqhdZ8kR3xs/OXDSsoHs2EIaPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPy9yZqG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720109799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJa9zCFGNHZVVWTUWtjqpJT17S7A9QRX0TDrsTkoGKc=;
	b=QPy9yZqGfeZ80kcMHWlgtBeRfXuoAJRyeeHNrI+yv1OxBX+w7QLi3qsfS+VCEiqFEIcNwM
	/R3JVnMe49R5hPbFS78Qh+8bRDp7dmjGWY27Qdi/A/0x5D9DfldhPzsuWnXENkmXphxG5x
	jnCbBYjh944RSEylKATcSAufL7mDjEs=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-Glu4wU24MrOX0RyMOtd_BQ-1; Thu, 04 Jul 2024 12:16:37 -0400
X-MC-Unique: Glu4wU24MrOX0RyMOtd_BQ-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7f6307d584aso101805839f.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 09:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720109797; x=1720714597;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yJa9zCFGNHZVVWTUWtjqpJT17S7A9QRX0TDrsTkoGKc=;
        b=RAlEV5PWEIS5EstWgUKhHI3jv4jKY0EIjawFRNBrv0jWY9WzuBNs2JDDIUif3+5c5M
         60QmrDbbAnhvXUlKWimSNBCe3uHvqR4bGZUiuTc5Gk49B8jWnCXkKerCS4eBwQ3ups3l
         T0ffFOp7RGYOBih3n31jGkosjWMXdQRWisqkFuc8T5JWRFqSFEYZFdLzoFP9worFSb/r
         pUgijzAgfN9rdyMTwqw2G+SDDOwCletDWDPaedKJgmDRUUmPlxRtIeg4Apst8gRcdmQW
         X3aIeRbPXIZWEGntBQpO5Fd3ouA0IafPgt64t+T8ZSw5Ydap9AM7E0rK2L+88kgTeZI9
         gf8A==
X-Forwarded-Encrypted: i=1; AJvYcCVndaZe/CyxXfKeX8XmohhwiScK6VXFLrNu3YshQMWp3212DIlRClHQeBlFBEr49FcozdOLWHHOkHAhZ3XInilqkMtt
X-Gm-Message-State: AOJu0YyKmbhkjiGguf9FBjeeK0TGiJ2uwNCAQa/DO164GkN+lU0PVuWJ
	tzaXSWixjUXqoqURUv41BRtRNM0tY21hLZot110ra5Mx8fuCvmYWfOYJGgAWi/E8yz4PeMeAb3W
	UT+w1/KAj0M6Jxkrsayhoy0LGE7EoF69KDm/3yDIE+FEaddv7wUFlhJR0kQ==
X-Received: by 2002:a6b:e611:0:b0:7f3:d82c:b9e6 with SMTP id ca18e2360f4ac-7f66df1c79emr262810239f.15.1720109796817;
        Thu, 04 Jul 2024 09:16:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJUTtWQwJuNtpWfpOA8Dm3k5p7PLSbdfR6O6iYLOTaqEpw7ci4MY9M4rg9iu7ACxq2jHdXvw==
X-Received: by 2002:a6b:e611:0:b0:7f3:d82c:b9e6 with SMTP id ca18e2360f4ac-7f66df1c79emr262807939f.15.1720109796433;
        Thu, 04 Jul 2024 09:16:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4bb73bb361fsm4006058173.23.2024.07.04.09.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 09:16:36 -0700 (PDT)
Date: Thu, 4 Jul 2024 10:16:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Gerd
 Bayer <gbayer@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 4/4] vfio/pci: Enable PCI resource mmap() on s390 and
 remove VFIO_PCI_MMAP
Message-ID: <20240704101634.30b542a2.alex.williamson@redhat.com>
In-Reply-To: <20240626-vfio_pci_mmap-v4-4-7f038870f022@linux.ibm.com>
References: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
	<20240626-vfio_pci_mmap-v4-4-7f038870f022@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Jun 2024 13:15:51 +0200
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> With the introduction of memory I/O (MIO) instructions enbaled in commit
> 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> gained support for direct user-space access to mapped PCI resources.
> Even without those however user-space can access mapped PCI resources
> via the s390 specific MMIO syscalls. Thus mmap() can and should be
> supported on all s390 systems with native PCI. Since VFIO_PCI_MMAP
> enablement for s390 would make it unconditionally true and thus
> pointless just remove it entirely.
> 
> Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff969.camel@linux.ibm.com/
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/vfio/pci/Kconfig         | 4 ----
>  drivers/vfio/pci/vfio_pci_core.c | 3 ---
>  2 files changed, 7 deletions(-)

I think you're planning a v5 which drops patch 3/ of this series and
finesses the commit log of patch 2/ a bit.  This has become much less a
vfio series, so if you want to commit through s390,

Acked-by: Alex Williamson <alex.williamson@redhat.com>

Thanks,
Alex

> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index bf50ffa10bde..c3bcb6911c53 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -7,10 +7,6 @@ config VFIO_PCI_CORE
>  	select VFIO_VIRQFD
>  	select IRQ_BYPASS_MANAGER
>  
> -config VFIO_PCI_MMAP
> -	def_bool y if !S390
> -	depends on VFIO_PCI_CORE
> -
>  config VFIO_PCI_INTX
>  	def_bool y if !S390
>  	depends on VFIO_PCI_CORE
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 0e9d46575776..c08d0f7bb500 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -120,9 +120,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  
>  		res = &vdev->pdev->resource[bar];
>  
> -		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
> -			goto no_mmap;
> -
>  		if (!(res->flags & IORESOURCE_MEM))
>  			goto no_mmap;
>  
> 


