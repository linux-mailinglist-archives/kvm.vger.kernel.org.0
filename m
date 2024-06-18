Return-Path: <kvm+bounces-19887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8991E90DC20
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EEDE1F23A8E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D528615EFA1;
	Tue, 18 Jun 2024 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/1f0JKO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008AB15E5B5
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 19:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718737270; cv=none; b=g8VpBHbobXk778ivUReXfXYB6S5mIACaLYubB3xpGPPzYeXrrmE3AL5MF2WbM50b95bW0SvkoKRJ5/UyALNFDSE+e+/CBgt1Tg7uN1QFqk/ZFRj/SRIQPpSQFWhRMPduNuBwCq7CjfH6JsifrU/84jfT2QXSe1gvtT1D5LzPw0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718737270; c=relaxed/simple;
	bh=RZdzogOuc1kq4sjLYqFyUe9bGzfScwyKnQmviKovzjk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7UB57Q4g+xathkD7vhz7HtMxG2wTz1S79qWzWSyPXVgXHrvoOxYHE1WGbOC4w5Ml0SX4bqN249gtrMRp0uYd9UloJqWN6hGXnnP2BtA1ZvW4kJ/tc/ceNp2jLEIhxBg01/Roihnrs/seqeznuDt0M55VrJQHLk3huVAVtIGaqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/1f0JKO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718737266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iONNWsSJIhRiflyqzXYngvOSW75NSKM8t1pbHy6XOt8=;
	b=Z/1f0JKOsoWWb7M65o+0EU8vSnJyXbWU3yu1raAaI0+6KLcbFxaehkqQ+fHLgx83Bwz5K8
	gCUHIyRQ64grL/hH22oSxZm1LX2L6DhJOJnLYpkE3i4flkbCaOg+VsVAtGZhK3ep4RrcBu
	lp9X1HeiFdVcIB6jMXrOJ8In83omEN0=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-Z-5RPbAlMou0HXLwnw7I-A-1; Tue, 18 Jun 2024 15:01:04 -0400
X-MC-Unique: Z-5RPbAlMou0HXLwnw7I-A-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7eb73f0683cso718526339f.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 12:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718737263; x=1719342063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iONNWsSJIhRiflyqzXYngvOSW75NSKM8t1pbHy6XOt8=;
        b=pl4IrM1YwVVOwxyROd5mnjpLncdUNsRJjpa+8QH88lPxdbVhvJlMMg3hXEpE8viKK/
         HSifKEc6xsSCHlfNfFVJYWxK8QM7CnSN7CBKnGeKoN1megjnNPCFn6SVcMi53i1hmrbG
         Dx5FPlgh3yPmcIKOZIqj5LET73zyGCSs4X0I9lqHByrIxvbY0m95VW4Nv9jPchhOHFYf
         i6XaY3h977lCbRUKfMR+E040vX1B2xMDLCV8U3ZfkEXOv8eQTZm5DuqvY25VOfIlO1g/
         sbqKu0TgjAx/R6dbpSZXnRPK08S/Kqukn0q/97YmL8HGEYF1jbFvR6C89PakuZI7gDz/
         FBKw==
X-Forwarded-Encrypted: i=1; AJvYcCWY7Y3FV9HPa1FZ+QMBLQWGaqsQ3W4QDVN6066GmhSDVw2mXY5BaS8aGVcjQ124qJfAlQNAasEURJ+Mh9vu/GLhakQG
X-Gm-Message-State: AOJu0Yxb9LQl+PEouOMu4yc3vZ7WdOUgdgipG6qEu7FZgTU8y7LMMClf
	ts1QcViH1ylKoL10ucTPXx2KO5INebi1k/MJJv0rdwV2WPpcEQTX/3Aq4CBsumENBgo7n+KFksx
	1pctHWKZN5EzysrzTJDd8ocP2hOk4dwvRb0dpuRIeqYieqjWYQQ==
X-Received: by 2002:a05:6602:13ce:b0:7eb:8d08:e9de with SMTP id ca18e2360f4ac-7f13ee617f3mr87312939f.14.1718737263717;
        Tue, 18 Jun 2024 12:01:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt6/Yo+vizoGd9kpvkDUEN0YgXOl2lw7rJTfvjGTAnXaZt0xOJLqn58TmtgF3f7CbCJGzNrg==
X-Received: by 2002:a05:6602:13ce:b0:7eb:8d08:e9de with SMTP id ca18e2360f4ac-7f13ee617f3mr87309739f.14.1718737263284;
        Tue, 18 Jun 2024 12:01:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b95693f330sm3278327173.61.2024.06.18.12.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 12:01:02 -0700 (PDT)
Date: Tue, 18 Jun 2024 13:01:00 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>, Ramesh Thomas <ramesh.thomas@intel.com>,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, Ankit Agrawal
 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
 <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH v5 3/3] vfio/pci: Fix typo in macro to declare accessors
Message-ID: <20240618130100.4d7a901f.alex.williamson@redhat.com>
In-Reply-To: <162e40498e962258e965661b7ad8457e2e97ecdf.camel@linux.ibm.com>
References: <20240605160112.925957-1-gbayer@linux.ibm.com>
	<20240605160112.925957-4-gbayer@linux.ibm.com>
	<20240618112020.3e348767.alex.williamson@redhat.com>
	<162e40498e962258e965661b7ad8457e2e97ecdf.camel@linux.ibm.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Jun 2024 20:04:26 +0200
Gerd Bayer <gbayer@linux.ibm.com> wrote:

> On Tue, 2024-06-18 at 11:20 -0600, Alex Williamson wrote:
> > On Wed,=C2=A0 5 Jun 2024 18:01:12 +0200
> > Gerd Bayer <gbayer@linux.ibm.com> wrote:
> >  =20
> > > Correct spelling of DECLA[RA]TION =20
> >=20
> > But why did we also transfer the semicolon from the body of the macro
> > to the call site?=C2=A0 This doesn't match how we handle macros for
> > VFIO_IOWRITE, VFIO_IOREAD, or the new VFIO_IORDWR added in this
> > series.
> > Thanks,
> >=20
> > Alex =20
>=20
> Hi Alex,
>=20
> I wanted to make it visible, already in the contracted form, that
> VFIO_IO{READ|WRITE}_DECLARATION is in fact expanding to a function
> prototype declaration, while the marco defines in
> drivers/vfio/pci/vfio_pci_core.c expand to function implementations.
>=20
> My quick searching for in-tree precedence was pretty inconclusive
> though. So, I can revert that if you want.

Hi Gerd,

I'd tend to keep them as is since both are declaring something, a
prototype or a function, rather than a macro intended to be used
inline.  Ideally one macro could handle both declarations now that we
sort of have symmetry but we'd currently still need a #ifdef in the
macro which doesn't trivially work.  If we were to do something like
that though, relocating the semicolon doesn't make sense.

In any case, this proposal is stated as just a typo fix, but it's more.
Thanks,

Alex

> > > Suggested-by: Ramesh Thomas <ramesh.thomas@intel.com>
> > > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > > ---
> > > =C2=A0include/linux/vfio_pci_core.h | 24 ++++++++++++------------
> > > =C2=A01 file changed, 12 insertions(+), 12 deletions(-)
> > >=20
> > > diff --git a/include/linux/vfio_pci_core.h
> > > b/include/linux/vfio_pci_core.h
> > > index f4cf5fd2350c..fa59d40573f1 100644
> > > --- a/include/linux/vfio_pci_core.h
> > > +++ b/include/linux/vfio_pci_core.h
> > > @@ -139,26 +139,26 @@ bool
> > > vfio_pci_core_range_intersect_range(loff_t buf_start, size_t
> > > buf_cnt,
> > > =C2=A0					 loff_t *buf_offset,
> > > =C2=A0					 size_t *intersect_count,
> > > =C2=A0					 size_t *register_offset);
> > > -#define VFIO_IOWRITE_DECLATION(size) \
> > > +#define VFIO_IOWRITE_DECLARATION(size) \
> > > =C2=A0int vfio_pci_core_iowrite##size(struct vfio_pci_core_device
> > > *vdev,	\
> > > -			bool test_mem, u##size val, void __iomem
> > > *io);
> > > +			bool test_mem, u##size val, void __iomem
> > > *io)
> > > =C2=A0
> > > -VFIO_IOWRITE_DECLATION(8)
> > > -VFIO_IOWRITE_DECLATION(16)
> > > -VFIO_IOWRITE_DECLATION(32)
> > > +VFIO_IOWRITE_DECLARATION(8);
> > > +VFIO_IOWRITE_DECLARATION(16);
> > > +VFIO_IOWRITE_DECLARATION(32);
> > > =C2=A0#ifdef iowrite64
> > > -VFIO_IOWRITE_DECLATION(64)
> > > +VFIO_IOWRITE_DECLARATION(64);
> > > =C2=A0#endif
> > > =C2=A0
> > > -#define VFIO_IOREAD_DECLATION(size) \
> > > +#define VFIO_IOREAD_DECLARATION(size) \
> > > =C2=A0int vfio_pci_core_ioread##size(struct vfio_pci_core_device
> > > *vdev,	\
> > > -			bool test_mem, u##size *val, void __iomem
> > > *io);
> > > +			bool test_mem, u##size *val, void __iomem
> > > *io)
> > > =C2=A0
> > > -VFIO_IOREAD_DECLATION(8)
> > > -VFIO_IOREAD_DECLATION(16)
> > > -VFIO_IOREAD_DECLATION(32)
> > > +VFIO_IOREAD_DECLARATION(8);
> > > +VFIO_IOREAD_DECLARATION(16);
> > > +VFIO_IOREAD_DECLARATION(32);
> > > =C2=A0#ifdef ioread64
> > > -VFIO_IOREAD_DECLATION(64)
> > > +VFIO_IOREAD_DECLARATION(64);
> > > =C2=A0#endif
> > > =C2=A0
> > > =C2=A0#endif /* VFIO_PCI_CORE_H */ =20
> >=20
> >  =20
>=20


