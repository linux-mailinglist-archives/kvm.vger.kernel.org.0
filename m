Return-Path: <kvm+bounces-60787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FEFFBF97C4
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 02:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB4F219C6060
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B61E188734;
	Wed, 22 Oct 2025 00:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZKq9sJ0G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD071607A4
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 00:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761093544; cv=none; b=TKlwqia6dTLRBCIdsiK11iymemI4hivO3//MtQFEwpYeQd72GpwEiuKXzbT0ZhyO5Cfderp3CY8ku50EDeiLKKo+d+7WIVfKJF3NptrsyNU+g7UcShsrsl73HoO5LwLIN9wQ0ui2mcTa7lRgySdIaMYpdH3Q3869dBOpHtYV49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761093544; c=relaxed/simple;
	bh=TIjFtBTjpwlKcGoETS7HOX7IgKiftQTJwlyTkdKev6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nmhRkUyF+TVrEnedWxgb8xEn9Wh4FG86clLhCBhBaUHhCmkvTGtJJkwaNybDYKZW3lphjdTQmkk1X5rCi3zjAKQIONbdgtdr8GgsKCNu8NIJYWA9M6qpshY6bpQn/ksGsXnRRgk/7+QTbZzR2Hrb/D0DjR6Vlvnw8ieF3+Bdl5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZKq9sJ0G; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-57b8fc6097fso5761575e87.1
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 17:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761093540; x=1761698340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07GWF8unSJYEHIbBCkg8bRPaixLcy4My/ivZS8+skUg=;
        b=ZKq9sJ0GuPAQ/a97nXCf5mrEmh7C85ZObbyoSvAZG3D8U2kfsQ147aoXogdCvZ3yeR
         FeRRG8xsGcUueTPg6peKA/g2o93EZV0glEMP0l6Gk6Wb4b2iOHjOuYsZ9l6d+OrF+fPo
         u4bzPnAur6Mzi0SAF0thqawLv7EvKD9oOhs0tNEPabhp6YTVQlZoGo+R9NfcEqtSP/wt
         Y3mNoNIgqs0ZgqZcx5uPDlAWP/0d4qbOU4hnsJXAlW4WguJnvcyhsd0gbEKPN2P8GrlX
         fx/EMHwVlwLzR/jNvix1UYu/zky/h/qpfWf6UnS4/A4uJFsUgMW62DpnH8+R64gmJnsb
         ovvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761093540; x=1761698340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=07GWF8unSJYEHIbBCkg8bRPaixLcy4My/ivZS8+skUg=;
        b=hGPt18PD9BQ8Z3706ND5AnHakLqKG73KS0wfXNRuoM3k9AkqimOPhhGain8mhftFZQ
         YyUwBSYBSRoAZNH2ZirVFzeVd+caDB5Izqvo8mk80ZExYRudrqsuHh/vnMXsYsbtEpeK
         i8RxPHi8R+zzUCpDKjUQGQpMK3C0db9UaDXbUD1KTlHX71VgHhJlZYlr6K3fcppeJys+
         2N8sy9iQ3qsGTXqkpVF6EXMF0+nssJxl6OHk0p7FR/wUZCcs97twzlnfIpVIyVzb4NMs
         2HtyLbOI3KQq83gAukQp2hQjnpoyLMpUnPdSCejSip6ckwdxDbyn1MR2Qi4SHKktQU2i
         51ag==
X-Forwarded-Encrypted: i=1; AJvYcCWLbGdXLNL64O/T+WHXiUa69RbxP02O3NWx9Vnh3F8o5pcGTKxnPmgYbd9SZ3HD+fTswTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKTW6O/6HLmQGYzfwwj7ZBTTtSb4va5olg9J3UjVv2G3IvBbrb
	BOSKRi6dvrljPUkOPpxpJ4SSdKI2JmHQoBD6/gZjAjOG/hnJxRg6McQibSBgtMaVVSzVJlCINxQ
	m99CYopn1KPn2TlM6I7ntw/rc++B8PD5mmxUkhQOwAXKPXu/X6Uk31xmIETY=
X-Gm-Gg: ASbGncuMRwD8retAohkZZ91cJgNSGEAZC0RcHIQp23b5MXCTQUsYiAIbbUN84xMos5y
	8LRTfXh6a1XlZig5gcEXVNGqcf9cpPIOVH4oE1/PTdGPCu8b+soKNv9NSK97AH+Gxw6x4aMqG0U
	Nj1gk+o0q80LjfgZoUBlzuv90GMXpSNtSTQwSR1q7B+iSZpGaOIt8vevhmL5sW0ZZU2XJaMEhcz
	9mSs4wdkvRY9SVE/fiOVEPHuctJ1Vhs+0QYw1xhlIDukA0c2shWyY8rWZmaY/gYWKukBVXWM8k7
	UZYd1rg+6ablJS4bQff3FGN62A==
X-Google-Smtp-Source: AGHT+IEv0LKkhKX4OP3PSlmIdQM3QHHaKGdBfaLjHdys1lfFe7uY5h85fQqVO38DlRtlCvYUTxOss9iLW6mylVMqGEM=
X-Received: by 2002:a05:6512:1054:b0:57b:96c8:6620 with SMTP id
 2adb3069b0e04-591d852be07mr6422849e87.3.1761093540202; Tue, 21 Oct 2025
 17:39:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com> <20251015132452.321477fa@shazbot.org>
 <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com> <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
 <20251016160138.374c8cfb@shazbot.org> <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
 <20251020153633.33bf6de4@shazbot.org> <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
 <CALzav=ebeVvg5jyFjkAN-Ud==6xS9y1afszSE10mpa9PUOu+Dw@mail.gmail.com> <aPfbU4rYkSUDG4D0@devgpu012.nha5.facebook.com>
In-Reply-To: <aPfbU4rYkSUDG4D0@devgpu012.nha5.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Oct 2025 17:38:31 -0700
X-Gm-Features: AS18NWA-blcidvzyitSBhyRzyox4onuIaIqQYeyFJ1tOQ9lvIpUcktY63SpLme8
Message-ID: <CALzav=cyDaiKbQfkjF_UUQ0PB6cAKZhnSqM3ZvodqqEe8kQEqw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable limit
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 12:13=E2=80=AFPM Alex Mastro <amastro@fb.com> wrote=
:
>
> On Tue, Oct 21, 2025 at 09:31:59AM -0700, David Matlack wrote:
> > On Tue, Oct 21, 2025 at 9:26=E2=80=AFAM Alex Mastro <amastro@fb.com> wr=
ote:
> > > On Mon, Oct 20, 2025 at 03:36:33PM -0600, Alex Williamson wrote:
> > > > Should we also therefore expand the DMA mapping tests in
> > > > tools/testing/selftests/vfio to include an end of address space tes=
t?
> > >
> > > Yes. I will append such a commit to the end of the series in v5. Our =
VFIO tests
> > > are built on top of a hermetic rust wrapper library over VFIO ioctls,=
 but they
> > > aren't quite ready to be open sourced yet.
> >
> > Feel free to reach out if you have any questions about writing or
> > running the VFIO selftests.
>
> Thanks David. I built and ran using below. I am not too familiar with
> kselftests, so open to tips.
>
> $ make LLVM=3D1 -j kselftest-install INSTALL_PATH=3D/tmp/kst TARGETS=3D"v=
fio"
> $ VFIO_SELFTESTS_BDF=3D0000:05:00.0 /tmp/kst/run_kselftest.sh
>
> I added the following. Is this the right direction? Is multiple fixtures =
per
> file OK? Seems related enough to vfio_dma_mapping_test.c to keep together=
.

Adding a fixture to vfio_dma_mapping_test.c is what I was imagining as well=
.

Overall looks good, we can hash out the specifics in the patches if
you prefer. But I added some thoughts below.

>
> I updated the *_unmap function signatures to return the count of bytes un=
mapped,
> since that is part of the test pass criteria. Also added unmap_all flavor=
s,
> since those exercise different code paths than range-based unmap.

When you send, can you introduce these in a separate commit and update
the existing test function in vfio_dma_mapping_test.c to assert on it?

>
> Relevant test output:
>
> # #  RUN           vfio_dma_map_limit_test.vfio_type1_iommu.end_of_addres=
s_space ...
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # #            OK  vfio_dma_map_limit_test.vfio_type1_iommu.end_of_addres=
s_space
> # ok 16 vfio_dma_map_limit_test.vfio_type1_iommu.end_of_address_space
> # #  RUN           vfio_dma_map_limit_test.vfio_type1v2_iommu.end_of_addr=
ess_space ...
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # #            OK  vfio_dma_map_limit_test.vfio_type1v2_iommu.end_of_addr=
ess_space
> # ok 17 vfio_dma_map_limit_test.vfio_type1v2_iommu.end_of_address_space
> # #  RUN           vfio_dma_map_limit_test.iommufd_compat_type1.end_of_ad=
dress_space ...
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # #            OK  vfio_dma_map_limit_test.iommufd_compat_type1.end_of_ad=
dress_space
> # ok 18 vfio_dma_map_limit_test.iommufd_compat_type1.end_of_address_space
> # #  RUN           vfio_dma_map_limit_test.iommufd_compat_type1v2.end_of_=
address_space ...
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # #            OK  vfio_dma_map_limit_test.iommufd_compat_type1v2.end_of_=
address_space
> # ok 19 vfio_dma_map_limit_test.iommufd_compat_type1v2.end_of_address_spa=
ce
> # #  RUN           vfio_dma_map_limit_test.iommufd.end_of_address_space .=
..
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
> # Mapped HVA 0x7f6638222000 (size 0x1000) at IOVA 0xfffffffffffff000
>
> diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools=
/testing/selftests/vfio/lib/include/vfio_util.h
> index ed31606e01b7..8e9d40845ccc 100644
> --- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
> +++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> @@ -208,8 +208,9 @@ void vfio_pci_device_reset(struct vfio_pci_device *de=
vice);
>
>  void vfio_pci_dma_map(struct vfio_pci_device *device,
>                       struct vfio_dma_region *region);
> -void vfio_pci_dma_unmap(struct vfio_pci_device *device,
> -                       struct vfio_dma_region *region);
> +u64 vfio_pci_dma_unmap(struct vfio_pci_device *device,
> +                       struct vfio_dma_region *region);
> +u64 vfio_pci_dma_unmap_all(struct vfio_pci_device *device);
>
>  void vfio_pci_config_access(struct vfio_pci_device *device, bool write,
>                             size_t config, size_t size, void *data);
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/t=
esting/selftests/vfio/lib/vfio_pci_device.c
> index 0921b2451ba5..f5ae68a7df9c 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
> @@ -183,7 +183,7 @@ void vfio_pci_dma_map(struct vfio_pci_device *device,
>         list_add(&region->link, &device->dma_regions);
>  }
>
> -static void vfio_iommu_dma_unmap(struct vfio_pci_device *device,
> +static u64 vfio_iommu_dma_unmap(struct vfio_pci_device *device,
>                                  struct vfio_dma_region *region)
>  {
>         struct vfio_iommu_type1_dma_unmap args =3D {
> @@ -193,9 +193,25 @@ static void vfio_iommu_dma_unmap(struct vfio_pci_dev=
ice *device,
>         };
>
>         ioctl_assert(device->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
> +
> +       return args.size;
> +}
> +
> +static u64 vfio_iommu_dma_unmap_all(struct vfio_pci_device *device)
> +{
> +       struct vfio_iommu_type1_dma_unmap args =3D {
> +               .argsz =3D sizeof(args),
> +               .iova =3D 0,
> +               .size =3D 0,
> +               .flags =3D VFIO_DMA_UNMAP_FLAG_ALL,
> +       };
> +
> +       ioctl_assert(device->container_fd, VFIO_IOMMU_UNMAP_DMA, &args);
> +
> +       return args.size;
>  }
>
> -static void iommufd_dma_unmap(struct vfio_pci_device *device,
> +static u64 iommufd_dma_unmap(struct vfio_pci_device *device,
>                               struct vfio_dma_region *region)
>  {
>         struct iommu_ioas_unmap args =3D {
> @@ -206,17 +222,54 @@ static void iommufd_dma_unmap(struct vfio_pci_devic=
e *device,
>         };
>
>         ioctl_assert(device->iommufd, IOMMU_IOAS_UNMAP, &args);
> +
> +       return args.length;
> +}
> +
> +static u64 iommufd_dma_unmap_all(struct vfio_pci_device *device)
> +{
> +       struct iommu_ioas_unmap args =3D {
> +               .size =3D sizeof(args),
> +               .iova =3D 0,
> +               .length =3D UINT64_MAX,
> +               .ioas_id =3D device->ioas_id,
> +       };
> +
> +       ioctl_assert(device->iommufd, IOMMU_IOAS_UNMAP, &args);
> +
> +       return args.length;
>  }
>
> -void vfio_pci_dma_unmap(struct vfio_pci_device *device,
> +u64 vfio_pci_dma_unmap(struct vfio_pci_device *device,
>                         struct vfio_dma_region *region)
>  {
> +       u64 unmapped;
> +
>         if (device->iommufd)
> -               iommufd_dma_unmap(device, region);
> +               unmapped =3D iommufd_dma_unmap(device, region);
>         else
> -               vfio_iommu_dma_unmap(device, region);
> +               unmapped =3D vfio_iommu_dma_unmap(device, region);
>
>         list_del(&region->link);
> +
> +       return unmapped;
> +}
> +
> +u64 vfio_pci_dma_unmap_all(struct vfio_pci_device *device)
> +{
> +       u64 unmapped;
> +       struct vfio_dma_region *curr, *next;
> +
> +       if (device->iommufd)
> +               unmapped =3D iommufd_dma_unmap_all(device);
> +       else
> +               unmapped =3D vfio_iommu_dma_unmap_all(device);
> +
> +       list_for_each_entry_safe(curr, next, &device->dma_regions, link) =
{
> +               list_del(&curr->link);
> +       }
> +
> +       return unmapped;
>  }
>
>  static void vfio_pci_region_get(struct vfio_pci_device *device, int inde=
x,
> diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools=
/testing/selftests/vfio/vfio_dma_mapping_test.c
> index ab19c54a774d..e908c1fe7103 100644
> --- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
> +++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
> @@ -122,6 +122,8 @@ FIXTURE_TEARDOWN(vfio_dma_mapping_test)
>         vfio_pci_device_cleanup(self->device);
>  }
>
> +#undef FIXTURE_VARIANT_ADD_IOMMU_MODE

I think this can/should go just after the
FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(); statement. The same below.

> +
>  TEST_F(vfio_dma_mapping_test, dma_map_unmap)
>  {
>         const u64 size =3D variant->size ?: getpagesize();
> @@ -192,6 +194,61 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
>         ASSERT_TRUE(!munmap(region.vaddr, size));
>  }
>
> +FIXTURE(vfio_dma_map_limit_test) {
> +       struct vfio_pci_device *device;
> +};
> +
> +FIXTURE_VARIANT(vfio_dma_map_limit_test) {
> +       const char *iommu_mode;
> +};
> +
> +#define FIXTURE_VARIANT_ADD_IOMMU_MODE(_iommu_mode)                     =
       \
> +FIXTURE_VARIANT_ADD(vfio_dma_map_limit_test, _iommu_mode) {             =
       \
> +       .iommu_mode =3D #_iommu_mode,                                    =
        \
> +}
> +
> +FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES();
> +
> +FIXTURE_SETUP(vfio_dma_map_limit_test)
> +{
> +       self->device =3D vfio_pci_device_init(device_bdf, variant->iommu_=
mode);
> +}
> +
> +FIXTURE_TEARDOWN(vfio_dma_map_limit_test)
> +{
> +       vfio_pci_device_cleanup(self->device);
> +}
> +
> +#undef FIXTURE_VARIANT_ADD_IOMMU_MODE
> +
> +TEST_F(vfio_dma_map_limit_test, end_of_address_space)
> +{
> +       struct vfio_dma_region region =3D {};
> +       u64 size =3D getpagesize();
> +       u64 unmapped;
> +
> +       region.vaddr =3D mmap(NULL, size, PROT_READ | PROT_WRITE,
> +                           MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +       ASSERT_NE(region.vaddr, MAP_FAILED);
> +
> +       region.iova =3D ~(iova_t)0 & ~(size - 1);
> +       region.size =3D size;
> +
> +       vfio_pci_dma_map(self->device, &region);
> +       printf("Mapped HVA %p (size 0x%lx) at IOVA 0x%lx\n", region.vaddr=
, size, region.iova);
> +       ASSERT_EQ(region.iova, to_iova(self->device, region.vaddr));
> +
> +       unmapped =3D vfio_pci_dma_unmap(self->device, &region);
> +       ASSERT_EQ(unmapped, size);
> +
> +       vfio_pci_dma_map(self->device, &region);
> +       printf("Mapped HVA %p (size 0x%lx) at IOVA 0x%lx\n", region.vaddr=
, size, region.iova);
> +       ASSERT_EQ(region.iova, to_iova(self->device, region.vaddr));
> +
> +       unmapped =3D vfio_pci_dma_unmap_all(self->device);
> +       ASSERT_EQ(unmapped, size);

The unmap_all test should probably be in a separate TEST_F. You can
put the struct vfio_dma_region in the FIXTURE and initialize it in the
FIXTURE_SETUP() to reduce code duplication.
> +}

Would it be useful to add negative map/unmap tests as well? If so we'd
need a way to plumb the return value of the ioctl up to the caller so
you can assert that it failed, which will conflict with returning the
amount of unmapped bytes.

Maybe we should make unmapped an output parameter like so?

int __vfio_pci_dma_map(struct vfio_pci_device *device,
        struct vfio_dma_region *region);

void vfio_pci_dma_map(struct vfio_pci_device *device,
        struct vfio_dma_region *region);

int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
        struct vfio_dma_region *region, u64 *unmapped);

void vfio_pci_dma_unmap(struct vfio_pci_device *device,
        struct vfio_dma_region *region, u64 *unmapped);

int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped)=
;
void vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapped);

unmapped can be optional and callers that don't care can pass in NULL.
It'll be a little gross though to see NULL on all the unmap calls
though... Maybe unmapped can be restricted to __vfio_pci_dma_unmap().
So something like this:

int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
        struct vfio_dma_region *region, u64 *unmapped);

void vfio_pci_dma_unmap(struct vfio_pci_device *device,
        struct vfio_dma_region *region);

