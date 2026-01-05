Return-Path: <kvm+bounces-67068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C8475CF5229
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 19:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5087D302EADE
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 18:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2161B2DECD2;
	Mon,  5 Jan 2026 17:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UN5dRM3z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E77322B9C
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767635698; cv=none; b=bY5Dq05YtmrtL4WCN/neeAMXbIPI+58lh00n728x9ISL5VohVqn3i2Ms8i0RZot9wh42tRaNSpljhkUNXDPr7PfzMtevb+grqVXaTjvmAs8/6VXYkR7SsOx8Czr/YgnD0ehj0tbpwJOAy0fa17Pba35SlNSTOioF7ZQGGDv/MD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767635698; c=relaxed/simple;
	bh=3exiw0thvbCtX+WLOhnht9nO6z7rXw54qNFKoQqhAuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WD0thyV8hTvI0LBT2P2OryjeCJ8dZGbcY2AB3AqZecX4vI5nTBinaTeNrsrWNOPkSGukcj+Wc2uF/Xn1Mashdq9Mmx6fv/f4OKTRYbL15yN6e9EA4Y3bU2UJU5CxduUB0BH6cSYNmcMJ/hpG2pMlEJ75VWmV8ELDnYbt3MPdrr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UN5dRM3z; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37d275cb96cso1667141fa.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 09:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767635694; x=1768240494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKzk+CxxnNt9ZNHbY1DTzzVJyV243CDMIdk2HW5f4qU=;
        b=UN5dRM3ztSXkZHfhID6ClvBESyiWxxz4sPV1ufIJGKf/E3BFKB5tA+z6nHJ46yRawk
         EMSdDrmgh445S/1GVaZNcxlEdxDsmNacFx99q6Bez8Xa03+sO3oGaJw2FAbZCZF+IoSS
         BQ4QELKiCSyJxeePrT13U72odBGZNhEvweBMS+HOePiiZE/DTea1Fje8ZrXNqYvfi67z
         b3JojZFMraQQu3N4ppNwi8J/ZCIcHvbW9WdMjvC99HiyPNswN1Z/ZiX9NtFodhartE7Z
         c7hiyaxMYrJH8E58ecEYqs6EN7h3CNmUm9b/cSQFlderY5RMovkpXsndF9baBIlg5OFl
         30ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767635694; x=1768240494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lKzk+CxxnNt9ZNHbY1DTzzVJyV243CDMIdk2HW5f4qU=;
        b=jqcLT02qi2ictSH3h+k7dpi/R1gp+Z60x6L6jEpb3I/UnrnZhEv7pG3ml1oUk2fum1
         1I/XV6gGngbjaFwVQcRz4UdT4gVrcnajZiEXzvJwdnm8PDW+ylUccnxntZWNsBpKtUY0
         V2ZsBkFPXLzhXQujrjeNoFRqRGHuPgZb8kr0j7lyVpPH9dO/RjKXuVvRcCPulvtDyjbo
         o9ZVfLj1h27i7QKeqNTsL4JTRId9LO16souEaquaZipie5H7UXGP3JUvYUyWQYHY1dZu
         APON6AFMlJYLcT0x6fBdKXL8drqyqY+qbtOu2aN5Jq8Wgp8TsQbBvZkpoUHSg2wurWgc
         591w==
X-Forwarded-Encrypted: i=1; AJvYcCU86EH5QSyn2Pd21AtsDimXiuCHQqCf49PZopWPwbPKuNQACXxgzYieqKL1FtYjm4oDg1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXklf0OXP5tvSRVbqSBTNT5pRayzZz9zjJIvFYC4ftRKXqe5Dn
	RMWSjmBdVA9FMH1J2mh1c55hZ3Ym9HQxErTolJ18BqcBwxKio0r8cqc85UnjO6FmajoO6F7T/dJ
	nZIPvveWYEPGFjQdvx+9cUHkSJiaRcI13xbJ/bFmH
X-Gm-Gg: AY/fxX6a4nfjLo0IxQieuEIkI7/kPxLCINbWFCXjRzBrLmd0hTuKbPoD9fftmdoUgkl
	0u/5Xdjy7lXVaIRwizb+j+j4a7czIwKrfUzntoufXsFvjNDQFcv9V6YyAxQpZVu50yEt6myJ0Jf
	E1nDK2JKcFlsObFXfOkLv25x9vjJ8uh3H1H68WgScysyPc7PhVNS2DriZBjqOAv7iaj6Svmj3cG
	dq2dsVedApJ0wOzmIfBV08t0qm7VKXx3Lx9z3JL9PWcBGoUJN6TdTuNdSGm0joO8o2Y0+oY
X-Google-Smtp-Source: AGHT+IG1OlQp7L7xGRo0uQarvmhbCxjRiBs9CCPI1n79KwlTxoqllow+YbWs7GIzqxYb/LvpuhvZzbuvoSSvtdK3ah8=
X-Received: by 2002:a05:651c:511:b0:37f:aa88:83fb with SMTP id
 38308e7fff4ca-382eaac1869mr377291fa.32.1767635693427; Mon, 05 Jan 2026
 09:54:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126193608.2678510-1-dmatlack@google.com> <20251126193608.2678510-20-dmatlack@google.com>
 <f0439348-dca7-4f1b-9d96-b5a596c9407d@linux.dev>
In-Reply-To: <f0439348-dca7-4f1b-9d96-b5a596c9407d@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Mon, 5 Jan 2026 09:54:24 -0800
X-Gm-Features: AQt7F2pamlADbdQVNO88tt3y4iAorzOwRP2E99cUQN8k3LcTYOLnYFBdkWya6hg
Message-ID: <CALzav=duUuUaFLmTnRR41ZiWZKxbRAcb9LGvA5S8g2b5_Liv4g@mail.gmail.com>
Subject: Re: [PATCH 19/21] vfio: selftests: Expose low-level helper routines
 for setting up struct vfio_pci_device
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kvm@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Philipp Stanner <pstanner@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 27, 2025 at 8:04=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> w=
rote:
> =E5=9C=A8 2025/11/26 11:36, David Matlack =E5=86=99=E9=81=93:
> > @@ -349,9 +351,20 @@ struct vfio_pci_device *__vfio_pci_device_init(con=
st char *bdf,
> >       device->bdf =3D bdf;
> >       device->iommu =3D iommu;
> >
> > +     return device;
> > +}
> > +
>
> In the latest kernel, this part changes too much.

Can you clarify what you mean by "changes too much"? What is the issue?

