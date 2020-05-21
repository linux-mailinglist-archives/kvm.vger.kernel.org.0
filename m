Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E161DC70B
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 08:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgEUG27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 02:28:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51501 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgEUG26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 02:28:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49SKT31jHSz9sT8;
        Thu, 21 May 2020 16:28:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590042536;
        bh=4aGvZd/60yfG45VzmIh3YI/neYvcqholgfnSpAb2LPc=;
        h=Date:From:To:Cc:Subject:From;
        b=YQmRuFQ23F6R6pGXi6pJElvnF4hMRgCR9CD0IPF2A4giCXnuAN0gmNAtXQi5QeLaU
         JdHA0NnBj5x3Q7KadBmGZkjN60ldZHkx/1hYhvPBeQgp9Z0VjhGxB+uOt34c4ozA1A
         XYsa/8WyjSn42P9GFOncUOz+/NHk1EDQix8A1NL9MwfzSp5rdRvXLC8XwMdybqj9ez
         0f/hEWif2nXvv/tidiY4FhnJedkTar6A1MOsomLbjS6HuVf6VizMox83ohlJ9sL8cx
         tZoIOjjwoOZyQ5TDKDK4xcO895s+u7EWJxZicPqs7zEwtJQGlCmOtSBdVGuBXJ/iA+
         mTMPGSLctdJ+Q==
Date:   Thu, 21 May 2020 16:28:54 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: linux-next: build failure after merge of the kvm tree
Message-ID: <20200521162854.70995699@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kRUYmA7Ax=s.v5n_hXDTMi5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/kRUYmA7Ax=s.v5n_hXDTMi5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/kvm/svm/svm.c: In function 'kvm_machine_check':
arch/x86/kvm/svm/svm.c:1834:2: error: too many arguments to function 'do_ma=
chine_check'
 1834 |  do_machine_check(&regs, 0);
      |  ^~~~~~~~~~~~~~~~
In file included from arch/x86/kvm/svm/svm.c:36:
arch/x86/include/asm/mce.h:254:6: note: declared here
  254 | void do_machine_check(struct pt_regs *pt_regs);
      |      ^~~~~~~~~~~~~~~~

Caused by commit

  1c164cb3ffd0 ("KVM: SVM: Use do_machine_check to pass MCE to the host")

interacting with commit

  aaa4947defff ("x86/entry: Convert Machine Check to IDTENTRY_IST")

from the tip tree.

I added the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 21 May 2020 16:24:59 +1000
Subject: [PATCH] KVM: SVM: fix up for do_machine_check() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ae287980c027..7488c8abe825 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1831,7 +1831,7 @@ static void kvm_machine_check(void)
 		.flags =3D X86_EFLAGS_IF,
 	};
=20
-	do_machine_check(&regs, 0);
+	do_machine_check(&regs);
 #endif
 }
=20
--=20
2.26.2

--=20
Cheers,
Stephen Rothwell

--Sig_/kRUYmA7Ax=s.v5n_hXDTMi5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7GH6YACgkQAVBC80lX
0GyKEwf/QaFM0a89iomF2hN2IEy0NIKFRVhaO2uhFSmTsgbtQOH8ViuzREPlWjUI
8BTtFJ28yru5hTLNb7nqVprEZCY7t6iOqVRWd5MTNqVqLffn7nCmcsBhKBaEyCWS
Q4dzRJ3UMe0Ll8zA9qikZMevuDLXDEad8asXUIP5ofo5u9ouQOcU0XGC/eNY8WxK
rGne3B3mSUNCCSZv9oMgVfi12/xLLujtEVeVj42i814KAtMYDM20uTmDQTPjGyLQ
KcRFHBim1QX0WiA6QN+HhoutvJpRMwrZhSm7W5RCNTI1tWK1cdir6FtRKmucjP+r
9v/xiu8T9afsY0n0g18SFMRdGjj/cA==
=0/Xc
-----END PGP SIGNATURE-----

--Sig_/kRUYmA7Ax=s.v5n_hXDTMi5--
