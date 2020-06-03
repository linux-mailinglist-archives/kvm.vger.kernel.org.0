Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A3A1ECF6C
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 14:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgFCMHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 08:07:50 -0400
Received: from ozlabs.org ([203.11.71.1]:37985 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgFCMHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 08:07:50 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cSN426Smz9sSc; Wed,  3 Jun 2020 22:07:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591186068;
        bh=/8OHMiJYf9fsWc/S8JvslYN4IuSO+nUpOmIPBciWWek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W4s6JcXcU7N66PtMVZVa79cn/fiI8+C+Sgd1/1mTXtHUBUDyWnWGeyHyhcol86/1w
         xk50FEpRc77mxtIpTFfBKD2GmM/6G+z5VHq0d8VqroZwlTZZTYyFlnpcweHdOgCGCF
         UYqzp8kUX+OY7xqhRhwckvcGqadancJGeyTbgnCQ=
Date:   Wed, 3 Jun 2020 20:09:10 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 10/18] guest memory protection: Add guest memory
 protection interface
Message-ID: <20200603100910.GA11091@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-11-david@gibson.dropbear.id.au>
 <20200525122735.1d4a45c7@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20200525122735.1d4a45c7@bahia.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2020 at 12:27:35PM +0200, Greg Kurz wrote:
> On Thu, 21 May 2020 13:42:56 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > Several architectures have mechanisms which are designed to protect gue=
st
> > memory from interference or eavesdropping by a compromised hypervisor. =
 AMD
> > SEV does this with in-chip memory encryption and Intel has a similar
> > mechanism.  POWER's Protected Execution Framework (PEF) accomplishes a
> > similar goal using an ultravisor and new memory protection features,
> > instead of encryption.
> >=20
> > This introduces a new GuestMemoryProtection QOM interface which we'll u=
se
> > to (partially) unify handling of these various mechanisms.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  backends/Makefile.objs                 |  2 ++
> >  backends/guest-memory-protection.c     | 29 +++++++++++++++++++++
> >  include/exec/guest-memory-protection.h | 36 ++++++++++++++++++++++++++
> >  3 files changed, 67 insertions(+)
> >  create mode 100644 backends/guest-memory-protection.c
> >  create mode 100644 include/exec/guest-memory-protection.h
> >=20
> > diff --git a/backends/Makefile.objs b/backends/Makefile.objs
> > index 28a847cd57..e4fb4f5280 100644
> > --- a/backends/Makefile.objs
> > +++ b/backends/Makefile.objs
> > @@ -21,3 +21,5 @@ common-obj-$(CONFIG_LINUX) +=3D hostmem-memfd.o
> >  common-obj-$(CONFIG_GIO) +=3D dbus-vmstate.o
> >  dbus-vmstate.o-cflags =3D $(GIO_CFLAGS)
> >  dbus-vmstate.o-libs =3D $(GIO_LIBS)
> > +
> > +common-obj-y +=3D guest-memory-protection.o
> > diff --git a/backends/guest-memory-protection.c b/backends/guest-memory=
-protection.c
> > new file mode 100644
> > index 0000000000..7e538214f7
> > --- /dev/null
> > +++ b/backends/guest-memory-protection.c
> > @@ -0,0 +1,29 @@
> > +#/*
> > + * QEMU Guest Memory Protection interface
> > + *
> > + * Copyright: David Gibson, Red Hat Inc. 2020
> > + *
> > + * Authors:
> > + *  David Gibson <david@gibson.dropbear.id.au>
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or
> > + * later.  See the COPYING file in the top-level directory.
> > + *
> > + */
> > +
> > +#include "qemu/osdep.h"
> > +
> > +#include "exec/guest-memory-protection.h"
> > +
> > +static const TypeInfo guest_memory_protection_info =3D {
> > +    .name =3D TYPE_GUEST_MEMORY_PROTECTION,
> > +    .parent =3D TYPE_INTERFACE,
> > +    .class_size =3D sizeof(GuestMemoryProtectionClass),
> > +};
> > +
> > +static void guest_memory_protection_register_types(void)
> > +{
> > +    type_register_static(&guest_memory_protection_info);
> > +}
> > +
> > +type_init(guest_memory_protection_register_types)
> > diff --git a/include/exec/guest-memory-protection.h b/include/exec/gues=
t-memory-protection.h
> > new file mode 100644
> > index 0000000000..38e9b01667
> > --- /dev/null
> > +++ b/include/exec/guest-memory-protection.h
> > @@ -0,0 +1,36 @@
> > +#/*
> > + * QEMU Guest Memory Protection interface
> > + *
> > + * Copyright: David Gibson, Red Hat Inc. 2020
> > + *
> > + * Authors:
> > + *  David Gibson <david@gibson.dropbear.id.au>
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or
> > + * later.  See the COPYING file in the top-level directory.
> > + *
> > + */
> > +#ifndef QEMU_GUEST_MEMORY_PROTECTION_H
> > +#define QEMU_GUEST_MEMORY_PROTECTION_H
> > +
> > +#include "qom/object.h"
> > +
> > +typedef struct GuestMemoryProtection GuestMemoryProtection;
> > +
> > +#define TYPE_GUEST_MEMORY_PROTECTION "guest-memory-protection"
> > +#define GUEST_MEMORY_PROTECTION(obj)                                  =
  \
> > +    INTERFACE_CHECK(GuestMemoryProtection, (obj),                     =
  \
> > +                    TYPE_GUEST_MEMORY_PROTECTION)
> > +#define GUEST_MEMORY_PROTECTION_CLASS(klass)                          =
  \
> > +    OBJECT_CLASS_CHECK(GuestMemoryProtectionClass, (klass),           =
  \
> > +                       TYPE_GUEST_MEMORY_PROTECTION)
> > +#define GUEST_MEMORY_PROTECTION_GET_CLASS(obj)                        =
  \
> > +    OBJECT_GET_CLASS(GuestMemoryProtectionClass, (obj),               =
  \
> > +                     TYPE_GUEST_MEMORY_PROTECTION)
> > +
> > +typedef struct GuestMemoryProtectionClass {
> > +    InterfaceClass parent;
> > +} GuestMemoryProtectionClass;
> > +
> > +#endif /* QEMU_GUEST_MEMORY_PROTECTION_H */
> > +
>=20
> Applying patch #1294935 using "git am -s -m"
> Description: [RFC,v2,10/18] guest memory protection: Add guest memory pro=
tection
> Applying: guest memory protection: Add guest memory protection interface
> .git/rebase-apply/patch:95: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.

Oops, fixed.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7XdsMACgkQbDjKyiDZ
s5K/hBAA1/nV1iP+BSJxo3zR4Q52aEImFYxuD6PEoIQ0BQczE0qNK6HW2Uqe4w0H
PclvgiMHwprTIIiQVQo4vu98mQvhpHTnYVZbjH0ww+oIBponyDA/aHBSNsKvNF76
ovkfC/nZ11GvHUA1FQzEKvnn4qiU2qv0N6aoKetxHmSUMSCUYomxdGKJOIVxa754
TMJvR0DuxcmEnY5/1bXah0QN9c4luvP3k7HVOJq5xSvz/4pK47znpvVaT9ZtX+h0
2Dq4vUWLlCgBKzOD859xLAdA8BdR0Ju8xpRmfdtkJSVQyb1rPprNRQWhi1YKO6SP
4uRwgRmlynNpVj3/MoWnBYFrXRKTYuAboPZZPf2mCTuErLEv6M4b20ZNvtAt93u+
4AFKYOweqivywCFdu6aDszC3ja2lwMxxlcc1TBYX/OVzjpPlzghpEEv4h79tgC6o
cIqde6lNeUxZ1VPScsW7fHsopIOW6ZLZs1vcg2raqqC76zmSek/JltMOmRUabUAj
7lUjIEgn9EGJZ3kc8KEXPl89H1rjmd4P4EmEkfNfasorEz7HCe6KtoSRCLBSblUx
iZ30ECn3MMF+Ptu9j9xWr53+Du4ldLOsWQYQjd7e318rhp7XfGFHerLEQachMhoH
ObHRq66/cP1XsRRcOEPYRxHZ+sFZJoJWDyCilG99tbokuT+OZtM=
=6G9C
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
