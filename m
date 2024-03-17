Return-Path: <kvm+bounces-11970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AD787E10A
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 00:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E4BC281524
	for <lists+kvm@lfdr.de>; Sun, 17 Mar 2024 23:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EC4219FD;
	Sun, 17 Mar 2024 23:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Y4lhV2SD"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7658E21106;
	Sun, 17 Mar 2024 23:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710717045; cv=none; b=Ct+mr8OJ6qzk7NaZKWDzGZUVqL1xN7e8IA0elgWGuNuRfRH5jrTA3VDjcAOdL/o9BMzxXosZKq7ek3442fHdHdo253r8D63nWZjdxqYvIFdjl2ZkNPNVyZKNkrKwPQYANUmsX4veoRloEtRKWnH5YtRx5Nt43km4UESnm74+Bnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710717045; c=relaxed/simple;
	bh=257a9BISI6R55ZcOkEr7lcMzNCScKQiNZenFOvSG8Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+lLW4nSes5LX+/3OfM44DoZnxfSfaGfkVoJfOWenBgz9sCcq2OWfQYxc1lEhUFngmEg0IVDkJ4wKgX5fbLDm+fedCKouXxUznm0wcFOHWHWoLqyERJOXjo0GRxKLV1hwE4MCmgltTPsNuMXwMCXSOD0c3WT8m4pQJgxe+uzDPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Y4lhV2SD; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1710717039;
	bh=RQ3aDuiEm0BNocE3CBz/zKa43PMepoyRHB2SxQtZ3ro=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y4lhV2SDzjNLaHd+pgDYuer94uI/ERPNIAcflu9HdC0NQmcLzbPHq/CsMK63/oTNc
	 WQzyj/yDv6qlZJTK8eH5jf8AqCasw8nQompOseV389kLQu/c7TgiNRLK5BW19yH+7l
	 J4RbCp8+vD72Z3dQgUDhnYDUxoI8MojSatV1RNMyDmNooW5xQA4hGn4K9qH/1pgHvc
	 TH/lrQ5CiLJi7hiKF+gB50hui1xukDOeOor8BH8Z19blnzHktSsw6AcWge7LeL7OOp
	 a4sxivl/YqIXv4JxrVYnZhmnd5dxpmhhL9ADyvq4B3ORwPI1Y8rOA0yRYe2yb/5ggy
	 qo1LNT4vDLQOQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TyYcZ1kbnz4wcD;
	Mon, 18 Mar 2024 10:10:38 +1100 (AEDT)
Date: Mon, 18 Mar 2024 10:10:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, Huacai
 Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Jinyang He <hejinyang@loongson.cn>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Tiezhu Yang
 <yangtiezhu@loongson.cn>
Subject: Re: linux-next: manual merge of the kvm tree with the loongarch
 tree
Message-ID: <20240318101037.15c93b28@canb.auug.org.au>
In-Reply-To: <20240227140927.463df093@canb.auug.org.au>
References: <20240227140927.463df093@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Xy.qFO_igjTl2LFZZ=SK3OU";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/Xy.qFO_igjTl2LFZZ=SK3OU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 27 Feb 2024 14:09:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>   arch/loongarch/Kconfig
>=20
> between commit:
>=20
>   853f96367535 ("LoongArch: Add kernel livepatching support")
>=20
> from the loongarch tree and commit:
>=20
>   f48212ee8e78 ("treewide: remove CONFIG_HAVE_KVM")
>=20
> from the kvm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
>=20
> diff --cc arch/loongarch/Kconfig
> index 99a0a15ce5f7,eb2139387a54..000000000000
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@@ -133,11 -133,8 +133,10 @@@ config LOONGARC
>   	select HAVE_KPROBES
>   	select HAVE_KPROBES_ON_FTRACE
>   	select HAVE_KRETPROBES
> - 	select HAVE_KVM
>  +	select HAVE_LIVEPATCH
>   	select HAVE_MOD_ARCH_SPECIFIC
>   	select HAVE_NMI
>  +	select HAVE_OBJTOOL if AS_HAS_EXPLICIT_RELOCS
>   	select HAVE_PCI
>   	select HAVE_PERF_EVENTS
>   	select HAVE_PERF_REGS

This is now a conflict between the loongarch tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/Xy.qFO_igjTl2LFZZ=SK3OU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmX3eG0ACgkQAVBC80lX
0GwVcwf/cTp/wYy2XUIRQzjMW8TMU2E1KqntbRLoPJZ0zbAnl5Ea3MUSPDwFf7Rv
G1FVsNp3PZqjLvwZnkoQwg7o0uWtFWmzDR1VLestovnmn1y0DLCoBmbF7es2zh2Q
jgTT4I30CqdjjfcRji2gu5JZ/3nFQuaEcEnmFz0EUgPa3DuGQTr5gwBBW4y3gaCs
iWb/LObiNuFyhcH5vCxWZ5yJiQZAHvto0Z9w3bZTs2QEccQv2rxvg0PgT3UPRzLX
D1AfWXoaIV4Rw2t4uuLZya8PGbQHhQ/iWfAifZiKrkk9l7nX5AnZ2eHOGX8Z5yPD
Pas7Ojn0v9RAdqaXUgG/H4EwcXm6ow==
=WAqf
-----END PGP SIGNATURE-----

--Sig_/Xy.qFO_igjTl2LFZZ=SK3OU--

