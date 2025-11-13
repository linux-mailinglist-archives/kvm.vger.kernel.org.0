Return-Path: <kvm+bounces-63031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB3DC59822
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 19:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 710A8503815
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 18:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E89345CC5;
	Thu, 13 Nov 2025 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qRYJZsx2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D3030BF66;
	Thu, 13 Nov 2025 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763056923; cv=none; b=HWRv6AtV6f3pe3HuforYBFCoLZfv0NqD8T+y5c0r4w5Ib6uNxAF/lHsgC0aoMzbFxguwp8Cn8T1l3mxyJf1n88kcyFA+g+pJu2Yfrt7BFX1ROAiSIzn51FusnZjrWIe0GFemRPUuor272DJwJs0m+O3qHkDPTR7yClBPGkdYnXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763056923; c=relaxed/simple;
	bh=pefRbuYJ4cIwww2DTcSFGlDLKpPtGWwLfORT21um08k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CnsFujsqpeRYQp1fefBV4t8zp/MEy+RSY/pUQfd9tnwg4qJbU22QcSTnRIbfigY0K3AOyw9NcmFCvBLzq5ZykrBhjPruqen0jNaGFVDapFRLCA/gbvDvdyXe096KB5h0ZHdMl4V9JkCq2R4wpVttL6ZEHggWc58B2UdKI5KHejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qRYJZsx2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B45C4CEF8;
	Thu, 13 Nov 2025 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763056923;
	bh=pefRbuYJ4cIwww2DTcSFGlDLKpPtGWwLfORT21um08k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qRYJZsx2w43hy0S+72gbKKMc/zciGp0kmjazlFFcrbx4ca7kWF2USySYUFmicDs/7
	 a4O8H2EMZa9pMbwGypr3qrmOCgzTS4X25nEI/JcGnuCT0kMf4QaE8HKf0CXCN2rmqU
	 RGvGNlwE1L2JLWVvWyBhg0+13XN6dHkbMP/9pCtr8viqDFhLBszebnitjHqMcE8WwH
	 FG2Nxsop+q/ZdZGgd6nUt7AOd5mFEL757RjwvHkaBDtN1YDK5lEl4/aEEtLg38IdZn
	 NMQvgwfLjOJZnysAhU7ttmwj6yqS1wgNmaYbIM/qbE2mAHSFBwuEYzeo/M37UJd9jC
	 52yHrUb4EvuEQ==
Date: Thu, 13 Nov 2025 18:01:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 04/45] KVM: arm64: Turn vgic-v3 errata traps into a
 patched-in constant
Message-ID: <72e1e8b5-e397-4dc5-9cd6-a32b6af3d739@sirena.org.uk>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4mHS3LPUsnt5TA9O"
Content-Disposition: inline
In-Reply-To: <20251109171619.1507205-5-maz@kernel.org>
X-Cookie: Live Free or Live in Massachusetts.


--4mHS3LPUsnt5TA9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2025 at 05:15:38PM +0000, Marc Zyngier wrote:
> The trap bits are currently only set to manage CPU errata. However,
> we are about to make use of them for purposes beyond beating broken
> CPUs into submission.
>=20
> For this purpose, turn these errata-driven bits into a patched-in
> constant that is merged with the KVM-driven value at the point of
> programming the ICH_HCR_EL2 register, rather than being directly
> stored with with the shadow value..

We're seeing the no-vgic-v3 failures in -next with slightly different
symptoms to those that were seen in mainline and fixed with Sacha's
change da888524c393 ("KVM: arm64: vgic-v3: Trap all if no in-kernel
irqchip").  That change generated a conflict with this patch which
Stephen resolved in what looks like a reasonable fashion tactically but
I suspect needs some wider changes.  The test now fails with:

# selftests: kvm: no-vgic-v3
# Random seed: 0x6b8b4567
# =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
#   lib/arm64/processor.c:487: false
#   pid=3D2080 tid=3D2080 errno=3D4 - Interrupted system call
#      1	0x0000000000413d27: assert_on_unhandled_exception at processor.c:4=
87
#      2	0x0000000000406c1f: _vcpu_run at kvm_util.c:1699
#      3	 (inlined by) vcpu_run at kvm_util.c:1710
#      4	0x000000000040308b: test_run_vcpu at no-vgic-v3.c:124
#      5	0x0000000000402253: test_guest_no_gicv3 at no-vgic-v3.c:155
#      6	 (inlined by) main at no-vgic-v3.c:174
#      7	0x0000ffff9dc17543: ?? ??:0
#      8	0x0000ffff9dc17617: ?? ??:0
#      9	0x000000000040242f: _start at ??:?
#   Unexpected exception (vector:0x4, ec:0x18)
not ok 25 selftests: kvm: no-vgic-v3 # exit=3D254

Log showing the failure:

   https://lava.sirena.org.uk/scheduler/job/2079953#L2994

This is on i.MX8MP-EVK, 4xA53 and a GICv3.

No bisect or anything, between unrelated DRM breakage in -next and the
same test failing in Linus' tree in -rc3 which the kvm-arm tree is based
on it's a bit of a mess.

--4mHS3LPUsnt5TA9O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkWHRQACgkQJNaLcl1U
h9CkFwf7BHSBpu13Gl2dKmMGEJ2tarZfJaanGVTIuXwd3MufzE8sMiFiUs9RDduR
K6xSxs+YogP46QjHrhJn6PkamnE9JsJ7AWCbuf5mkw74ON7ROFXcuCqBXlSxL8w/
l2jFp2sBgQRLYhMPJAnrIoVDgRhmPfnHVtafsg4vutmLxRcN4+wOQuL21J578KDA
M2Id7VjL0JupztKELzp9pbVblX65VJgu/nFduWrn7qPbdtF5LLPvotyXRp0MoAHn
yb1RdvDkjyasDHHuJSMXtX1COI2oTRWgky2VifAh2gTLVtUy9GKQC+ki5pLGgehs
S+j6wno6JUxOJXzCBkr6A8pwb+3wtA==
=waEM
-----END PGP SIGNATURE-----

--4mHS3LPUsnt5TA9O--

