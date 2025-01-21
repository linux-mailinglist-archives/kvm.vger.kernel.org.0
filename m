Return-Path: <kvm+bounces-36103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71566A17C9A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 12:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DC0F3AB1E1
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B761F12EF;
	Tue, 21 Jan 2025 11:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTj33Yul"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B041B4137;
	Tue, 21 Jan 2025 11:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737457661; cv=none; b=eQNSSa/4+Ftrz+j0j6IdLgbSp3jYkXuDuDpOUjaqTgmiurC2DKZEDr5s/R33uHbwDnHFD1gsBZoaqfQg2WC/9kUQcFeDNyycyT86Rj0Hrn+7J7oOEueutxQcE3+ci3tD/ijzT1xkr/vVF+6AtNlyZTnQgm+pwE+pjySc4bl/u04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737457661; c=relaxed/simple;
	bh=m1tprvfWRRlC07DIQoKClTxgzVmEIjEJGYB7rI/Hsxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DvdGJEGoeDC/N2XEdwhG0Xk5yyKBxtzKNsydfzvEXdPIijyhF+PmyOLwLbxzBfI00UtDJPShkigcQrM0wGlJGJQBpF7Tv2QCDlcbW6rvPlpUgckEWjA1RkxWKx+hTr30AZwvdLXBy/JDge9reTiSKD2C9K3NI+iH5uu3PnCu0vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MTj33Yul; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-437a92d7b96so54145945e9.2;
        Tue, 21 Jan 2025 03:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737457657; x=1738062457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60Ashbu4ZtB730+B8toAPEzMOd5yglkvbvpHZzMPLiA=;
        b=MTj33Yul6Ijc2YkO7lcIFABvcP5vSOoxwsB75QlR9hP9Asi72IcP7Rr2s3bKgVd/sp
         PH2wOwvuYj9Ljp5/MUghcSvPWHYhv5ap79oBmw+1v8J3xiJ8xEBPB5vk5MjiaQnwGgfd
         D+3b/mip+ngvER/GUFeQSUmGW4pjIrjFJEGPK3LGs+ibN82at2dK2eV2VIMWoblGgNpc
         AkaXqCxhRbvtY8SZFJBOPhzuNrOOpOJYQXBp7nwzuysSvoOcloawvuXLzDqIPIPyoCCS
         4D7vcZpJJNDSTVE1SOqsmuds33MfytvQEuog0pvYgufNX3BVGmdgis+v8sI79awYsPzn
         ZwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737457657; x=1738062457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=60Ashbu4ZtB730+B8toAPEzMOd5yglkvbvpHZzMPLiA=;
        b=Cw8UWmN8co8QhT4Mks2q4wCiu0Cabp0FsbzdyryqjXXuBX8A/gUSqC5RGEVOy7kLsa
         W8RXS20ZlfOwA7JGVE0b20n3j97ZxUYFtVlb758iJ9puzEuj75c6+fZ5DY81qlviN3mw
         Lm2AaOhAAGUk57t96wWGloFSwdHEhLt68AwqPTn/fLmB/TuCwYQmy1K+nj/Bf/X6kOjd
         D7gJknw8kwqTii/LS/3wXEVMrabkk5NV937gk5bPTqxcvVjhIYmA3tND3s3Ji15/6M5Z
         NEDeL+ZnIlzVBjDIpsQEiVexE3Nn6zUydq9p2GQIEbUI5dm0LTfmVe/DYL6auKAKAG00
         bEOw==
X-Forwarded-Encrypted: i=1; AJvYcCVN66pHiOmaRIMrBVGioVMwXUIqPI64ZM/D/2GQfr2f9q719nSVe02+dEMNQlEU3TWN/jg=@vger.kernel.org, AJvYcCWgR7jgxHHxVRDck4ZwgluG+C9T/fAAIpExkAa0Pm2qvh2RSlafe5H/RBUAjlb3/4SsYtRdoFykZHc95hbB@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdd29p5PCLhdiapECyxOKKah1Bel5rlG9tf0eSzg27U5emf7zg
	2QH1b7JoRTektJI1jk2k44Fs+AbUbpNTMCaQ54baPCnNMEq3HY5DvaC7wkvfBeLOpQ2jw5uwn8S
	NcFSqN9l3m5fKO6QFfFe6Bh53O2A=
X-Gm-Gg: ASbGncuCpA0F/J9BrMU8HJ8bNd6OnbA719WxI93yI0nKcZlmJqEm3MuYMM9V1IBwKal
	o7tHJ1QNUG4jqRRG7Cl8LaFkvg/Q++XhvgUfI0r6FOTQFxRX7sMl7
X-Google-Smtp-Source: AGHT+IGfvSf6M09BR7JIfEFNdgUGqce6RjqixLfgBHLq9bhdbtl+V3VirJ8yDsw9FaoieXex25TM0s/LQYzvcbbzVys=
X-Received: by 2002:a05:600c:34c1:b0:438:a432:7c44 with SMTP id
 5b1f17b1804b1-438a4327dadmr84043775e9.21.1737457657322; Tue, 21 Jan 2025
 03:07:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117071423.469880-1-east.moutain.yang@gmail.com> <20250117084449.6cfd68b3.alex.williamson@redhat.com>
In-Reply-To: <20250117084449.6cfd68b3.alex.williamson@redhat.com>
From: Wencheng Yang <east.moutain.yang@gmail.com>
Date: Tue, 21 Jan 2025 19:07:26 +0800
X-Gm-Features: AbW1kvZ01xYCwDauLptJ25vIP6An_8SaX99fPIWpWTtZ1hVEn4fA8sNC_SMZJqM
Message-ID: <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
Subject: Re: [PATCH v2] drviers/iommu/amd: support P2P access through IOMMU
 when SME is enabled
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> This needs to:
>
>  - Be split into separate IOMMU vs VFIO patches
>  - Consider and consolidate with other IOMMU implementations of the same

I will do that in the next patch.

>  - Provide introspection to userspace relative to the availability of
>    the resulting mapping option
I don't get your meaning, can you expain in detail?

>
> It's also not clear to me that the user should be responsible for
> setting this flag versus something in the VFIO or IOMMU layer.  For
> example what are the implications of the user setting this flag
> incorrectly (not just failing to set it for MMIO, but using it for RAM)?

If user sets this flag to RAM region, it has no effect on the platform
that memory
encrytion is disable. If memory encrytion is enabled, then device
can't get correct
data from RAM, for example, CPU writes data to RAM that is encrypted by
memory controller, but device read the data from RAM as plaintext, but will
never leak confidential data.

Thanks,
Wencheng

On Fri, Jan 17, 2025 at 9:45=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Fri, 17 Jan 2025 15:14:18 +0800
> Wencheng Yang <east.moutain.yang@gmail.com> wrote:
>
> > When SME is enabled, memory encryption bit is set in IOMMU page table
> > pte entry, it works fine if the pfn of the pte entry is memory.
> > However, if the pfn is MMIO address, for example, map other device's mm=
io
> > space to its io page table, in such situation, setting memory encryptio=
n
> > bit in pte would cause P2P failure.
> >
> > Clear memory encryption bit in io page table if the mapping is MMIO
> > rather than memory.
> >
> > Signed-off-by: Wencheng Yang <east.moutain.yang@gmail.com>
> > ---
> >  drivers/iommu/amd/amd_iommu_types.h | 7 ++++---
> >  drivers/iommu/amd/io_pgtable.c      | 2 ++
> >  drivers/iommu/amd/io_pgtable_v2.c   | 5 ++++-
> >  drivers/iommu/amd/iommu.c           | 2 ++
> >  drivers/vfio/vfio_iommu_type1.c     | 4 +++-
> >  include/uapi/linux/vfio.h           | 1 +
> >  6 files changed, 16 insertions(+), 5 deletions(-)
>
> This needs to:
>
>  - Be split into separate IOMMU vs VFIO patches
>  - Consider and consolidate with other IOMMU implementations of the same
>  - Provide introspection to userspace relative to the availability of
>    the resulting mapping option
>
> It's also not clear to me that the user should be responsible for
> setting this flag versus something in the VFIO or IOMMU layer.  For
> example what are the implications of the user setting this flag
> incorrectly (not just failing to set it for MMIO, but using it for RAM)?

> Thanks,
>
> Alex
>
> >
> > diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/am=
d_iommu_types.h
> > index fdb0357e0bb9..b0f055200cf3 100644
> > --- a/drivers/iommu/amd/amd_iommu_types.h
> > +++ b/drivers/iommu/amd/amd_iommu_types.h
> > @@ -434,9 +434,10 @@
> >  #define IOMMU_PTE_PAGE(pte) (iommu_phys_to_virt((pte) & IOMMU_PAGE_MAS=
K))
> >  #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
> >
> > -#define IOMMU_PROT_MASK 0x03
> > -#define IOMMU_PROT_IR 0x01
> > -#define IOMMU_PROT_IW 0x02
> > +#define IOMMU_PROT_MASK 0x07
> > +#define IOMMU_PROT_IR   0x01
> > +#define IOMMU_PROT_IW   0x02
> > +#define IOMMU_PROT_MMIO 0x04
> >
> >  #define IOMMU_UNITY_MAP_FLAG_EXCL_RANGE      (1 << 2)
> >
> > diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgta=
ble.c
> > index f3399087859f..dff887958a56 100644
> > --- a/drivers/iommu/amd/io_pgtable.c
> > +++ b/drivers/iommu/amd/io_pgtable.c
> > @@ -373,6 +373,8 @@ static int iommu_v1_map_pages(struct io_pgtable_ops=
 *ops, unsigned long iova,
> >                       __pte |=3D IOMMU_PTE_IR;
> >               if (prot & IOMMU_PROT_IW)
> >                       __pte |=3D IOMMU_PTE_IW;
> > +             if (prot & IOMMU_PROT_MMIO)
> > +                     __pte =3D __sme_clr(__pte);
> >
> >               for (i =3D 0; i < count; ++i)
> >                       pte[i] =3D __pte;
> > diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_p=
gtable_v2.c
> > index c616de2c5926..55f969727dea 100644
> > --- a/drivers/iommu/amd/io_pgtable_v2.c
> > +++ b/drivers/iommu/amd/io_pgtable_v2.c
> > @@ -65,7 +65,10 @@ static u64 set_pte_attr(u64 paddr, u64 pg_size, int =
prot)
> >  {
> >       u64 pte;
> >
> > -     pte =3D __sme_set(paddr & PM_ADDR_MASK);
> > +     pte =3D paddr & PM_ADDR_MASK;
> > +     if (!(prot & IOMMU_PROT_MMIO))
> > +             pte =3D __sme_set(pte);
> > +
> >       pte |=3D IOMMU_PAGE_PRESENT | IOMMU_PAGE_USER;
> >       pte |=3D IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
> >
> > diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> > index 16f40b8000d7..9194ad681504 100644
> > --- a/drivers/iommu/amd/iommu.c
> > +++ b/drivers/iommu/amd/iommu.c
> > @@ -2578,6 +2578,8 @@ static int amd_iommu_map_pages(struct iommu_domai=
n *dom, unsigned long iova,
> >               prot |=3D IOMMU_PROT_IR;
> >       if (iommu_prot & IOMMU_WRITE)
> >               prot |=3D IOMMU_PROT_IW;
> > +     if (iommu_prot & IOMMU_MMIO)
> > +             prot |=3D IOMMU_PROT_MMIO;
> >
> >       if (ops->map_pages) {
> >               ret =3D ops->map_pages(ops, iova, paddr, pgsize,
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_=
type1.c
> > index 50ebc9593c9d..08be1ef8514b 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -1557,6 +1557,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iom=
mu,
> >               prot |=3D IOMMU_WRITE;
> >       if (map->flags & VFIO_DMA_MAP_FLAG_READ)
> >               prot |=3D IOMMU_READ;
> > +    if (map->flags & VFIO_DMA_MAP_FLAG_MMIO)
> > +        prot |=3D IOMMU_MMIO;
> >
> >       if ((prot && set_vaddr) || (!prot && !set_vaddr))
> >               return -EINVAL;
> > @@ -2801,7 +2803,7 @@ static int vfio_iommu_type1_map_dma(struct vfio_i=
ommu *iommu,
> >       struct vfio_iommu_type1_dma_map map;
> >       unsigned long minsz;
> >       uint32_t mask =3D VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRIT=
E |
> > -                     VFIO_DMA_MAP_FLAG_VADDR;
> > +                     VFIO_DMA_MAP_FLAG_VADDR | VFIO_DMA_MAP_FLAG_MMIO;
> >
> >       minsz =3D offsetofend(struct vfio_iommu_type1_dma_map, size);
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index c8dbf8219c4f..68002c8f1157 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -1560,6 +1560,7 @@ struct vfio_iommu_type1_dma_map {
> >  #define VFIO_DMA_MAP_FLAG_READ (1 << 0)              /* readable from =
device */
> >  #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)     /* writable from device *=
/
> >  #define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
> > +#define VFIO_DMA_MAP_FLAG_MMIO (1 << 3)     /* map of mmio */
> >       __u64   vaddr;                          /* Process virtual addres=
s */
> >       __u64   iova;                           /* IO virtual address */
> >       __u64   size;                           /* Size of mapping (bytes=
) */
>

