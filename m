Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68C52F26CF
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 04:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbhALDu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 22:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbhALDu2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 22:50:28 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170C9C061786
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 19:49:47 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFGmS1c5Lz9sXV; Tue, 12 Jan 2021 14:49:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610423384;
        bh=Pu1uUI8cNnCK2d3m6U8+RaJ5aZcbiR7kyAyYwXtPDOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ku44Fn78DbjaIJuAGpIfkU4xhTwyz2zi06RWXMpVl2F9BEDULeIBwF+2ZsEtGx9CT
         TWK+jxKmW2qGK7TUCVF48Kz/uxH3cZM/rje1K4JfEN/PVHC50rjek0GjqF/Qo5oK9/
         EGTXYBh6R6fqw2DbU5/GVMVRL5DkNt/3EOS9eZmI=
Date:   Tue, 12 Jan 2021 14:49:35 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 03/13] securable guest memory: Handle memory
 encryption via interface
Message-ID: <20210112034935.GL3051@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-4-david@gibson.dropbear.id.au>
 <20201204141005.07bf61dd.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/ZYM6PqDyfNytx60"
Content-Disposition: inline
In-Reply-To: <20201204141005.07bf61dd.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/ZYM6PqDyfNytx60
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 04, 2020 at 02:10:05PM +0100, Cornelia Huck wrote:
> On Fri,  4 Dec 2020 16:44:05 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > At the moment AMD SEV sets a special function pointer, plus an opaque
> > handle in KVMState to let things know how to encrypt guest memory.
> >=20
> > Now that we have a QOM interface for handling things related to securab=
le
> > guest memory, use a QOM method on that interface, rather than a bare
> > function pointer for this.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> > ---
> >  accel/kvm/kvm-all.c                   |  36 +++++---
> >  accel/kvm/sev-stub.c                  |   9 +-
> >  include/exec/securable-guest-memory.h |   2 +
> >  include/sysemu/sev.h                  |   5 +-
> >  target/i386/monitor.c                 |   1 -
> >  target/i386/sev.c                     | 116 ++++++++++----------------
> >  6 files changed, 77 insertions(+), 92 deletions(-)
> >=20
>=20
> > @@ -224,7 +224,7 @@ int kvm_get_max_memslots(void)
> > =20
> >  bool kvm_memcrypt_enabled(void)
> >  {
> > -    if (kvm_state && kvm_state->memcrypt_handle) {
> > +    if (kvm_state && kvm_state->sgm) {
>=20
> If we want to generalize the concept, maybe check for encrypt_data in
> sgm here? There's probably room for different callbacks in the sgm
> structure.

Actually, I've realised this isn't even as general as it pretends to
be now, so I've taken a different approach for the next spin.

>=20
> >          return true;
> >      }
> > =20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/ZYM6PqDyfNytx60
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/9HE0ACgkQbDjKyiDZ
s5Js5A//Yd7jTZccBJbYr8fl6LwL5XR1I53MZzJBdb0mQjdbnkUlRxWOwGoIzTOh
hMTP7/m3oKzOePEV76IwEhBIouuYuPALTpP1cOnZdg4kDzKsln+36tP1VA2pMAm3
l2xL6WxqUjdMpXzH5oD3+0FdOLplr7bXGtMZW9vBhGDluLdR5uyfYLveJwswwwHo
72mdv3zcDQ6BSChR8MijtPuKpLWfkuKuyGAtSy2ovQNZfHqEIq9XmstPqFAvCsA/
aKXg2fA7qMm0507tAjdlKXBuSvnxy0O72Kyvl73L+Ipw+gyiZKSnKYpexPODFyLt
oN3ZYYb8zphWnDlr/7DjTJDfMpyxxOFjLkE6WMa84eWSi1G8IXJ1CJcDd+0tHtlr
5J26cpGXl/L3Z82bIctc2qJp5CGWNhahRr2ThdEnQebh+3wzW9O6CyF0w3+cY5QX
19kqHodasjj+ige37V6LU0tfEn2jJ7bGyIHedJBnTryNlWK9+OIj5inUvvxpNNg+
KTIsLiphN+6Zr7v5/uCoDmmK6LPOn+8yOf9m2tHfmmRqtUbXkXqiFKSw0Al1vKbZ
o2E6yoWGNFI7Y9YKzoKtoge3qdU2BHgt71nnXo3+1WM9i16vTCjr8zH2UaIqoeXL
wGPq0aoODgI8G2ZQmiEbc0ieQZcIvYPqh8TaSb+gdf47wy2dQ50=
=M33/
-----END PGP SIGNATURE-----

--/ZYM6PqDyfNytx60--
