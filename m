Return-Path: <kvm+bounces-8991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F0B8596F0
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 13:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5C941F21640
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 12:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CC26BB5F;
	Sun, 18 Feb 2024 12:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbHkwCff"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6A566B54;
	Sun, 18 Feb 2024 12:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708260470; cv=none; b=fWTu2EJFrWUbY9Z5T/ce4HbnMF/LwuliolW+bhaHMvqxbDX6jzHFdF/xwiuBkHdtumzbOc7dtJCDTB3juVPCIjhr13Gs28PnzM0O8Ga5YTa/qWvnw18S9C7QA7SkIzEfdk9tX8hDcxLKY8HbQrQhvfggNsJfVA2hnvQRnA/1nD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708260470; c=relaxed/simple;
	bh=sK2TmZpAQu9k8EAmihVlLcIiBryBY0eXzheo238yJWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2nqEvuH75R/tKhPZl5ekFn4aJMdTWQeaIbk50Nn59AJDBaXiZPorCXSbLCPiAmT0t+UPpU46lnId0DvKZ4FFgHkHsAAAzeghnLAbJloWQk+9p/iobNSUTHn2HBddI0M5i9kMh4HAaMQN/xTmn66caA0bxW52LXkQWL/05ClgTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pbHkwCff; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E0DC433F1;
	Sun, 18 Feb 2024 12:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708260469;
	bh=sK2TmZpAQu9k8EAmihVlLcIiBryBY0eXzheo238yJWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pbHkwCffzFslLALjB4HU3bL93ie308bi65wFrpZuI6Gpn7pfrfK7wd8UQWUCmoURn
	 8RyCLtsGROOHycaTrVINptPC4tVpYyDZi5l29aW0z1wefwZ3wGYQs9wCzr8M/Km/AH
	 oiKNs4yxhknja8YCDyCaq1/xaRKxTjvWuCBfQKMNOzoB0WKx/CX3/m2uOFlpONHwiE
	 c0ZOvnjVV2vMmVFxZzNwhP6+DUP3ctAF0LidKpYRs/pXjisDWnDsDRMk+2T25nXzV4
	 yf9fhltuGCsyiJf0u04XI2TaY05KfrCeShDca2tcH9MbncQzzObsP6Tj3FuqJnwx65
	 wUSC7qFLx9ALA==
Date: Sun, 18 Feb 2024 12:47:39 +0000
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
Subject: Re: [PATCH RFC 04/20] dt-bindings: riscv: add Sxcsrind ISA extension
 description
Message-ID: <20240218-struggle-grumble-43efdfb9515d@spud>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
 <20240217005738.3744121-5-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mtQyaJDzucCfto0x"
Content-Disposition: inline
In-Reply-To: <20240217005738.3744121-5-atishp@rivosinc.com>


--mtQyaJDzucCfto0x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 04:57:22PM -0800, Atish Patra wrote:
> Add the S[m|s]csrind ISA extension description.
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  .../devicetree/bindings/riscv/extensions.yaml      | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Do=
cumentation/devicetree/bindings/riscv/extensions.yaml
> index 63d81dc895e5..77a9f867e36b 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -134,6 +134,20 @@ properties:
>              added by other RISC-V extensions in H/S/VS/U/VU modes and as
>              ratified at commit a28bfae (Ratified (#7)) of riscv-state-en=
able.
> =20
> +	- const: smcsrind
> +          description: |
> +            The standard Smcsrind supervisor-level extension extends the

The indentation here looks weird.

> +	    indirect CSR access mechanism defined by the Smaia extension. This
> +	    extension allows other ISA extension to use indirect CSR access
> +	    mechanism in M-mode.

For this, and the other patches in the series, I want a reference to the
frozen/ratified point for these extensions. See the rest of this file
for examples.

Cheers,
Conor.

> +
> +	- const: sscsrind
> +          description: |
> +            The standard Sscsrind supervisor-level extension extends the
> +	    indirect CSR access mechanism defined by the Ssaia extension. This
> +	    extension allows other ISA extension to use indirect CSR access
> +	    mechanism in S-mode.
> +
>          - const: ssaia
>            description: |
>              The standard Ssaia supervisor-level extension for the advanc=
ed
> --=20
> 2.34.1
>=20

--mtQyaJDzucCfto0x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZdH8awAKCRB4tDGHoIJi
0u4mAP9fsytyek6UcV7VwruVpbfAA+aCT8dvujmuE+Oy3Gzq/QEAgVGeiO4Z57ek
bOGtDZTcTAe8Vqrk2tSkrjGvbhOX2wQ=
=6anZ
-----END PGP SIGNATURE-----

--mtQyaJDzucCfto0x--

