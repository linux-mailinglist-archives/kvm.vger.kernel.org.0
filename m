Return-Path: <kvm+bounces-21764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BE29335FA
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 06:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B7D6283E60
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 04:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08488B67F;
	Wed, 17 Jul 2024 04:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="kwzNtuyw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995C628;
	Wed, 17 Jul 2024 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721189797; cv=none; b=ZzdVk+w3y4EtjxVOml0AtcUjaZINOgnKxwdpzjc/kwDxH+MGlbjgvNdXzW/zuvoNHEpPrDvpLBf/oTzMEH/a6DJDCVv2NDa7xzS7Db3zLrw0/XNDnYOXUXnLjus5ZsdedPXepZFk2mxI4ZlA30PHGEdPlYF6Kux07dztHeI50lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721189797; c=relaxed/simple;
	bh=fckreYchgkphuu384WYXYxS+MYhEvPLE+NKAoNBY48Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWQtKyA0hUgGb007mvIFBSg3NBQ8zpWmTCZ/IqukWbCUtKQbHecPTlRYeA9cXVfLQ6V7nZihS1v8V0QuMYFaqtkCAYOdpCBh7gXBxKjfqTffUQ+t8IPujxBo33ut2j32idtbuy0eJVmVqYV8rrUhEu/XycXQ484FrHO6UKJ/SSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=kwzNtuyw; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1721189791;
	bh=kWZGtwpQXLb/d7BQ2+ONvviZastDeWEFSn6QoGUOCHg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kwzNtuywCXYnQHfpTyauH8J3bHbKn1c0Yoy9YS+XcC+zEViMnTBnOkVZNkYtfoQcW
	 hn6CWEyjTlQ+sdt0sun0zI1UmJep+7f8a9ZWfrI+f0rsJgV9vVTmo1XHTnsQsBE0ah
	 JSwJ2f6TszgoBDM9LpWdqLuC6KJRzzj1M7ArK99MremLYtRSn3Sbzgrgq1aBvlXGIa
	 AbfIJQ7LreQ1yZzGZfLvz+Xt9qd/ZDdwnOAPRphx5o8y13lO/U4/UoYvu9FgGCuJ5X
	 OH9bL2jpu8YDSzR7xMDIh+UP8QQ6lZ1Rhp9XEC0j4rCeRM+wdocwH7pIuNPTjy7Mct
	 xvugo8fzL+EVg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WP2gf22pMz4w2R;
	Wed, 17 Jul 2024 14:16:30 +1000 (AEST)
Date: Wed, 17 Jul 2024 14:16:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Brown <broonie@kernel.org>, Anup Patel <anup@brainfault.org>, Ian
 Rogers <irogers@google.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>, Shenlin
 Liang <liangshenlin@eswincomputing.com>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-riscv tree with the perf
 tree
Message-ID: <20240717141629.08a04e4e@canb.auug.org.au>
In-Reply-To: <Zn8HeRRX3JV2IcxQ@sirena.org.uk>
References: <Zn8HeRRX3JV2IcxQ@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WdmZLCz=kDcfvAjCp36l3U8";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/WdmZLCz=kDcfvAjCp36l3U8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 28 Jun 2024 19:56:57 +0100 Mark Brown <broonie@kernel.org> wrote:
>
> Today's linux-next merge of the kvm-riscv tree got a conflict in:
>=20
>   tools/perf/arch/riscv/util/Build
>=20
> between commit:
>=20
>   e467705a9fb37 ("perf util: Make util its own library")
>=20
> from the perf tree and commit:
>=20
>   da7b1b525e972 ("perf kvm/riscv: Port perf kvm stat to RISC-V")
>=20
> from the kvm-riscv tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc tools/perf/arch/riscv/util/Build
> index 65ec3c66a3754,d72b04f8d32bb..0000000000000
> --- a/tools/perf/arch/riscv/util/Build
> +++ b/tools/perf/arch/riscv/util/Build
> @@@ -1,5 -1,6 +1,6 @@@
>  -perf-y +=3D perf_regs.o
>  -perf-y +=3D header.o
>  +perf-util-y +=3D perf_regs.o
>  +perf-util-y +=3D header.o
>  =20
>  -perf-$(CONFIG_LIBTRACEEVENT) +=3D kvm-stat.o
>  -perf-$(CONFIG_DWARF) +=3D dwarf-regs.o
>  -perf-$(CONFIG_LIBDW_DWARF_UNWIND) +=3D unwind-libdw.o
> ++perf-util-$(CONFIG_LIBTRACEEVENT) +=3D kvm-stat.o
>  +perf-util-$(CONFIG_DWARF) +=3D dwarf-regs.o
>  +perf-util-$(CONFIG_LIBDW_DWARF_UNWIND) +=3D unwind-libdw.o

This is now a conflict between the kvm tree ad Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/WdmZLCz=kDcfvAjCp36l3U8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmaXRZ0ACgkQAVBC80lX
0GzQ3Af8COd42mC9I9csW815+7a17cR6NyhRWSuvPdBMJWADuNe9cLchYHB8wccu
IBmqwgDxTewa7YDVXx7caCOfZ0sGKHdQvPm7lcvNUJTyLLbzA44q3ZRxXlKpRNsi
u5dKKZP8TYHLszbe+zP4XmX6K2eZ9h4NAs00GmS/ALYdK28v+eTMdDa8Zpv1WIP8
yluJH8MmxE9r69gu094FQLFFpynLV4QBR8CIMH6KX13yFvhIEbaf5uUsT9gYZzZJ
AUTQ4zJCv7LKPYpMnhk5PUlUn10f0LeLW3k6UrYuMROZa8EqZ5nFoDKbKZqNumPT
fRAXGI5GOISbvJu7lsT4z36wwOL6iA==
=IIZ0
-----END PGP SIGNATURE-----

--Sig_/WdmZLCz=kDcfvAjCp36l3U8--

