Return-Path: <kvm+bounces-33001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE61B9E3795
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D8171610BB
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332011E1A3B;
	Wed,  4 Dec 2024 10:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="yHzctCnE"
X-Original-To: kvm@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39191DEFEA
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 10:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308286; cv=none; b=ujovG31Vb4BtYmNi+i9/SRUnS4skPE0uyNFO5NNn3zHUJIk+jD1yX8TSgKgbsRhfQuDHVagQUXJdeGUv7z6P6U/72TACdVsdNuIGPfzvMvL74+N+JRkDIRMakXM2gPVZCPBzFg5ICHiEHGznLKWlj+3d89wbrfMEjKQZNNrsLLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308286; c=relaxed/simple;
	bh=r0YdPCfkW3WmeY7CSxvYSy9ijT0JApNn+evb9OV6AyY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjdPLofNy9g85O0gGsFRC5YHsofXZL6o6zyu25VImOcMcMhYJ6KqQKnQVwPIBZmCQa/ZUdsBT3KpfaVE+HYAqu5bpX+9+bpds3h8EMmkYhG6RnG3jH2agm9viVHFgtFVTrZAi+A+Zy2nBBRjZ8TzjFWphkCeRl+DSYu/PmJT2EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=yHzctCnE; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1733308284; x=1764844284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r0YdPCfkW3WmeY7CSxvYSy9ijT0JApNn+evb9OV6AyY=;
  b=yHzctCnEpuvMQVfARxD1LrffKY6jWzgkE5BhtK6H50hJAy+FIaBupAeT
   HmWm/j66jsgtZeoKTkB8QRcJE2O0Ie+tXSlSO7tqg5HGgCiOpWKBaQGVd
   1ICaq2NunxcDsxjac5kEq6zSURad2Sc3yV3QjlTP03hY43wF5C8jOVQo4
   1v6DnP/hqID8pdbDKUJynZSwFsGyMmqj6Y2C91VDnyEfiwWbu2t4pgR3/
   qFL/B/c6VR7ZMlxSGqR9L0tBAXtRPhV33bCWhRQ9FHD5BS6kgGQ07/AGF
   y+PHxEFa5NqX37CPAcPv9VntR5f9fo7KgwiqP6xwF+8TlFZUdnbVFxC9j
   Q==;
X-CSE-ConnectionGUID: CZPZjHfUTDSgQz0WJMX9AQ==
X-CSE-MsgGUID: C7yECW8eSqCGXf/l/TDPkQ==
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="asc'?scan'208";a="38772663"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Dec 2024 03:31:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 4 Dec 2024 03:31:14 -0700
Received: from wendy (10.10.85.11) by chn-vm-ex03.mchp-main.com (10.10.85.151)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Frontend
 Transport; Wed, 4 Dec 2024 03:31:12 -0700
Date: Wed, 4 Dec 2024 10:30:44 +0000
From: Conor Dooley <conor.dooley@microchip.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
CC: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
	<palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Damien Le Moal
	<dlemoal@kernel.org>, Anup Patel <anup@brainfault.org>, Atish Patra
	<atishp@atishpatra.org>, <linux-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
Subject: Re: [PATCH] riscv: Remove duplicate CLINT_TIMER selections
Message-ID: <20241204-aliens-cover-66b60e058ca4@wendy>
References: <448dba3309fe341f4095b227b75ae5fc6b05f51a.1733242214.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="g2aKOaNiiQhFm06t"
Content-Disposition: inline
In-Reply-To: <448dba3309fe341f4095b227b75ae5fc6b05f51a.1733242214.git.geert+renesas@glider.be>

--g2aKOaNiiQhFm06t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2024 at 05:15:53PM +0100, Geert Uytterhoeven wrote:
> Since commit f862bbf4cdca696e ("riscv: Allow NOMMU kernels to run in
> S-mode") in v6.10, CLINT_TIMER is selected by the main RISCV symbol when
> RISCV_M_MODE is enabled.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
and in case Palmer isn't sure if he should apply it or not:
Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

> ---
>  arch/riscv/Kconfig.socs | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
> index f51bb24bc84c6e47..d4ea91cdb2b138b2 100644
> --- a/arch/riscv/Kconfig.socs
> +++ b/arch/riscv/Kconfig.socs
> @@ -53,7 +53,6 @@ config ARCH_THEAD
> =20
>  config ARCH_VIRT
>  	bool "QEMU Virt Machine"
> -	select CLINT_TIMER if RISCV_M_MODE
>  	select POWER_RESET
>  	select POWER_RESET_SYSCON
>  	select POWER_RESET_SYSCON_POWEROFF
> @@ -73,7 +72,6 @@ config ARCH_CANAAN
>  config SOC_CANAAN_K210
>  	bool "Canaan Kendryte K210 SoC"
>  	depends on !MMU && ARCH_CANAAN
> -	select CLINT_TIMER if RISCV_M_MODE
>  	select ARCH_HAS_RESET_CONTROLLER
>  	select PINCTRL
>  	select COMMON_CLK
> --=20
> 2.34.1
>=20

--g2aKOaNiiQhFm06t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ1AvNAAKCRB4tDGHoIJi
0vHtAQC82qG49EDSoaB2PeTLrfhjmint5mOs27szHVRiwtSjhgD8CTPFKDSZQ/N0
ltKkzalZOnfOWfs44+mL9vkAJURnBwQ=
=yxzy
-----END PGP SIGNATURE-----

--g2aKOaNiiQhFm06t--

