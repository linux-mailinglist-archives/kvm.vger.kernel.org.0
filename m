Return-Path: <kvm+bounces-36126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8A9A18131
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E95816BDE7
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCEF1F471D;
	Tue, 21 Jan 2025 15:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dtti4lss"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9231F3D36
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737473693; cv=none; b=WbDLH9QQTXzbxPwsYhgh7+TwOkuGuldCVwynv7ywgPzptGKf9XCFwtAJvYvFpNqbrjVv/1fPBS2o5kNrtS92KKQdpIBhx1uxH8/YG/1JGpRvljcBZYvx9CLZNg5YU0MZgr5bCyFFsTRGr2VFffNIwUQbVrVCXCIbhBAIWm5oouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737473693; c=relaxed/simple;
	bh=afviXNWO37OLbCdPveVgalVfRIUMjV5OEQjfKTrtdr0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZMpgkNXUSv9SIx+oEYhln3oDRgk12dlimtNusdsIsP4nLNG0X+Y1h9Jse1ymaj5jPqewufJkXDw2VSIv0xB2IeskErsamJDtK2H2dGjdE2tPeooZsMZ4WDvT9a3a/F8GjGMuufJSC4dOU6aW4puEEJDoOWDS8L5c1KpM87FCzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dtti4lss; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737473690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uMSAKbRPh6a+5W2yOXg2mdEQMDX85qLb4xAsmG7l1FI=;
	b=Dtti4lssex7vFWbAc2qBUB7QnX2u3G2zjPtQ6Gk2cKoE9nH/fBnFD3D9A9O00ea9MnMEDJ
	oXTT6EDGr9hSHnHA7APfYy964jUNRPq5S7hwdS1FIh1rjzzl6H+RjAxgObY0A+V/J73nx0
	n/9SjMaOWj51MgxVEGyweIssjDFn8gs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-ZsHTPgTfNyKfRTkDyQ-DpQ-1; Tue, 21 Jan 2025 10:34:48 -0500
X-MC-Unique: ZsHTPgTfNyKfRTkDyQ-DpQ-1
X-Mimecast-MFC-AGG-ID: ZsHTPgTfNyKfRTkDyQ-DpQ
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ce46f7d554so4222855ab.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 07:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737473687; x=1738078487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMSAKbRPh6a+5W2yOXg2mdEQMDX85qLb4xAsmG7l1FI=;
        b=udXwVdW5neS9wPh1lbZ0dPFNfysQovhoc8XU8CI82qijCxG36S2t39KXhFWc23Mi6t
         El8foemV7PWkopEaqNrRgINYf6lLMZ7H5tsGkY/93lhgy67nChnthhpnazzOXfMGP0qs
         6q/0pZb0XYb5lmL53DGfkHDj/h+dcIVZm4by2m5V5RhpmQM6K0Slmz3u51FItjJQ1uBU
         UwagC9txE1NPwn/Qx6ZF9inO/kfbc1exLICJkaZTt+aXUhSWScGxL+3EiBdVkZSETmON
         Wvz5BJQYuByoUNiroDyvgJDYcUC0D1lFMNEODkIp/E/taPK+zaQr0SM89EqMcNNjvRMX
         PmUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqwVZY4g4Nvfbh661urs+95GCuUNLe75S7mnuUwmxpYhkUIT/CwY5B0f44LxcFMIlVu6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7khOVe4XLsVmyjHm8LHuNCi2M81cGHzsCJ7f483us9oyRyTZZ
	8OrWw74efEt9QRvLg4r5yLWsiP4w4+eoNB/+NpSfFBUDiHOBttaSU7LARM9emD3L9HBRi2ap18j
	dAaye4n9Dk/VIcNqDCB9TXVMvYFKWV8+SQs2v10Xm7GUedsktcw==
X-Gm-Gg: ASbGncttZ2J8Be5+bNakXbNs14RfBQsoWxv4pHOAY23CUe8xCVd2k3xdmwnBVBRAZ1p
	T8JSsvgCYE3vYsoXlL9QMc+QmSVn//vDyyy4xrg9pZcJV7PbSXWHAGQyRivo6eXYNkotX1stkgK
	bP9C/T0hJ8JtiAyKJNCrixsU2vy2rGuS25VGQMZ/1jalryO2NZn0nuKJQnZ9RhfNe2T/UKoWflZ
	nPSbYN9rFEA6DYgZZ5mcUWw65qs2qF+kEhJd1SjBh7VRJPsZ1JaE4U07VM1CyAwqBEiexZLNQ==
X-Received: by 2002:a05:6602:888:b0:847:5b61:636c with SMTP id ca18e2360f4ac-851b618ea35mr341445439f.2.1737473687365;
        Tue, 21 Jan 2025 07:34:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkmTrnhDbMZuVVvF5aGKoAlr5t2ri5MIgtN3x0h66amEtEIzKucp7O3u/rYt/X9g6rlR8mng==
X-Received: by 2002:a05:6602:888:b0:847:5b61:636c with SMTP id ca18e2360f4ac-851b618ea35mr341443939f.2.1737473686956;
        Tue, 21 Jan 2025 07:34:46 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea753f6502sm3381142173.18.2025.01.21.07.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 07:34:46 -0800 (PST)
Date: Tue, 21 Jan 2025 08:34:43 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Wencheng Yang <east.moutain.yang@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin
 Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] drviers/iommu/amd: support P2P access through IOMMU
 when SME is enabled
Message-ID: <20250121083443.3984579a.alex.williamson@redhat.com>
In-Reply-To: <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
References: <20250117071423.469880-1-east.moutain.yang@gmail.com>
	<20250117084449.6cfd68b3.alex.williamson@redhat.com>
	<CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Jan 2025 19:07:26 +0800
Wencheng Yang <east.moutain.yang@gmail.com> wrote:

> > This needs to:
> >
> >  - Be split into separate IOMMU vs VFIO patches
> >  - Consider and consolidate with other IOMMU implementations of the sam=
e =20
>=20
> I will do that in the next patch.

Clearly the latter bullet is not considered in the most recent posting.

> >  - Provide introspection to userspace relative to the availability of
> >    the resulting mapping option =20
> I don't get your meaning, can you expain in detail?

Generally it would be polite to get these sorts of clarifications
before spamming the list with another version of the series.  Userspace
has no ability to determine whether the kernel supports this flag other
than trial and error.  The ability to determine the kernel support for
a new feature is introspection.  For example, if QEMU blindly adds the
MMIO flag the mapping will fail on older kernels.  How does QEMU know
whether support for the flag is available on the underlying kernel?

> > It's also not clear to me that the user should be responsible for
> > setting this flag versus something in the VFIO or IOMMU layer.  For
> > example what are the implications of the user setting this flag
> > incorrectly (not just failing to set it for MMIO, but using it for RAM)=
? =20
>=20
> If user sets this flag to RAM region, it has no effect on the platform
> that memory
> encrytion is disable. If memory encrytion is enabled, then device
> can't get correct
> data from RAM, for example, CPU writes data to RAM that is encrypted by
> memory controller, but device read the data from RAM as plaintext, but wi=
ll
> never leak confidential data.

This description is unclear to me.  As others have noted, we probably
need to look at whether the flag should be automatically applied by the
kernel.  We certainly know in the vfio IOMMU layer whether we're
mapping a page or a pfnmap.  In any case, we're in the process of
phasing out the vfio type1 IOMMU backend for iommufd, so whatever the
implementation, and especially if there's a uapi component, it needs to
be implemented in iommufd first.  Thanks,

Alex

> On Fri, Jan 17, 2025 at 9:45=E2=80=AFPM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Fri, 17 Jan 2025 15:14:18 +0800
> > Wencheng Yang <east.moutain.yang@gmail.com> wrote:
> > =20
> > > When SME is enabled, memory encryption bit is set in IOMMU page table
> > > pte entry, it works fine if the pfn of the pte entry is memory.
> > > However, if the pfn is MMIO address, for example, map other device's =
mmio
> > > space to its io page table, in such situation, setting memory encrypt=
ion
> > > bit in pte would cause P2P failure.
> > >
> > > Clear memory encryption bit in io page table if the mapping is MMIO
> > > rather than memory.
> > >
> > > Signed-off-by: Wencheng Yang <east.moutain.yang@gmail.com>
> > > ---
> > >  drivers/iommu/amd/amd_iommu_types.h | 7 ++++---
> > >  drivers/iommu/amd/io_pgtable.c      | 2 ++
> > >  drivers/iommu/amd/io_pgtable_v2.c   | 5 ++++-
> > >  drivers/iommu/amd/iommu.c           | 2 ++
> > >  drivers/vfio/vfio_iommu_type1.c     | 4 +++-
> > >  include/uapi/linux/vfio.h           | 1 +
> > >  6 files changed, 16 insertions(+), 5 deletions(-) =20
> >
> > This needs to:
> >
> >  - Be split into separate IOMMU vs VFIO patches
> >  - Consider and consolidate with other IOMMU implementations of the same
> >  - Provide introspection to userspace relative to the availability of
> >    the resulting mapping option
> >
> > It's also not clear to me that the user should be responsible for
> > setting this flag versus something in the VFIO or IOMMU layer.  For
> > example what are the implications of the user setting this flag
> > incorrectly (not just failing to set it for MMIO, but using it for RAM)=
? =20
>=20
> > Thanks,
> >
> > Alex
> > =20
> > >
> > > diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/=
amd_iommu_types.h
> > > index fdb0357e0bb9..b0f055200cf3 100644
> > > --- a/drivers/iommu/amd/amd_iommu_types.h
> > > +++ b/drivers/iommu/amd/amd_iommu_types.h
> > > @@ -434,9 +434,10 @@
> > >  #define IOMMU_PTE_PAGE(pte) (iommu_phys_to_virt((pte) & IOMMU_PAGE_M=
ASK))
> > >  #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
> > >
> > > -#define IOMMU_PROT_MASK 0x03
> > > -#define IOMMU_PROT_IR 0x01
> > > -#define IOMMU_PROT_IW 0x02
> > > +#define IOMMU_PROT_MASK 0x07
> > > +#define IOMMU_PROT_IR   0x01
> > > +#define IOMMU_PROT_IW   0x02
> > > +#define IOMMU_PROT_MMIO 0x04
> > >
> > >  #define IOMMU_UNITY_MAP_FLAG_EXCL_RANGE      (1 << 2)
> > >
> > > diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pg=
table.c
> > > index f3399087859f..dff887958a56 100644
> > > --- a/drivers/iommu/amd/io_pgtable.c
> > > +++ b/drivers/iommu/amd/io_pgtable.c
> > > @@ -373,6 +373,8 @@ static int iommu_v1_map_pages(struct io_pgtable_o=
ps *ops, unsigned long iova,
> > >                       __pte |=3D IOMMU_PTE_IR;
> > >               if (prot & IOMMU_PROT_IW)
> > >                       __pte |=3D IOMMU_PTE_IW;
> > > +             if (prot & IOMMU_PROT_MMIO)
> > > +                     __pte =3D __sme_clr(__pte);
> > >
> > >               for (i =3D 0; i < count; ++i)
> > >                       pte[i] =3D __pte;
> > > diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io=
_pgtable_v2.c
> > > index c616de2c5926..55f969727dea 100644
> > > --- a/drivers/iommu/amd/io_pgtable_v2.c
> > > +++ b/drivers/iommu/amd/io_pgtable_v2.c
> > > @@ -65,7 +65,10 @@ static u64 set_pte_attr(u64 paddr, u64 pg_size, in=
t prot)
> > >  {
> > >       u64 pte;
> > >
> > > -     pte =3D __sme_set(paddr & PM_ADDR_MASK);
> > > +     pte =3D paddr & PM_ADDR_MASK;
> > > +     if (!(prot & IOMMU_PROT_MMIO))
> > > +             pte =3D __sme_set(pte);
> > > +
> > >       pte |=3D IOMMU_PAGE_PRESENT | IOMMU_PAGE_USER;
> > >       pte |=3D IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
> > >
> > > diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> > > index 16f40b8000d7..9194ad681504 100644
> > > --- a/drivers/iommu/amd/iommu.c
> > > +++ b/drivers/iommu/amd/iommu.c
> > > @@ -2578,6 +2578,8 @@ static int amd_iommu_map_pages(struct iommu_dom=
ain *dom, unsigned long iova,
> > >               prot |=3D IOMMU_PROT_IR;
> > >       if (iommu_prot & IOMMU_WRITE)
> > >               prot |=3D IOMMU_PROT_IW;
> > > +     if (iommu_prot & IOMMU_MMIO)
> > > +             prot |=3D IOMMU_PROT_MMIO;
> > >
> > >       if (ops->map_pages) {
> > >               ret =3D ops->map_pages(ops, iova, paddr, pgsize,
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iomm=
u_type1.c
> > > index 50ebc9593c9d..08be1ef8514b 100644
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -1557,6 +1557,8 @@ static int vfio_dma_do_map(struct vfio_iommu *i=
ommu,
> > >               prot |=3D IOMMU_WRITE;
> > >       if (map->flags & VFIO_DMA_MAP_FLAG_READ)
> > >               prot |=3D IOMMU_READ;
> > > +    if (map->flags & VFIO_DMA_MAP_FLAG_MMIO)
> > > +        prot |=3D IOMMU_MMIO;
> > >
> > >       if ((prot && set_vaddr) || (!prot && !set_vaddr))
> > >               return -EINVAL;
> > > @@ -2801,7 +2803,7 @@ static int vfio_iommu_type1_map_dma(struct vfio=
_iommu *iommu,
> > >       struct vfio_iommu_type1_dma_map map;
> > >       unsigned long minsz;
> > >       uint32_t mask =3D VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WR=
ITE |
> > > -                     VFIO_DMA_MAP_FLAG_VADDR;
> > > +                     VFIO_DMA_MAP_FLAG_VADDR | VFIO_DMA_MAP_FLAG_MMI=
O;
> > >
> > >       minsz =3D offsetofend(struct vfio_iommu_type1_dma_map, size);
> > >
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index c8dbf8219c4f..68002c8f1157 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -1560,6 +1560,7 @@ struct vfio_iommu_type1_dma_map {
> > >  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)              /* readable fro=
m device */
> > >  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)     /* writable from device=
 */
> > >  #define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
> > > +#define VFIO_DMA_MAP_FLAG_MMIO (1 << 3)     /* map of mmio */
> > >       __u64   vaddr;                          /* Process virtual addr=
ess */
> > >       __u64   iova;                           /* IO virtual address */
> > >       __u64   size;                           /* Size of mapping (byt=
es) */ =20
> > =20
>=20


