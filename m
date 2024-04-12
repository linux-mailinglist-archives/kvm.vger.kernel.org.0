Return-Path: <kvm+bounces-14378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F74D8A2474
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E176B21539
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3FB17C6A;
	Fri, 12 Apr 2024 03:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="BGYvy4hW"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6671D175AE;
	Fri, 12 Apr 2024 03:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712892921; cv=none; b=RqBLDy2bNP0Gt8878lqfSvXHc774Ui3GLHicnOVb7Jv/Vf47JRhy5uV1jZFJba3YucvzBJRWl0IeeVxqCUXTQVOReMogcL3GqmRg4L8+Kev7NTm7ydGQq46oOHM9RHF9TXKL+Hsg3ZbS4sh7Eoy9+Tzmwo7Y2A1FKSy0N2ASKyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712892921; c=relaxed/simple;
	bh=BUnPMsX7xiAK1WQI+8i6PvsKjuUdnCvXKBJWg6bVUlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZeibXYSk4zT3qBzjmEFf3NJExzwqdvZbz3i41t+GhC3Ij6pGMCW70VHPpYZ5Y32Yh2Qbc+TXNz/9FQ/su9ASFFOO7zXOw5qEMC9WgRyak2epEKG2Pt/Xs1LloZ5anJOTBk7WREE5FYMTZEClDDkPSppTcBVUhIti6aa12paPozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=BGYvy4hW; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1712892916;
	bh=UoSJs0K7a1DrpxDp0WOxpICpKhVRDee6/y03ovBkfLg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BGYvy4hWWQirSwKRZXqwu4Ug0qj2zxMxgkO66Qn4b3CAvORnQ9/BaseHESH9Q6vag
	 R1OTGA3jE7S5SuDDX82taIF1+3uNayP/zZsTaNd+HFYnkI/JmA00I4+KqIRnW7murO
	 tFWReqODAnWkUR/AaxJqqHpucEirmvdADs4uCa2X5j0sFx33ektJ/JWkrwxpPfBOOu
	 SlyABgDuBVUXG9v7GXI7TJFlDAOb7ewpVFR7wDUOEYo3T2DCSBX5MyTo/AZiAMK9a+
	 m+Ic8I3MVYAjo6cXLmZolFWu4y3Tq6bDnV5IV2YHuhAzxjzKGrMhHzoe/Kl/xOBwm4
	 sgJhROBRen9uw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VG2JN4Tqzz4wnv;
	Fri, 12 Apr 2024 13:35:16 +1000 (AEST)
Date: Fri, 12 Apr 2024 13:35:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20240412133516.0286f480@canb.auug.org.au>
In-Reply-To: <20240412133407.3364cda3@canb.auug.org.au>
References: <20240412133407.3364cda3@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3v7HGrvl+Yo=lnfOvoxZj3g";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/3v7HGrvl+Yo=lnfOvoxZj3g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 12 Apr 2024 13:34:07 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> kernel/events/uprobes.c: In function '__replace_page':
> kernel/events/uprobes.c:160:35: error: storage size of 'range' isn't known
>   160 |         struct mmu_notifier_range range;
>       |                                   ^~~~~
> kernel/events/uprobes.c:162:9: error: implicit declaration of function 'm=
mu_notifier_range_init' [-Werror=3Dimplicit-function-declaration]
>   162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, =
addr,
>       |         ^~~~~~~~~~~~~~~~~~~~~~~
> kernel/events/uprobes.c:162:41: error: 'MMU_NOTIFY_CLEAR' undeclared (fir=
st use in this function)
>   162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, =
addr,
>       |                                         ^~~~~~~~~~~~~~~~
> kernel/events/uprobes.c:162:41: note: each undeclared identifier is repor=
ted only once for each function it appears in
> kernel/events/uprobes.c:175:9: error: implicit declaration of function 'm=
mu_notifier_invalidate_range_start' [-Werror=3Dimplicit-function-declaratio=
n]
>   175 |         mmu_notifier_invalidate_range_start(&range);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> kernel/events/uprobes.c:208:9: error: implicit declaration of function 'm=
mu_notifier_invalidate_range_end' [-Werror=3Dimplicit-function-declaration]
>   208 |         mmu_notifier_invalidate_range_end(&range);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> kernel/events/uprobes.c:160:35: warning: unused variable 'range' [-Wunuse=
d-variable]
>   160 |         struct mmu_notifier_range range;
>       |                                   ^~~~~
> cc1: some warnings being treated as errors
>=20
> Caused by commit
>=20
>   b06d4c260e93 ("mm: replace set_pte_at_notify() with just set_pte_at()")
>=20
> I have applied the following patial revert for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Apr 2024 13:27:20 +1000
Subject: [PATCH] fix up for "mm: replace set_pte_at_notify() with just
 set_pte_at()"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/events/uprobes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f4523b95c945..1215bc299390 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -18,6 +18,7 @@
 #include <linux/sched/coredump.h>
 #include <linux/export.h>
 #include <linux/rmap.h>		/* anon_vma_prepare */
+#include <linux/mmu_notifier.h>
 #include <linux/swap.h>		/* folio_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
--=20
2.43.0

--=20
Cheers,
Stephen Rothwell

--Sig_/3v7HGrvl+Yo=lnfOvoxZj3g
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmYYq/QACgkQAVBC80lX
0Gz1XggAiOOOy9JAP40iUMqL+9UgspecbmHh+ThOwV2JtdkuiTikPUoDZ7HUBTdz
m9MssskSBBW7nxomW9Mdvpuc0vJvCoRCBGJE8dkCsNZIkD4E8fUW29InUbDvxOXv
qh9odGz8tG5JNGT54CuEqbNI2wp+iFIC0NRLbHmdfy3WYVHZWE6O7zoFS4JHJbRS
//CYWpSuxFzBnCnbeIwmANfBvV8jG1kdTEuylJjf1Ft6/wKQNjkoO44g5/VhLN4P
r05W76DFzSr1TRXqQDb6Wcb0dQsrgRPKRi8wtSZmsf2iDmf5LB5YnzWg91jcN5O7
VQl3UmpVvppIjyJ7W680P4WSsvJSnQ==
=lvfW
-----END PGP SIGNATURE-----

--Sig_/3v7HGrvl+Yo=lnfOvoxZj3g--

