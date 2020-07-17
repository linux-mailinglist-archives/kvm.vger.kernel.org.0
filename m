Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3CC2232E5
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 07:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgGQF0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 01:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgGQF0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 01:26:02 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44F4C061755;
        Thu, 16 Jul 2020 22:26:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B7KN65K28z9sRR;
        Fri, 17 Jul 2020 15:25:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594963560;
        bh=LbMvc5Iklk5Xyio7B6Dc+w1qLyJXPJQeJsnn4jpFg6Y=;
        h=Date:From:To:Cc:Subject:From;
        b=HSs0Kgl9Ta8tvTHe1BgLFTd26tXH473RBtQnTuMJip+2hTgbOqhFvIajhjWyILvAF
         g+EguwyXjq0+GhXfUoV/0j1GM+DaGaBSxkZCOmGNX7PLr4sgF3RsftUYTwQIQwgLOi
         fhnXKyCAMTV9PitJ4MNxcU/v7n6fpOWTmumDIaZMfcmFkeNbXVXlVKUJi6ysLan6JI
         FMo+eMIND3AvXNbCn39S89ng9qYc/49CiVFsLn7GTkx0gs3bG8JBQgWGtgFDGcZl1m
         KUno5e80DQIsubaqIYgJdIWvYtYmsh25MIcy1vxNO+Bycmt5gLddFPnoUR3GE91njm
         Vso4KK27is2Kg==
Date:   Fri, 17 Jul 2020 15:25:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20200717152557.49ca6764@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/uTbsuNq/+Q2QD.tf4=F9Ue7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/uTbsuNq/+Q2QD.tf4=F9Ue7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kernel/kvm.c

between commit:

  b037b09b9058 ("x86/entry: Rename idtentry_enter/exit_cond_rcu() to idtent=
ry_enter/exit()")

from the tip tree and commit:

  b1d405751cd5 ("KVM: x86: Switch KVM guest to using interrupts for page re=
ady APF delivery")

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

diff --cc arch/x86/kernel/kvm.c
index 3f78482d9496,d9995931ea18..000000000000
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@@ -232,18 -235,13 +235,13 @@@ EXPORT_SYMBOL_GPL(kvm_read_and_reset_ap
 =20
  noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
  {
- 	u32 reason =3D kvm_read_and_reset_apf_flags();
+ 	u32 flags =3D kvm_read_and_reset_apf_flags();
 -	bool rcu_exit;
 +	idtentry_state_t state;
 =20
- 	switch (reason) {
- 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
- 	case KVM_PV_REASON_PAGE_READY:
- 		break;
- 	default:
+ 	if (!flags)
  		return false;
- 	}
 =20
 -	rcu_exit =3D idtentry_enter_cond_rcu(regs);
 +	state =3D idtentry_enter(regs);
  	instrumentation_begin();
 =20
  	/*

--Sig_/uTbsuNq/+Q2QD.tf4=F9Ue7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8RNmUACgkQAVBC80lX
0GyLnAf+JEDs0FjozNrM0bFizJ/eK1Z66gfGFZ/26fWbMM5oot3q2R6YP2+D+g5Z
VIoed+WHh1aHeXrrN3nKtGP+Z8NpuiIx3HKa1Tu9dCroEgHUS/xdz3eZ5Jf/MlF3
yFxY1GxOtoAp4WT9n2hVA07V6CLvf2Y/x/rueS2rDE8PODZdWdQHaaBR/++a1DWU
UEOyDXs/Kic6xHj9jhggqkYOxIIk0V1TrCkh42x0p1pxh0P4NwVUUSl/55N0e6Lq
nPqD5CQZEkHLswKgD/r3EzMqEub+oA1tZhWpFueNwwj+KZ5G9e0Qkc7Xirr5LBDI
RBo0ONnFW19DoPMZtuj/2Jb0GzWZzQ==
=S/OY
-----END PGP SIGNATURE-----

--Sig_/uTbsuNq/+Q2QD.tf4=F9Ue7--
