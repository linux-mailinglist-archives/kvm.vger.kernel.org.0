Return-Path: <kvm+bounces-9963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 460ED868028
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:56:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 699311C23F2E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDAAD12F39F;
	Mon, 26 Feb 2024 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ImaO8gPH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B7012E1D5
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 18:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973764; cv=none; b=EUBqhtBc7qv42sfLvMYx/LaZaAecstQMQyb2PkYnoIcdGr+uYrgmjGijt5aS8RUG6XDyZPuzDZRHywzLTIel2sH8Rcv8zAHbbeOxhin0JU3S8OQ3HNGY9Eu4ZqWGMiZN6BfA+ApBIkU8+zm0qPyAIY2nqEilYV3tHMke+WbJimU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973764; c=relaxed/simple;
	bh=Hky7ScwvprYvyvPsvvnUnTHqJwElNbJ7fw1O/KrHbRU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uh2W9McFF2lYJMCqVISN9ACJiL0P3oYEJ29HQOACifB0zgN8Jf3TpM3yXHIBLJbvFLzlU9x+9l7ImA7ae6eMwvV8NaVH//idkchfsAV13fOZD/DJWkpeeKE3WB6jPrCwog73yGgqpD0VxU3gtUAholcrJajRsUC2ExCN51/9dSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ImaO8gPH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708973761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FMl14UBC0wFtsSRs7CXZ1lEAQzA5s3cCQgMHboCVWvc=;
	b=ImaO8gPHGBKBZiGST2PAlnlC1jMtTf/PxlKIRlaCVmAsXFEkEDjn454ZyvmpgNMjXvh+Q9
	WXqhcSwu6OPKQMEg+Wjx0WVXVCe5L71wKdsnO00pYUr6cXSQnfuQ4TFY7cwWjJUMMa0N35
	BsaiV70QNr4KUMdAlpCYAqhgxAlZHbc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-sLW9r8_ON_yvswUslia8Ug-1; Mon, 26 Feb 2024 13:55:59 -0500
X-MC-Unique: sLW9r8_ON_yvswUslia8Ug-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c7c9831579so120679539f.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:55:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708973759; x=1709578559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMl14UBC0wFtsSRs7CXZ1lEAQzA5s3cCQgMHboCVWvc=;
        b=lUriHBGVCdFfxO5G64AyypVBUNrAxLJR0NwkXkHKUYvaPfxmV4j924gyANTaTlFGig
         uAZiwvUmOPhb8d3QqCeCf4a/9uACOdZlkFHsN+uLVNyJenCzq1tDW0q9UfDsrxokJrjs
         GfZV/l4bqCpi8j/RwqaSGjXYrS3kwtYBqKbZNLWPHj2KVEvRR/G910JL70jNb9dRn0wC
         Z4pMQGw1QsEOH3hrKcD+Rr4CS9xLHUgys/2SlvyVhhmzKQrmlR/lZainrsObrdsReJlI
         xs8Zv3FVd2zqpxW8jno6rhl7w4pNyvfJ8KgifmEZ3s0S5oFmvf9UPHsKS0Z+fbpaRdqT
         gnKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXazSpK/gkr5vW1bCt2PDrbDjLZ03dtvIdPt2VKg8kPKKe754MtusS+mDpMvUlSuykSJRMRfD7wG+wsHPFvxhdRLa+6
X-Gm-Message-State: AOJu0YznuVFYKZB8MAHigX2KbhbQp9QPW6rn6WGUA/Fpoqd8XdjL5awl
	GvfGf+g2R/kBMART/EBP/ZI2vRmUYycN5ToiOGU86HBhnQezrb5Uew588R24p335wvYLmT1HyCo
	QXKhpz3agSvPjsdln3BEg+pTkGdJ2cAInYvRXSRm8P7FJVX0kkw==
X-Received: by 2002:a5e:a81a:0:b0:7c4:19c7:646a with SMTP id c26-20020a5ea81a000000b007c419c7646amr9384939ioa.19.1708973758888;
        Mon, 26 Feb 2024 10:55:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdFByuu/xMUKArc3Uub3jOwAvoWwpkqkD5yTxzJdHimpXozAU0C2doX7+xr7iDIcC6QcfNGg==
X-Received: by 2002:a5e:a81a:0:b0:7c4:19c7:646a with SMTP id c26-20020a5ea81a000000b007c419c7646amr9384924ioa.19.1708973758518;
        Mon, 26 Feb 2024 10:55:58 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id b20-20020a5ea714000000b007c79a708e73sm1357541iod.35.2024.02.26.10.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 10:55:57 -0800 (PST)
Date: Mon, 26 Feb 2024 11:55:56 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>, jgg@nvidia.com
Cc: herbert@gondor.apana.org.au, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240226115556.3f494157.alex.williamson@redhat.com>
In-Reply-To: <20240221155008.960369-11-xin.zeng@intel.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Feb 2024 23:50:08 +0800
Xin Zeng <xin.zeng@intel.com> wrote:

> Add vfio pci driver for Intel QAT VF devices.
> 
> This driver uses vfio_pci_core to register to the VFIO subsystem. It
> acts as a vfio agent and interacts with the QAT PF driver to implement
> VF live migration.
> 
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  MAINTAINERS                         |   8 +
>  drivers/vfio/pci/Kconfig            |   2 +
>  drivers/vfio/pci/Makefile           |   2 +
>  drivers/vfio/pci/intel/qat/Kconfig  |  12 +
>  drivers/vfio/pci/intel/qat/Makefile |   3 +
>  drivers/vfio/pci/intel/qat/main.c   | 663 ++++++++++++++++++++++++++++
>  6 files changed, 690 insertions(+)
>  create mode 100644 drivers/vfio/pci/intel/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/intel/qat/Makefile
>  create mode 100644 drivers/vfio/pci/intel/qat/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5a4051996f1e..8961c7033b31 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23099,6 +23099,14 @@ S:	Maintained
>  F:	Documentation/networking/device_drivers/ethernet/amd/pds_vfio_pci.rst
>  F:	drivers/vfio/pci/pds/
>  
> +VFIO QAT PCI DRIVER
> +M:	Xin Zeng <xin.zeng@intel.com>
> +M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> +L:	kvm@vger.kernel.org
> +L:	qat-linux@intel.com
> +S:	Supported
> +F:	drivers/vfio/pci/intel/qat/
> +

Alphabetical please.

>  VFIO PLATFORM DRIVER
>  M:	Eric Auger <eric.auger@redhat.com>
>  L:	kvm@vger.kernel.org
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 18c397df566d..329d25c53274 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
>  
>  source "drivers/vfio/pci/virtio/Kconfig"
>  
> +source "drivers/vfio/pci/intel/qat/Kconfig"

This will be the first intel vfio-pci variant driver, I don't think we
need an intel sub-directory just yet.

Tangentially, I think an issue we're running into with
PCI_DRIVER_OVERRIDE_DEVICE_VFIO is that we require driver_override to
bind the device and therefore the id_table becomes little more than a
suggestion.  Our QE is already asking, for example, if they should use
mlx5-vfio-pci for all mlx5 compatible devices.

I wonder if all vfio-pci variant drivers that specify an id_table
shouldn't include in their probe function:

	if (!pci_match_id(pdev, id)) {
		pci_info(pdev, "Incompatible device, disallowing driver_override\n");
		return -ENODEV;
	}

(And yes, I see the irony that vfio introduced driver_override and
we've created variant drivers that require driver_override and now we
want to prevent driver_overrides)

Jason, are you seeing any of this as well and do you have a better
suggestion how we might address the issue?  Thanks,

Alex


