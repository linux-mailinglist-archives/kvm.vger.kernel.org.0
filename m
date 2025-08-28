Return-Path: <kvm+bounces-56010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B63B39146
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 03:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 487311C21DFC
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 01:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0C523CF12;
	Thu, 28 Aug 2025 01:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="cOpgT0vg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB318A921;
	Thu, 28 Aug 2025 01:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756345932; cv=none; b=aQxa2pazz3+CnQgPg8LxRJxz3ALsRCJXcLBgLoxBJKZmCNEutgBpF5aZiW9kzcxzVRX79iC16FvNudH3+YX3pHLNU1feM9jQePFZcY+vP8mdfSioIdRLtTDgw8y3i2Jinqw1b7Qt+GM2YhDuAxOiU27y5cwHyhnyvfWHpKxA/eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756345932; c=relaxed/simple;
	bh=dxVMbtukpZtuIX4YUMRUUfAnD5vwgNh9C9/uAXuDN1U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=OTikYsSe2cEjREjomWgLKkF7IpRkhVn/OrFu2HfWmXNEnbkxRpkj7rRtCdDJS6HaepxbcK1kp/IS2Su53TDn6ZcpsUAfjKfskDWpnFazJlJxLQdcP4gJgyU4NPLpdzogyJD9K/fQKzY435k0RK521F/ROI8UWo3/1ZUG3vq+z/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=cOpgT0vg; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1756345919;
	bh=F39yMcjHEFpvtjRjRBSI4QvZlsA6G7xVDxZcBNCF4Us=;
	h=Date:From:To:Cc:Subject:From;
	b=cOpgT0vg/n1fZM5GL3zn9+JUVr//q7HX2sVcmRU4s09b8ksKMiJMhZ47JX3vcDDOu
	 b+pu1ksHUYYWpFrs6rRCqHLP9GdNTmXDC1/0gQfjhGNDKLn0CNtLRC1P7GfdenLCNR
	 8+E6adz5wljxsDTm1PCiiVS6W9d9lLCGYQaPnBUkt6h3DXnK3WFQlfaaBcG8s9I6In
	 lQzxpXahE60y5cJ06xTF353X8+KSYcK0++IIdXpoyCKCQohY4KkI7DZYD1LZZAvojw
	 niH67FXsYViNRr157Axt+Z7dd01a+hL4f4EdDBP8REirtzonWXRli1uHQXYH/d3Vl2
	 FO3gQqnb2yF+A==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4cC4C26h4Kz4wfs;
	Thu, 28 Aug 2025 11:51:58 +1000 (AEST)
Date: Thu, 28 Aug 2025 11:51:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Sean Christopherson
 <seanjc@google.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20250828115158.46901da7@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PR/896pPmtBOudSc/Yy5nsz";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/PR/896pPmtBOudSc/Yy5nsz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/Kconfig

between commit:

  28d11e4548b7 ("x86/fred: KVM: VMX: Always use FRED for IRQs when CONFIG_X=
86_FRED=3Dy")

from the tip tree and commit:

  924121eebddc ("KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff CO=
NFIG_KVM_INTEL_TDX=3Dy")

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

diff --cc arch/x86/kvm/Kconfig
index b92ef117f355,4e43923656d0..000000000000
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@@ -95,9 -96,6 +96,7 @@@ config KVM_SW_PROTECTED_V
  config KVM_INTEL
  	tristate "KVM for Intel (and compatible) processors support"
  	depends on KVM && IA32_FEAT_CTL
- 	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
- 	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 +	select X86_FRED if X86_64
  	help
  	  Provides support for KVM on processors equipped with Intel's VT
  	  extensions, a.k.a. Virtual Machine Extensions (VMX).

--Sig_/PR/896pPmtBOudSc/Yy5nsz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmivtj4ACgkQAVBC80lX
0Gzrmwf+PvlSMd7ecWwcYuqP/SEPp+06QOPy6t0n2KMJdSTsRbjG1FqA4v070MyW
4eDTwGn/7Tnb2Fsq418TuqhxocT/CxJ13dC+NQh34qWsvD6TLeBsVSph3j78CY37
ko3WGVe5bdM9sUfKPJTTN9+hsaxvoZ7tkUvukFwbSo8c79y+pPWQVnHFiqzYt34i
Qnixouv3NwSt9u6eUbBP8WrzSdDn014JTmcKJ7J9BRzOXc8KN8j5QH/rHGc+1nA4
lib1t+29s/ugTJ9Qdhy+8KOF+00h7ZVYMHNmyfFRVl5af47veM5oIlzbBvyLKjFc
r9RcsBcpDj3Eo3C10imRgc22IzaXYQ==
=1oY5
-----END PGP SIGNATURE-----

--Sig_/PR/896pPmtBOudSc/Yy5nsz--

