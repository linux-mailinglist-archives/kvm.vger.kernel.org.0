Return-Path: <kvm+bounces-54802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81935B28496
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 19:02:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEC9618878A7
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0600B2E5D00;
	Fri, 15 Aug 2025 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UBaR2YqN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5069C257825
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755277185; cv=none; b=UNLsVPwY9d71acKkzgzd8sWU9GA/aDH2OJKNg9jACpa18xBfHvPpaAx4cPCpSKVfhMuBRXdb4+FKFO7YCDNExi31qKNUUE/2AjArw5Sxu/3aqGrPydc8bKJ2JtsCpWVjqSrPW7BSc5sbMkDs2FQG4EgmS56vp27vOxsLDfyhRUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755277185; c=relaxed/simple;
	bh=rhInmV/9EHfiW6HrH4oNvD6+cVmLsn8cITcdXoLg4EA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzNwWigaQKgcaUdUV7J2ogJWn02X92IYcCOTN4qpz2IFX3JDa1qiXZb216xiZJRUiPb4Vkz01LM2SWZK16RS/nYEOWFoKCnJSoesF7u81MKoRn7x7tpmhoNrTYd49VFUbXRMwI9U2umzltS4Ue2L9cBfXCHwfDl+YrDDIUxX7OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UBaR2YqN; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so3075e9.0
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 09:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755277182; x=1755881982; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tt2pL0nJRFchkqIJ9phiYTwtCAvzq73Tu9fHBuoCiTM=;
        b=UBaR2YqN8gJu8jMyt970fwpDDxRSC8xSoSX1HWzYBN2IB//x50n2N7krnBtBkBtp9k
         mNSC2Zn77AitHUwFX2tIFNcYR4+5l26Q2IcagXtxzNOuxMe9svKZg1YgkOhp1NUfl3xs
         3fwpdSpPIJ2u0NQNlwSlXH9fOaUALfjg5NBNZprFxSA28ruh98+kE3lDhbZnEHkvuai1
         M/EAipk5y62+cgp6CBob3N4xAZ2ef/ZHy9Hi9cU3B1vfrGzND6s4rJPy/4lwqDW8f8t0
         wn04WO1uhkZZtU/xTcIxfaEt0eqEpOAGgmIwmhyGyF+pFi17OBAXrk6aDEMwnH0snSkz
         C4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755277182; x=1755881982;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tt2pL0nJRFchkqIJ9phiYTwtCAvzq73Tu9fHBuoCiTM=;
        b=vlQ70/lDTdxOotABhpQXBFRkowZTHPppXqv3OT4Zkq0Gq1E+M9k0szn8+jODldrJ49
         NOrjT/wMBaAiIv5GppxlL8oUt9a7LDaZ3D1wjnDIlOivLF2wbk4w5VtnQv+UitDeFLFb
         2KkG/JC5vp6Zf7h3sjGd1TmHVeVBEkmSUpesUs3rbfpdcM388kS1sJ3JxOm+sJCqUTnh
         xr41b/CxTGJxD1UayVM1hDtljPIqAiTH3Ue1YTBC3/1bPD7OuFpczMg6ljtoUJ4eOIBz
         9wJH/74ek+IZrQd3tiYJQi3DXLO+bR8x1MJY7sx4gKfzT+nWs4uSKW8qKqJwfkXIF254
         g0ug==
X-Gm-Message-State: AOJu0YymS6KM/nrbITQGzoB/FEaxYv9iYhLWHcFwnbgdW3wyqOt7BO7s
	nagSXDq8i6Ym7NE+ZtnSEJKd4BuDCksjoAodwS+cIDLhZ5tp6o3J8hQnC84bWlSHh6aJEEGBqx3
	1K7CrMA==
X-Gm-Gg: ASbGncsDLrW43KVoGLdfTFwOWFQY04how5+uC3V7QD7jbsowkZUl/FZJ2doiyElsd2s
	AgZyd/psTPT31V7unlGjbQARH4vo3aZlqxcb6m+KZ4XPzUmrm4vXAV0ZwrWHb46SHoPVOl3t2az
	xxeZeGaJSCx4f8OeYjJx8ATBdpTcDUyMIuMBu++dh14YBYbW/SJ/qmvYHhwJLhzBeAw2UXi8Wy6
	oHUQi17Wtk1wUkwd5RdKT+RDlXL5F8Gj3wOLtm6JKSpRe0IwsASBXv4n1Jb/xDuo9whSw/sJwOq
	cXdJ0kvgO4wuvTW6+xNKcFHJ2CZgWDyjSUl2AZFHj+GuR9TsaKtOgPrXF2k5+jmOTWJNaCoteKq
	7qd5yeKi8q/a+bTA8SI57K4armNfNVc+J9Yzv9soqV/ExhP2R7UTFEvjd3BeWT/G2WKQcviM/
X-Google-Smtp-Source: AGHT+IH0FS4DNCJwS5JjKiThp/YRraMtzDyLcmUWZurSIi7HZBLSM0v/KD49mY2MejFeUM1bPT6j6g==
X-Received: by 2002:a05:600d:102:b0:459:d7da:3179 with SMTP id 5b1f17b1804b1-45a2126cb1bmr1056035e9.5.1755277181385;
        Fri, 15 Aug 2025 09:59:41 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64758d27sm2668023f8f.9.2025.08.15.09.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 09:59:40 -0700 (PDT)
Date: Fri, 15 Aug 2025 16:59:37 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	eric.auger@redhat.com, clg@redhat.com
Subject: Re: [PATCH 2/2] vfio/platform: Mark for removal
Message-ID: <aJ9neYocl8sSjpOG@google.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
 <20250806170314.3768750-3-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250806170314.3768750-3-alex.williamson@redhat.com>

Hi Alex,

On Wed, Aug 06, 2025 at 11:03:12AM -0600, Alex Williamson wrote:
> vfio-platform hasn't had a meaningful contribution in years.  In-tree
> hardware support is predominantly only for devices which are long since
> e-waste.  QEMU support for platform devices is slated for removal in
> QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
> driver and difficulties supporting new devices at KVM Forum 2024,
> gaining some support for removal, some disagreement, but garnering no
> new hardware support, leaving the driver in a state where it cannot
> be tested.
> 
> Mark as obsolete and subject to removal.

Recently(this year) in Android, we enabled VFIO-platform for protected KVM,
and it’s supported in our VMM (CrosVM) [1].
CrosVM support is different from Qemu, as it doesn't require any device
specific logic in the VMM, however, it relies on loading a device tree
template in runtime (with “compatiable” string...) and it will just
override regs, irqs.. So it doesn’t need device knowledge (at least for now)
Similarly, the kernel doesn’t need reset drivers as the hypervisor handles that.

Unfortunately, there is no upstream support at the moment, we are making
some -slow- progress on that [2][3]

If it helps, I have access to HW that can run that and I can review/test
changes, until upstream support lands; if you are open to keeping VFIO-platform.
Or I can look into adding support for existing upstream HW(with platforms I am
familiar with as Pixel-6)

Thanks,
Mostafa

[1] https://chromium.googlesource.com/chromiumos/platform/crosvm/+/refs/heads/chromeos/devices/src/platform/vfio_platform.rs
[2] https://lore.kernel.org/linux-iommu/20250728175316.3706196-1-smostafa@google.com/
[3] https://lore.kernel.org/all/20250729225455.670324-1-seanjc@google.com/

> 
> Link: https://lore.kernel.org/all/20250731121947.1346927-1-clg@redhat.com/
> Link: https://www.youtube.com/watch?v=Q5BOSbtwRr8
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  MAINTAINERS                           |  2 +-
>  drivers/vfio/platform/Kconfig         | 10 ++++++++--
>  drivers/vfio/platform/reset/Kconfig   |  6 +++---
>  drivers/vfio/platform/vfio_amba.c     |  2 ++
>  drivers/vfio/platform/vfio_platform.c |  2 ++
>  5 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 25a520467dec..c19b60032aa3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26084,7 +26084,7 @@ F:	drivers/vfio/pci/pds/
>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  L:	kvm@vger.kernel.org
> -S:	Maintained
> +S:	Obsolete
>  F:	drivers/vfio/platform/
>  
>  VFIO QAT PCI DRIVER
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index 88fcde51f024..a8bde833e9e5 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -7,9 +7,12 @@ config VFIO_PLATFORM_BASE
>  	select VFIO_VIRQFD
>  
>  config VFIO_PLATFORM
> -	tristate "Generic VFIO support for any platform device"
> +	tristate "Generic VFIO support for any platform device (DEPRECATED)"
>  	select VFIO_PLATFORM_BASE
>  	help
> +	  The vfio-platform driver is deprecated and will be removed in a
> +	  future kernel release.
> +
>  	  Support for platform devices with VFIO. This is required to make
>  	  use of platform devices present on the system using the VFIO
>  	  framework.
> @@ -17,10 +20,13 @@ config VFIO_PLATFORM
>  	  If you don't know what to do here, say N.
>  
>  config VFIO_AMBA
> -	tristate "VFIO support for AMBA devices"
> +	tristate "VFIO support for AMBA devices (DEPRECATED)"
>  	depends on ARM_AMBA || COMPILE_TEST
>  	select VFIO_PLATFORM_BASE
>  	help
> +	  The vfio-amba driver is deprecated and will be removed in a
> +	  future kernel release.
> +
>  	  Support for ARM AMBA devices with VFIO. This is required to make
>  	  use of ARM AMBA devices present on the system using the VFIO
>  	  framework.
> diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
> index dcc08dc145a5..70af0dbe293b 100644
> --- a/drivers/vfio/platform/reset/Kconfig
> +++ b/drivers/vfio/platform/reset/Kconfig
> @@ -1,21 +1,21 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  if VFIO_PLATFORM
>  config VFIO_PLATFORM_CALXEDAXGMAC_RESET
> -	tristate "VFIO support for calxeda xgmac reset"
> +	tristate "VFIO support for calxeda xgmac reset (DEPRECATED)"
>  	help
>  	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
>  
>  	  If you don't know what to do here, say N.
>  
>  config VFIO_PLATFORM_AMDXGBE_RESET
> -	tristate "VFIO support for AMD XGBE reset"
> +	tristate "VFIO support for AMD XGBE reset (DEPRECATED)"
>  	help
>  	  Enables the VFIO platform driver to handle reset for AMD XGBE
>  
>  	  If you don't know what to do here, say N.
>  
>  config VFIO_PLATFORM_BCMFLEXRM_RESET
> -	tristate "VFIO support for Broadcom FlexRM reset"
> +	tristate "VFIO support for Broadcom FlexRM reset (DEPRECATED)"
>  	depends on ARCH_BCM_IPROC || COMPILE_TEST
>  	default ARCH_BCM_IPROC
>  	help
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index ff8ff8480968..9f5c527baa8a 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -70,6 +70,8 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
>  	struct vfio_platform_device *vdev;
>  	int ret;
>  
> +	dev_err_once(&adev->dev, "DEPRECATION: vfio-amba is deprecated and will be removed in a future kernel release\n");
> +
>  	vdev = vfio_alloc_device(vfio_platform_device, vdev, &adev->dev,
>  				 &vfio_amba_ops);
>  	if (IS_ERR(vdev))
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 512533501eb7..48a49b14164a 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -59,6 +59,8 @@ static int vfio_platform_probe(struct platform_device *pdev)
>  	struct vfio_platform_device *vdev;
>  	int ret;
>  
> +	dev_err_once(&pdev->dev, "DEPRECATION: vfio-platform is deprecated and will be removed in a future kernel release\n");
> +
>  	vdev = vfio_alloc_device(vfio_platform_device, vdev, &pdev->dev,
>  				 &vfio_platform_ops);
>  	if (IS_ERR(vdev))
> -- 
> 2.50.1
> 

