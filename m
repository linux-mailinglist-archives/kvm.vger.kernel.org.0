Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427E31E7622
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 08:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgE2GqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 02:46:18 -0400
Received: from ozlabs.org ([203.11.71.1]:46139 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725681AbgE2GqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 02:46:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49YFTM68PYz9sSp;
        Fri, 29 May 2020 16:46:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590734776;
        bh=l+Xvu2zy6hKZ6lhYjwD7Ye7643sbaA4BsCh6MX+Mf40=;
        h=Date:From:To:Cc:Subject:From;
        b=IJOIS0/Qce3klupjjUsZu7IruI9fPBWK5y71pBmirNG9rAJQmMgbg4Uh9ohw+i4iX
         bLK1egBbnQevdcHNSGnio/XHHuSxJEjpyNhTJ7XFWKuNiKDGQW/nJszJG8F3vduH7/
         44Dl0y+a17sN1CxqQAWeFnW8LB17zZe39l9MR8b3lcyjTIuPZ/nO17JYJF6IiqifD7
         j9hh4xV/mhiD2RxOiHq0YjWLievOWaIBepZM47EsRnSmT6FZ2xqb478YDbmBLfqWR1
         enZQziWeEWgq8OEfXko5eckwbMGOItE5YhuLymVw+o8+tN3NoO1cLwdr0vLf3U8Ppf
         6GTrVTZ7T6Uyw==
Date:   Fri, 29 May 2020 16:46:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: linux-next: manual merge of the kvm tree with the s390 tree
Message-ID: <20200529164613.526f5865@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Jb9VoBJqXmq2POSA2Qi8d./";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Jb9VoBJqXmq2POSA2Qi8d./
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/s390/kvm/vsie.c

between commit:

  0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")

from the s390 tree and commit:

  d075fc3154be ("KVM: s390: vsie: Move conditional reschedule")

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

diff --cc arch/s390/kvm/vsie.c
index 4fde24a1856e,ef05b4e167fb..000000000000
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@@ -1000,9 -1000,9 +1000,6 @@@ static int do_vsie_run(struct kvm_vcpu=20
 =20
  	handle_last_fault(vcpu, vsie_page);
 =20
- 	if (need_resched())
- 		schedule();
 -	if (test_cpu_flag(CIF_MCCK_PENDING))
 -		s390_handle_mcck();
--
  	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 =20
  	/* save current guest state of bp isolation override */

--Sig_/Jb9VoBJqXmq2POSA2Qi8d./
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7Qr7UACgkQAVBC80lX
0GwjxQgAloXEB6ijQwPWPzPlo8/jBiG1eJJCES3TLkThdjLaW3jH/gWxSiLC7TOm
X9wdNoExw2wa521d3LM+gKmEAXEBDW1mbJrX2pNV973+gOgv5nWnXJEk5ZrZ/3De
Zu0G2YKsoKnJgtSwXN2ezAU+RkHs3jI4TFGUs3SDYwWUh3MPxXYOeGr7dudIcC4P
8+fqSAEBnOf5CtsVf2eTx3k8bf0maPrpoUN28v1Qy8wh7L/caC7uUwSECxbTAkbK
qIMngkOuvzm7MCsicnS2YS4tOKBo9YAnkYHHcpjOJ+zcooKkE5KVRoUQ7dNqapwE
vlvFfUXwZsmok7FCHOT83nIKQRtB4g==
=8zLf
-----END PGP SIGNATURE-----

--Sig_/Jb9VoBJqXmq2POSA2Qi8d./--
