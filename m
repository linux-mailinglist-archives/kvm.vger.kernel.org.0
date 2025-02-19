Return-Path: <kvm+bounces-38593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11866A3C9FD
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 840513BBE9A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA89023C388;
	Wed, 19 Feb 2025 20:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="VjhdojLL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFCF22F167
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739997178; cv=none; b=Y5fHFrdIaCs10sLKb81/6+5D1zminDjXXK4ggiZxt609HC7OpoB9ewU3EgZsxxNfFtesCwbD1ltLc5mC+NQo7vpQeuJRDSkP3N+F8bd5aMs2zdbzZBjr8Ss7h6LMdQZuKsA0gIPeuHbB7Z90BHiAI6oDReOzfJiwxF2v0ow/YJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739997178; c=relaxed/simple;
	bh=vvk+AdM4vt9tKMhqg5D0XuqAML5DgtxedDKIhoqmiro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=poAR062ptv7dnyCySGjfVm38eyMNUNBterma9Zh5a/c+Hwr3UNgvC0Ij7DijQBDMX5QdbVzZR+vK/Clcp9dhfxjNFKlMor90wdf9SScLGON2InVQid5TshDtSo13OPnjTfWK+w1XDMbzDhmNo+VXYeQtRnwigNU8A0aeAqHvPh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=VjhdojLL; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 86DFE3F2C7
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 20:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1739997167;
	bh=xFP8oLpfyz9SCRbb3oTVySdSbCN+UfrmsGZ/3z62Kgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=VjhdojLL1HIzHxO9900aJ/k1ik5vxVkTblziizp4DkuIA1nZ1Kys1xoHlLHV7iDRz
	 E2tX6dD3jV7sVX7P8N9tiKjDaqk2MmdY/8TPRwWj/sw+kKn15GyJMzQx/ocSHgFfnA
	 0A+U4F5cUVJAJdXP5NuzjL9bM0eiwlft4gKYirGEJ3ioyY+k4zKbSNIMfVaPzLCrfG
	 6vu4D3eUnUmQeKurzPppU/dKsJmiu7hK715IJQgG7lEEM//Qd2n20SlACC6DVWX5RQ
	 d+GLt1V2/VXv2VFt2e+uOROgn56Mby4lsVMOf9dq78BZwQg/c+cdPeyjS9KApEJgNS
	 fN9LMw/vYXcTg==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5daa661ec3dso119580a12.3
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 12:32:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739997167; x=1740601967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFP8oLpfyz9SCRbb3oTVySdSbCN+UfrmsGZ/3z62Kgg=;
        b=R5asqNuanSKGts2qmBQHwxjj1BPtyJ6DeXVQlD2k6pSyiPY/6VLJ9pYb8VwDq31beP
         qcbtP57VRgzSDdEp7TmV5Mz7BEBrzUiTU59ThO0N976S3b7WM7Kqcz4HwptBE4gDZDjC
         GEHyeKS+1N3/Lr46A0viu7jez01L2pD13Yu0Uvu3ahOJrmWqPU5zRIoeo8oo7a1gCGR8
         EVG5I7dTBFRoe9pjV6e3BeghSo5TlvUSaytwZOqaNP+R08E53BTJu9xatVlui3R10tzU
         hpKOwxiiaqH5v61SEIyGWwiCudJl/rn1n6uMz+C08Z9Hb6y0+abwMvysazpMvgpuLChf
         quqw==
X-Forwarded-Encrypted: i=1; AJvYcCVHWOErT9sqlzayDipbdq1RTiMwIitOEux9bkKVqQsjtT7XA8HL9QXNhMESvq036iYyS6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaJJm212GKfs4d8Wcj/ehvRQp2hZ7SndckmgDykWsncauOgI+0
	4aXr7oepLqjThH2bqW8hg9nMTHGWGcmIlEdl744geH9gCFLuOne+nAgaeUYIUlYXxLpL6YbQu8J
	YyV9zBa51vvckgJCtGtUWgDcvoMHOnYcfVvPStIO89cIoAl/l+4qb8LE/HszJwPcxFkrcg636eB
	NKX1Rsfumb53e6l//JS+NpGhFJndIeqc4DFSFKgktg
X-Gm-Gg: ASbGnctsXwmJ6xZH1oLhGEC0ygqrZ9oAlhmxaHdgMeMdnvDVq81UciCbQz3rQSE+/pk
	uhHVwh0BYVo+vXJS6/vuftrfRnY7oVIu423iJiAvsCVFyN+sBx/2qHl9Fp52Z
X-Received: by 2002:a05:6402:3506:b0:5e0:8b68:94a2 with SMTP id 4fb4d7f45d1cf-5e08b689680mr3713935a12.14.1739997166759;
        Wed, 19 Feb 2025 12:32:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKtH6+f6L2nxcMslXOaM66izZ0LxjlrBRHiN0KiuAZdxw04Ao9z+jcqOIKrM1PHM0hMJHtmwlLcqptaNiDRKA=
X-Received: by 2002:a05:6402:3506:b0:5e0:8b68:94a2 with SMTP id
 4fb4d7f45d1cf-5e08b689680mr3713914a12.14.1739997166395; Wed, 19 Feb 2025
 12:32:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-7-alex.williamson@redhat.com> <Z7UOEpgH5pdTBcJP@x1.local>
 <20250218161407.6ae2b082.alex.williamson@redhat.com> <CAHTA-ua8mTgNkDs0g=_8gMyT1NkgZqCE0J7QjOU=+cmZ2xqd7Q@mail.gmail.com>
 <20250219080808.0e22215c.alex.williamson@redhat.com>
In-Reply-To: <20250219080808.0e22215c.alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Wed, 19 Feb 2025 14:32:35 -0600
X-Gm-Features: AWEUYZkNrqeSRPk2dMwchTS7IsyHy1tjCAS0voQFiVDUY9YB0_CFzqovwj_O_Fs
Message-ID: <CAHTA-ubiguHnrQQH7uML30LsVc+wk-b=zTCioVTs3368eWkmeg@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	clg@redhat.com, jgg@nvidia.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Thanks for the review and testing!

Sure thing, thanks for the patch set!

If you happen to have a few minutes, I'm struggling to understand the
epfn computation and would appreciate some insight.

My current understanding (very possibly incorrect):
- epfn is intended to be the last page frame number that can be
represented at the mapping level corresponding to addr_mask. (so, if
addr_mask =3D=3D PUD_MASK, epfn would be the highest pfn still in PUD
level).
- ret should be =3D=3D npages if all pfns in the requested vma are within
the memory hierarchy level denoted by addr_mask. If npages is more
than can be represented at that level, ret =3D=3D the max number of page
frames representable at addr_mask level.
- - (if the second case is true, that means we were not able to obtain
all requested pages due to running out of PFNs at the current mapping
level)

If the above is all correct, what is confusing me is where the "(*pfn)
| " comes into this equation. If epfn is meant to be the last pfn
representable at addr_mask level of the hierarchy, wouldn't that be
represented by (~pgmask >> PAGE_SHIFT) alone?

Thanks in advance,
Mitchell Augustin

On Wed, Feb 19, 2025 at 9:08=E2=80=AFAM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 18 Feb 2025 20:36:22 -0600
> Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
>
> > /s/follow_pfnmap_args.pgmask/follow_pfnmap_args.addr_mask/ in v2
> > commit log.
>
> Thanks for spotting that, if there's no other cause for a re-spin I'll
> fix that on commit.  Thanks for the review and testing!
>
> Alex
>
> > Aside from that, it works as expected.
> >
> > Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
> > Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
> >
> >
> > On Tue, Feb 18, 2025 at 5:14=E2=80=AFPM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > On Tue, 18 Feb 2025 17:47:46 -0500
> > > Peter Xu <peterx@redhat.com> wrote:
> > >
> > > > On Tue, Feb 18, 2025 at 03:22:06PM -0700, Alex Williamson wrote:
> > > > > vfio-pci supports huge_fault for PCI MMIO BARs and will insert pu=
d and
> > > > > pmd mappings for well aligned mappings.  follow_pfnmap_start() wa=
lks the
> > > > > page table and therefore knows the page mask of the level where t=
he
> > > > > address is found and returns this through follow_pfnmap_args.pgma=
sk.
> > > > > Subsequent pfns from this address until the end of the mapping pa=
ge are
> > > > > necessarily consecutive.  Use this information to retrieve a rang=
e of
> > > > > pfnmap pfns in a single pass.
> > > > >
> > > > > With optimal mappings and alignment on systems with 1GB pud and 4=
KB
> > > > > page size, this reduces iterations for DMA mapping PCI BARs by a
> > > > > factor of 256K.  In real world testing, the overhead of iterating
> > > > > pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
> > > > > sub-millisecond overhead.
> > > > >
> > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > ---
> > > > >  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++-------
> > > > >  1 file changed, 16 insertions(+), 7 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_=
iommu_type1.c
> > > > > index ce661f03f139..0ac56072af9f 100644
> > > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > > @@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch=
 *batch)
> > > > >
> > > > >  static int follow_fault_pfn(struct vm_area_struct *vma, struct m=
m_struct *mm,
> > > > >                         unsigned long vaddr, unsigned long *pfn,
> > > > > -                       bool write_fault)
> > > > > +                       unsigned long *addr_mask, bool write_faul=
t)
> > > > >  {
> > > > >     struct follow_pfnmap_args args =3D { .vma =3D vma, .address =
=3D vaddr };
> > > > >     int ret;
> > > > > @@ -544,10 +544,12 @@ static int follow_fault_pfn(struct vm_area_=
struct *vma, struct mm_struct *mm,
> > > > >                     return ret;
> > > > >     }
> > > > >
> > > > > -   if (write_fault && !args.writable)
> > > > > +   if (write_fault && !args.writable) {
> > > > >             ret =3D -EFAULT;
> > > > > -   else
> > > > > +   } else {
> > > > >             *pfn =3D args.pfn;
> > > > > +           *addr_mask =3D args.addr_mask;
> > > > > +   }
> > > > >
> > > > >     follow_pfnmap_end(&args);
> > > > >     return ret;
> > > > > @@ -590,15 +592,22 @@ static long vaddr_get_pfns(struct mm_struct=
 *mm, unsigned long vaddr,
> > > > >     vma =3D vma_lookup(mm, vaddr);
> > > > >
> > > > >     if (vma && vma->vm_flags & VM_PFNMAP) {
> > > > > -           ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, prot & =
IOMMU_WRITE);
> > > > > +           unsigned long addr_mask;
> > > > > +
> > > > > +           ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, &addr_m=
ask,
> > > > > +                                  prot & IOMMU_WRITE);
> > > > >             if (ret =3D=3D -EAGAIN)
> > > > >                     goto retry;
> > > > >
> > > > >             if (!ret) {
> > > > > -                   if (is_invalid_reserved_pfn(*pfn))
> > > > > -                           ret =3D 1;
> > > > > -                   else
> > > > > +                   if (is_invalid_reserved_pfn(*pfn)) {
> > > > > +                           unsigned long epfn;
> > > > > +
> > > > > +                           epfn =3D (*pfn | (~addr_mask >> PAGE_=
SHIFT)) + 1;
> > > > > +                           ret =3D min_t(long, npages, epfn - *p=
fn);
> > > >
> > > > s/long/unsigned long/?
> > >
> > > ret is signed long since it's the function return and needs to be abl=
e
> > > to return -errno, so long was the intention here.  Thanks,
> > >
> > > Alex
> > >
> > > > Reviewed-by: Peter Xu <peterx@redhat.com>
> > > >
> > > > > +                   } else {
> > > > >                             ret =3D -EFAULT;
> > > > > +                   }
> > > > >             }
> > > > >     }
> > > > >  done:
> > > > > --
> > > > > 2.48.1
> > > > >
> > > >
> > >
> >
> >
> > --
> > Mitchell Augustin
> > Software Engineer - Ubuntu Partner Engineering
> >
>


--=20
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

