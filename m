Return-Path: <kvm+bounces-4895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5318196F5
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AE16B25333
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953E68F44;
	Wed, 20 Dec 2023 02:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="pHFC0HeD"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4E78488;
	Wed, 20 Dec 2023 02:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1703040775;
	bh=u+n7djgZgZC5+nAlDbG46jcmuKzAaYJMrC+bvBoFM0c=;
	h=Date:From:To:Cc:Subject:From;
	b=pHFC0HeDZMm6Nyp7PFD9Q3ura+L1lAAv6lwFHd14ZzBaxFyYuwZw//HbmrbbXPvt7
	 52PAJt63HgWKz7Ys4p/n7Ud1JEDRNIrCySKyf96CFDzwTOX96cUIZCHfZz4S/O0Wnd
	 z1/9tOGtwu7hYivg84JoWZU94QVbVHSgyjFdfXHdUBb5B0qa3fJc30r8WLt9LpuglQ
	 hM8oxnSlThBtCK1UXmaQvEqTwcrG/QOcoq7HF3Terh1f0uN5jxacRtNefHfraL32h/
	 1LEpzSNK7OTXwza6jJnrpSnghgLXgllT9GXPzTPX1TG3gYdyDY8fcfI++zgSJyrgHk
	 1YJNlndx+Z/jQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Svym55Pdkz4wdD;
	Wed, 20 Dec 2023 13:52:53 +1100 (AEDT)
Date: Wed, 20 Dec 2023 13:52:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, Jens
 Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with the block tree
Message-ID: <20231220135251.67a61536@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Se2yPS5HSeJnu+2cA8zfccr";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/Se2yPS5HSeJnu+2cA8zfccr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  io_uring/io_uring.c

between commit:

  6e5e6d274956 ("io_uring: drop any code related to SCM_RIGHTS")

from the block tree and commit:

  4f0b9194bc11 ("fs: Rename anon_inode_getfile_secure() and anon_inode_getf=
d_secure()")

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

diff --cc io_uring/io_uring.c
index bc0dc1ca9f1e,db3f545ddcac..000000000000
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@@ -3777,8 -3867,28 +3777,9 @@@ static int io_uring_install_fd(struct f
   */
  static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
  {
- 	return anon_inode_getfile_secure("[io_uring]", &io_uring_fops, ctx,
 -	struct file *file;
 -#if defined(CONFIG_UNIX)
 -	int ret;
 -
 -	ret =3D sock_create_kern(&init_net, PF_UNIX, SOCK_RAW, IPPROTO_IP,
 -				&ctx->ring_sock);
 -	if (ret)
 -		return ERR_PTR(ret);
 -#endif
 -
+ 	/* Create a new inode so that the LSM can block the creation.  */
 -	file =3D anon_inode_create_getfile("[io_uring]", &io_uring_fops, ctx,
++	return anon_inode_create_getfile("[io_uring]", &io_uring_fops, ctx,
  					 O_RDWR | O_CLOEXEC, NULL);
 -#if defined(CONFIG_UNIX)
 -	if (IS_ERR(file)) {
 -		sock_release(ctx->ring_sock);
 -		ctx->ring_sock =3D NULL;
 -	} else {
 -		ctx->ring_sock->file =3D file;
 -	}
 -#endif
 -	return file;
  }
 =20
  static __cold int io_uring_create(unsigned entries, struct io_uring_param=
s *p,

--Sig_/Se2yPS5HSeJnu+2cA8zfccr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmWCVwMACgkQAVBC80lX
0GyU2gf+OY5SIJaF+IjNQMWUt2zmqt/rolbsnDZUnWJ3l1iiq30lDQtlVOfbZP7j
c3fu65tRA1OAJjALfvNaTCppB5iR7e4uN9tFkYt1Xu0fMHvd8ZAqrpj4mffuGVx6
PgMwRBSqAjU3dzEWslOJJqJoyJ7EmvqrZ6Yek3PX6iu46jvEn3wZdJlfJOTODSJg
0ufHB7jPBPmpUN4N44YgpJYHR/ULVFC7cyxFE0Gl+E7JWrC/yD+cKCyX9rRDIE2r
ZekKllT7ApCq6iroR/73u1CX5xwRW7EGXCMcJ8xNU65cHqaEjZrY1nLlHhglmJP+
Yf/nmoGi4DJ7JOuD/8u8chs+D8o4lw==
=dNsd
-----END PGP SIGNATURE-----

--Sig_/Se2yPS5HSeJnu+2cA8zfccr--

