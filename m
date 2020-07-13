Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D88121CE5A
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 06:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgGMEkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 00:40:41 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:32959 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgGMEkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 00:40:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B4rYf07ttz9sRW;
        Mon, 13 Jul 2020 14:40:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594615238;
        bh=X2Wud9eqHa5P5dnFzfs5isEGcPND8sa4/jcFZQA1klE=;
        h=Date:From:To:Cc:Subject:From;
        b=Ds5dBXJl5n4w6dclItOfUPmw15D2n+JAC129r9bWBPsMz/uh15Fxi8c5MFAnp8Cio
         K98Zh72fNFvw8uqDFNvSomRchfGwJijVQPGYgkomYSnTrtZy+ZDEVlQ7otsDLah15X
         NpGb1/rLXwBPhIg4fr6LNN1ak1hEGvIFpToKXlh3Im0k7+0xph1xqKRXgx2oC6bkae
         f62YOFWl/Rzs6WX6U1gQQApLfFuoLb4Kp2RS8vj9R2ObGFa7PVprmmLONIbX1sQIyl
         7HOQOkhpnML6HLNbj0FNmZq4VwxHG12iC2Wz4puaPLNQr4db3wnvwfsc9dKW5nZcUj
         WfDJCiMHxs7bg==
Date:   Mon, 13 Jul 2020 14:40:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20200713144036.7afe4e76@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/E=RS7Cw=NiZB95zv0VwjT.i";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/E=RS7Cw=NiZB95zv0VwjT.i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/arm64/kvm/mmu.c

between commit:

  c1a33aebe91d ("KVM: arm64: Use common KVM implementation of MMU memory ca=
ches")

from the kvm tree and commit:

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
index 838aad520f1c,cd14c831d56f..000000000000
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

--Sig_/E=RS7Cw=NiZB95zv0VwjT.i
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8L5cQACgkQAVBC80lX
0GzzxAf/dwrPFrD9cNWtYSFdCDM7I3ln2fYbXIo3OFAq/qFczwbvH2Ae5KS8Uw+h
nbNrZ0tPhBNEj74hcSqvIH+D9kHs9s0kjncO5tDoFTRfTB+o8cqkKbuYc0ft8lW4
uoEDfzI4Jut/gPYxN7pkotVcSnto3TT/BJAnFycdjj8LaYsGEBjvhmSAxwZmTs1Z
yYFcWz5CIZtTN26ADkxPV1hZ2ezcYsIojP2qWBJL60QCWqn+NsNbYoz/ID80CAfW
+3uFCwZOqoMbq58Xf0J8nbHCqOITFGbgjrZSH2o2PA3OVau5qCbPK3MBuEfbyKzh
NtWH2fCVZ57FbFiwzqOSml7clZcb1Q==
=BDCb
-----END PGP SIGNATURE-----

--Sig_/E=RS7Cw=NiZB95zv0VwjT.i--
