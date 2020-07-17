Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB0022332B
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 07:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGQF5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 01:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgGQF5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 01:57:09 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B03EC061755;
        Thu, 16 Jul 2020 22:57:09 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B7L3z5kSgz9sQt;
        Fri, 17 Jul 2020 15:57:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594965425;
        bh=pogloshOGM434OcRKBF6s6ykZvFgAvuWoOESdMeuiYQ=;
        h=Date:From:To:Cc:Subject:From;
        b=Qh6uvWzU9USOoVdsHuNu9fBrdoTUryAb8L7RQvx42+KbM904Jpg/QAkQVAzaoCEWd
         TYd71mEQtOaxgHgVkBEu7L8kn14f2SbliwRKDAcyU/KTeG05Bv+MqKF9Xi//sa5UkL
         BzNBXO6HwX6qz5LmOPHV9eTmhV2YWZS9eyhac3rBSnrRCPAwxackvwxhOU52Ni8uJN
         IzusT8QiRIzNqHR/Les5DWWLeLA96mxB+tLEjAVFP4+yiU6p9BPvpoJHkrLMyEnCKx
         W0pDwPPaZHpO/t+JesjlkDXhVIZbu8pmfJRfkvO08lZRJxAxm7Ekvv8duZRNshXgi+
         rgyqV0Ey1ytXQ==
Date:   Fri, 17 Jul 2020 15:57:01 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20200717155701.2d7caebb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/A2+892SpS7JbA5SH7D40+2e";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/A2+892SpS7JbA5SH7D40+2e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/kernel/kvm.c: In function '__sysvec_kvm_asyncpf_interrupt':
arch/x86/kernel/kvm.c:275:13: error: implicit declaration of function 'idte=
ntry_enter_cond_rcu'; did you mean 'idtentry_enter_nmi'? [-Werror=3Dimplici=
t-function-declaration]
  275 |  rcu_exit =3D idtentry_enter_cond_rcu(regs);
      |             ^~~~~~~~~~~~~~~~~~~~~~~
      |             idtentry_enter_nmi
arch/x86/kernel/kvm.c:286:2: error: implicit declaration of function 'idten=
try_exit_cond_rcu'; did you mean 'idtentry_exit_nmi'? [-Werror=3Dimplicit-f=
unction-declaration]
  286 |  idtentry_exit_cond_rcu(regs, rcu_exit);
      |  ^~~~~~~~~~~~~~~~~~~~~~
      |  idtentry_exit_nmi

Caused by commit

  b037b09b9058 ("x86/entry: Rename idtentry_enter/exit_cond_rcu() to idtent=
ry_enter/exit()")

from the tip tree interacting with commit

  26d05b368a5c ("Merge branch 'kvm-async-pf-int' into HEAD")

from the kvm tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 17 Jul 2020 15:51:27 +1000
Subject: [PATCH] fix up for idtentry_{enter,exit}_cond_rcu() renaming

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/kvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index cebd96687194..91dd322f768d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -270,9 +270,9 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 {
 	struct pt_regs *old_regs =3D set_irq_regs(regs);
 	u32 token;
-	bool rcu_exit;
+	idtentry_state_t state;
=20
-	rcu_exit =3D idtentry_enter_cond_rcu(regs);
+	state =3D idtentry_enter(regs);
=20
 	inc_irq_stat(irq_hv_callback_count);
=20
@@ -283,7 +283,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
 	}
=20
-	idtentry_exit_cond_rcu(regs, rcu_exit);
+	idtentry_exit(regs, state);
 	set_irq_regs(old_regs);
 }
=20
--=20
2.27.0

--=20
Cheers,
Stephen Rothwell

--Sig_/A2+892SpS7JbA5SH7D40+2e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8RPa0ACgkQAVBC80lX
0Gz2TggAl6/wSCerW01gjKj4t12AMidEFOAeQs+6Wu9p8rYdNsggQaPG4Y3mMJtr
T44siKA0jHZ4iHFm/8BrjopwqDcJ5EGoOqAGm1MVOHZILE4Pjg22yxvJm5kc/1aQ
8fxTiGMc5H5ntKpkeVlsVr+tumcQf1yAtQYhkHGbEloeVHBVS98rQkBzq/9ERLoN
4DuLnOw6lalilJBSinhs431OzZL243An4aX+Li2S6rn57k9tNVd54xFzNGtUE3B6
SRpG3twknomwuHVNDDFyL7EQ/eAZg8W2v5YGSqIe9YPvDL3M+Zjrfcsd9bwhD1+T
5ieVxU+gK1WbvteqeTQGI4xQCndvtA==
=rcvQ
-----END PGP SIGNATURE-----

--Sig_/A2+892SpS7JbA5SH7D40+2e--
