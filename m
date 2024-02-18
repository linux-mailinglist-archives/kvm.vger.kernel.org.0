Return-Path: <kvm+bounces-8992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A41F8596F3
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 13:50:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A43D32816D1
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 12:50:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211616BFA2;
	Sun, 18 Feb 2024 12:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSRhxkun"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3672E31A66;
	Sun, 18 Feb 2024 12:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708260617; cv=none; b=oWG5B4qiXtnW8xAS7ONRcjs5bwWW4Xy/69AJP8ICbKXK4Z+1crFz8adsRDMWSWcYJNUz2GRhgC88vlHbc6OdLOZ/Cv85GZ1tfmigUNP2MG8RpUx6uGyHVEZBl4++pnz0Gg9IxmQPUqXI8ebwK2bQPbS8lofXP+JhXn3sBbmxlF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708260617; c=relaxed/simple;
	bh=ZOuHC5/gemoLsv0gAHH7UQAs52/xaQ/OjKNR4b7C5iU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fp//aWFZ326cQpo9UgzfDljvUW7EL6jsngx6gYnmXHzfHaicelOJr9kXGYnsjqSy90kiLoV5NPzCsHgrd9rAFv27T8C2D4Tex8W989K/KpKNX2yaE4U48GfgTdq7esrisH5XgWvhkirbVQhsv0abmVCaFC5zzf2Fr78gQoAaXWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSRhxkun; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FFAC433F1;
	Sun, 18 Feb 2024 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708260616;
	bh=ZOuHC5/gemoLsv0gAHH7UQAs52/xaQ/OjKNR4b7C5iU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OSRhxkunjvuVg+kQQrNev5yXaSd763FyHTmF8BVOi3oTkf5Yz8WIvE/LNareLfcxr
	 GB9AZQ25nviU4M8kNbK1Dpg454Eli1ortScnmzbw7i20Ji3RYdJkpkqh9qDyFeXYfz
	 Xf0yGZkd6whMp2e8tr8Ay0mtu1J/d9AaY8P03GQsC+8xKQM2Bm4j/RCIZbTg9cWKKA
	 bCZ/TwBhym8gTzbH/oWsYVkoVdPHeCB8VRQxdj1QkPcti/61YXZ17jD0pzJPkYa+U0
	 LwOEGuHNJX8SoWikhUPsGQusnIFa0aXaswxiHjizlSzfw7ifaj/nU9NzNMuV1ikYnD
	 7PB3+V1R9PTJQ==
Date: Sun, 18 Feb 2024 12:50:06 +0000
From: Conor Dooley <conor@kernel.org>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>,
	devicetree@vger.kernel.org, Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>, Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>, Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com, Yang Jihong <yangjihong1@huawei.com>
Subject: Re: [PATCH RFC 09/20] RISC-V: Add Smcntrpmf extension parsing
Message-ID: <20240218-contort-profile-53593ed8d391@spud>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
 <20240217005738.3744121-10-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jbzKRUs6kj78gPRQ"
Content-Disposition: inline
In-Reply-To: <20240217005738.3744121-10-atishp@rivosinc.com>


--jbzKRUs6kj78gPRQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 04:57:27PM -0800, Atish Patra wrote:
> Smcntrpmf extension allows M-mode to enable privilege mode filtering
> for cycle/instret counters. However, the cyclecfg/instretcfg CSRs are
> only available only in Ssccfg only Smcntrpmf is present.

There's some typos in this opening paragraph that makes it hard to
follow.

>=20
> That's why, kernel needs to detect presence of Smcntrpmf extension and
> enable privilege mode filtering for cycle/instret counters.
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/hwcap.h | 1 +
>  arch/riscv/kernel/cpufeature.c | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwca=
p.h
> index 5f4401e221ee..b82a8d7a9b3b 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -84,6 +84,7 @@
>  #define RISCV_ISA_EXT_SMCSRIND		75
>  #define RISCV_ISA_EXT_SSCCFG            76
>  #define RISCV_ISA_EXT_SMCDELEG          77
> +#define RISCV_ISA_EXT_SMCNTRPMF         78
> =20
>  #define RISCV_ISA_EXT_MAX		128
>  #define RISCV_ISA_EXT_INVALID		U32_MAX
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index 77cc5dbd73bf..c30be2c924e7 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -302,6 +302,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =3D {
>  	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
>  	__RISCV_ISA_EXT_DATA(smcdeleg, RISCV_ISA_EXT_SMCDELEG),
>  	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
> +	__RISCV_ISA_EXT_DATA(smcntrpmf, RISCV_ISA_EXT_SMCNTRPMF),
>  	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
>  	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>  	__RISCV_ISA_EXT_DATA(sscsrind, RISCV_ISA_EXT_SSCSRIND),
> --=20
> 2.34.1
>=20

--jbzKRUs6kj78gPRQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZdH8/gAKCRB4tDGHoIJi
0isjAP4q6xpgI0SAprv3/kjAyM2CkWmD6mwTd7LPsrl/J8GTIwEAn19T671J/0t4
0ezPoULwYy8T4LILe16iToWJlXnvhAk=
=28GE
-----END PGP SIGNATURE-----

--jbzKRUs6kj78gPRQ--

