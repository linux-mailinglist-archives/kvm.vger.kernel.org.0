Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8684A2067C5
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 01:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbgFWXAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 19:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387606AbgFWXAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 19:00:35 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AE2C061573;
        Tue, 23 Jun 2020 16:00:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49s1vy3D5Wz9s1x;
        Wed, 24 Jun 2020 09:00:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592953233;
        bh=KPI3aAUIMWOgw1b5tXl9B51uLxeA81au0UgltAmeN6U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EkIXFub/WzsMZ+H1Ralc3gj/qmMIfcAtcnviBfxlxctDYfwGaiNZnImNIIO63lYY5
         Dr1FQGblvHue0YFe8kEV6C/vmiPDk6ZhxybbP5QqsPKjAAY7VToPXAmJUHWxv//ne7
         iyKvfBpH1KAZev3MfY6XqZLv5Us2toeZ8vZaVYLDuuaE+3LVaFjKKQ1axbEyRKO5Bn
         SpTbpmTuK23m+NQVA6Cx6byInmz0Ovxg76eVYqEOf5hrN1UvO/LFAE9TLcYmL3SpF1
         t8p5Cvuh6aSWAPmMdWY7mkJUUzQkK9qNMYFJZWmTV9vQAxxTr1Fj0S9CIRTv2WWtn2
         9Mg8HrmvY4f8Q==
Date:   Wed, 24 Jun 2020 09:00:29 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marco Elver <elver@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        syzbot <syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Subject: Re: linux-next build error (9)
Message-ID: <20200624090029.5fa2dc1f@canb.auug.org.au>
In-Reply-To: <20200623112448.GA208112@elver.google.com>
References: <000000000000c25ce105a8a8fcd9@google.com>
        <20200622094923.GP576888@hirez.programming.kicks-ass.net>
        <20200623124413.08b2bd65@canb.auug.org.au>
        <20200623093230.GD4781@hirez.programming.kicks-ass.net>
        <20200623201730.6c085687@canb.auug.org.au>
        <20200623112448.GA208112@elver.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vx20BsoZP5nc+1hY2szmS6d";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/vx20BsoZP5nc+1hY2szmS6d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Marco,

On Tue, 23 Jun 2020 13:24:48 +0200 Marco Elver <elver@google.com> wrote:
>
> On Tue, Jun 23, 2020 at 08:17PM +1000, Stephen Rothwell wrote:
> > Hi Peter,
> >=20
> > On Tue, 23 Jun 2020 11:32:30 +0200 Peter Zijlstra <peterz@infradead.org=
> wrote: =20
> > >
> > > I suppose the next quest is finding a s390 compiler version that works
> > > and then bumping the version test in the aforementioned commit. =20
> >=20
> > Not a lot of help, but my Debian cross compiler seems to work:
> >=20
> > $ s390x-linux-gnu-gcc --version
> > s390x-linux-gnu-gcc (Debian 9.3.0-13) 9.3.0 =20
>=20
> Rummaging through changelogs led me to 8.3.0 as the first good GCC. Also
> confirmed by building that version and compiling a file that breaks with
> older versions. It seems the first major version to fix it was 9, but
> backported to 8.3. This is for all architectures.
>=20
> Suggested patch below.
>=20
> Thanks,
> -- Marco
>=20
> ------ >8 ------ =20
>=20
> From: Marco Elver <elver@google.com>
> Date: Tue, 23 Jun 2020 12:57:42 +0200
> Subject: [PATCH] kasan: Fix required compiler version
>=20
> The first working GCC version to satisfy
> CC_HAS_WORKING_NOSANITIZE_ADDRESS is GCC 8.3.0.
>=20
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D89124
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  lib/Kconfig.kasan | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
> index 7a496b885f46..19fba15e99c6 100644
> --- a/lib/Kconfig.kasan
> +++ b/lib/Kconfig.kasan
> @@ -16,7 +16,7 @@ config CC_HAS_KASAN_SW_TAGS
>  	def_bool $(cc-option, -fsanitize=3Dkernel-hwaddress)
> =20
>  config CC_HAS_WORKING_NOSANITIZE_ADDRESS
> -	def_bool !CC_IS_GCC || GCC_VERSION >=3D 80000
> +	def_bool !CC_IS_GCC || GCC_VERSION >=3D 80300
> =20
>  config KASAN
>  	bool "KASAN: runtime memory debugger"
> --=20
> 2.27.0.111.gc72c7da667-goog
>=20

Thanks for tracking that down.  I will add that patch to the tip tree
merge for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/vx20BsoZP5nc+1hY2szmS6d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7yiY0ACgkQAVBC80lX
0Gytxwf/XSrFXKqHN67FRDF9pjKF802HQJnp4w+90WqMxbbxwr3+eodMzrTQMOBG
5qW60CEHccXVmT3ErY7S4fqBV/4a/gUzSZIqWIuckfSBJDWM8SD3480SWTtWKTTc
sR3Bk1jKyd+NSsA3b2gVgzWyzDKwQqFofPVZVWyNrsPq7wlOQdx/gYG0PvXXxmpo
poRcjeAOeLL5CDAZysCTA0mwptdkiYBYZqZ0Hh8Uq9t4aVzaq/8DUCrkN6CdTh0T
Epm0SVi+CrXDBKIskh9MLBRGimc9g7w9BnxYZlA0ek+PBDZTHfBTpY+LFvUbMbDE
c25DPzSkr4ftsJMLqsiFHvs27ETbKA==
=jf2S
-----END PGP SIGNATURE-----

--Sig_/vx20BsoZP5nc+1hY2szmS6d--
