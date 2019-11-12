Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DA8F9B63
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKLVAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:00:44 -0500
Received: from ozlabs.org ([203.11.71.1]:38799 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfKLVAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:00:43 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47CKs43JPvz9sNH;
        Wed, 13 Nov 2019 08:00:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1573592440;
        bh=Fl+cnxImbUdxKiW7FdnzmPITLo/GSGUVAFEIaaL5eo0=;
        h=Date:From:To:Cc:Subject:From;
        b=MVzlhpxs4rSOX1QJUEOnQslPQrXJ1R279YUQO/nyPodUDCZYiQgnotS9Te1U5QlvE
         rkBkppTlI2//CHrmsMnZyhuchJkETC9pz1EtBF6vCJr09TOSpzKB3h9UCdb8rlAnZX
         8sGd9jeNw4qYY/99JoP4dz31tKgFJ6Rq5rfEJ1WVBLDVEpRnOHpQM4ZYBm4k8z1ezh
         Z6aMmYQEsScFndpTBk7mkS+sFoKFNQ99f+lWPkdPZnPj95A//O1LNW8MxMLH3eSAGZ
         h84WtvE3mGGKRePiV6gjsk5pDU+EN7qXwPbrn+q9ivxs5lBy89n14pEjVb86NM6/9U
         8q7daU8fIDbFQ==
Date:   Wed, 13 Nov 2019 08:00:27 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Junaid Shahid <junaids@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: manual merge of the kvm-fixes tree with Linus' tree
Message-ID: <20191113080027.7f97187e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8Xt/mjuISnu+fFn1EoKnuQe";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/8Xt/mjuISnu+fFn1EoKnuQe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-fixes tree got a conflict in:

  virt/kvm/kvm_main.c

between commit:

  1aa9b9572b10 ("kvm: x86: mmu: Recovery of shattered NX large pages")

from Linus' tree and commit:

  8a44119a98be ("KVM: Fix NULL-ptr deref after kvm_create_vm fails")

from the kvm-fixes tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc virt/kvm/kvm_main.c
index 4aab3547a165,0dac149ead16..000000000000
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@@ -693,16 -700,7 +718,11 @@@ static struct kvm *kvm_create_vm(unsign
  	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
  #endif
 =20
- 	if (init_srcu_struct(&kvm->srcu))
- 		goto out_err_no_srcu;
- 	if (init_srcu_struct(&kvm->irq_srcu))
- 		goto out_err_no_irq_srcu;
-=20
  	r =3D kvm_init_mmu_notifier(kvm);
 +	if (r)
 +		goto out_err_no_mmu_notifier;
 +
 +	r =3D kvm_arch_post_init_vm(kvm);
  	if (r)
  		goto out_err;
 =20
@@@ -715,15 -713,6 +735,11 @@@
  	return kvm;
 =20
  out_err:
 +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 +	if (kvm->mmu_notifier.ops)
 +		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 +#endif
 +out_err_no_mmu_notifier:
- 	cleanup_srcu_struct(&kvm->irq_srcu);
- out_err_no_irq_srcu:
- 	cleanup_srcu_struct(&kvm->srcu);
- out_err_no_srcu:
  	hardware_disable_all();
  out_err_no_disable:
  	kvm_arch_destroy_vm(kvm);

--Sig_/8Xt/mjuISnu+fFn1EoKnuQe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3LHWsACgkQAVBC80lX
0GzCPAf/b29ToiuxSPwg8rdX45EO9o3HaaUOIr75goZaHxQ+AikHF38WUH9G7nQf
gvEOHY35Im8wFMmLXpy+HB/AHAFaUqLegATYyYFnnrYGsZmjC1LtHo/1Ll1RNtpd
JDjtfTINyD++G2SR1iujUQaVgtth4ysWva3qbMJ9/ytZ26maxRK55Q2lFRJHVKmJ
jGa5Hqkw44xKGMIfWrqmPpxCGhwS5Q60xwcafuz4Bx9k2dlFG787gHWjolg0ZO/r
e4T/y5u15jXqtCGNRYIgJgbhgwgLFJl3AXFGkljtste7FFNtynAk6BKyA822IoSp
CNP0Tei0yRD4G1is1DpDstEqYgIxTQ==
=jQY5
-----END PGP SIGNATURE-----

--Sig_/8Xt/mjuISnu+fFn1EoKnuQe--
