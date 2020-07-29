Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDE5231A05
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 09:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgG2HGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 03:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgG2HGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 03:06:06 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786E7C061794;
        Wed, 29 Jul 2020 00:06:06 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BGl245FFpz9sSd;
        Wed, 29 Jul 2020 17:06:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596006365;
        bh=SfAf+m4iEwdrS7l7HGsDBbqAFb+OtlgvWiqP1GSnX9s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cso8UQKES9SKN7dIUje/dvNkXft+78lNG+EuNRoEx1tEvYsKcO0+fjOeLXb9h0t2e
         ra9a6k9P6xbCBYekb/kGpUexaanNzUmPorO18lePP0/1aUIM7P6oWkF0tiozs/t0a4
         xeXoApjBreRBFEcgxABFSzOtRhqgWUP0rHk5GzkIMOLDwP/EefsxwYiprcPAohc0o5
         RBDUYkM45CYGOChDcsNRCua+ekjs2MILuuQXUposnEf4vfMSkxwlqv459bKwj1soxM
         TyXYJUC9pNHUnuG/86HsMsyM++SvQlrNBlPgGNsgOG0D+EzeIdDkWhBBsezp4lOaxS
         aXNHknnclKSjw==
Date:   Wed, 29 Jul 2020 17:06:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20200729170603.526fa60f@canb.auug.org.au>
In-Reply-To: <20200717155701.2d7caebb@canb.auug.org.au>
References: <20200717155701.2d7caebb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CjF1.yBgWInn=gJ7WvN56Vb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/CjF1.yBgWInn=gJ7WvN56Vb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 17 Jul 2020 15:57:01 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> arch/x86/kernel/kvm.c: In function '__sysvec_kvm_asyncpf_interrupt':
> arch/x86/kernel/kvm.c:275:13: error: implicit declaration of function 'id=
tentry_enter_cond_rcu'; did you mean 'idtentry_enter_nmi'? [-Werror=3Dimpli=
cit-function-declaration]
>   275 |  rcu_exit =3D idtentry_enter_cond_rcu(regs);
>       |             ^~~~~~~~~~~~~~~~~~~~~~~
>       |             idtentry_enter_nmi
> arch/x86/kernel/kvm.c:286:2: error: implicit declaration of function 'idt=
entry_exit_cond_rcu'; did you mean 'idtentry_exit_nmi'? [-Werror=3Dimplicit=
-function-declaration]
>   286 |  idtentry_exit_cond_rcu(regs, rcu_exit);
>       |  ^~~~~~~~~~~~~~~~~~~~~~
>       |  idtentry_exit_nmi
>=20
> Caused by commit
>=20
>   b037b09b9058 ("x86/entry: Rename idtentry_enter/exit_cond_rcu() to idte=
ntry_enter/exit()")
>=20
> from the tip tree interacting with commit
>=20
>   26d05b368a5c ("Merge branch 'kvm-async-pf-int' into HEAD")
>=20
> from the kvm tree.
>=20
> I have applied the following merge fix patch.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 17 Jul 2020 15:51:27 +1000
> Subject: [PATCH] fix up for idtentry_{enter,exit}_cond_rcu() renaming
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/kernel/kvm.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index cebd96687194..91dd322f768d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -270,9 +270,9 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
>  {
>  	struct pt_regs *old_regs =3D set_irq_regs(regs);
>  	u32 token;
> -	bool rcu_exit;
> +	idtentry_state_t state;
> =20
> -	rcu_exit =3D idtentry_enter_cond_rcu(regs);
> +	state =3D idtentry_enter(regs);
> =20
>  	inc_irq_stat(irq_hv_callback_count);
> =20
> @@ -283,7 +283,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
>  		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
>  	}
> =20
> -	idtentry_exit_cond_rcu(regs, rcu_exit);
> +	idtentry_exit(regs, state);
>  	set_irq_regs(old_regs);
>  }
> =20

Now due to commits

  bdcd178ada90 ("x86/entry: Use generic interrupt entry/exit code")
  a27a0a55495c ("x86/entry: Cleanup idtentry_enter/exit")

The above patch now looks like this:

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
+	irqentry_state_t state;
=20
-	rcu_exit =3D idtentry_enter_cond_rcu(regs);
+	state =3D irqentry_enter(regs);
=20
 	inc_irq_stat(irq_hv_callback_count);
=20
@@ -283,7 +283,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
 	}
=20
-	idtentry_exit_cond_rcu(regs, rcu_exit);
+	irqentry_exit(regs, state);
 	set_irq_regs(old_regs);
 }
=20
--=20
2.27.0

--=20
Cheers,
Stephen Rothwell

--Sig_/CjF1.yBgWInn=gJ7WvN56Vb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8hH9wACgkQAVBC80lX
0GxSAQf/RhZ9DUKnhCWXxI04X9vcCW1QYyRRvONerN9mMkLIkJj8G0XJ/DdxlV7b
IvhoAJPU2k9tX5JrqRRhTQEd7tdtBHJMnoOQJxjkzzK+0SriS3x33V41nz0sMpI1
ZUi79Si9CLngYt4IfkzI7cL7IPk8zXzMjpiihSqvPQZtrgimvw58uD4KlqtQLdq+
CQTCEg8C3Ctw4IHy9wa65UgjfaeEP6Z2iHSnWu/YFOp2V7aWpnPD8CEtQG/l9RVP
aCYzhfkQlkiZ3vlW4Q1xf3MoAu5Louk137Xc3/Ma9wxhGLOFxPExCF2XVAvdmJUu
QMZeuSrHIXEs2I1vqEP9mCuSnKnIKg==
=cTfq
-----END PGP SIGNATURE-----

--Sig_/CjF1.yBgWInn=gJ7WvN56Vb--
