Return-Path: <kvm+bounces-36792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1D9A2109E
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:15:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C305618822F0
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 18:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B53118C004;
	Tue, 28 Jan 2025 18:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHBk+2KB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C5D1DE3DB;
	Tue, 28 Jan 2025 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738088131; cv=none; b=X9mUYe7JEPtXWYiaV28c0ETuvH5vw3kICREqtaJ2YyHrAqM9GDcFvlRM2yCMMfR2wzLGms5sougqZTZRDkun4q7zjXj1e+IEAPz6AeTXo2WhsdLXQi+2ciC69PX5SnjDs2Ul9r3ZY66/2bMloPvkMCEZV8wuHEEOGEPIei5oemI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738088131; c=relaxed/simple;
	bh=6075frjmGf2CUp9HJ5/vQDRATQCGJ5BP/XrPZq5Nprg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l6P5gzaQrPx3WdtbMyc/BbjIzkGQXlMFu8lUCHb0caGR3fdynwTA9/WrSiv/BgvgeWFkdcvgeb4O2c0F1lFgciSE5emf5OSJROwXJkT0aj6/suiSRU89u8v8HU+kAwER+p5JLswcOd5bGo/ZwbG3ccdKQQmyqWKSUM2ZlqI/aUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHBk+2KB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1923CC4CED3;
	Tue, 28 Jan 2025 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738088130;
	bh=6075frjmGf2CUp9HJ5/vQDRATQCGJ5BP/XrPZq5Nprg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHBk+2KBtaE1HOUtjCqrKseXmeqGHBEUiU1op0fxaYBtVY2NXJ5z/1iewzUG0d7MI
	 Fir+fc7UdqpYikHjmDTwnbmVvtZlf4Ey/93imq2a1I3mct7h7Nzrotkr1Yuj6EVz+o
	 CqdQZ8mDeXV/XYRI3z7ZVC+EdscMSxmZq73iVQ0GPZgOXS1ImdlXtp4LzVB/MMF84w
	 tFZPMdBoM4NW9cK9mpbHR4Bi3QOb7v4sFDlDjxkMWsKEzZQto798CEhGs5enRMlRWe
	 98x2v/SuhQlUY0AfZxEMWWZ0z1lMzF6kUgp8zeHCEqrn3ZolLzwun1WrCAmiPehQ9j
	 CrcGJOPVn8rcQ==
Date: Tue, 28 Jan 2025 18:15:24 +0000
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
Subject: Re: [PATCH v3 08/21] dt-bindings: riscv: add Counter delegation ISA
 extensions description
Message-ID: <20250128-murky-shack-0ba8e6e65db6@spud>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
 <20250127-counter_delegation-v3-8-64894d7e16d5@rivosinc.com>
 <20250128-crazed-crudeness-f7b1fbc87f1d@spud>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/eM+/vjEehefq9Br"
Content-Disposition: inline
In-Reply-To: <20250128-crazed-crudeness-f7b1fbc87f1d@spud>


--/eM+/vjEehefq9Br
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2025 at 06:13:30PM +0000, Conor Dooley wrote:
> On Mon, Jan 27, 2025 at 08:59:49PM -0800, Atish Patra wrote:
> > Add description for the Smcdeleg/Ssccfg extension.
> >=20
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
>=20
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

Actually no, I take this back. Don't describe dependencies in text,
there's examples at the end of the file for how to set up dependencies
between extensions in schema. If you get stuck, lmk and I'll help.

--/eM+/vjEehefq9Br
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ5keuwAKCRB4tDGHoIJi
0tECAP4paJ3J93SR4l7JboJVyX3iK+3HsvDkfh03Tg6KWjjrzgD/daARcIoPZWNF
iNl1rW5lnWyTZ4vN+TrR+hLHXd6XmwU=
=h1bm
-----END PGP SIGNATURE-----

--/eM+/vjEehefq9Br--

