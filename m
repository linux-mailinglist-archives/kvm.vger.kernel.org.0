Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E7A2EECD9
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 06:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbhAHFUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 00:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHFUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 00:20:12 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C500DC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 21:19:31 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DBrxq326Mz9sWm; Fri,  8 Jan 2021 16:19:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610083167;
        bh=yM+GSG4Blu08wIh9l4eOZ3YDwhjhMK9nufRyv7Kfvgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=liZ9gk5HASA02GcL6ulAiQ+LEY5MFhBoA8niYeQtoi54jGblXFYwZzWKg4Skl2s8F
         o6c6L/XuNLP8SMkRf2Ip4QkzgMcPZDbEoYeqleougcuJCzumNxxa6yCyw55hmpSnh3
         pGa6DWFfDz8kgZ+JQ/9b+Qzov7IEDwCf3T+LxtNo=
Date:   Fri, 8 Jan 2021 15:03:03 +1100
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
Message-ID: <20210108040303.GH3209@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-4-david@gibson.dropbear.id.au>
 <20201204141005.07bf61dd.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aF3LVLvitz/VQU3c"
Content-Disposition: inline
In-Reply-To: <20201204141005.07bf61dd.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--aF3LVLvitz/VQU3c
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

I don't think it's worth changing here.  This gets changed again in
patch 6, I'll adjust to clarify a bit what's going on there.

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

--aF3LVLvitz/VQU3c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/32XQACgkQbDjKyiDZ
s5I3Hw//eRYOBsJ2TurIh7rwuauV/QflkcKoHjCC3SbHxSNrIRsiXD/KxU15OTyR
TVyCCZIQnyD2mORKhwpNPtSTdPbeds/sTsxGC2mUwAkcudy7s1f5GpQccf9jL7j5
jJjsBAo9Tkn0VJKoQZMPYSEY4ru33Zbqk5zArqR8PvrUsXhw60K3/xXi2mVZ5cUN
m82v5dSxl9pIgF5fDm7a2VHeE5YiB5/ZCpdbGFpuX59LvV5y/UmFdx9vbam5e8Ie
ekoIjFsv5yJ2eECeZ7jzmBmdJ/KoNWZ5rzX0ID39o8buS5ZZO2KxC9F4Rt/iIt0I
RX0YNmD32wX/s3CJzB/KytTTE38jjzdEnU7arlGHEDz5CibGBpDoA/BP2tFIoTll
o7ina6lu0s+T4UrNEKS+DagFY5qJGNA+1p7JcuNBGj2ns7QIY8zNXh04K0toyrb5
LFUHd9DT+AciTDaQ5e/I7/ONaFLBh2EAc4AbcUo6r1iXyPQ+df446qaIljA2ljGn
oQX0CjYDxWRo+Wn2wBc1yLiL7GD4vu19m5JdTPpom8LdjCDGDtCuGi6Vr56c1NRS
DMYbbnOBxtnR49B9umPfqR8VS+lKFeilixsohid8+Yohe940BkyIcgFCVyth+RG0
044z8YFmtRnuZL5HaPXD+YzAG93+OeFSA0MAyxakNE8hrl/EQt4=
=e/zG
-----END PGP SIGNATURE-----

--aF3LVLvitz/VQU3c--
