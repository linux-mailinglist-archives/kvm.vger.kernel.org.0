Return-Path: <kvm+bounces-17561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 234DA8C7F04
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:42:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1587B21F34
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 23:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE312D051;
	Thu, 16 May 2024 23:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="ojWbBU0O"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C412C68C;
	Thu, 16 May 2024 23:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715902946; cv=none; b=EFZ1giD3JNo4B7pGx8ILQP1IQeRibCO8O/DnsiOyNDb2BmGQQPSWKLFH5vqQ6WyEdt1xLSW6BaC2+w+JPefI62Id72muqmZpi+wtdRIhHtxwAwJCh79zJSEnYvgcyyCTPjdF8epi3JxGgD1AXK8P8dwUbRdf5AdSETyUzXt4Z6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715902946; c=relaxed/simple;
	bh=zee7hHQpdOGP25NMSwoAHBhZF/iEgJc6wzU+KTUZfdY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LEXqv8+HvVjq0ODoEHB6NLxcQoo9Z5dkec2YG1h2ufAr0jHDwWwXRk1LQ3ebz+FGkMu/QtoKViRXlHSEIEc0cUOur4AzBzaNR8Rr4HFByr8A0hj8lx/w3Vs4rIs5Y3MMIYUj82/Q6596nFUY6FtcvlJQfCjNImW0W0iK4Oo22y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=ojWbBU0O; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1715902940;
	bh=XSBc8fMaGGaZPXxCyzrlLuxfz7M3VRz50PHtt0uz3jw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ojWbBU0OOadLF9W6zwZSKJqNs+qQWVf5jYFvGV99pevivf81EmEIq8CHAsWs47zGI
	 bEIeU5O8qAw2d7L+UHNrkPYTwTBxZpR4bSMmwfvgRl7YXPRRi5zqpFg1DgNXWhHO1C
	 SQyUP5ZE6D91caUVya1WsmvHq3jL/l8f7zbBLxfEP11CTn4qFLr5BIZjZ+BvxER2oE
	 lgMjgWQiQ/nMNA2L75Dj5gWF5UK/76qXlX5tMcYtQwnT5ex0G4ftrZlmznfvTr96S4
	 fbvmXeKgqijqzyrKU8x2R+FGK1B559462dhBuerhIO9TOeJSkSXVUhggmh692DKr0e
	 W11pnD5XeDJNA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VgRTR70f5z4wbr;
	Fri, 17 May 2024 09:42:19 +1000 (AEST)
Date: Fri, 17 May 2024 09:42:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, Bibo Mao
 <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: linux-next: manual merge of the kvm tree with the loongarch
 tree
Message-ID: <20240517094219.6a4f618a@canb.auug.org.au>
In-Reply-To: <20240515125404.5ffbaada@canb.auug.org.au>
References: <20240515125404.5ffbaada@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/o=RVMbxBToyvQbtEwVMaoE1";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/o=RVMbxBToyvQbtEwVMaoE1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 15 May 2024 12:54:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>   arch/loongarch/kernel/irq.c
>=20
> between commit:
>=20
>   5685d7fcb55f ("LoongArch: Give a chance to build with !CONFIG_SMP")
>=20
> from the loongarch tree and commit:
>=20
>   316863cb62fe ("LoongArch/smp: Refine some ipi functions on LoongArch pl=
atform")
>=20
> from the kvm tree.
>=20
> I fixed it up (the latter removed a function that was made protected by
> CONFIG_SMP in the former - I just removed it) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.

This is now a conflict between the loongarch tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/o=RVMbxBToyvQbtEwVMaoE1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmZGmdsACgkQAVBC80lX
0GyYnggAoHkAcH1yudrcWWYykKNdOiAPmChnPhT34hThPHbuuo2Eo6V+OC7Ks6eO
F2v0+KrTyZJYRjxAHSeEDuT1SlZxax9hRYOH2JV1ugK2HXeAuxQY4u3HTfiIIP28
G4F3KLZpQfrFsoAkhfb/8wDyB/YvohpsiBfVEkerVZoKqNQUGUhODIa0gPvSSZLc
3vlXNIJwKaNigl2FDGtcsLMmZTNce9F/qo4ya2S99jtYlMaxRcz1BTk7GdmZcKPx
TN1AuGrQXDcWmutcc/0Rc2zFc6InBu0JOZDXLCrLWuiAZcrFLydrGknIXomraF1O
edm8Ww9lQNy2dS6auN9I7ocR+6FPZQ==
=Twam
-----END PGP SIGNATURE-----

--Sig_/o=RVMbxBToyvQbtEwVMaoE1--

