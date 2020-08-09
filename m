Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B52C23FD76
	for <lists+kvm@lfdr.de>; Sun,  9 Aug 2020 10:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHIIzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 04:55:49 -0400
Received: from ozlabs.org ([203.11.71.1]:41911 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgHIIzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Aug 2020 04:55:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BPXxX4yzfz9sTN;
        Sun,  9 Aug 2020 18:55:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596963345;
        bh=h9z3S1P7kfySisJHeRwXBAFE9LjBOYSWlgVqiTJ4IvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kCuB6cXsY2PBOhTveHFLDGQ3Ifgt56128+kdMJJ+a0ScbZdHk9H8W9BiHeor3iveQ
         yHTi2pSUXOW8hs138SUC4K1k1WmNV5jf/PXn0yQVTp2rQrhK1ce0jmk05o5KITtNFt
         ir4VSnygpDivRuMgGYDfmQoi5vw7nyddRmBcMd+m/U/8eCAa1w2lQfeM2tHFi5wj5L
         zuZE9S8CT5L3+G0pEldCZEHrWe7uCAEP6VUME5U8piPuDVbaJlrfBbiv3pAMmuViWW
         W947iUSbA/APznQdJ0eYPcN5kL7gK6s5TltB3/g0/7byAkYYdlB3qrNQMfol3ymtEf
         qOuWeSxE7YHFg==
Date:   Sun, 9 Aug 2020 18:55:43 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20200809185543.4dffd5e1@canb.auug.org.au>
In-Reply-To: <20200713144036.7afe4e76@canb.auug.org.au>
References: <20200713144036.7afe4e76@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/t9+.IJT4cacetod67OCrUOy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/t9+.IJT4cacetod67OCrUOy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 13 Jul 2020 14:40:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm-arm tree got a conflict in:
>=20
>   arch/arm64/kvm/mmu.c
>=20
> between commit:
>=20
>   c1a33aebe91d ("KVM: arm64: Use common KVM implementation of MMU memory =
caches")
>=20
> from the kvm tree and commit:
>=20
>   a0e50aa3f4a8 ("KVM: arm64: Factor out stage 2 page table data from stru=
ct kvm")
>=20
> from the kvm-arm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc arch/arm64/kvm/mmu.c
> index 838aad520f1c,cd14c831d56f..000000000000
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@@ -124,11 -127,44 +127,12 @@@ static void stage2_dissolve_pud(struct=20
>   	put_page(virt_to_page(pudp));
>   }
>  =20
> - static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_ad=
dr_t addr)
>  -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>  -				  int min, int max)
>  -{
>  -	void *page;
>  -
>  -	BUG_ON(max > KVM_NR_MEM_OBJS);
>  -	if (cache->nobjs >=3D min)
>  -		return 0;
>  -	while (cache->nobjs < max) {
>  -		page =3D (void *)__get_free_page(GFP_PGTABLE_USER);
>  -		if (!page)
>  -			return -ENOMEM;
>  -		cache->objects[cache->nobjs++] =3D page;
>  -	}
>  -	return 0;
>  -}
>  -
>  -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>  -{
>  -	while (mc->nobjs)
>  -		free_page((unsigned long)mc->objects[--mc->nobjs]);
>  -}
>  -
>  -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>  -{
>  -	void *p;
>  -
>  -	BUG_ON(!mc || !mc->nobjs);
>  -	p =3D mc->objects[--mc->nobjs];
>  -	return p;
>  -}
>  -
> + static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu, pgd_t *pgd, =
phys_addr_t addr)
>   {
> + 	struct kvm *kvm =3D mmu->kvm;
>   	p4d_t *p4d_table __maybe_unused =3D stage2_p4d_offset(kvm, pgd, 0UL);
>   	stage2_pgd_clear(kvm, pgd);
> - 	kvm_tlb_flush_vmid_ipa(kvm, addr);
> + 	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
>   	stage2_p4d_free(kvm, p4d_table);
>   	put_page(virt_to_page(pgd));
>   }

This is now a conflict between the kvm-arm tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/t9+.IJT4cacetod67OCrUOy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8vug8ACgkQAVBC80lX
0Gz/uQgAnukH8JtyH6V0NhbMs9W+6b8VYhrKRWS1Z7gwWtudqjazLJhxLwkxlBSJ
l0HFSyx7+1TmHikuaYLxNrjv30bxalSTqu+i4RlCyaJXkSo+j5qppFBTb//TLXAK
4CSh/yGO9p2yHk/VC8mc6yOofysn1j8JVK24Iz1VyoUQLj5WbCp1VSeERxd9KBjb
v5v3W4yVKAu1LUYYbfKCNZJ7hhd/0g0UNOPCYTFQoQOfwaHpCLfdMd5UZEELScIc
MOqbE78Kf1/b5gVUVnsbB8TT55UocqIIiFBrWgN5tRGQS5hRUT9GuCYCikvCaIRo
y4i89ZYPa7EZgC31fHI3wE4wUqw8QA==
=Y8xT
-----END PGP SIGNATURE-----

--Sig_/t9+.IJT4cacetod67OCrUOy--
