Return-Path: <kvm+bounces-43754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03E86A95F8D
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8FCC16B510
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 07:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE69C1EB5FE;
	Tue, 22 Apr 2025 07:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Zlc3r/SD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E715B115;
	Tue, 22 Apr 2025 07:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745307230; cv=none; b=db4KtxO5XdmZpbm8zfxkzOJLvZ56k11Dop9XzG6OTY0mY2BIHwllYnUNpu1W/o5M2EZyezlRFExUBHo5EQxNcIMZWDAEkxrxcjYFQHJ2bnP0EdpYUKVUWkYKZ1h8dJryxodOPeXF4Tk9q4G8Wp715eB9RHWTK27J+1LyuILEotg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745307230; c=relaxed/simple;
	bh=ViXx4eONjGlhBzfMVmJsvt2CzOO/9DfBnFvVJXYr5No=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDPK51YjYqsGx9MlEJan8R9I3YsDH42O1hNYdbmi7ZLn3p9bZXUMegZkD5w6vUKeXqA2OqgVbafWDq0kFkLGBQacNBnFdxJyywZWfoRWjCGhXE+a4G7jPgmlEWN9aSrZKzCZCAYkwMmVxddZ9xPkJTxTD+7V/r1e0w+8yaiOTUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=Zlc3r/SD; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1745307222;
	bh=I9TVUx6c4BGgBvFzBgkb4c3HADW5EmiA9gvacOc8TdU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Zlc3r/SDgyQhzJOHNU0BK2C14izZy992cY9AcNPTja9Aof/QcXakRIe4MKZMsCAAA
	 Jlo3a0LsotHrtrI9v7lrxMvHDGj9FuUE2ppprB/TCsawDxvR+FXmAalNnwGMfzh4+I
	 OHBwnDLdQou7xb9G4YAiwIxCoUp3EbGSU4LygpW2xai2m/KJDypcAh1VhTYoi2rru6
	 VVW972meNLKPZZTZX1DuKlwm+ifc23osgLvUSooGdC9aZ/clJVO6bTvCmI1z1l0cM4
	 rnF0+TiZbH2lFujjiJE8dRevxWVHCrIQeOBB/Qu71Em5CxYKXPpv5oZ4pX/n/soChc
	 /vIvfpK4UMdoQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4ZhYrQ59Lvz4wbX;
	Tue, 22 Apr 2025 17:33:42 +1000 (AEST)
Date: Tue, 22 Apr 2025 17:33:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm-fixes tree
Message-ID: <20250422173341.0901ebaf@canb.auug.org.au>
In-Reply-To: <20250422124310.2e9aee0d@canb.auug.org.au>
References: <20250422124310.2e9aee0d@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JFLYtN+IoJsJtENQJJGvQN5";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/JFLYtN+IoJsJtENQJJGvQN5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 22 Apr 2025 12:43:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm-fixes tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko] undef=
ined!
>=20
> Caused by commit
>=20
>   73e0c567c24a ("KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled")
>=20
> I have used the kvm-fixes tree from next-20250417 for today.

I also had to use the kvm tree from next-20250417.

--=20
Cheers,
Stephen Rothwell

--Sig_/JFLYtN+IoJsJtENQJJGvQN5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmgHRlUACgkQAVBC80lX
0GxTVQgAkBd8sPKtfGpF2GLbqxHFFlRWP21deua/52Uc4A0FDjDzIQo/xNvloVAk
ZtMQoY3o8DH8OYPSC8CWKMOfVnfI+yOcnhksyLmP31f0GJbRvzgd3507lmOySg2v
Md/c62aK8Qr8h9WVDxnQ9Xy0i4L/eLvIElxIEaMb0CMZEnwRU3yCVxknCDeMC3I4
bPCTTU4g56NiNSkZANFRoW6J7KW4vZ0tP14hQ3h38bDP9LA1OcTHF+iNoGT0ELkE
p/GCiub2Ja2OEjZAhpKDKmwT2rBtJMRfwPPlOkAvfWWRbAsnhljTIaR4XaKPAdMf
pGdrlzFgGPoVZF0HA3uNJ63swszjdQ==
=iUXD
-----END PGP SIGNATURE-----

--Sig_/JFLYtN+IoJsJtENQJJGvQN5--

