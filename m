Return-Path: <kvm+bounces-47845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0610DAC6144
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 07:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F0851BC2F69
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 05:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D5D20458A;
	Wed, 28 May 2025 05:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="dvdNXzEO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BA6F9E8;
	Wed, 28 May 2025 05:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748410122; cv=none; b=GbcCV5Rng5kGIZQNAfY0EacK1yxqKVhiygi5Iwe2S5EWvsh3I6eRGozfmkXT3XgcJ8FRp69ptyc4FiOHafVcNahSLJ7CRs86htpRuzGlzY7htvdlkibp1ZfCvpipPIUCq++eXatBgG113zDt/R7BXLAhK3n+ue2FRZT3NHhGZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748410122; c=relaxed/simple;
	bh=+czCOGVe7tz4injuv9NQuV3PobqsvGxJ4nyQ4ioD9lU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=crgcdlsD5+jaonViCvZJO4SHhXl9Y4rSCo2VTN37ra1+AxGFiu+Qklf/CGeanjOwO/KCmTmMvgAJUSnUvmQdJOcKJ0Tn1kct89orFtRqZeGbOKc+Sc8Pk8dmkMnC5K8oWs1tQOoApV+4rmcWANqZtDN/PXsFjMKwV4Lrkzzr0qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=dvdNXzEO; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1748410113;
	bh=Aw4qnLvSGZ8usqlOGUUgSD3mt1Ujj0x7KJRUzlUoK7c=;
	h=Date:From:To:Cc:Subject:From;
	b=dvdNXzEO1HAzj20noz92SNalzzXW1fWHv9ew1+Ra+4wgDqZfK8D+XIKTNIo/qjz3+
	 amLl6Pb9KfVIi/4Djx3q0AawkkK1/SAwnkQGhgNiALJgXMFZsvD5ZXhWpxRKpbAokB
	 x3wdiZQWV0/2bvKGl08ksdURt9qYoR/E4dq9J0XAmjQqPbpZ4VDV1TZJzDpqPK57w9
	 P/LVH4hXgMv0G+kPPtwJ1qYDt8GXXpoxzr68RI2Fth0hbFHb4SJ9AFOe3xxIHmaw5+
	 ybvtKsx6gYpvwRsKv1PdaIfhj5wSbppUDmvzh3ziThwmpjKDW0AnH3Myvba9KNkwFx
	 WsskEWBLesifw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4b6dMP1XDKz4wcD;
	Wed, 28 May 2025 15:28:33 +1000 (AEST)
Date: Wed, 28 May 2025 15:28:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, KVM <kvm@vger.kernel.org>, Linux
 Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20250528152832.3ce43330@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8t7IU+J+lsYfCXpYhoZ7cvV";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/8t7IU+J+lsYfCXpYhoZ7cvV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

error[E0425]: cannot find function `mutex_trylock` in crate `bindings`
   --> rust/kernel/sync/lock/mutex.rs:129:41
    |
129 |         let result =3D unsafe { bindings::mutex_trylock(ptr) };
    |                                         ^^^^^^^^^^^^^ help: a functio=
n with a similar name exists: `mutex_lock`
    |
   ::: /home/sfr/next/x86_64_allmodconfig/rust/bindings/bindings_helpers_ge=
nerated.rs:265:5
    |
265 |     pub fn mutex_lock(lock: *mut mutex);
    |     ------------------------------------ similarly named function `mu=
tex_lock` defined here

error: aborting due to 1 previous error

For more information about this error, try `rustc --explain E0425`.

Caused by commit

  c5b6ababd21a ("locking/mutex: implement mutex_trylock_nested")

I have used the kvm tree from next-20250527 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/8t7IU+J+lsYfCXpYhoZ7cvV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmg2nwAACgkQAVBC80lX
0GwOxAf7BhoRonJStMXDeDSttM4k2vUAwApF0geAwTRkbwalc/2QqAGn57sV2HMs
NWvsRrA5MD6aPTK4TzL0T+1bNMkH1VRWrTshRpoYqpC1vfuZSHdb4Xkg0yDpq8IW
6P88GtpeMSl1qsOhytq+ARAEH+uB3G0w8g8yTIuosCwb1NFMIlMmmEWBQR5UKIEu
j4xa/MG/Q2Y8PF4I6RLB4z77UxKz/u16/K6rzxVzkc8OdrBAaLmCLMP6uGqaD3jJ
puwvayXPtk2zJYi5cy6jR84XpV9gzP3GzAjxIY4eWT7ikulT6T/y1Cel4+7yTEOw
FwHKDdWR5SQtzufClQzSr1xkaSa0VA==
=ADQx
-----END PGP SIGNATURE-----

--Sig_/8t7IU+J+lsYfCXpYhoZ7cvV--

