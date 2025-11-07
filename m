Return-Path: <kvm+bounces-62257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC5CC3E472
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 03:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 199D34EA974
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 02:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED4C22F1FE6;
	Fri,  7 Nov 2025 02:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RSh1VrRk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B0AF9EC
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 02:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762483576; cv=none; b=He60czt711QOdAQehlHmVfIu9S5LCZsxOX5mt4NewdykkMngBP0RpPFAsAO8gQo/g9ehIQUB/PrKEjGmyzeYP+60cKlK8bqjNGA/6qgVEbuMafJSb0atoQ6m2X2TQMJWGaK8kcUwnQlZaMER6Rbdok8TYCa5L/mOXYOxjXnUq/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762483576; c=relaxed/simple;
	bh=CN5K3yzDftChpk9iPHZj0k8ikaXMoctpj7lZgTmoTc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F55y0ETwuPCHOaPXLlQIVfztTH5+rfDcgHuT7PyP85jX2339L94bQPMWhaF0P4BHtfpklPszXrK5pgFliOlIhkycJzoGA+denTrJlG5IaQ/+erP5bJUnxbaW4F/ZAMYv5x5IlDul+M/MoLbdJOW40bDY0Aj21BUUSD8JcAmjdic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RSh1VrRk; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ea12242d2eso97861cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 18:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762483573; x=1763088373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uNskrK7tJFFsUI2zJYFppzc5EdnT8JZKI21ow7cwyB8=;
        b=RSh1VrRkRu9G+l6cdXQqUza24Sggi4Ps9NH8CoYdIz8IxNh/2whQfti/xH4CRbETlk
         8j+m7IdliEZMbULVcbLBvomCQ8I7FYMS8f9iLhYdpofw43046Vo6uOCeRKw5qkvJ17eF
         xz1d0lWhnXR8iV7U2cvUxZyyhk0we6l0foMUA3JqZRpvbF9+c7qD1KJ9BkKv438DGXMu
         W1UTurIZlYiM0IKJj0NOjUV+YMfJ6m1PdPJ3FHJclSykeoJuV8+dzFtAqG6fpBY1cyYq
         JnxJ3t/s5KTnL0tvlyJ1DuqB8sXaqGoIxl6HzhthNeEWkDGZNUin78aefgWRT3LsYak5
         JWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762483573; x=1763088373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uNskrK7tJFFsUI2zJYFppzc5EdnT8JZKI21ow7cwyB8=;
        b=bRnIufZHd3JFqZnXJgesWQyUcLxY84Wl8/d3SziB9EW4/njiS6YbOm9emo7dvYJP6V
         VluQ9WbaYVuWuNx5R9nnEQX7KkWIWV4Qly/FQXWtIObmeb5J+QnDpgFbQ0pZrFznOrJF
         X23qalg85p1BcreeabH1t1uhBxHUSK1h9drn06+E4VDfjIBwldAeNXSmfKzX6Q5WUNy6
         08yp8X8kIgRJp3PZV8jzz6WNtM7AChQFDw/lLKqD5bgaGwcvYSHjgSJ+xjqoVwe0Pa7s
         O2+YW8UV39yvl5/Kc7x/HkywovDzwxl7yGBARtc2xHNiADTnG/ByFzGXUFya79sD/36/
         0WKA==
X-Forwarded-Encrypted: i=1; AJvYcCVeLeMdXaD3kCBXZp4bqa0nq+p7/lEK6NbYAkTbu3lG3MUFOAF1s+VCdnCoQY1thKgDMI4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yymw/fF7Bo7smHpYK/1IISNEf0Qqi2kvs3DSRVLwlM1Z9peu2eG
	wfuYzssoN1oOjtFWrxBmxzOwZcZGVzKvgvg0+z+AQdjFSz8S8zLp0mIk2mkfQNzQtBlC9cjl6Sz
	smogI6MZr2bSeNzhrM1Qb5ra45zyoNPPkcWUR2Jz0
X-Gm-Gg: ASbGncuNPLjkuLCX+NNPhxWn9ReYLPHPnKuCX/kgxGXnko2HtShrp6mpEIcatb7cTgP
	ttcK6nctq6QGq06jN4/Q1gtd4yzfxYci02rrV3Nr8mv+SSMNtNbGB8NaWrIwiPTR66HVkJVBRbG
	SPcJC+Uwn1zKoX09xslCPoXm6a5NI65cvWonaEbnDk8cj6VDAvmNA7hOk3ODV5M+r9XdKY57aJh
	HhV3nH9bqAmkZPBjZBS6imRV6BdM6MOfdgP0d1GSVjO3jA3vwuApv0Pgogs7rUyx/AbbGg=
X-Google-Smtp-Source: AGHT+IEorFy/XQylN//cdx26SVjPxbveC2oreM7dnrKJ9wDt0WGW6CjtWa1f25tjWXKFtnzqz/Udq0wK7cTgvWyhDm0=
X-Received: by 2002:a05:622a:14cb:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4ed955ca3ecmr2689741cf.0.1762483572542; Thu, 06 Nov 2025
 18:46:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com> <20251104003536.3601931-2-rananta@google.com>
 <aQvjQDwU3f0crccT@google.com> <CAJHc60xb_=v9k46MEo=6S5QmMXKnd_1FiuWQr9dkCnE_XtTkfQ@mail.gmail.com>
 <aQzYOjWPs0qsW4YR@google.com>
In-Reply-To: <aQzYOjWPs0qsW4YR@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Fri, 7 Nov 2025 08:16:01 +0530
X-Gm-Features: AWmQ_blJnQHSRhtNMwi529tokKmsZ3S89cLrOC2vc6Yi1GAzpBOsvHyg-TXYXtU
Message-ID: <CAJHc60y0KA00KmcW09ft-O_oUwp=5Wr9nBpF8RtYytrQ2tFYaw@mail.gmail.com>
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 10:47=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2025-11-06 09:56 PM, Raghavendra Rao Ananta wrote:
> > On Thu, Nov 6, 2025 at 5:22=E2=80=AFAM David Matlack <dmatlack@google.c=
om> wrote:
> > > On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> > >
> > > > -struct vfio_pci_device *vfio_pci_device_init(const char *bdf, cons=
t char *iommu_mode);
> > > > +struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > > > +                                           const char *iommu_mode,
> > > > +                                           const char *vf_token);
> > >
> > > Vipin is also looking at adding an optional parameter to
> > > vfio_pci_device_init():
> > > https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.c=
om/
> > >
> > > I am wondering if we should support an options struct for such
> > > parameters. e.g. something like this
> > >
> > > diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/t=
ools/testing/selftests/vfio/lib/include/vfio_util.h
> > > index b01068d98fda..cee837fe561c 100644
> > > --- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
> > > +++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
> > > @@ -160,6 +160,10 @@ struct vfio_pci_driver {
> > >         int msi;
> > >  };
> > >
> > > +struct vfio_pci_device_options {
> > > +       const char *vf_token;
> > > +};
> > > +
> > >  struct vfio_pci_device {
> > >         int fd;
> > >
> > > @@ -202,9 +206,18 @@ const char *vfio_pci_get_cdev_path(const char *b=
df);
> > >
> > >  extern const char *default_iommu_mode;
> > >
> > > -struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > > -                                             const char *iommu_mode,
> > > -                                             const char *vf_token);
> > > +struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
> > > +                                              const char *iommu_mode=
,
> > > +                                              const struct vfio_pci_=
device_options *options);
> > > +
> > > +static inline struct vfio_pci_device *vfio_pci_device_init(const cha=
r *bdf,
> > > +                                                          const char=
 *iommu_mode)
> > > +{
> > > +       static const struct vfio_pci_device_options default_options =
=3D {};
> > > +
> > > +       return __vfio_pci_device_init(bdf, iommu_mode, &default_optio=
ns);
> > > +}
> > > +
> > >
> > > This will avoid you having to update every test.
> > >
> > > You can create a helper function in vfio_pci_sriov_uapi_test.c to cal=
l
> > > __vfio_pci_device_init() and abstract away the options stuff from you=
r
> > > test.
> > >
> > I like the idea of an optional expandable struct. I'll implement this i=
n v2.
>
> Just to make sure we're on the same page: I don't think you need to add
> this in v2 since you don't need to call vfio_pci_device_init(). For the
> inner functions that you want to call from your test, passing vf_token
> directly makes more sense IMO. vfio_pci_device_init() will just pass in
> NULL to those functions for vf_token by default.
>
> If/when we want to pass vf_token to vfio_pci_device_init() we can add
> the options struct.
>
Yes, of course. I'll avoid it until we have a need.

> > > No space necessary after a cast. This is another one checkpatch.pl wi=
ll
> > > catch for you.
> > >
> > >   CHECK:SPACING: No space is necessary after a cast
> > >   #81: FILE: tools/testing/selftests/vfio/lib/vfio_pci_device.c:338:
> > >   +       char *arg =3D (char *) bdf;
> > >
> > Actually, I did run checkpatch.pl on the entire series as:
> > .$ ./scripts/checkpatch.pl *.patch
> >
> > I didn't see any of these warnings. Are there any other options to cons=
ider?
>
> Ah, I run with a few additional options. That's probably why we are
> seeing different output. Here's what I have in my .bashrc:
>
> function checkpatch() {
>         scripts/checkpatch.pl \
>                 -q \
>                 --strict \
>                 --codespell \
>                 --no-signoff \
>                 --show-types \
>                 --ignore gerrit_change_id,FILE_PATH_CHANGES,NOT_UNIFIED_D=
IFF \
>                 --no-summary \
>                 "$@"
> }
Thanks! I'll give this a shot!

