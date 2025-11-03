Return-Path: <kvm+bounces-61786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D6EC2A373
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 07:43:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 17468348388
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 06:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1F627146B;
	Mon,  3 Nov 2025 06:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bzqHHDry"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84427347C3
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 06:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762152200; cv=none; b=e81aTksDpzWM7E0OTos+yXpudJQtHtTo2iRynqKaV9a8N5KFt1WplbwSy2T/oG1ixRsgmp4fCpsCo6AQI317CxlkA4JW4AVN1qtAFQLCT6VztvsWScsvVAnnGLWPr4W+0TVZU/VRlvl4/OALxmhyYsxsvkzvc7bq5uPfvYm3pb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762152200; c=relaxed/simple;
	bh=4+2jNttfGJTUArM3tzL5Y2lmRNiEYuzuOIQmI+CPwVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXXHymnOUMdnJNXcNH5u6iGc1g7iF47cOEH3kfzYXpW5pg39bR6cnlXLb/S1nmfsMimLOB+SvK1P5BsVwGc+eWj9wQBYf4WDs8CwyhIGWjaqIMROLAikHEJ001rtWxlcHLjJbRE5udK/XyD/iCPKnY4LYmJpd/8Jio1+sFlVaIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bzqHHDry; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-295c64cb951so79825ad.0
        for <kvm@vger.kernel.org>; Sun, 02 Nov 2025 22:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762152199; x=1762756999; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vxS6TWyQqtdZLWaYvGIMM/0/SSg5nejyyCdpsoAJAw4=;
        b=bzqHHDryQbtysEXyY8A4QLQv3xVfTa7ZF8u2UsJNMYz6MAFNITNAnXMBQWDvsgrsOv
         XdBs9RQkB7n6UD9B+6P7XCPkpN/vt7b7BVOiMfafuJgvQeXB9J2LUPUgkrWcwciefRXU
         yM0d+zc7XWBfyiKx/lURSBlS9xYbFDKMKOotCHPaTvapS8rUYaaEDcQne1GdmULqMCbo
         17ebOzm0JviJxsTxXWko5ePflmugYMT1hIORs83PbXacU1LxUhwHTg0i7nRYLRpd00s8
         3UwA6WraLJzmcRF8fLYCnGVLdMMLMFKOwUg6Z0ltOknqHRRkeYs/kMNKEF/3bw7V3fMr
         91jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762152199; x=1762756999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxS6TWyQqtdZLWaYvGIMM/0/SSg5nejyyCdpsoAJAw4=;
        b=kyDh3eGvUvL+CpCJHh+lykKCMZP+bbmDIzHUVtI9ZDtsdcYLd5EkOFUoe8ew+tjJpd
         gEd2KjG1+vh+o6S1SDhMDgbvkQGYKSOfwlw385lDLVir1a4WuJi9SmviETKLC+ON5piS
         jSYOKwSBXmhSe0eD3wR+GiJ0rQnsy1Oii6kITJmqV3fIutA9V1TO+d24UK6om2wWlWfs
         dHzPuclE6blWH6jePj8gTAT0jI5LRjPu4NI0/X6buZ4q4spH+9QOg5q1P3eJP+d+Qkgc
         dzXpjcIfIlZUF3yg4ckQDMqU02gMlgfZy0PTvM/70ddMOcj4CQrFyITulPkeiiu/kG1q
         /IQA==
X-Forwarded-Encrypted: i=1; AJvYcCWCC1pwqluC6N2FMkEnAlcCfM2ijxykJJJVWL+6jrDlfJIFOqDO8zeVAXO6CFKzxA62eDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjdtIoY/yu3ch7lDPVV5QZBb3ijmE1LiMBZC0X+pJ350eKppwu
	0C4wXdXaiFqMjUSQ1VlHXS3Pq5YZB7g5k8GXdbpg3HVpLaP0/K5hGsfdw+FjFas7Tw==
X-Gm-Gg: ASbGncvd8BTTXo8wk25k5wcfcschlWQz7w/+Tlppl6S6MWy2Fink6Xl7PoRCIWJ3tof
	MQ/BobVOOR69SQDevtgF++vuGVEXJxUX5A4vZQPIAmgbPDom7zOaOLbrTv3iSHQ7cbPwQ4YJlTU
	Zk+m7uXg7J5mubSCBJvHOqZvA3S2rWG6hH8te+1KVwj0coTWYmSKT7Ho6G2nDtqOxNOxdu9egOt
	BULteml5ultO934x8wzNyYOBpZbRLTpj7yNYIw5pyfThsi9j/OGrYNqgO33B3WXpv+qs4v8iUf/
	oSbijfi6Ew45QUC10ewwpizLZFiDioCOx7QXXJs5VMJpzMho+mAQbBP7dm+FwlehajsLd6rCoh4
	PfyzYgNZ4axZ7YTZxOcIBMzz6RReKGfnSdg/T9C4HVVM20U4i7fTMM5OdOENQtgKuuboj6XR8yL
	53OvOtJgUj5ZUNTKgeQfmDyM4T+m5M+poKPXkZLm25yELUa39q
X-Google-Smtp-Source: AGHT+IEazENwFhX4zlZOAPlLrsglGHn3aC4ae1C3vchxLK4wgltvDYn1olscExUoutjpE7Up5ejKXA==
X-Received: by 2002:a17:903:2f81:b0:295:5405:46be with SMTP id d9443c01a7336-295562f73a8mr5347545ad.1.1762152198351;
        Sun, 02 Nov 2025 22:43:18 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2954d5ee092sm80708835ad.62.2025.11.02.22.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:43:17 -0800 (PST)
Date: Mon, 3 Nov 2025 06:43:07 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 05/22] vfio/pci: Fill in the missing get_region_info ops
Message-ID: <aQhO-5Ka4b8Mcwxf@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <5-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:19PM -0300, Jason Gunthorpe wrote:
> Now that every variant driver provides a get_region_info op remove the
> ioctl based dispatch from vfio_pci_core_ioctl().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  drivers/vfio/pci/mlx5/main.c                   | 1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c            | 1 +
>  drivers/vfio/pci/pds/vfio_dev.c                | 1 +
>  drivers/vfio/pci/qat/main.c                    | 1 +
>  drivers/vfio/pci/vfio_pci.c                    | 1 +
>  drivers/vfio/pci/vfio_pci_core.c               | 2 --
>  drivers/vfio/pci/virtio/main.c                 | 2 ++
>  8 files changed, 8 insertions(+), 2 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

