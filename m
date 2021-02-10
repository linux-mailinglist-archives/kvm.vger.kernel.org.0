Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F43316293
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhBJJot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 04:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhBJJnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 04:43:11 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E10AC06174A;
        Wed, 10 Feb 2021 01:42:29 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DbFD04H3wz9sCD;
        Wed, 10 Feb 2021 20:42:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612950145;
        bh=J9lGZTrqX2s2/B1qIZ8e77GL8+B9fY0I9TXfY6sYe/8=;
        h=Date:From:To:Cc:Subject:From;
        b=uSThYFWrLYpUQEF0KWeH9xx8LK5CMonAm1c53irvHAtThiZ1R13V5ciblSWV3nwqz
         ClbXyKWxgpcvN9x0PtdID996yZ+jLypi8ztpKFJxw5lW0kcytsFWffMn3clvt0aFq5
         9rPEQRAUulCyN7l9miCXY/iIHs8HgAfAwMvqlYO6yZeUHlLmh4P0HGuFGIVMCoBXF8
         n5JdJQK8qD59qE/cjzTGezrLq3DlFbf4LtdB1YePV5AooTsy0urSC8hOUCTlqw0+Fe
         vqcTQCTmdVOAx50zJc4jqtYMfkCx+DLxopphIkP12vJuOdMMRuKMdOGaJvW9mjTJeS
         OGKjax5aiUBHg==
Date:   Wed, 10 Feb 2021 20:42:15 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Vetter <daniel@ffwll.ch>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the iomem-mmap-vs-gup tree
Message-ID: <20210210204215.2912b80b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/S90AYVKifAGg.VlqIK_6.7M";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/S90AYVKifAGg.VlqIK_6.7M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the iomem-mmap-vs-gup tree, today's linux-next build
(powerpc ppc64_defconfig) failed like this:


Caused by commit

  96667f8a4382 ("mm: Close race in generic_access_phys")

interacting with commit

  9fd6dad1261a ("mm: provide a saner PTE walking API for modules")

from the kvm tree.

I have applied the following merge fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 10 Feb 2021 20:29:22 +1100
Subject: [PATCH] mm: fixup for follow_pte() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b518bf4273d2..2c436e3a6259 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4825,7 +4825,7 @@ int generic_access_phys(struct vm_area_struct *vma, u=
nsigned long addr,
 		return -EINVAL;
=20
 retry:
-	if (follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl))
+	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
 		return -EINVAL;
 	pte =3D *ptep;
 	pte_unmap_unlock(ptep, ptl);
@@ -4840,7 +4840,7 @@ int generic_access_phys(struct vm_area_struct *vma, u=
nsigned long addr,
 	if (!maddr)
 		return -ENOMEM;
=20
-	if (follow_pte(vma->vm_mm, addr, NULL, &ptep, NULL, &ptl))
+	if (follow_pte(vma->vm_mm, addr, &ptep, &ptl))
 		goto out_unmap;
=20
 	if (!pte_same(pte, *ptep)) {
--=20
2.30.0

--=20
Cheers,
Stephen Rothwell

--Sig_/S90AYVKifAGg.VlqIK_6.7M
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAjqncACgkQAVBC80lX
0GzF0gf+IoInNF+gWKQAgwYEB0j8McYhVWX8qIoih4IIWGAJdlXgfWOG11hm5HwE
rnsdLwk2HeRAMkekqSypxPNa6jA8D4FQg7MnYCnt5v+BRXGjR/CoBjsHjFhf8Z+Y
K7j9ZTjstM81iGqppt4AZuikbV5Mr3aF9xnKzpNNMjTsmJ9kajKW7oo3H83ghpF3
dbQbvmqyVG9yrULNWI/yZz5BrBGa7tdvqFwHfpzaAK8LTJeLK1t1BoS21P/LylcY
IZ0mPPllO6wjstRI2L8mYlDAZ+n3eRB1V/HzRNDSfP3svbjzes12s0VFgbePb9oR
+kn0f1doDG0Fwu/nnX88G5llMHE/8A==
=n0dX
-----END PGP SIGNATURE-----

--Sig_/S90AYVKifAGg.VlqIK_6.7M--
