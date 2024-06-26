Return-Path: <kvm+bounces-20577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC3A919A71
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 00:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3913D1F23884
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 22:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349231940A9;
	Wed, 26 Jun 2024 22:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NftDNO2y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56215161314;
	Wed, 26 Jun 2024 22:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719439920; cv=none; b=XBgc5haJ+9ANygp8xswi935CsqPzMGOD8ou+biASwzdcBS8ypHkF2IcQ1aiZ+Y3qcJG03C5Oxzo8HR/q62UmlmDDxsNlw1C7ASYvTMkZR1CopXDzdCrvAgE1/YKFoyGf4kVgwdSZg0BS/LP+rnZKfuWXalUKnOtR/FKmUDbtvic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719439920; c=relaxed/simple;
	bh=hpQdIVXXgJ8IuDlSJFC93BuJvLDRkunHWFns0BW8VHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayXeBUwvTAAXQjY/AJqGmQDG5J+m0LPdClJw0oBiEIybo9tfPonD3G5s7q5CCyQowq8Z+EiNS1+EPsAl4CW13SMMV5tqU4G/schPC1+ZY5Vkg83XCC6j4Lc20WTiZkv1s75C6aHzibFAOzWvQbrijS7Mzp4HuNIHH6CQe2Ce/sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NftDNO2y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A02C116B1;
	Wed, 26 Jun 2024 22:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719439919;
	bh=hpQdIVXXgJ8IuDlSJFC93BuJvLDRkunHWFns0BW8VHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NftDNO2yLuZesOV4fuw7HaphDFd3R1jqrmBELfKDVHpmS3AicuoQr7Khztp9tHq1V
	 DKDR6Qa4k7n9nHovDaVcQbceZDGq+mccl9vDe7nAVuUZXNU8xA49F6ioAv3kqYKx/M
	 ZMRq3VPtdVzUft0nWQ6HGgEmbPasr2iIdK9TP2TspmMnS9/9Mpm7n9MqRZsM7gie1y
	 3eC5iaQiA+dJFce3DULYRMgwWFxUzczuFD9O5jD2sUflhr3CIfFdXZ9nJnA4iEISZF
	 QW9ohg1ayRBBz3X6aCnjhuElpCF7vcS+lLQFJWM5BFLLYgy45eaArm8fDg8UJ5g9zV
	 UgkvQilcgMujw==
Date: Wed, 26 Jun 2024 23:11:54 +0100
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
Message-ID: <20240626-pedigree-retype-dd7f1e54ac2b@spud>
References: <20240626-misc_perf_fixes-v3-0-de3f8ed88dab@rivosinc.com>
 <20240626-misc_perf_fixes-v3-2-de3f8ed88dab@rivosinc.com>
 <96ff4dd2-db66-4653-80e9-97d4f1381581@sifive.com>
 <CAHBxVyHx9hTRPosizV_yn6DUZi-MTNTrAbJdkV3049D-qsDHcw@mail.gmail.com>
 <20240626-eraser-unselect-99e68a1f5a3e@spud>
 <20240626-spyglass-clutter-4ff4d7b26dd4@spud>
 <CAHBxVyEg2uKKdikXib77JDmCKs8qDGJHvj3stsFgCgO0U9omRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Qn8GLMXXMKWShJFF"
Content-Disposition: inline
In-Reply-To: <CAHBxVyEg2uKKdikXib77JDmCKs8qDGJHvj3stsFgCgO0U9omRg@mail.gmail.com>


--Qn8GLMXXMKWShJFF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 01:40:52PM -0700, Atish Kumar Patra wrote:

> > > > @Palmer Dabbelt : Can you add that while picking up
> > > > the patch or should I respin a v4 ?
> > >
> > > b4 should pick the signoff up though. "perf: RISC-V: Check standard
> > > event availability" seems to be missing your signoff though...
> >
> > Huh, this doesn't really make sense. I meant:
> >         b4 should pick the signoff up, though "perf: RISC-V: Check stan=
dard
> >         event availability" seems to be missing your signoff...
>=20
> Strange. I modified and sent the patch using b4 as well. It's missing
> my sign off too.

`b4 shazam` should pick up trailers provided on the list, signoffs
included. `b4 shazam -s` will add yours. TBH, I am not sure why that is
not the default behaviour.

Cheers,
Conor.

--Qn8GLMXXMKWShJFF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnySKgAKCRB4tDGHoIJi
0ggpAQDI5svZclXsiiw/tBho5jBjNBUOz2wHe+OAFRr/Tp5zRgEA0WA8ZFlqoud+
fKQ/MbZq8OBTmsy2Kb9vdKxThGGg8QA=
=D/2H
-----END PGP SIGNATURE-----

--Qn8GLMXXMKWShJFF--

