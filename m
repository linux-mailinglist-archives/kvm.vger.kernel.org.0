Return-Path: <kvm+bounces-10017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05379868786
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 04:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3E7D282325
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 03:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1951CAB2;
	Tue, 27 Feb 2024 03:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="U/DRxxGU"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A096D18B09;
	Tue, 27 Feb 2024 03:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709003374; cv=none; b=bDCUXxU4Fc2QoD92LYxsE3UR3qcc7RfRG3rUyq06Rb2G6NcttJmUn/zMfPVFddpHsQSdYUchLrI2P5ecdcnTA0kQjf7rUnJotofPjumjG5xHzjKX54Ijs5m8P2U1md54IR/XCpHj0FMQlLsQBqAAyJG2b4ufzUOrHwbr6ujP1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709003374; c=relaxed/simple;
	bh=9jeqtYVQD/ayeSM+BVKdEcASzw1aabQVZ1LWjohg9xA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=r7pxRQrUj4Jroj2Li8tgcrRDRW1hVY/rY7D+MU3lt5njw8E66B947pCfsEegJ7AopXNjSvo6i3IXns4Qvf9suEZMhfe0w7ixwW6i1d/JkL7aqabgb3Wab60LaMH8SmNvIuUHPj8ZaSBVGfKkblT3UopXI1XLGObzcsrBl2kbT/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=U/DRxxGU; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1709003369;
	bh=hz++nsI/MDcuIMfz08ba0k9/02i8g12awFKAWnONEMs=;
	h=Date:From:To:Cc:Subject:From;
	b=U/DRxxGUHlM7tzfISR41/+Uimv5pRzoiwdmeWuJM3JsOWvuM2jlQmc5wPsASpZC5B
	 F4We6TS87wIlgqBTnKQmlXTIULhiQfLofmugtWGgYeIjhxQUoCh/XtSPvPkd4A9oEG
	 zyXvaWQDANQrlS925YT19xtW+f+F7G/MMSnDyLXunPBB5SyIuM3op8jkCwvFpHMwe9
	 4IgYjgE05CRgSWv3+/siRTFRR4OvDIc2xNP+qfeq46F/2eh4O3MKS09ySEyqTgImR8
	 y+mretLLJTGliivMIHjISgHqLr2OEcixtt7R6GXOyu1uNO4Ykj8PP+4LFuh8VeOZXi
	 0hNJ5w4KuCbjw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TkMsN2F18z4wby;
	Tue, 27 Feb 2024 14:09:28 +1100 (AEDT)
Date: Tue, 27 Feb 2024 14:09:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, Huacai
 Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Jinyang He <hejinyang@loongson.cn>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Tiezhu Yang
 <yangtiezhu@loongson.cn>
Subject: linux-next: manual merge of the kvm tree with the loongarch tree
Message-ID: <20240227140927.463df093@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IncGFwUXhNX8r=SsiFMIfe5";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/IncGFwUXhNX8r=SsiFMIfe5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/loongarch/Kconfig

between commit:

  853f96367535 ("LoongArch: Add kernel livepatching support")

from the loongarch tree and commit:

  f48212ee8e78 ("treewide: remove CONFIG_HAVE_KVM")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/loongarch/Kconfig
index 99a0a15ce5f7,eb2139387a54..000000000000
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@@ -133,11 -133,8 +133,10 @@@ config LOONGARC
  	select HAVE_KPROBES
  	select HAVE_KPROBES_ON_FTRACE
  	select HAVE_KRETPROBES
- 	select HAVE_KVM
 +	select HAVE_LIVEPATCH
  	select HAVE_MOD_ARCH_SPECIFIC
  	select HAVE_NMI
 +	select HAVE_OBJTOOL if AS_HAS_EXPLICIT_RELOCS
  	select HAVE_PCI
  	select HAVE_PERF_EVENTS
  	select HAVE_PERF_REGS

--Sig_/IncGFwUXhNX8r=SsiFMIfe5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmXdUmcACgkQAVBC80lX
0GxlAwf/aw9OJcBpp9BgnnNziBx6e60CoaKJVttb1NXvpuG81efJeE5e6vRRJOp3
MIB/jhmNrFuBokVdu5ROjNQVR7ujoZ30/aevr5zn0mQqXVuuuPFGPqtlWWkTWwWR
dGCveC+3cKDZvzPaPn3JbXA6ofPBfHQ7xyYIg4kyEBXvJb6//kzZMgOF8u8qTL0c
IgCvFP6YrQkBdKl1XI/1vnKj4mBXicbnwi0lWcr0Bhd/ghZYQWhkUzdE2qHOXISg
yj5w9OJwgRitzRU7ygM4PU5xcyvV62Xdq1/tauBqaD8nTnlUzJ10HxFAuMbSg5bt
fkVXefGZ1p7iJFuxU3X2PUmJLHeEvQ==
=3VAg
-----END PGP SIGNATURE-----

--Sig_/IncGFwUXhNX8r=SsiFMIfe5--

