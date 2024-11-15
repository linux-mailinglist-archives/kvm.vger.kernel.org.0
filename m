Return-Path: <kvm+bounces-31909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E70449CD620
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 05:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6668280D6F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 04:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC16216F851;
	Fri, 15 Nov 2024 04:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Rws3Vb3j"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C520D155A2F;
	Fri, 15 Nov 2024 04:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731643546; cv=none; b=fGWgBcpoCReVdbHd11oTZ4LsudoccyJ8Dfs7YKW6ZsEokhPQCRGVrlqCReJQ7um3A4ohRtqakbzhVxFyi/+eLUo6dyIGnAsnXS5oWEeBP9BGR13yl5p7GyXk33RHvCnziUzOzS3th7eCrZebK20PjYxml3CNhJrPnXsz7wnJww0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731643546; c=relaxed/simple;
	bh=b3AT6AKpS+kUcgi7BA3eUNf9UYufYRVv8pj3DCDRr3E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGmBtZbhzFugRNQAv9QorSda1U0XH9NGFrpV637px1AYpwXazjRJs2pGZsIVKB5NNnLH9V449/405f4bwzpKPx56M7b/zzeoHwMG5Pz3yS6MEdtR5IgYLp6GVZogfbmX59pDxcxqfwQQqfJ4UYxq6WgSh0DfUuFlw1GGyj9Om9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Rws3Vb3j; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1731643539;
	bh=Wx/CjR4XQVbMA/M/7ZlkINu4DHcqhXpv+A7XlpzDKT0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rws3Vb3jSwIryU89IFhPz4hk5sRmwRvWdOer12+TYocqdFo8fkgEdV/8fyS4dq0qU
	 MBq80BLmza3iQj+NZJ7CkBjLfZe5ZLFiykqN+H6KdfHgHToFIkJMe34bU7voPKSQhv
	 V0y4zZA9aaHbkYpCfvp/R1TKRuhkhL1D9KLB49nIQobh1gL2F7qtm3GYUHlZUQkSiM
	 sBqrmSsj/FrTxON3xWKnXmCFrAFvtj50Gh1TlGhIQKezaV6b0lxwTWSRFB7Xjf/AnX
	 C2ihr/CpVXaBsSAxxpjaTaTKU7uT73pMsFi2yywJ7+nZndj+bLnmKGl0PWbwl5SReh
	 qn5PlaNc2bTtQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XqNjG3qnPz4w2F;
	Fri, 15 Nov 2024 15:05:37 +1100 (AEDT)
Date: Fri, 15 Nov 2024 15:05:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64
 tree
Message-ID: <20241115150539.49a010d8@canb.auug.org.au>
In-Reply-To: <20241031143519.73eca58b@canb.auug.org.au>
References: <20241031143519.73eca58b@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XXiwl.9JUZ0mVUdsW+F./dd";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/XXiwl.9JUZ0mVUdsW+F./dd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 31 Oct 2024 14:35:19 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm-arm tree got a conflict in:
>=20
>   arch/arm64/tools/sysreg
>=20
> between commit:
>=20
>   034993461890 ("arm64/sysreg: Update ID_AA64MMFR1_EL1 to DDI0601 2024-09=
")
>=20
> from the arm64 tree and commit:
>=20
>   9ae424d2a1ae ("arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_H=
AFT")
>=20
> from the kvm-arm tree.
>=20
> I fixed it up (the former is a superset of the latter) and can carry the
> fix as necessary. This is now fixed as far as linux-next is concerned,
> but any non trivial conflicts should be mentioned to your upstream
> maintainer when your tree is submitted for merging.  You may also want
> to consider cooperating with the maintainer of the conflicting tree to
> minimise any particularly complex conflicts.

This is now a conflict between the kvm tree and the arm64 tree

--=20
Cheers,
Stephen Rothwell

--Sig_/XXiwl.9JUZ0mVUdsW+F./dd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmc2yJQACgkQAVBC80lX
0GxpFAf/cQgjBGmp0pMjruTdLl8Hr4qupKlZHr45AB1gG+CNedjxlkr0Y91erLzK
IZqnrM7FPX4e9vmEsNJxWkFehL0y0CN0PppIryMceaSq6xLB0j9rJIN6hLX4sO6m
FW/fdlfHx07rokJGpmYlUU3w57xGMlM3R5BxBsg2NddwrFlmMMmvACvhufKwRGZL
A6zmhK83ieNr6Tyq7N6XbBM95+Xam98MXAAwM31HjF7sVeyYwVbIcsvfk7RM/xHe
evE960s+Q9xJH56ifB+6xEMCBOu3W3l3UW5ZBYhfiMfOJy7z/UyX/dlzv/205hK5
yDU4kuMkPiTShEyZsFF3h4UvR8tjZA==
=jzxC
-----END PGP SIGNATURE-----

--Sig_/XXiwl.9JUZ0mVUdsW+F./dd--

