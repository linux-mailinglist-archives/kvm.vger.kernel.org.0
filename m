Return-Path: <kvm+bounces-23040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED74C945E4D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 15:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 967B91F233D9
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848CE1E3CD2;
	Fri,  2 Aug 2024 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDTAY15H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F401BE87A;
	Fri,  2 Aug 2024 13:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722603792; cv=none; b=pOl79YQgHLztTeQq3/OTvQ4+jxLXLyBuNbLVyN1nYcSIxTVZngAWFrGKv2Q7uYRl2QQJc74ZQB7ProDYZXnY8YdjURtqKXTfUfD3YZLaY6pxJ5a/yFsArHGTYfBnT4bdQeeFXdbQPf8QJufbdXuE7JAfAYg71UrTIPfgrel2+yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722603792; c=relaxed/simple;
	bh=eNepbBfqF2TuR1nUKNmOJBk5xlbLcvyFSrrd+Jt7kUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QvHbD52prkxpu61Q8gKzzA00QbYPulj598+V6uGhdUReyTWcIWpRF79llHBpcNOq8GHdGxQqzOm8We5JFZ1J+7xyy9JFXjkxUAd3uTE09Y7uGHo/4yEHv91nnsflHg92tUzcL+bjtWEHKN46f288B4P11gqz9hhXOPpErxDgYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDTAY15H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CD4C32782;
	Fri,  2 Aug 2024 13:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722603792;
	bh=eNepbBfqF2TuR1nUKNmOJBk5xlbLcvyFSrrd+Jt7kUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VDTAY15Hytw4gdcOvPPNroOgf4uEUcaGz/MrzVZpPIpSDk8xF8B75VqRNAcpCuYtg
	 stSojknuFbv6Fqxse0NG4WSThhOhOqtpf/uLiW3+knz+y15tctTw2gu/K59QrhDF4W
	 SWXRIQ2WYOM7NWXDuCypncuOuWRX+2njXV12lhKdJyZeI3GvFZPNuqIH3XK/ICSzIl
	 rNx9w47OcKGL6ZkzK8074yHC7+JCkcmBG30vPf9es0Dm9aU24wpXia2Waq7zjxMlM9
	 91MHEVyo0/G+kTd+D1OUOM3sS9M6edbgLHxXho+9umqzV8sXg/AeNWCV0+A5qqOfo/
	 D09d96/wW/qgA==
Date: Fri, 2 Aug 2024 14:03:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH v2 4/8] KVM: arm64: Add save/restore support for FPMR
Message-ID: <3a18d8e8-c610-47f6-8f86-4e9e5188cd40@sirena.org.uk>
References: <20240801091955.2066364-1-maz@kernel.org>
 <20240801091955.2066364-5-maz@kernel.org>
 <1a00165f-7ae5-4c58-9283-836716205db7@sirena.org.uk>
 <87ttg43szf.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s4KEHDyvf9qME22j"
Content-Disposition: inline
In-Reply-To: <87ttg43szf.wl-maz@kernel.org>
X-Cookie: -- I have seen the FUN --


--s4KEHDyvf9qME22j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2024 at 09:09:40PM +0100, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > nVHE is faulting for me, apparently on the kvm_has_fpmr() check though I
> > ran out of time to actually figure out where exactly it is going wrong.
> > I'll have a further poke tomorrow.  Backtrace below.

> Well, that's actually pretty obvious when you see the crash
> (FAR:ffffff880115cd1c spills the beans).

Ah, good tip.  My problems are usually more to do with traps than
pointer dereferences.

> I'll rename the variable if that avoids people getting their brains in
> a twist. Full potential fix below.

That's working well for me here.

--s4KEHDyvf9qME22j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmas2QkACgkQJNaLcl1U
h9DnHwf/Rf3JY7dWR3sez9zyBv1qu/LhZHai54OD5JxwRPbSvDcwawZx6giVyzH1
PcmysPYEAdSh0nbZ9K953ZtNE2+FJzWwVvtpAzaQLxDkWFYS9RByyejH4u0jX356
hqO8A3IsJtzoiXTj4wTNATGV7ewkxrBgmTdT4CeT+Wd3M+icSZWP9H/VDcu5mLHn
RSoqOJ74J/iYFAZMKfFUoVGazOfOl5bVsO8U1wWPF3CYlRnpbWhLiNPiIF2KBI/j
zlY5WRODw2pY39CUoA18hYQZc3AHcoGr0bkxrSXwj7ipANeur+bGSaOTWGBV9Jrc
P/szgsD8ULRvlDfbyW07C/PhI3CkOQ==
=3kCX
-----END PGP SIGNATURE-----

--s4KEHDyvf9qME22j--

