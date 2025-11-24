Return-Path: <kvm+bounces-64391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id F106EC80BCD
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 14:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5A6A44E5A8E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B037A18FDBE;
	Mon, 24 Nov 2025 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJ1Hmwx9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C40321ABD0;
	Mon, 24 Nov 2025 13:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763990594; cv=none; b=b2BpwNqHCvFP4U4DD8fbYZ9F6sMwsEjx8pfYd6XKQBcPYgCmFgaQTpJGiZaPS1r/0oCCpqwqoGmdXnzmiE8a8rWU23G9FXpKx1F4JvTEe1bsHqrmBgovuI1029IF/YZdwqlsm/moh52Nh4LPVL6Ur5bJV9PIDZ6i+06zxbW2Vo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763990594; c=relaxed/simple;
	bh=ZkveGrdkvCfPZFoOUJbbqtFMDnhuefLqnTOZdpFUeTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqnpdNoIZ2UT1DxSltOvIQ1Xs0TcZXDVOagrjnbCDVAklPTy0/Rr/kVGYvzxRZV2WEOdsH6rTlXkXXRhEPzUwhv+niRo6FNVsReI9VJf50GN9AzzQXwv3jXOpXXZIQ30Kp7a2k1Xl6SVEEC5BOPnJuldSF+4Ma+EwmoabizXLck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJ1Hmwx9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E1AC116C6;
	Mon, 24 Nov 2025 13:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763990593;
	bh=ZkveGrdkvCfPZFoOUJbbqtFMDnhuefLqnTOZdpFUeTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iJ1Hmwx9zq6u/cnF1AWukxT1quc2d66mXECA5dl6e16/7bLcnUFeBC4B41HvRk+UD
	 D4aU5LTRl7k5mw/273TdJmLhqIhN4sJIjtY9G5l29ZQyuvbnyqmZ+yf/CmEnxcmAmP
	 eQnFIu1E0Pu2VGOXIT8ARfUhq4avwxSjHb98EtCIJaGJoJBEE4YcNmwAIZ1anWYJ2n
	 OHcT4HtO10dn9eUzFCnYefUIQ0fcJa64sUsJxvyGIhmxKudlURT5moD0SxXxYKFcVW
	 6VzQK9fc3/Y/3uygosq1OfKSn04to+6Fz/6qr9+NjlxqmuNUfl+yBYpVvz+kA7j2Yj
	 xVVai9St2BZuQ==
Date: Mon, 24 Nov 2025 13:23:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v2 29/45] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when
 interrupts overflow LR capacity
Message-ID: <342302ba-5678-408a-ab63-1a854099d4a1@sirena.org.uk>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-30-maz@kernel.org>
 <CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com>
 <86cy5ku06v.wl-maz@kernel.org>
 <51f5b5d7-9e98-40b8-8f8b-f50254573f3d@sirena.org.uk>
 <86o6orr356.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hFXx54rNo6XRJZ1B"
Content-Disposition: inline
In-Reply-To: <86o6orr356.wl-maz@kernel.org>
X-Cookie: Single tasking: Just Say No.


--hFXx54rNo6XRJZ1B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 24, 2025 at 01:06:29PM +0000, Marc Zyngier wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > FWIW I am seeing this on i.MX8MP (4xA53+GICv3):

> >   https://lava.sirena.org.uk/scheduler/job/2118713#L1044

> There are worrying errors way before that, in the VMID allocator init,
> and I can't see what the GIC has to do with it. The issue Fuad
> reported was at run time, not boot time. so this really doesn't align
> with what you are seeing.

Yeah, I was just looking further and realising it was probably
different - sorry about that.  I was checking what else was failing
after seeing the qemu issue he was, all the platforms aren't booting one
way or another.  FWIW with earlycon on the AM625 is showing similar
issues to the i.MX8MP.

--hFXx54rNo6XRJZ1B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkkXDwACgkQJNaLcl1U
h9C2vQf/ZbF4IdL2c4d01zdL9N7tPXlRLDT98/P32kMDIRLhCDDdoBw+Y9fOnYa7
KEbi4DHROC73/b49D7t63cVaBwBE55FSvyRk/XPWGb/KFUlzapbyEn9p338AojG0
TIihc0wE3J8q4W3vcJSmwIY+XoZOwQUuL8yxfoa3k+EAlYewtFRT3T7rMwGpvic8
kd5pt4mIRbTVM3rqOdpfq8xkzFVrQ0SZLrWVtzqPF+sEdjLdw15LH96rl6gzOnxt
nPeEylyci7LuRB3kPnw7pxYjOstZun3de+aEC0BLaSJxPWCW6y4N87RONHeZ+75j
jONlJPB3f5zFMqWmcO3lQlNXSnSUyw==
=fXcl
-----END PGP SIGNATURE-----

--hFXx54rNo6XRJZ1B--

