Return-Path: <kvm+bounces-30823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 864189BD9B7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 00:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1831C1F23EC8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 23:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7856216A2C;
	Tue,  5 Nov 2024 23:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QBA6az7X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E915216A18
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730849350; cv=none; b=J1zvdNJQuaUC3eCt1Cw2ndg3VpnxqAwrp2rsQA8sJ8Gp9FZqO8FY4mLPgVmoQ34JYR4ad7T8Z0FHSh7V/BH4NMi5fP9I6bc+CVxuBBQahPIlr9YVEHnwPJ3m9jEgA+H58Oy+y4UnTyiIH7NdbHV/vXvU3HPxDg7xa8V+Wil+IEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730849350; c=relaxed/simple;
	bh=c+O1aCV2hHScg23TJ/rGo6MfIEAdK07rMuZqdGFa4ac=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cPfTt4vvbCj4VHpJOfqW8IdJRzUAbNfNvicyG46/QVpS2vFhOfP9JfXVMAJgolwocCFa8e4jFq5YYJ4V6T6zgBxwBb/tjlSTbM2maXWIiHj9xlwKepY79mGdFl3k0x+1GlS24/D4jHNGgPlkoynHO1wrPNDwVrX6tY6oTEe8J5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QBA6az7X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730849348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1NZ0zx9SE1uKHc2bVZ86v1ZGK5me+n6DQA6Bc2mp/i0=;
	b=QBA6az7Xb1Lxi34egKAw3+Zj4XsQnfzR6e9lgvHoX6OGjAvhMyuyxpGIzZVbH0Zg2K5WfC
	NRzAUKLU1i8Xwsn4vH0bwnadMkgqtO619ZqYpVgFtyl7LmO+enn3AhwNDnX3GekCwLzXvc
	l/Q2sIBMZmKBD2BoKUjMYy5NdaiVXkE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-8MjPSzhpO9KNlCV_sBoemA-1; Tue, 05 Nov 2024 18:29:06 -0500
X-MC-Unique: 8MjPSzhpO9KNlCV_sBoemA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4da5c5c02so9302475ab.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 15:29:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730849346; x=1731454146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NZ0zx9SE1uKHc2bVZ86v1ZGK5me+n6DQA6Bc2mp/i0=;
        b=PEAaxUDjbquLwpOMjAE6n7g/2R7w7baz4jX124XmZlxLgvAxERG9N4Co2YDy9riC9c
         A/4D53ASUqITN1A7+/Z8mpMd6r+JU7ULWL0A0qclVTy9Qld2CViLQJ+aJ753HXsWS45s
         NFuO2eYTbTS7WPhorsaJAw5FmDsdoCy0mJ+7rDWi07syecP1hbAJJlGqCwpAhzaF6Us+
         sp/i0K93IDKevtdnxFif/tqPBXIQj+FP6k4Hd8kp/goi4qAa41V9Evv6VoM+z1g7pDrn
         7nvsRUourp+67O6n+EkZcs7HZiAeiREmVtfTUca1YDer9BKvwgcTlRqPzEFJ4BVA/NUN
         od7w==
X-Forwarded-Encrypted: i=1; AJvYcCWb7jzj73rGXB2QSpHpFq7/a39Bb3fltQlgWSNYLg0xfeFNEKqT3bz8HXQq29RJlZRHP/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTSX11UZJKEx8+wf/Zu9nZtWBFH4nbZyNJSoIMVCprrX1+aVoJ
	WI2e19GElRcshBVS66o6Z1r+OP1UXu2HLpXqV1rLkUiJ8kRHXenwkUTilATO7yWoF0P5Xo7ty8C
	eIlxxyBDhby8dbXImSwjlOf5JS68wTJwsS711AcLKeTrGCzinOQ==
X-Received: by 2002:a05:6e02:1385:b0:3a6:c048:4194 with SMTP id e9e14a558f8ab-3a6c04842aemr32218245ab.1.1730849345948;
        Tue, 05 Nov 2024 15:29:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH3/LzSIQREr27YcRyo458y8lltHd7KixOnzZv+XiAf1/o6pv7/b6gDajkbSPHSdFza38BG9A==
X-Received: by 2002:a05:6e02:1385:b0:3a6:c048:4194 with SMTP id e9e14a558f8ab-3a6c04842aemr32218095ab.1.1730849345459;
        Tue, 05 Nov 2024 15:29:05 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de049a45b8sm2608291173.132.2024.11.05.15.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2024 15:29:05 -0800 (PST)
Date: Tue, 5 Nov 2024 16:29:04 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
Message-ID: <20241105162904.34b2114d.alex.williamson@redhat.com>
In-Reply-To: <20241104102131.184193-8-yishaih@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241104102131.184193-8-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 4 Nov 2024 12:21:31 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> Now that the driver supports live migration, only the legacy IO
> functionality depends on config VIRTIO_PCI_ADMIN_LEGACY.
> 
> Move the legacy IO into a separate file to be compiled only once
> VIRTIO_PCI_ADMIN_LEGACY was configured and let the live migration
> depends only on VIRTIO_PCI.
> 
> As part of this, modify the default driver operations (i.e.,
> vfio_device_ops) to use the live migration set, and extend it to include
> legacy I/O operations if they are compiled and supported.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/virtio/Kconfig     |   4 +-
>  drivers/vfio/pci/virtio/Makefile    |   1 +
>  drivers/vfio/pci/virtio/common.h    |  19 ++
>  drivers/vfio/pci/virtio/legacy_io.c | 420 ++++++++++++++++++++++++++++
>  drivers/vfio/pci/virtio/main.c      | 416 ++-------------------------
>  5 files changed, 469 insertions(+), 391 deletions(-)
>  create mode 100644 drivers/vfio/pci/virtio/legacy_io.c
> 
> diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
> index bd80eca4a196..af1dd9e84a5c 100644
> --- a/drivers/vfio/pci/virtio/Kconfig
> +++ b/drivers/vfio/pci/virtio/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config VIRTIO_VFIO_PCI
>          tristate "VFIO support for VIRTIO NET PCI devices"
> -        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
> +        depends on VIRTIO_PCI
>          select VFIO_PCI_CORE
>          help
>            This provides support for exposing VIRTIO NET VF devices which support
> @@ -11,5 +11,7 @@ config VIRTIO_VFIO_PCI
>            As of that this driver emulates I/O BAR in software to let a VF be
>            seen as a transitional device by its users and let it work with
>            a legacy driver.
> +          In addition, it provides migration support for VIRTIO NET VF devices
> +          using the VFIO framework.

The first half of this now describes something that may or may not be
enabled by this config option and the additional help text for
migration is vague enough relative to PF requirements to get user
reports that the driver doesn't work as intended.

For the former, maybe we still want a separate config item that's
optionally enabled if VIRTIO_VFIO_PCI && VFIO_PCI_ADMIN_LEGACY.

Thanks,
Alex


