Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863DB14770C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 03:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgAXC5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 21:57:31 -0500
Received: from ozlabs.org ([203.11.71.1]:46361 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbgAXC5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 21:57:31 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 483kMW2mW6z9sRK;
        Fri, 24 Jan 2020 13:57:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579834648;
        bh=q8ffQqdirptsDf8OczDeNcXp3ch/G5iyXyRmUhpQ7xA=;
        h=Date:From:To:Cc:Subject:From;
        b=cvtN5YcHGJtpouxbY2undLOtEunTEaJ3Z9Jkztl/HmNzAQuRUJakQHM8Kc/NPU1Tf
         MPGh3HHHbrCFRQg9DfW/d1XY2xaogzv4EP/xFWIZX/snz7TDo9FpbibHMgEIZK+moK
         FSLCVu+F+82aSlStdqFuI8DpVyvxOB2/PZswHoqhMRPI+foiyuse6tT6ZkrSdqx3wY
         K7yyEN1AwoLZsaxGA17+p+C8no4XExo/qt4K/i2qJZcF01EQ0GJcxwUTKF41uS6oS9
         hkq0Gej50KzTS/sLjATFQI4gFIyETcWgK6I+pbhbzlfyKLG+uFocuaT639LfZCDKGt
         WI6bjTSyD0OGQ==
Date:   Fri, 24 Jan 2020 13:57:26 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20200124135726.5fa8d146@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/N3xuIRKvN6fQ3AKvGXUMZTr";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/N3xuIRKvN6fQ3AKvGXUMZTr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  mm/huge_memory.c

between commit:

  97d3d0f9a1cf ("mm/huge_memory.c: thp: fix conflict of above-47bit hint ad=
dress and PMD alignment")

from Linus' tree and commit:

  0638468d2282 ("mm: thp: KVM: Explicitly check for THP when populating sec=
ondary MMU")

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

diff --cc mm/huge_memory.c
index a88093213674,9b3ee79d0edf..000000000000
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@@ -527,13 -527,24 +527,24 @@@ void prep_transhuge_page(struct page *p
  	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
  }
 =20
+ bool is_transparent_hugepage(struct page *page)
+ {
+ 	if (!PageCompound(page))
+ 		return 0;
+=20
+ 	page =3D compound_head(page);
+ 	return is_huge_zero_page(page) ||
+ 	       page[1].compound_dtor =3D=3D TRANSHUGE_PAGE_DTOR;
+ }
+ EXPORT_SYMBOL_GPL(is_transparent_hugepage);
+=20
 -static unsigned long __thp_get_unmapped_area(struct file *filp, unsigned =
long len,
 +static unsigned long __thp_get_unmapped_area(struct file *filp,
 +		unsigned long addr, unsigned long len,
  		loff_t off, unsigned long flags, unsigned long size)
  {
 -	unsigned long addr;
  	loff_t off_end =3D off + len;
  	loff_t off_align =3D round_up(off, size);
 -	unsigned long len_pad;
 +	unsigned long len_pad, ret;
 =20
  	if (off_end <=3D off_align || (off_end - off_align) < size)
  		return 0;

--Sig_/N3xuIRKvN6fQ3AKvGXUMZTr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4qXRYACgkQAVBC80lX
0Gy/rAf8DIQ0Sxyoae7h9n1by/1APETPO+A4WLctDdKktOmSlrC4zueiznCmZ/IK
1vjeZ5Cz2Q9MFzqCcMV34n7ZQkip92I0rUmwd6xkXi/tnRphvSX1fAbpw5pXBZkd
Pi4cySxGIGBsyJbTxrUWgdG2qlmLkoDPUX45Bq4yCLeLKcZPvSv9i8QhIuzeKuNM
GNdidhTZmh/RDxs+/Pigl3hYg4daGUQqCsYjGjrvlfSgzP5KPTfoNDGKzRIcYofU
RsDZy8NsqauaKhBX/IO2U3Ijqv3vwHtcCja5dQO6I8jElWfP+rSnwGetuRjsClh6
I8RXs7oMIn+OgbjJK754Xagm9ecaOw==
=eQO+
-----END PGP SIGNATURE-----

--Sig_/N3xuIRKvN6fQ3AKvGXUMZTr--
