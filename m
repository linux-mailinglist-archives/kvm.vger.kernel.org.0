Return-Path: <kvm+bounces-67642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D397D0C583
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 22:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B803302E339
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 21:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA7433DECB;
	Fri,  9 Jan 2026 21:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JEyNlwUB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C48133A715
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 21:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767994769; cv=pass; b=FsiqGxU7XfAfJTPumWADMxeOfEn0/djCQYvGWhspqs4a7yUMcjlzlcOdz1jwQ9jthJRE/Sda6bcLYYFyxewLcYzGjvNzFKyl8UTqnKZLQpDHfmb54YimcHIp4fPhRxTMLJxILhHFYsr0EcvyHXVBtTPN/BD6mW3skQAXEUJs2hU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767994769; c=relaxed/simple;
	bh=LRktjBIuVYAHxo/d1MN6i3X7/mOpSmpIHtlRCR3qKu4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fSAuJfielbn5sOKky5+L6FBDO4Y7PIaVFxmAH6xGUCQRahI1dKFDvHQInrhxf8GdelTachc2feeT0kftKHmpz4/dAwSpoIW6VXfap+oahyri7VdZU3KCGh5Gq5ulrXntYU+sUrrmAB8YpbiIKzuHG7ZklyGvhKabBRKesNwr+Wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JEyNlwUB; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4edb8d6e98aso139641cf.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 13:39:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767994766; cv=none;
        d=google.com; s=arc-20240605;
        b=S2+Dzl5WhFRLRyJw672oQB0LU1GhlqE6VaiKh3wHMbBtU6vwjRGcFvzO4pxple+U+p
         KceTs0g09z3tDqG/oWTrZt20xlpJZsvcJOTV+th7pAChnc7tCDglyjYLAW4fpg8cm5K/
         jRW+eleieBFdU2AuG3whMuxTdXHIg3uiCD5HDcyINOKnCaRHMoFp4BY3IsiA5enO6FAL
         l4BgRcGMgv1r/ppAR7qyUngmY2CILLB0MwBkmB0rmSkeQBdE0eJ7hN1gUy/NSKjk9UzG
         xYJYZEHs8rlJPQE3zCdNkSWd3uELSrgi0AhsFEgNdjrLRzKc+8k6OxUy/XW45Yim3rEA
         WRkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W/dylGzwVL+uyGpMZYNFm7dWAj2mtf9lYu+gfspoxo0=;
        fh=Vgz+v3kpIGxDvE3EmTaiGgWu25gTZtpEL8lRpJszXwQ=;
        b=SmKBG8KDLCz3wFU+lFnXNW6lqYq2ASeWEnrLjWmXqQUNUuM75y5XG1hKdb60rXsDEg
         X10AarmOzc/nWynXtRcnGoexyH4gbXaKUXWCmqendW6RZWYdO/lzjRvG7btI1AmzdDpf
         m1uWo9lc0dWz5pCj+rk35D9slNUIfXwMEwBmclJDTlQC2zhf7AfJTZQO3kKJMIYhqj0z
         jPXdCdK14wxENbCXNinIkbPVMCfQwFORk/DzNQGcqahce5BoZmHHSO895cHWJ1R7jjjl
         zlit1XEQOqvvLz3JobA9+8Mr8epfx9Tn56hkGfyj8gJS0CvJ3v2A+RffikLiUL4mXGck
         kDBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767994766; x=1768599566; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/dylGzwVL+uyGpMZYNFm7dWAj2mtf9lYu+gfspoxo0=;
        b=JEyNlwUBswD7InseAjUU/K6/4CUnWX3s1opA1oWJDCnkxfPGT0TAJ74d3iVT8kT8rU
         H9EAkZj2zLDtuuugMWPRxTTunxpGwJB/4sxa+NdVDJIy34Eom8XWKNWOvSD+T+9zye3y
         CdNCt0L91iqCgG4455mDJTjVSa/DVVPCjTMP90SI/xMlrO3detg1bnl7M2wyjPVWeUXx
         Fn52qOc/m5svYrhYWw13N3RF/0SpkjWFwWWXZrDahlUw0LY/0clQ1k6PwyGeXDKdl+7J
         ZeA+D1OumKDRDi69P+KCydwfUHZEDf6QPZTt0g7mHiqXkXt5NHaNycXC1+++asImBtua
         UcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767994766; x=1768599566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W/dylGzwVL+uyGpMZYNFm7dWAj2mtf9lYu+gfspoxo0=;
        b=i5YONpyisLZyKshKpa3rR7eZDZdjXyUNkEK6cEaPL7f13UH4NfWvJQ5boHqyjpP7XT
         2qZskRLBPeezwlKgRt/EoIjpsqs4/732rb9FwBkTgD0NfEGrBucj+7RC0Yp4fHn+8JBn
         pqv4CcttQwb/KRe5ICOvHksl1782opbSyrBS9nLlFIgGDzZLRDdN/SI8VjxOwwuXMHcf
         tQbYDkuSIRCdwx9/KAXoqOBSze4XtizjGdwahY3dyWzC7ofI0hSUFiZjUWA2E1XkPtn3
         /mI2ygLYT3459ZwPqXkYFdlUHqL0uB0F4fR99FstRQibXIUWfw9ZPsVX96iJYZDmcBIE
         vFxg==
X-Forwarded-Encrypted: i=1; AJvYcCW60J4Z3ytENF6CG5+WJ8UO0cHQOE4zZ6ksYgF9MAEv2FcFJ3Ki2TtMLH7tRAhVvtd+BGY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeIl3t/zxAv/P04yXT356Z1741y6440Zs7Xl+k8yfIXRowYSvY
	zTtg7ZzVZYbBAJCK10INw+ztphFrEB/AZtmr7l2X23RMXpF4YQRzsH0+5/Xi7AoWtHtfPRuZZSV
	zmvHq/i2IRYjv/6ILqdYZZIzqq7WK4cikv4WUHl+v
X-Gm-Gg: AY/fxX6L+/QK5JhxHgqA4UZAdnDoQHAyzgeN3A4AI+qy2LgAeHlj6B7r+fNH7/2NVKx
	DyKmskF338+pIetGM+ioA1ZgK04ZZdWXlDBbkwC7VFvTWE6zwYPhU5hAER7g0BHtJP+VtVLbqic
	/px4T9flYqmVszvVRxw5pcd7YzmqqFqAW/MZBeaZQWFj/fZRqNYR0ag3iS0qfJQOmj7FmXFxZRy
	S9Di+ppP7i4w3Wy0772BeZqR1K2DOrKlQSJizX0QnV8bUNpiXJoiiDVQd9IzZYuvAcz0r3PkkaK
	NoaAZV/mFkaaRLA7PEoRi53ytvo=
X-Received: by 2002:a05:622a:5cf:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-5011975f24dmr1250271cf.7.1767994766141; Fri, 09 Jan 2026
 13:39:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107201800.2486137-1-skhawaja@google.com> <20260107201800.2486137-3-skhawaja@google.com>
 <aV76VWKNxMw2t2kH@google.com>
In-Reply-To: <aV76VWKNxMw2t2kH@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Fri, 9 Jan 2026 13:39:14 -0800
X-Gm-Features: AZwV_QjwmaqpUXqrmGnwiQj3ddFB2KVdvzXHx4tgLOWE3HGuUmdzWyLSYVCMyWc
Message-ID: <CAAywjhQSPveBybmq32CtRMnmz_kyzzqRgimqZ3euXB5yZq5-sg@mail.gmail.com>
Subject: Re: [PATCH 2/3] vfio: selftests: Add support of creating iommus from iommufd
To: David Matlack <dmatlack@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Robin Murphy <robin.murphy@arm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 4:29=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2026-01-07 08:17 PM, Samiullah Khawaja wrote:
> > Add API to init a struct iommu using an already opened iommufd instance
> > and attach devices to it.
> >
> > Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> > ---
> >  .../vfio/lib/include/libvfio/iommu.h          |  2 +
> >  .../lib/include/libvfio/vfio_pci_device.h     |  2 +
> >  tools/testing/selftests/vfio/lib/iommu.c      | 60 +++++++++++++++++--
> >  .../selftests/vfio/lib/vfio_pci_device.c      | 16 ++++-
> >  4 files changed, 74 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h b=
/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
> > index 5c9b9dc6d993..9e96da1e6fd3 100644
> > --- a/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
> > +++ b/tools/testing/selftests/vfio/lib/include/libvfio/iommu.h
> > @@ -29,10 +29,12 @@ struct iommu {
> >       int container_fd;
> >       int iommufd;
> >       u32 ioas_id;
> > +     u32 hwpt_id;
> >       struct list_head dma_regions;
> >  };
> >
> >  struct iommu *iommu_init(const char *iommu_mode);
> > +struct iommu *iommufd_iommu_init(int iommufd, u32 dev_id);
> >  void iommu_cleanup(struct iommu *iommu);
> >
> >  int __iommu_map(struct iommu *iommu, struct dma_region *region);
> > diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_=
device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device=
.h
> > index 2858885a89bb..1143ceb6a9b8 100644
> > --- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.=
h
> > +++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.=
h
> > @@ -19,6 +19,7 @@ struct vfio_pci_device {
> >       const char *bdf;
> >       int fd;
> >       int group_fd;
> > +     u32 dev_id;
> >
> >       struct iommu *iommu;
> >
> > @@ -65,6 +66,7 @@ void vfio_pci_config_access(struct vfio_pci_device *d=
evice, bool write,
> >  #define vfio_pci_config_writew(_d, _o, _v) vfio_pci_config_write(_d, _=
o, _v, u16)
> >  #define vfio_pci_config_writel(_d, _o, _v) vfio_pci_config_write(_d, _=
o, _v, u32)
> >
> > +void vfio_pci_device_attach_iommu(struct vfio_pci_device *device, stru=
ct iommu *iommu);
> >  void vfio_pci_irq_enable(struct vfio_pci_device *device, u32 index,
> >                        u32 vector, int count);
> >  void vfio_pci_irq_disable(struct vfio_pci_device *device, u32 index);
> > diff --git a/tools/testing/selftests/vfio/lib/iommu.c b/tools/testing/s=
elftests/vfio/lib/iommu.c
> > index 58b7fb7430d4..2c67d7e24d0c 100644
> > --- a/tools/testing/selftests/vfio/lib/iommu.c
> > +++ b/tools/testing/selftests/vfio/lib/iommu.c
> > @@ -408,6 +408,18 @@ struct iommu_iova_range *iommu_iova_ranges(struct =
iommu *iommu, u32 *nranges)
> >       return ranges;
> >  }
> >
> > +static u32 iommufd_hwpt_alloc(struct iommu *iommu, u32 dev_id)
> > +{
> > +     struct iommu_hwpt_alloc args =3D {
> > +             .size =3D sizeof(args),
> > +             .pt_id =3D iommu->ioas_id,
> > +             .dev_id =3D dev_id,
> > +     };
> > +
> > +     ioctl_assert(iommu->iommufd, IOMMU_HWPT_ALLOC, &args);
> > +     return args.out_hwpt_id;
> > +}
> > +
> >  static u32 iommufd_ioas_alloc(int iommufd)
> >  {
> >       struct iommu_ioas_alloc args =3D {
> > @@ -418,11 +430,9 @@ static u32 iommufd_ioas_alloc(int iommufd)
> >       return args.out_ioas_id;
> >  }
> >
> > -struct iommu *iommu_init(const char *iommu_mode)
> > +static struct iommu *iommu_alloc(const char *iommu_mode)
> >  {
> > -     const char *container_path;
> >       struct iommu *iommu;
> > -     int version;
> >
> >       iommu =3D calloc(1, sizeof(*iommu));
> >       VFIO_ASSERT_NOT_NULL(iommu);
> > @@ -430,6 +440,16 @@ struct iommu *iommu_init(const char *iommu_mode)
> >       INIT_LIST_HEAD(&iommu->dma_regions);
> >
> >       iommu->mode =3D lookup_iommu_mode(iommu_mode);
> > +     return iommu;
> > +}
> > +
> > +struct iommu *iommu_init(const char *iommu_mode)
> > +{
> > +     const char *container_path;
> > +     struct iommu *iommu;
> > +     int version;
> > +
> > +     iommu =3D iommu_alloc(iommu_mode);
> >
> >       container_path =3D iommu->mode->container_path;
> >       if (container_path) {
> > @@ -453,10 +473,42 @@ struct iommu *iommu_init(const char *iommu_mode)
> >       return iommu;
> >  }
> >
> > +struct iommu *iommufd_iommu_init(int iommufd, u32 dev_id)
>
> I don't think the name really captures what this routine is doing. How
> about iommufd_dup()?

The reason I used _iommu_init because it creates a new hwpt and ioas
also, and it represents a separate "struct iommu". dup might indicate
that it is pointing to the same IOAS? Do you think maybe dup is an
implementation detail that doesn't need to be conveyed?

Do you think maybe I should rename it to iommufd_device_iommu_init as
it is creating an hwpt compatible with the device "dev_id"? Or
iommufd_iommu_init_for_device?
>
> > +{
> > +     struct iommu *iommu;
> > +
> > +     iommu =3D iommu_alloc("iommufd");
> > +
> > +     iommu->iommufd =3D dup(iommufd);
> > +     VFIO_ASSERT_GT(iommu->iommufd, 0);
> > +
> > +     iommu->ioas_id =3D iommufd_ioas_alloc(iommu->iommufd);
> > +     iommu->hwpt_id =3D iommufd_hwpt_alloc(iommu, dev_id);
> > +
> > +     return iommu;
> > +}
> > +
> > +static void iommufd_iommu_cleanup(struct iommu *iommu)
>
> nit: iommufd_cleanup()

Agreed.
>
> > +{
> > +     struct iommu_destroy args =3D {
> > +             .size =3D sizeof(args),
> > +     };
> > +
> > +     if (iommu->hwpt_id) {
> > +             args.id =3D iommu->hwpt_id;
> > +             ioctl_assert(iommu->iommufd, IOMMU_DESTROY, &args);
> > +     }
> > +
> > +     args.id =3D iommu->ioas_id;
> > +     ioctl_assert(iommu->iommufd, IOMMU_DESTROY, &args);
> > +
> > +     VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
> > +}
> > +
> >  void iommu_cleanup(struct iommu *iommu)
> >  {
> >       if (iommu->iommufd)
> > -             VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
> > +             iommufd_iommu_cleanup(iommu);
> >       else
> >               VFIO_ASSERT_EQ(close(iommu->container_fd), 0);
> >
> > diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools=
/testing/selftests/vfio/lib/vfio_pci_device.c
> > index fac4c0ecadef..9bc1f5ade5c4 100644
> > --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> > +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> > @@ -298,7 +298,7 @@ const char *vfio_pci_get_cdev_path(const char *bdf)
> >       return cdev_path;
> >  }
> >
> > -static void vfio_device_bind_iommufd(int device_fd, int iommufd)
> > +static int vfio_device_bind_iommufd(int device_fd, int iommufd)
> >  {
> >       struct vfio_device_bind_iommufd args =3D {
> >               .argsz =3D sizeof(args),
> > @@ -306,6 +306,7 @@ static void vfio_device_bind_iommufd(int device_fd,=
 int iommufd)
> >       };
> >
> >       ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
> > +     return args.out_devid;
> >  }
> >
> >  static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
> > @@ -326,10 +327,21 @@ static void vfio_pci_iommufd_setup(struct vfio_pc=
i_device *device, const char *b
> >       VFIO_ASSERT_GE(device->fd, 0);
> >       free((void *)cdev_path);
> >
> > -     vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
> > +     device->dev_id =3D vfio_device_bind_iommufd(device->fd, device->i=
ommu->iommufd);
> >       vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id)=
;
> >  }
> >
> > +void vfio_pci_device_attach_iommu(struct vfio_pci_device *device, stru=
ct iommu *iommu)
> > +{
> > +     u32 pt_id =3D iommu->ioas_id;
>
> /* Only iommufd supports changing struct iommu attachments */
> VFIO_ASSERT_TRUE(iommu->iommufd);

Agreed
>
> > +
> > +     if (iommu->hwpt_id)
> > +             pt_id =3D iommu->hwpt_id;
> > +
> > +     VFIO_ASSERT_NE(pt_id, 0);
> > +     vfio_device_attach_iommufd_pt(device->fd, pt_id);
>
> device->iommu =3D iommu;
>
> > +}
> > +
> >  struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct i=
ommu *iommu)
> >  {
> >       struct vfio_pci_device *device;
> > --
> > 2.52.0.351.gbe84eed79e-goog
> >

Thank you for the feedback.

