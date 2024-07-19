Return-Path: <kvm+bounces-21914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8B09372D4
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 05:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B132BB21842
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 03:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2039424A08;
	Fri, 19 Jul 2024 03:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="XmA3hTTX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E93479FE;
	Fri, 19 Jul 2024 03:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721360696; cv=none; b=da6atuv43eUteBjuJ6a9zatL2zVmvYZIcdXhRM1nOF45J3vyDJWhlPflnuG2Z/d/CHShjBRvOxXVMjdWGoSqN97JO2CxT13nSITXsHLeITU6Zw36zwYUPaReilvN68xrHVZkU8JDI0e7Bh44tIjZT7rEtHtwL3U+cG9dxI3Aia8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721360696; c=relaxed/simple;
	bh=uMVBID/u+V9lpkwKU9qS/Jvtup/QMoIKyI2JqwrWv4k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ocb0vvyUp+p6EgO5afd7JEqzZY+TktPlHjwmMusDx7HZAggduwMck3Us7tq65NTj4YrLHlOW4BUF2u+nK8F9R4ZRky8Hx+/GNxuG/lnEpxhLAFjSfTL4+s8AgmEI1VOIeIizOyNso7eFLj2sPDPOv3QrPcku6yBS2q8RFPEWhb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=XmA3hTTX; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1721360687;
	bh=lYQYhT9K+g5ZB8u0Won7Mnms04sbllRofab/g/UFdfI=;
	h=Date:From:To:Cc:Subject:From;
	b=XmA3hTTXHYEv3Wj9rsz1NTBsbT6x2BEok7gz3GH+HXwkbEpVmuY9RzfdbStPqslqP
	 0osAs+oftLvXYdWc8WYkLo6XJnsVv2d7FApHS/mEx4zZdhry/tbk5uYA34Mztym8yv
	 orEcUdfAk6+DtUyqKqMShZZ+1CPLyI6tn+/WDxLna0wjlUsflPjn0DVwxLndrSQ9eh
	 AyIHztobwhOzyt9xYt8ZjbA2AkESpP+JGuKhy919vlaUM+IOCEO9/RTnS6/FfJe+mP
	 SkQliGyMS0XmzCBpJS2zKunPeYA3sQbxquCrDbQ45iHW6UrVLes/FuIW2Rgp52T557
	 xM+1HOq8p61Kg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WQFt71MM7z4wxk;
	Fri, 19 Jul 2024 13:44:47 +1000 (AEST)
Date: Fri, 19 Jul 2024 13:44:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the kvm-x86 tree
Message-ID: <20240719134446.440ad28c@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZDHYv_RFwqqcs8H.cs3g.5s";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/ZDHYv_RFwqqcs8H.cs3g.5s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in the kvm-fixes tree as different commits
(but the same patches):

  2a2cc315c0ab ("KVM: x86: Introduce kvm_x86_call() to simplify static call=
s of kvm_x86_ops")
  b528de209c85 ("KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls =
of kvm_pmu_ops")

--=20
Cheers,
Stephen Rothwell

--Sig_/ZDHYv_RFwqqcs8H.cs3g.5s
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmaZ4S4ACgkQAVBC80lX
0GyvvQf+OU5yj4b4in0/5y41M/4Dyuh5SAtCtgnfTET3DuDL+/Hw84LKGwOLTld9
s/cVUZcnqVJuIB4McMqXctbSmO7iWm6E0w2jD5EIvwjGU44jWKUdv3RSEFq4gHie
IsVNSBEbpFZ8ackU6MfXVk1uBnVWVbN0WMVdsSYZLGQvGCWLjBYb2OK8IUH8v+AM
TBSh5Zr7HOL3IDBidZ6iNVVlDniLAmu1LkF7yuOG/bntKky89zds5qcjOmkhfqFw
V1WlVvKF2XUxfndu0MJFbuRmRymis4INJnH16LXMdZw6t6YPQUtZUcapTJA9gi5L
mw9CO7hJPgrl4aCPa9L1ZXfKUXdjKQ==
=hIg8
-----END PGP SIGNATURE-----

--Sig_/ZDHYv_RFwqqcs8H.cs3g.5s--

