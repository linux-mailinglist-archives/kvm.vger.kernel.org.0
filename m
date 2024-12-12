Return-Path: <kvm+bounces-33676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AC79EFFA9
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 00:00:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60DE91885DB9
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C041DE2BC;
	Thu, 12 Dec 2024 23:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N30rrJwf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFF4153800
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 23:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734044437; cv=none; b=run/HlrmIBLfhnC/uWAjExjg3PYxBkJP2Wf5qYCWwbCybtQTQ0C/YDQSbYWw5a39JA5PqfSYwBYZ9a/SGDDqj8nLl7/HhzHQ1ZUX+a5Ohmnv1sDw1AXd33AHme1GkEYOq4h2AOye1b/+D8tPYtOzru2Tf6+6FrRbsBN5dxK+VI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734044437; c=relaxed/simple;
	bh=ksH4+Zb+0JTG3+9CTFqiTDaCW59z6+Q6UDq2Yq9kuLk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NosmqN09WWUyG6csgZqE4rouEaxT216afSfYNK61H84grL19VNEyKY3RQx49GD6syE6Y4CKFGREIZPgW0BanxR+FCTmAYtEAf8dj/bcE1MplNoidRbQToibhqLQlFTLHDyCCoGP/fVpVUNlp2BfN6f3mv6gHE6qZrzFTd5QlNT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N30rrJwf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734044434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IiuE9FA1WMonxXg6t0oRy39y00CWPRIjL+lTv/pFKSk=;
	b=N30rrJwfSclO2NdKsI6+2QAPRxlnLGjAZLKLXkxTqLcrRru6vOaR0PTGITIbGYwhxob97D
	bHSz7JAHBbUE8kewxO/+4UCoSHzqXA10jfBVKtvzcnXR0wrpTuj65gznttaEEn/O9kU66b
	FBUcEYoAbSKA8OG4sVeD2EgAkV3BF1g=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-IcMInGHrPqS6jmUxlbgHsw-1; Thu, 12 Dec 2024 18:00:30 -0500
X-MC-Unique: IcMInGHrPqS6jmUxlbgHsw-1
X-Mimecast-MFC-AGG-ID: IcMInGHrPqS6jmUxlbgHsw
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-844ca9b7233so15154239f.3
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 15:00:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734044430; x=1734649230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IiuE9FA1WMonxXg6t0oRy39y00CWPRIjL+lTv/pFKSk=;
        b=TrZHAnp8xz/MBJtVZbStN7JdvWBXmpH9KBXTB4sSrXqem7oQ0cf0tRXIqFWvs6XLCs
         WhCzenjLrk9LDY6SkKUVVWzVyU/DkI59sRBys1wVh9/ZZt1j0BsG2MSUevp5DqNeCPTq
         JpliC+/p0A58kZf/kTgYP2an2krp5kFq7qDlKORCGSxlA2zwMnZ1k+Bn230hFnTI7eYS
         +cIdY5cabet4dFk+51HawuB4hbLRUTA1+jqYRBGYnbHcqyOnr+McXNF2TNcq/yCDHUj1
         dEWECLFMIUPT+S8KOM02FvtMdOYMYZAHrEpOTgKpLYo4wiZPIeeSGohPRFBvhIzWMWeb
         saxg==
X-Gm-Message-State: AOJu0YxibMiU09+djwap9uRjla07AEoNJl6sKLxyYNbUQXrO/5jOv/9u
	qWTgpqU80jkftuy+hZG/nU50YjkldvLONK5qbP+ZYSAcbDdrc/ALHruX+MeS1mOzHzgBio08H8B
	aI3HO4PvWyyevyv2oLmSIkdu/jmQaiC5fxmWmKSStvUk89wpGdw==
X-Gm-Gg: ASbGnctLNF7fBdMLDPLT+EYaKSNFsPcIOrqkO7xmhw6EjfFjbkGDmbqCoPuk5pj+0bB
	3IEZa2w4kgPPFhRo62I9FXOLE7MKHaxBY8Qu/w8txGgmRe13rk9SzOcKJ2LBOVKqNoENp5s/erb
	uak5piMTm+eNepP+NRB2dUgnvdspzx7uqrlfKuUwsbtiyPT4CGsxL3uLQATrd6I7ZAteEb5a7MY
	o6tUV0G7ywrHbDJGpnYHjWNE8YwQHm/i63Sa7r9SdhyhyL4rwSlVl/Z8H/J
X-Received: by 2002:a05:6e02:1565:b0:3a7:81cd:5c4a with SMTP id e9e14a558f8ab-3aff33952edmr1999925ab.7.1734044429694;
        Thu, 12 Dec 2024 15:00:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQz/YQPnCIhrpQJ2lHUW4Pkezpn4mXz2vBlDcW2Bhm/UCtG2f0t4QaXgGPJccw0ssQlVXJMg==
X-Received: by 2002:a05:6e02:1565:b0:3a7:81cd:5c4a with SMTP id e9e14a558f8ab-3aff33952edmr1999435ab.7.1734044427605;
        Thu, 12 Dec 2024 15:00:27 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2c57add37sm2112009173.120.2024.12.12.15.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 15:00:27 -0800 (PST)
Date: Thu, 12 Dec 2024 16:00:24 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yunxiang Li <Yunxiang.Li@amd.com>
Cc: <kvm@vger.kernel.org>, <kevin.tian@intel.com>, <yishaih@nvidia.com>,
 <ankita@nvidia.com>, <jgg@ziepe.ca>
Subject: Re: [PATCH 1/3] vfio/pci: Remove shadow rom specific code paths
Message-ID: <20241212160024.38f6cd1b.alex.williamson@redhat.com>
In-Reply-To: <20241212205050.5737-1-Yunxiang.Li@amd.com>
References: <20241212205050.5737-1-Yunxiang.Li@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Please us a cover letter for any multi-part series to describe your
overall goal with the series.

On Thu, 12 Dec 2024 15:50:48 -0500
Yunxiang Li <Yunxiang.Li@amd.com> wrote:

> After 0c0e0736acad, the shadow rom works the same as regular ROM BARs so
> these code paths are no longer needed.

Commit references should be in the form of:

  After commit 0c0e0736acad ("PCI: Set ROM shadow location in arch
  code, not in PCI core"), the shadow...

Thanks,
Alex

> Signed-off-by: Yunxiang Li <Yunxiang.Li@amd.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |  8 ++------
>  drivers/vfio/pci/vfio_pci_core.c   | 10 ++--------
>  drivers/vfio/pci/vfio_pci_rdwr.c   |  3 ---
>  3 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index ea2745c1ac5e6..e41c3a965663e 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -511,13 +511,9 @@ static void vfio_bar_fixup(struct vfio_pci_core_device *vdev)
>  		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
>  		mask |= PCI_ROM_ADDRESS_ENABLE;
>  		*vbar &= cpu_to_le32((u32)mask);
> -	} else if (pdev->resource[PCI_ROM_RESOURCE].flags &
> -					IORESOURCE_ROM_SHADOW) {
> -		mask = ~(0x20000 - 1);
> -		mask |= PCI_ROM_ADDRESS_ENABLE;
> -		*vbar &= cpu_to_le32((u32)mask);
> -	} else
> +	} else {
>  		*vbar = 0;
> +	}
>  
>  	vdev->bardirty = false;
>  }
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1ab58da9f38a6..b49dd9cdc072a 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1057,14 +1057,8 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
>  
>  		/* Report the BAR size, not the ROM size */
>  		info.size = pci_resource_len(pdev, info.index);
> -		if (!info.size) {
> -			/* Shadow ROMs appear as PCI option ROMs */
> -			if (pdev->resource[PCI_ROM_RESOURCE].flags &
> -			    IORESOURCE_ROM_SHADOW)
> -				info.size = 0x20000;
> -			else
> -				break;
> -		}
> +		if (!info.size)
> +			break;
>  
>  		/*
>  		 * Is it really there?  Enable memory decode for implicit access
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 66b72c2892841..a1eeacad82120 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -244,9 +244,6 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  
>  	if (pci_resource_start(pdev, bar))
>  		end = pci_resource_len(pdev, bar);
> -	else if (bar == PCI_ROM_RESOURCE &&
> -		 pdev->resource[bar].flags & IORESOURCE_ROM_SHADOW)
> -		end = 0x20000;
>  	else
>  		return -EINVAL;
>  


