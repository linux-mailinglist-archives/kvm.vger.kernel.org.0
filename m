Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FD11B35BF
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 05:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDVDwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 23:52:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45171 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgDVDwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 23:52:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 496RMf0jKKz9sSg;
        Wed, 22 Apr 2020 13:52:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587527535;
        bh=Ht2B9g7UeZlkPJ4YAiu9xxmmZjmqQOON7qrTD5NTcWU=;
        h=Date:From:To:Cc:Subject:From;
        b=hjOwoZL8NY5GqqQy3WlTAEVSC6Wg14/fHs9eTRiMvv/1VK+5tc6+n2MtPYDrOTElp
         CrAPYW15l3geQ8bIUqD/vs6PikvYN7C6TgQTKMgivh8VCyubg+hBHqO8MC8bL+KHbl
         dM8L/HOpBofi9+GBvhm2xPpLNuxOOPNNrJf+8Z6fywTu8RoQrj0rWeoHPceqwkjfr5
         qdp310u2SiyKsTrVGOrFv8ORtLZHIGRl40PkdiTDLtZ9xYnpN4qcvMb5QVQuxSC1GN
         jen18EHpr84ZR0oNljWw/msC6clRakkhff6O2EP9ImF6Ce7ps4GfmSBAUdBrtXjTdA
         nyB/GwC4ee7ZA==
Date:   Wed, 22 Apr 2020 13:52:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qian Cai <cai@lca.pw>, Wanpeng Li <wanpengli@tencent.com>
Subject: linux-next: manual merge of the kvm tree with the rcu tree
Message-ID: <20200422135212.74d72690@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5VSpAfQEKxH/B/sz0WWOHru";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/5VSpAfQEKxH/B/sz0WWOHru
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/svm/svm.c

between commit:

  c60e60a23f24 ("kvm/svm: Disable KCSAN for svm_vcpu_run()")

from the rcu tree and commit:

  a9ab13ff6e84 ("KVM: X86: Improve latency for single target IPI fastpath")

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
index b303ae0803d2,a6f4e1bdb045..000000000000
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@@ -3276,10 -3299,21 +3299,21 @@@ static void svm_cancel_injection(struc
  	svm_complete_interrupts(svm);
  }
 =20
+ static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kv=
m_vcpu *vcpu)
+ {
+ 	if (!is_guest_mode(vcpu) &&
+ 	    to_svm(vcpu)->vmcb->control.exit_code =3D=3D SVM_EXIT_MSR &&
+ 	    to_svm(vcpu)->vmcb->control.exit_info_1)
+ 		return handle_fastpath_set_msr_irqoff(vcpu);
+=20
+ 	return EXIT_FASTPATH_NONE;
+ }
+=20
  void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 =20
- static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
 -static enum exit_fastpath_completion svm_vcpu_run(struct kvm_vcpu *vcpu)
++static __no_kcsan enum exit_fastpath_completion svm_vcpu_run(struct kvm_v=
cpu *vcpu)
  {
+ 	enum exit_fastpath_completion exit_fastpath;
  	struct vcpu_svm *svm =3D to_svm(vcpu);
 =20
  	svm->vmcb->save.rax =3D vcpu->arch.regs[VCPU_REGS_RAX];

--Sig_/5VSpAfQEKxH/B/sz0WWOHru
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6fv2wACgkQAVBC80lX
0GymtQf/U17yb+yHk4v+1jDTGDNXHyZnQZ2UUycoKCW7etIYYM4PP1XhDKPy5YBK
VAywDItg71HdFtO33xKb9TkT1uiGFGIu6JTBoxnHsas5MBd0OYc/UyHo/5g8eMBF
KACqYK0cIcPI/KlLP7pz+J4o4TUwmf5RSx796vNEmG5v7hfM9D8n7+UHmDtUSlno
c+Uik1TxRJV3pPO/pfVNyovUoV8Og+aJVsRetWB5insLMZBK/GwcFUEFXHNVDkfV
DkSm791vwVdN1Z6+nL/SfMIb07x5xtSM/ySmt8zpeE6/HlrgC/xwMKfOHq+Y7ppP
vVUg8yMkH60eBdnoeoQzAVvqfXYuvQ==
=6Vge
-----END PGP SIGNATURE-----

--Sig_/5VSpAfQEKxH/B/sz0WWOHru--
