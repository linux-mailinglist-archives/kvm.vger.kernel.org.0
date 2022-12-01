Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF44363E670
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiLAAYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAAYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:24:36 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05D558BC9;
        Wed, 30 Nov 2022 16:24:35 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NMxfB0bK1z4xG6;
        Thu,  1 Dec 2022 11:24:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669854274;
        bh=8Vn/tJhughq3v4sEE4ce0PBjHo/J8FUKxdLHSm73ghU=;
        h=Date:From:To:Cc:Subject:From;
        b=HsRtv8mvMTozgdJuuWCh4LyydxgRGAXdN7cUum0zTamKT5wsCd43ikqIYWCWScfWY
         b7B2pbNrloAiQtPgrIaf5BaaHVXc3E+cs1GVy7ipMrC2zjYWPBtWZf4Q+IToNBw0xW
         AD03bgcGb62F3e/58l4zzjUWlyf6Ziv/05TyZRIJzH1imTrzVGINwt9owymym/Rsyw
         iK1DvK0pdAky0tPXkyQ0fUf0Vj+UmkxmU0iuA9ZNaHS23kBT8zPYtZ89HzIkEyYwGi
         MuWfRgWNltQ/qjYiHJG/DdgMFKIzTX7F36kYUzyU/rdNjAOgycl+gwUyCi4pgzaIs4
         8J6HWsfbpyEqA==
Date:   Thu, 1 Dec 2022 11:24:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Gavin Shan <gshan@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20221201112432.4cb9ae42@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4NQKXa60ICPhK3C=IjESPee";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/4NQKXa60ICPhK3C=IjESPee
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/x86/include/asm/kvm_host.h

between commit:

  b0b42197b5c6 ("KVM: x86: start moving SMM-related functions to new files")

from the kvm tree and commit:

  e8a18565e593 ("KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_d=
irty_ring.h")

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

diff --cc arch/x86/include/asm/kvm_host.h
index d1013c4f673c,b4dbde7d9eb1..000000000000
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@@ -2154,8 -2084,12 +2154,6 @@@ static inline int kvm_cpu_get_apicid(in
  #endif
  }
 =20
- int kvm_cpu_dirty_log_size(void);
 -#define put_smstate(type, buf, offset, val)                      \
 -	*(type *)((buf) + (offset) - 0x7e00) =3D val
 -
 -#define GET_SMSTATE(type, buf, offset)		\
 -	(*(type *)((buf) + (offset) - 0x7e00))
--
  int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages=
);
 =20
  #define KVM_CLOCK_VALID_FLAGS						\

--Sig_/4NQKXa60ICPhK3C=IjESPee
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOH9EAACgkQAVBC80lX
0Gy11gf/R1EZqg51iZqnb5h2wy3qKBqyKfr6hA0syWaYQNY9Mvrt4eQkQIxXfEaK
sltRwkrTEfHbwG0EVEbxfvk7/K2rysp5UMObzpyqYt8C1lV0uw72DiaNimdYMN5h
+G83larc1aT0XMfrqWK+YwG4jNTvEQtZRCDC8rI1RVCe1syVXIxOVPR4xBP7Cd+B
yufIaMwvYqIb+5jPlk2sAZ1mvTQJlZEouFyqxFYWmHCF66c2rs8DddHQMn6hC9RL
xmFgDLImaN/1HTGbhYFzpYPwpekm7+SL/mWHySk+H1oveWXzxV3AIXDLS9OiU21t
ZslCitNVxR2ChbptZLn5uZfwDl98lw==
=JhQh
-----END PGP SIGNATURE-----

--Sig_/4NQKXa60ICPhK3C=IjESPee--
