Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6C23B3C37
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 07:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhFYF0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 01:26:36 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55485 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233133AbhFYF0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 01:26:35 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GB55n6sXKz9sT6;
        Fri, 25 Jun 2021 15:24:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624598654;
        bh=Zp3z90qF7a58nx5/paNfizx5wb5txzLsiWbTxfjPssc=;
        h=Date:From:To:Cc:Subject:From;
        b=iFavLbji2HMdUGx1o3Fmi0LENvDUQFTJHzwBrUVG9KT4Cf8vQjQmCrZJnzLpc0DBX
         zW3pKzxBBAx3arBQAegX+om1ld+FYA1Y/z4X/tjMAOa5WdLjDXa+ZE4DHEku0Mvoqv
         9qwyv1KX+UUBmJVdHa+Y6H7Hrv4oux0EtInM8ZOUbNgPmLl8odSuxV0feW4JEakkp1
         UhPKCyqJXOg+B4uUc5hn4iOdb8VcQPQO+BRplt19GZucDLuX9ALYBKTuUWk2vCARLm
         ffEGXxwnpYETBapWnBCgVijhIGbBYAPnVGMs1OouQQAhx4GkEykDZlmj4zNvjNMOGT
         WKERZ0w2Rq2+A==
Date:   Fri, 25 Jun 2021 15:24:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20210625152412.11924d50@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/id3G_mYGCmp0nVq7PpI6QaM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/id3G_mYGCmp0nVq7PpI6QaM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  tools/testing/selftests/kvm/include/x86_64/processor.h

between commit:

  ef6a74b2e55e ("KVM: sefltests: Add x86-64 test to verify MMU reacts to CP=
UID updates")

from the kvm tree and commit:

  75275d7fbef4 ("KVM: selftests: Introduce UCALL_UNHANDLED for unhandled ve=
ctor reporting")

from the kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/kvm/include/x86_64/processor.h
index 6d27a5435971,92a62c6999bc..000000000000
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@@ -55,11 -53,6 +55,9 @@@
  #define CPUID_PKU		(1ul << 3)
  #define CPUID_LA57		(1ul << 16)
 =20
 +/* CPUID.0x8000_0001.EDX */
 +#define CPUID_GBPAGES		(1ul << 26)
 +
- #define UNEXPECTED_VECTOR_PORT 0xfff0u
-=20
  /* General Registers in 64-Bit Mode */
  struct gpr64_regs {
  	u64 rax;
@@@ -396,13 -389,9 +394,13 @@@ struct ex_regs=20
 =20
  void vm_init_descriptor_tables(struct kvm_vm *vm);
  void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
- void vm_handle_exception(struct kvm_vm *vm, int vector,
+ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
  			void (*handler)(struct ex_regs *));
 =20
 +uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t =
vaddr);
 +void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vadd=
r,
 +			     uint64_t pte);
 +
  /*
   * set_cpuid() - overwrites a matching cpuid entry with the provided valu=
e.
   *		 matches based on ent->function && ent->index. returns true

--Sig_/id3G_mYGCmp0nVq7PpI6QaM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDVaHwACgkQAVBC80lX
0GxwGggAj9aYiCGLhKwt4HasTRtwkzwInvP6BK5UfFN9u6/Oaez+JrJFeOU7c7Kg
oc/8TRjI+XcCtmmRewZkNOM9zVIJL9FgES3cMPFOkdPEN1HptZ47arXH71dwAm2k
jgZ/ixUjNdEEvGdXEI4j+Pk6YER53QDYyfP+Qaymhf1GibgVK2l78BYqP0E4WYlL
wLE0+5PjWNgypW9eqjXywwwTuErHtVOno9XFt7YR95FtZcToKIahegOBTg1BvlZV
bn3QQGoht8djJbEn4h5qPrjyzl+1lCPVPZaBNQemR+dvEjHBT6N1O8r3mpnKgbqz
yPruy2RcfCi34kQNFBbcUiTRTiyAog==
=WHdn
-----END PGP SIGNATURE-----

--Sig_/id3G_mYGCmp0nVq7PpI6QaM--
