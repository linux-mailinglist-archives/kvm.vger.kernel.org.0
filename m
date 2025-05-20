Return-Path: <kvm+bounces-47148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A39DABDF4F
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DF191BA7F27
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4438A25F965;
	Tue, 20 May 2025 15:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ADkahkj/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF7B2571D7
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747755605; cv=none; b=sZThjCBL363luH3QpoxXPkkLVUVdsoTZKrYeH6+JapU4FTCR8OijxJZrGzFOpFMFVswvbLTIFEVCFwPkoh0I5kWVP/pbzrGDi3zLH2NopgXC+Fh69mZTghvsDzaQXpzq2cV8C7hmp9tRc8ceJEzhXMPAXhzlQa8ZUJ+FFFhaYJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747755605; c=relaxed/simple;
	bh=l3VEMbZT3qJcMmeU3g5Lfef1YZQOsS8YY+NjQ+sCV88=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsuFqSnPnZt1dovdvbjRCYbtPRd2sxb8VKY96ErpjoFpZb8DwHc2Q8NTD8SzcB3IzXP+JXetJgaHFmAO7ICoTDpCFz6FDK1qeYLzG4mlF/Zf8CpxeHR4h+/Zlu/1ghQUHv6ulW61m9E46iibZa2+l3sBkZeOzCvXLfSLwrmMW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ADkahkj/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747755602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+nRshVxD0Vdfy7whIcULOp5PofMuD6cmE/wxUNvSYgg=;
	b=ADkahkj/hZzRlPqusY7Gn6txyJ2FjNzRmgl4MOWc2VDUe4NIqIIugbaho/HGSsiL74xxGM
	pyNjNDug4Pnx9Zy1iF7NqQ4kIAkh3pl6Wle0gyp2/09i02mZ5IlXPzAuouupuLHR/MFBM7
	AuJ1eIis5ifSpg6qOdzfStq62DfPgrc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-C7dnt6zONd61X_7iK2baUA-1; Tue, 20 May 2025 11:39:59 -0400
X-MC-Unique: C7dnt6zONd61X_7iK2baUA-1
X-Mimecast-MFC-AGG-ID: C7dnt6zONd61X_7iK2baUA_1747755599
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8617c4a3d0dso102602939f.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747755599; x=1748360399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nRshVxD0Vdfy7whIcULOp5PofMuD6cmE/wxUNvSYgg=;
        b=MIEPQhnyBTC4Oq9CJskxMaBNpkltyaKBlgd8f1krP0BJoSde78pa2cHrJ02DybdLji
         UQzHZM5il+qsCsrpAcbsI5TQIsENwPgejw9Ijg/kaOEGNNcT1F2AiO3h0ITge2uJDna0
         bkpG/qzPPDCKqV/HY0r8wQosLkL576avw20HYnjGmQRxziAHOe8DUwCSvCLtin/8HqUb
         FhdeFfM9o4ReKzOAO1NtGkg/L2dkouuCMXChFTlzc0eVGfwBP5S2GFU06YPV0nYwx0I2
         kYtthX/a+sgwXZugjM8vpDOgFiUzsZanb+zw5UQDZEUhTi3zzzmkLYaaZ668V9mjqVMx
         KUPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVML7CC/XWud+d0HFWymjvw8Qse/uowQY+sKvvcc1yC8xySvIBUjUIvKSlawtjiYI9PbdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDNuujSc13jBN8w/zRYAFvg1dKG0GewYqFV8RupcKIXtZ+u3kq
	q9W0ofwNz44I4ESwM66D5SjtySPy9kzHTQlkxSNgvG7Hq6DE6GK9rz1X0XPIyAhK4pltjBU9GBb
	WdJMYY9Sn+aLeSBYkCyfz44vH2l5Gzh28yZhzo+kfdi1xXlodsS1uTw==
X-Gm-Gg: ASbGncvVJEw8/Z9lLr0etzglhChBCDJyDKjx4C9FBhRiNzRh2dWKA4TyLxAZNme135Q
	fdZF6Us2Q6LcH5XYA86r6j2V0xuzB+kCvluquAHmz0+ZL/TMdsNPVl0J77xBK+9IwLDLpfZd7ow
	LJgPf34AzMLR/IWeDana2YE3Qoxc8Xxxb8ZOo358h4vBckJ/jTQ7EJP79eEDHQcNlF6axwLlnLd
	RZl/6eolxCc8gtkyDjysBAbpxRwASMHDUqhNfg4xttpOsM7X/ajNO4OaIELvLGRxgJnYAGv9Dta
	KZ3lxOG6BIbDoAI=
X-Received: by 2002:a05:6e02:4412:b0:3dc:787f:2be4 with SMTP id e9e14a558f8ab-3dc787f2ec6mr13452885ab.4.1747755598682;
        Tue, 20 May 2025 08:39:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJxW+SwL23Ubb7kryh1zsb3t6QDkgY2CzkAQAAYZW5H0j+3UA7gJ+6O/KrIt4EIQrmGCv89A==
X-Received: by 2002:a05:6e02:4412:b0:3dc:787f:2be4 with SMTP id e9e14a558f8ab-3dc787f2ec6mr13452715ab.4.1747755598089;
        Tue, 20 May 2025 08:39:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1c78sm2388655173.57.2025.05.20.08.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 08:39:57 -0700 (PDT)
Date: Tue, 20 May 2025 09:39:56 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, kvm@vger.kernel.org, Yishai
 Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
 <kevin.tian@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH vfio-next 0/3] mlx5 VFIO PCI DMA conversion
Message-ID: <20250520093956.3856d75d.alex.williamson@redhat.com>
In-Reply-To: <cover.1747747694.git.leon@kernel.org>
References: <cover.1747747694.git.leon@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 May 2025 16:46:29 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> Hi Alex,
> 
> This series presents subset of new DMA-API patchset [1] specific
> for VFIO subsystem, with some small changes:
> 1. Change commit message in first patch.
> 2. Removed WARN_ON_ONCE DMA_NONE checks from third patch.
> 
> ------------------------------------------------------------------
> It is based on Marek's dma-mapping-for-6.16-two-step-api branch, so merging
> now will allow us to reduce possible rebase errors in mlx5 vfio code and give
> enough time to start to work on second driver conversion. Such conversion will
> allow us to generalize the API for VFIO kernel drivers, in similar way that
> was done for RDMA, HMM and block layers.
> 
> Thanks
> 
> [1] [PATCH v10 00/24] Provide a new two step DMA mapping API
> https://lore.kernel.org/all/cover.1745831017.git.leon@kernel.org/
> 
> Leon Romanovsky (3):
>   vfio/mlx5: Explicitly use number of pages instead of allocated length
>   vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>   vfio/mlx5: Enable the DMA link API
> 
>  drivers/vfio/pci/mlx5/cmd.c  | 371 +++++++++++++++++------------------
>  drivers/vfio/pci/mlx5/cmd.h  |  35 ++--
>  drivers/vfio/pci/mlx5/main.c |  87 ++++----
>  3 files changed, 235 insertions(+), 258 deletions(-)

Applied to vfio next branch for v6.16.  Thanks,

Alex


