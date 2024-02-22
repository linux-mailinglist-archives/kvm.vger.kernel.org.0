Return-Path: <kvm+bounces-9382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5374085F75A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 12:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD72F1F2A3F7
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D6AD45BF0;
	Thu, 22 Feb 2024 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Ge/Y40e+"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92753F9ED;
	Thu, 22 Feb 2024 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708602047; cv=none; b=fvybAcNnx/Tqc71Lm/TFyOOaH+qXNg3+gkkL0SVTeNSfrIVQ+XorigakTZVERDczeNRQ2qtrtPdB9Pcx4gfXr7BU/dImBWBBJHOIxwp16oVAC+dzAmYXCUIX+cU3rBCBPefWh8RELrMh1s3ELjK3ARQ5qcRiAz7CKH5ZhrFoPqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708602047; c=relaxed/simple;
	bh=qErhb31YfBBbfbwsXUA9smxLugNiT5kmyg/IG8Z2rbA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j67xN8wjImr8ZDFbvvVb00rBB5mhqKPNH3nPVXLg/xmi5tDrCfx3N0wEtrT6LYA7kfj66HpgIJbabAcpgyk94Sad64h+zaKh1S2B2iYdEYuhpZmYoBhbtG3+fruONShqe2pKZLQolhLpWVsJiPU2HurLiC9NnuV5cYOtVXi3TDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Ge/Y40e+; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1708602043;
	bh=bJXOfG/Dk72N81ShHuOJUbjEwxeP53GZRuMDnBXS5rc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ge/Y40e++eyOSiOWUCdFX0J57Zp12w08KgkZfld28dxOqN1K3L85Jym1O5bjFIUyL
	 EnI79ZcpBZQOe8Q+zYq3/zloBlOu0VgQdGnR+ij/Yv9qeS/6AK2WvxjAgxB6EvsIwu
	 Bvuod3hkNtIPcFnTvdoXkoZ15Q3cSR8rFh4XisolfkLgpgWZ1ENp/SFVYFtE78R3Dy
	 aiq862/J/Cb7yfnuowHnO0p1ZcUlGNZ/McEgxtVkOgxhuOv1ngW3yGYBxrRG7Ir7lS
	 S54T3qk89K4O/keOCe0zYAvWOQsy4b7CNcP2pgOxO3ZpS5RifJ9Nrk3k8KitLKsO40
	 Ej4f+ydj8bmvQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TgWRZ4Crzz4wb2;
	Thu, 22 Feb 2024 22:40:42 +1100 (AEDT)
Date: Thu, 22 Feb 2024 22:40:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall
 <cdall@cs.columbia.edu>, Marc Zyngier <maz@kernel.org>, KVM
 <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
Message-ID: <20240222224041.782761fd@canb.auug.org.au>
In-Reply-To: <20240222111129.GA946362@e124191.cambridge.arm.com>
References: <20240222220349.1889c728@canb.auug.org.au>
	<20240222111129.GA946362@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/AedWDBZ0=V+nKK0DvBL+JL8";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/AedWDBZ0=V+nKK0DvBL+JL8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Joey,

On Thu, 22 Feb 2024 11:11:29 +0000 Joey Gouly <joey.gouly@arm.com> wrote:
>
> On Thu, Feb 22, 2024 at 10:03:49PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the kvm tree, today's linux-next build (arm64 defconfig)
> > failed like this:
> >=20
> > In file included from <command-line>:
> > In function 'check_res_bits',
> >     inlined from 'kvm_sys_reg_table_init' at arch/arm64/kvm/sys_regs.c:=
4109:2:
> > include/linux/compiler_types.h:449:45: error: call to '__compiletime_as=
sert_591' declared with attribute error: BUILD_BUG_ON failed: ID_AA64DFR1_E=
L1_RES0 !=3D (GENMASK_ULL(63, 0))
> >   449 |         _compiletime_assert(condition, msg, __compiletime_asser=
t_, __COUNTER__)
> >       |                                             ^
> > include/linux/compiler_types.h:430:25: note: in definition of macro '__=
compiletime_assert'
> >   430 |                         prefix ## suffix();                    =
         \
> >       |                         ^~~~~~
> > include/linux/compiler_types.h:449:9: note: in expansion of macro '_com=
piletime_assert'
> >   449 |         _compiletime_assert(condition, msg, __compiletime_asser=
t_, __COUNTER__)
> >       |         ^~~~~~~~~~~~~~~~~~~
> > include/linux/build_bug.h:39:37: note: in expansion of macro 'compileti=
me_assert'
> >    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond),=
 msg)
> >       |                                     ^~~~~~~~~~~~~~~~~~
> > include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_=
ON_MSG'
> >    50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #co=
ndition)
> >       |         ^~~~~~~~~~~~~~~~
> > arch/arm64/kvm/check-res-bits.h:58:9: note: in expansion of macro 'BUIL=
D_BUG_ON'
> >    58 |         BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0       !=3D (GENMASK_U=
LL(63, 0)));
> >       |         ^~~~~~~~~~~~
> >=20
> > I bisected this to the merge of the kvm-arm tree into linux-next but I
> > could not figure out why it fails :-(
> >=20
> > --=20
> > Cheers,
> > Stephen Rothwell =20
>=20
> This fails because https://git.kernel.org/pub/scm/linux/kernel/git/arm64/=
linux.git/commit/?id=3Dfdd867fe9b32
> added new fields to that register (ID_AA64DFR1_EL1)
>=20
> and commit b80b701d5a6 ("KVM: arm64: Snapshot all non-zero RES0/RES1 sysr=
eg fields for later checking")
> took a snapshot of the fields, so the RES0 (reserved 0) bits don't match =
anymore.
>=20
> Not sure how to resolve it in the git branches though.

Thanks.  I will apply this patch to the merge of the kvm-arm tree from
tomorrow (and at the end of today's tree).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 Feb 2024 22:31:22 +1100
Subject: [PATCH] fix up for "arm64/sysreg: Add register fields for ID_AA64D=
FR1_EL1"

interacting with "KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields=
 for later checking"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm64/kvm/check-res-bits.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/check-res-bits.h b/arch/arm64/kvm/check-res-bit=
s.h
index 967b5d171d53..39f537875d17 100644
--- a/arch/arm64/kvm/check-res-bits.h
+++ b/arch/arm64/kvm/check-res-bits.h
@@ -55,7 +55,6 @@ static inline void check_res_bits(void)
 	BUILD_BUG_ON(ID_AA64SMFR0_EL1_RES0	!=3D (GENMASK_ULL(62, 61) | GENMASK_UL=
L(51, 49) | GENMASK_ULL(31, 31) | GENMASK_ULL(27, 0)));
 	BUILD_BUG_ON(ID_AA64FPFR0_EL1_RES0	!=3D (GENMASK_ULL(63, 32) | GENMASK_UL=
L(27, 2)));
 	BUILD_BUG_ON(ID_AA64DFR0_EL1_RES0	!=3D (GENMASK_ULL(27, 24) | GENMASK_ULL=
(19, 16)));
-	BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0	!=3D (GENMASK_ULL(63, 0)));
 	BUILD_BUG_ON(ID_AA64AFR0_EL1_RES0	!=3D (GENMASK_ULL(63, 32)));
 	BUILD_BUG_ON(ID_AA64AFR1_EL1_RES0	!=3D (GENMASK_ULL(63, 0)));
 	BUILD_BUG_ON(ID_AA64ISAR0_EL1_RES0	!=3D (GENMASK_ULL(3, 0)));
--=20
2.43.0

--=20
Cheers,
Stephen Rothwell

--Sig_/AedWDBZ0=V+nKK0DvBL+JL8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmXXMrkACgkQAVBC80lX
0Gyb6wf/Y/9NIHRf5ckuf73aWrvP2Z3vSOrtciYwk1j77ut8ISRM9gkpZkYpk3IN
dLyNfXMpuRZHXMfD0xT7KzdV8bgtAjP2IwOLqQdTbwxnDOvILVSUzfdeTKninGKf
Tor1rMYB55PJxqu3yO1ToCl2wSXLWbari6DbZIA9K6NhSBrA6r0djmqK5pS2cChr
VUkI3cN4PH9P+oZE6lw4+WphtrXDmUIUjfUHtbVT6VQE7E7qLQX1oqJsMkfJPCaG
Bg0Zu/9KA6tDDwBoI5XU5U+OvpBOC9r+o9jX/AKAKmrm8DGpQc0Sw1zsDPwTumvK
53Pi7MPtAz4t05LzcNWdr7gYcCTkkw==
=aSyV
-----END PGP SIGNATURE-----

--Sig_/AedWDBZ0=V+nKK0DvBL+JL8--

