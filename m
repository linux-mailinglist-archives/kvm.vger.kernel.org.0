Return-Path: <kvm+bounces-31714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 412489C6942
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 07:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E978E287882
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 06:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D852178384;
	Wed, 13 Nov 2024 06:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="g9AtMkmo"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0CF1632EE;
	Wed, 13 Nov 2024 06:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731479351; cv=none; b=oaMnMR0j4T91wWUps/AB14Eubejqd2ZX7TVQwadtmUW1aQJNhCFjxSbu9mLBWsCvvX6wfUEBD6peCkHXtetDQf0kS/cEzxs+eah+Cl1nmtHEycEHlCRIhPqqY20C8OL+bODcgL/Cft+IW/XftCUM7fxff/06gCOxQXQmFURwJFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731479351; c=relaxed/simple;
	bh=KLOTVOoom/sj94CbohhvlCELTlDVVaps7oVMYqeZs3M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jETVkA8+4kcLQ8E/NbpFJfa+3vXlUknj2p9SXyY5iv3P6PR3KGxkj6Z6makn+SNMMNH8PSWFWD7wadI0vE5aCL2o1tWKdTcnEVdoYwCD3DboB4iiGJGcw8nyCbEQ2py4DsA7iCwQ5mfiaWlsETVmTNxVsoXaN+xUsGkkynNtE5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=g9AtMkmo; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1731479340;
	bh=3y4UTnEYjW3asxooorakrDX715n0Ibp6XSKtFzl63UY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g9AtMkmoN3laj9O7jcqqBQ4mT380//KuFHgSvT/CuW0XtDzHKAz5hd2v6Df/vSNTu
	 bmO9d8QbnXt8GM3KIDpkWlEklvms0ZkfJTi8SL47yt9jjQp7uQ2F2ARd3/vQpk5Z5O
	 TrxE1Wxvx1MSFmXNFpojli19jitkpP4QPIeSY6SJn0zWCxFua9eLPLlrdpy19x/9s0
	 pJiBz+cNPC7NjOUBAM0hbcjk2nozmczIsKzvxz5vjN5uIN+akFv2cLRpBHOvl17jFv
	 To8hnty+ssA8mO9QuBHvh750HXoxPchXvX4hdlSQG2y1KuQkqJhH0x6ZmeZTJ/BPM6
	 upf5AnTY2lgVA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XpCzc1pgWz4x3q;
	Wed, 13 Nov 2024 17:29:00 +1100 (AEDT)
Date: Wed, 13 Nov 2024 17:29:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
Message-ID: <20241113172902.7ada7d6e@canb.auug.org.au>
In-Reply-To: <20241028192945.2f1433fc@canb.auug.org.au>
References: <20241028192945.2f1433fc@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/75US9MYnmmpLFYgZpc9Obal";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/75US9MYnmmpLFYgZpc9Obal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 28 Oct 2024 19:29:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (htmldocs) produced
> this warning:
>=20
> Documentation/virt/kvm/locking.rst:157: ERROR: Malformed table.
>=20
> +------------------------------------------------------------------------=
-+
> | At the beginning::                                                     =
 |
> |                                                                        =
 |
> |       spte.W =3D 0                                                     =
         |
> |       spte.Accessed =3D 1                                              =
         |
> +-------------------------------------+----------------------------------=
-+
> | CPU 0:                              | CPU 1:                           =
 |
> +-------------------------------------+----------------------------------=
-+
> | In mmu_spte_update()::              |                                  =
 |
> |                                     |                                  =
 |
> |  old_spte =3D *spte;                  |                                =
   |
> |                                     |                                  =
 |
> |                                     |                                  =
 |
> |  /* 'if' condition is satisfied. */ |                                  =
 |
> |  if (old_spte.Accessed =3D=3D 1 &&      |                              =
     |
> |       old_spte.W =3D=3D 0)              |                              =
     |
> |     spte =3D new_spte;                |                                =
   |
> +-------------------------------------+----------------------------------=
-+
> |                                     | on fast page fault path::        =
 |
> |                                     |                                  =
 |
> |                                     |    spte.W =3D 1                  =
   |
> |                                     |                                  =
 |
> |                                     | memory write on the spte::       =
 |
> |                                     |                                  =
 |
> |                                     |    spte.Dirty =3D 1              =
   |
> +-------------------------------------+----------------------------------=
-+
> |  ::                                 |                                  =
 |
> |                                     |                                  =
 |
> |   else                              |                                  =
 |
> |     old_spte =3D xchg(spte, new_spte);|                                =
   |
> |   if (old_spte.Accessed &&          |                                  =
 |
> |       !new_spte.Accessed)           |                                  =
 |
> |     flush =3D true;                   |                                =
   |
> |   if (old_spte.Dirty &&             |                                  =
 |
> |       !new_spte.Dirty)              |                                  =
 |
> |     flush =3D true;                   |                                =
   |
> |     OOPS!!!                         |                                  =
 |
> +-------------------------------------+----------------------------------=
-+
>=20
> Introduced by commit
>=20
>   5f6a3badbb74 ("KVM: x86/mmu: Mark page/folio accessed only when zapping=
 leaf SPTEs")

I am still seeing this warning.
--=20
Cheers,
Stephen Rothwell

--Sig_/75US9MYnmmpLFYgZpc9Obal
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmc0Ry4ACgkQAVBC80lX
0GyjxQgAm3DWnQq+aJ2CLsggxTJTxbsrcEEogEUu/kAfbDxHyPiSjoChIhdlviQC
nBOCACDjMSA2z6lZjMLqo67uAFZoFlsCoWnPSYoXh+FEgl8uKW3DoeXi1LfC4dwz
zG0eRZm9mAqtI14+GcPhqUJAHIfEylvMBka3qeYj/cE0Sgr/wwipIZ7fVyQ1V11J
DJ4CHHoB06Rw+FTtCbNh7cU824WZIflC8E0z8db8FyH9EKeJQminf0/Cq64aO+iv
eOJpvyhGAfYKFv6S3X+1HaAXfedZ4UGviEgosG2yjIFosqwVDaY1eEO9TaF5fGmj
bn8Y+Mxu7DmhSam8iVWL1rJQLiASfg==
=OwZ/
-----END PGP SIGNATURE-----

--Sig_/75US9MYnmmpLFYgZpc9Obal--

