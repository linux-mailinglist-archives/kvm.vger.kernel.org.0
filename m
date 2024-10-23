Return-Path: <kvm+bounces-29570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2379ACFD9
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 18:14:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BB0E1C21416
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955EB1CB31C;
	Wed, 23 Oct 2024 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ptUI6ITJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689E1CACE7;
	Wed, 23 Oct 2024 16:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700033; cv=none; b=XO7kw/p0/awhV5wbnAdCBe05rt9BtSw+LCnPeoXVt0/YMheP3boAApLtmnkm/sjLFgWhyROAnc8WINKJxdRA7tBPK+nymYy1MXQpW78fS6MYKkGPJM8yi8Df8fAN1j6I5VQE4YzPBPeRbkV9wn85tU8atzEwREpJZnG4Jc42gnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700033; c=relaxed/simple;
	bh=UKrF+3JAsYvrc9zKdrxnsBzuHKK/Q/vC5JypSYYR3u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBR4cTb4GgAbyZGkfEU1mY4RP7bAJkKpWszN9HJx/9H9aALOvUxA6wpjKQVCvw3DS43MWpcb2UaZ20wINc/pklUXZanC9ZscczjdUdxOnpx5qNmV31o+3a2NfVW9n7a688eL2kMK/ZV6zRsteCKU5+yWJDwKmA3ia3Xrb8S3C+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ptUI6ITJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA4AC4CEC6;
	Wed, 23 Oct 2024 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729700033;
	bh=UKrF+3JAsYvrc9zKdrxnsBzuHKK/Q/vC5JypSYYR3u8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ptUI6ITJnyylzHi/pFVDz+ja6NQQaXmZSZFZ17HmRJCFw92MMGXGs92zmYaUhugE/
	 EwII5iyrqYHhqM76C5LKV2HtkQjBtEAlNigjswT97uOFj5JZO9oz8BVCm7YSH+pxNN
	 DIN0zGZfDvkL7m3WoQj0z/0r7M5+RFUM/A+lJofPdfgZ8DBJu8WFYU/CX2St3wukla
	 nH3u1FqrExbdgyNEahz9IALoxHr5z2QBUoiCUJT65+AEnwGib7m3wF8AJgDi61HXBg
	 bQCuznJdpb5tiLquWPje1sU37Hmg506srUtYW9cEAhgF53uy6MpfHFjDE0smybRLEv
	 eL31cK5dfx0mg==
Date: Wed, 23 Oct 2024 17:13:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 27/37] arm64: Add encoding for POR_EL2
Message-ID: <bef5f236-8bec-44af-bb44-a1c60184ad31@sirena.org.uk>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-28-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="81j28s7634StTB0z"
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-28-maz@kernel.org>
X-Cookie: A bachelor is an unaltared male.


--81j28s7634StTB0z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 23, 2024 at 03:53:35PM +0100, Marc Zyngier wrote:
> POR_EL2 is the equivalent of POR_EL1 for the EL2&0 translation
> regime, and it is sorely missing from the sysreg file.

> +Sysreg	POR_EL2		3	4	10	2	4
> +Fields	PIRx_ELx
> +EndSysreg

We should probably rename the Fields here, though there'd be an awful
lot of xs in that name.  Still, not an issue for this patch:

Reviewed-by: Mark Brown <broonie@kernel.org>

--81j28s7634StTB0z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcZILsACgkQJNaLcl1U
h9CLlwf+Og5cWMMbSKMvKfAYjr12+GMfwlv2bPVr/vo6SJd7qQVwjy7ZCotQUz/Y
EM46RUtI7zJZd0nbsG++3r0hbMpYCnL3z2261EMha4DyD1Apeq8Tw+ZqMH3Vvfi5
y7EYb2HV+5VAcBE8T8qctp6g4f1MT3uzKgrFpOTuh/KsWNUPlxuUpvL/KK9Qh7ou
jYuhb2BZEzECOCpfMz6IgBT6JARxIUg1BCp840Ao2Z9c9rYWWNYCh9dlNTwDQ3D0
h8xDx+jtPpcSx5HSLeGykJTmmwXSSVcL+Uzv/KJ20q4OUoNYnxbZkbYuAUio1r1O
Z1VXoZUt4mimVeSQJGtuXYI5+7nvcQ==
=CNyb
-----END PGP SIGNATURE-----

--81j28s7634StTB0z--

