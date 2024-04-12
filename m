Return-Path: <kvm+bounces-14377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B14A8A2470
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B62991F22CE6
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFD717C6A;
	Fri, 12 Apr 2024 03:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="g+Mq3vUO"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0CD28FC;
	Fri, 12 Apr 2024 03:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712892855; cv=none; b=HUZga4YfPZWsztky/nrzSkFjWZCNxDMMtY91yoOngM65NA7kiKOyPFrXlAdRhIWiD4YwuBt2oBYwt0Oa+ypmDElsuVx8lNUmb7bprNzOWVt44BdShZoSAizzZHUbsnF6PvlOg/y1hIYNqWMNWZd9pDVIZlprImpTrCZ6sy5r/Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712892855; c=relaxed/simple;
	bh=7UUc+9AWLzj9smYxaD8BUoPg3oDr6y3pMqaVgw67Uu8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=qrUSr3H23pcnWTKjqT6rNSonJVlgq2904uvYObQ0b1ULQ27RO4Wfs+E9ep4ft1xkX33I5Vtq+4ulzGVDYYQ9TGd8kHyAyKDOLg4dbDmal3aGXW9WQI5IHm1foDzHxLEF4DMwsq9p1VxfI7uaWv2nwe+CsnvJJm/6YUrhSEoB2wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=g+Mq3vUO; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1712892848;
	bh=9NHUhxP5YI/EJKapznWec2l/J2qFs55hoUvYBue1eMU=;
	h=Date:From:To:Cc:Subject:From;
	b=g+Mq3vUOnS8hzVRgMdknmHD56/BeU0fOre6PzCJsL3Q2XYx9LXjt8Gm3kNr3EA9XL
	 R6WsDV7+Xa3Gq6+0Dwboc30L6YEpBnNP/KVj3KdboZ1Tp8glG+WIcYggr8bs5QkL2Z
	 i0KAlC3pd3ALsZ+ZZbu+rQSRxonnFyF76L6RnbNwOBJW1eDcGlIfy43XTEeIGi0Pni
	 +K9VoYE7iVh51pDKXus6z3BPTPDxvHEYvb3ZnEM0T4EWH6IAmxgoHOV2u8PEJm5oyj
	 DquSCnDdAU+uPPvvRXNpPG9fWhYbo4odgSVVMZjC1N+3CI4WR2LFOyV4i1crQqEnFJ
	 yPhkLbyK6Hywg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VG2H41Dpjz4wd7;
	Fri, 12 Apr 2024 13:34:08 +1000 (AEST)
Date: Fri, 12 Apr 2024 13:34:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20240412133407.3364cda3@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XoZoWVvdCW=_3sRXUnSB=2I";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/XoZoWVvdCW=_3sRXUnSB=2I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

kernel/events/uprobes.c: In function '__replace_page':
kernel/events/uprobes.c:160:35: error: storage size of 'range' isn't known
  160 |         struct mmu_notifier_range range;
      |                                   ^~~~~
kernel/events/uprobes.c:162:9: error: implicit declaration of function 'mmu=
_notifier_range_init' [-Werror=3Dimplicit-function-declaration]
  162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, ad=
dr,
      |         ^~~~~~~~~~~~~~~~~~~~~~~
kernel/events/uprobes.c:162:41: error: 'MMU_NOTIFY_CLEAR' undeclared (first=
 use in this function)
  162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, ad=
dr,
      |                                         ^~~~~~~~~~~~~~~~
kernel/events/uprobes.c:162:41: note: each undeclared identifier is reporte=
d only once for each function it appears in
kernel/events/uprobes.c:175:9: error: implicit declaration of function 'mmu=
_notifier_invalidate_range_start' [-Werror=3Dimplicit-function-declaration]
  175 |         mmu_notifier_invalidate_range_start(&range);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kernel/events/uprobes.c:208:9: error: implicit declaration of function 'mmu=
_notifier_invalidate_range_end' [-Werror=3Dimplicit-function-declaration]
  208 |         mmu_notifier_invalidate_range_end(&range);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kernel/events/uprobes.c:160:35: warning: unused variable 'range' [-Wunused-=
variable]
  160 |         struct mmu_notifier_range range;
      |                                   ^~~~~
cc1: some warnings being treated as errors

Caused by commit

  b06d4c260e93 ("mm: replace set_pte_at_notify() with just set_pte_at()")

I have applied the following patial revert for today.



--=20
Cheers,
Stephen Rothwell

--Sig_/XoZoWVvdCW=_3sRXUnSB=2I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmYYq68ACgkQAVBC80lX
0GwKJwf+LxCKR/B3h+5Y+ROivsBKoQNcSbtZdRJdmQialSJIHIa2IY2dm5pEF9D/
nQ7b7GS0S9oJ2AhDN77CEDnpmwAoeNyDCtIjw/H/FE94BwJm3STg42i/8/l8ssfP
QDifXLUYHv+ozqLBASs28unuhbkz+06s+0978xzl/gxpLUouQ6cbVIqJFLpz6wUi
wl5f+Odxjgf4T+axgNpUxixRfQNRGgWioONBE1rgoo7Ta0OioRM1KXd07f8p2RL4
VPQ3r0GdeIVfjGtNd4PS0d4AhKeSxHww/a1rR/HbBTLcNce3z+CQLAziEHhj+zKG
b8nCO/vcKw0q9FNpLIgK+RBigeo4SQ==
=5LsJ
-----END PGP SIGNATURE-----

--Sig_/XoZoWVvdCW=_3sRXUnSB=2I--

