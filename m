Return-Path: <kvm+bounces-17415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0118C5F48
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 04:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFB371C2124E
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 02:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C8B376E4;
	Wed, 15 May 2024 02:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="sFLDUAZg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0253A36AE0;
	Wed, 15 May 2024 02:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715741651; cv=none; b=b830/FUOFlWk/zNCq/O9tS9z9Vd4K8P3kxp+w2XvhJYqjns2QtE5F7A4YgW0WOHvpCIp3hpB7WVHv1ObsMtRlPnC43HJ8cI0smYBfE3ub0vMtsGYG9Q/0W184i64nZQWI/xX0RYgsnmy7savjvt6JPIhuxW1osup6tGBO/3CawI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715741651; c=relaxed/simple;
	bh=FrTSNu9y56pabtP28PDvyyHeKaYZe4k+0eITepOd/qk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=fySH6L+X7UhGcRF0WO8BCJXzyjH0YQOVgjyydVlbSOW8ijRFguXz6Gnaux4rG1EoslvKjGee/Vdbmri93J/qZcyvt4X0v/KboGSOM79OI2QjLqnwpgdBdiuzrTSMk0JT6mRpvw+tHpiQWDSqgMwd3KGGNA6weiqOFakCt0e/NWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=sFLDUAZg; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1715741645;
	bh=88zHo7n0BTHEK7IEgzwThHpPCEj50A3rg+9I/KaLZhs=;
	h=Date:From:To:Cc:Subject:From;
	b=sFLDUAZgNh4sCHhI2qdMgT5DDWq70DnQ/eEDSL2P6BvJRaD9Jh6FPh3jhHJni7Xyi
	 /KwvBrGdGdef/AWxdtnMOBlMjkmsMulCQqDBGRNbUGylxHjLNygJ404EU3kU/52eoJ
	 E1URO6FhKL9H1sfWgqgRyvcHqlc6C9e1SLqqu6qQY9sScV0pjZ4eKpUkCjcQ1RsPDw
	 8BuGHeTpeK7Si8R54NxwLFVTjoSXZ30RgLuffN7XFlEQHSRjXOkSGA6Qp3EpDQ3hJW
	 as4gd5dHLvkdX+7QkOKrVLTakBJmBP+vRb3I1/QAiIg4BAhef1Ir4fUdAEnFaZmoIU
	 gNYM9K2F5HC8w==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VfHqc4lcQz4wc8;
	Wed, 15 May 2024 12:54:04 +1000 (AEST)
Date: Wed, 15 May 2024 12:54:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, Huacai
 Chen <chenhuacai@loongson.cn>
Cc: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Tiezhu Yang
 <yangtiezhu@loongson.cn>
Subject: linux-next: manual merge of the kvm tree with the loongarch tree
Message-ID: <20240515125404.5ffbaada@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/o_MYjImIFPwNGrSQLBO1o6j";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/o_MYjImIFPwNGrSQLBO1o6j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/loongarch/kernel/irq.c

between commit:

  5685d7fcb55f ("LoongArch: Give a chance to build with !CONFIG_SMP")

from the loongarch tree and commit:

  316863cb62fe ("LoongArch/smp: Refine some ipi functions on LoongArch plat=
form")

from the kvm tree.

I fixed it up (the latter removed a function that was made protected by
CONFIG_SMP in the former - I just removed it) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/o_MYjImIFPwNGrSQLBO1o6j
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmZEI8wACgkQAVBC80lX
0GytFAf+LwzWmlb8+iyV3iC1tKJKoM+QdKdzMfUejvrZdKabf64GAniBKDs3lsG9
QoW12zerBpcB3PjbEz1qJ02Ph/5YfrgScsACfSBtQjGCGel65+0qokxnd1ZgOOX5
7rm+u5uaG6dxN1ZKkQRfJSITwksiewkL296VJWZd0YNjgUA4E+u9CAGwfdCetOGR
dTnDYNi1ys2oy6Yx2PYHPgQjtz/o/6Yu9exXlGtxfAxmwuNFQeToHUPhEy6UQ49M
AJNl5LdVWM7ywSP5EPYvmlnEnQguQGL1gaOW/JgmjbVqLorL1QOUH5wcsEb6DVZd
Rw4REV3p/09kOqC27mzzzzHDRFBiqg==
=KwgP
-----END PGP SIGNATURE-----

--Sig_/o_MYjImIFPwNGrSQLBO1o6j--

