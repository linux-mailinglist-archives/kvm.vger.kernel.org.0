Return-Path: <kvm+bounces-13409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A12D98961B1
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 02:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D23A91C224D0
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 00:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3463101C4;
	Wed,  3 Apr 2024 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Np+rraRc"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246AE28FC;
	Wed,  3 Apr 2024 00:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712105646; cv=none; b=PoEUcYnEchiiRrRvG+eL8DAA+ZDRhZt+2ABb7wS44C1gS5+9VjgTWQydWAJdPJLHSshO7gprVr83UTfylvy5Z+OdL8CGf6Wb2km7B5zhC7eUi2/TQvWL27aoMtZfL1OYV1WgBbhMUbR329CoonW4Keu7l6937CPIWQ3GmW3iTZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712105646; c=relaxed/simple;
	bh=+SAlP9kHVlh7iFi31R674pJNdtdpSCKCF/iafEcczb8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=bNK8KWQia0m/rRtiHoyv7hMaUKk4SZAu7FdxqAIFvxJXJri8s3SRR5mqcb4S0FZ0s+5b1YUuYxAgGVuwRNyN0uU21T3JvQNxztOcEbfdnb5Ua2ge6Q+n1idzRuJwT9OGqJXz60gZWHhNxPsHj6IoMJzSLlNr4GP/g5soF9Abk+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Np+rraRc; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1712105636;
	bh=yMn7CWEDwJ/I6VqHvO9A+ou6USwpxJZr7pe1Gsdq7JM=;
	h=Date:From:To:Cc:Subject:From;
	b=Np+rraRcjNWKwmpKmZsXUhzCQWNNNY7g3UlfWpjqoOpejTDE9iF0DV52vVLkeGJoc
	 wVjy1fzq7N+oG78k3v+gWzW9tE4somCTHEUa4I7Ht3d120kdkFk7CKZnhlGiP9BRh5
	 Uf8T8voEHjzjcNiULKtMJtEUYkgQIDLVJxuP+KDiyPAQc0lzQ2wKp41MrxlyGyEo+J
	 slawaRzSTWHHQMEttJKAKuykgOdJl84Yji1L7vEtiillFhBwVih8f8U2PDwb9OBOSW
	 Z8wGrrWnDx46G2nWRHLSVs9rISivqmrP4pH1aEgSkTJWYoWYbSyMrslrFOHjiUCFWK
	 2NL72tKABfTgQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4V8R8M6tGhz4wcb;
	Wed,  3 Apr 2024 11:53:55 +1100 (AEDT)
Date: Wed, 3 Apr 2024 11:53:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm-x86 tree with the kvm-fixes
 tree
Message-ID: <20240403115353.59c7b4f4@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fZQSE1CbvT3OvZf0/G5tIRg";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/fZQSE1CbvT3OvZf0/G5tIRg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-x86 tree got a conflict in:

  tools/testing/selftests/kvm/include/x86_64/processor.h

between commit:

  0d1756482e66 ("Merge tag 'kvm-x86-pvunhalt-6.9' of https://github.com/kvm=
-x86/linux into HEAD")

from the kvm-fixes tree and commit:

  964d0c614c7f ("Merge branch 'hyperv'")

from the kvm-x86 tree.

I fixed it up (I used the former version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/fZQSE1CbvT3OvZf0/G5tIRg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmYMqKEACgkQAVBC80lX
0GxbOwf/eDxlNKVlJRm37PWQKeKQ4FMvKavrHBe+EpehdSNcMn73XkwLWGPsKxhE
af9jilp7xlyK2FPoPmm2NYMqlihC3DQ18T4ZaxKiAnxCcgtmRISkxKJrHhHftgOn
UyWhX5+6gt7McLrKG8JaFPG7g3/yg4JvtfG0fmohcQ9kQNKVqmVHTyHbXbDHwwkh
8wQd9SCT26+EYdy3Mig6r6OtBYSEUWTJUWLzUeQj0O7YgeBi9TatenqJw5qCl/+C
avSYM7ZMaktIltmQMJb+RXPF+6Wqj3uWiyzBHy9RR59bv+o9qux7R8ZjhK04/q6o
j/3ENljd8K1yW2wgRZrEB1H+M0UASw==
=X0Oj
-----END PGP SIGNATURE-----

--Sig_/fZQSE1CbvT3OvZf0/G5tIRg--

