Return-Path: <kvm+bounces-34568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 499CEA01BA4
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 20:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBEF6162BF2
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 19:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852F81CDFAE;
	Sun,  5 Jan 2025 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="SgkiQC0j"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97B143725;
	Sun,  5 Jan 2025 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736106157; cv=none; b=p/2wG1N9lUfyzJovIrvJM8TaDKBMrOdOqWQYiVDNWytJFpuTi1DLQrYavriZt19Ew5YKs3inGgfzrxsMsKiqUptfcTHE9us195yIhIEkFn8WOac8VdPt7lqYpjIOyN/RXfQquQbZa2/wHFVLMlzZUgRMtXIHQhjrDA7tOLl5gi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736106157; c=relaxed/simple;
	bh=oza7v3yHsqpHOHQHaI2+tZYj5ycQRLiyseScSMk1/G4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=oAIWltmuFRd5DctzgBKNYWb816qbgJrMakcrUgWY7GlyW8xBUPEXLOO1h3B8PX85up3pIg9kpNxWvChLuyjJhQP7P6sGrCSbIzzXKsAHaanjd8aMyYTP3UTJuOBIiT/NjJi+j9cB3F9EDLBh8AAngTKJagwgOKhW+csOx5iVzh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=SgkiQC0j; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1736106146;
	bh=XVyMAhYAccp+Zqo59dhZgtuYbzrnE8vfKpM26LAfmTc=;
	h=Date:From:To:Cc:Subject:From;
	b=SgkiQC0jF5yzRFKKHucbZ7FaqPIkj/mRkGer2/X6iWca67JuhUn82UZjpGXu7PtLP
	 xE0R2pda4w7b36N1arjVUHnEcQfIcT8XXua5Ko2U7uvfvBvt5SOS9QmSF9qJT2edDl
	 Xej6T2AhChJZ7q2hsK1QTj6LLZ3gfroHZ1DeANoZUPpyJ8N/h+qZR5YR5zbe1O7hf8
	 /l/vTiKSoWSWcq+1jq3aseERgSuVp8D+ieYAtJVwQFhRvuax15MPVtYsDOugEvDR+R
	 mdtwmbn+ckWobpW2+yjF4SounN8+pmy0XxsEZxSnjrzlHdiuQ1vYS2rQ1papMMxeRu
	 eq15sLWqyZY1Q==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4YR74f47Ppz4wvc;
	Mon,  6 Jan 2025 06:42:26 +1100 (AEDT)
Date: Mon, 6 Jan 2025 06:42:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, KVM <kvm@vger.kernel.org>, S390
 <linux-s390@vger.kernel.org>
Cc: Christoph Schlameuss <schlameuss@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvms390-fixes tree
Message-ID: <20250106064232.3c34fdb1@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NbXAMPvXk4m27Aklu6opAl3";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/NbXAMPvXk4m27Aklu6opAl3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  6c2b70cc4887 ("selftests: kvm: s390: Streamline uc_skey test to issue isk=
e after sske")

Fixes tag

  Fixes: 7d900f8ac191 ("selftests: kvm: s390: Add uc_skey VM test case")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 0185fbc6a2d3 ("KVM: s390: selftests: Add uc_skey VM test case")

--=20
Cheers,
Stephen Rothwell

--Sig_/NbXAMPvXk4m27Aklu6opAl3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmd64KgACgkQAVBC80lX
0Gxkfwf/Sc1PKm60m0A97vGq54UbmWNb0qRQZ4bc3b2UfGzEVGGQ4PdDEoTVyFQZ
rXvnJPnkQTWfWUo9i6FsoWLd2Do4r1cdhny+tE+jQS2tKnN8XDpJ+WZ7/+v6O7+N
4OEF6Wte63Csp6+J8ioieuNwWqmFS4YZi2TW8WxrsIMxaiKbsrWgQfKKBgX7waRt
INGizVYwyBYAB/wbrAxkOgu09coRLTVguxGT6zSfuNRRSiNNywz0yQcyWVNwLtoF
t8RQL6VDy4jcvM3eXL3Ni3vz9BldHqx5FKfGjSsLc1PC0NFOAPI1HMJhSMvziQxK
mh4FsHCcbtVYtiljP/oseJ2GI41KDA==
=xvST
-----END PGP SIGNATURE-----

--Sig_/NbXAMPvXk4m27Aklu6opAl3--

