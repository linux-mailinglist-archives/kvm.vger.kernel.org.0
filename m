Return-Path: <kvm+bounces-64348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3A2C8029B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:17:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA54B4E4F88
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70C02FB977;
	Mon, 24 Nov 2025 11:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RXW/1lD6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130762566E9
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 11:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763983059; cv=none; b=m7YdICM8hYZU5KohUHBayI1Syr6o9KHq620PLS5pRPK71n5IhdpltgjGNyV6ISQiEt4l7xlL0MOy+t/mR3TQysVuQIi0cgfrMmnwyNAQq2NVK8PdtCrH8aQPXQOndxlUl+Vz+av71N6cZD5PLv5aMnFNxzcA/oROwKtNv+PNzzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763983059; c=relaxed/simple;
	bh=D+g6Rij4sWXjdanibXUhH9zTEAKr2SDJdkKgmOhgIAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P4ltasKpoIBiBB6XeUntg8QruKbB3A0AY7BmQuAelDmdH/R2ckVwo2IX1I0SiKCTVeOa0xusZMFfRIw8mwlF2npGebH9akF8T6utl80a+pqpbdcrCEuME1mqX4OQmqKv56Ub/Xud5ZhG76FlnhyIi31nH1TUKDzuU7bccX/MB3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RXW/1lD6; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee147baf7bso471781cf.1
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 03:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763983057; x=1764587857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mzzc4hSr5S09Is1ztONBZro4uu+2xplgy4/XwhtEgfI=;
        b=RXW/1lD6H1UbVA4xW519mlZ7tbrwVzrahMMs+Dcq2ZLNsclUyvEJsiCTI1JJlprdQY
         h8RgKohOqSvktn4kukB2ja/51WBlygkiNrb/B1BpsStQ1UfcSknFISZEq98OwO1s5I6I
         keZsSesoDBzh1maIjezPXqr8EDe5v3FzwHf/lO66y9aD2vjfcJcCIHvvT6E+8jMS0IES
         DfVVlVXAyjUDrlvC+ZTUI6g5GF7ZeZo3fMWdfplIg8XFMDSBASlLmjlEXQs83OkvUfdH
         0I6E1e8nSe6xxmkd6ePjXpygPZsJJbjLlsgYB/EpxHADAGjvaqgEr0qjmh/tMbL6c1QC
         Rbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763983057; x=1764587857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mzzc4hSr5S09Is1ztONBZro4uu+2xplgy4/XwhtEgfI=;
        b=jsCc/bouBJvs9gWOyTRHwQuK9ZDc7SKj1pcR7GEKxWAPemN5f0QNs5pq3HP5mSoEUf
         W2vfK/93DNt1tplwzwKkMHLVV92txaLMNkAdXTXkheEXNvoRP8W9svDhcvPKtRoV/ay9
         nOufgMAQACNbp2SUod27eAc/HHBqtOxkAGiftRWUI482qpYzwMAwv89BaKBhysxr9VsG
         2/xRPafPV9akmR1WH4zqKafQeEPlQvwp6xy9zlH+t3pkA2POPjzncMVJFbhczmuxRnWH
         mbdAvc0Zzy2JBDZrv4PGgDFENfCzPTjKUoyEC4n3+fuLW2TDnD4FBGaqa0AKDUbGwTkm
         Djog==
X-Forwarded-Encrypted: i=1; AJvYcCWQufaiCEIukEBKD+cVfVcOmWa8RJQ5NS9UTTep4+dZJiN4nL24UZ2xboGEx9yzELVxdYs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5Yl4K/nvM9aFKiOrTqeOeFptC3C3zBQVdzBFYEM1M3cOM0RSS
	5FM/vsa5dY6UycnGWhBYz7CYOGxl223tb+n8qKhQJfYi2/PikYodPN0E7vmlRsUmUqqsW5ay9sP
	UTsr7w7cbTzc8tG9iznDaR7s+/zKs7karksfazkrJ
X-Gm-Gg: ASbGnctxX+eHMuBD6msE5gh87y3AT2dbpijTun5/BGRV6/9S13ZkH+YChD1l2r/VTSV
	7wkXxULxN3PAxKYpIPpBxLY3JL8vueVXW3QKCJzMnJaZHShUtfKW5vpBvADOuc9WeR35ZIxASvr
	evjhOBZFKQblcZkgiUSaj9ITCyLMvFvZVp8zCa+0SvwjfROsM8MjG6zaeeRdfiOC+zcy8+W4OJ7
	LQqe8C6Dg0yZHP7OzUW1fc7cA0Qj8O0kApTufKvVF55HNwCzB2d/AxkBKV1D1Xp0PAIcGvi0xhv
	V7x2CdkG+/1/OFVvv+Frw45zJFA=
X-Google-Smtp-Source: AGHT+IHPCu8R3S1JD9PSnlMzncHlf84m97jDDEtIoqInagZC3d+StqPrkZiyJgHyWukWagfTfD5/LOtuK3hD2On/ygs=
X-Received: by 2002:ac8:598e:0:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-4ee60f84620mr8571491cf.14.1763983056685; Mon, 24 Nov 2025
 03:17:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121181429.1421717-1-dmatlack@google.com> <20251121181429.1421717-7-dmatlack@google.com>
In-Reply-To: <20251121181429.1421717-7-dmatlack@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 24 Nov 2025 16:47:24 +0530
X-Gm-Features: AWmQ_blRnCLweWKPFsV7ropg_mxLTP-N5DgdGxxocyhptePqGWlf95CqbKaHA00
Message-ID: <CAJHc60zW+FzOfUQzZYCStmFJ_d8Gr2mi-nN297b=gU+26mt1BQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/18] vfio: selftests: Support multiple devices in the
 same container/iommufd
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2025 at 11:44=E2=80=AFPM David Matlack <dmatlack@google.com=
> wrote:
>
> Support tests that want to add multiple devices to the same
> container/iommufd by decoupling struct vfio_pci_device from
> struct iommu.
>
> Multi-devices tests can now put multiple devices in the same
> container/iommufd like so:
>
>   iommu =3D iommu_init(iommu_mode);
>
>   device1 =3D vfio_pci_device_init(bdf1, iommu);
>   device2 =3D vfio_pci_device_init(bdf2, iommu);
>   device3 =3D vfio_pci_device_init(bdf3, iommu);
>
>   ...
>
>   vfio_pci_device_cleanup(device3);
>   vfio_pci_device_cleanup(device2);
>   vfio_pci_device_cleanup(device1);
>
>   iommu_cleanup(iommu);
>

> +struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iom=
mu *iommu)
>  {
>         struct vfio_pci_device *device;
>
>         device =3D calloc(1, sizeof(*device));
>         VFIO_ASSERT_NOT_NULL(device);
>
> -       device->iommu =3D calloc(1, sizeof(*device->iommu));
> -       VFIO_ASSERT_NOT_NULL(device->iommu);
> -
> -       INIT_LIST_HEAD(&device->iommu->dma_regions);
> -
> -       device->iommu->mode =3D lookup_iommu_mode(iommu_mode);
> +       device->iommu =3D iommu;
nit: Since we now depend on the caller to follow the right order,
should we have a VFIO_ASSERT_NOT_NULL(iommu), or something along the
lines of 'Is iommu initialized?" before this function starts using it,
and fail with an appropriate error message?

>
>         if (device->iommu->mode->container_path)
minor nit: if there's a v4, simply use iommu->mode->container_path.

Thank you.
Raghavendra


>                 vfio_pci_container_setup(device, bdf);
> @@ -853,17 +872,22 @@ void vfio_pci_device_cleanup(struct vfio_pci_device=
 *device)
>                 VFIO_ASSERT_EQ(close(device->msi_eventfds[i]), 0);
>         }
>
> -       if (device->iommu->iommufd) {
> -               VFIO_ASSERT_EQ(close(device->iommu->iommufd), 0);
> -       } else {
> +       if (device->group_fd)
>                 VFIO_ASSERT_EQ(close(device->group_fd), 0);
> -               VFIO_ASSERT_EQ(close(device->iommu->container_fd), 0);
> -       }
>
> -       free(device->iommu);
>         free(device);
>  }
>
> +void iommu_cleanup(struct iommu *iommu)
> +{
> +       if (iommu->iommufd)
> +               VFIO_ASSERT_EQ(close(iommu->iommufd), 0);
> +       else
> +               VFIO_ASSERT_EQ(close(iommu->container_fd), 0);
> +
> +       free(iommu);
> +}
> +
>  static bool is_bdf(const char *str)
>  {
>         unsigned int s, b, d, f;
> diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools=
/testing/selftests/vfio/vfio_dma_mapping_test.c
> index 102603d4407d..4727feb214c8 100644
> --- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
> +++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
> @@ -94,6 +94,7 @@ static int iommu_mapping_get(const char *bdf, u64 iova,
>  }
>
>  FIXTURE(vfio_dma_mapping_test) {
> +       struct iommu *iommu;
>         struct vfio_pci_device *device;
>         struct iova_allocator *iova_allocator;
>  };
> @@ -119,7 +120,8 @@ FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(anonymous_hugetlb=
_1gb, SZ_1G, MAP_HUGETLB |
>
>  FIXTURE_SETUP(vfio_dma_mapping_test)
>  {
> -       self->device =3D vfio_pci_device_init(device_bdf, variant->iommu_=
mode);
> +       self->iommu =3D iommu_init(variant->iommu_mode);
> +       self->device =3D vfio_pci_device_init(device_bdf, self->iommu);
>         self->iova_allocator =3D iova_allocator_init(self->device);
>  }
>
> @@ -127,6 +129,7 @@ FIXTURE_TEARDOWN(vfio_dma_mapping_test)
>  {
>         iova_allocator_cleanup(self->iova_allocator);
>         vfio_pci_device_cleanup(self->device);
> +       iommu_cleanup(self->iommu);
>  }
>
>  TEST_F(vfio_dma_mapping_test, dma_map_unmap)
> @@ -203,6 +206,7 @@ TEST_F(vfio_dma_mapping_test, dma_map_unmap)
>  }
>
>  FIXTURE(vfio_dma_map_limit_test) {
> +       struct iommu *iommu;
>         struct vfio_pci_device *device;
>         struct vfio_dma_region region;
>         size_t mmap_size;
> @@ -235,7 +239,8 @@ FIXTURE_SETUP(vfio_dma_map_limit_test)
>          */
>         self->mmap_size =3D 2 * region_size;
>
> -       self->device =3D vfio_pci_device_init(device_bdf, variant->iommu_=
mode);
> +       self->iommu =3D iommu_init(variant->iommu_mode);
> +       self->device =3D vfio_pci_device_init(device_bdf, self->iommu);
>         region->vaddr =3D mmap(NULL, self->mmap_size, PROT_READ | PROT_WR=
ITE,
>                              MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>         ASSERT_NE(region->vaddr, MAP_FAILED);
> @@ -253,6 +258,7 @@ FIXTURE_SETUP(vfio_dma_map_limit_test)
>  FIXTURE_TEARDOWN(vfio_dma_map_limit_test)
>  {
>         vfio_pci_device_cleanup(self->device);
> +       iommu_cleanup(self->iommu);
>         ASSERT_EQ(munmap(self->region.vaddr, self->mmap_size), 0);
>  }
>
> diff --git a/tools/testing/selftests/vfio/vfio_pci_device_test.c b/tools/=
testing/selftests/vfio/vfio_pci_device_test.c
> index 7a270698e4d2..e95217933c6b 100644
> --- a/tools/testing/selftests/vfio/vfio_pci_device_test.c
> +++ b/tools/testing/selftests/vfio/vfio_pci_device_test.c
> @@ -23,17 +23,20 @@ static const char *device_bdf;
>  #define MAX_TEST_MSI 16U
>
>  FIXTURE(vfio_pci_device_test) {
> +       struct iommu *iommu;
>         struct vfio_pci_device *device;
>  };
>
>  FIXTURE_SETUP(vfio_pci_device_test)
>  {
> -       self->device =3D vfio_pci_device_init(device_bdf, default_iommu_m=
ode);
> +       self->iommu =3D iommu_init(default_iommu_mode);
> +       self->device =3D vfio_pci_device_init(device_bdf, self->iommu);
>  }
>
>  FIXTURE_TEARDOWN(vfio_pci_device_test)
>  {
>         vfio_pci_device_cleanup(self->device);
> +       iommu_cleanup(self->iommu);
>  }
>
>  #define read_pci_id_from_sysfs(_file) ({                                =
                       \
> @@ -99,6 +102,7 @@ TEST_F(vfio_pci_device_test, validate_bars)
>  }
>
>  FIXTURE(vfio_pci_irq_test) {
> +       struct iommu *iommu;
>         struct vfio_pci_device *device;
>  };
>
> @@ -116,12 +120,14 @@ FIXTURE_VARIANT_ADD(vfio_pci_irq_test, msix) {
>
>  FIXTURE_SETUP(vfio_pci_irq_test)
>  {
> -       self->device =3D vfio_pci_device_init(device_bdf, default_iommu_m=
ode);
> +       self->iommu =3D iommu_init(default_iommu_mode);
> +       self->device =3D vfio_pci_device_init(device_bdf, self->iommu);
>  }
>
>  FIXTURE_TEARDOWN(vfio_pci_irq_test)
>  {
>         vfio_pci_device_cleanup(self->device);
> +       iommu_cleanup(self->iommu);
>  }
>
>  TEST_F(vfio_pci_irq_test, enable_trigger_disable)
> diff --git a/tools/testing/selftests/vfio/vfio_pci_driver_test.c b/tools/=
testing/selftests/vfio/vfio_pci_driver_test.c
> index f69eec8b928d..b0c7d812de1f 100644
> --- a/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> +++ b/tools/testing/selftests/vfio/vfio_pci_driver_test.c
> @@ -44,6 +44,7 @@ static void region_teardown(struct vfio_pci_device *dev=
ice,
>  }
>
>  FIXTURE(vfio_pci_driver_test) {
> +       struct iommu *iommu;
>         struct vfio_pci_device *device;
>         struct iova_allocator *iova_allocator;
>         struct vfio_dma_region memcpy_region;
> @@ -73,7 +74,8 @@ FIXTURE_SETUP(vfio_pci_driver_test)
>  {
>         struct vfio_pci_driver *driver;
>
> -       self->device =3D vfio_pci_device_init(device_bdf, variant->iommu_=
mode);
> +       self->iommu =3D iommu_init(variant->iommu_mode);
> +       self->device =3D vfio_pci_device_init(device_bdf, self->iommu);
>         self->iova_allocator =3D iova_allocator_init(self->device);
>
>         driver =3D &self->device->driver;
> @@ -113,6 +115,7 @@ FIXTURE_TEARDOWN(vfio_pci_driver_test)
>
>         iova_allocator_cleanup(self->iova_allocator);
>         vfio_pci_device_cleanup(self->device);
> +       iommu_cleanup(self->iommu);
>  }
>
>  TEST_F(vfio_pci_driver_test, init_remove)
> @@ -231,18 +234,31 @@ TEST_F_TIMEOUT(vfio_pci_driver_test, memcpy_storm, =
60)
>         ASSERT_NO_MSI(self->msi_fd);
>  }
>
> -int main(int argc, char *argv[])
> +static bool device_has_selftests_driver(const char *bdf)
>  {
>         struct vfio_pci_device *device;
> +       struct iommu *iommu;
> +       bool has_driver;
> +
> +       iommu =3D iommu_init(default_iommu_mode);
> +       device =3D vfio_pci_device_init(device_bdf, iommu);
> +
> +       has_driver =3D !!device->driver.ops;
> +
> +       vfio_pci_device_cleanup(device);
> +       iommu_cleanup(iommu);
>
> +       return has_driver;
> +}
> +
> +int main(int argc, char *argv[])
> +{
>         device_bdf =3D vfio_selftests_get_bdf(&argc, argv);
>
> -       device =3D vfio_pci_device_init(device_bdf, default_iommu_mode);
> -       if (!device->driver.ops) {
> +       if (!device_has_selftests_driver(device_bdf)) {
>                 fprintf(stderr, "No driver found for device %s\n", device=
_bdf);
>                 return KSFT_SKIP;
>         }
> -       vfio_pci_device_cleanup(device);
>
>         return test_harness_run(argc, argv);
>  }
> --
> 2.52.0.rc2.455.g230fcf2819-goog
>

