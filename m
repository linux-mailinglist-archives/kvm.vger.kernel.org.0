Return-Path: <kvm+bounces-21106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8F7F92A642
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 835051F22472
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C241442FB;
	Mon,  8 Jul 2024 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyZq0sxe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5AD1487ED;
	Mon,  8 Jul 2024 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720454030; cv=none; b=NAEtwfbmrxeGtVaDA5KK7L8qUSBmJsGlD6Prvh7PSA+8RUe0yaGsc3Fygx2meUB7Tf6+/qvhG1K62q5RlCeGRkWjWEPIlyOdK30Slbd10ovmoITONDM71tPChH+4lGCtgtL8aLHr6nxH7iikoU7Zpgnv44nCVd7k7/ueCGB2eGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720454030; c=relaxed/simple;
	bh=2HMIO4K+SHCTIb+8BDQJABedFYsONFuY0Xzr83IVt/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0jkCnDD7TnbQyxJQSkO2U6IPNi+2kL4tGqdGQTpGD4UPywHPd+uqyx8/HN/Hare+5V3eP0DnI+i2a3sjveiqwj/v3Sd5+blMbdUWQ35MUuWFkkSuKwfSqNwDmouofsz3PQxeXMgzQ0IoIjgCagRF8JT1iewdl6oaBT3oiRzq8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyZq0sxe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268CAC4AF13;
	Mon,  8 Jul 2024 15:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720454030;
	bh=2HMIO4K+SHCTIb+8BDQJABedFYsONFuY0Xzr83IVt/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OyZq0sxeCjd23VqAcSKqkzWSZBU2jvnB3LLGPSkU+A+Gfbh8u7awVrFlKJ9O07SwG
	 tvFcyQqEE0jjEZ08X2aWWrQr8b5D2CxMe/YRrUHKpV+7022bI9CFxz5v+msH4J96Sw
	 d1er2JX6TTfLmvBG+rEkpTOg0plbcj/9E9hiBbQ9kpl5vSn0zH2VOMmP/Bsa5pjuNT
	 khFlkWKLlkIFhx+IOfyg8jlXH22uKJcjD9M8wuQuzEpbqrWbpiPscq7KqB/cMdcZZl
	 8AF8vzBfz3oQdYPyz20LMjOdx3jHWyl+NPrINFzWRt5rA7Vl3GqARAhoS0BDywev+9
	 ek1KTBfiI+IyQ==
Date: Mon, 8 Jul 2024 16:53:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 1/7] KVM: arm64: Move SVCR into the sysreg array
Message-ID: <0b3d7e18-e024-466f-b79d-859eb320ac09@sirena.org.uk>
References: <20240708154438.1218186-1-maz@kernel.org>
 <20240708154438.1218186-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1GRwR6KARsg8Xwf1"
Content-Disposition: inline
In-Reply-To: <20240708154438.1218186-2-maz@kernel.org>
X-Cookie: Many are cold, but few are frozen.


--1GRwR6KARsg8Xwf1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2024 at 04:44:32PM +0100, Marc Zyngier wrote:
> SVCR is just a system register, and has no purpose being outside
> of the sysreg array. If anything, it only makes it more difficult
> to eventually support SME one day. If ever.

Right, that's why the SME serie has a patch adding it to sysreg -
it was kept out due to feature detection.

--1GRwR6KARsg8Xwf1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaMC4gACgkQJNaLcl1U
h9BG0gf/eTLbiBcaHtBeq57BjW5GLQip7iOqbODqi+y/tufP3QVFijfRRaDwkO3y
UZtX4869WIMH2FmYnqVial/xX1Wg7GSWImYc9Nx6GjfvsilqwamGEq5JMbZVSnll
bxE21iEmFf81+lZ77lqFiZpMERd65kAQ9gIm3yCtw3oVpEuPu0wxc4l9jwKGSX1G
FzDaulJU+oaJ7gtGyUojVVKiizTeckcOG+eGsutFxNZqi+wEqx1n14CIeFgBPxt3
lfw8QDy6DQPU5GXUn0bf0MdSdN24YnG1dzHG2bswnAmAtMNEklEosYkW7F+lJUZd
r+lyTcUXMygCkv9k3rCXoxOnBm4wqw==
=vC0S
-----END PGP SIGNATURE-----

--1GRwR6KARsg8Xwf1--

