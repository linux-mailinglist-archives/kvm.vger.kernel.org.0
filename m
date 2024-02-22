Return-Path: <kvm+bounces-9378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9BD85F673
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 12:04:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0765A287EB7
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953193FB28;
	Thu, 22 Feb 2024 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Ok+AwaJA"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873433FB03;
	Thu, 22 Feb 2024 11:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599838; cv=none; b=NUFvZDIjTrkXFAJHvcSAiKxPBO5zEDyUnzI0cknvqzvqCDsHh7pgWs6D+I8d1OH3+qTZE0OQ2MTd7UU14bznev9zf6pPCWjZeD5M9k6++FDgNuG6D87SVwyxX+5MjadC9hB17Po60mrssqCrZY9Sm5qdtQF6aC/311KBGN8fb3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599838; c=relaxed/simple;
	bh=Nhvkh3qGjiDklbVBphgKeKpgEVtWOE3lKREbR9yWuAM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=bknI+PVS/mFKaqQ5inJjurIUskK0D96rXSz2XqGXg6+SZIJaKCbMtxfHnvDPVqRUIB0P7imiScocEqqFD6n83OuJMOjmsozcICNsKJ+Z9pEY0BB2SjE+1QkIe56p/KB+OuD+y0F49jLEPsS11zrl4FnB5OY7VZxqCHr0/+QmdEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Ok+AwaJA; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1708599832;
	bh=mnmf11XsRxjTJ5dv9VjzYEWEYDyN39lp43BiigEjMvE=;
	h=Date:From:To:Cc:Subject:From;
	b=Ok+AwaJA7UQoqKP7Mr9J45edM+obH/evIa4ypaSjAwPOhFtZ8plF5ArxtaKMJkYao
	 Wlr8/yTgyung0ZdPcruCMOTqDmdetR0gUh2dtowRvMCQgyORWKgknj4jZGlRh4ihHF
	 sZZ/sjWrvP+g1Rw1OKv/3KLK8U83R3V+JuxwRQXQMJfgv0N5vPDprpCKpX4RuQ1hXD
	 oyNBQaS0LuvmmrKgaQzEfto3P/v0lo5x4IkYV4l6+YnKQxjUxYEbC6nhC98xnLQ72Q
	 OmrlKOtEripWh3SJMewBp7UuyvpIBQ0fPuChksT3xFlpo20OSAyl1fWUsYbx9gDxfh
	 eT9p+f+oDnUQQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TgVd34jxJz4wcg;
	Thu, 22 Feb 2024 22:03:51 +1100 (AEDT)
Date: Thu, 22 Feb 2024 22:03:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall
 <cdall@cs.columbia.edu>, Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm-arm tree
Message-ID: <20240222220349.1889c728@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XniYb+l32S1LzO/j40ZgFnL";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/XniYb+l32S1LzO/j40ZgFnL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (arm64 defconfig)
failed like this:

In file included from <command-line>:
In function 'check_res_bits',
    inlined from 'kvm_sys_reg_table_init' at arch/arm64/kvm/sys_regs.c:4109=
:2:
include/linux/compiler_types.h:449:45: error: call to '__compiletime_assert=
_591' declared with attribute error: BUILD_BUG_ON failed: ID_AA64DFR1_EL1_R=
ES0 !=3D (GENMASK_ULL(63, 0))
  449 |         _compiletime_assert(condition, msg, __compiletime_assert_, =
__COUNTER__)
      |                                             ^
include/linux/compiler_types.h:430:25: note: in definition of macro '__comp=
iletime_assert'
  430 |                         prefix ## suffix();                        =
     \
      |                         ^~~~~~
include/linux/compiler_types.h:449:9: note: in expansion of macro '_compile=
time_assert'
  449 |         _compiletime_assert(condition, msg, __compiletime_assert_, =
__COUNTER__)
      |         ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_a=
ssert'
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_M=
SG'
   50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condit=
ion)
      |         ^~~~~~~~~~~~~~~~
arch/arm64/kvm/check-res-bits.h:58:9: note: in expansion of macro 'BUILD_BU=
G_ON'
   58 |         BUILD_BUG_ON(ID_AA64DFR1_EL1_RES0       !=3D (GENMASK_ULL(6=
3, 0)));
      |         ^~~~~~~~~~~~

I bisected this to the merge of the kvm-arm tree into linux-next but I
could not figure out why it fails :-(

--=20
Cheers,
Stephen Rothwell

--Sig_/XniYb+l32S1LzO/j40ZgFnL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmXXKhUACgkQAVBC80lX
0GxtLwf9ESR99ONEv2qGVPNShHnzbFrvMULx7FtOOrP3djqk/AfXgLrLjdEdw7DR
kIPTEyM6QINWCSNRjVsJJ6Gt4RvTrAm5OntbhyAl50fLTakkuIsiEIVSsk+C4b55
bf95IYnUIY16kkWU2mYgxwIwQW7AzFUUYK7t63vi4g+EVwMQLMdevZfzNPA5lZ04
R+vxKNpVi2/H1XFrP5IXwKwAOXmzAnB5dzSp/notdsHjM5tt8qhbYQMTny2G2GjW
vPQMi8SpXjl9//6dUHqHusz6vHFW+WH4iD0LzAOlcQr1Hp/Z0IlmheB7IOZleVKl
gyMQrzi5/zurFFvWxbpPEOwS+XxGQg==
=ayAK
-----END PGP SIGNATURE-----

--Sig_/XniYb+l32S1LzO/j40ZgFnL--

