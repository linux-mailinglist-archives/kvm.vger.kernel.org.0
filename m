Return-Path: <kvm+bounces-34399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F23C89FDFDB
	for <lists+kvm@lfdr.de>; Sun, 29 Dec 2024 17:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A9AC18825AF
	for <lists+kvm@lfdr.de>; Sun, 29 Dec 2024 16:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6F519644B;
	Sun, 29 Dec 2024 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Li1wmvhQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801212594B9
	for <kvm@vger.kernel.org>; Sun, 29 Dec 2024 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735489568; cv=none; b=YFS2yPpE/4UIGdGyUTumWeSLQyUVgbMkvno+zobglFQ4V2jKZpgH71QKDq0xDq7Vn6fChiMlPxqzZY4Z3rEC4sLrLAE5I8JMF4ikWuLg9aNoEgwZq8T7GGcpnVG97MMSOi2pYkmeS/BdwE1fNld66wHcg2pPUEmbPrC3xQFUHNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735489568; c=relaxed/simple;
	bh=HaNY+C8oP30vh3/L+YrE5useMaXWOGBiCcL5tROaxfs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sw1OT7TKjDH4YHX5cXGQcqIbWW/ESq1FLK1YgSL42DRLpjk6TmnvSr+wzEBpSZxOK7N4KlonmUy2hkPtrBAJAGsGx8XtnV/axlijXI8PzL2ZWGRmyg/9Ns7JbQDO0wBYVfmXaHUPWWXwB68AQjW4Ry4X0WrcDSriCukDVUhxJ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Li1wmvhQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735489565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BP9CmBVdMWKyit113lefuy/9N9GsQCl9FPjSqRS+5JM=;
	b=Li1wmvhQJSS3JivjrZgZ5+wWcinKXVA/HgaEsPLGh8Wt1N70YgJbn7V8xzSONgzWNgqLMY
	hC2jXY0TR4fuDu6PaKE8IAH93XOqMnu6QRp8CA4VOjQs0EhsarwgHnD9TVamgWgszZvgFX
	5wi5Kux12gEOi4kX2yoVtLHBkLqBer8=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-zc3kgFE3NvKPgfeIyR3Png-1; Sun, 29 Dec 2024 11:26:04 -0500
X-MC-Unique: zc3kgFE3NvKPgfeIyR3Png-1
X-Mimecast-MFC-AGG-ID: zc3kgFE3NvKPgfeIyR3Png
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a81764054aso10159875ab.2
        for <kvm@vger.kernel.org>; Sun, 29 Dec 2024 08:26:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735489563; x=1736094363;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BP9CmBVdMWKyit113lefuy/9N9GsQCl9FPjSqRS+5JM=;
        b=SlnF7CgOXHGZWqa7F0FkyfrjMJQcE+4kGWxjAPR5oKOkPxASNq0xOdsyvZsXTg1321
         zjhQSIOmJKQONw+GCvq8ztKsxxnwXP11Spj+d4Fjlt4Js0NpwrrY74HsrLaB0FAyVHGo
         Cs2rli9ATpyHVFcMnmCKRV53h7vWNve3qQmLLW4XDardlCl6Yx0lfB7qrBZR0+g6gcLw
         FdX8oiTU+MX1ZV6WcYmPGdIfgOuCLHNw45kM690Svaoco/cTy+6E64N13FxTTeRM2B+9
         v9Z4NhCaQg8QBZ/wrRTZxrKVjd3oKniREX4Drwo3+MJhJjuQ3yE6Jww6j6Gp8MSQbBft
         e8kQ==
X-Gm-Message-State: AOJu0YwG9dP6y1GeZR/BFobSU4NFFtGafiv7eLH+0+MsDJCWFInBiP6e
	SY2bGhTPb2nU0LYDtyeG4ms/2BnmtVfHq8ois5eVZ0FadT4C3eBdKgw1dPaJDIqKhb5XmXB0U+z
	tkpMvXoplz2TyFdxmZCF40LFOPN8SAakfmCNSx+eUptaGUyj8LQ==
X-Gm-Gg: ASbGnctJaU0hZ7QrLjsi0+QvxNyTyGVuM0eDfonEyHtFdcS/eDoLI923OziKfcpiE6y
	323p5GWzf6wYcJ++/kMef4gmIklO62YCDK2ZhQhO+vbIzgCe7wC5/oBFFnT81Go0H5ilzuFQza3
	TElni/MZFRHgjtGxdJX4jtdlB9AVfLVoI5Zz1k0EruOz/0sj+kE5ppNnxe7t3TS0qPa4qkfPr64
	PMkPp/yUeKRYo7da/dZU1qyAQpIYFgpYgUYElMlFf7GNJ92dgYHxKsINUW5
X-Received: by 2002:a05:6e02:1c81:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3c2cbd89eedmr79536255ab.0.1735489563264;
        Sun, 29 Dec 2024 08:26:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhP2KVMR0b5CnCDmPD36tMrDG2mxii9UYCt/CB0wL//kHYEx0U43ymDHuzdL6EErDtqQf9XQ==
X-Received: by 2002:a05:6e02:1c81:b0:3a7:bd4c:b17e with SMTP id e9e14a558f8ab-3c2cbd89eedmr79536225ab.0.1735489562947;
        Sun, 29 Dec 2024 08:26:02 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf4f33esm5063250173.19.2024.12.29.08.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 08:26:02 -0800 (PST)
Date: Sun, 29 Dec 2024 09:26:00 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Tomita Moeko <tomitamoeko@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: update igd matching conditions
Message-ID: <20241229092600.00ffa55f.alex.williamson@redhat.com>
In-Reply-To: <20241229155140.7434-1-tomitamoeko@gmail.com>
References: <20241229155140.7434-1-tomitamoeko@gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 29 Dec 2024 23:51:40 +0800
Tomita Moeko <tomitamoeko@gmail.com> wrote:

> igd device can either expose as a VGA controller or display controller
> depending on whether it is configured as the primary display device in
> BIOS. In both cases, the OpRegion may be present. Also checks if the
> device is at bdf 00:02.0 to avoid setting up igd-specific regions on
> Intel discrete GPUs.
> 
> Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index e727941f589d..051ef4ad3f43 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -111,9 +111,11 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
>  	if (ret)
>  		return ret;
>  
> -	if (vfio_pci_is_vga(pdev) &&
> +	if (IS_ENABLED(CONFIG_VFIO_PCI_IGD) &&
>  	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
> -	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
> +	    ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA ||

The above is vfio_pci_is_vga(pdev), maybe below should have a similar
helper.

> +	     (pdev->class >> 8) == PCI_CLASS_DISPLAY_OTHER) &&
> +	    pdev == pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(2, 0))) {

This increments the reference count on the device:

 * Given a PCI domain, bus, and slot/function number, the desired PCI
 * device is located in the list of PCI devices. If the device is
 * found, its reference count is increased and this function returns a
 * pointer to its data structure.  The caller must decrement the
 * reference count by calling pci_dev_put().

>  		ret = vfio_pci_igd_init(vdev);
>  		if (ret && ret != -ENODEV) {
>  			pci_warn(pdev, "Failed to setup Intel IGD regions\n");


