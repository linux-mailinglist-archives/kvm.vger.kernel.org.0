Return-Path: <kvm+bounces-67475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9B9D064A7
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EE84302B12B
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726783370F4;
	Thu,  8 Jan 2026 21:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o4qHk2VB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AAB20C477
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 21:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767907534; cv=pass; b=e3P37qZD3HgtOTEJx7xzggTNthNKOSkAaOBWYzzWA6oqWEaSCjs1mONwi4uNDPqN0SuUKv5HG3v0kRUMwnKD5o5u2vKyoq+L4PRbg4MkTBBM+hTGYlrwDcm6UlId/ySPnLCGt3hudzZarhON1F0H+VmzEIXy6qxmBxWgrWBOS7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767907534; c=relaxed/simple;
	bh=nAHaxAjxx1h0Dm46m+zzBiQGvEZ1ecRtZbeCnlPRCMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KRKJrgmbJNhZoyMcSqhE6L+itn3kM9KBAdXsEo8uRAvtqQ7xJE/bqFmbCwFmyebXTi2yJg6h0BB7RQ2AYrW2jspT6IdEUFub3799BE8oZ5DOtDKt4cZGZ2saA2NyoRf7OWAPMAsdErbF2kzUiy9GErR+nLpuuTHrKSllpzQjwh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o4qHk2VB; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ee147baf7bso43701cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 13:25:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767907532; cv=none;
        d=google.com; s=arc-20240605;
        b=TBe1h1k7oQ7/e09Dw0AShevijc2dzgE+LblRSDty/r8l/2ODiFrNkQTgXsDIZJMaYy
         CE7cop6kdvUXv64s4dHgNru/joJP22ndlAcH+IWnS9hEiiNf1R5mG5fDm8TnV6iF6iTV
         KcSoWzjOMt5YqzNJEUn6pY8eAtDfJkC+JUNCQDichYWjQEMt4GfX5ivG2z1rll4JUQPD
         oMWjx3q9ElgH3z7dbHFYnjNA+PGqKN06EztmQfCa6a+Cz5PsBvTh9kn1uQ7nf0xxWnas
         4FDcK2Ab4t3Z9AFU/+i5v1i1f9F5rCFwugj+IwvlntZtTNrjzFFbHnhtmw2zv1JBrzjL
         NJOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vZoFdt8/tz//O2llLLyn4wE8/yLpzuaTdZJvYRJkOcU=;
        fh=eCSCKFL9/MXSOo8qRz2UM22e10WujacKxzsYIDNoLLg=;
        b=l3swrbRHIlKQI63sDtu6IDQRySE7tWFJm9c3rKIZGJpb/7+gP4OB08Sd2N0hu02ymM
         GEsX6tIl7mCFwf06PtOt/B5ndBgur8vVybPgvMZUsDFdd+IbDjtmUBDTaaYJ1ev/vfUU
         eht0Tfk7XejoEwB6lLztIgYsTyqQJtpS5KU9FGVwtB6ay2YqsX7AX7qsxe61FGhFxDuO
         qqR0qk7bJajYRkEuyYcEIOJ94J6UnfowssZnMtG509Zk6XaxdBEP/evAqVUuaIBYBM4h
         HspwLkv9PmB6tks5wJ+2AqvzJ0jdD7FNEbVqlKdnPBr1GEf9BbXp/QBFGLQigqhq8iZU
         b17g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767907532; x=1768512332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZoFdt8/tz//O2llLLyn4wE8/yLpzuaTdZJvYRJkOcU=;
        b=o4qHk2VB9RNJKFiGZGyTwXug4nfAEmTr6qoviv7TuoVEhk8PagvaZhs7l1vPyXtgkH
         BQDI0vT09nzLZBYvXSiMm/ZPVvthldi/i28bi7mpMnHoGoSuoId3Uov554n/U9l0k7rV
         nvcQ8zx24BqFSpJMNTXCGmV5HujlcS1xpkKS6u0eXZNAQ2BzbQz/SiY19w//xQLF9Avd
         c+71pir7EBUziTjo+fmgMxqum/gvMnjzNmP6wyHnDKuSvELCG2fceUv0thHl+DG/waBz
         2SJCQmWHPY1/SbO9dyEEW4oLSRFJe5SRNSxrlyLM/98jEDMc/ndCXfYGElCtiG58XIdJ
         cI3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767907532; x=1768512332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vZoFdt8/tz//O2llLLyn4wE8/yLpzuaTdZJvYRJkOcU=;
        b=nDnd+i2q2N0aKbwRUxhNMUo1i4jdMA0rQz92lidqcgljKdVxINEGsBRnwRH4o7Ausq
         Muuz0xEsAclMP5g2fsuoluOA+OTkh6Y8ylLYk90c874P0A11bG2/tjvLsaAAQHiX1jgY
         OETwb8s5WWbU54yc9RY/v+BUSzPunrYC1xq4XcElaygc86y0GJEPufwCPK25x+nCwIoO
         xsatCuLMvL/sE/hv50vYJy3LbLhZAst/UDb0dLo3xFyELWQV5993ZNnl292FOsbbzH0y
         hWAdGLzea6uyUPatgWlFF1zNQpA/AUAwRGkr8bh2vAJiM6KPgSTzlI8+BoGGDCzjSCcO
         QJdg==
X-Forwarded-Encrypted: i=1; AJvYcCUCzz2L2DiLkmyqJS5/OTq+fXRpiycfKfxZabHIJI5NOxCt6RpG1V5OxafZJTx9tZ32EYo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4iFPotT80auwSr77LPjpb1ZKWe4oCrWoaOyGLOh9fFRfGca+O
	KxShBMVb2PPSknVT3w0CpatcQHhx/5CMznPMNifA/tdR+cKzMzW9xWrkGq7ruXVEgGl4Q3vA0zp
	PYgy2D+5ylBWF2rIABbb4v3cF+W2RIVZiJ4LSv3CK
X-Gm-Gg: AY/fxX45OuTvXuZhn4knuSxgyGjH/XvQ+31HbxWFa9A8UEayy5wugcL2Qyo6R1wCdKk
	FIn5t3rUQzkrn/4/O35WipaHEOtHBorrYW9DZddQ3GoymxKnZqnwV8EWL+CnxGdkyCoFykpSY24
	F+tzu+adu+7O9Vdl2KoTphmCei0thF+XXpThxwA99TCFZig+6OaowaH35Z+jvUOuLTES5dt/iVG
	g0qob7g+QpTjKLeMmv4l1THy+gcFmfJmu6193eA16T0lI8cuGY/dQIKcNT6N6zrwO4ACNm//+fE
	GVzm7F6PCJ/RorOIKoGrYIzpXexGFp26bi5g
X-Received: by 2002:a05:622a:508:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-4ffca3ad5b8mr2989771cf.18.1767907531627; Thu, 08 Jan 2026
 13:25:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-3-rananta@google.com>
 <aV7hDIe3tvehETXS@google.com>
In-Reply-To: <aV7hDIe3tvehETXS@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 8 Jan 2026 13:25:19 -0800
X-Gm-Features: AQt7F2p_yoVi5pOazSYCNJ6UBD6BfgkoSDcBEpk1Ok4IyvDvsvYrsLT94x4m148
Message-ID: <CAJHc60z49qAhPkug25Gm-TU_pqgSius7LndkhuEam54ZhKWYMg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] vfio: selftests: Introduce a sysfs lib
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 2:41=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
> > Introduce a sysfs liibrary to handle the common reads/writes to the
>                     library
>
> > PCI sysfs files, for example, getting the total number of VFs supported
> > by the device via /sys/bus/pci/devices/$BDF/sriov_totalvfs. The library
> > will be used in the upcoming test patch to configure the VFs for a give=
n
> > PF device.
> >
> > Opportunistically, move vfio_pci_get_group_from_dev() to this library a=
s
> > it falls under the same bucket. Rename it to sysfs_get_device_group() t=
o
> > align with other function names.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/vfio/lib/include/libvfio.h      |   1 +
> >  .../vfio/lib/include/libvfio/sysfs.h          |  16 ++
> >  tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
> >  tools/testing/selftests/vfio/lib/sysfs.c      | 151 ++++++++++++++++++
> >  .../selftests/vfio/lib/vfio_pci_device.c      |  22 +--
> >  5 files changed, 170 insertions(+), 21 deletions(-)
> >  create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sy=
sfs.h
> >  create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools=
/testing/selftests/vfio/lib/include/libvfio.h
> > index 279ddcd701944..bbe1d7616a648 100644
> > --- a/tools/testing/selftests/vfio/lib/include/libvfio.h
> > +++ b/tools/testing/selftests/vfio/lib/include/libvfio.h
> > @@ -5,6 +5,7 @@
> >  #include <libvfio/assert.h>
> >  #include <libvfio/iommu.h>
> >  #include <libvfio/iova_allocator.h>
> > +#include <libvfio/sysfs.h>
> >  #include <libvfio/vfio_pci_device.h>
> >  #include <libvfio/vfio_pci_driver.h>
> >
> > diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h b=
/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> > new file mode 100644
> > index 0000000000000..1eca6b5cbcfcc
> > --- /dev/null
> > +++ b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
> > @@ -0,0 +1,16 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +#ifndef SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> > +#define SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H
> > +
> > +int sysfs_get_sriov_totalvfs(const char *bdf);
> > +int sysfs_get_sriov_numvfs(const char *bdf);
> > +void sysfs_set_sriov_numvfs(const char *bdfs, int numvfs);
> > +void sysfs_get_sriov_vf_bdf(const char *pf_bdf, int i, char *out_vf_bd=
f);
> > +bool sysfs_get_sriov_drivers_autoprobe(const char *bdf);
> > +void sysfs_set_sriov_drivers_autoprobe(const char *bdf, bool val);
> > +void sysfs_bind_driver(const char *bdf, const char *driver);
> > +void sysfs_unbind_driver(const char *bdf, const char *driver);
> > +int sysfs_get_driver(const char *bdf, char *out_driver);
> > +unsigned int sysfs_get_device_group(const char *bdf);
> > +
> > +#endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_SYSFS_H */
> > diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testin=
g/selftests/vfio/lib/libvfio.mk
> > index 9f47bceed16f4..b7857319c3f1f 100644
> > --- a/tools/testing/selftests/vfio/lib/libvfio.mk
> > +++ b/tools/testing/selftests/vfio/lib/libvfio.mk
> > @@ -6,6 +6,7 @@ LIBVFIO_SRCDIR :=3D $(selfdir)/vfio/lib
> >  LIBVFIO_C :=3D iommu.c
> >  LIBVFIO_C +=3D iova_allocator.c
> >  LIBVFIO_C +=3D libvfio.c
> > +LIBVFIO_C +=3D sysfs.c
> >  LIBVFIO_C +=3D vfio_pci_device.c
> >  LIBVFIO_C +=3D vfio_pci_driver.c
> >
> > diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/s=
elftests/vfio/lib/sysfs.c
> > new file mode 100644
> > index 0000000000000..5551e8b981075
> > --- /dev/null
> > +++ b/tools/testing/selftests/vfio/lib/sysfs.c
> > @@ -0,0 +1,151 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <fcntl.h>
> > +#include <unistd.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <linux/limits.h>
> > +
> > +#include <libvfio.h>
> > +
> > +static int sysfs_get_val(const char *component, const char *name,
>
> nit: I'm partial to putting the verbs at the end of function names for
> library calls.
>
> e.g.
>
>   vfio_pci_config_read()
>   vfio_pci_config_write()
>   vfio_pci_msi_enable()
>   vfio_pci_msi_disable()
>
> So these would be:
>
>   sysfs_val_set()
>   sysfs_val_get()
>   sysfs_device_val_set()
>   sysfs_device_val_get()
>   sysfs_sriov_numvfs_set()
>   sysfs_sriov_numvfs_get()
>   ...
>
> > +                      const char *file)
> > +{
> > +     char path[PATH_MAX] =3D {0};
> > +     char buf[32] =3D {0};
>
> nit: You don't need to zero-initialize these since you only use them
> after they are intitialized below.
>
> > +     int fd;
> > +
> > +     snprintf(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name=
, file);
>
> Use the new snprintf_assert() :)
>
> > +     fd =3D open(path, O_RDONLY);
> > +     if (fd < 0)
> > +             return fd;
> > +
> > +     VFIO_ASSERT_GT(read(fd, buf, ARRAY_SIZE(buf)), 0);
> > +     VFIO_ASSERT_EQ(close(fd), 0);
> > +
> > +     return strtol(buf, NULL, 0);
> > +}
> > +
> > +static void sysfs_set_val(const char *component, const char *name,
> > +                       const char *file, const char *val)
> > +{
> > +     char path[PATH_MAX] =3D {0};
>
> Ditto here about zero-intialization being unnecessary.
>
> > +     int fd;
> > +
> > +     snprintf(path, PATH_MAX, "/sys/bus/pci/%s/%s/%s", component, name=
, file);
>
> Ditto here about snprintf_assert()
>
> You get the idea... I won't comment on the ones below.
>
> > +     VFIO_ASSERT_GT(fd =3D open(path, O_WRONLY), 0);
> > +
> > +     VFIO_ASSERT_EQ(write(fd, val, strlen(val)), strlen(val));
> > +     VFIO_ASSERT_EQ(close(fd), 0);
> > +}
> > +
> > +static int sysfs_get_device_val(const char *bdf, const char *file)
> > +{
> > +     sysfs_get_val("devices", bdf, file);
> > +}
> > +
> > +static void sysfs_set_device_val(const char *bdf, const char *file, co=
nst char *val)
> > +{
> > +     sysfs_set_val("devices", bdf, file, val);
> > +}
> > +
> > +static void sysfs_set_driver_val(const char *driver, const char *file,=
 const char *val)
> > +{
> > +     sysfs_set_val("drivers", driver, file, val);
> > +}
> > +
> > +static void sysfs_set_device_val_int(const char *bdf, const char *file=
, int val)
> > +{
> > +     char val_str[32] =3D {0};
> > +
> > +     snprintf(val_str, sizeof(val_str), "%d", val);
> > +     sysfs_set_device_val(bdf, file, val_str);
> > +}
> > +
> > +int sysfs_get_sriov_totalvfs(const char *bdf)
> > +{
> > +     return sysfs_get_device_val(bdf, "sriov_totalvfs");
> > +}
> > +
> > +int sysfs_get_sriov_numvfs(const char *bdf)
> > +{
> > +     return sysfs_get_device_val(bdf, "sriov_numvfs");
> > +}
> > +
> > +void sysfs_set_sriov_numvfs(const char *bdf, int numvfs)
> > +{
> > +     sysfs_set_device_val_int(bdf, "sriov_numvfs", numvfs);
> > +}
> > +
> > +bool sysfs_get_sriov_drivers_autoprobe(const char *bdf)
> > +{
> > +     return (bool)sysfs_get_device_val(bdf, "sriov_drivers_autoprobe")=
;
> > +}
> > +
> > +void sysfs_set_sriov_drivers_autoprobe(const char *bdf, bool val)
> > +{
> > +     sysfs_set_device_val_int(bdf, "sriov_drivers_autoprobe", val);
> > +}
> > +
> > +void sysfs_bind_driver(const char *bdf, const char *driver)
> > +{
> > +     sysfs_set_driver_val(driver, "bind", bdf);
> > +}
> > +
> > +void sysfs_unbind_driver(const char *bdf, const char *driver)
> > +{
> > +     sysfs_set_driver_val(driver, "unbind", bdf);
> > +}
> > +
> > +void sysfs_get_sriov_vf_bdf(const char *pf_bdf, int i, char *out_vf_bd=
f)
> > +{
> > +     char vf_path[PATH_MAX] =3D {0};
> > +     char path[PATH_MAX] =3D {0};
> > +     int ret;
> > +
> > +     snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/virtfn%d", pf_b=
df, i);
> > +
> > +     ret =3D readlink(path, vf_path, PATH_MAX);
> > +     VFIO_ASSERT_NE(ret, -1);
> > +
> > +     ret =3D sscanf(basename(vf_path), "%s", out_vf_bdf);
> > +     VFIO_ASSERT_EQ(ret, 1);
> > +}
> > +
> > +unsigned int sysfs_get_device_group(const char *bdf)
>
> nit: s/device_group/iommu_group/
>
> > +{
> > +     char dev_iommu_group_path[PATH_MAX] =3D {0};
> > +     char path[PATH_MAX] =3D {0};
> > +     unsigned int group;
> > +     int ret;
> > +
> > +     snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/iommu_group", b=
df);
> > +
> > +     ret =3D readlink(path, dev_iommu_group_path, sizeof(dev_iommu_gro=
up_path));
> > +     VFIO_ASSERT_NE(ret, -1, "Failed to get the IOMMU group for device=
: %s\n", bdf);
> > +
> > +     ret =3D sscanf(basename(dev_iommu_group_path), "%u", &group);
> > +     VFIO_ASSERT_EQ(ret, 1, "Failed to get the IOMMU group for device:=
 %s\n", bdf);
> > +
> > +     return group;
> > +}
> > +
> > +int sysfs_get_driver(const char *bdf, char *out_driver)
> > +{
> > +     char driver_path[PATH_MAX] =3D {0};
> > +     char path[PATH_MAX] =3D {0};
> > +     int ret;
> > +
> > +     snprintf(path, PATH_MAX, "/sys/bus/pci/devices/%s/driver", bdf);
> > +     ret =3D readlink(path, driver_path, PATH_MAX);
> > +     if (ret =3D=3D -1) {
> > +             if (errno =3D=3D ENOENT)
> > +                     return -1;
> > +
> > +             VFIO_FAIL("Failed to read %s\n", path);
> > +     }
> > +
> > +     ret =3D sscanf(basename(driver_path), "%s", out_driver);
>
> I think this is equivalent to:
>
>   out_driver =3D basename(driver_path);
>
> ... which means out_driver to point within driver_path, which is stack
> allocated? I think you want to do strcpy() after basename() to copy the
> driver name to out_driver.
>
> Also how do you prevent overflowing out_driver? Maybe it would be
> cleaner for sysfs_get_driver() to allocate out_driver and return it to
> the caller?
>
> We can return an empty string for the ENOENT case.
>
Good point. Better to alloc 'out_driver'.

I'll take care of this and other nits that you pointed out in v3.

Thank you.
Raghavendra

