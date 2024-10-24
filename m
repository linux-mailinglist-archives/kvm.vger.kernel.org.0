Return-Path: <kvm+bounces-29636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6159AE56A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2204F1F236A2
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630F01D63DD;
	Thu, 24 Oct 2024 12:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMntBTRg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885571D319B;
	Thu, 24 Oct 2024 12:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729774558; cv=none; b=iKvnSy0T1IybYyf/HUG080j3JFyxnTBlKxe5zSkPvsKBP8YlIX92gsgSA8C84jFZlpavvh1k08sj9nF6xAjrvOSWOIlinBp+ftqIZ7WxV8XYvi81Du1270GSXKZDjCs+P6yKsSJ6i5AgrDAMO1N2ZnNbgZXx3aRIYLlpcu4rF0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729774558; c=relaxed/simple;
	bh=klCzLI1Jv7dNAj0tikPJt7sDFVqShxr+T7TfoODWh2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkTqhHL21crk6jmUUdvNeFjX3ax7f3f49kBChGON2/HTYVaATff0aXIvRL3EU61cK3P6mbp6yT3vMFOS2gOjMJuk5nJ3MhRVDzeRBwfvIv/fig2qgSzq848U/2l2Q5iaBQpkWuGeAIt86zM+KcUiDmiKT18Ypd2F746l/rBiBTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMntBTRg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F060C4CEE3;
	Thu, 24 Oct 2024 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729774558;
	bh=klCzLI1Jv7dNAj0tikPJt7sDFVqShxr+T7TfoODWh2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMntBTRgMrvJQIzj03H9cRXN7FbzlM44NGal0mcHABZmr33TMMgdTlcBhXnILLFzz
	 0CQTohxakmLWqWpBddFR8va80U4Nkw5/RG97hWknY9XonTik8fDC2GtP1Rs3pJAx4P
	 1r50Ei4Z/dslcCWqmhy3Y7UywvWTaDLSRJkYftfRDkwKmF72sT9fBSjYmQtA3xMdwz
	 w5xKjIxHmC9vEJH9AOKGFBLT194KmzS4H7LPYRBWp/VKz1/sPkNrfBg7mQ6OQQTcW+
	 s5JchFKTbExCkG9nKHHEAU1bbmmekHbuI/g1Q6WO0fT9imYZMq4XtRm75r+rUCBRk/
	 ZVyh1apF0SVhw==
Date: Thu, 24 Oct 2024 13:55:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 17/37] KVM: arm64: Sanitise ID_AA64MMFR3_EL1
Message-ID: <8fcd3716-901d-4fd0-8786-7bf612066f61@sirena.org.uk>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-18-maz@kernel.org>
 <33681a4d-2ea4-416e-9e2c-81a89a78c4ed@sirena.org.uk>
 <20241024124528.GA1403933@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tYWgyLjV7ZKA67pB"
Content-Disposition: inline
In-Reply-To: <20241024124528.GA1403933@e124191.cambridge.arm.com>
X-Cookie: Real programs don't eat cache.


--tYWgyLjV7ZKA67pB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2024 at 01:45:28PM +0100, Joey Gouly wrote:
> On Thu, Oct 24, 2024 at 01:32:09PM +0100, Mark Brown wrote:

> > The changelog is now out of date, POE has been added.

> This will disappear with a rebase won't it? Since you made the same chang=
e in=20
> d4a89e5aee23 ("KVM: arm64: Expose S1PIE to guests"), in Linus' tree.

Yeah, it should go away if the code is rebased.

--tYWgyLjV7ZKA67pB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcaQ9gACgkQJNaLcl1U
h9Akzwf7Bi8xmtq6ivZTHX80fZiWWoXCIXR0kvqvB6/i/hyQEo8tdAJnNswLOzvQ
38tAqpibOfQ4Qo1ite5uWxbTQWCIWT3d1pF0jzBldQ0tAGxT+4Y7zrkS9rTWFqqD
GzLBljMIeFWvNgaNpbpZp0DFuQWNh6i3ewHBtpctBSadul7ZJm6RjTlK7ujwe8BD
y6jB2i6Q8WCwUp7bO7O+43OWFYF71fMpH8JvNXwEp0pKEBH/66kTEKFpRPoYOrkV
VOax2p83LFwuP8xCMIQbhDxFyuSL2lKncWveYXNHDAmoEfpFWfzk+wPLWtC2srPy
XLZZi7LrDgwtCzcgHv+J6E8XV/psuw==
=3TrK
-----END PGP SIGNATURE-----

--tYWgyLjV7ZKA67pB--

