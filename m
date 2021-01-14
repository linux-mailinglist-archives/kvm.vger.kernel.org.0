Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F892F607A
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbhANLrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:47:08 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:51503 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbhANLrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 06:47:08 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGjFX3btbz9shx; Thu, 14 Jan 2021 22:46:23 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610624784;
        bh=MLcZN3Qo4B+3OIZBzY194QiYnraPxOj/vYFCJGbS0Sk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8GHyAWaSdJREVHjbYlzJj/c6rBJdcPylygKIQzuOrvX8CpTng2gMHsRqx+AtCZki
         3wnnm+EGgnhkg8AFfCbYUno//IlvEixL5n5pVZgPV9qtkHO3S7el5Bs3EIKCl5Pl58
         4j7QRZwvYEmADQiCONlWladmu0ACc0M0MmlAJd3A=
Date:   Thu, 14 Jan 2021 21:42:07 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        andi.kleen@intel.com
Subject: Re: [PATCH v7 02/13] confidential guest support: Introduce new
 confidential guest support class
Message-ID: <20210114104207.GM435587@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-3-david@gibson.dropbear.id.au>
 <20210114093436.GB1643043@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sWvRP97dwRHm9fX+"
Content-Disposition: inline
In-Reply-To: <20210114093436.GB1643043@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--sWvRP97dwRHm9fX+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14, 2021 at 09:34:36AM +0000, Daniel P. Berrang=E9 wrote:
> On Thu, Jan 14, 2021 at 10:58:00AM +1100, David Gibson wrote:
> > Several architectures have mechanisms which are designed to protect gue=
st
> > memory from interference or eavesdropping by a compromised hypervisor. =
 AMD
> > SEV does this with in-chip memory encryption and Intel's MKTME can do
> > similar things.  POWER's Protected Execution Framework (PEF) accomplish=
es a
> > similar goal using an ultravisor and new memory protection features,
> > instead of encryption.
> >=20
> > To (partially) unify handling for these, this introduces a new
> > ConfidentialGuestSupport QOM base class.  "Confidential" is kind of vag=
ue,
> > but "confidential computing" seems to be the buzzword about these schem=
es,
> > and "secure" or "protected" are often used in connection to unrelated
> > things (such as hypervisor-from-guest or guest-from-guest security).
> >=20
> > The "support" in the name is significant because in at least some of the
> > cases it requires the guest to take specific actions in order to protect
> > itself from hypervisor eavesdropping.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  backends/confidential-guest-support.c     | 33 ++++++++++++++++++++
> >  backends/meson.build                      |  1 +
> >  include/exec/confidential-guest-support.h | 38 +++++++++++++++++++++++
> >  include/qemu/typedefs.h                   |  1 +
> >  target/i386/sev.c                         |  3 +-
> >  5 files changed, 75 insertions(+), 1 deletion(-)
> >  create mode 100644 backends/confidential-guest-support.c
> >  create mode 100644 include/exec/confidential-guest-support.h
> >=20
> > diff --git a/backends/confidential-guest-support.c b/backends/confident=
ial-guest-support.c
> > new file mode 100644
> > index 0000000000..9b0ded0db4
> > --- /dev/null
> > +++ b/backends/confidential-guest-support.c
> > @@ -0,0 +1,33 @@
> > +/*
> > + * QEMU Confidential Guest support
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
> > +#include "exec/confidential-guest-support.h"
> > +
> > +OBJECT_DEFINE_ABSTRACT_TYPE(ConfidentialGuestSupport,
> > +                            confidential_guest_support,
> > +                            CONFIDENTIAL_GUEST_SUPPORT,
> > +                            OBJECT)
> > +
> > +static void confidential_guest_support_class_init(ObjectClass *oc, voi=
d *data)
> > +{
> > +}
> > +
> > +static void confidential_guest_support_init(Object *obj)
> > +{
> > +}
> > +
> > +static void confidential_guest_support_finalize(Object *obj)
> > +{
> > +}
> > diff --git a/backends/meson.build b/backends/meson.build
> > index 484456ece7..d4221831fc 100644
> > --- a/backends/meson.build
> > +++ b/backends/meson.build
> > @@ -6,6 +6,7 @@ softmmu_ss.add([files(
> >    'rng-builtin.c',
> >    'rng-egd.c',
> >    'rng.c',
> > +  'confidential-guest-support.c',
> >  ), numa])
> > =20
> >  softmmu_ss.add(when: 'CONFIG_POSIX', if_true: files('rng-random.c'))
> > diff --git a/include/exec/confidential-guest-support.h b/include/exec/c=
onfidential-guest-support.h
> > new file mode 100644
> > index 0000000000..5f131023ba
> > --- /dev/null
> > +++ b/include/exec/confidential-guest-support.h
> > @@ -0,0 +1,38 @@
> > +/*
> > + * QEMU Confidential Guest support
> > + *   This interface describes the common pieces between various
> > + *   schemes for protecting guest memory or other state against a
> > + *   compromised hypervisor.  This includes memory encryption (AMD's
> > + *   SEV and Intel's MKTME) or special protection modes (PEF on POWER,
> > + *   or PV on s390x).
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
> > +#ifndef QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
> > +#define QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
> > +
> > +#ifndef CONFIG_USER_ONLY
> > +
> > +#include "qom/object.h"
> > +
> > +#define TYPE_CONFIDENTIAL_GUEST_SUPPORT "confidential-guest-support"
> > +OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUES=
T_SUPPORT)
> > +
> > +struct ConfidentialGuestSupport {
> > +    Object parent;
> > +};
> > +
> > +typedef struct ConfidentialGuestSupportClass {
> > +    ObjectClass parent;
> > +} ConfidentialGuestSupportClass;
> > +
> > +#endif /* !CONFIG_USER_ONLY */
> > +
> > +#endif /* QEMU_CONFIDENTIAL_GUEST_SUPPORT_H */
> > diff --git a/include/qemu/typedefs.h b/include/qemu/typedefs.h
> > index 976b529dfb..33685c79ed 100644
> > --- a/include/qemu/typedefs.h
> > +++ b/include/qemu/typedefs.h
> > @@ -36,6 +36,7 @@ typedef struct BusState BusState;
> >  typedef struct Chardev Chardev;
> >  typedef struct CompatProperty CompatProperty;
> >  typedef struct CoMutex CoMutex;
> > +typedef struct ConfidentialGuestSupport ConfidentialGuestSupport;
> >  typedef struct CPUAddressSpace CPUAddressSpace;
> >  typedef struct CPUState CPUState;
> >  typedef struct DeviceListener DeviceListener;
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 1546606811..6b49925f51 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -31,6 +31,7 @@
> >  #include "qom/object.h"
> >  #include "exec/address-spaces.h"
> >  #include "monitor/monitor.h"
> > +#include "exec/confidential-guest-support.h"
> > =20
> >  #define TYPE_SEV_GUEST "sev-guest"
> >  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> > @@ -322,7 +323,7 @@ sev_guest_instance_init(Object *obj)
> > =20
> >  /* sev guest info */
> >  static const TypeInfo sev_guest_info =3D {
> > -    .parent =3D TYPE_OBJECT,
> > +    .parent =3D TYPE_CONFIDENTIAL_GUEST_SUPPORT,
>=20
> If you're changing the parent QOM type, then you also need to change
> the parent struct field type in SevguestState to match

Oops, yes.  I checked the rest of the types as I made the
OBJECT_DECLARE_TYPE conversions, but I forgot to go back and check
SEV.

> >      .name =3D TYPE_SEV_GUEST,
> >      .instance_size =3D sizeof(SevGuestState),
> >      .instance_finalize =3D sev_guest_finalize,
>=20
> Regards,
> Daniel

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--sWvRP97dwRHm9fX+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAAH+AACgkQbDjKyiDZ
s5JWchAAh9E9X3fG0nGhtlYc7Kp4oUctbgp6QyZoRBDoRS8yFOL9Obkj2TAZeHTb
ZV8NF+P38daRaFawwPbTDiOrlrESlCgvFRXE5TaqUKena4mol4x4dGrbnzjSdjIo
rDgi/10QkXfFUKhQcQxZvMF+TwKooWmGuAdXOtBGTbEqMLC1lqsJ5W3sejX6Eknj
C5CqCOV/FtAjNhHb+FijwMEne/tuq7qWa3e3+B6NV2WlY/6kFhv8HicQgjfbpb6O
ljVahhseGZkFl3ibzy4f1CODdlph8Ox9LIgukeCqmIv08jMT9DcfxR5uBmpFJH/P
jNQY7GAz4JJDRjjPlvRH2dT3nIQCSrRQ6hKuOcpkc4s1Yy9BqBwXKIYOxhzuEmx+
EdMxXUfQQITNO2ad0JHakdoyX60FcgO6ENqs9Yz3W+eQ6LruhpSFpyz3/BpRzNs8
ytYwjRm+3/sTX2u6btmZxq/QjQRHbpJDYEXDjzAk4bF84otVn0xc+TeUuVcNAqV4
OwAuJiwPAOxV5O/rDOvPPDzIh5B0Ulz5m2shgTLVVWTkO8PJe39oBZ2QWFYEOy7v
PwsK4rQL4YsCfNVtJ8PqsXkUVvfg6B/3oE4Shi56STKQb0fNZld7yUpX0HcM6qdR
EIgX+34g0s2RZNuDV3sBqNJGD5WJFzh9FOrRN9K+yVUJvRHoBs0=
=fQd4
-----END PGP SIGNATURE-----

--sWvRP97dwRHm9fX+--
