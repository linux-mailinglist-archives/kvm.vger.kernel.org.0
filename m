Return-Path: <kvm+bounces-22656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 184E3940EB6
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C709E282B19
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FD619882C;
	Tue, 30 Jul 2024 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="ZhX3ZqAf"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6542E18A92A;
	Tue, 30 Jul 2024 10:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722334315; cv=none; b=ZQ6qhQ6yPNHUgZ4MsDwfuvWAzxMu5qqM7pp/B/kOVg2MPcnTORxW5wntNB33jEMnGrBpJMw5qXFRPo/AB8lFr1MhqQjpbpohmwSZ+L1OqwYn+nRc1EGQT1p0UVG+L4qUtXWNG4qWKU3kX4jpAjgTaGU9I2bxVV8J4By7l6SxFZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722334315; c=relaxed/simple;
	bh=TLCYMGmwxlm77A6hkqIfOvum7+f6XT0qmB2Gb20v754=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UuxvkdSzOUOEOrGObvYmODlSeFuXLTt9h0PWXfoLBYNxAbIIL9f/oVsDI/1noonHRcVLchmJLlKyk7tvRba0lj8gZG6N11PuR+uVDcJ0VzByYlLq5NwTR3lcmRoInJEJJkxtEojyF83pEruifkVts2kkFdG2PIpzcEGL1fBZtDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=ZhX3ZqAf; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1722334311;
	bh=+Nr7Lad5gRaYdovqaCtrI45f0nfllUhBeYqWiY25QUM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZhX3ZqAfd8OI1ErtC/ySu0Q7ZbVzcQJoXI8jMRflMQW1vRC+w1hJHO0LFSKo8eogI
	 50LnjFV0jDWa8b4SD8Bb86JQ8SxcTXBJhWfaWFcz12cy+IQehx979KBoPbDo69aUFm
	 qaCPNyqXPfJzBSilX2d1HmCshe6loGi+AY8xAgwksoX4HdBTxP2Zy/k6/o1S2xOaL/
	 lKw8amzNf+rgtN8xi5fYg8TLhOGN2BuzKymJ4l42332I9aBkDTG0irihVrSgERaogk
	 dyihEOylGLYnOcVCWplgOj/HW7ieHCaDpVKvg9F/stUT4iqGIXhP57UYBKHBRBRyG5
	 2Au8H2SABteIA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WY9xg3gWHz4x3d;
	Tue, 30 Jul 2024 20:11:51 +1000 (AEST)
Date: Tue, 30 Jul 2024 20:11:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the kvm tree
Message-ID: <20240730201150.3090e64d@canb.auug.org.au>
In-Reply-To: <20240717155930.788976bc@canb.auug.org.au>
References: <20240717155930.788976bc@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mveM+ILdJ8gIOasG1GFKSR_";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/mveM+ILdJ8gIOasG1GFKSR_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 17 Jul 2024 15:59:30 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
\> After merging the kvm tree, today's linux-next build (htmldocs) produced
> this warning:
>=20
> Documentation/virt/kvm/api.rst:6371: WARNING: Title underline too short.
>=20
> 4.143 KVM_PRE_FAULT_MEMORY
> ------------------------
>=20
> Introduced by commit
>=20
>   9aed7a6c0b59 ("KVM: Document KVM_PRE_FAULT_MEMORY ioctl")

I am still seeing this warning.

--=20
Cheers,
Stephen Rothwell

--Sig_/mveM+ILdJ8gIOasG1GFKSR_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmaovGYACgkQAVBC80lX
0Gw4Vwf/Q97nkllGFADGA3Xzbd8OKEpLl2I3ZrI9Os9trtJNjGbwW364pCoKa8ZA
3QofMFP0j8ZJOdu/wv++ItFx0Z4Duyj1omkDn6iSZlFY1m0nTEzGGRo6RgzoNNRI
N49eb+rpb1JEhL878cVBLHTrZraizGQReXlWXlqwBemFMJrgVcdDGL3FXwKKMvNC
NU61AKrziUPmEiiNy+VpA4gRhVc8gDzkAu5SnmytSAfBANK+EeE3C3PE9vrkKUM1
Zflk+TK8N3y5qOFs6ga/1mnOealQju5rtFBWOB5TWDB07MVWGXYXw0pAt/LyiHmr
Jo+KJDwdkPN6W3JK2VPkPrpX8F4upQ==
=DpNs
-----END PGP SIGNATURE-----

--Sig_/mveM+ILdJ8gIOasG1GFKSR_--

