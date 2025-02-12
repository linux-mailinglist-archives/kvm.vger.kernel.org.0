Return-Path: <kvm+bounces-37987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BABD0A330D2
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 21:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66D78167EB7
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 20:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB7E201258;
	Wed, 12 Feb 2025 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S3dtN+I5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB988200B99
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739392099; cv=none; b=KQOosZVZCWLvKR9DNZ8fO/T9/JlmzLs3Qs9ZcG5iezK/ATibuO6lefmpugmRzAzsNGzQUJSzSk7/HJmKKqHC8PAGIuGtTR8K3EqdrWhKq5kHRuGPREpXcj4oqdUhAlKZF5kANZnc+HzB2NTq4k0GxQMl1z8EL02Eaq5XjkZCvdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739392099; c=relaxed/simple;
	bh=sjyb8CO9UDI0bkvCcVRPvdxFy6b8B/z8MMi7G+pzvSs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XypIHUYVIVRf0b1U3TgCPjSRwakODkI0zwMkfJ0cGMG69rF19tI/Z5IV8RmT1IrFU9IbrMrCK48U91eWO7bwaLGkc9FLswRXcvHL7ZEgujsv9h1RPu0ncRW4kkAferxdiTE+DaqbwKDKMCAnDMSj6XZa8y78p6OkhOpB19E7ge0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S3dtN+I5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739392096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UEoeLSsS3aCEim/Ww8cGuMBb2a0y/QZooCtBWDiEWjA=;
	b=S3dtN+I55XaLdh8p0ehDOL+JzDJBJmMsnaNNPr7kwClBcM4f3hmmwLkz9eVY+Vm3E+I0/l
	MUAuIfr4OG1pO11Ysrtjr2KaCXseAdjHPkjy+/NTFjrSau284FCXl4fxjXG0lo8OoibpuL
	vG4m/MH8Xw+hmB7nSvx+1GQRFiFKzlw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-0_iH82zHNSyqqNYOWJX3tA-1; Wed, 12 Feb 2025 15:28:15 -0500
X-MC-Unique: 0_iH82zHNSyqqNYOWJX3tA-1
X-Mimecast-MFC-AGG-ID: 0_iH82zHNSyqqNYOWJX3tA
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-85534e45380so1987739f.1
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 12:28:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739392095; x=1739996895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UEoeLSsS3aCEim/Ww8cGuMBb2a0y/QZooCtBWDiEWjA=;
        b=ezcBTKua/jANNMR3T6FmzUMpg1XqRgb8XvGXudNVeuzwBBJqe5ZjVSOqo6hbWDBPfs
         LKuvRosuvdy7BhHifvPhow093VEGIg1dvsh5f1G5S/Hj4qH5oMw/DaJo+MBJKkC1AqDm
         40SEaiKTX2MFBR2LXAej+qP8AJT5d5DN6J2JaGRz9NSuQWhZ3YYt7JBnWPx0x7cK8pO0
         0hpx315NNs5PQ6tyWH6DwsVJ3s69FHEBzns3MOQg7zwm0+onajL9tavMenJLbpFteFl8
         Pk7fk2fvdheuZMvtWMwpd56sK5utyDCdoqxBlvTvPBHptH8rFuejDIW6UCWj1tnRH4fe
         BQlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDx9cegQHZKqVJacHdujvMbLSTAg7CnS65SmKFkBackTLqmM2pai2l52GwvlMqvQngra4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlhPxa/Idr55CvNk9Wpw3SHbxLiIXI7HtQHajasPwJZibVj252
	u9RqrzQJn6u18ckdRSwgF0d5Uo+gt1saTHW+hKwdkFOH0jISiaEWFRr0danU7aoJRmxboyiqoaS
	A8Ct4OfEIWUfZ64o6z8xY4LIuIZNGPtavM6T/E0yTEjMTyO/Nhg==
X-Gm-Gg: ASbGnctFzhGffgE6MXjy7F1kMVtl44TxEG7XFMGRqlY5uouFVvAAr9d/32sVkcvpQv4
	WIB8XRp66pioLs229akR0gebWxYzvL1x2r7qAMQxtN36LhCzdlw413Dy2ABVItnBLe3Sskwx3xX
	YK9f+Z9jvinin4/jW/7JfmZIG3KoEvL7/Z5wVlg7iZ6yIYujusb+IiqqnEzAO1mdzrKFOUy/pa6
	kshSN9x+iKmTPHBOSft+m/CLvkUd77+GwYNUTKEASrqtazB8TsXSDZW2gRTlzKfwG2aXo3/TxK7
	qERuOY5p
X-Received: by 2002:a92:cd84:0:b0:3d0:17d2:a02a with SMTP id e9e14a558f8ab-3d17bffab44mr9449655ab.6.1739392094516;
        Wed, 12 Feb 2025 12:28:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGyMnLl5ryneXcFqbJLdWXtkIqeCdaQ3vDzYtJyQFOGuNj5RmpgPu7yQTnc7ZA4uZtoSr3rVg==
X-Received: by 2002:a92:cd84:0:b0:3d0:17d2:a02a with SMTP id e9e14a558f8ab-3d17bffab44mr9449525ab.6.1739392094143;
        Wed, 12 Feb 2025 12:28:14 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eccf9afc38sm3393858173.1.2025.02.12.12.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 12:28:12 -0800 (PST)
Date: Wed, 12 Feb 2025 13:28:08 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alexandra Winter <wintera@linux.ibm.com>, Gerd Bayer
 <gbayer@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Thorsten Winkler <twinkler@linux.ibm.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Julian Ruess <julianr@linux.ibm.com>, Halil
 Pasic <pasic@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 2/2] PCI: s390: Support mmap() of BARs and replace
 VFIO_PCI_MMAP by a device flag
Message-ID: <20250212132808.08dcf03c.alex.williamson@redhat.com>
In-Reply-To: <20250212-vfio_pci_mmap-v5-2-633ca5e056da@linux.ibm.com>
References: <20250212-vfio_pci_mmap-v5-0-633ca5e056da@linux.ibm.com>
	<20250212-vfio_pci_mmap-v5-2-633ca5e056da@linux.ibm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Feb 2025 16:28:32 +0100
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> On s390 there is a virtual PCI device called ISM which has a few
> peculiarities. For one, it presents a 256 TiB PCI BAR whose size leads
> to any attempt to ioremap() the whole BAR failing. This is problematic
> since mapping the whole BAR is the default behavior of for example
> vfio-pci in combination with QEMU and VFIO_PCI_MMAP enabled.
> 
> Even if one tried to map this BAR only partially, the mapping would not
> be usable without extra precautions on systems with MIO support enabled.
> This is because of another oddity, in that this virtual PCI device does
> not support the newer memory I/O (MIO) PCI instructions and legacy PCI
> instructions are not accessible through writeq()/readq() when MIO is in
> use.
> 
> In short the ISM device's BAR is not accessible through memory mappings.
> Indicate this by introducing a new non_mappable_bars flag for the ISM
> device and set it using a PCI quirk. Use this flag instead of the
> VFIO_PCI_MMAP Kconfig option to block mapping with vfio-pci. This was
> the only use of the Kconfig option so remove it. Note that there are no
> PCI resource sysfs files on s390x already as HAVE_PCI_MMAP is currently
> not set. If this were to be set in the future pdev->non_mappable_bars
> can be used to prevent unusable resource files for ISM from being
> created.

I think we should also look at it from the opposite side, not just
s390x maybe adding HAVE_PCI_MMAP in the future, but the fact that we're
currently adding a generic PCI device flag which isn't honored by the
one mechanism that PCI core provides to mmap MMIO BARs to userspace.
It seems easier to implement it in pci_mmap_resource() now rather than
someone later discovering there's no enforcement outside of the very
narrow s390x use case.  Thanks,

Alex

> As s390x has no PCI quirk handling add basic support modeled after x86's
> arch/x86/pci/fixup.c and move the ISM device's PCI ID to the common
> header to make it accessible. Also enable CONFIG_PCI_QUIRKS whenever
> CONFIG_PCI is enabled.
> 
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  arch/s390/Kconfig                |  4 +---
>  arch/s390/pci/Makefile           |  2 +-
>  arch/s390/pci/pci_fixup.c        | 23 +++++++++++++++++++++++
>  drivers/s390/net/ism_drv.c       |  1 -
>  drivers/vfio/pci/Kconfig         |  4 ----
>  drivers/vfio/pci/vfio_pci_core.c |  2 +-
>  include/linux/pci.h              |  1 +
>  include/linux/pci_ids.h          |  1 +
>  8 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 9c9ec08d78c71b4d227beeafab1b82d6434cb5c7..e48741e001476f765e8aba0037a1b386df393683 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -41,9 +41,6 @@ config AUDIT_ARCH
>  config NO_IOPORT_MAP
>  	def_bool y
>  
> -config PCI_QUIRKS
> -	def_bool n
> -
>  config ARCH_SUPPORTS_UPROBES
>  	def_bool y
>  
> @@ -258,6 +255,7 @@ config S390
>  	select PCI_DOMAINS		if PCI
>  	select PCI_MSI			if PCI
>  	select PCI_MSI_ARCH_FALLBACKS	if PCI_MSI
> +	select PCI_QUIRKS		if PCI
>  	select SPARSE_IRQ
>  	select SWIOTLB
>  	select SYSCTL_EXCEPTION_TRACE
> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> index df73c5182990ad3ae4ed5a785953011feb9a093c..1810e0944a4ed9d31261788f0f6eb341e5316546 100644
> --- a/arch/s390/pci/Makefile
> +++ b/arch/s390/pci/Makefile
> @@ -5,6 +5,6 @@
>  
>  obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_clp.o \
>  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
> -			   pci_bus.o pci_kvm_hook.o pci_report.o
> +			   pci_bus.o pci_kvm_hook.o pci_report.o pci_fixup.o
>  obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
>  obj-$(CONFIG_SYSFS)	+= pci_sysfs.o
> diff --git a/arch/s390/pci/pci_fixup.c b/arch/s390/pci/pci_fixup.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..35688b645098329f082d0c40cc8c59231c390eaa
> --- /dev/null
> +++ b/arch/s390/pci/pci_fixup.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Exceptions for specific devices,
> + *
> + * Copyright IBM Corp. 2025
> + *
> + * Author(s):
> + *   Niklas Schnelle <schnelle@linux.ibm.com>
> + */
> +#include <linux/pci.h>
> +
> +static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
> +{
> +	/*
> +	 * ISM's BAR is special. Drivers written for ISM know
> +	 * how to handle this but others need to be aware of their
> +	 * special nature e.g. to prevent attempts to mmap() it.
> +	 */
> +	pdev->non_mappable_bars = 1;
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IBM,
> +			PCI_DEVICE_ID_IBM_ISM,
> +			zpci_ism_bar_no_mmap);
> diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
> index e36e3ea165d3b2b01d68e53634676cb8c2c40220..d32633ed9fa80c1764724f493b363bfd6cb4f9cf 100644
> --- a/drivers/s390/net/ism_drv.c
> +++ b/drivers/s390/net/ism_drv.c
> @@ -20,7 +20,6 @@
>  MODULE_DESCRIPTION("ISM driver for s390");
>  MODULE_LICENSE("GPL");
>  
> -#define PCI_DEVICE_ID_IBM_ISM 0x04ED
>  #define DRV_NAME "ism"
>  
>  static const struct pci_device_id ism_device_table[] = {
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index bf50ffa10bdea9e52a9d01cc3d6ee4cade39a08c..c3bcb6911c538286f7985f9c5e938d587fc04b56 100644
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
> index 586e49efb81be32ccb50ca554a60cec684c37402..c8586d47704c74cf9a5256d65bbf888db72b2f91 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -116,7 +116,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  
>  		res = &vdev->pdev->resource[bar];
>  
> -		if (!IS_ENABLED(CONFIG_VFIO_PCI_MMAP))
> +		if (vdev->pdev->non_mappable_bars)
>  			goto no_mmap;
>  
>  		if (!(res->flags & IORESOURCE_MEM))
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 47b31ad724fa5bf7abd7c3dc572947551b0f2148..7192b9d78d7e337ce6144190325458fe3c0f1696 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -476,6 +476,7 @@ struct pci_dev {
>  	unsigned int	no_command_memory:1;	/* No PCI_COMMAND_MEMORY */
>  	unsigned int	rom_bar_overlap:1;	/* ROM BAR disable broken */
>  	unsigned int	rom_attr_enabled:1;	/* Display of ROM attribute enabled? */
> +	unsigned int	non_mappable_bars:1;	/* BARs can't be mapped to user-space  */
>  	pci_dev_flags_t dev_flags;
>  	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>  
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index de5deb1a0118fcf56570d461cbe7a501d4bd0da3..ec6d311ed12e174dc0bad2ce8c92454bed668fee 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -518,6 +518,7 @@
>  #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
>  #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
>  #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
> +#define PCI_DEVICE_ID_IBM_ISM		0x04ED
>  
>  #define PCI_SUBVENDOR_ID_IBM		0x1014
>  #define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4
> 


