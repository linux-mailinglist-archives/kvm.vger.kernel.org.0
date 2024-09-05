Return-Path: <kvm+bounces-25922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D130F96CE85
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 07:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9562A288BB9
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 05:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F42E1891BB;
	Thu,  5 Sep 2024 05:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="k1/2jNqj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF7779F5;
	Thu,  5 Sep 2024 05:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725514887; cv=none; b=c0KkPO45ZTnPpv8O3t+f31Z0ueWOIx82mCQT5QQhJ3gBmXsdIipgZhk1LZmmqGHjVLjLUUW+hIU7KhzgeS2bOyG4a665jRztfG9D6homQVKIbbZezQgfkvOWsblrGF8PMQvmxJX1LjHmdbPQo/P2v5ZiD5zQwD2ViTXET1AJD1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725514887; c=relaxed/simple;
	bh=bukNGaq1h4j0tZ1iIyqrdFGIwoKB2kFX5gMr3mYk97E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=e7tLpCO0QwjZyfLQ/SFi7/MwPqPPeSdQW5Vrc9N9V35j6ZTwC528B7DbGMyf2mq5n2ig9Ln+PM7hXkGUoTQZlBLBwvCOGLFgSgE7peANowYda+Y4u8eGPPrvtIyS0kJEr8hYPEY5zALZ2FKAbXv9mpiw4YnUZNVRWvy6N0T4dcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=k1/2jNqj; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1725514883;
	bh=pzxIrb4vHscmNo6gBj3hMeGWCocCmBxoXFQK8/UPJwQ=;
	h=Date:From:To:Cc:Subject:From;
	b=k1/2jNqjfpoYRW8bKKgo9AkCqW/3wKnzxtDrrzIrWdmOS32aTsGgTBD6S/zqG6EnX
	 3eN2XN1Zgtl6mMvCEiuxdmVco8O8YwUov29BEAl2nxF5eTgyFjVY9a7ImH+xdLpanc
	 nRjcbEcibEFuPiuR3/QFfO1aupx8bkAa87xbmviFWpbPA/hTvfOFsvUYzbpxTg1gU8
	 F95IpMgCzkNDWriAaeLqndUukWZ+Dg4PCssJ1P+Dfq2O/FF5ZTXVXAFQeQ3i1Wqi9Y
	 yXyWeplckFcfetB8zmtySWyEc4ppnuZHKjlE2wwq5xnZRZQdRwC+Xo2zc195eR4EJz
	 SJVjU4Bi1brNg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WzpBW2b0cz4wnw;
	Thu,  5 Sep 2024 15:41:23 +1000 (AEST)
Date: Thu, 5 Sep 2024 15:41:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@kernel.org>, Frederic Weisbecker
 <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Boqun
 Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>, Paolo
 Bonzini <pbonzini@redhat.com>
Cc: Leonardo Bras <leobras@redhat.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Valentin Schneider <vschneid@redhat.com>, KVM
 <kvm@vger.kernel.org>
Subject: linux-next: manual merge of the rcu tree with the kvm-fixes tree
Message-ID: <20240905154122.4d1f8ca5@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YbPb85dQp7jbj/Z7FqJY6u5";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/YbPb85dQp7jbj/Z7FqJY6u5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the rcu tree got a conflict in:

  include/linux/context_tracking.h

between commit:

  593377036e50 ("kvm: Note an RCU quiescent state on guest exit")

from the kvm-fixes tree and commit:

  d65d411c9259 ("treewide: context_tracking: Rename CONTEXT_* into CT_STATE=
_*")

from the rcu tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/context_tracking.h
index 8a78fabeafc3,d53092ffa9db..000000000000
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@@ -80,12 -80,10 +80,12 @@@ static __always_inline bool context_tra
  	return context_tracking_enabled_this_cpu();
  }
 =20
 -static __always_inline void context_tracking_guest_exit(void)
 +static __always_inline bool context_tracking_guest_exit(void)
  {
  	if (context_tracking_enabled())
- 		__ct_user_exit(CONTEXT_GUEST);
+ 		__ct_user_exit(CT_STATE_GUEST);
 +
 +	return context_tracking_enabled_this_cpu();
  }
 =20
  #define CT_WARN_ON(cond) WARN_ON(context_tracking_enabled() && (cond))

--Sig_/YbPb85dQp7jbj/Z7FqJY6u5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmbZRIIACgkQAVBC80lX
0Gx34AgAoAdUkrl9V6aVPa56QtAHTIV1ALI36tg6X/3gDFDCIiMmIoUeT6JvgSHG
SB3y5mZgrCkAOwU4+ELeaLhxuhuWtRPi1AITzPr3KyfiaZ8MirkUM9o6NwTtO8Kw
hl9Dwhq89ULXXEpoDCZ8BWhIkIbyZbZ/q8CVpNXhXdiVnbtrhuBf4OUBbo3morkm
Ewai4oTwghRjkLHfLml4dFcFyeFEztH3gFYFG+1sXtK+qwWTKQMvIfB7JkAmbo4P
QGs7KXZFHn+cCGoiOUeKsne8TBCDavGArXx6AaC8Zt43tkDT/nl9KKISduuNBAku
R4O2AMXF1cxU1BZfkID5b7Pi+inuZA==
=IGXu
-----END PGP SIGNATURE-----

--Sig_/YbPb85dQp7jbj/Z7FqJY6u5--

