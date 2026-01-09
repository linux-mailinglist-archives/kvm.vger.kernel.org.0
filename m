Return-Path: <kvm+bounces-67633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9589DD0C00D
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 20:06:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1DCCE3020C06
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 19:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E00A2E7631;
	Fri,  9 Jan 2026 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gLbrtWYl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6022DF719
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767985556; cv=pass; b=j6UNM8xBf42Rq0/NDXwkX+LYLfUGYyiMLdDUc3lBQm/oteARVj+Uci4YZyn+YguUR+b71Y+TlOXCkdISVhX7nZ/H5Yi+tZbZk1PHf4es2639hUEjSSZTSWrNJiVgJ+sPeGqx+Qd40xb1nSH6b2mDli1+RU+av+Jrs87s6meAxyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767985556; c=relaxed/simple;
	bh=r30yWHIvJYSIjkE2WJJ9/Bwq+JHgLd6IARJpcPxcu/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dv9AsCHt9pVt87ie+a7oty0HIyTqhdDMlWYdBv6C8O1f6Fhp5fXnvata2TDUrOmwhXyF1DOvfKl//kPo4yBiWk6pKxgLRSkfcY2EqM0UI0HFMPvBqHnYOpF0iw5hZPBgwpXs9FGSu8NkavLHw/mUK5QD5Hg8++DBxud6wWNsOiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gLbrtWYl; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ffbaaafac4so65161cf.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 11:05:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767985554; cv=none;
        d=google.com; s=arc-20240605;
        b=H+Q3oIoqKzBtAwLXudA5o9Lu0Qge5hb1wJwl++W2ISZHYIAqzoRJPq84rUKQP7BMkf
         Yo1DvB+fo4KLEgJNxezoeauExDDddjKcqyLuOv2KUxMTFOmzju4lPJMaKACCQGD9LnL5
         KK3z48GP/xUKSggbb4NpmP+EmxIpmg+2vmPNV6Mgz5O2JEsWsdwyfF9XlENWjFaNTInc
         eZ7ZUbc1gkLz/sXRtopFAWR/u7RLQjW+I3ckMesHTrA5WRNa4DyedyKn8aZUkMFVzPed
         2vKBgBOHF9Hn2QTJEtuU35vPyLgejq4OYphTHIOq6vVnz6xurFE+F+Pefyb7a9VMm2/0
         cINg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9ft5nMhXTfGwES+fXOJSK+DHN/bCuh84GwyXLcErjqE=;
        fh=kaSdCCW73mJJapSns359e2WVAOU2ONkUdc5AYCNZSyE=;
        b=dDn00JRMvfmVs+KNOGgtx0r2reH/m9CEHruXacgzfzeRhAHsEUtFwFE3aT97RN4bY8
         FkHBXV3nONvAjz5r09WtdO0cdKzxS8aBSRNgW1oMie5hJggx4MWgc+N6WeUZ9Fl0wlaT
         +WCbdEZ4992xHiklH1wnDL6ugTbTyXeJeZzGuUNYSf2Wi7iWyXVfRarbrNj3+XX7XRUB
         pV6/RCb0wYUEiXeNI0Y/2c55K+OenXxGOXGbmO/8gMNG64/dbenSKzM1d4OqoNjk2/1W
         zEKjK0nTeO0s/zy3RqEKg/PB8yxFrEBofC0+7J9opJCGqVzdNs+UKVkxAS+3rXP9vZm0
         f2Cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767985554; x=1768590354; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ft5nMhXTfGwES+fXOJSK+DHN/bCuh84GwyXLcErjqE=;
        b=gLbrtWYlDvQj40yI0IzTn+mB3hq41329xnLJlPLxJoGHXwBk4JIT+/ezgf+hjb90R2
         mzBnS9+GLyMHjTDSia2YBfCf2n81YTWeuOUUeqT5lSB5QG5kenaOKQzROnUOkCo63S2x
         wG8usZp4/yeo5AWdDGvc22HK1Bcepqsnb2O3G6HAxxij20CSrK+sdS2rp0+6CTQQwS3f
         bUT1Rfn7UeGKJWXu61kWaksjpWgWsCPip7vI0xy8gHhm8z46TZhcuwke+IBrTwyQCOWo
         nKm1x7OnuFcqYFQq2P00mkISxR3ZfZF8sTCj2uHZ0+wDoRn63IohZQFJ/mR2wHY5Hcj+
         iarw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767985554; x=1768590354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ft5nMhXTfGwES+fXOJSK+DHN/bCuh84GwyXLcErjqE=;
        b=dziGjmzo5xtiUvXmb75eefVhm3j1fL35KUgbnlwuQmDYbKqDQu+I0l2vXtNWCmq5Ld
         itzSdeB4/40QsnW+EmNzyGdtpL2xTtBI+QXw30bPcCs6rdNocs7U/FSKZCChL2qUH1A9
         zXjmrrGsRwf2yV8Ejiy+xLai70mLKGdK87UQZt6sVO5sYTBBLZIzuxtoRz8Tf35QygmM
         aErcoJ6zLZSaGKF05/hMlR0QO98OP5E/tsoxQ9u6QIQk8NOFriakfXOAg79oyq+aPnmc
         DToSWQkk/gcav+JRCYPQGsKbdT62bp7piVqWvkUw20aFqF7os5p4XsM/l17G694hwGRC
         BRAA==
X-Forwarded-Encrypted: i=1; AJvYcCW0aUNCFWcWiLGG0cmZsDaeEAyYBi3nEbxJdFTDhTi2TckRhA9t988EDLT/OHabOOZNo80=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg++VgTYOPGawszF4JNQIoO9u1jmhATNvgSiMddnrAXjrpDDJp
	33OspNUuc/44Xt3iwYWzDP546t8Xc3F3pvKdDvQox/mmLaZ3L0x9ONtV79+awzmMesd7uzzJflh
	W1FOQdrAKCvoZa21VEG3oAp3RzAC7K8+F3qNCX33S
X-Gm-Gg: AY/fxX6swtPd+X2dAmnRKPkdhgVqIG8uzZkNAt0Pa5z2KLjXvsJ5/rOaY6RH76FLPlk
	4Uh5is5XrrrluV+95u7IEd7eCJ9l/VU6bietGm4WUyRsn9AuUQlMBsMo4H2GEQd+JUdTPgD/pnH
	BpfowUoqFVstqiRBVLPlGFN8NGCNR5DdyQO0oRZwx7M5178vjPyBBQPj4uXXcwxtb+wLk9+Xudx
	Mn3iYQ4lsoRoGUw+3iAaBpsyio6pM3CjaFapUzuIyR5PvuvGvxtAibDAd+zFkFeSG5ZSwn7H+2g
	hQprhVow7vnxWXqBKqBR9M7S4kKb
X-Received: by 2002:a05:622a:1187:b0:4e5:8707:d31 with SMTP id
 d75a77b69052e-5011856b0f5mr1292971cf.7.1767985553232; Fri, 09 Jan 2026
 11:05:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-7-rananta@google.com>
 <aV7qwp4N_G6f_Bt7@google.com>
In-Reply-To: <aV7qwp4N_G6f_Bt7@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 9 Jan 2026 11:05:41 -0800
X-Gm-Features: AQt7F2pYs03KGdW71m3R_wQ1F0_zP_fh27BllEZHbY3dVJknwxXS3eSRqQ2gGqM
Message-ID: <CAJHc60wHXkZm_QU=SUtCGHRrMWfBhBdy209wmdQqnox8Z0-mQg@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] vfio: selftests: Add tests to validate SR-IOV UAPI
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 3:22=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> > Add a selfttest, vfio_pci_sriov_uapi_test.c, to validate the
> > SR-IOV UAPI, including the following cases, iterating over
> > all the IOMMU modes currently supported:
> >  - Setting correct/incorrect/NULL tokens during device init.
> >  - Close the PF device immediately after setting the token.
> >  - Change/override the PF's token after device init.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/testing/selftests/vfio/Makefile         |   1 +
> >  .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 215 ++++++++++++++++++
> >  2 files changed, 216 insertions(+)
> >  create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_te=
st.c
> >
> > diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/self=
tests/vfio/Makefile
> > index 3c796ca99a509..f00a63902fbfb 100644
> > --- a/tools/testing/selftests/vfio/Makefile
> > +++ b/tools/testing/selftests/vfio/Makefile
> > @@ -4,6 +4,7 @@ TEST_GEN_PROGS +=3D vfio_iommufd_setup_test
> >  TEST_GEN_PROGS +=3D vfio_pci_device_test
> >  TEST_GEN_PROGS +=3D vfio_pci_device_init_perf_test
> >  TEST_GEN_PROGS +=3D vfio_pci_driver_test
> > +TEST_GEN_PROGS +=3D vfio_pci_sriov_uapi_test
> >
> >  TEST_FILES +=3D scripts/cleanup.sh
> >  TEST_FILES +=3D scripts/lib.sh
> > diff --git a/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c b/=
tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
> > new file mode 100644
> > index 0000000000000..4c2951d6e049c
> > --- /dev/null
> > +++ b/tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c
> > @@ -0,0 +1,215 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <fcntl.h>
> > +#include <unistd.h>
> > +#include <stdlib.h>
> > +#include <sys/ioctl.h>
> > +#include <linux/limits.h>
> > +
> > +#include <libvfio.h>
> > +
> > +#include "../kselftest_harness.h"
> > +
> > +#define UUID_1 "52ac9bff-3a88-4fbd-901a-0d767c3b6c97"
> > +#define UUID_2 "88594674-90a0-47a9-aea8-9d9b352ac08a"
> > +
> > +static const char *pf_dev_bdf;
>
> nit: I think you could simplify some of the names in this file. This
> code isn't in a library so the names dont' have to be globally unique
> and quite so long.
>
>   s/pf_dev_bdf/pf_bdf/
>   s/vf_dev_bdf/vf_bdf/
>   s/pf_device/pf/
>   s/vf_device/vf/
>   s/test_vfio_pci_container_setup/container_setup/
>   s/test_vfio_pci_iommufd_setup/iommufd_setup/
>   s/test_vfio_pci_device_init/device_init/
>   s/test_vfio_pci_device_cleanup/device_cleanup/
>
> Feel free to ignore this though if you think it makes the names too
> terse.
>
No, I think the short versions are fine. I can change in the next version.

> > +
> > +static int test_vfio_pci_container_setup(struct vfio_pci_device *devic=
e,
> > +                                      const char *bdf,
> > +                                      const char *vf_token)
> > +{
> > +     vfio_pci_group_setup(device, bdf);
> > +     vfio_container_set_iommu(device);
> > +     __vfio_pci_group_get_device_fd(device, bdf, vf_token);
> > +
> > +     /* The device fd will be -1 in case of mismatched tokens */
> > +     return (device->fd < 0);
> > +}
> > +
> > +static int test_vfio_pci_iommufd_setup(struct vfio_pci_device *device,
> > +                                    const char *bdf, const char *vf_to=
ken)
> > +{
> > +     vfio_pci_iommufd_cdev_open(device, bdf);
> > +     return __vfio_device_bind_iommufd(device->fd,
> > +                                       device->iommu->iommufd, vf_toke=
n);
> > +}
> > +
> > +static struct vfio_pci_device *test_vfio_pci_device_init(const char *b=
df,
> > +                                                      struct iommu *io=
mmu,
> > +                                                      const char *vf_t=
oken,
> > +                                                      int *out_ret)
> > +{
> > +     struct vfio_pci_device *device;
> > +
> > +     device =3D calloc(1, sizeof(*device));
> > +     VFIO_ASSERT_NOT_NULL(device);
> > +
> > +     device->iommu =3D iommu;
> > +     device->bdf =3D bdf;
>
> Can you put this in a helper exposed by vfio_pci_device.h? e.g.
> vfio_pci_device_alloc()
>
Is that just to wrap the ASSERT() within? Or were you thinking of
initializing the members as well in there?


> > +
> > +     if (iommu->mode->container_path)
> > +             *out_ret =3D test_vfio_pci_container_setup(device, bdf, v=
f_token);
> > +     else
> > +             *out_ret =3D test_vfio_pci_iommufd_setup(device, bdf, vf_=
token);
> > +
> > +     return device;
> > +}
> > +
> > +static void test_vfio_pci_device_cleanup(struct vfio_pci_device *devic=
e)
> > +{
> > +     if (device->fd > 0)
> > +             VFIO_ASSERT_EQ(close(device->fd), 0);
> > +
> > +     if (device->group_fd)
> > +             VFIO_ASSERT_EQ(close(device->group_fd), 0);
> > +
> > +     free(device);
> > +}
> > +
> > +FIXTURE(vfio_pci_sriov_uapi_test) {
> > +     char vf_dev_bdf[16];
> > +     char vf_driver[32];
> > +     bool sriov_drivers_autoprobe;
> > +};
> > +
> > +FIXTURE_SETUP(vfio_pci_sriov_uapi_test)
> > +{
> > +     int nr_vfs;
> > +     int ret;
> > +
> > +     nr_vfs =3D sysfs_get_sriov_totalvfs(pf_dev_bdf);
> > +     if (nr_vfs < 0)
> > +             SKIP(return, "SR-IOV may not be supported by the device\n=
");
>
> Should this be <=3D 0?
>
Yes, <=3D 0 should be better. I was only aiming for the case where
"Device doesn't support SR-IOV if the file is absent." Looking at the
pci code, I think there's a potential for returning 0, say for a VF or
an error in the PCI config.
I'll update this in v3.

> And replace "the device" with the BDF.
>
Sure

> > +
> > +     nr_vfs =3D sysfs_get_sriov_numvfs(pf_dev_bdf);
> > +     if (nr_vfs !=3D 0)
> > +             SKIP(return, "SR-IOV already configured for the PF\n");
>
> Let's print the BDF and nr_vfs for the user.
>
Sure

> > +
> > +     self->sriov_drivers_autoprobe =3D
> > +             sysfs_get_sriov_drivers_autoprobe(pf_dev_bdf);
> > +     if (self->sriov_drivers_autoprobe)
> > +             sysfs_set_sriov_drivers_autoprobe(pf_dev_bdf, 0);
> > +
> > +     /* Export only one VF for testing */
>
> s/Export/Create/
>
Sure

> > +     sysfs_set_sriov_numvfs(pf_dev_bdf, 1);
> > +
> > +     sysfs_get_sriov_vf_bdf(pf_dev_bdf, 0, self->vf_dev_bdf);
> > +     if (sysfs_get_driver(self->vf_dev_bdf, self->vf_driver) =3D=3D 0)
> > +             sysfs_unbind_driver(self->vf_dev_bdf, self->vf_driver);
>
> This should be impossible since we disabled autoprobing.
>
> > +     sysfs_bind_driver(self->vf_dev_bdf, "vfio-pci");
>
> Some devices also require setting driver_override to "vfio-pci" as well
> so the device can be bound to vfio-pci. Let's just do that
> unconditionally.
>
Sure, I'll include that in v3.

Thank you.
Raghavendra

