Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2571EDB6F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 04:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgFDCyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 22:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDCyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 22:54:38 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EF2C03E96D;
        Wed,  3 Jun 2020 19:54:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49cr3J3ylFz9sSc;
        Thu,  4 Jun 2020 12:54:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591239277;
        bh=VDSt+L9FTNZd1aTV4qG1+DRbMcoJ1bNPOKptE+HomBY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=exrcuh0ttF7VJs9YQR6mYlPsHSfPRAC4Y9Dp5roMJp0XlK6w8Oj1Zt+ln/l/Nzwm/
         9a4UbLVRumMN3s7v9MttjxsIU7nmoC33YR4wJDQCYslWb+hpfKIW3pwE7Pcv5TZdv4
         R6NvMeB6+I0ZsOs9azDDsX9flqjWQfUaiT+dG9JTXJptgtAtWdVFer5vjvjfgW/SQ7
         v0hlFTsj2iMqGRIjDWrbQLKk1p3bgF3fk0RZDHqI5JOGqp+UfBLSFOjOuj2orcCiEN
         h1lvJyKxBuWVg+EYeLyF6jYs7dzUCVtvOzEFv9crFx6lYhMM4x7x98ME/1Mk+k3ykT
         ncKy1lm76VRsQ==
Date:   Thu, 4 Jun 2020 12:54:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20200604125435.6505fe96@canb.auug.org.au>
In-Reply-To: <20200521162854.70995699@canb.auug.org.au>
References: <20200521162854.70995699@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4sekqo98_Ne_x5b5whad_WZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/4sekqo98_Ne_x5b5whad_WZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 21 May 2020 16:28:54 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> arch/x86/kvm/svm/svm.c: In function 'kvm_machine_check':
> arch/x86/kvm/svm/svm.c:1834:2: error: too many arguments to function 'do_=
machine_check'
>  1834 |  do_machine_check(&regs, 0);
>       |  ^~~~~~~~~~~~~~~~
> In file included from arch/x86/kvm/svm/svm.c:36:
> arch/x86/include/asm/mce.h:254:6: note: declared here
>   254 | void do_machine_check(struct pt_regs *pt_regs);
>       |      ^~~~~~~~~~~~~~~~
>=20
> Caused by commit
>=20
>   1c164cb3ffd0 ("KVM: SVM: Use do_machine_check to pass MCE to the host")
>=20
> interacting with commit
>=20
>   aaa4947defff ("x86/entry: Convert Machine Check to IDTENTRY_IST")
>=20
> from the tip tree.
>=20
> I added the following merge fix patch.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 21 May 2020 16:24:59 +1000
> Subject: [PATCH] KVM: SVM: fix up for do_machine_check() API change
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ae287980c027..7488c8abe825 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1831,7 +1831,7 @@ static void kvm_machine_check(void)
>  		.flags =3D X86_EFLAGS_IF,
>  	};
> =20
> -	do_machine_check(&regs, 0);
> +	do_machine_check(&regs);
>  #endif
>  }
> =20
> --=20
> 2.26.2

This fix is now needed whe the tip tree merges with Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/4sekqo98_Ne_x5b5whad_WZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7YYmsACgkQAVBC80lX
0GyIhgf+JAqQ3tXuwT3gUG/OkbE8w50IQxkFHo2P1Akk+CVddd94/rxeTcf7YA6b
gdb0pFI90QVtL5XHoLrvnm25Q8bq7iuiIVi9dWQsSgMomwYy0lF9/IF2IHViknkt
dEreUw1dfBW19rwwHrnAQy3INAXQgD8tHLe/SAzpH6zDcocWzEASzBAujLMyrMzX
nZ0yJAs6ehvI/E8OO8R2Zn1uMhEJ0ehSAT53mvJWH7tBwhub4Sw6ACdepJjprIYm
ewqi4Z+IJRQL3CREureMSqpZ+c/X1B9C4SRLHwWZvckIc4DjKliGBd9BMyf9SVcw
iRIKoqpxTTNGT5+qw/P7PjI2IPNi8g==
=TkYW
-----END PGP SIGNATURE-----

--Sig_/4sekqo98_Ne_x5b5whad_WZ--
