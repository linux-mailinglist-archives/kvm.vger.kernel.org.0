Return-Path: <kvm+bounces-20567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B29FB918788
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 18:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66B551F21AAD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA7018FC6E;
	Wed, 26 Jun 2024 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCG7hsy2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2AE18F2E3;
	Wed, 26 Jun 2024 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719419833; cv=none; b=UdK17kf8Z/VOPcR/zTrO/7HGJcYtUDfX2Zn268zWmfMay8YSPn3K9E3lLN3P6VUInE0K0f3cHzJnjrdlpo/SkEaVbUu2eNXaOhGlXCHI/tR3fxIjIlRmvnWuwvZXzPFB+8FYiuoCtoO0/dmZsNAe17yFtkw/uVqBnEVmoDd+5mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719419833; c=relaxed/simple;
	bh=1lD8fRLKhQDmXHyNmsSrGUGVXdUGFAPvH9RJeDgB7pE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6xini/YPiMed+dPg7G5VulaI6PGz9K7v1lJiffmLqxQ4ci46BqWDVhM/uN/KtYljT/yHMfs+P892YWEMDz4ixAyiHsRHByBaf4Ek/XxzHJjqU0uj8v6w0Ogbp5CQqtn+KLiwXe+xK6LgMvSrI45jHFgX1EjXTdCUNovlk3c+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCG7hsy2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDB2C116B1;
	Wed, 26 Jun 2024 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719419832;
	bh=1lD8fRLKhQDmXHyNmsSrGUGVXdUGFAPvH9RJeDgB7pE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eCG7hsy2l9mBP8DgUpW6XIpDt4uWVHlRvknHISmTPLOh1xGolLNBmOFqBxH6GtrC5
	 UTk7lYax8L91yj/c3jLL1NPP0w4ngeqTrcKad1GvCfrhYra5PkGsXQDl/AaC+b5FjQ
	 s7j2iQJYWL+wG5mW/fledGv2KPyPdX8ZVn/vOoPWaM5Ec+bPUS018GoOjpcDR2eubW
	 kQdj6p8tJW++NCGN+zCLRKuSrJp6OsKOBm1hiAO4GSReOLQYEgcUo9+39L/NrfA0vO
	 sBaf9nGoToLOZRtaUas/UJBBzxs2GwFd90GrjhS/tFZ5yHDWX/gs/XcYNcQsstGS27
	 DhuI6ppAYoUbQ==
Date: Wed, 26 Jun 2024 17:37:07 +0100
From: Conor Dooley <conor@kernel.org>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
	linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>,
	Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/3] drivers/perf: riscv: Reset the counter to
 hpmevent mapping while starting cpus
Message-ID: <20240626-eraser-unselect-99e68a1f5a3e@spud>
References: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
 <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com>
 <96ff4dd2-db66-4653-80e9-97d4f1381581@sifive.com>
 <CAHBxVyHx9hTRPosizV_yn6DUZi-MTNTrAbJdkV3049D-qsDHcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ron7u5fHDD4eUMra"
Content-Disposition: inline
In-Reply-To: <CAHBxVyHx9hTRPosizV_yn6DUZi-MTNTrAbJdkV3049D-qsDHcw@mail.gmail.com>


--ron7u5fHDD4eUMra
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 09:18:46AM -0700, Atish Kumar Patra wrote:
> On Wed, Jun 26, 2024 at 6:24=E2=80=AFAM Samuel Holland
> <samuel.holland@sifive.com> wrote:
> >
> > On 2024-06-26 2:23 AM, Atish Patra wrote:
> > > From: Samuel Holland <samuel.holland@sifive.com>
> > >
> > > Currently, we stop all the counters while a new cpu is brought online.
> > > However, the hpmevent to counter mappings are not reset. The firmware=
 may
> > > have some stale encoding in their mapping structure which may lead to
> > > undesirable results. We have not encountered such scenario though.
> > >
> >
> > This needs:
> >
> > Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> >
>=20
> Oops. Sorry I missed that.
>=20
> @Alexandre Ghiti

What's Alex going to be able to do?

> @Palmer Dabbelt : Can you add that while picking up
> the patch or should I respin a v4 ?

b4 should pick the signoff up though. "perf: RISC-V: Check standard
event availability" seems to be missing your signoff though...

--ron7u5fHDD4eUMra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnxDswAKCRB4tDGHoIJi
0jfRAQDzZpKiVTiVaovH+Q/5OxJQntjZIMNpZSGbTWqwqtdMoAEA9qF6f+d+BCB2
dVhzoaqpQ2mizAy1CcfVkCikmzqBlQM=
=RDz8
-----END PGP SIGNATURE-----

--ron7u5fHDD4eUMra--

