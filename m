Return-Path: <kvm+bounces-29815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE459B24D1
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 07:03:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A17F01F219E0
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4933418D627;
	Mon, 28 Oct 2024 06:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="lokTkadu"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9376152E1C;
	Mon, 28 Oct 2024 06:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730095397; cv=none; b=D97PC/yX+cMLi/Jp5+nkWFZHgBVfAFP8icJQytnWQi2nBl/p7iIslQZS+8hPqzzs+QLYG6jB5P7dJY8JluKZUQWX2bt67bIsAsvrFkjTGR6K7GxPF3cK0dZVQRj10JlhVTnClB8L3uvvzruuNimf5yJHNWeghn/mfF77g7/ddho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730095397; c=relaxed/simple;
	bh=TI3ksAMTpWD8gOlvvcnQztCLvbbDM0zXwV43Wxs/9vc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Mju+VQ07Cb4fhtSCGSKVUJfqc33Aeo3u19vW48ThfaET5VvpHvwu89nplx+03XuU1FlvEdswxRdCdS4mCmVP1lB3FLpZBTvdrYduYCvIG3DpZYyFcc19efxAyFsCwSWVMG1/aGeA6pzXUu+ZXRiC+LokCv6r7ObdGh+W8hCqDis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=lokTkadu; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1730095391;
	bh=r5CGirt+k28THwHiOtdhQFTAzLSz32aIval60x2/fnI=;
	h=Date:From:To:Cc:Subject:From;
	b=lokTkadufk+xTd5oxYvUiO8Ho4ihlP94oIyUJbG+YFsuhWnyQC9LVLRxlp/yXhbfu
	 rVvlXoMILLVtigCFD0ToiltB3WRnJThJRRtMWT3ed5UVGZ1EaJ2WnTooEofxHn+34d
	 246BFJwibKxw6ROf+qo5HRswsQjRaquFYcwhidRl3xiW410nyJovA5wyF6lv3mu6R/
	 lp/ue2NpITH3Mof+2zEQyVgdoWuD2izMkG/7yOWKRE3M5iHKa9Af3O24t0rRTTuTUn
	 TTc1cY8hcIXyHVDRcx1ANQQ2dXbemXqcAjgh8jSbt/Mi1qDOCbXa6/R43LzXxCd13N
	 +GENtMtnSDqlw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XcN996fmYz4wcl;
	Mon, 28 Oct 2024 17:03:09 +1100 (AEDT)
Date: Mon, 28 Oct 2024 17:03:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, Yang
 Shi <yang@os.amperecomputing.com>
Subject: linux-next: manual merge of the kvm tree with the arm64 tree
Message-ID: <20241028170310.3051da53@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SoGIVsEPFh=qBQZQubuD=DY";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/SoGIVsEPFh=qBQZQubuD=DY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/arm64/kvm/guest.c

between commit:

  25c17c4b55de ("hugetlb: arm64: add mte support")

from the arm64 tree and commit:

  570d666c11af ("KVM: arm64: Use __gfn_to_page() when copying MTE tags to/f=
rom userspace")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/arm64/kvm/guest.c
index e738a353b20e,4cd7ffa76794..000000000000
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@@ -1051,13 -1051,11 +1051,12 @@@ int kvm_vm_ioctl_mte_copy_tags(struct k
  	}
 =20
  	while (length > 0) {
- 		kvm_pfn_t pfn =3D gfn_to_pfn_prot(kvm, gfn, write, NULL);
+ 		struct page *page =3D __gfn_to_page(kvm, gfn, write);
  		void *maddr;
  		unsigned long num_tags;
- 		struct page *page;
 +		struct folio *folio;
 =20
- 		if (is_error_noslot_pfn(pfn)) {
+ 		if (!page) {
  			ret =3D -EFAULT;
  			goto out;
  		}
@@@ -1099,12 -1090,8 +1097,12 @@@
  			/* uaccess failed, don't leave stale tags */
  			if (num_tags !=3D MTE_GRANULES_PER_PAGE)
  				mte_clear_page_tags(maddr);
 -			set_page_mte_tagged(page);
 +			if (folio_test_hugetlb(folio))
 +				folio_set_hugetlb_mte_tagged(folio);
 +			else
 +				set_page_mte_tagged(page);
 +
- 			kvm_release_pfn_dirty(pfn);
+ 			kvm_release_page_dirty(page);
  		}
 =20
  		if (num_tags !=3D MTE_GRANULES_PER_PAGE) {

--Sig_/SoGIVsEPFh=qBQZQubuD=DY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmcfKR4ACgkQAVBC80lX
0GyNaAf3fOZRAdtjm1v/S4cgiyVo3XKlUSRVdk0AE6B4/IveFjqZ4G0a26tDUhJO
BivPci/A4XZypbG7We0hNmgBuEhdBgley3XrhQJWwWMd3ye32zrRKEzUj9WgLhBP
VVVThYO2MpeV0J6Zm00xl5j3dqjWOFb29OmXpnLhCZqR+m+KIXRhY0UsCpEtfnxD
BpCE/xncVQEBsz1kCMeYin1FuY0AtyPPX4dNNIA+2cNFLAHxeqUHGHkcQrLRFY+e
eUXsACHgZU0RTd69MWWDO56GIL7RHn5PNFjeruLjyCn8L47n7jeQM+Dnq/AgvJS6
rMrKHkF0O+FvpFX5GBsLmZknL5Lh
=xyTl
-----END PGP SIGNATURE-----

--Sig_/SoGIVsEPFh=qBQZQubuD=DY--

