Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C662FDEF2
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbhAUBmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:42:23 -0500
Received: from ozlabs.org ([203.11.71.1]:41739 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbhAUBWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:22:13 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DLl366JMHz9sWX; Thu, 21 Jan 2021 12:21:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1611192082;
        bh=vCW/h9Js7xgLo8fl1XONbMPHFoEKd4u4Njdjh+h5cls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDA4OzfrVHp1us0H7wfIwv8oPvFUa0yTbwNVv3xwYTrcNtjCBVb9dR/YbBCWMxsux
         hoO/BhxIo2MrRGscsmdSbjoXB7EPBK+uPY6r6uy9/1oeVPzFNXdiBAjXwDoQa14/6U
         IuDTgZYW6Xa+TYaYfYGpzrUaTalP1M0GTez3iku4=
Date:   Thu, 21 Jan 2021 12:06:43 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, pasic@linux.ibm.com,
        qemu-devel@nongnu.org, cohuck@redhat.com,
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
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 02/13] confidential guest support: Introduce new
 confidential guest support class
Message-ID: <20210121010643.GG5174@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-3-david@gibson.dropbear.id.au>
 <20210118185124.GG9899@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JkW1gnuWHDypiMFO"
Content-Disposition: inline
In-Reply-To: <20210118185124.GG9899@work-vm>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--JkW1gnuWHDypiMFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 18, 2021 at 06:51:24PM +0000, Dr. David Alan Gilbert wrote:
> * David Gibson (david@gibson.dropbear.id.au) wrote:
> > Several architectures have mechanisms which are designed to protect gue=
st
> > memory from interference or eavesdropping by a compromised hypervisor. =
 AMD
> > SEV does this with in-chip memory encryption and Intel's MKTME can do
>                                                            ^^^^^
> (and below) My understanding is that it's Intel TDX that's the VM
> equivalent.

I thought MKTME could already do memory encryption and TDX extended
that to... more?  I'll adjust the comment to say TDX anyway, since
that seems to be the newer name.

>=20
> Dave
>=20
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
> >      .name =3D TYPE_SEV_GUEST,
> >      .instance_size =3D sizeof(SevGuestState),
> >      .instance_finalize =3D sev_guest_finalize,

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--JkW1gnuWHDypiMFO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAI06EACgkQbDjKyiDZ
s5Lz0A//aAMRlbB+KxasmsRWe9lEiszg3aseOraJVo+8dDsLUUM0KGZDOQNBWose
8RFcHq6dKd6e0pbGoUbMf76mQ6SOoHsPzMweU8O2lH+wW/R/tLnDifd5BbcYtxkS
7Y8zSXukSAEIy5+G76Cisvv9k4x0AFdyk7u3AvZ76zVrspxPB37JccCfJOleSRWF
OI0XUMaPxS9933U7hgf9N8ISD3oMCtjzgc/b6JSaJ89OWEvEX4Vr3kOZAMeYCi/Z
jDU8AfxtQCl991Q0vPLd4numw7SjcHAMaQL8VjRRKmAavgKUt6s5UPXWENiF01Z1
VpXXLVxLzLjFSWyWBZiXOvUxyhzoAeyjTEtGm4sKT62Iw2MwSIPxTHwMqp8e0RGc
usGpnb4eIHHnqZUBPMRMqNhD8fxgzlEe7deCslFBiTBFoH6wGm+1hrL08Kbj/FXQ
zUhLDO5gvY50AQYu8kp0Bj1iFYntGg9X4s8vc56PGuoLNVBdcBnqW66nLNFDeUIv
cq53835XD13bdo+salP/2X5S4mwubcFzdbpxV0PXj0vxzxSSRsVuZ/LpXl1QvZxV
ejkqpoPR9EeutD6lNglqdMJ51WDTqT0PVmikvNE+CYyetphdsgDyboQnj3tBuKJs
O7qgTxU4CyfXJncEo1OxoD9qGmiVqIhPHtsFFid2Q9AdI7cRxvA=
=YpKR
-----END PGP SIGNATURE-----

--JkW1gnuWHDypiMFO--
