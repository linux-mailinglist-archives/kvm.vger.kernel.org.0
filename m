Return-Path: <kvm+bounces-62765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D53C4D9A3
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 13:12:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 74B554FD1D1
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 12:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37DD3559F8;
	Tue, 11 Nov 2025 12:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRGCfqeX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3ED32E6116;
	Tue, 11 Nov 2025 12:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762862701; cv=none; b=nJ3bzMcK7E0AwvwFSLXmRcNsVf4RKkhfQ4LY7LhNPWi/Gl5fWnpeojV4rFCZfQEYYGSfiJXe+SpNYQ6f17VM9PcoewTjRq2c8XLQMH4TG9OiEOnv4IfdmakNj85xHiycJ+uwzWCV11aEnP2KOqCaOjev7/x8gQueGC63fq/0mV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762862701; c=relaxed/simple;
	bh=Rj/Ffz6hWZOnKL6lUXw9bBydLKj+ya5olampmLUhD6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=At94G8ZFU8YGHBeAnFdp2EUCFLb5agPTO9QeocLvbU/lX1MHAeW/+kF5fe33w6jRDx5Oqo+bQI7uNhXqOhwUd2a3EchAO+OUXBaVEppbkgAaRRMImB5Gw8P5/wOETK3Gmf8degTbWsxkceKopOuc+xmsoNoI2qLqQfo5UcxSgZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRGCfqeX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E004FC16AAE;
	Tue, 11 Nov 2025 12:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762862701;
	bh=Rj/Ffz6hWZOnKL6lUXw9bBydLKj+ya5olampmLUhD6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IRGCfqeXtVbKlLi2wEo2Z7mqPczPhzbwL7YTnc98QY8J945F4mXyyWYWtqKq6TPfs
	 K42bkkFxokP+VQvg1yp/8D8naqmI0qlvRJhYOpY4rmdXGkdq5xen9yxhOQicqJp9dK
	 8+0ChkZ9Yg2euz2BtNXsysvp4TRRQKW/MRb2B7xdEuZdETAJkMd1Jlw05cpF18sSPp
	 bnqy4VGAIqZhwjMLWcVjTTvNXkKK0sWw+hOCzW3DdrDxzvt/YQl/nDf8SyEp60MqA4
	 70UmESZlEzt3X70Rr0ChfXLa2MWKnracGfrOFuUlnXXHeIp5/eR47/0+VNFzYgGPjA
	 YEQ3MKbWsOPcA==
Date: Tue, 11 Nov 2025 12:04:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Finalize ID registers only once per VM
Message-ID: <aRMmaLBxLI025Bpe@finisterre.sirena.org.uk>
References: <20251110173010.1918424-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="botkdb13y08NZZbR"
Content-Disposition: inline
In-Reply-To: <20251110173010.1918424-1-maz@kernel.org>
X-Cookie: You dialed 5483.


--botkdb13y08NZZbR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 05:30:10PM +0000, Marc Zyngier wrote:
> Owing to the ID registers being global to the VM, there is no point
> in computing them more than once.  However, recent changes making
> use of kvm_set_vm_id_reg() outlined that we repeatedly hammer
> the ID registers when we shouldn't.
>=20
> Gate the ID reg update on the VM having never run.

This resolves all the test issues I was seeing:

Tested-by: Mark Brown <broonie@kernel.org>

--botkdb13y08NZZbR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkTJmUACgkQJNaLcl1U
h9DYqAf/dM6FdLxmhP9fECQFCQKuAMwwwUPye6YkHnpfFANgWBy4Hz9Wo5el5bfT
olCIEzv7zloQ90R5wFf5TvfbdToJNUAwwbosgLOoyPXFT2XDsnT6gyl4mO3Q52nd
zM0zwhZR9/1DAXr305wyhtYDdbWXaM4Q/t+CzBQEB8ad1yI32GTBhDjciAfHdPm+
K6PDHYFGn6ZSCie6e/WFAPOU+AKp/Crl6AqxxlFkytXKW3f4tpw6Oon1SJ0t224N
ssAUc5ZAtTFcGY2vSSDsAANZnj2y9tWLAMzisJp/kBFIrIlWbEKd7mj66EBnVa5r
J1AzIEzPcyyel+JUqEkqagQ3nKkZJw==
=V3rN
-----END PGP SIGNATURE-----

--botkdb13y08NZZbR--

