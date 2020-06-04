Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1FB1EDCFF
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgFDGMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:12:33 -0400
Received: from ozlabs.org ([203.11.71.1]:38493 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgFDGMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:12:32 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cwRd0DKKz9sT9; Thu,  4 Jun 2020 16:12:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591251149;
        bh=7Q9EoAEsm4CUyc+8kT1Oj2miaAQHPa+uszA858Mjx1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WD9NUZ52oeQ8n17L4mXKrNejWC2n+y38XCaoJVCv+edpMOijxtlOo0H13qsZu2BB2
         Lsp//JH4CSj0sz1yEY0Bwt5dBvW6KyfF2emGW6c5hItI12qlQ6rPljuQ+L47txnBRO
         xfNYyJXH22vSPvyepi+j0iP5H48w1g7MegT5j6cM=
Date:   Thu, 4 Jun 2020 13:46:26 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 17/18] spapr: Added PEF based guest memory protection
Message-ID: <20200604034626.GE228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-18-david@gibson.dropbear.id.au>
 <20200529075940.GA26785@oc0525413822.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <20200529075940.GA26785@oc0525413822.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2020 at 12:59:40AM -0700, Ram Pai wrote:
> On Thu, May 21, 2020 at 01:43:03PM +1000, David Gibson wrote:
> > Some upcoming POWER machines have a system called PEF (Protected
> > Execution Framework) which uses a small ultravisor to allow guests to
>=20
> Framework -> Facility
>=20
> > run in a way that they can't be eavesdropped by the hypervisor.  The
> > effect is roughly similar to AMD SEV, although the mechanisms are
> > quite different.
> >=20
> > Most of the work of this is done between the guest, KVM and the
> > ultravisor, with little need for involvement by qemu.  However qemu
> > does need to tell KVM to allow secure VMs.
> >=20
> > Because the availability of secure mode is a guest visible difference
> > which depends on havint the right hardware and firmware, we don't
>=20
> havint -> having
>=20
> > enable this by default.  In order to run a secure guest you need to
> > create a "pef-guest" object and set the guest-memory-protection machine=
 property to point to it.
> >=20
> > Note that this just *allows* secure guests, the architecture of PEF is
> > such that the guest still needs to talk to the ultravisor to enter
> > secure mode, so we can't know if the guest actually is secure until
> > well after machine creation time.
>=20
> In fact, Qemu has no direct way of knowing if the guest has turned
> secure or not, even after machine creation time. There are indirect ways
> for Qemu to know that, but nothing informs Qemu explicitly about it.=20
>=20
> So maybe we should just say...
>=20
> "..
>  such that the guest still needs to talk to the ultravisor to enter
>  secure mode, so we can't directly know if the guest actually is secure."=
=20
>=20
>=20
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  target/ppc/Makefile.objs |  2 +-
> >  target/ppc/pef.c         | 81 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 82 insertions(+), 1 deletion(-)
> >  create mode 100644 target/ppc/pef.c
> >=20
> > diff --git a/target/ppc/Makefile.objs b/target/ppc/Makefile.objs
> > index e8fa18ce13..ac93b9700e 100644
> > --- a/target/ppc/Makefile.objs
> > +++ b/target/ppc/Makefile.objs
> > @@ -6,7 +6,7 @@ obj-y +=3D machine.o mmu_helper.o mmu-hash32.o monitor.=
o arch_dump.o
> >  obj-$(TARGET_PPC64) +=3D mmu-hash64.o mmu-book3s-v3.o compat.o
> >  obj-$(TARGET_PPC64) +=3D mmu-radix64.o
> >  endif
> > -obj-$(CONFIG_KVM) +=3D kvm.o
> > +obj-$(CONFIG_KVM) +=3D kvm.o pef.o
> >  obj-$(call lnot,$(CONFIG_KVM)) +=3D kvm-stub.o
> >  obj-y +=3D dfp_helper.o
> >  obj-y +=3D excp_helper.o
> > diff --git a/target/ppc/pef.c b/target/ppc/pef.c
> > new file mode 100644
> > index 0000000000..823daf3e9c
> > --- /dev/null
> > +++ b/target/ppc/pef.c
> > @@ -0,0 +1,81 @@
> > +/*
> > + * PEF (Protected Execution Framework) for POWER support
> > + *
> > + * Copyright David Gibson, Redhat Inc. 2020
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or =
later.
> > + * See the COPYING file in the top-level directory.
> > + *
> > + */
> > +
> > +#include "qemu/osdep.h"
> > +
> > +#define TYPE_PEF_GUEST "pef-guest"
> > +#define PEF_GUEST(obj)                                  \
> > +    OBJECT_CHECK(PefGuestState, (obj), TYPE_SEV_GUEST)
> > +
> > +typedef struct PefGuestState PefGuestState;
> > +
> > +/**
> > + * PefGuestState:
> > + *
> > + * The PefGuestState object is used for creating and managing a PEF
> > + * guest.
> > + *
> > + * # $QEMU \
> > + *         -object pef-guest,id=3Dpef0 \
> > + *         -machine ...,guest-memory-protection=3Dpef0
> > + */
> > +struct PefGuestState {
> > +    Object parent_obj;
> > +};
> > +
> > +static Error *pef_mig_blocker;
> > +
> > +static int pef_kvm_init(GuestMemoryProtection *gmpo, Error **errp)
> > +{
> > +    PefGuestState *pef =3D PEF_GUEST(gmpo);
> > +
> > +    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
> > +        error_setg(errp,
> > +                   "KVM implementation does not support Secure VMs (is=
 an ultravisor running?)");
> > +        return -1;
> > +    } else {
> > +        int ret =3D kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_SECURE_GU=
EST, 0, 1);
> > +
> > +        if (ret < 0) {
> > +            error_setg(errp,
> > +                       "Error enabling PEF with KVM");
> > +            return -1;
> > +        }
> > +    }
> > +
> > +    return 0;
> > +}
>=20
> This looks correct to me.
>=20
> > +
> > +static void pef_guest_class_init(ObjectClass *oc, void *data)
> > +{
> > +    GuestMemoryProtectionClass *gmpc =3D GUEST_MEMORY_PROTECTION_CLASS=
(oc);
> > +
> > +    gmpc->kvm_init =3D pef_kvm_init;
> > +}
> > +
> > +static const TypeInfo pef_guest_info =3D {
> > +    .parent =3D TYPE_OBJECT,
> > +    .name =3D TYPE_PEF_GUEST,
> > +    .instance_size =3D sizeof(PefGuestState),
> > +    .class_init =3D pef_guest_class_init,
> > +    .interfaces =3D (InterfaceInfo[]) {
> > +        { TYPE_GUEST_MEMORY_PROTECTION },
> > +        { TYPE_USER_CREATABLE },
> > +        { }
> > +    }
> > +};
> > +
> > +static void
> > +pef_register_types(void)
> > +{
> > +    type_register_static(&pef_guest_info);
> > +}
> > +
> > +type_init(pef_register_types);
>=20
> Acked-by: Ram Pai <linuxram@us.ibm.com>
>=20
> Thanks for doing this!
>=20
> BTW: Will there be a new machine type defined for running secure VMs?

I wasn't planning on it.  Part of the point of this unified
configuration is that we can reasonably have libvirt and upper layers
tell qemu to do this without needing specific machine type hacks.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7Ybo8ACgkQbDjKyiDZ
s5IVtxAAhNo7bcl3pRrGvxEkKahFwNKH21dvbdiXSoJIz/hPe5RU3kMfmG32b4Mg
M/fXA1pquobNvst6ybx6goQ4ODKK41879HVP9p7zI81VSpqcgMcjWPzZ5YACU2nw
B5+XP7yGWXKFYpEfNE1xgyM5hFVsJgrjw1G/7HCjFf+tj3nKoH3LgQms13w5+b21
nG4DFnet97frK2OfUvBdxzZarYGj8Z7LXfyAM886HelQkl8eZ59nBguk+EolHrle
RD0AJyWZkvspDNzyYa3w8+ApJ4fr35upOJPTG3GBHv0DP1nT8taBvSjq+mwPBGiL
+jR1u991VokJ2kPWi+tw8t2wIIiDVDYqQccU50KHwdAGGc8//uUz2kNdrf1Uu/G+
u8qJJoyMt8XtVwhoMMqKnZCDoamb22pByKkUUPSwmISKDhBLiWc2ODPAZYtZvUcw
S9RdN0t3QmW55ikZBIr0V/e9YRfxqAOZJLqIXeHwC0kbqZFn7r6trQnV8muhMTFj
iQNw3557OYOoIXM3kwP7qfh8bAkb2qHv2nNQebT6AOxnB3hP98Gh+RMS8waiUqPP
1AXQ5rFJ5TRytILzP4dxLPYUSXDoZQ3JEYboeVPLXis1+pSvzDFZmOwojqKnM2D1
ddX6JvA8g8c2dyXShSVzlYLp/CMwJVaQ4EqlUK/IFFlZr67CycA=
=l9xg
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
