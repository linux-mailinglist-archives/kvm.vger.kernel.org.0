Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD57363E644
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiLAAPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLAAOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:14:48 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D21E47;
        Wed, 30 Nov 2022 16:08:38 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NMxHm3YjQz4xG6;
        Thu,  1 Dec 2022 11:08:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669853317;
        bh=zWrObo4KxrpcrfavyssUlQcI2HjG+yVpYjVwM2SdgXI=;
        h=Date:From:To:Cc:Subject:From;
        b=jSH9VMTAJXhMqUWm78ZIa9CgA18ETmStFDMRByKtVAsE+N5XWuFVEXl33rDXrAr0F
         hrhwvDXDD9H0erh1mJNQ9Z0iKruk3a0BTVVf0NSys2AIM4thNIkExoELf1hx/uxaMb
         uFY+doAMhqsTjkmKeimXLeic5pt/QxYaWaPkRPgCErSwGPd6ok1UXKagyjsWTMRrT0
         R3G9YP9LRsv3b1i7loOWfPBMF4pfwJFMhWgz6Cl38A2XVQzsbZXYYPRyHzl73oUlrW
         AtSQan5lZ3bSv2Af0KpTAa3YWDw3onpjWhHNctIaP1MaTepJjrhMYRpijn1sVnjaHe
         TdVBiutaIw+cA==
Date:   Thu, 1 Dec 2022 11:08:35 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Peter Xu <peterx@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the block tree
Message-ID: <20221201110835.4e72b8fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RnLRMe_HzLA/FtXo33c4iV1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/RnLRMe_HzLA/FtXo33c4iV1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  include/linux/mm.h

between commit:

  4003f107fa2e ("mm: introduce FOLL_PCI_P2PDMA to gate getting PCI P2PDMA p=
ages")

from the block tree and commit:

  93c5c61d9e58 ("mm/gup: Add FOLL_INTERRUPTIBLE")

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

idiff --cc include/linux/mm.h
index f0eab324102b,3c84f4e48cd7..000000000000
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@@ -2968,7 -2958,7 +2968,8 @@@ struct page *follow_page(struct vm_area
  #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
  #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
  #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup=
 */
 -#define FOLL_INTERRUPTIBLE  0x100000 /* allow interrupts from generic sig=
nals */
 +#define FOLL_PCI_P2PDMA	0x100000 /* allow returning PCI P2PDMA pages */
++#define FOLL_INTERRUPTIBLE  0x200000 /* allow interrupts from generic sig=
nals */
 =20
  /*
   * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with ea=
ch

--Sig_/RnLRMe_HzLA/FtXo33c4iV1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOH8IMACgkQAVBC80lX
0GwI4Qf+KABiBkmorFvdood/Ke8RQ9Dap/QXLUBkBGDt9a1FFMulQ4KcnNOulqbx
yA1b+0Wqo3G/rjl1Ugk3RHeipS4KbNao6gKoWzI4U3/M8NlrhAFSH5mIpmPoGYn9
n+n4YwyKZ9+VAiksCnqCldR/7npXEtJfmpdvRh4HUrnvJFNfxtzC3NFbJTotYsmR
M0hoHQbtrGOwvEsemne/rH8ca4HH3vbkSrWQmUzVpdi8yPp38dxCI7dgu4UA90u6
0xlbDvd7blSPEVIciso3djgWUX4F+FR6QRaOMuLZ/zH2UIhpBAlAicUyGGpaRga2
S8zrwYoXlY/szOl/zw3Xk0WHGYKm4Q==
=TIgK
-----END PGP SIGNATURE-----

--Sig_/RnLRMe_HzLA/FtXo33c4iV1--
