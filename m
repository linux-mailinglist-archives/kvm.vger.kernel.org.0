Return-Path: <kvm+bounces-38580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF86A3C325
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 16:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B7CB189B4E5
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1521F419D;
	Wed, 19 Feb 2025 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DR65f3vj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED261F3BBF
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 15:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977700; cv=none; b=OQ/uYxDOo0NEulL3mqFL6DXUplaI8U9yWSWvBdmaFA0w55EWKSVkJByQqlua0aawrzsqevI7fxi3ejr45kOWoS4qSrk7NMMmtNgn5fqHZ496uQjBguyRMMUov49u7ewtfhGKGdkeiloDoz8aPhhp2oxaycCaM096joqCyb/c6qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977700; c=relaxed/simple;
	bh=nIlzcWPCpNDHeGWJ1Tv8gxxOpW0FShbKAlaQ3tpaGjo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTUxhVtL+TaIxkdgv3iIQ41lO+p4guKKlihQ3WdwNoFcaXWOvCD1Nm4Q2/A8MhiOgYdHC6Plr3oLONKfqslPu98G/PCRPH9ZqNYNw27tffpVPq+nqi/e0qqHGBu5Cjs8r6lmCV+cGBoNVZul6YX90BDJwgxCEEeJhH75ixs/A9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DR65f3vj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739977695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h0i0ytHqma4RDTIEIdZzYRA/ktw8J09sr28RqE6ASb0=;
	b=DR65f3vjWAsFAXNiRHmbvwqhcqjv+lGT1I0oEcFG0whmdE31bezQIk9kMs/UqCUJwtQM0K
	G27/5aLO/TB3X3z1vbW01C2SApN4t8fo7POGeyS5AbPo3FEINJIM3X6NmZ97bEE0MeuYky
	7Jwm1nTJtLS3K08UyRNr6B9R+/OSBsw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-be6BkeiePDK1LFuMNHlAkQ-1; Wed, 19 Feb 2025 10:08:14 -0500
X-MC-Unique: be6BkeiePDK1LFuMNHlAkQ-1
X-Mimecast-MFC-AGG-ID: be6BkeiePDK1LFuMNHlAkQ_1739977693
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d2a939f01bso1708355ab.1
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 07:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739977693; x=1740582493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h0i0ytHqma4RDTIEIdZzYRA/ktw8J09sr28RqE6ASb0=;
        b=nyBcu7lB1i6nlBPFMDnI5P0uRKN4L9R71KXuEgeLRIN7xw938yALCG/5tQnTxhIPFz
         pGet7m+Y52Rk/InNCg1EnLKBpMGWos4OR6gjiIfeYZ7+92PAALKYTOG5ScEzG7PlyoWN
         o6d/X81uSPlxWldeT6rxZwCOxvcc4xabcdjpNXWFC75X4o1W9+2pAdx0Iv+FSW6psbQ5
         fMa932MWj//OiTmtZkQS0uEkAba89UmQ10Axj0sHAgUOakg1kqLsI7RiTbVtXam6VJtJ
         +R063gfA1/LNuh1ZBC24R+RnTfoEz93MEvqrqwGBuHpB8IabUJSpuzTT39SBHwTeoOum
         IQXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNSzTx/8mt5uaEIZU+0Tia3QBbNIQ3wNVXCX491d9Mi50XdrWOjm0bqo3y7vWc+Fts9pM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCFh/G9Xb/M+acNkHIWl/+UcSZPH/Vt6H1PFQGyXDc0yyfWAaB
	TUQCrymqjmqztU2p2JVFs8NCcJ+YOOr8wwrnLNkQq5i2zmeeoPtGaGCi53hQnu1cMRvGXsnmiHX
	Y5ApJgwW99qR9zkGZdbJrkzAEBAJ9RbMkLvS2bbpgt+bGIPrfzQ==
X-Gm-Gg: ASbGncs0nIPmqBvjov05EqdUezxPlrfRwVJRnFFKcwENlTg5uZPSM9opE+IU34ytS8l
	KM4zv0/DM26eaqL8WW/x1rIx+YyVvBr0+uCSczTfXI+7jMwyb1OHSRWr3EgOCHGV8cst9UGFFkU
	80vplDU1+5rwgRatMVUU7nKRvaA1hmebX5ww6mPkw9fcP9wrNPfc3Hd4dW5lFa5m4+wf/2E2boJ
	/yMQutLJlmbs2U7HrUYxqvyh027AvADOFroBm+/nXTJy/tGfk8Lcp1mWHhi4WuygMT2BTBWItZU
	FhwC8OYF
X-Received: by 2002:a05:6602:2dd2:b0:855:a047:5f01 with SMTP id ca18e2360f4ac-855a0477cdfmr292673239f.3.1739977693171;
        Wed, 19 Feb 2025 07:08:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFewhjDw5FMQQv2E37ZGUyKeodB2Szx8gB5YrE4eo4YClIcD42Wt2wzkfld876dn+j1QGOjWQ==
X-Received: by 2002:a05:6602:2dd2:b0:855:a047:5f01 with SMTP id ca18e2360f4ac-855a0477cdfmr292671039f.3.1739977692599;
        Wed, 19 Feb 2025 07:08:12 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8559c37b07fsm108826239f.0.2025.02.19.07.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:08:10 -0800 (PST)
Date: Wed, 19 Feb 2025 08:08:08 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Mitchell Augustin <mitchell.augustin@canonical.com>
Cc: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, clg@redhat.com, jgg@nvidia.com,
 willy@infradead.org
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <20250219080808.0e22215c.alex.williamson@redhat.com>
In-Reply-To: <CAHTA-ua8mTgNkDs0g=_8gMyT1NkgZqCE0J7QjOU=+cmZ2xqd7Q@mail.gmail.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
	<20250218222209.1382449-7-alex.williamson@redhat.com>
	<Z7UOEpgH5pdTBcJP@x1.local>
	<20250218161407.6ae2b082.alex.williamson@redhat.com>
	<CAHTA-ua8mTgNkDs0g=_8gMyT1NkgZqCE0J7QjOU=+cmZ2xqd7Q@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Feb 2025 20:36:22 -0600
Mitchell Augustin <mitchell.augustin@canonical.com> wrote:

> /s/follow_pfnmap_args.pgmask/follow_pfnmap_args.addr_mask/ in v2
> commit log.

Thanks for spotting that, if there's no other cause for a re-spin I'll
fix that on commit.  Thanks for the review and testing!

Alex

> Aside from that, it works as expected.
>=20
> Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
> Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
>=20
>=20
> On Tue, Feb 18, 2025 at 5:14=E2=80=AFPM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Tue, 18 Feb 2025 17:47:46 -0500
> > Peter Xu <peterx@redhat.com> wrote:
> > =20
> > > On Tue, Feb 18, 2025 at 03:22:06PM -0700, Alex Williamson wrote: =20
> > > > vfio-pci supports huge_fault for PCI MMIO BARs and will insert pud =
and
> > > > pmd mappings for well aligned mappings.  follow_pfnmap_start() walk=
s the
> > > > page table and therefore knows the page mask of the level where the
> > > > address is found and returns this through follow_pfnmap_args.pgmask.
> > > > Subsequent pfns from this address until the end of the mapping page=
 are
> > > > necessarily consecutive.  Use this information to retrieve a range =
of
> > > > pfnmap pfns in a single pass.
> > > >
> > > > With optimal mappings and alignment on systems with 1GB pud and 4KB
> > > > page size, this reduces iterations for DMA mapping PCI BARs by a
> > > > factor of 256K.  In real world testing, the overhead of iterating
> > > > pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
> > > > sub-millisecond overhead.
> > > >
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > >  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++-------
> > > >  1 file changed, 16 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_io=
mmu_type1.c
> > > > index ce661f03f139..0ac56072af9f 100644
> > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch *=
batch)
> > > >
> > > >  static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_=
struct *mm,
> > > >                         unsigned long vaddr, unsigned long *pfn,
> > > > -                       bool write_fault)
> > > > +                       unsigned long *addr_mask, bool write_fault)
> > > >  {
> > > >     struct follow_pfnmap_args args =3D { .vma =3D vma, .address =3D=
 vaddr };
> > > >     int ret;
> > > > @@ -544,10 +544,12 @@ static int follow_fault_pfn(struct vm_area_st=
ruct *vma, struct mm_struct *mm,
> > > >                     return ret;
> > > >     }
> > > >
> > > > -   if (write_fault && !args.writable)
> > > > +   if (write_fault && !args.writable) {
> > > >             ret =3D -EFAULT;
> > > > -   else
> > > > +   } else {
> > > >             *pfn =3D args.pfn;
> > > > +           *addr_mask =3D args.addr_mask;
> > > > +   }
> > > >
> > > >     follow_pfnmap_end(&args);
> > > >     return ret;
> > > > @@ -590,15 +592,22 @@ static long vaddr_get_pfns(struct mm_struct *=
mm, unsigned long vaddr,
> > > >     vma =3D vma_lookup(mm, vaddr);
> > > >
> > > >     if (vma && vma->vm_flags & VM_PFNMAP) {
> > > > -           ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, prot & IO=
MMU_WRITE);
> > > > +           unsigned long addr_mask;
> > > > +
> > > > +           ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, &addr_mas=
k,
> > > > +                                  prot & IOMMU_WRITE);
> > > >             if (ret =3D=3D -EAGAIN)
> > > >                     goto retry;
> > > >
> > > >             if (!ret) {
> > > > -                   if (is_invalid_reserved_pfn(*pfn))
> > > > -                           ret =3D 1;
> > > > -                   else
> > > > +                   if (is_invalid_reserved_pfn(*pfn)) {
> > > > +                           unsigned long epfn;
> > > > +
> > > > +                           epfn =3D (*pfn | (~addr_mask >> PAGE_SH=
IFT)) + 1;
> > > > +                           ret =3D min_t(long, npages, epfn - *pfn=
); =20
> > >
> > > s/long/unsigned long/? =20
> >
> > ret is signed long since it's the function return and needs to be able
> > to return -errno, so long was the intention here.  Thanks,
> >
> > Alex
> > =20
> > > Reviewed-by: Peter Xu <peterx@redhat.com>
> > > =20
> > > > +                   } else {
> > > >                             ret =3D -EFAULT;
> > > > +                   }
> > > >             }
> > > >     }
> > > >  done:
> > > > --
> > > > 2.48.1
> > > > =20
> > > =20
> > =20
>=20
>=20
> --
> Mitchell Augustin
> Software Engineer - Ubuntu Partner Engineering
>=20


