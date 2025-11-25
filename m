Return-Path: <kvm+bounces-64531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D24AC863EA
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A76894EA412
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B64032B9BA;
	Tue, 25 Nov 2025 17:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mvWH/Y6a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC72329C57
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764092267; cv=none; b=XYNj5VQEhQHUbbAyZWoA9gMAH1PrAMpTG9RIxw6XUsucBL5v1oPm9jFe3yqX5fDoh2/Il85O5I9gOg2xWhj46yx1YEO1IOp79aCgd3xgppjhoV7iqzOSKP/nWjnqH5cNTtV4zEXDGAdPzYopLr8AHAoyk08i2HVnwe1VL5XG5oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764092267; c=relaxed/simple;
	bh=Ejku2oAgTG0MLuTVF5tg29vzUgVV+nOFGngep+HFdYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lkKL1CWzCgF406jgarQovIsgtjkmo9w9z6NLU33zyRAysYrQaGLrGpJ/fsqKuLy5bh2ZH9y2VtGABxpiEo2BGBArq5WkboLdNbdkXnZM/vTf1o+1ijXHSXdRKyFusmx2XOWuPVVNaBxqwOxLmRNAU1vsP/tb1PXHl++I7tBGznw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mvWH/Y6a; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59428d2d975so6147146e87.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 09:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764092264; x=1764697064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okuVuEMd31Qt38di8puew2SNgGFFbYVoFM6SMy0UZTM=;
        b=mvWH/Y6a0gOX72i6jbzraxSdj+3VNfQ3NTamm8f38en5UJzj3HO74sPtezSQPCyYY8
         eddkgtKG2BGrE2tOcrznnH8jUlQvClIjuB5I3xR+r+Hn9+ei1pUe8bl5rTzS18ZQZG+D
         zXjfoaRLkMq0QfjFdS8YOS5dTJA0tC0K5fc38nWDOzafYEKcK1BkaVAhvocVzqfjxfaN
         CXssgDARPE82kPMBkl76AZWSQnz387BsvSC6E9FG2w7wn4RpUVrkxZakntsagcMNSWuC
         EF5YTI3pvOqAUikxBpBVuI42k7HF26gwVvg7jMQPyr/+YQRNsdW1ORAMNCQ87t7TM5lo
         Yz8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764092264; x=1764697064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=okuVuEMd31Qt38di8puew2SNgGFFbYVoFM6SMy0UZTM=;
        b=J4Qe/ytB21MXrJxLkxqXPSUAME5ZxgBvlCVkKRbf5/PZ9mwPO480firR34skO9N51P
         5vIN1fBTgJ5KZA8D2jny+jHvqU30NXLjpx/esfMaIfY5UXRc+AftEX8jd5CP0VOGUiAI
         iXo80pUlwDsFNEDsmbTm2Og5HS4MOvcXRCTSt8ygIDpW01se/t8TFxFxj9A0gp41Fkug
         +wHJ5d5syn40rJd27kKW2o+TB24QUydBM1RpizMA7uoVW3VD0MjAsPHkQA7zNeDw53wX
         cj788QuUzaPN22K7S2UZT6xbNdPN/JFPR14RTbPHEh9oHZPW+Q5/oujg6Mk9WLPmjqZb
         IOHw==
X-Forwarded-Encrypted: i=1; AJvYcCVrF8OOwnz2RzdrxC2vOOh6h2tiBqk8+RnRjiJcAqOEjvVlBX59auREcFkStEGg2LZGACc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXOqFnEQV4EHRZ/Caxq4pcPfdC6K4bBBDPkjMhaLLcNlkSR+ew
	uPcurKD86QT7t4yslDjbtazv73nUIHwm8L1nyhyWNOaNVI4oTpkW+g6aNV6v2cJkGJXR60Bwaor
	X52UUXmtm7IQIZGfHsAbArZAwMmkgKYQ0fhC/eWwL
X-Gm-Gg: ASbGnctXQWyRahKQWd/5HkapX5DLGJ4bp96vB4D5F5CDQBv75nXS+C20OWMcOoq5UOl
	fivqFMDyMNYUaOVUJRdJpjS/nCDePxQu31FDPrsKebMC1a36RHuYVLfFegHQ4L2bSsi+aOBK2lT
	QG9Ovro62O+uElwkScHMjkSd323tVJ0cQWcliqeAa8k/ETlk8EfQ+Ygx8JOLPMXERnbGh1zsDOF
	PujOyCoVxB7V/ZJk6LXpbH5Tr2DEdwy5A6YreL7xVYJoBwU6NYUCEQ0GENnGQnrlDLFTh0=
X-Google-Smtp-Source: AGHT+IEvpHau791IAO0dltg1a3e0hjW7a5btTqdQz225JT89zGJmvQWbORKrFwH0dVFgXeulmu9pimYSiYV6QIzPdaM=
X-Received: by 2002:a05:6512:12c7:b0:594:cb92:b377 with SMTP id
 2adb3069b0e04-596b52909b2mr1546440e87.42.1764092263437; Tue, 25 Nov 2025
 09:37:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121181429.1421717-1-dmatlack@google.com> <20251121181429.1421717-7-dmatlack@google.com>
 <CAJHc60zW+FzOfUQzZYCStmFJ_d8Gr2mi-nN297b=gU+26mt1BQ@mail.gmail.com>
In-Reply-To: <CAJHc60zW+FzOfUQzZYCStmFJ_d8Gr2mi-nN297b=gU+26mt1BQ@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 25 Nov 2025 09:37:15 -0800
X-Gm-Features: AWmQ_blXo2R832vAXskZpPadEWRx5jQ3IoP9HQvzSngDu_3AkgqN5_Y8TmlJRuQ
Message-ID: <CALzav=fseMCyQEvBsJa+J+_V=1S3MX_7sArEksGYUQAey==70g@mail.gmail.com>
Subject: Re: [PATCH v3 06/18] vfio: selftests: Support multiple devices in the
 same container/iommufd
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 3:17=E2=80=AFAM Raghavendra Rao Ananta
<rananta@google.com> wrote:
> On Fri, Nov 21, 2025 at 11:44=E2=80=AFPM David Matlack <dmatlack@google.c=
om> wrote:
> > +struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct i=
ommu *iommu)
> >  {
> >         struct vfio_pci_device *device;
> >
> >         device =3D calloc(1, sizeof(*device));
> >         VFIO_ASSERT_NOT_NULL(device);
> >
> > -       device->iommu =3D calloc(1, sizeof(*device->iommu));
> > -       VFIO_ASSERT_NOT_NULL(device->iommu);
> > -
> > -       INIT_LIST_HEAD(&device->iommu->dma_regions);
> > -
> > -       device->iommu->mode =3D lookup_iommu_mode(iommu_mode);
> > +       device->iommu =3D iommu;
> nit: Since we now depend on the caller to follow the right order,
> should we have a VFIO_ASSERT_NOT_NULL(iommu), or something along the
> lines of 'Is iommu initialized?" before this function starts using it,
> and fail with an appropriate error message?

I think the compiler and type system largely enforce the order now.
The compiler will complain if a user passes in an uninitialized struct
iommu *. And the only way to initialize it is with iommu_init(). I
guess someone could pass in NULL, so having an explicit assert for
non-null would be easier to debug than a SIGSEGV. I'll add that in v4.

>
> >
> >         if (device->iommu->mode->container_path)
> minor nit: if there's a v4, simply use iommu->mode->container_path.

Yes, thanks, will do!

