Return-Path: <kvm+bounces-50913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD4FAEA95E
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B9F54E1B06
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73C7261365;
	Thu, 26 Jun 2025 22:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RhG6yrMv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EECA23B634
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 22:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750975833; cv=none; b=AuPmIh5/egrcP3+Q1Nbeia4OeZczzvP/jLri5uPvzW254eNvD77xNSVQrcrpjBHjqVv5kFnJt9QfnRLCCKRzbcT3kg3farlA5Y+iLs3+JRAkEYAnCSLSmX7Qad9o6FGxSnVYe8uRfMwj5cUE5tmcxx85dz1VLPgVhhtKzZacXjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750975833; c=relaxed/simple;
	bh=ggSirxR1drZ9XPlya+FuL7vbw55I9G/zrP21CglzSe4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ihFtWxapF512629k59jJM0ljGuL/n+lCo+XGTM0dl9bVQmLDUelnj9g+frilSEpWkbW1+0hweaCBrAvuy3CO+Ami+On0CZZvB5P4bed8kfWFEXFN8SC2aXhu2svu9ukdvINKZWLLTaoLHv3RAWqZNEu0p3Hy93OipT6ctHFyDWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RhG6yrMv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750975830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A2yDSqRpxx8M4NdtsCvKAVYY1i7sxWqZwfwf6PNsQv4=;
	b=RhG6yrMvwuhCJoRN7mzR8ICrtFG09LEc1259YcPEPlgZ1vIEQ4nmYI7T6VxX22J21TL6II
	ea7kCL/BVf/SdFKFXQ3uHYbXTomoNN25Lf0+/Id9SOuqS7B1Q5Y7P/0GvMPDSGx7HKifLm
	NiK0pysdAUtO6pt0Jd6+SuVklOqtm+Q=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-xNs2sVbjOaGYZPJRqAGL0A-1; Thu, 26 Jun 2025 18:10:28 -0400
X-MC-Unique: xNs2sVbjOaGYZPJRqAGL0A-1
X-Mimecast-MFC-AGG-ID: xNs2sVbjOaGYZPJRqAGL0A_1750975828
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86cff09d29dso29353939f.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 15:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750975828; x=1751580628;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A2yDSqRpxx8M4NdtsCvKAVYY1i7sxWqZwfwf6PNsQv4=;
        b=juteYCdDH+Vd/3tqQUmiYkQ2jwocWlM79AcrDqC0RHjIVxz/dl4qdldPcEwSYgGocB
         /ULmgKhgkrU+aQqEk1HgtNUluchl/uheRh+fILUnq6QxpsFm193RUlm76FFZFTM13Y2c
         tFaoNX2JXq69y6ZEzcOP3jG07AvkhweJyC1aOXRveaXTP4K46vJnLwxe6UTfpgfZuWYE
         iQt6Gfpt7KJ4ZTpyIFAYxg6Eruv6XkBWAQhGPFYUXLXxjukQ5g5sThEbw6swJ6mSCvGN
         ZRgAmTRfdPFg1b+CpytnyiHL5fClyFp85+WDWwocAlBTqvw82PjDOuc89N4ovyZ2IN7Z
         f58w==
X-Forwarded-Encrypted: i=1; AJvYcCXRxjHGU9ZBWkqzAXdzwn1u2e7ZHi8/76xEKOmTK9lhoqWKsJfLiIbwEE9a+Fd95ZGy21M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhLcT5fLCrZXU+vlXp796FtimikNbXlMI53H3N029Q5kzwtOVX
	u5G0sbJHjfIuQUK48woLK2U1mGUpSchDV6WHx78pJvCiPPu82gbpSaJFI5GDJPXUIWY7pUI+UK1
	UBGiDZI2LNiIbpCtfEfSZ46bzONwGdBfNnNabyxL10CXsTTDcJXKJQw==
X-Gm-Gg: ASbGncs/JHp60p1c0HHCmFDGUjf9dGlcfFq/N1nT7JS78FQFYbwjBDyjfNT5mrs3e4I
	u5mXbV3W3bVu1IW8tYRWlbWKKnIecVG4o19Snz5tjvoXo9DWR9/WQNtMV5JUhSHdeIPDgFQcZAu
	jjoPzLqNGzMhiuT/DS5/OzJOiamPFpgCaT4zbUh98kaP643Kzaund9zZZZSaQR+flm2ocIoUxp/
	tEa1PNPggjEcPAvzifG1cx3dxj/01MZ0KRNAWiG5HiPJGnwVhFr75F1+lKCGBXg9xddKkDMtFjD
	u+H3TmQoS9WZDJnvFUAPlIWi9g==
X-Received: by 2002:a05:6e02:3804:b0:3dd:ba33:be80 with SMTP id e9e14a558f8ab-3df4aba855fmr4629535ab.4.1750975828049;
        Thu, 26 Jun 2025 15:10:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDoE0TlTM0qzwfE3zrVHD12SB2JExgfCv/r6GbE0jkmdkz74Z39BQxLxcfQe+RznzbpQ27yg==
X-Received: by 2002:a05:6e02:3804:b0:3dd:ba33:be80 with SMTP id e9e14a558f8ab-3df4aba855fmr4629365ab.4.1750975827556;
        Thu, 26 Jun 2025 15:10:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50204adc2b1sm185252173.134.2025.06.26.15.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 15:10:26 -0700 (PDT)
Date: Thu, 26 Jun 2025 16:10:25 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, bhelgaas@google.com,
 dmatlack@google.com, vipinsh@google.com, kvm@vger.kernel.org,
 seanjc@google.com, jrhilke@google.com
Subject: Re: [RFC PATCH 0/3] vfio: selftests: Add VFIO selftest to
 demontrate a latency issue
Message-ID: <20250626161025.7c407e70.alex.williamson@redhat.com>
In-Reply-To: <CAAAPnDHa249E381EYjaJUna4N_EsY2AiBcqMEtcuy-raJxgpXw@mail.gmail.com>
References: <20250626180424.632628-1-aaronlewis@google.com>
	<20250626132659.62178b7d.alex.williamson@redhat.com>
	<20250626205608.GO167785@nvidia.com>
	<CAAAPnDHa249E381EYjaJUna4N_EsY2AiBcqMEtcuy-raJxgpXw@mail.gmail.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jun 2025 14:58:54 -0700
Aaron Lewis <aaronlewis@google.com> wrote:

> On Thu, Jun 26, 2025 at 1:56=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> =
wrote:
> >
> > On Thu, Jun 26, 2025 at 01:26:59PM -0600, Alex Williamson wrote: =20
> > > On Thu, 26 Jun 2025 18:04:21 +0000
> > > Aaron Lewis <aaronlewis@google.com> wrote:
> > > =20
> > > > This series is being sent as an RFC to help brainstorm the best way=
 to
> > > > fix a latency issue it uncovers.
> > > >
> > > > The crux of the issue is that when initializing multiple VFs from t=
he
> > > > same PF the devices are reset serially rather than in parallel
> > > > regardless if they are initialized from different threads.  That ha=
ppens
> > > > because a shared lock is acquired when vfio_df_ioctl_bind_iommufd()=
 is
> > > > called, then a FLR (function level reset) is done which takes 100ms=
 to
> > > > complete.  That in combination with trying to initialize many devic=
es at
> > > > the same time results in a lot of wasted time.
> > > >
> > > > While the PCI spec does specify that a FLR requires 100ms to ensure=
 it
> > > > has time to complete, I don't see anything indicating that other VFs
> > > > can't be reset at the same time.
> > > >
> > > > A couple of ideas on how to approach a fix are:
> > > >
> > > >   1. See if the lock preventing the second thread from making forwa=
rd
> > > >   progress can be sharded to only include the VF it protects. =20
> > >
> > > I think we're talking about the dev_set mutex here, right?  I think t=
his
> > > is just an oversight.  The original lock that dev_set replaced was
> > > devised to manage the set of devices affected by the same bus or slot
> > > reset.  I believe we've held the same semantics though and VFs just
> > > happen to fall through to the default of a bus-based dev_set.
> > > Obviously we cannot do a bus or slot reset of a VF, we only have FLR,
> > > and it especially doesn't make sense that VFs on the same "bus" from
> > > different PFs share this mutex. =20
> >
> > It certainly could be.. But I am feeling a bit wary and would want to
> > check this carefully. We ended up using the devset for more things -
> > need to check where everything ended up.
> >
> > Off hand I don't recall any reason why the VF should be part of the
> > dev set..
> > =20
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio=
_pci_core.c
> > > index 6328c3a05bcd..261a6dc5a5fc 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_p=
ci_core_device *vdev)
> > >               return -EBUSY;
> > >       }
> > >
> > > -     if (pci_is_root_bus(pdev->bus)) {
> > > +     if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) { =20
>=20
> That fixes the issue.  I applied this patch and reran the test and
> both threads finish in ~100ms now!  We are now getting fully
> parallelized resets!
>=20
> [0x7fd12afc0700] '0000:17:0c.2' initialized in 102.3ms.
> [0x7fd12b7c1700] '0000:17:0c.1' initialized in 102.4ms.
>=20
> > >               ret =3D vfio_assign_device_set(&vdev->vdev, vdev);
> > >       } else if (!pci_probe_reset_slot(pdev->slot)) {
> > >               ret =3D vfio_assign_device_set(&vdev->vdev, pdev->slot);
> > >
> > > Does that allow fully parallelized resets? =20
> >
> > I forget all the details but if we are sure the reset of a VF is only
> > the VF then that does seem like the right direction
> >
> > Jason =20
>=20
> Alex, would you like me to include your patch in this series so we
> have the fix and test together, or would you prefer to propose the fix
> yourself?  Either way works for me.

I think it's best not to queue the fix behind the selftests when
there's no code dependency.  I'll send out the patch and hopefully
Jason can chew on whether I'm overlooking something.  This mutex has
basically become our defacto serialization mutex, but I think that hot
reset remains the only multi-device serialization problem.  Thanks,

Alex


