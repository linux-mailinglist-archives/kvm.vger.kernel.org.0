Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B543E39D3B9
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 05:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhFGEAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 00:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGEAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 00:00:45 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEEFC061766
        for <kvm@vger.kernel.org>; Sun,  6 Jun 2021 20:58:54 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Fz03b4Rb1z9sT6; Mon,  7 Jun 2021 13:58:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623038331;
        bh=mV8ib3f1msaftXonM+x4Yhyomn2b+ILhmwZntahsw94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RLoXQP6KVeB1JVRgKLVckEo1NWax49Wvl9Pt8g9Fpu6Mq88SM06S0Rx4G1H1emT4b
         G5LQDtXXXq7P02PxBxlJle6ZPenn6mCw4L0jW4wqn9SxqhtQsXsh7nGoc7ijEi+Rk9
         yt41GsJheZjjwPNITgDX5OzfYMd1wqJA/l2IJSpc=
Date:   Mon, 7 Jun 2021 13:52:10 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Bruno Larsen (billionai)" <bruno.larsen@eldorado.org.br>
Cc:     qemu-devel@nongnu.org, fernando.valle@eldorado.org.br,
        matheus.ferst@eldorado.org.br, farosas@linux.ibm.com,
        lucas.araujo@eldorado.org.br, luis.pires@eldorado.org.br,
        qemu-ppc@nongnu.org, richard.henderson@linaro.org,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH] target/ppc: removed usage of ppc_store_sdr1 in kvm.c
Message-ID: <YL2X6m6mpXQ4cfof@yekko>
References: <20210601184242.122895-1-bruno.larsen@eldorado.org.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+DDARd3aRRs07dny"
Content-Disposition: inline
In-Reply-To: <20210601184242.122895-1-bruno.larsen@eldorado.org.br>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--+DDARd3aRRs07dny
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 01, 2021 at 03:42:42PM -0300, Bruno Larsen (billionai) wrote:
> The only use of this function in kvm.c is right after using the KVM
> ioctl to get the registers themselves, so there is no need to do the
> error checks done by ppc_store_sdr1.
>=20
> The probable reason this was here before is because of the hack where
> KVM PR stores the hash table size along with the SDR1 information, but
> since ppc_store_sdr1 would also store that information, there should be
> no need to do any extra processing here.
>=20
> Signed-off-by: Bruno Larsen (billionai) <bruno.larsen@eldorado.org.br>
> ---
>=20
> This change means we won't have to compile ppc_store_sdr1 when we get
> disable-tcg working, but I'm not working on that code motion just yet
> since Lucas is dealing with the same file.
>=20
> I'm sending this as an RFC because I'm pretty sure I'm missing
> something, but from what I can see, this is all we'd need

I don't think this is a good idea.  Even though it's not strictly
necessary for KVM, I'd prefer to have a common entry point for SDR1
updates to reduce confusion.  Plus this won't be sufficient to fix
things for !TCG builds, since we still have the common calls on the
loadvm path.

>=20
>  target/ppc/kvm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 104a308abb..3f52a7189d 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -1159,7 +1159,11 @@ static int kvmppc_get_books_sregs(PowerPCCPU *cpu)
>      }
> =20
>      if (!cpu->vhyp) {
> -        ppc_store_sdr1(env, sregs.u.s.sdr1);
> +        /*
> +         * We have just gotten the SDR1, there should be no
> +         * reason to do error checking.... right?
> +         */
> +        env->spr[SPR_SDR1] =3D sregs.u.s.sdr1;
>      }
> =20
>      /* Sync SLB */

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--+DDARd3aRRs07dny
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC9l+oACgkQbDjKyiDZ
s5Lfuw//XmNsvqY9rzssSKrU0tClRdUqyJy/wdFCA89+8uuOuUGSNaJznRLCbgZd
FnezH8KKbxxn8wo0BnZG6roUeJE47+FBUB4RzS+WCXShXNJI5yu5HbzfPWFaGOyq
3rOgFEI8Og3pC62e7Fng9bSsL2XDwU9EAp7zAJVPn07kimp4Jsyr0Na3LXppR04h
GbWDLKztvOiLcOHbuQT7WTykoyB36WrfF/EEoGjUaYhGw9N4rbJPfTIYS6gG/0Jm
CfvyVpKs0eNJoY1axiAVKoWKZR60zWhL5wabNj8l8iRi5zt2yocQeEvsZxy6HsII
lREmw39NhfbqGdTv50BnNaEGitlk+EEMRxhDdPE9+zQh+UHEkVGU6eTnsyoPvDU+
Q5V0yWcIgi+9aHlSPJ+74YWgfRDoW2rGJAY5etieJPmke2jLWkw/uuhY3VU0czmy
GfRDnHpbIFSePT0Vz7oYQCRXVg1bFp0nxmbO1VkuFpkgEi6njmsOUUzyURNY/kAs
VgFlXvwaUbdbEbkhr8KxnXmNuU4vT2QbMttUZvY+rAkQKUVRzk2hTAQ97O0q+6+6
O93ar8TQLQ9iUz1e90zMz5xKq+JFvt3XUCEfomXMRKtz3YZpzOFaVmpY2oFsSctT
mq0DbIxYqu3K20qjw/WkgfVY9W9u0lbwasiZZMpUnyQZymRvkb8=
=8/jU
-----END PGP SIGNATURE-----

--+DDARd3aRRs07dny--
