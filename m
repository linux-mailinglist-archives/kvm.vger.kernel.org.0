Return-Path: <kvm+bounces-27708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3E498AF15
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 23:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0D25B24125
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 21:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48ADF1A2851;
	Mon, 30 Sep 2024 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WzcvG1R0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE59B1A2566
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727731666; cv=none; b=ea3aJt1GThun95iYSU9ZA6guhgKjEPw+l+S3FsjNEIJMygt9UyJNChASIxXZdqgMh8q0/EWNeKO8mkjBw4J2Tu5uzUKnsMS7w/94QG9Qsl5mQBW2a9KV0JRjonyYNTm7uJHNQUpYsbPPX1AJBFiEudvQfRS8lOEU9Olp86U9BOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727731666; c=relaxed/simple;
	bh=3M8h7q9Pxa+KqWk46f6MFbZxx801ltg9CgK8WSTwKU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzhNcbD8z4BoyJLydGat/TeAAk5Bj9tgbA8ngEXRL7YFmhQ86KDVx61h4VNW5YHOuvYTpN3J8tyjgz4jbvFgmihDlx0zVaDfZBTyn34ulC6PFeR7z9qcYPodluGauaZcZtTLjNOefAX4gwCVK2+vW+tGHUKy/o2ueKWGOSUP1RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WzcvG1R0; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-84ea658b647so1420018241.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 14:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727731663; x=1728336463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FdW//+Tr0a+ne7swPURE2HA/J0aJVeP59/NQKu0ikls=;
        b=WzcvG1R0j1HS91T2LHmaqJMwP+CEIQ6wQjtWiOgZlr5Jcn89ycR6TR8XzaCy7Io5qF
         D5GMoZchSXS4HZkQViIxPADHCd+pYxbay0t2RGV9BcfT7tLUBHgZDEow8tqNgGXYU1at
         WGgWoPT7xl/OZDOG+7ze6tdjJdHl9wW5UQLBFiAmqkxzSzIfcnWspcIMxvivrJ8GPpfB
         4xTtYode6/+QOROI+5luo+wWQUYMje+nJY7HgcO3EIaDkJ6Qh6xWjp7NmG7/NSqAEQMF
         nBGVKrMKcl88eG2WCA/dphCNMCYqS0TIo/aShx5G/5sauX7uM2vFSiJm25a2jzctCn9S
         3zDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727731663; x=1728336463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FdW//+Tr0a+ne7swPURE2HA/J0aJVeP59/NQKu0ikls=;
        b=HLIeUz2vfp9TEHAE9NtZDQkcOekeOFKP8i7hEq46dXMrfVd/PokA/l33Y1lOBVJnY4
         FGFvFn5WOKbWd8ADPxHx77Z2hzwFeIOGCFIC3ZP6z8Ol5YHvtGY+lkfmPtR71lz7tx30
         RYMqVRfeKm0+WwRfNoowln5xnKNfth1x76GtIJp085dKSArhXnZnu7c97b+QUqiHBTgS
         7943JOGLrUUX4mf+q4EELGvuDg7qlsP/0QdQyGcjYFsxv3uq9t21wKh6dzZfuy9yvmHY
         A3jK/ONZ9gQWyn+pudSUeyMYVFy9cxV3Ss1cWoTM/ddQnuDNtL7bqCecN7iCU93nPHJe
         Fx2g==
X-Gm-Message-State: AOJu0YxCio8TKOVqMdLH0qMQ5xNaWT7nOVUkAevgD8mApS5SSCNdfuNR
	JdKlsGUNAUVrkbDXQSbiXJugsv5XtlBvXWB/MxyCapBcndIDjXjeGzsGR3akT5hQI7bw5m9337E
	qBKfg/P+FZOgQB4mcs/7bA2vimQU=
X-Google-Smtp-Source: AGHT+IHlsMoe8BB6gp/9qJg4t9ZOr5LVIJbfii/Iw6VyG5Ul3OWGEinqe20k/GGPUWIkASccQApdVUDv9fToctSFRmI=
X-Received: by 2002:a05:6122:3105:b0:4f2:a974:29e5 with SMTP id
 71dfb90a1353d-507816b9ccamr8712022e0c.1.1727731663443; Mon, 30 Sep 2024
 14:27:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACcEcgQq_yxvjAo7BticTw6ne8S2uUjbCFxPTnWHT24oMkxf=w@mail.gmail.com>
 <e3680d93-0463-42d6-be13-03dd90bb0d8a@intel.com>
In-Reply-To: <e3680d93-0463-42d6-be13-03dd90bb0d8a@intel.com>
From: Michael Williamson <mike.a.williamson@gmail.com>
Date: Mon, 30 Sep 2024 17:27:33 -0400
Message-ID: <CACcEcgTuhgX5RYCCCwU+sWS7iGKUVpGQkFGdh8yWyTVxoU=fiw@mail.gmail.com>
Subject: Re: Supporting VFIO on nVidia's Orin platform
To: Yi Liu <yi.l.liu@intel.com>
Cc: kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Nicolin Chen <nicolinc@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 12:00=E2=80=AFAM Yi Liu <yi.l.liu@intel.com> wrote:
>
> On 2024/9/29 23:02, Michael Williamson wrote:
> > Hello,
> >
> > I've been trying to get VFIO working on nVidia's Orin platform (ARM64) =
in
> > order to support moving data efficiently off of an attached FPGA PCIe b=
oard
> > using the SMMU from a user space application.  We have a full applicati=
on
> > working on x86/x64 boxes that properly support the VFIO interface.  We'=
re
> > trying to port support to the Orin.
> >
> > I'm on nVidia's 5.15.36 branch.  It doesn't work out of the box, as the
> > tegra194-pcie platform controller is lumped in the same iommu group as =
the
> > actual PCIe card.  The acs override patch didn't help to separate them.
> >
> > I have a patch below that *seems* to work for us, but I will admit I do=
 not
> > know the implications of what I am doing here.
>
> your below patch is to pass the vfio_dev_viable() check I suppose. If you

yes.

> are sure the tegra194-pcie platform controller will not issue DMA, then i=
t
> is fine. If not, you should be careful about it.
>

There are multiple tegra194-pcie platform controllers defined in the dts.  =
This
one only has the one PCIe slot we are working with and nothing else.  There
are other instances of the tegra194-pcie controllers that have control over
other PCIe devices in the system.  There appear to be two main smmu control=
lers
that support multiple masters.  The tegra194-pcie platform controller tied
to the PCIe bus I want has a unique smmu/iommu master ID but is sharing the=
 main
smmu controller with other devices.  However, they are all assigned to
different iommu groups, so I think this is OK?

> > Can anyone let me know if this is (and why it is) a bad idea, and what =
really
> > needs to be done?  Or if this is the wrong mailing list, point me in th=
e right
> > direction?
>
> this is the right place to ask. +NV folks I know.
>

I appreciate the insight.  Thank you.

> > Thanks,
> > Mike
> >
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 818e47fc0896..a598a2204781 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -638,8 +638,15 @@ static struct vfio_device
> > *vfio_group_get_device(struct vfio_group *group,
> >    * breaks anything, it only does so for user owned devices downstream=
.  Note
> >    * that error notification via MSI can be affected for platforms that=
 handle
> >    * MSI within the same IOVA space as DMA.
> > + *
> > + * [MAW] - the tegra194-pcie driver is a platform PCie device controll=
er and
> > + * fails the dev_is_pci() check below.  Not sure if it's because its g=
rouping
> > + * needs to be reworked, but I don't know how this is (or if it
> > should be) done.
> > + * This is a hack to see if we can get it going well enough to use the
> > + * SMMU from user space.  The other two devices (for the Orin) in the =
group
> > + * are the host bridge and the PCIe card itself.
> >    */
> > -static const char * const vfio_driver_allowed[] =3D { "pci-stub" };
> > +static const char * const vfio_driver_allowed[] =3D { "pci-stub",
> > "tegra194-pcie" };
> >
> >   static bool vfio_dev_driver_allowed(struct device *dev,
> >                                      struct device_driver *drv)
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_=
type1.c
> > index 66bbb125d761..e34fbe17ae1a 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -45,7 +45,8 @@
> >   #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>=
"
> >   #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
> >
> > -static bool allow_unsafe_interrupts;
> > +/** [MAW] - hack, need this set for Orin test, not compiled is module
> > currently */
> > +static bool allow_unsafe_interrupts =3D true;
> >   module_param_named(allow_unsafe_interrupts,
> >                     allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> >   MODULE_PARM_DESC(allow_unsafe_interrupts,
> > @@ -1733,8 +1734,18 @@ static int vfio_bus_type(struct device *dev, voi=
d *data)
> >   {
> >          struct bus_type **bus =3D data;
> >
> > -       if (*bus && *bus !=3D dev->bus)
> > +       /**
> > +        * [MAW] - hack.  the orin tegra194-pcie is in this group and
> > +        * reports in as bus-type of "platform".  We will ignore it
> > +        * in an attempt to get vfio to play along.
> > +        */
> > +       if (!strcmp(dev->bus->name,"platform")) {
> > +               return 0;
> > +       }
> > +
> > +       if (*bus && *bus !=3D dev->bus) {
> >                  return -EINVAL;
> > +       }
> >
> >          *bus =3D dev->bus;
> >
>
> --
> Regards,
> Yi Liu



--=20
Mike Williamson
OpenPGP Public Key

