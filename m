Return-Path: <kvm+bounces-64352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 991ABC80472
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8869F3A8629
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB592FF663;
	Mon, 24 Nov 2025 11:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeFPtxm8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B63E2FE598;
	Mon, 24 Nov 2025 11:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985133; cv=none; b=qDSZGDGexUIAg86AGJyGPmzZ9hMQf69XXs9gqiYs6V6bVPXed76vMp3aqYNxEqTJUcvgW4F9RimCbYlpOjRaWJ5vkGlv7rdKW14mZwMIig9j2ql4NXIeVjjhispsacksjydtRRiZa5M0sma4q41RjpzqhQmP+6VVJK0OnNx76v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985133; c=relaxed/simple;
	bh=+A0RZRVEBIVa97yRu+iGJ3OLNh6XAPvgUo5bkd4evxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUeSckCB/Qb0j/r+qjJODrdvS6FEwUJho2Md5gw1xMwdv0tu4OiRT89Q6P4uyOjJXqm3e3QVr7u06VrzTGa4ZPbuxERoVY4FyuLM9SNQlMc05sRD7YFFRTjZenEitbt4imqM1Yxfr2OGS20RFeFdOwiXX22tqMB5IlxCGS3a9Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MeFPtxm8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D59C4CEF1;
	Mon, 24 Nov 2025 11:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763985132;
	bh=+A0RZRVEBIVa97yRu+iGJ3OLNh6XAPvgUo5bkd4evxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MeFPtxm8ba1BCOfiVIPu4YL4MMPX/jRMyYFXWRaJlCoAkTJRQkgB0Ft8RTKvu9Qqi
	 C/qZ3h9LzrZrHcrmfmaGIP+bQvmZdUDkMtR4/VVXWJLoDOtkymHbTUDW4vBDN1bqkR
	 oiKdcR69YqIWg78G+3cuNjoBsZTWGB3+DVV5UN8w9bvweinTbBimnncrn5MWQUtogE
	 ZTB3xUlwWtiRLNIt+38dP1f/u8RuMiXO9Ok5EpApoTzbw9JRMCgD8tP6AufgovpfpI
	 bptfQO2t5TZrzzRefmUFV4aa9UyWbvKG9+NnBg0dvFWtEazmQEYi6l/gv1NfWD+L/i
	 8HMTTCO5/odVg==
Date: Mon, 24 Nov 2025 11:52:07 +0000
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
Message-ID: <51f5b5d7-9e98-40b8-8f8b-f50254573f3d@sirena.org.uk>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-30-maz@kernel.org>
 <CA+EHjTzRwswNq+hZQDD5tXj+-0nr04OmR201mHmi82FJ0VHuJA@mail.gmail.com>
 <86cy5ku06v.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GQXf/xg20mFSxdaQ"
Content-Disposition: inline
In-Reply-To: <86cy5ku06v.wl-maz@kernel.org>
X-Cookie: Are we running light with overbyte?


--GQXf/xg20mFSxdaQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 03:02:32PM +0000, Marc Zyngier wrote:
> Fuad Tabba <tabba@google.com> wrote:
> > On Sun, 9 Nov 2025 at 17:17, Marc Zyngier <maz@kernel.org> wrote:

> > > +       /*
> > > +        * Note that we set the trap irrespective of EOIMode, as that
> > > +        * can change behind our back without any warning...
> > > +        */
> > > +       if (irqs_active_outside_lrs(als))
> > > +               cpuif->vgic_hcr |=3D ICH_HCR_EL2_TDIR;
> > >  }

> > I just tested these patches as they are on kvmarm/next
> > 2ea7215187c5759fc5d277280e3095b350ca6a50 ("Merge branch
> > 'kvm-arm64/vgic-lr-overflow' into kvmarm/next"), without any
> > additional pKVM patches. I tried running it with pKVM (non-protected)
> > and with just plain nVHE. In both cases, I get a trap to EL2 (0x18)
> > when booting a non-protected guest, which triggers a bug in
> > handle_trap() arch/arm64/kvm/hyp/nvhe/hyp-main.c:706

> > This trap is happening because of setting this particular trap (TDIR).
> > Just removing this trap from vgic_v3_configure_hcr() from the ToT on
> > kvmarm/next boots fine.

> This is surprising, as I'm not hitting this on actual HW. Are you
> getting a 0x18 trap? If so, is it coming from the host? Can you
> correlate the PC with what the host is doing?

FWIW I am seeing this on i.MX8MP (4xA53+GICv3):

  https://lava.sirena.org.uk/scheduler/job/2118713#L1044
=20
I'm also seeing boot failures on AM625 in pKVM mode but much earlier,
before any console output, so there's some confounding issue in that
case (non-pKVM boots on the platform seemed fine, I'll investigate if
it's still a problem in today's -next).

--GQXf/xg20mFSxdaQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkkRucACgkQJNaLcl1U
h9Ctwwf/UjCM5goRKvuE8EnGB6VSLcY7irSfXLjXDneE5T4Zooihr4CpVDT0cfhR
qKXjvRw5wtUrm6X5KEcicUo6bm2AJK4EfEY+d0X+QYW6cN4BHCDzGnb15uBtdwrA
lv/ncF2ZwZcgwxl3GyQInmZARS4jjSYTLpCGMid0MF68cZ3d0M2WalchkopHRBl7
piZqsQOU18T0NR2p8Vq5RYjztxSKpumbctKAF+CFOjOxjAFUU5ys6h12PfI0UnHI
QQgrQ8UpD+Z5d5aZnZnOVj1k0ehaPojN1Agnl+ThGdS1m0YxVIYhfyUUB+irJikj
vYGcRfxjfZYci+1+860etlcUDyiqiA==
=KDCh
-----END PGP SIGNATURE-----

--GQXf/xg20mFSxdaQ--

