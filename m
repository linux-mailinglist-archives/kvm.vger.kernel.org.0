Return-Path: <kvm+bounces-31536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC079C4864
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 22:45:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E92A5B22FC8
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 21:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739AF1B4F07;
	Mon, 11 Nov 2024 21:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcNx3Pq1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9EA165F1D
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 21:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731360463; cv=none; b=M8ZIg33fMHw/5ToEVIoXBYGe1pwI+2WuvLCMxkvMJMCFBcMg3A44vt+7wkaf/hAwB3ZJMot6YYf5s/WwNTH04UPTllV7Cu4YCQGIoPdFcoAElpO3C+iohcHUIAkub2x8b2GRhkK4AUnMHnobcWhLE3q5sxjBg+wCfuJBfShbmp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731360463; c=relaxed/simple;
	bh=7gdx99zZFTJV7kjMusQaB+ZZVp3XgQyK/up+geK19Jw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R+uEMJ2BmSzuAZh4k3KtgUl4d15HUG/OaU7m+RhImnHjFQ7wGl8GkTGXbc/cKNjRdjVi0qQoX2IpZI9vFQl3Odn1TaCZrZWuTgapGq7Q4euXAvaw8vNDRhdO60Hr0ZeiZJUsWjwM7+dZJwMxqVyriWdMN54macjEa3XTAWEsOS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcNx3Pq1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731360460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKTzfUrxnVHXdTB3XXfquz3VdrDTYaHm0nfSYpXbJms=;
	b=fcNx3Pq111oEUf7zEXsHHRUker2VfkXB8TYrtrU5OM3Kwu71MglZx4WCjfW77VmMXkqSD4
	RcCDVabyx6oo8oyuaBA9Q4sXYK5QExPF0gRuBUJ3SLCKTL0Z57uuFWQzUlpBuc0fsS0JRk
	XA08LMPzz4m8ZKuZiYzTQEa1dEO6TkM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-HIaLJBBfOTu28V4ViX5G6A-1; Mon, 11 Nov 2024 16:27:39 -0500
X-MC-Unique: HIaLJBBfOTu28V4ViX5G6A-1
X-Mimecast-MFC-AGG-ID: HIaLJBBfOTu28V4ViX5G6A
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83ba5dcee51so25047339f.1
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 13:27:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731360458; x=1731965258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKTzfUrxnVHXdTB3XXfquz3VdrDTYaHm0nfSYpXbJms=;
        b=uHLCrKeIdxmYzKosM4IzFr6PtuUIxEz3OI/MjPncE9RAf8FOVzXfWtZrHMF/0H5MsD
         W+DtfLwesptv38kg4BeRSb/UBNp1qQdu4xXew8NZe66usDx15xUkhrNZL8VXom5YQRmu
         szgR6zHOjR4addKDeaShZVbIATjZO9i2yrGq8LGCnJsJmRhRSGrPy+GRaHjUuKY4AFyr
         XKpCxukce5y5qEkRAO3Wypb91QApQRZmcB1RhAhWPG28VjK9u+JWpFQvvHRWFvBeryuJ
         qr6u9IAXaYVTD7jZsGUWYncKSuCYKebuzTbg/5Jfrjxuk12vO7eSCohR3EslP0D3Cy1Q
         0F4g==
X-Forwarded-Encrypted: i=1; AJvYcCVanRTNFdErdP4byHVPvIruI7TgzkVRWEYBuZ8eVV05LjNTWqTEUMMNyzODJrDDE/8jrBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCA5iVPRC8V3/gu6mjOFepbMDhjutZKLkpgZtuBEqj0aM08nwf
	oSZ6sW1l9t4Lt5E9wRPGjU4JkDP/lUgeaYEr+jecgd2hxrt+6tW5Mopf3K6UwHJ1P6/uUr73yl+
	TTEuIUYJbSNogydEyueRN8YrdArnWk6zFlswPR75TGGJ1vd5qrQ==
X-Received: by 2002:a05:6602:1355:b0:82a:249e:bdfd with SMTP id ca18e2360f4ac-83e0336c2d5mr389586939f.3.1731360458550;
        Mon, 11 Nov 2024 13:27:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGX/Ggt58ehkyFsCDSKKtU9X8zNWVnKRm0joN8z3lTyNEVbcXKQvdETM55lD1avBOWaFa37pA==
X-Received: by 2002:a05:6602:1355:b0:82a:249e:bdfd with SMTP id ca18e2360f4ac-83e0336c2d5mr389586139f.3.1731360458143;
        Mon, 11 Nov 2024 13:27:38 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de787d6278sm1574968173.88.2024.11.11.13.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 13:27:37 -0800 (PST)
Date: Mon, 11 Nov 2024 14:27:36 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org, parav@nvidia.com,
 feliu@nvidia.com, kevin.tian@intel.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
Message-ID: <20241111142736.18a625df.alex.williamson@redhat.com>
In-Reply-To: <112ebe08-06f3-4cb5-8cf0-8b49c56eac89@oracle.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
	<20241104102131.184193-8-yishaih@nvidia.com>
	<20241105162904.34b2114d.alex.williamson@redhat.com>
	<20241106135909.GO458827@nvidia.com>
	<20241106152732.16ac48d3.alex.williamson@redhat.com>
	<af8886fd-ec75-45fa-b627-2cd3c2ce905c@nvidia.com>
	<20241107142554.1c38f347.alex.williamson@redhat.com>
	<4ea48b12-03d0-40df-8c9c-96a78343f8c6@nvidia.com>
	<d2b83eef-4f39-4583-86d8-fc5bf83dd47a@oracle.com>
	<ba487f4f-b8d9-4e42-9aef-300a8ed3648a@nvidia.com>
	<112ebe08-06f3-4cb5-8cf0-8b49c56eac89@oracle.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Nov 2024 15:30:47 +0000
Joao Martins <joao.m.martins@oracle.com> wrote:

> On 11/11/2024 14:17, Yishai Hadas wrote:
> > On 11/11/2024 12:32, Joao Martins wrote: =20
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depend=
s on VIRTIO_PCI
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 select=
 VFIO_PCI_CORE
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 select=
 IOMMUFD_DRIVER =20
> >>>>
> >>>> IIUC, this is not a dependency, the device will just lack dirty page
> >>>> tracking with either the type1 backend or when using iommufd when the
> >>>> IOMMU hardware doesn't have dirty page tracking, therefore all VM
> >>>> memory is perpetually dirty.=C2=A0 Do I have that right? =20
> >>>
> >>> IOMMUFD_DRIVER is selected to utilize the dirty tracking functionalit=
y of IOMMU.
> >>> Therefore, this is a select option rather than a dependency, similar =
to how the
> >>> pds and mlx5 VFIO drivers handle it in their Kconfig files.
> >>> =20
> >>
> >> Yishai, I think Alex is right here.
> >>
> >> 'select IOMMUFD_DRIVER' is more for VF dirty trackers where it uses th=
e same
> >> helpers as IOMMUFD does for dirty tracking. But it's definitely not si=
gnaling
> >> intent for 'IOMMU dirty tracking' but rather 'VF dirty tracking' =20
> >=20
> > I see, please see below.
> >  =20
> I should have said that in the context of VFIO drivers selecting it, not =
broadly
> across all drivers that select it.
>=20
> >>
> >> If you want to tie in to IOMMU dirty tracking you probably want to do:
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0'select IOMMUFD'
> >> =20
> >=20
> > Looking at the below Kconfig(s) for AMD/INTEL_IOMMU [1], we can see tha=
t if
> > IOMMUFD is set IOMMFD_DRIVER is selected.
> >  =20
> Correct.
>=20
> > From that we can assume that to have 'IOMMU dirty tracking' the IOMMFD_=
DRIVER is
> > finally needed/selected, right ?
> >  =20
>=20
> Right, if you have CONFIG_IOMMUFD then the IOMMU will in the end auto-sel=
ect
> IOMMU_DRIVER. But standalone at best you can assume that 'something does =
dirty
> tracking'. The context (i.e. who selects it) is what tells you if it's VF=
 or IOMMU.
>=20
> In your example above, that option is meant to be selected by *a* dirty t=
racker,
> and it's because AMD/Intel was selecting that you would have IOMMU dirty
> tracking. The option essentially selects IOVA bitmaps helpers (zerocopy s=
cheme
> to set bits in a bitmap) which is both used by VF dirty trackers and IOMM=
U dirty
> trackers. Originally this started in VFIO and later got moved into IOMMUF=
D which
> is why we have this kconfig to allow independent use.

Yeah, I agree.  IOMMUFD_DRIVER is only configuring in iova_bitmap
support independent of IOMMUFD, which mlx5 requires, but this does not.

> > So you are saying that it's redundant in the vfio/virtio driver as it w=
ill be
> > selected down the road once needed ?
> >  =20
> Right.
>=20
> Of course, it will always depend on user enabling the right kconfigs and =
such.
> But that would be no different than the other drivers than don't support =
VF
> dirty tracking.
>=20
> > [1]
> > https://elixir.bootlin.com/linux/v6.12-rc6/source/drivers/iommu/intel/K=
config#L17
> > https://elixir.bootlin.com/linux/v6.12-rc6/source/drivers/iommu/amd/Kco=
nfig#L16
> >  =20
> >> But that is a big hammer, as you also need the VFIO_DEVICE_CDEV kconfi=
g selected
> >> as well and probably more. =20
> >=20
> > I agree, we didn't plan to add those dependencies.
> >  =20
> >>
> >> Perhaps best to do like qat/hisilicon drivers and letting the user opt=
ionally
> >> pick it. Migration is anyways disabled when using type1 (unless you fo=
rce it,
> >> and it then it does the perpectual dirty trick). =20

Yes, at least for QEMU, unless the user forces the device to support
migration we'll add a migration blocker rather than use the perpetually
dirty trick.  Ultimately the support depends on the underlying IOMMU
capabilities where we're running anyway, so it makes sense to me to
leave this to the user rather than trying to force a kernel config that
can support IOMMU dirty page tracking.  Thanks,

Alex


