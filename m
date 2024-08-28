Return-Path: <kvm+bounces-25305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF29963554
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 01:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E2ED1C220E8
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 23:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39ABC1AD9FC;
	Wed, 28 Aug 2024 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niLDzTj1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A451AD9E9;
	Wed, 28 Aug 2024 23:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724887378; cv=none; b=Rln9Hx+IP+KvlDbQ4DFNEX9MPshIVSk6fD4vn0Coq4d1KYUh2XNQt/Qd+UognmyNA7YST5fNfns+MkURWm+RBxuTpXnCGIIQ4XlkzLhaKEFqRA8nyuCythrpWIS01eg2x/oqaaXHWI+EUfhXQsC3Ic/uoDG9ZjjXRahd3Zkckdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724887378; c=relaxed/simple;
	bh=stYGe9beWSBEYcsSQRMZ32Ehkf+ocCoS50uBe3fjGoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+C0Y8l5Jzf7umR4ogQjxoeJ/GKDamtvPOk8KZpj2cGfWQ90W2cvo58KB+LZbGKnsGwwhSh9ukHLBZgG0BeNgKiHlPdukZFTl2NGVLcljvCEWpQpcyulNw3ZtDZozfIDGdaEsDOJl5wInPZ77W8U8UkpkNFwuEc9/bpAZQfeJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niLDzTj1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11AAC4CEC0;
	Wed, 28 Aug 2024 23:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724887377;
	bh=stYGe9beWSBEYcsSQRMZ32Ehkf+ocCoS50uBe3fjGoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=niLDzTj1m3PygOqJLIBumKUMHEZE4h/Uueo0h4OTGzVjuNw9Pozw3xhs6UnOyhAUr
	 xDSj2NFrIWcF6bC3oT2owEgTZa7MwT4eUo1iQ+SzF0LnTUNv9wdVJZVE95Neak+ocY
	 4JLJH5L3onnKvvg5qGD2+2ZXkHSJuTVdCEMoiL7NlXA/1DayXtIT1m7Nttff0/yvKq
	 F8Y+GFbMFPrMLK7NGQzmoGgsL3+3u9RzZ/ZMM85f+K1NwZSrm/P1Cw1mIc87A9lI0N
	 BC4X31d4lWjacj87AKfknrNd2RxM6h5bG3nDznz9yMc8iEWgk7axMZnpGyjAzD0yMv
	 LywaMhAcqNnTQ==
Date: Thu, 29 Aug 2024 00:22:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH v2 05/11] KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no
 GICv3 is presented to the guest
Message-ID: <fa2ea6cf-0ee9-4208-8526-3426a78895a8@sirena.org.uk>
References: <20240827152517.3909653-1-maz@kernel.org>
 <20240827152517.3909653-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mTeBIqFzdJh+yJcd"
Content-Disposition: inline
In-Reply-To: <20240827152517.3909653-6-maz@kernel.org>
X-Cookie: You have no real enemies.


--mTeBIqFzdJh+yJcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 04:25:11PM +0100, Marc Zyngier wrote:
> In order to be consistent, we shouldn't advertise a GICv3 when none
> is actually usable by the guest.
>=20
> Wipe the feature when these conditions apply, and allow the field
> to be written from userspace.
>=20
> This now allows us to rewrite the kvm_has_gicv3 helper() in terms
> of kvm_has_feat(), given that it is always evaluated at runtime.

This patch, which is in -next, is causing the set_id_regs tests to fail
on a variety of platforms including synquacer (it looks to be everything
with GICv3 which wouldn't be surprising but I didn't confirm):

# selftests: kvm: set_id_regs
# Random seed: 0x6b8b4567
# TAP version 13
# 1..81
# ok 1 ID_AA64DFR0_EL1_PMUVer
# ok 2 ID_AA64DFR0_EL1_DebugVer

=2E..

# ok 79 ID_AA64ZFR0_EL1_SVEver
# ok 80 test_vcpu_ftr_id_regs
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   aarch64/set_id_regs.c:449: test_reg_vals[encoding_to_range_idx(uc.args[=
2])] =3D=3D uc.args[3]
#   pid=3D1716 tid=3D1716 errno=3D4 - Interrupted system call
#      1	0x000000000040249f: test_guest_reg_read at set_id_regs.c:449
#      2	0x0000000000401cc7: main at set_id_regs.c:580
#      3	0x0000ffff9a737543: ?? ??:0
#      4	0x0000ffff9a737617: ?? ??:0
#      5	0x0000000000401e2f: _start at ??:?
#   0x1001111 !=3D 0x1111 (test_reg_vals[encoding_to_range_idx(uc.args[2])]=
 !=3D uc.args[3])
not ok 6 selftests: kvm: set_id_regs # exit=3D254

That's running test_reset_preserves_id_regs.

Full log at:

   https://lava.sirena.org.uk/scheduler/job/661438

The bisection converges fairly smoothly:

git bisect start
# status: waiting for both good and bad commits
# bad: [195a402a75791e6e0d96d9da27ca77671bc656a8] Add linux-next specific f=
iles for 20240828
git bisect bad 195a402a75791e6e0d96d9da27ca77671bc656a8
# status: waiting for good commit(s), bad commit known
# good: [0c78c247d6e9dddf53ea0ac009ccc3399f9203ae] Merge branch 'for-linux-=
next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect good 0c78c247d6e9dddf53ea0ac009ccc3399f9203ae
# good: [319121b3e57ddefccb36ca4af417ae602c9f97bc] Merge branch 'master' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git bisect good 319121b3e57ddefccb36ca4af417ae602c9f97bc
# good: [ed51c1e6d8adb0fc6ec023d7473627e03c6b0a2e] Merge branch 'for-next' =
of git://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux-dt.git
git bisect good ed51c1e6d8adb0fc6ec023d7473627e03c6b0a2e
# bad: [125bc49fbc0e1333b9602c1200153f2763cb0a3c] Merge branch 'char-misc-n=
ext' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
git bisect bad 125bc49fbc0e1333b9602c1200153f2763cb0a3c
# good: [c55ba156ad53e2b1f56b3cc53174b0860aef1b10] Merge branch 'next' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/rcu/linux.git
git bisect good c55ba156ad53e2b1f56b3cc53174b0860aef1b10
# bad: [8765b2fe7b05721f45e4320c2290c6a7e4f2ccd3] Merge branch 'for-next' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.=
git
git bisect bad 8765b2fe7b05721f45e4320c2290c6a7e4f2ccd3
# bad: [bf8600945fa1536cea05731775d5f7d62e8632c8] Merge branch 'for-next' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
git bisect bad bf8600945fa1536cea05731775d5f7d62e8632c8
# bad: [be43d82250a5d125e578065615ca805359dc58fe] Merge branch 'topic/ppc-k=
vm' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git
git bisect bad be43d82250a5d125e578065615ca805359dc58fe
# bad: [1093a3758142ce8613341ae39fb4591383d5df0a] Merge branch kvm-arm64/vg=
ic-sre-traps into kvmarm-master/next
git bisect bad 1093a3758142ce8613341ae39fb4591383d5df0a
# good: [d17317a13fd0498cfa2b4bf9c4eebbe5adf929ab] Merge branch kvm-arm64/f=
pmr into kvmarm-master/next
git bisect good d17317a13fd0498cfa2b4bf9c4eebbe5adf929ab
# bad: [9f5deace58da737d67ec9c2d23534a475be68481] KVM: arm64: Add ICH_HCR_E=
L2 to the vcpu state
git bisect bad 9f5deace58da737d67ec9c2d23534a475be68481
# good: [8d917e0a8651377321c06513f42e2ab9a86161f4] KVM: arm64: Force GICv3 =
trap activation when no irqchip is configured on VHE
git bisect good 8d917e0a8651377321c06513f42e2ab9a86161f4
# bad: [5cb57a1aff7551bcb3b800d33141b06ef0ac178b] KVM: arm64: Zero ID_AA64P=
FR0_EL1.GIC when no GICv3 is presented to the guest
git bisect bad 5cb57a1aff7551bcb3b800d33141b06ef0ac178b
# good: [795a0bbaeee2aa993338166bc063fe3c89373d2a] KVM: arm64: Add helper f=
or last ditch idreg adjustments
git bisect good 795a0bbaeee2aa993338166bc063fe3c89373d2a
# first bad commit: [5cb57a1aff7551bcb3b800d33141b06ef0ac178b] KVM: arm64: =
Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest

--mTeBIqFzdJh+yJcd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmbPsUsACgkQJNaLcl1U
h9DU0Af+LIvuxsrDDxJ6Ab4DdLLyM0Tc1NlRZiDM1SOXpol1kKbFnqQ2ETvTGyGP
Jr0Yh/WmMWJWmkJTDmE+/ko1PuvgNI6QR870wyYVCPZDOeFqKZBR8DoWqnIJwXKW
vZgViDDtXxnooTsXaMw1c1f0LaeUbfA9oFbTGWd1IQPNJwERTqFb6lpHG5+sdSzn
qE8JODMyNVL/Azr5kauyY6FY7pgh00ykGhNvB6f6LQk1gSMTuoARyFT26TqMG83r
2Z2zNHHr/1WQhisM1JY2/KyeItaXaJ3epUzT3NwiHdVbErVbPEZ+WRJSFx7KsxtX
ZsautBOZfp3jul0liuH3+X1ncsn3gQ==
=hDBZ
-----END PGP SIGNATURE-----

--mTeBIqFzdJh+yJcd--

