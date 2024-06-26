Return-Path: <kvm+bounces-20568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20C6991879A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 18:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC36128A9E8
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 16:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938F618FC63;
	Wed, 26 Jun 2024 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVEeMRkK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B742518EFEB;
	Wed, 26 Jun 2024 16:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719419994; cv=none; b=p8SwQtCtyxJlBsF44YDagg1ykhMiAeTFtst6NR/LToG5roSnziwpei+JWQ94Zeu3eXlzZEvbMy6tw2bQqYvPg35Rt9uOSDE57rMuUBZVR6A1xzXiUoptLz599a1Q/jqX2h6eRekdIYtJMZmwMSaWTBjIDT0u2HcgACYdyXx301k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719419994; c=relaxed/simple;
	bh=2PIGptfu7Q6IJYjxdK4gnMcXpRqy+KgrEzlHWeWHipg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdVy4vL0FedeTks7hkRByOQLkKo8EIDewXcrXIc8ou5XLRboPm1JAGfwDZy3PPl/wr8GVN/Y/Dyv/ypUvcn+bk6T6AvkRHcUOuzGavHdJXHniCc6GegrQrY0W+6MFodAIYrr+17XXPRs282D5/+tiyC6QTtuhZ30rgsodnTRoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVEeMRkK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10966C32789;
	Wed, 26 Jun 2024 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719419994;
	bh=2PIGptfu7Q6IJYjxdK4gnMcXpRqy+KgrEzlHWeWHipg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UVEeMRkK91SZfmGSS4KOvWnt+VMC1hj25VJkNV95C414FgBfOEXos8yU+6ls5YVX+
	 rGKvDVSHjHvMd/SgQJVBKWeV5R4by02/TT0prfUcJcC0beCPDQhOQkPcJhXhON+v9H
	 fgTApVTS3doKRbsSMiXFP8wKi3XGjV9Anq37vAFVNwuSCJekV0aowMTieJTL1qks7w
	 uyZQ2niXeXh1qkR1Rtd66AoP68zG4qzehgVRYVlAgBQbnQ8WR5CV0/l5SCJtbyWe4U
	 Ktd4GlozG/zGYUnfWJf+sUKyObD1mpqjYw2MeeyDxvgoQsKm6cb6VKOsQQMHkJf2K+
	 OMPttVlqoz74A==
Date: Wed, 26 Jun 2024 17:39:49 +0100
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
Message-ID: <20240626-spyglass-clutter-4ff4d7b26dd4@spud>
References: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
 <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com>
 <96ff4dd2-db66-4653-80e9-97d4f1381581@sifive.com>
 <CAHBxVyHx9hTRPosizV_yn6DUZi-MTNTrAbJdkV3049D-qsDHcw@mail.gmail.com>
 <20240626-eraser-unselect-99e68a1f5a3e@spud>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FU7Zc89k4QCiR7WV"
Content-Disposition: inline
In-Reply-To: <20240626-eraser-unselect-99e68a1f5a3e@spud>


--FU7Zc89k4QCiR7WV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 05:37:07PM +0100, Conor Dooley wrote:
> On Wed, Jun 26, 2024 at 09:18:46AM -0700, Atish Kumar Patra wrote:
> > On Wed, Jun 26, 2024 at 6:24=E2=80=AFAM Samuel Holland
> > <samuel.holland@sifive.com> wrote:
> > >
> > > On 2024-06-26 2:23 AM, Atish Patra wrote:
> > > > From: Samuel Holland <samuel.holland@sifive.com>
> > > >
> > > > Currently, we stop all the counters while a new cpu is brought onli=
ne.
> > > > However, the hpmevent to counter mappings are not reset. The firmwa=
re may
> > > > have some stale encoding in their mapping structure which may lead =
to
> > > > undesirable results. We have not encountered such scenario though.
> > > >
> > >
> > > This needs:
> > >
> > > Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> > >
> >=20
> > Oops. Sorry I missed that.
> >=20
> > @Alexandre Ghiti
>=20
> What's Alex going to be able to do?
>=20
> > @Palmer Dabbelt : Can you add that while picking up
> > the patch or should I respin a v4 ?
>=20
> b4 should pick the signoff up though. "perf: RISC-V: Check standard
> event availability" seems to be missing your signoff though...

Huh, this doesn't really make sense. I meant:
	b4 should pick the signoff up, though "perf: RISC-V: Check standard
	event availability" seems to be missing your signoff...

--FU7Zc89k4QCiR7WV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnxEVAAKCRB4tDGHoIJi
0hINAP48KsydcVtxBdutJ7PLHDXPIJwaexLkCAn12KujpGyUXwD/ayGbi7swPtlU
FUXHQj/AMQOOQenoBkNfM/k44jEYCQE=
=a7Yq
-----END PGP SIGNATURE-----

--FU7Zc89k4QCiR7WV--

