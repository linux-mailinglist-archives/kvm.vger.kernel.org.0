Return-Path: <kvm+bounces-31183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B089C10F5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1997F1C233D1
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D19921832F;
	Thu,  7 Nov 2024 21:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PBqaxFtO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8871CF7BB
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731014763; cv=none; b=iiBpoJotrsr6fS36s7U7LyMDJUpsXv6r2nZmaRMVm/WoJMbhcgwiqmQjGHWSwpQRFbRoqtSA9o6EQiQRsEbzyqmuX9KzVPhAUXCuCW1vaDOsTcuL2R5H61rq/34z3tyiiUuAgMqCT/ByxBA40GuCBsUSPSaOnaCKyUJJprFbdkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731014763; c=relaxed/simple;
	bh=pW4Mk6YiAta0P5QZSSY6WPlvBSHYrDftIxdkUw34ZZc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b8N1jXAG8wXDfRMJlNjoDsZTE7WW0BGOrVzThayPFeLpTBLLkOfPEtBWB43whIP5aeKHKb6TVU5buR7luONmdb+0kb15gut/g9SnyF/eBBfuLwGwQaZVztk3MFejCMP5ABFSdPg4anMkPKHm84FByJUQezXwzYgo/w3SgRS8uCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PBqaxFtO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731014759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrUNH9vtPlvjlTDQFOqG7/QZPSEZTHrrvLFCVTsPcHI=;
	b=PBqaxFtOxS0X1gKsdLPNEejlnCdaSKQLpqpYi71iK3VGiMQMWi1dtcYrZYGM1LtyH328Ko
	yj8LJPnVHMXKb+/mzJWvUXOiTczZ4XZKHWzhfrwBIv3G6y0BgMc50sQBRKR6YJMBPNrUAY
	8I9q0VXX1ugh4ic9XVx7RasrWq7PmcM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-c0Zz720tNVqSuE7TKsA5kQ-1; Thu, 07 Nov 2024 16:25:58 -0500
X-MC-Unique: c0Zz720tNVqSuE7TKsA5kQ-1
X-Mimecast-MFC-AGG-ID: c0Zz720tNVqSuE7TKsA5kQ
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83b7cce903cso28999239f.2
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 13:25:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731014758; x=1731619558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vrUNH9vtPlvjlTDQFOqG7/QZPSEZTHrrvLFCVTsPcHI=;
        b=fd1tSwETWHEiPauDP1YDElR6qRc5Y/kpKQvGW2Y0AYlrzh/LjZaX1my88puYwcysWI
         DRoVaoim5WLvGHOHlgNW3OiNZPGAEB062ji1jVoKNpwW5x1nKvF2+A2J8xbVUTaRBMck
         gI3tJCjpJ61pFm19Wu9VUaxdSf3/5iIOYX/2QDdrJDf4J+uizQJLOdR+nnwcvJArC0VH
         MrTYe/aq0Zj4wgwxa10IT+pxFsjpqCWw4q0kREzHMGZeqkKYAmCXdlhjJaSDKUWEVpRH
         djqNeqTdsSNsPitkEF68xkuePBhWy6JV7tby6+XJJ0VM1PKLsjsEi/wUrLNpVN6jaWiC
         sOeA==
X-Forwarded-Encrypted: i=1; AJvYcCXD2IkD9k/+R+VXmZqKbbV9uK/5pmBncQkNgV/usC+t3ydZZBiJWxBElbNUcUeCxEVEmVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YweZ2e173fAy2CHx5YR7esmm0dmRIwqo0VALyTBhowrABf7rKCS
	T+TkcaUQkIx6NVvmmYr8jgOfc0MUlwuDspNfnRp/AmIvXF1H1nQj5IY1th4qFUzhfgT3P6nLuAx
	VdoIUm7N2F92etC7LbxpMkNkLZJTsa0ngYpby4quGN4J5iGicJg==
X-Received: by 2002:a05:6602:1550:b0:83a:92e5:7eeb with SMTP id ca18e2360f4ac-83e03082657mr15267939f.0.1731014757799;
        Thu, 07 Nov 2024 13:25:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEp7eXeRbz62660yxPzQ0ijKk6KzJLsBL0eubgfdPA83fTKv0fV4hT1Cus63N4TbXPmff2OIQ==
X-Received: by 2002:a05:6602:1550:b0:83a:92e5:7eeb with SMTP id ca18e2360f4ac-83e03082657mr15266239f.0.1731014757262;
        Thu, 07 Nov 2024 13:25:57 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de5f8e2acesm477481173.113.2024.11.07.13.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 13:25:56 -0800 (PST)
Date: Thu, 7 Nov 2024 14:25:54 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, <mst@redhat.com>,
 <jasowang@redhat.com>, <kvm@vger.kernel.org>,
 <virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
 <feliu@nvidia.com>, <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
 <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
Message-ID: <20241107142554.1c38f347.alex.williamson@redhat.com>
In-Reply-To: <af8886fd-ec75-45fa-b627-2cd3c2ce905c@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241104102131.184193-8-yishaih@nvidia.com>
	<20241105162904.34b2114d.alex.williamson@redhat.com>
	<20241106135909.GO458827@nvidia.com>
	<20241106152732.16ac48d3.alex.williamson@redhat.com>
	<af8886fd-ec75-45fa-b627-2cd3c2ce905c@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2024 14:57:39 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 07/11/2024 0:27, Alex Williamson wrote:
> > On Wed, 6 Nov 2024 09:59:09 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >  =20
> >> On Tue, Nov 05, 2024 at 04:29:04PM -0700, Alex Williamson wrote: =20
> >>>> @@ -1,7 +1,7 @@
> >>>>   # SPDX-License-Identifier: GPL-2.0-only
> >>>>   config VIRTIO_VFIO_PCI
> >>>>           tristate "VFIO support for VIRTIO NET PCI devices"
> >>>> -        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
> >>>> +        depends on VIRTIO_PCI
> >>>>           select VFIO_PCI_CORE
> >>>>           help
> >>>>             This provides support for exposing VIRTIO NET VF devices=
 which support
> >>>> @@ -11,5 +11,7 @@ config VIRTIO_VFIO_PCI
> >>>>             As of that this driver emulates I/O BAR in software to l=
et a VF be
> >>>>             seen as a transitional device by its users and let it wo=
rk with
> >>>>             a legacy driver.
> >>>> +          In addition, it provides migration support for VIRTIO NET=
 VF devices
> >>>> +          using the VFIO framework. =20
> >>>
> >>> The first half of this now describes something that may or may not be
> >>> enabled by this config option and the additional help text for
> >>> migration is vague enough relative to PF requirements to get user
> >>> reports that the driver doesn't work as intended. =20
> >>
> >> Yes, I think the help should be clearer
> >> =20
> >>> For the former, maybe we still want a separate config item that's
> >>> optionally enabled if VIRTIO_VFIO_PCI && VFIO_PCI_ADMIN_LEGACY. =20
> >>
> >> If we are going to add a bunch of  #ifdefs/etc for ADMIN_LEGACY we
> >> may as well just use VIRTIO_PCI_ADMIN_LEGACY directly and not
> >> introduce another kconfig for it? =20
> >=20
> > I think that's what Yishai is proposing, but as we're adding a whole
> > new feature to the driver I'm concerned how the person configuring the
> > kernel knows which features from the description might be available in
> > the resulting driver.
> >=20
> > We could maybe solve that with a completely re-written help text that
> > describes the legacy feature as X86-only and migration as a separate
> > architecture independent feature, but people aren't great at reading
> > and part of the audience is going to see "X86" in their peripheral
> > vision and disable it, and maybe even complain that the text was
> > presented to them.
> >=20
> > OR, we can just add an optional sub-config bool that makes it easier to
> > describe the (new) main feature of the driver as supporting live
> > migration (on supported hardware) and the sub-config option as
> > providing legacy support (on supported hardware), and that sub-config
> > is only presented on X86, ie. ADMIN_LEGACY.
> >=20
> > Ultimately the code already needs to support #ifdefs for the latter and
> > I think it's more user friendly and versatile to have the separate
> > config option.
> >=20
> > NB. The sub-config should be default on for upgrade compatibility.
> >  =20
> >> Is there any reason to compile out the migration support for virtio?
> >> No other drivers were doing this? =20
> >=20
> > No other vfio-pci variant driver provides multiple, independent
> > features, so for instance to compile out migration support from the
> > vfio-pci-mlx5 driver is to simply disable the driver altogether.
> >  =20
> >> kconfig combinations are painful, it woudl be nice to not make too
> >> many.. =20
> >=20
> > I'm not arguing for a legacy-only, non-migration version (please speak
> > up if someone wants that).  The code already needs to support the
> > #ifdefs and I think reflecting that in a sub-config option helps
> > clarify what the driver is providing and conveniently makes it possible
> > to have a driver with exactly the same feature set across archs, if
> > desired.  Thanks,
> >  =20
>=20
> Since the live migration functionality is not architecture-dependent=20
> (unlike legacy access, which requires X86) and is likely to be the=20
> primary use of the driver, I would suggest keeping it outside of any=20
> #ifdef directives, as initially introduced in V1.
>=20
> To address the description issue and provide control for customers who=20
> may need the legacy access functionality, we could introduce a bool=20
> configuration option as a submenu under the driver=E2=80=99s main live mi=
gration=20
> feature.
>=20
> This approach will keep things simple and align with the typical use=20
> case of the driver.
>=20
> Something like the below [1] can do the job for that.
>=20
> Alex,
> Can that work for you ?
>=20
> By the way, you have suggested calling the config entry=20
> VFIO_PCI_ADMIN_LEGACY, don't we need to add here also the VIRTIO as a=20
> prefix ? (i.e. VIRTIO_VFIO_PCI_ADMIN_LEGACY)

I think that was just a typo referring to VIRTIO_PCI_ADMIN_LEGACY.
Yes, appending _ADMIN_LEGACY to the main config option is fine.

> [1]
> # SPDX-License-Identifier: GPL-2.0-only
>=20
> config VIRTIO_VFIO_PCI
>          tristate "VFIO support for live migration over VIRTIO NET PCI
>                    devices"

Looking at other variant drivers, I think this should just be:

	"VFIO support for VIRTIO NET PCI VF devices"

>          depends on VIRTIO_PCI
>          select VFIO_PCI_CORE
>          select IOMMUFD_DRIVER

IIUC, this is not a dependency, the device will just lack dirty page
tracking with either the type1 backend or when using iommufd when the
IOMMU hardware doesn't have dirty page tracking, therefore all VM
memory is perpetually dirty.  Do I have that right?

>          help
>            This provides migration support for VIRTIO NET PCI VF devices
>            using the VFIO framework.

This is still too open ended for me, there is specific PF support
required in the device to make this work.  Maybe...

	This provides migration support for VIRTIO NET PCI VF devices
	using the VFIO framework.  Migration support requires the
	SR-IOV PF device to support specific VIRTIO extensions,
	otherwise this driver provides no additional functionality
	beyond vfio-pci.

	Migration support in this driver relies on dirty page tracking
	provided by the IOMMU hardware and exposed through IOMMUFD, any
	other use cases are dis-recommended.

>            If you don't know what to do here, say N.
>=20
> config VFIO_PCI_ADMIN_LEGACY

VIRTIO_VFIO_PCI_ADMIN_LEGACY

>          bool "VFIO support for legacy I/O access for VIRTIO NET PCI
>                devices"

Maybe:

	"Legacy I/O support for VIRTIO NET PCI VF devices"

>          depends on VIRTIO_VFIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
>          default y
>          help
>            This provides support for exposing VIRTIO NET VF devices which
>            support legacy IO access, using the VFIO framework that can
>            work with a legacy virtio driver in the guest.
>            Based on PCIe spec, VFs do not support I/O Space.
>            As of that this driver emulates I/O BAR in software to let a
>            VF be seen as a transitional device by its users and let it
>            work with a legacy driver.

Maybe:

	This extends the virtio-vfio-pci driver to support legacy I/O
	access, allowing use of legacy virtio drivers with VIRTIO NET
	PCI VF devices.  Legacy I/O support requires the SR-IOV PF
	device to support and enable specific VIRTIO extensions,
	otherwise this driver provides no additional functionality
	beyond vfio-pci.

IMO, noting the PF requirement in each is important (feel free to
elaborate on specific VIRTIO extension requirements).  It doesn't seem
necessary to explain how the legacy compatibility works, only that this
driver makes the VF compatible with the legacy driver.

Are both of these options configurable at the PF in either firmware or
software?  I used "support and enable" in the legacy section assuming
that there is such a knob, but for migration it seems less necessary
that there's an enable step.  Please correct based on the actual
device behavior.  Thanks,

Alex


