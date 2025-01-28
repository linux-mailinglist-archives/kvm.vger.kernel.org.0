Return-Path: <kvm+bounces-36789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9FCA21081
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E0001689D3
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 18:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A7D1DE8BE;
	Tue, 28 Jan 2025 18:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEkA549Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A4F1DE3BF;
	Tue, 28 Jan 2025 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738087866; cv=none; b=JB2jZQXREVx34EwcScjaUflRnW5zpnsvwvf/DqwcJ6fueVaZ5FzsHnB3u2huxoBNpYXs6tQx6ML3yil47FqOwjZgB//gjb9Ngd8QCyj6Bmu6iCfliu+RL2NGfMO9seQnJCa7TRmXktGy+HkUvUYm9+0Qe4oZSHr789lYz67vM+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738087866; c=relaxed/simple;
	bh=yEBiZ8mqq0tTSbFKxUO9y4M2n4j6xBmDLpLWSPRhhkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUV+Nv3epd7goQ+wMP6nu69E3cGoqOJ9Np0UEcCWMPNOkrIDUvULOm2UBQWihpAASFrEOql/J6CbA/oXPMcRCSaDm7Tw2krVq+tcIkwAYWz1rmWhm9jLd9CLLwbct/p12rrSJXQMiD5d7nODIV47tTapNfv+KPsk5zsaoJ8imIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEkA549Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60226C4CED3;
	Tue, 28 Jan 2025 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738087866;
	bh=yEBiZ8mqq0tTSbFKxUO9y4M2n4j6xBmDLpLWSPRhhkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QEkA549Y5fkmYtnn7ptzhhyFhsQrseZR3e/LbzWl+7KNhkr77n+RWVreexc0LP00S
	 N7PFwTy5Lgp21ry6QiAzNh3UHRQTt4MgmSqBa2sLqm4a8OprvNrWH5QNYr9YGt0Mm6
	 ANZwLw/g7uwUPRW8H4kv+QlHNT339mehFFl5LgCfC1KO0gRDDGglWFjGTBjw7vY1s0
	 sNOZZFnYQ3rcuD4OcsXeQKiMUHl6SCZGV0NQ3kX8xlHdbbjnQaZWpnv0e27htyOCst
	 Jm9t3qkiVN0k1HOaSSM7YxAJ5TNFv1kocCO8/fa06nBzw5VBCN5jp9pvzeKoQB9VHY
	 UJTLRb1luEWCw==
Date: Tue, 28 Jan 2025 18:10:59 +0000
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
Subject: Re: [PATCH v3 09/21] RISC-V: Add Smcntrpmf extension parsing
Message-ID: <20250128-jubilance-mosaic-e3a81199aec8@spud>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
 <20250127-counter_delegation-v3-9-64894d7e16d5@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="AeQjYjsxiXla5jGt"
Content-Disposition: inline
In-Reply-To: <20250127-counter_delegation-v3-9-64894d7e16d5@rivosinc.com>


--AeQjYjsxiXla5jGt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 08:59:50PM -0800, Atish Patra wrote:
> Smcntrpmf extension allows M-mode to enable privilege mode filtering
> for cycle/instret counters. However, the cyclecfg/instretcfg CSRs are
> only available only in Ssccfg only Smcntrpmf is present.
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
> index 2f5ef1dee7ac..42b34e2f80e8 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -104,6 +104,7 @@
>  #define RISCV_ISA_EXT_SMCSRIND		95
>  #define RISCV_ISA_EXT_SSCCFG            96
>  #define RISCV_ISA_EXT_SMCDELEG          97
> +#define RISCV_ISA_EXT_SMCNTRPMF         98
> =20
>  #define RISCV_ISA_EXT_XLINUXENVCFG	127
> =20
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeatur=
e.c
> index b584aa2d5bc3..ec068c9130e5 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -394,6 +394,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =3D {
>  	__RISCV_ISA_EXT_DATA(smmpm, RISCV_ISA_EXT_SMMPM),
>  	__RISCV_ISA_EXT_SUPERSET(smnpm, RISCV_ISA_EXT_SMNPM, riscv_xlinuxenvcfg=
_exts),
>  	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
> +	__RISCV_ISA_EXT_DATA(smcntrpmf, RISCV_ISA_EXT_SMCNTRPMF),
>  	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),

Isn't the order here wrong?
 * 3. Standard supervisor-level extensions (starting with 'S') must be list=
ed
 *    after standard unprivileged extensions.  If multiple supervisor-level
 *    extensions are listed, they must be ordered alphabetically.

--AeQjYjsxiXla5jGt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ5kdswAKCRB4tDGHoIJi
0qZFAQCpe0QJ5o16AKk5zmb7bqYpmvMDoPRwL4regdLry1RudAD/UU5umiu7pC6H
GV2ayeNoIup+xEZqYsS9ZNY8zLhrTgs=
=5FZk
-----END PGP SIGNATURE-----

--AeQjYjsxiXla5jGt--

