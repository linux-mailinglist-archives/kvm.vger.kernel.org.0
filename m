Return-Path: <kvm+bounces-36790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A7AA2108D
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:13:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24CF0188353E
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 18:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F011DE89B;
	Tue, 28 Jan 2025 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ia48mg0x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A161C5F1D;
	Tue, 28 Jan 2025 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738087994; cv=none; b=ArpnzEvpgynxmA8w1mqZPtq/IK/0Pzt46jk3L/layW0ilAzLheWgS9UhI6FuPvNrGlMfQa9A9LS0pP3Jd3Son/Iqlt5WqrF/8TSXkEm9m9ZNTb6WCbMWvFb2xs8cUwRUxZwkGirx3YBNN7WRTI3fHaijORZSmLYKFyAHTDiD3k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738087994; c=relaxed/simple;
	bh=+I9h/svnrKeZUj46Q/YA9sqg4nwDYw/Jz+DfrJhXcb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajx9wPRYjk/amnRxV5IeH+r9yigz5uWiwe6P5etl+j5Lj9ZO0YanWS8xblREgEtbNvtZvnVMjmlXS05rkjrzkjQBNKTaBMuuCqIeeLsgR4KzKqrVBUKHsFAhg1d3yBA3jsep5cNlWkQpnG9cmXXoshJgvG7PzFpmYv2ZSet6uOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ia48mg0x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AEAC4CED3;
	Tue, 28 Jan 2025 18:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738087993;
	bh=+I9h/svnrKeZUj46Q/YA9sqg4nwDYw/Jz+DfrJhXcb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ia48mg0xrcDLeEXqdYVrCbqfVLpeuDkh3p5Z04Q8i6zAq/cRyi58IhHklxmjYbiVs
	 DnimRVPCxDp6Sz4+ORf5IthMQdNuuE4obeBeq0xW1lEilv1I5wR0GGmIa8mKSRCCmg
	 AqL8sjypOG5TU2cSuta2ksVzly3v+NKagWgPaM/M0Os0dr4fwfK4+Y6Ft5j+H8PP4s
	 f0fb9rRL4DhE4GjqL/6sZnX4mnuCOnf3w1VXGtliGsKxweGHZidnOK+WGcH0wwA0O6
	 BdVT3uYL0dPpWKgY3y6nlk0k/4+4cHvxo1C3Ub+V5RCZyE0kBToXgbYvM4UmhriQNe
	 0DCO2yqa0Jjkw==
Date: Tue, 28 Jan 2025 18:13:06 +0000
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
Subject: Re: [PATCH v3 04/21] dt-bindings: riscv: add Sxcsrind ISA extension
 description
Message-ID: <20250128-generous-subtract-32158b4ee05b@spud>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
 <20250127-counter_delegation-v3-4-64894d7e16d5@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SYADI19HB8MN2NaU"
Content-Disposition: inline
In-Reply-To: <20250127-counter_delegation-v3-4-64894d7e16d5@rivosinc.com>


--SYADI19HB8MN2NaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 08:59:45PM -0800, Atish Patra wrote:
> Add the S[m|s]csrind ISA extension description.
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--SYADI19HB8MN2NaU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ5keMgAKCRB4tDGHoIJi
0msdAQCuEvxDWJyKiJkoX8Q0COXGLdc8ZqrcoXFMy3qWLF8SdwD/YsLhWxVSNpiN
Ki4R6w9cUWtC4Px4K6vM3YQcTtwKzgQ=
=molm
-----END PGP SIGNATURE-----

--SYADI19HB8MN2NaU--

