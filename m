Return-Path: <kvm+bounces-52211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC53B0272A
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 00:51:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1B537BE532
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 082CC2222DA;
	Fri, 11 Jul 2025 22:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5hyTAyS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC671F2BAB
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 22:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752274274; cv=none; b=m8NWgdAtMQQQGNUmgzTxTdVFNDJT7LYBzIitA9v4WrX9ccomT4qzLiCIsp7oShIgbybFX9f+u3inuQRmmWFjPyb8eRvnBQ21PEpeE0NDH9gt978m8Ybd2ptWeSoLN0+eI7GXc3o8AfLdRnSYt3bISUa0g6hlZpfGbt/eQJFP5oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752274274; c=relaxed/simple;
	bh=e2HRqwLef4kAURx8meT3jjA5yDP1bjM/Z501qkoAhEc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q22WAQ8cDwX6fJHwGvS9EhGTublsEosYgGyJl0Vt6wVE2Gqo0bzQiIqpA4F/rVYmVZnD0TX74a1CqabPFBLaWfDqiqCVaDR9nBKnsqawAmfzQivFPdPIZBAJy5+S2PHVBLN8obV1s3K9GdYU2IUuwtKibtXfsbbmhnCB4g0E/nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c5hyTAyS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752274271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CUlBOZt5JepuEesoPNsvp78tEh5FR4bXJJdKcsQXWvM=;
	b=c5hyTAyShXftT61gS6b69gT6qM+c0OvLFlkWZ1S2edY5DN51r+1n1JsV0PJq7nqis5+DLg
	z5hLC9015eVd1WTC2LMk55JjZrXFWvWMC+VzVlB5hKc7PKGhfZEJQotgWF8ErLfy9eusgk
	L2zRJ+vdVFKQG4z/PAfJZzt54k4cn/4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-IIDUGizGN8m8-qM7X_Mr6g-1; Fri, 11 Jul 2025 18:51:09 -0400
X-MC-Unique: IIDUGizGN8m8-qM7X_Mr6g-1
X-Mimecast-MFC-AGG-ID: IIDUGizGN8m8-qM7X_Mr6g_1752274268
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-86cf14fd106so58305339f.2
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 15:51:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752274268; x=1752879068;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CUlBOZt5JepuEesoPNsvp78tEh5FR4bXJJdKcsQXWvM=;
        b=a910a8qiyIhh1KLAGSupNpFasb6mW9KRIVZlp2c3xm2kWKhqdWqXvdUd76eMjGh8Np
         zQolMne928bC5hqdOgVRplO2r+5ASrXYMk8hM6ns/BfW7EKF+Q31VKLkZWELX6Ld7EG6
         D3TgvbkFBhsRbf9cm8mM8tf/hs8DAXTdQ00L0soqcoHEhEjtX5c/lRpXk3xiw3pMwvO4
         RzvBU8ufxwfEvXAOcSrl+wCw+5ULDKEpTW2swTILG9u8+uhhjDb3rWW8IwQ2nCeKTmTZ
         6+3T/+0u9bJKeHgKAWpMv2IClDwuz1GBLqKIQPE/SQwdZCRHiFmRadB7Ai++K11LZLOd
         bfwA==
X-Forwarded-Encrypted: i=1; AJvYcCWAGOdTQ9q8aJgAMNUebcRwZaegods28eEdDnjjye3rqVk1wjh/c94531gsj2B8UY578IM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb9nF9e9LRKaZzMlQ1GlrwNKH0bsa1RfhXQHWSH0E9xND9D2ST
	+pIAdxVoOQk9suVc97EBDPhhNcbWJlk8f+YWnnFW6jAYOLVe/jPtW3p7xH5Nj67cpCzWnvbvJ0Z
	XzkVKhUpEH4joQzsKLwr7gLVw3Zno9hyokiSICYoJ9yzhUUoFx05PXQ==
X-Gm-Gg: ASbGncsq99QyH+D6mB+HENLEV3YYunwIH3aPezbTU6h0ul0U3JRFPpAzPGQlXEN7z2j
	noftxPQJEMMK/hIcAJpLwTnGQ5bWRlQtvA3qsA9BjKNNgSc97xtsItVsudszD0pFVwS5tXkJvLa
	jy1ip9skMO+vAnHnFqWcDicVDq95bS7xYtXNNhWJPSUaXUpgUVJPZqvH5X1WXgvbYJmBiJQMK9m
	NdBaaROwy2VHWzUcta0NIQkVGaWuBlYrHkUJVW4SlddXO1qN9b1it/3HmaB05zIctxEKO0eBMyR
	A6ZW5NZGJ1OumpTWyx50sz2A2ykomXWhUli0VBIQJgs=
X-Received: by 2002:a92:c248:0:b0:3df:4cf8:dd4f with SMTP id e9e14a558f8ab-3e2543e0bb3mr15415545ab.5.1752274268508;
        Fri, 11 Jul 2025 15:51:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWvIa74WArboI4td6WgV6O8vUwd+B2SMYGRpKd+kzyAGObgn0Yb70rdbxO+KtouVW2IoQ43A==
X-Received: by 2002:a92:c248:0:b0:3df:4cf8:dd4f with SMTP id e9e14a558f8ab-3e2543e0bb3mr15415475ab.5.1752274268108;
        Fri, 11 Jul 2025 15:51:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e2461344c9sm14794715ab.16.2025.07.11.15.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 15:51:06 -0700 (PDT)
Date: Fri, 11 Jul 2025 16:51:04 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pds: Fix missing detach_ioas op
Message-ID: <20250711165104.37fec2f6.alex.williamson@redhat.com>
In-Reply-To: <20250702163744.69767-1-brett.creeley@amd.com>
References: <20250702163744.69767-1-brett.creeley@amd.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Jul 2025 09:37:44 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> When CONFIG_IOMMUFD is enabled and a device is bound to the pds_vfio_pci
> driver, the following WARN_ON() trace is seen and probe fails:
> 
> WARNING: CPU: 0 PID: 5040 at drivers/vfio/vfio_main.c:317 __vfio_register_dev+0x130/0x140 [vfio]
> <...>
> pds_vfio_pci 0000:08:00.1: probe with driver pds_vfio_pci failed with error -22
> 
> This is because the driver's vfio_device_ops.detach_ioas isn't set.
> 
> Fix this by using the generic vfio_iommufd_physical_detach_ioas
> function.
> 
> Fixes: 38fe3975b4c2 ("vfio/pds: Initial support for pds VFIO driver")
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> ---
>  drivers/vfio/pci/pds/vfio_dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index 76a80ae7087b..f6e0253a8a14 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -204,6 +204,7 @@ static const struct vfio_device_ops pds_vfio_ops = {
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas = vfio_iommufd_physical_detach_ioas,
>  };
>  
>  const struct vfio_device_ops *pds_vfio_ops_info(void)

Applied to vfio next branch for v6.17.  Thanks,

Alex


