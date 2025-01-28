Return-Path: <kvm+bounces-36793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9318A210A0
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 124301881532
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 18:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C6631DED66;
	Tue, 28 Jan 2025 18:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrftOapN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B5218C004;
	Tue, 28 Jan 2025 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738088186; cv=none; b=IgKoyFCC48/7Tq+QXQVG4ToQSsoxZ6inY94zuxQbKXESI+i4lav/knalea2U51212n+xitBqrKD7lHwnwWDTR7vijZkhkepPAns5u2IpgFXz/6HXmCMq37H2OopjGnDvHskvjIpkZaerrr8NCwgX2Uh+y8rfddmvg1PVO8woQuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738088186; c=relaxed/simple;
	bh=dAhBIZe0NzGrk1yP7ba0F2cmDA+lcqNfDyuYt8ErwRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQF+ZC9cp8A5PvzEqOOIpSx4WTLrvec0PlH9gNzTC7Oln7waBOa+vppeFRMK35sCxiodXi7seAFWmuK5iqGf4M6aer4rfjWRMFX997VXEoPMGLRei/4ucR7JwlrOGkAj/AaKKlmorzMMXW8Yf+nQ3i1YgskZWlG/k1dAVPh9irY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrftOapN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36FAC4CED3;
	Tue, 28 Jan 2025 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738088185;
	bh=dAhBIZe0NzGrk1yP7ba0F2cmDA+lcqNfDyuYt8ErwRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZrftOapNA8Eyku0qCpJKq83E+TD2XmaWlujUh9CFP4XK8vS31y6coss+9ZWtBusns
	 AHcEsFX0JlmC8QYGEOggefw0efgPihS9eUzUIHHdUDwtDhWtJAPPHnWvv3LraZhB6E
	 XGOMQNebgjk4IBWQg3Wa6c3K2FziMHBNWSm2tsu2g1FMDrCwJbxqDO9Agg6/0gqfzl
	 I+XiSOsd7PN/30899VQtArlsbbAjsvaCoojBh4I6UPEO2cNsB1+PTHf8oyVmAqPSC6
	 /i56wCYOR4kLHGDO1W9UH4FEJvDF8MhbIsVZ19awk2Svz+J3luKa52D1KTi4JciHUy
	 z0BCn2hK8R5rA==
Date: Tue, 28 Jan 2025 18:16:18 +0000
From: Conor Dooley <conor@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 10/21] dt-bindings: riscv: add Smcntrpmf ISA extension
 description
Message-ID: <20250128-alkalize-gains-d7ff05cb8c71@spud>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
 <20250127-counter_delegation-v3-10-64894d7e16d5@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9yLtu4dFJkbHyVHb"
Content-Disposition: inline
In-Reply-To: <20250127-counter_delegation-v3-10-64894d7e16d5@rivosinc.com>


--9yLtu4dFJkbHyVHb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 08:59:51PM -0800, Atish Patra wrote:
> Add the description for Smcntrpmf ISA extension
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Do=
cumentation/devicetree/bindings/riscv/extensions.yaml
> index 1706a77729db..0afe47259c55 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -136,6 +136,14 @@ properties:
>              20240213 version of the privileged ISA specification. This e=
xtension
>              depends on Sscsrind, Zihpm, Zicntr extensions.
> =20
> +        - const: smcntrpmf
> +          description: |
> +            The standard Smcntrpmf supervisor-level extension for the ma=
chine mode
> +            to enable privilege mode filtering for cycle and instret cou=
nters as
> +            ratified in the 20240326 version of the privileged ISA speci=
fication.
> +            The Ssccfg extension depends on this as *cfg CSRs are availa=
ble only
> +            if smcntrpmf is present.

Same here, this Ssccfg dep on Smcntrpmf should be in schema.

> +
>          - const: smmpm
>            description: |
>              The standard Smmpm extension for M-mode pointer masking as
>=20
> --=20
> 2.34.1
>=20

--9yLtu4dFJkbHyVHb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ5ke8gAKCRB4tDGHoIJi
0vPhAQDx+AuPwwIGi1but7cc+ZSuNL3hdXEnMDZgYqVgWvZYyQD/XAo/U+6tF1Qq
aDwsQLtFmnRh8LNdj2PoYC0npPteJQg=
=WLCX
-----END PGP SIGNATURE-----

--9yLtu4dFJkbHyVHb--

