Return-Path: <kvm+bounces-2239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F307F3B8C
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 02:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 751A4B21AD1
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 01:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AA9746C;
	Wed, 22 Nov 2023 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="LSt7nN3k"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ADD191;
	Tue, 21 Nov 2023 17:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1700618141;
	bh=7FPZrQpXckwEBiIN9Y1g3A9pS2bcgEzzAWiPT+SeB5I=;
	h=Date:From:To:Cc:Subject:From;
	b=LSt7nN3kuHNFZSSk8DWiD852msXu5uKO6t7YWtdui95oa1Ic65OCitI9uWln5JUro
	 Qt9fSovUvXI64CfHf+E8FO6fmbB8rCeVscBtkxY9GyCfYK8vkb/ejTU4/iEU4pQL1A
	 A7hSIuay7LpCyOV5hKsdUFwDcT6tbzsz6j64knbVIUjYev5pFHel3ZUV/tOo2mlCy6
	 fODth7pB8EQdZAr7VPDVpgE7dkhKfj5e3KucU4RwKv0t59uFR0ostTV59pp22x74vV
	 oj6z+Ip0ssGMNEExbamkaiR/SXm0yr7ijL+FN8deWYgREhMSHT4phWu3FqZMCiTcIL
	 Atof8VF48yPeg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SZkq03tmpz4xNt;
	Wed, 22 Nov 2023 12:55:40 +1100 (AEDT)
Date: Wed, 22 Nov 2023 12:55:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
 Vlastimil Babka <vbabka@suse.cz>
Subject: linux-next: manual merge of the kvm tree with the vfs-brauner tree
Message-ID: <20231122125539.5a7df3a3@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/honfjtDRMxpjius90+yuCtF";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/honfjtDRMxpjius90+yuCtF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  include/linux/pagemap.h

between commit:

  762321dab9a7 ("filemap: add a per-mapping stable writes flag")

from the vfs-brauner tree and commit:

  0003e2a41468 ("mm: Add AS_UNMOVABLE to mark mapping as completely unmovab=
le")

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

diff --cc include/linux/pagemap.h
index 06142ff7f9ce,bf2965b01b35..000000000000
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@@ -203,9 -203,8 +203,10 @@@ enum mapping_flags=20
  	/* writeback related tags are not used */
  	AS_NO_WRITEBACK_TAGS =3D 5,
  	AS_LARGE_FOLIO_SUPPORT =3D 6,
- 	AS_RELEASE_ALWAYS,	/* Call ->release_folio(), even if no private data */
+ 	AS_RELEASE_ALWAYS =3D 7,	/* Call ->release_folio(), even if no private d=
ata */
+ 	AS_UNMOVABLE	=3D 8,	/* The mapping cannot be moved, ever */
 +	AS_STABLE_WRITES,	/* must wait for writeback before modifying
 +				   folio contents */
  };
 =20
  /**
@@@ -291,21 -290,22 +292,37 @@@ static inline void mapping_clear_releas
  	clear_bit(AS_RELEASE_ALWAYS, &mapping->flags);
  }
 =20
+ static inline void mapping_set_unmovable(struct address_space *mapping)
+ {
+ 	/*
+ 	 * It's expected unmovable mappings are also unevictable. Compaction
+ 	 * migrate scanner (isolate_migratepages_block()) relies on this to
+ 	 * reduce page locking.
+ 	 */
+ 	set_bit(AS_UNEVICTABLE, &mapping->flags);
+ 	set_bit(AS_UNMOVABLE, &mapping->flags);
+ }
+=20
+ static inline bool mapping_unmovable(struct address_space *mapping)
+ {
+ 	return test_bit(AS_UNMOVABLE, &mapping->flags);
+ }
+=20
 +static inline bool mapping_stable_writes(const struct address_space *mapp=
ing)
 +{
 +	return test_bit(AS_STABLE_WRITES, &mapping->flags);
 +}
 +
 +static inline void mapping_set_stable_writes(struct address_space *mappin=
g)
 +{
 +	set_bit(AS_STABLE_WRITES, &mapping->flags);
 +}
 +
 +static inline void mapping_clear_stable_writes(struct address_space *mapp=
ing)
 +{
 +	clear_bit(AS_STABLE_WRITES, &mapping->flags);
 +}
 +
  static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
  {
  	return mapping->gfp_mask;

--Sig_/honfjtDRMxpjius90+yuCtF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmVdX5sACgkQAVBC80lX
0GzSXgf+N2TLLaEpSHOYVqMs/ZwLPvbsg/rzTqaXc/4q/rgKKllPK7IfInPe5Pfo
YfZXyLs/h+nBPwptExxL0Rt+krQqEPB1dsG0GoU1aGfOZ6L14bjJIy0A9T7IeWjz
1GNuV0BJZYhnvthgvCDS6t1H9SNEhLMDOlkLB5hc8Chptm4jm4JmYqhWQ1gevm/p
vAPCvaeFSEcp9mLpQiAKPxPo1wjgYRvLn7Cyzwd7H8OWE6q+xDE6WnEmIN+2X7Dc
zxy8mZbwqtvaRpVR3j0jNvgCDQQT+zdLUPvj/vxhBZ8dJ4r8OKsVaSz//Ba2B69H
HqlrJQbRuP2ZjlnzR4yD1SmjfuC8mw==
=BT5G
-----END PGP SIGNATURE-----

--Sig_/honfjtDRMxpjius90+yuCtF--

