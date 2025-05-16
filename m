Return-Path: <kvm+bounces-46744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F3BAB9315
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 02:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 578A21B66965
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 00:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7364B8F6C;
	Fri, 16 May 2025 00:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="IslUog/D"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C91D17E4;
	Fri, 16 May 2025 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747354570; cv=none; b=j7uSjmYLsrI8wpCc/LYuLv7dJChLrfCGJB9U1RZjgaK+jZsFFJUvEMDVk+wrqcKFezvQmiyVy2iuL8VQUtPEWfPo4/AWAPvS/QGBvF6z0wrWxM+9YYfviN0MpZzUlXqc0vOaXn4WXTXP0JL/Xnin2LJ/qIE4W36kNv5ciOCy7cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747354570; c=relaxed/simple;
	bh=p5NR/VDZKJ8yjpgeliNA7RHEjb5AW+yTp7x/ak01lxY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ceb1D6LSoFHU7JV7pVlhtgPNBljOn3pcXizBBadupVH05r9YQXWtN4qSsKDgaSaGD0Y7Ayu6SsRP4EV3TviC9Pu4K4uoX0tansEbkC2GwvD4ggdlZcoDzoY3fdyXHwTvRXyMGgpcw2x2tcUbOffu1jF7zgN3caERItyhtNv0oYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=IslUog/D; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1747354565;
	bh=J4XIcsUxSb8ZfiZj/Iaa/P2J+JIXvoXMCLXM7gI/t1g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IslUog/Dk4dKnDuiubDEJYEB3/MZO1WhEjgn/7Sz1dNyDuJXb8LnKkudiVusPBuCQ
	 iCMXsOc3HCO11MAken6AMs8eOIGBxSwOnvyqhH/tc0mXpNTrdKR/S3T8FBho3gT1N0
	 WDarHTC0DlUI7WxXPUvskUXPxlD1FMQzy+fBZRuUiBPtIsh7PfSW1yJdsg/VSiopYe
	 iWpyCVYeZlp79IEDllSq1lyXZt8q5UOS0LLRtvI4ltfiDVnilwW8FcNNsWbecYiW+e
	 o9kAG7RMIyLrxfhYdf3CQd1TiNFX4PqAW6TuamOxzPwREpMN1smugbpRWDttiEGUGE
	 qe2b/u0i8sqkw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Zz70P16W4z4xFt;
	Fri, 16 May 2025 10:16:05 +1000 (AEST)
Date: Fri, 16 May 2025 10:16:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Isaku Yamahata
 <isaku.yamahata@intel.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
Message-ID: <20250516101604.7261c44a@canb.auug.org.au>
In-Reply-To: <20250409131356.48683f58@canb.auug.org.au>
References: <20250409131356.48683f58@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/offU.zWJ54GnTgL4.MCsxi3";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/offU.zWJ54GnTgL4.MCsxi3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 9 Apr 2025 13:13:56 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>=20
> After merging the kvm tree, today's linux-next build (htmldocs) produced
> this warning:
>=20
> Documentation/virt/kvm/x86/intel-tdx.rst:255: WARNING: Footnote [1] is no=
t referenced. [ref.footnote]
>=20
> Introduced by commit
>=20
>   52f52ea79a4c ("Documentation/virt/kvm: Document on Trust Domain Extensi=
ons (TDX)")

I am still seeing this warning (as of yesterday).

--=20
Cheers,
Stephen Rothwell

--Sig_/offU.zWJ54GnTgL4.MCsxi3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmgmg8QACgkQAVBC80lX
0Gy35wf9G9EOsTSoYAqfF2IPKIKxpF2zpc2zruIwVg1LLPN5NxPCk+jzW4fmhPHU
aKZOzQfbV5ep2Is3QyzxVlLEXeJ5E25HxAPlEv2A1UAtIE7URgMy2bEtxfnVSxb/
qG1lNFVUb2zjs09+kPk0adwkycfQkys1BTNDMG71vpsz71jemt6Xfoh4d+ecDsSi
iyTH3gZiSEEq60tXLGwC0fcqGLuM9tCqzzG3TpB2HPzJz407u8Hgz/I9jFOHaFMw
lodXVTqAty5bvOg8IpclAvPeg017hEOQJW8XYuefHjrzr7UcE3GcuedIzmdp69GU
zR4bq7D2+3sfnCKKE3NZ//2bnXh95g==
=pkqc
-----END PGP SIGNATURE-----

--Sig_/offU.zWJ54GnTgL4.MCsxi3--

