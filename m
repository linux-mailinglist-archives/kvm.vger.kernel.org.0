Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55ADD2119D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 03:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEQBKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 21:10:38 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39457 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbfEQBKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 21:10:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 454qwV1tpRz9sB3;
        Fri, 17 May 2019 11:10:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1558055434;
        bh=RK0ByL2dNNTGhFRkNqTeaiBcwQPpljOhzr45pORWQTE=;
        h=Date:From:To:Cc:Subject:From;
        b=I45YXxk1QmBzm4aEkaF5SMDfEbJgUhPrl+qIfxNEpyrPWQtIT3yiLnLilyWsHpMRV
         ICQccNMbNJ5MHDTrcoEyjcK4MKKqGEUowgTO3XnUvJ7SIahhIn/qTA5ul6QQYScRrx
         i3FOPIwbyPrittApoXT8bxesNY/zOFpuChE/3I716RYgshP7RLajP67bqITriOPE7H
         ojqxPsKhL3J+uzxT3Q711+LaNgoN2Al7QnA2iyPwAvlH9p8MwVvinNlNkgBtDbq253
         rs78WKES7EuQ5HO8mOzOH3fZ9pnu+WPLgx/DgiwI/kcV0c63/OlLipiabkaAekc1w/
         Xfr2kzCDIL1PA==
Date:   Fri, 17 May 2019 11:10:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Filippo Sironi <sironi@amazon.de>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20190517111033.2b757538@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AN2PV9Q=aQ6OJ=glPm0oskc"; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/AN2PV9Q=aQ6OJ=glPm0oskc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/paging_tmpl.h

between commit:

  73b0140bf0fe ("mm/gup: change GUP fast to use flags rather than a write '=
bool'")

from Linus' tree and commit:

  bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching=
 GPTEs")

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

diff --cc arch/x86/kvm/paging_tmpl.h
index 08715034e315,c40af67d0f44..000000000000
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@@ -140,16 -140,36 +140,36 @@@ static int FNAME(cmpxchg_gpte)(struct k
  	pt_element_t *table;
  	struct page *page;
 =20
 -	npages =3D get_user_pages_fast((unsigned long)ptep_user, 1, 1, &page);
 +	npages =3D get_user_pages_fast((unsigned long)ptep_user, 1, FOLL_WRITE, =
&page);
- 	/* Check if the user is doing something meaningless. */
- 	if (unlikely(npages !=3D 1))
- 		return -EFAULT;
-=20
- 	table =3D kmap_atomic(page);
- 	ret =3D CMPXCHG(&table[index], orig_pte, new_pte);
- 	kunmap_atomic(table);
-=20
- 	kvm_release_page_dirty(page);
+ 	if (likely(npages =3D=3D 1)) {
+ 		table =3D kmap_atomic(page);
+ 		ret =3D CMPXCHG(&table[index], orig_pte, new_pte);
+ 		kunmap_atomic(table);
+=20
+ 		kvm_release_page_dirty(page);
+ 	} else {
+ 		struct vm_area_struct *vma;
+ 		unsigned long vaddr =3D (unsigned long)ptep_user & PAGE_MASK;
+ 		unsigned long pfn;
+ 		unsigned long paddr;
+=20
+ 		down_read(&current->mm->mmap_sem);
+ 		vma =3D find_vma_intersection(current->mm, vaddr, vaddr + PAGE_SIZE);
+ 		if (!vma || !(vma->vm_flags & VM_PFNMAP)) {
+ 			up_read(&current->mm->mmap_sem);
+ 			return -EFAULT;
+ 		}
+ 		pfn =3D ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+ 		paddr =3D pfn << PAGE_SHIFT;
+ 		table =3D memremap(paddr, PAGE_SIZE, MEMREMAP_WB);
+ 		if (!table) {
+ 			up_read(&current->mm->mmap_sem);
+ 			return -EFAULT;
+ 		}
+ 		ret =3D CMPXCHG(&table[index], orig_pte, new_pte);
+ 		memunmap(table);
+ 		up_read(&current->mm->mmap_sem);
+ 	}
 =20
  	return (ret !=3D orig_pte);
  }

--Sig_/AN2PV9Q=aQ6OJ=glPm0oskc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzeCgkACgkQAVBC80lX
0GzRfQgAiN14rzmIAsb31BoTkkyQ3mplU+L1zCnON85OmMs8K0AB6LmpVFRt4apt
gQpS78zaq6BFYkdbDURyDu6ZtZsN4PGuNEYGcHpekrEQDV71DduEidzonNODO8cC
Q6CZZaBIh/3aGvmHa6wxWBYKK7f7w5AyCg+B0jKnQnq5Dn1RA8Ey7KXvakKd8QMu
TWRxNqvmC7WLHLJILkgSp8FYRIgf2s/jZcsZbiCab1Jn/nOCAN2Xx3CinsvLgz/G
dGXxpA/lTUfWn3mtFiQi4sggfwVRYKUGrJJWdVzpIUtbc7anmet5/wL3KdDWrjWW
QeRusjDZjzXt05/r5zzTaThk3AZTXw==
=cTGR
-----END PGP SIGNATURE-----

--Sig_/AN2PV9Q=aQ6OJ=glPm0oskc--
