Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84C8623993
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 03:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiKJCJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 21:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiKJCJZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 21:09:25 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EAFFAE0;
        Wed,  9 Nov 2022 18:09:24 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N74yn6VjLz4xGT;
        Thu, 10 Nov 2022 13:09:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668046162;
        bh=yYAo6orz4PQyawTZ7XwqSAZd30ekfwNX0vXirxhu7Io=;
        h=Date:From:To:Cc:Subject:From;
        b=uMg7Ib9z5n/UMhs/NawTAZl6UMVnz48f6bIyvSr/lMhfooUcxV2VkwzKxMC3lOqSO
         Z2L7b5rKhAXDPVkkAN9PeIpmBrxmtRXMckShWJXoPVdzHykB81E/uANHunhvgjK33a
         M76qvUfqYL2y43oviV5y8GSmYbceNZNOzYy9MYAw8ZQgf6GT7/fwJUR9h4t2JavKmM
         H7+TG9unPQEtTgCa5l+HhI56vk8yUtrs9UPJ0MlWrFc2GBF2By7dTGN+uuzcis3NXq
         pBtCLrrvP5DLkQQRUJ6aGEUkUSPb4OARI7XR6hlDyJuOgBLThxc9JipXtnf7Je2vNL
         R+DPRtWeAZRtA==
Date:   Thu, 10 Nov 2022 13:09:20 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the tip tree with the kvm-fixes tree
Message-ID: <20221110130920.55a7d583@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/I/CbxKwYia5swyvyn4Bfs1N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/I/CbxKwYia5swyvyn4Bfs1N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  arch/x86/kernel/asm-offsets.c

between commit:

  debc5a1ec0d1 ("KVM: x86: use a separate asm-offsets.c file")

from the kvm-fixes tree and commits:

  c063a217bc07 ("x86/percpu: Move current_top_of_stack next to current_task=
")
  5d8213864ade ("x86/retbleed: Add SKL return thunk")

from the tip tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kernel/asm-offsets.c
index 437308004ef2,13afdbbee349..000000000000
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@@ -107,4 -108,14 +107,9 @@@ static void __used common(void
  	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
  	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
  	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
+=20
+ 	OFFSET(X86_top_of_stack, pcpu_hot, top_of_stack);
+ #ifdef CONFIG_CALL_DEPTH_TRACKING
+ 	OFFSET(X86_call_depth, pcpu_hot, call_depth);
+ #endif
 -
 -	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
 -		BLANK();
 -		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
 -	}
  }

--Sig_/I/CbxKwYia5swyvyn4Bfs1N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNsXVAACgkQAVBC80lX
0GyyFgf/QVGuyy/XIJyjdNpwPzzP5l2bC3sXYNTjngCNytpK65voxV4L4Tyh957D
QUqCwWzj8bcz+rHWHZxlY5Nn+S+NKnjb2I3OzG6S6PItIey2jdh2tDxVC5wj5mC4
bIqES7erhaPfpGFw1E9sbYwglY/5fZHIl3kY6AHi0V2BwXda92a+CBT+5fHNC9Ne
R6gXMy/qAOJdM4lo5nm4dsyjDrU7jVCIxzx3AjjELf1Gu3y/rMXTTP+XI1YuFwrw
t6NgbvMa2zkWFxgXU+5d/2eq54oZFZ9A0xkRJeqklJ2/jrwijCBBlIbQb8nDZWUD
1+BQKj7v1LLIOhe6R6bXsbsKw35U3Q==
=3u65
-----END PGP SIGNATURE-----

--Sig_/I/CbxKwYia5swyvyn4Bfs1N--
