Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E232C2DDD0C
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 03:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbgLRCsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 21:48:33 -0500
Received: from ozlabs.org ([203.11.71.1]:57001 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgLRCsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 21:48:32 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CxtZZ1Hvjz9sWR;
        Fri, 18 Dec 2020 13:47:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1608259670;
        bh=9kLtd9vZRVb0Bzbu/us9QjmM3pXtlm84GlIUkd9FX7o=;
        h=Date:From:To:Cc:Subject:From;
        b=uZfdmiUHzYNu+cxFXGM/P0qEivh5ZpvXsloSwyFWIMSbpIhK6zxaX8EZieGJDEksM
         eZSsQljpZRXskqU6qgGot0dRN+rZSFhNzosAMbGd9x2Dc7BxcRxGfZoNe8Gj61Twwc
         jXBKc14aEZmSJor0sPWU+58J8/G5YTSGQLnplmcO7ASQs42cgjgqbuRPRFLV8SYHmb
         3O73EwWUYWRT4KJ69RbDHKE86SoObvbIQ6EkjFKcwzB3XxfECZeWG9ECiNwpX4ViCj
         HWwEFfs0UofEXtaGj5dlfAGhvEd8qjrXvat1GmGETbraYP7IU7P5a6CBufanmBKGaR
         kv4mrrNk5aDoA==
Date:   Fri, 18 Dec 2020 13:47:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: linux-next: manual merge of the kvm tree with the arm64-fixes tree
Message-ID: <20201218134739.45973671@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PJC12DwrcG=i=a+srC9bCTG";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/PJC12DwrcG=i=a+srC9bCTG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/arm64/include/asm/kvm_asm.h

between commit:

  9fd339a45be5 ("arm64: Work around broken GCC 4.9 handling of "S" constrai=
nt")

from the arm64-fixes tree and commit:

  b881cdce77b4 ("KVM: arm64: Allocate hyp vectors statically")

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

diff --cc arch/arm64/include/asm/kvm_asm.h
index 8e5fa28b78c2,7ccf770c53d9..000000000000
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@@ -198,14 -199,6 +199,12 @@@ extern void __vgic_v3_init_lrs(void)
 =20
  extern u32 __kvm_get_mdcr_el2(void);
 =20
- extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
-=20
 +#if defined(GCC_VERSION) && GCC_VERSION < 50000
 +#define SYM_CONSTRAINT	"i"
 +#else
 +#define SYM_CONSTRAINT	"S"
 +#endif
 +
  /*
   * Obtain the PC-relative address of a kernel symbol
   * s: symbol

--Sig_/PJC12DwrcG=i=a+srC9bCTG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/cGEsACgkQAVBC80lX
0Gx/ewf9HzAAb5ayqTx0QmzpaUCw+K/jRogXkmCPyLKF5SVys5WDfnEVEBUi6U37
s9HIieOp9sHY2OixrIzDhc86zNhr0WbA/r91JWzv4wkdXVCe4vzGH+9a5HyxhRtK
lnAT5kaJGRmIeHPv6jX6ZmJxLBG7Fq4Z25hNrHuBsw9aacdPKlLYLL9lkNDOY/MH
Hg9TLOHIaGhMyOAuDbNeUGd0vM5/XpOaI8FNyylZkXH2srwLghmFhZ2cfQUEcrT2
LiUOscu9nCMKjokmnLOgcirWWhD9JZk7fapS87+T1RxlXV2pjvYpUN2gfsCLxX5v
tyeL9xrWh1ACITdmkkaJfWUAmY0mng==
=aBYp
-----END PGP SIGNATURE-----

--Sig_/PJC12DwrcG=i=a+srC9bCTG--
