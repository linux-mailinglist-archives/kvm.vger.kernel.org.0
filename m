Return-Path: <kvm+bounces-14375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5AE8A243E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 346531F2373A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D54A1BC3C;
	Fri, 12 Apr 2024 03:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="WeOSneIB"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE83199D9;
	Fri, 12 Apr 2024 03:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712891698; cv=none; b=OoyWpVzCc+Btcr5+bocYz5kqU5SWmCHoyipDuTRsuxaloXEde4g9TCY7EzVt1YUzphF7VtdRGiCoAKUhnCK06eNE1HnTTVSrRR5DC9oaE9UOByFP8YvZxwl9Ka2behMH2s9BAHXVIKGuQILpA8T2n7SteALK1cL/GIVm/L+VuaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712891698; c=relaxed/simple;
	bh=GMSCKdtp7p5x5tKn0fvsWFlKFRuMmTOJXY3eOciD3LI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=pUg3hWwhnFxiSbGqz3x3XyMjaqfXzua2fybZ5NFuoHqFZQZ9y9p4cU16FrGqDWXKzamPjwj4vXzuqaSBzQ8dUUL1d57ke7x2zgGDHAeWJPG1rDYFhti7SNzVZxLM1fLzWZrEfp5W6xiCn9O/8VvjeQeLNWErM9mDYxYQ5HViyqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=WeOSneIB; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1712891691;
	bh=EY3WqoWVQVYhu6CX8mA3X80QuETTVo1FlNuaCnjkIEI=;
	h=Date:From:To:Cc:Subject:From;
	b=WeOSneIBpWl5HEVoW37Hhd4Oh891LmOTg4am5vxz4vGFE/H2ppo7Ai0uCK7nf3veB
	 MnGA0ZrABbEscv9fWrM+Chi7LzyJQNXDQ7vKCvcv7Xh+oSdD2Qu+rnWpfpUdbjeBPO
	 aem/qZbAM09Mj638suQEdlOfTkLW7zK8dDhQaKo7vEy01XFeCqRjuOwBr9gEDqpJJa
	 e0tanMd3TonJ3JZMVVM8zcYuw5kSOscyjPAEheRdMS+5cBXB2dWK1mC3iBWNTF5A1h
	 vZA3jylkhYRWc+xu5jKliDSUpwiAGcrrzH3p5v++BVeE3nB0NErqc4O7wN/CuBWYaB
	 pBzBp9caDZ9Qg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VG1rp6TzWz4wqM;
	Fri, 12 Apr 2024 13:14:50 +1000 (AEST)
Date: Fri, 12 Apr 2024 13:14:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm-x86 tree with the kvm tree
Message-ID: <20240412131448.4403df6a@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3N_WPBCBiQSNIeSEhY.ZcO9";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/3N_WPBCBiQSNIeSEhY.ZcO9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-x86 tree got a conflict in:

  arch/x86/kvm/svm/svm.c

between commit:

  605bbdc12bc8 ("KVM: SEV: store VMSA features in kvm_sev_info")

from the kvm tree and commit:

  c92be2fd8edf ("KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN v=
ia host save area")

from the kvm-x86 tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/svm/svm.c
index 0f3b59da0d4a,9aaf83c8d57d..000000000000
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@@ -1511,12 -1524,8 +1516,8 @@@ static void svm_prepare_switch_to_guest
  	 * or subsequent vmload of host save area.
  	 */
  	vmsave(sd->save_area_pa);
- 	if (sev_es_guest(vcpu->kvm)) {
- 		struct sev_es_save_area *hostsa;
- 		hostsa =3D (struct sev_es_save_area *)(page_address(sd->save_area) + 0x=
400);
-=20
- 		sev_es_prepare_switch_to_guest(svm, hostsa);
- 	}
+ 	if (sev_es_guest(vcpu->kvm))
 -		sev_es_prepare_switch_to_guest(sev_es_host_save_area(sd));
++		sev_es_prepare_switch_to_guest(svm, sev_es_host_save_area(sd));
 =20
  	if (tsc_scaling)
  		__svm_write_tsc_multiplier(vcpu->arch.tsc_scaling_ratio);

--Sig_/3N_WPBCBiQSNIeSEhY.ZcO9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmYYpygACgkQAVBC80lX
0GxBPwf/VFRBOWGuSGfmrscNLd6XvmE0R0vpMIqwr5pdezQfl130qO1JY1QoZiFj
rvYF7lsDnxpRWNG2uYw6to5xtj4JX+dGvy6qMPUdYCLCD5uYO6JzE0w/rOcXit05
zjcseqoGqo00wKRxSlj4vTflz4/Z6stt5HQnq8F1kqPuvQNpwAAxxgOa4XIgQzHP
7w3ojlToNlsDOR8/JYHE1cvKvCwG5cbgqjbxdeeE7moQBR/omoCE8Rl7zslH3Xar
/KgFryHn7kZJlNAvYQZcezZZIaV8dSygIa3brBD4bAzxjLt4LMk261ieW5ZOyS84
Cdfi4OkLQYUxK0pqQ0OIVTRoa4xlhw==
=AyeR
-----END PGP SIGNATURE-----

--Sig_/3N_WPBCBiQSNIeSEhY.ZcO9--

