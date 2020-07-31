Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71731233F38
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 08:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgGaGlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 02:41:24 -0400
Received: from ozlabs.org ([203.11.71.1]:38869 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731369AbgGaGlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 02:41:23 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BHyNZ6xtsz9sRN;
        Fri, 31 Jul 2020 16:41:17 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596177680;
        bh=YiqLrRycvqLl4QUJsOXEjPkwKcEk/G+XXcaUYXrgJBE=;
        h=Date:From:To:Cc:Subject:From;
        b=uS7CB3LWcSRO5A3NOPyQbmC98LYlgrYkHkhyprR9Z1D+us23DsxZgnNBnz1JVB0kR
         JMEM/mX03jkm4uNQ8YNyr4b9LX8r57KAsxc99PDVOrRi84Ia5769oU6jyfFVNSwaUx
         nqwxdXUhgH8w1D7YKS/I3K04Q0ZiMXW49eos8bmPoSvTaubVc9tWKEjN3et1yGJ0tk
         cTwSpF2OCU2JNciaCFvy3hLaKdkcq5eRGN+b+tRRRZm9VINtLEENT6QkD2dml5+Bdd
         t1diSEqu3NX8ttdhwA/pvenENNBrlTwHtc7w5q9TefnMZtgLc2+0mx9L3mrLTkXYmx
         lVS+YUg9Qdw8A==
Date:   Fri, 31 Jul 2020 16:41:17 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm-fixes
 tree
Message-ID: <20200731164117.3ecb9791@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sHtRfof93J1vXO=3zZ.KFni";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/sHtRfof93J1vXO=3zZ.KFni
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/arm64/kvm/mmu.c

between commit:

  b757b47a2fcb ("KVM: arm64: Don't inherit exec permission across page-tabl=
e levels")

from the kvm-fixes tree and commit:

  a0e50aa3f4a8 ("KVM: arm64: Factor out stage 2 page table data from struct=
 kvm")

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

diff --cc arch/arm64/kvm/mmu.c
index 7a7ddc4558a7,05e0e03fbdf8..000000000000
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@@ -124,11 -127,44 +127,12 @@@ static void stage2_dissolve_pud(struct=20
  	put_page(virt_to_page(pudp));
  }
 =20
- static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr=
_t addr)
 -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 -				  int min, int max)
 -{
 -	void *page;
 -
 -	BUG_ON(max > KVM_NR_MEM_OBJS);
 -	if (cache->nobjs >=3D min)
 -		return 0;
 -	while (cache->nobjs < max) {
 -		page =3D (void *)__get_free_page(GFP_PGTABLE_USER);
 -		if (!page)
 -			return -ENOMEM;
 -		cache->objects[cache->nobjs++] =3D page;
 -	}
 -	return 0;
 -}
 -
 -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 -{
 -	while (mc->nobjs)
 -		free_page((unsigned long)mc->objects[--mc->nobjs]);
 -}
 -
 -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 -{
 -	void *p;
 -
 -	BUG_ON(!mc || !mc->nobjs);
 -	p =3D mc->objects[--mc->nobjs];
 -	return p;
 -}
 -
+ static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu, pgd_t *pgd, ph=
ys_addr_t addr)
  {
+ 	struct kvm *kvm =3D mmu->kvm;
  	p4d_t *p4d_table __maybe_unused =3D stage2_p4d_offset(kvm, pgd, 0UL);
  	stage2_pgd_clear(kvm, pgd);
- 	kvm_tlb_flush_vmid_ipa(kvm, addr);
+ 	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
  	stage2_p4d_free(kvm, p4d_table);
  	put_page(virt_to_page(pgd));
  }
@@@ -1294,7 -1356,7 +1324,8 @@@ static bool stage2_get_leaf_entry(struc
  	return true;
  }
 =20
- static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr, unsigned lo=
ng sz)
 -static bool stage2_is_exec(struct kvm_s2_mmu *mmu, phys_addr_t addr)
++static bool stage2_is_exec(struct kvm_s2_mmu *mmu, phys_addr_t addr,
++			   unsigned long sz)
  {
  	pud_t *pudp;
  	pmd_t *pmdp;
@@@ -1306,14 -1368,15 +1337,15 @@@
  		return false;
 =20
  	if (pudp)
 -		return kvm_s2pud_exec(pudp);
 +		return sz <=3D PUD_SIZE && kvm_s2pud_exec(pudp);
  	else if (pmdp)
 -		return kvm_s2pmd_exec(pmdp);
 +		return sz <=3D PMD_SIZE && kvm_s2pmd_exec(pmdp);
  	else
 -		return kvm_s2pte_exec(ptep);
 +		return sz =3D=3D PAGE_SIZE && kvm_s2pte_exec(ptep);
  }
 =20
- static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *c=
ache,
+ static int stage2_set_pte(struct kvm_s2_mmu *mmu,
+ 			  struct kvm_mmu_memory_cache *cache,
  			  phys_addr_t addr, const pte_t *new_pte,
  			  unsigned long flags)
  {
@@@ -1924,8 -1995,7 +1962,8 @@@ static int user_mem_abort(struct kvm_vc
  	 * execute permissions, and we preserve whatever we have.
  	 */
  	needs_exec =3D exec_fault ||
 -		(fault_status =3D=3D FSC_PERM && stage2_is_exec(mmu, fault_ipa));
 +		(fault_status =3D=3D FSC_PERM &&
- 		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
++		 stage2_is_exec(mmu, fault_ipa, vma_pagesize));
 =20
  	if (vma_pagesize =3D=3D PUD_SIZE) {
  		pud_t new_pud =3D kvm_pfn_pud(pfn, mem_type);

--Sig_/sHtRfof93J1vXO=3zZ.KFni
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8jvQ0ACgkQAVBC80lX
0Gy0lwf+JCeYR7z4ALYZJLhk2HOQMU9eiSRwKbm4w6NEs2oS+XjQ8A7Dd0mNVYk5
dvEK9GhATqGPMoltbQT4UEF7g0XNKT2WaJ4uOYlqHtFeIw29mAtUmrk1FYzjHjNa
+t+TkqTnwIvx5/HjaJu2h4kNBARPS3MX3Ny/bt9+whXSXgwsZAHeijEO6sah3lmB
AQPBzTO2bdm0KVBtqx3G7+H+rQRoIP3sOoGZzwAQDCm2P90q/VZ4OZVrNGEX9ir1
pTjEBhGga6lKeGwKq96M2HMffyfqSN9t9S6YrRebWxfezojMhTV1LWtTrmo4SsHG
Htv8r4BH9oqjNyL+45/NvD67EuJXmg==
=G+w3
-----END PGP SIGNATURE-----

--Sig_/sHtRfof93J1vXO=3zZ.KFni--
