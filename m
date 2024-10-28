Return-Path: <kvm+bounces-29824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2E19B2A4B
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 09:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 633CC1F214CA
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 08:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CD4192D63;
	Mon, 28 Oct 2024 08:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="ZIrsIaZj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EACC191F82;
	Mon, 28 Oct 2024 08:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104194; cv=none; b=eTyiKMf+9lsKl/a8yoFh+Qu1kTptIInRTImxBst+dfqJu9h1iARh6K2Gg7IsybNrcA6tN2YNa8Iy1P4ZEphCywIJhPSy/peW37MxVL6ZYGEDpZZtjjkH65NF/xBralT7FSFvUmF1P7p8eshTjYWZrSjFYUbqDPzjOK5lWpbKTF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104194; c=relaxed/simple;
	bh=x4deraDO0Gk1qK4wUkrL89y75/dvrsNKNqNVxp86Fts=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=iryd4xfePasCzb1Xh3hOG43FHvP55JZsCIBl+rsq1yQLtDokQ+1e74FuVRNSiAVwdxRTQVq9JtciL61+yMSCHnnVQto5ta8319Y2/JhfVOALZLVjmR8GcwFh2INBYjqa0fX+n63GJXEizdRHQL9PgySNkHMa5hhdzHC0MSnELgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=ZIrsIaZj; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1730104184;
	bh=9BVxsgUOBsW8yr8S8arOAnJ0UXW6sPo5ixr+nakCZ30=;
	h=Date:From:To:Cc:Subject:From;
	b=ZIrsIaZjJW76BLKaqZPW6r6LVKUcSrdgq3Sh31VikpnOe+ebWbYxBcfAsNFQoyxcK
	 BiGRE69kpTP5ewYCscAF9BQqrCUUj1iMkOj4glz1pzFuDgkmez2l9uXGcAlMvGCzbh
	 aoDgWZLDEpH5gzzmD2sJoA7lnRzLlWTu7DsqDkv7iEIJsE5VwR6MmsgzxxPuvM57Eu
	 QSAO20j2ge7gnNT8ckQcQXU0vOcCl9fU6++OR47hfGQy2hgOD5n7636mosw67AX1+4
	 RRLFEXV7mUHrj8Owp44peOxowjXvBofg9MvQQEO6zl3VtUxRXFLeozynkkSOohfZ5W
	 FLMXfozzfD8DA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XcRQJ59lrz4x8C;
	Mon, 28 Oct 2024 19:29:44 +1100 (AEDT)
Date: Mon, 28 Oct 2024 19:29:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20241028192945.2f1433fc@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Vikg07d5ve1SZB4Ur.bXY4L";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/Vikg07d5ve1SZB4Ur.bXY4L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/locking.rst:157: ERROR: Malformed table.

+-------------------------------------------------------------------------+
| At the beginning::                                                      |
|                                                                         |
|       spte.W =3D 0                                                       =
       |
|       spte.Accessed =3D 1                                                =
       |
+-------------------------------------+-----------------------------------+
| CPU 0:                              | CPU 1:                            |
+-------------------------------------+-----------------------------------+
| In mmu_spte_update()::              |                                   |
|                                     |                                   |
|  old_spte =3D *spte;                  |                                  =
 |
|                                     |                                   |
|                                     |                                   |
|  /* 'if' condition is satisfied. */ |                                   |
|  if (old_spte.Accessed =3D=3D 1 &&      |                                =
   |
|       old_spte.W =3D=3D 0)              |                                =
   |
|     spte =3D new_spte;                |                                  =
 |
+-------------------------------------+-----------------------------------+
|                                     | on fast page fault path::         |
|                                     |                                   |
|                                     |    spte.W =3D 1                    =
 |
|                                     |                                   |
|                                     | memory write on the spte::        |
|                                     |                                   |
|                                     |    spte.Dirty =3D 1                =
 |
+-------------------------------------+-----------------------------------+
|  ::                                 |                                   |
|                                     |                                   |
|   else                              |                                   |
|     old_spte =3D xchg(spte, new_spte);|                                  =
 |
|   if (old_spte.Accessed &&          |                                   |
|       !new_spte.Accessed)           |                                   |
|     flush =3D true;                   |                                  =
 |
|   if (old_spte.Dirty &&             |                                   |
|       !new_spte.Dirty)              |                                   |
|     flush =3D true;                   |                                  =
 |
|     OOPS!!!                         |                                   |
+-------------------------------------+-----------------------------------+

Introduced by commit

  5f6a3badbb74 ("KVM: x86/mmu: Mark page/folio accessed only when zapping l=
eaf SPTEs")

--=20
Cheers,
Stephen Rothwell

--Sig_/Vikg07d5ve1SZB4Ur.bXY4L
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmcfS3kACgkQAVBC80lX
0GyqKQf/fQpz2YyVP/bzIvFuL5UioYh+Hf29V91Bh2O9b+LZImJsKW9YLPF9e9Lu
9IxdDuKjJnSYo9u/2e3X1O863R2s5zOHhKiL7emran48d+1ptG4pgNiSjPE/FUbr
hyneoC1WrQ48j6+RUoynog9zp+NIYJ1mYzco8a1rnLoo8n7LwDDGVZduOTvl3+sa
yV7WRIltbltozGJU9Gtyjaxd4Ii6AlKouykx2cznQwxSRX6e0VN0M6VPVQamaqlZ
44H3BzGh9RAzgUO8yS9P/AhHqleC2N1pQxl0X6IRkspFQUFtBkIfJYtQg6rOJ15A
SNVTZ06wFjcWPY8fKLRiOGCNUuSztA==
=eygx
-----END PGP SIGNATURE-----

--Sig_/Vikg07d5ve1SZB4Ur.bXY4L--

