Return-Path: <kvm+bounces-59175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A1DBAE02B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE8C216E759
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D581F307487;
	Tue, 30 Sep 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iEaJoRjB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B13081C3
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759248491; cv=none; b=jQnw1I8Hq6OyDcnANCa5/iKppkntK6ImIxcGY9hXzEJY5bT3E2UQUrUPko8jzrCZRZZxVylq3LDLJCfnUiR+sIcBC25IA9BV+mMFWgm96Tv5RONppBs4xEeAMOuV/QEcLJsh0A3IHf56ZnCPvx+60GXB4o9AoLZlvhET6wNjBVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759248491; c=relaxed/simple;
	bh=snlcpuhg9ToSlXPE+QrSoUGnOciOVCfFz6OxetVNkco=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IP12Jt+OyVkwvN2IiOvptLzj2uZW+B9r+T+z0dlUHUhGoD/dfHjrR5lOV79Ejw+CUaCFo+30ExBFZsmKlAGiJhpVv3dH207/1KUrI1hKbO/ZbQKRX7e+QRMoIUKfUsDlVMwBeHvvqwHxqUy6u7W4vsI8Q1ZlTG0lezjV4htSeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iEaJoRjB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759248488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wSk9NtZOWjVSHAXaMNsatYeAsaJr+OLKF/ipGZAl/7o=;
	b=iEaJoRjBA+qVbCTNV/oqwJexw0nqTxU26QfQUuNEGd/e5LwcG3SVI3iwX/J6+77+Hu96GU
	lCb1LtkdllqxxX7pyggvfazgHuKUXRj6PlAVNRCixumnbidCkdLMeK5OE+6jOxiiQ3zu9q
	fQqlXWepq5BkNzXq491VZo89wdOJVno=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-a0CeXpb4PvmFXPptzYH2iA-1; Tue, 30 Sep 2025 12:08:05 -0400
X-MC-Unique: a0CeXpb4PvmFXPptzYH2iA-1
X-Mimecast-MFC-AGG-ID: a0CeXpb4PvmFXPptzYH2iA_1759248484
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7503f0ed0eeso1785689a34.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759248484; x=1759853284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wSk9NtZOWjVSHAXaMNsatYeAsaJr+OLKF/ipGZAl/7o=;
        b=C1YLWr0EyMTe6CcsQujgLJDZgOwK1LdAAg0KmOhIpnA3bEClqbU20yvPBmXKFkUnvd
         8L25RvbfIEpxTylv7otzstCRiKxbWdZqCndpfmaIu7YykPzKMxYkhHairydApqyJOj3K
         kCUZa4lqUH6P4oU+XYChDsPBiIPuBZqU8Lki3s/5IlQN/7ESX0rami8kS1Z3Y69Lf9s6
         2xq8XwQ/zhjJAg1PJVKjeKus3AtlhQQKVnZJ8HL/pokUkEP00QHpBEquC5Ci1fmGjHju
         fnTWabDOKgkpU7YyqcDpfLRiG0+QTyupjNZa7OT5kmi5fRiYxrVQemF8r55xVomCGB/b
         L75g==
X-Forwarded-Encrypted: i=1; AJvYcCVh7ydxx8Iy9be9Wl84qBMm09GoU89fPuH7v12SntS/F+ZS6OtqrFx2ESgoIoF0IoZaiT8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhoRP/Hg4dLuskqC6Q/aQJn8ndPWmieRheeT4mtbcVrK4QG2WE
	W2UkYNrWH5z/DoxsOW4zNdOKmhWgUmNE+bWVvTit7pYFoMTtWRVeMlEPDwRRUtaC6icXi1MxUMy
	h1z1mjKHErPkWKpIYHULbLfKE1+RP3SRC9N/+j1/uKcfXrHtVj9BQgA==
X-Gm-Gg: ASbGncsNG1TzsrPJpI2mJJiMWPKjgGxWCvjprH5GlD0UHLXdCy3RuWTYtjzVrcFPPKO
	Umr7vNPgZtsBwxYbNK8hc+kq0XxmzyLNUDwBOBCdBwqTI2iZBB44Pbjh3OGaCZMR5rTpcGO4qaZ
	6jnS5mNevglnhuZsn89MN3IxmMWnWv3KE9X+eA319Oz60BCSUyMmPY/ifpCLVew5DRgcfkbMlMe
	BozhAUHgrbo/EExCtdtM6FE1IU9pqcMTLkindCMR2c1Is3+lAKSXISJNEuN52LF3qEuLs1n0/2U
	CfHtEM4rvLMrpwHe2zwVSNLwwDSONM+j7vYrPFDl3CB/baam
X-Received: by 2002:a05:6820:5082:b0:621:2845:6daa with SMTP id 006d021491bc7-64bb6545f8bmr113863eaf.0.1759248483602;
        Tue, 30 Sep 2025 09:08:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJseUyrGoKfdwzuhrG64O9kfcQryt5nehwMqyr+Cc6sT4mD/DyY2Du1MoSsHbbw6RCv1mcDg==
X-Received: by 2002:a05:6820:5082:b0:621:2845:6daa with SMTP id 006d021491bc7-64bb6545f8bmr113843eaf.0.1759248483252;
        Tue, 30 Sep 2025 09:08:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7b4c0e92da9sm1836631a34.26.2025.09.30.09.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 09:08:02 -0700 (PDT)
Date: Tue, 30 Sep 2025 10:07:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 07/10] vfio/pci: Add dma-buf export config for MMIO
 regions
Message-ID: <20250930100758.1605d5a5.alex.williamson@redhat.com>
In-Reply-To: <20250930075748.GF324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
	<b1b44823f93fd9e7fa73dc165141d716cb74fa90.1759070796.git.leon@kernel.org>
	<20250929151740.21f001e3.alex.williamson@redhat.com>
	<20250930075748.GF324804@unreal>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Sep 2025 10:57:48 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Mon, Sep 29, 2025 at 03:17:40PM -0600, Alex Williamson wrote:
> > On Sun, 28 Sep 2025 17:50:17 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Add new kernel config which indicates support for dma-buf export
> > > of MMIO regions, which implementation is provided in next patches.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---
> > >  drivers/vfio/pci/Kconfig | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > index 2b0172f54665..55ae888bf26a 100644
> > > --- a/drivers/vfio/pci/Kconfig
> > > +++ b/drivers/vfio/pci/Kconfig
> > > @@ -55,6 +55,26 @@ config VFIO_PCI_ZDEV_KVM
> > >  
> > >  	  To enable s390x KVM vfio-pci extensions, say Y.
> > >  
> > > +config VFIO_PCI_DMABUF
> > > +	bool "VFIO PCI extensions for DMA-BUF"
> > > +	depends on VFIO_PCI_CORE
> > > +	depends on PCI_P2PDMA && DMA_SHARED_BUFFER
> > > +	default y
> > > +	help
> > > +	  Enable support for VFIO PCI extensions that allow exporting
> > > +	  device MMIO regions as DMA-BUFs for peer devices to access via
> > > +	  peer-to-peer (P2P) DMA.
> > > +
> > > +	  This feature enables a VFIO-managed PCI device to export a portion
> > > +	  of its MMIO BAR as a DMA-BUF file descriptor, which can be passed
> > > +	  to other userspace drivers or kernel subsystems capable of
> > > +	  initiating DMA to that region.
> > > +
> > > +	  Say Y here if you want to enable VFIO DMABUF-based MMIO export
> > > +	  support for peer-to-peer DMA use cases.
> > > +
> > > +	  If unsure, say N.
> > > +
> > >  source "drivers/vfio/pci/mlx5/Kconfig"
> > >  
> > >  source "drivers/vfio/pci/hisilicon/Kconfig"  
> > 
> > This is only necessary if we think there's a need to build a kernel with
> > P2PDMA and VFIO_PCI, but not VFIO_PCI_DMABUF.  Does that need really
> > exist?  
> 
> It is used to filter build of vfio_pci_dmabuf.c - drivers/vfio/pci/Makefile:
> vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o

Maybe my question of whether it needs to exist at all is too broad.
Does it need to be a user visible Kconfig option?  Where do we see the
need to preclude this feature from vfio-pci if the dependencies are
enabled?

> > I also find it unusual to create the Kconfig before adding the
> > supporting code.  Maybe this could be popped to the end or rolled into
> > the last patch if we decided to keep it.  Thanks,  
> 
> It is leftover from previous version, I can squash it, but first we need
> to decide what to do with pcim_p2pdma_init() call, if it needs to be
> guarded or not.

As in the other thread, I think it would be cleaner in an IS_ENABLED
branch.  I'm tempted to suggest we filter out EOPNOTSUPP to allow it to
be unconditional, but I understand your point with the list_head
initialization.  Thanks,

Alex


