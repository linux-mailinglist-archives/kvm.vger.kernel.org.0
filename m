Return-Path: <kvm+bounces-36791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFFAEA21092
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E570162B23
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 18:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AF31DE8BC;
	Tue, 28 Jan 2025 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkDeNu+H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2781A725A;
	Tue, 28 Jan 2025 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738088017; cv=none; b=ScHZ1Vhiu03DFexPsPYOecdJegak/oEC1hQTd7ksUBJt4ovxDOMlNBxG1PPCdtZfvsgP3lWI3jyAUVVnXmcn0+yzmVZqdXalaSQBD/HNpWrbMbJtV0UcDV76MNHa7/JkiN7lGrLraiHVJReRJGLn0pWqCJHMo93QoZFF3lp5wLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738088017; c=relaxed/simple;
	bh=ZII8PZSI4LeKQp3xZZFOwVUjjXkbI08cdwKGSeAU3ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsB4EF7sCQppV6LTSFUNUcoRj8ZRQ4Bz/KZwQBAi7r33UTjcw2BAKM3oMU/M8AXuVwGK/6VQhM8AVdNQMhriBzTdXWu/Qlfs78bRqyj7fmpV8uF0HerF2jND7yUti+8ZkHt8KK78mnGOoOJr4OVTNRfD9wk0H/kOU0D3xPhHG14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkDeNu+H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5BCC4CED3;
	Tue, 28 Jan 2025 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738088016;
	bh=ZII8PZSI4LeKQp3xZZFOwVUjjXkbI08cdwKGSeAU3ts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fkDeNu+H4AejWPaGDdgyWju3XPs4aU/s9RSc7SlhVr/J6tDUE6ZmioABJ+DSYiMNX
	 BjeO0bFLPmdToOwoOw3aZY5CQ3nxHiQxWl4cL45dpkXkefQUfGx+bhJGJsHGZ8kdrd
	 Bkv4imXVAH0fW9cjrYmabvwIdLd+DDQUMznxv7ffVZ8C6VKKgBlkRYKFhKcv8Mu4B7
	 KQfqSYz6ycODwT65fpfPm6QlooCW9e+zS2U78LPvLIDqv8DmG/P6mbdr0z0CtIQ0IP
	 mRBZ8pNDW7+69UKXQpgaY+dZ9+qvxeQgAFPtpFbR7Ez4UXubpRQHGHagw336p6ddg3
	 w3wAg5HDt4GiA==
Date: Tue, 28 Jan 2025 18:13:30 +0000
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
Message-ID: <20250128-crazed-crudeness-f7b1fbc87f1d@spud>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
 <20250127-counter_delegation-v3-8-64894d7e16d5@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GvgqpjPPPGH/clyG"
Content-Disposition: inline
In-Reply-To: <20250127-counter_delegation-v3-8-64894d7e16d5@rivosinc.com>


--GvgqpjPPPGH/clyG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 08:59:49PM -0800, Atish Patra wrote:
> Add description for the Smcdeleg/Ssccfg extension.
>=20
> Signed-off-by: Atish Patra <atishp@rivosinc.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--GvgqpjPPPGH/clyG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ5keSQAKCRB4tDGHoIJi
0rDgAPwON9XqyKUy23jJH1lSiqhZdCPhX0R4hX2MfIgKmnZOeQEA77rnupIw+zEX
DD6TjYVZE8nXtyNpDTjlWlsM7onJhwM=
=kpCk
-----END PGP SIGNATURE-----

--GvgqpjPPPGH/clyG--

