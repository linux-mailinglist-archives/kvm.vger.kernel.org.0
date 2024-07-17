Return-Path: <kvm+bounces-21768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18AB093367E
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 07:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92AECB22C50
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42FD125AC;
	Wed, 17 Jul 2024 05:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="XAGXsWLX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C395FB64C;
	Wed, 17 Jul 2024 05:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721195979; cv=none; b=AyGnSivmE9vVETjkl6ECWWHODBM+1KP3lPt8z80Ly4oaezcUarZZv4VHIHzdhj7cwkoOfSZcaPA6pW912lPn2qV0SrKblnDgE+Dbd7q1UJWtTi74AiJ5qOH+eG1QrBppghja5Ato4st0phngSz4yLeBPbGR5So59Nn6o8SfR+0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721195979; c=relaxed/simple;
	bh=FM8EFwD2/TJ0falNpFW9BxiynwMFJ50kPUTGUJcqeU0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ASBYmXiNCKd7YEdY6jBjFCSlWNB3m2AIkOIZWX5W5dJSoqBdinzu1fmFFVisNcy3HpGTRXBQ3TRp2/kPQPSyi61Upxt0j2E1gEsQ86drbh99Nh0NgL5nx2pZcr7on65PA1ILLbfCJFsjw9PctGP7cecXyjBlKY7/nFAKLMmuo3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=XAGXsWLX; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1721195971;
	bh=RtnpywVCtDzY8pnLNUzM/4KaVEPjw8JEzLEZSpW7oW8=;
	h=Date:From:To:Cc:Subject:From;
	b=XAGXsWLXJ9l5cdx41GiYZOmBWVkJYEKG/UqjDSFrZYGnfxKuLO87WrfRDlsDF1mAN
	 Nu26IqN6rhZdmDjUQg7X5xP5ADk/15ov+nw9WSLt3XyaB5u0jrB6dhCa9Z/6miAZl+
	 SzzQ5kBidkrqSR890fVFr/vN0eSkkHvRaj7cmJbmldrU6ea7mp4kgiEqQ3JOr9YfEb
	 ySoaLrAO2pkGqkUcuRKaL0SaV40XUUBidNYIbOzXZKwoqGcZ7/qYHeHcOnrp2dCYNM
	 u3HZmQuH5y8UfPZtpOYHQd6PxodZfkGBekKpv2/ITetIjcGKUc3SqrRTaar02YOTFv
	 5b/fsIvbIzCxQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WP4yV53DTz4w2K;
	Wed, 17 Jul 2024 15:59:30 +1000 (AEST)
Date: Wed, 17 Jul 2024 15:59:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, KVM <kvm@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20240717155930.788976bc@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tXAYtBfsLPGBnTnfGEmMneL";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/tXAYtBfsLPGBnTnfGEmMneL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/api.rst:6371: WARNING: Title underline too short.

4.143 KVM_PRE_FAULT_MEMORY
------------------------

Introduced by commit

  9aed7a6c0b59 ("KVM: Document KVM_PRE_FAULT_MEMORY ioctl")

--=20
Cheers,
Stephen Rothwell

--Sig_/tXAYtBfsLPGBnTnfGEmMneL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmaXXcIACgkQAVBC80lX
0GwMxgf+JBWpQHW70TDlVR4KE/HVILsKqoJ99H1qvgHXNqBrnUZM5Yv3vAAWCWh2
wAphalOEpnUh4+yLgWBD9s/1zrWms4Mn4qCaOPHe6Fwsd1rxh8fgdVM8ZNurq5xk
muGwzL9m5kpR6YGCEQgXjC9zOchyT2fTWXmVbya/KHP6jUcn9cpryFaFiSdK1Ez8
baZVoOpo8kHfxkF7FQmkkN3gXNTeWjz9Y/sgtsATslr7Ni5vYbnj2WXzuXDpI6Sb
tWbWB7HmjqvNDHjA7IRgEkvRQ/jcYqvlo977y5wQwp9C2LmaunPCtUkyyEN/0t2Q
6/j6wKdikmjKlGs90STXzzOGZvqIrw==
=u6Ej
-----END PGP SIGNATURE-----

--Sig_/tXAYtBfsLPGBnTnfGEmMneL--

