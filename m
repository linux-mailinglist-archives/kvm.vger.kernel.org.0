Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000EF2DCB25
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 03:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgLQC44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 21:56:56 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:59597 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgLQC44 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 21:56:56 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CxGpg5JCjz9sRR;
        Thu, 17 Dec 2020 13:56:11 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1608173773;
        bh=0BUN17/xDSq7+CWgU8wi0dZDg7QZRtEzB1WlEheKggE=;
        h=Date:From:To:Cc:Subject:From;
        b=TpWRTGPMExPzxK4g6VJFBkIPYYtyYT4sVp8ZeelQHmrO+qbYC7mvlB2fWDyd++g7k
         NQWfs75u66yPdiG8dTWmlqfSj0vmQt0SYH6dNZZXcUgiRjf03597lrr6HmScTzLG6b
         jdF8cQEPnVlA4XKrndHBSu1ozFroi5JlXplqHyM28V6SS4LsYV/W5s1NBqgiEGjpk/
         knO6reWL99Zo6oC0EKRMc8QeZim3R0VLRrYw9YmvBB4jv2B2N+m3K3glziFJ/P97wz
         P/+M5WCjpv5ZW072G9zJ8x4Yv9s/l88nKMONdppCsMxrgivTukK2WXByGn0RMXBZ3n
         9xmcNUdmuRO8g==
Date:   Thu, 17 Dec 2020 13:56:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Chen Zhou <chenzhou10@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20201217135609.6543533c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/m2GsJ3mUgdFxez.xofiN/.G";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/m2GsJ3mUgdFxez.xofiN/.G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/svm/svm.c

between commit:

  054409ab253d ("KVM: SVM: fix error return code in svm_create_vcpu()")

from Linus' tree and commit:

  add5e2f04541 ("KVM: SVM: Add support for the SEV-ES VMSA")

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

diff --cc arch/x86/kvm/svm/svm.c
index da7eb4aaf44f,941e5251e13f..000000000000
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@@ -1309,10 -1347,8 +1347,10 @@@ static int svm_create_vcpu(struct kvm_v
  		svm->avic_is_running =3D true;
 =20
  	svm->msrpm =3D svm_vcpu_alloc_msrpm();
 -	if (!svm->msrpm)
 +	if (!svm->msrpm) {
 +		err =3D -ENOMEM;
- 		goto error_free_vmcb_page;
+ 		goto error_free_vmsa_page;
 +	}
 =20
  	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 =20

--Sig_/m2GsJ3mUgdFxez.xofiN/.G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/ayMkACgkQAVBC80lX
0GyIkQf7BcLVgA0gSlM4vf1TYexJbBY0qpgPu2A2Uc7SJDkYqesPaW92MwR4DNI9
TLlzxnoMJrJutlUWHKbULGokRPIVMRcte4uG4zjG4TmFVirNdhhj7hLL08Ob0IpO
kxicci7tkXm68jMDmqJI3vMmdegPkBKpON9BFol3xwGov0IqYkn0O9zkXD62rEqz
v5HbALddFIKB4934gX4ng8u0503/QC2CLELpDmLk7+h+8lBdEwULTWVvDRodf7hv
Zg7l5HGrSs1GvdeFNDKlMflY+r+lJn4dTwshCamdFpleZzfsCp5XeQYFluVnNni5
WlL32AsrgYanF/KHxAPLcEPEd5bAxQ==
=569i
-----END PGP SIGNATURE-----

--Sig_/m2GsJ3mUgdFxez.xofiN/.G--
