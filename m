Return-Path: <kvm+bounces-19872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8FD90D7E9
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:59:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B98DA2872D1
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 15:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784B3482C6;
	Tue, 18 Jun 2024 15:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9hZx3zv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C204596F
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718725948; cv=none; b=UPQa9ZgltU5qIsE+dW60bz3vESQ333DT/0eNF/IAFkxwhn7yCk8CMB6P/hi3/3+/fCC/hs3TSWeX5j76oBptuiG65j+K37WqM4wwAyrULrTJWg0BMqrpzQEJHMuj5ILdIzmYy/QHmNpCrCB9I1BKSEYzIhHH5gJqG/ineLeUzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718725948; c=relaxed/simple;
	bh=PB3USleHUb/QPoFw6SKEi75ZURoWtyqzVwM8amBJZAU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kUA2O+c9hbAFMiIfrlg75Yg5QIWZ0cZmCXHnT1bXVKTfiJ838y+rublgVcPAe5l2QJSXBd5sbwW0sW+oD9WZLvDgfo1v0pNrUWvBOWHcr2V2uYxVnkgE9psCS74AxXX0lmj5Qk8Y7QUYJMS6hGM7tmaqc2ILjAtc8SadTn+SsrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9hZx3zv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718725946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVmZ/5mbaKN/De6q4yv+eWVlcCgx8hpVTD1CM9NopTg=;
	b=F9hZx3zvv0dhiWKmKORixrqe/UR/DyVnY9CbZHUti7q1F2+BTh5L20RINjsgEJA78cGjs0
	R1y7HDfNaVkIHHzcP5i69zm+TTVr65rJzmkVYqsOrXoktnUQeXGmxqaDO54hv51LgYUNJI
	2tOE+BfyLozBujq3vV5Ugp+2ut9n/OY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-H_RekHz0No6Xqx5x5eEk_g-1; Tue, 18 Jun 2024 11:52:24 -0400
X-MC-Unique: H_RekHz0No6Xqx5x5eEk_g-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7eee4ffd19eso296623839f.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 08:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718725944; x=1719330744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BVmZ/5mbaKN/De6q4yv+eWVlcCgx8hpVTD1CM9NopTg=;
        b=RrqMNSwc4KawuYUMYaKuUf/yACb+45mWm+bhM5QvNKOvYj5FyaSCFCpexuM2il1aRN
         OzuWOwQum5q8wrQRNu+U6roaDdzlSYRCINzK4URmpEyrJSJXlJDVVFUhvfo0YH5klBsy
         M/tHag/sPZypRPrWi/TQ9X12YBcdb8l9HZoCvGeVOCf+DMAGkw8ELoef7pZ92b5BR0Py
         UVJUF9Or2BCyp/HqYSAv0EsSaAzPCUotqUjXeDdy05NHk50/cjJsaNR3BwZfPjrd1jBT
         uX+IekguDZxfc0A8X/S8oXh7R+rU2LvXL/uNDSpr9SJ+8hEXgEcj5Rb8AihcVzBiK+9/
         Dy6w==
X-Forwarded-Encrypted: i=1; AJvYcCWJeJev6Y694Z++1zSVE+NgD8+BqpNyVqsuZx2q3alRsxbyMYE6zbZfMNEd4mukUKKkHPyQoJJFsEwacqF41x1Zx+2t
X-Gm-Message-State: AOJu0Yytn0+3EIlcYRuDtBL5vCVqNrE4wJP+yBhz4adblJn+nqnABfFO
	w1kDuKbhu3G/4k3bS0dFHuBwEwB1wYOrSdrDewnpK8iqJsBkk6n8toNkXoPhz5jKPbkg5nNPcIZ
	EhMXYtuMggqNtRHMbyAZhzbqaYHdCZBgnqyw27umZV+Ppnk9NxA==
X-Received: by 2002:a05:6602:3f8d:b0:7eb:6f43:a5d2 with SMTP id ca18e2360f4ac-7f13ee232a3mr30890439f.6.1718725943809;
        Tue, 18 Jun 2024 08:52:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDUCqhjvNdeRs5ta43og613XTt+6cG5mUBgazazo00ws+4w6OYM87gq+U0uDJVWek2iR4iDQ==
X-Received: by 2002:a05:6602:3f8d:b0:7eb:6f43:a5d2 with SMTP id ca18e2360f4ac-7f13ee232a3mr30880139f.6.1718725941552;
        Tue, 18 Jun 2024 08:52:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7ebdba176dasm280256039f.9.2024.06.18.08.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 08:52:21 -0700 (PDT)
Date: Tue, 18 Jun 2024 09:52:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Gerd
 Bayer <gbayer@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/3] vfio/pci: Enable PCI resource mmap() on s390 and
 remove VFIO_PCI_MMAP
Message-ID: <20240618095220.79995c3b.alex.williamson@redhat.com>
In-Reply-To: <20240529-vfio_pci_mmap-v3-3-cd217d019218@linux.ibm.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
	<20240529-vfio_pci_mmap-v3-3-cd217d019218@linux.ibm.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 May 2024 13:36:26 +0200
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> With the introduction of memory I/O (MIO) instructions enbaled in commit

Nit if there's a respin for the powerpc build, s/enbaled/enabled/

Thanks,
Alex

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
> index 0f1ddf2d3ef2..a0e2e2a806d1 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -121,9 +121,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
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


