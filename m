Return-Path: <kvm+bounces-62481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50904C44DB3
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1606C188D6AA
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27D3288505;
	Mon, 10 Nov 2025 03:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zFDFB6tZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C72D21CFFD
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762746332; cv=none; b=ti/GGjKmbBdoKe7V2fQi7TU34NUz/eS3sDp0wHMHmUgOvCBjVa+nDNaHEC+FnHzBm4Dq4kKPZoI/8c+cPGu1N0FbzOngmDcmFA9dU1vG3oo1G23JZm8LwriG7IBukKsnaDTf3nCWWqnu/V3azIm+u08a7bIz66mpk2Bey0xiMEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762746332; c=relaxed/simple;
	bh=bEaPGuay/6gbRMrtAIFDUCiDY7Ufhk5Da+3wjvGIHDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R2NMR3isQI1qGNp1Q5E3Ok4MyJnUZvtOWX3HfVmMXgqAP/kul9LCvSQiNPpvWKP41Z0dl2Zhx2fjRhNKsgQ7ZmcDMPW6jX0TPMGoMqL44J+fUF46Ze9kEuJq2o5Txu0Q5mlo60PfRXnPM7Dlj5q8NiCfZEqWnF6FGl6QrN2S/Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zFDFB6tZ; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edb8d6e98aso126631cf.0
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762746330; x=1763351130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pO1+WA3Lo3SzoRELtMhVMVFvpwqIDn7YXcebJoNLSSY=;
        b=zFDFB6tZaZ8KYrihoBtwGml6HUUIMCBVWgUdlNFfJf4I/DyNn3S0bheMyLituYhUQf
         pYTNV0GlxiGYyQvqfLADL26ussAsRb0X4Q9rBKD+nZo8AOU/9YjKT0Y1ZKlPwzx9MVtw
         qdSwUB2giX/EDhLUxo7VIJn+eZ71VCFvMDAa2j8gTu+M7cB5YxLbw/kou/Plre9B+FgC
         LTSBj68HsIos+Sd6asp0XfMgJRrVbbTmiYWmzwqgqyFHEVF98s87mA0EZ0cGIN67AeLz
         1iBkq9gjho3p2vgXVIMk8F/f4SzQv7G28JOAZhEyJA5l4GUmKoleWw2xYBuhbuA/9iD6
         cXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762746330; x=1763351130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pO1+WA3Lo3SzoRELtMhVMVFvpwqIDn7YXcebJoNLSSY=;
        b=sO3khPJqMcYaGyeRLYCIbxd0XQ1q03neQyR3rkbhkpaytkS521dmEEoTESP+Y/sllj
         /MXe4Y5KvjCTOPMtzQfgKJ2Nyq7wved6sR9d2Ra5cCCAM2KNDTiBaA2AHZV/cRNhhYAA
         vayC5gRGkzcAePhheA3tmB1Qp9Ncfc1OfcZ94+KuMpIdgtUZYSF7sXHda18OBxK4y2mS
         R23MPnKV0SlGw2Kx7V1BrdVxg1Dy9sVlZcyrF2uy3KHQC7l2zyHjXpinHf0TVMHF8KHb
         +5iUOXdxVOb/dbwM/EOacPnm3VvOdItuiaeI3CW0EsS7o9+h74Z67djFVnw4CqVCYyR1
         Fz7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqzh61NJ8NxmO98GbbfPepwQVn3BCUnHXtyKtcy0JEyNjKaS9hpY86zpMGTot5cDkcQVY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yza9SX2Cwnbe+16ZBK4T3xJmkIFGU8wEhKKOj+RFoyut809XgD8
	VjWbmLZFzAfZfPngQlyDcE0jBd3txNyJo3tXGm9/kfOEstkHMkS7zxBKUFkkzoYV5wgCKGW4n01
	+Jk/Sl8Z6VDle35fDH0bWwp7IscM8asgph9a06gc3
X-Gm-Gg: ASbGncuas5Yjfhv80lH+QlVwdZJY+LOJT7Q78Th1zdo9jrlo8YiqJdrYq/8zHhh4H07
	cuf1lE91pGQLjlTxGFrv60ZNl5eG06nUyxahmu25fG44Lba3nA1EF+0N5UFvITtABC5V/yXgdbq
	QPVQdRWKecLJEZFNFtGoMlbdldBrvx5gqEVwuU4ew/1L27+pTL1ATMtJD38pbGuGKG5Fz25ysDL
	aTlTXEMYfKpIm0MowbMZebdhZv1j+gjKeGJ/GO1PkUR9n++q+29E6KwQd+WQeokXceU6XJ3jH6v
	TFQ5d8G2DV1ZqMcigq2CkjRQEuGR/g==
X-Google-Smtp-Source: AGHT+IHkI5YsbFxyyS82tj2X9LN/0dzwhUDZCyTzbn8FGecyGYjxBiFXH5j3XoKfpwvhov2NCgV4EVJFZmr2eVlcJks=
X-Received: by 2002:ac8:57d3:0:b0:4e8:b245:fba0 with SMTP id
 d75a77b69052e-4eda4e8cc1emr11941391cf.14.1762746330092; Sun, 09 Nov 2025
 19:45:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com> <20251008232531.1152035-3-dmatlack@google.com>
In-Reply-To: <20251008232531.1152035-3-dmatlack@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 10 Nov 2025 09:15:18 +0530
X-Gm-Features: AWmQ_bkpnxbMBI97zxsCaCAoaAd2gGCuZUFH_hhBv2_QmN9jUVMGOfF04SoZg5c
Message-ID: <CAJHc60yVqHHVjX2_oGVUBfBatFom-7-d3q9_uwgHy=-dSS4xNg@mail.gmail.com>
Subject: Re: [PATCH 02/12] vfio: selftests: Allow passing multiple BDFs on the
 command line
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 4:56=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
> -const char *vfio_selftests_get_bdf(int *argc, char *argv[])
> +static char **vfio_selftests_get_bdfs_cmdline(int *argc, char *argv[], i=
nt *nr_bdfs)
>  {
> -       char *bdf;
> +       int i;
> +
> +       for (i =3D *argc - 1; i > 0 && is_bdf(argv[i]); i--)
> +               continue;
> +
> +       i++;
> +       *nr_bdfs =3D *argc - i;
> +       *argc -=3D *nr_bdfs;
Just curious, why update 'argc' (I know we had this before as well)?

> +
> +       return *nr_bdfs ? &argv[i] : NULL;
> +}
>
> -       if (*argc > 1 && is_bdf(argv[*argc - 1]))
> -               return argv[--(*argc)];
> +static char **vfio_selftests_get_bdfs_env(int *argc, char *argv[], int *=
nr_bdfs)
> +{
> +       static char *bdf;
>
>         bdf =3D getenv("VFIO_SELFTESTS_BDF");
> -       if (bdf) {
> -               VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
> -               return bdf;
> -       }
> +       if (!bdf)
> +               return NULL;
> +
> +       *nr_bdfs =3D 1;
> +       VFIO_ASSERT_TRUE(is_bdf(bdf), "Invalid BDF: %s\n", bdf);
> +
> +       return &bdf;
> +}
nit: Since vfio_selftests_get_bdfs_env() still returns a single BDF,
perhaps add a comment, as it contradicts the plurality in the
function's name?

Thank you.
Raghavendra

