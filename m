Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494BF20156F
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 18:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394715AbgFSQWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 12:22:10 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390218AbgFSPAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:00:20 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49pMRh15XWz9sjF; Sat, 20 Jun 2020 01:00:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592578816;
        bh=i09Pzm3J+sHg0qnWmU6RuDXb6mWa9G7DYcrmVm6UoBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C6DS+ar7jPslhN9O0WwbEn1ayt+r6wlNcnguyJVycjvA5RqxBcPyHXrPAmuv283x2
         HMcCuAogsKUMm1OQef7TBRlAzqp1jMAX1H0enKcgbCEt9Nnq3gvhza6kiuJxSYeEV7
         8tRtC/a22PQL23JdgPLKG8qPZoppbekkiRRRz1vg=
Date:   Sat, 20 Jun 2020 00:45:41 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        mst@redhat.com, cohuck@redhat.com, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 9/9] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200619144541.GM17085@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AQYPrgrEUc/1pSX1"
Content-Disposition: inline
In-Reply-To: <20200619101245.GC700896@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--AQYPrgrEUc/1pSX1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 11:12:45AM +0100, Daniel P. Berrang=E9 wrote:
> On Fri, Jun 19, 2020 at 12:06:02PM +1000, David Gibson wrote:
> > The default behaviour for virtio devices is not to use the platforms no=
rmal
> > DMA paths, but instead to use the fact that it's running in a hypervisor
> > to directly access guest memory.  That doesn't work if the guest's memo=
ry
> > is protected from hypervisor access, such as with AMD's SEV or POWER's =
PEF.
> >=20
> > So, if a host trust limitation mechanism is enabled, then apply the
> > iommu_platform=3Don option so it will go through normal DMA mechanisms.
> > Those will presumably have some way of marking memory as shared with the
> > hypervisor or hardware so that DMA will work.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  hw/core/machine.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >=20
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index a71792bc16..8dfc1bb3f8 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -28,6 +28,8 @@
> >  #include "hw/mem/nvdimm.h"
> >  #include "migration/vmstate.h"
> >  #include "exec/host-trust-limitation.h"
> > +#include "hw/virtio/virtio.h"
> > +#include "hw/virtio/virtio-pci.h"
> > =20
> >  GlobalProperty hw_compat_5_0[] =3D {
> >      { "virtio-balloon-device", "page-poison", "false" },
> > @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *machin=
e)
> >           * areas.
> >           */
> >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > +
> > +        /*
> > +         * Virtio devices can't count on directly accessing guest
> > +         * memory, so they need iommu_platform=3Don to use normal DMA
> > +         * mechanisms.  That requires disabling legacy virtio support
> > +         * for virtio pci devices
> > +         */
> > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", =
"on");
> > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform=
", "on");
> >      }
>=20
> Silently changing the user's request configuration like this

It doesn't, though.  register_sugar_prop() effectively registers a
default, so if the user has explicitly specified something, that will
take precedence.

> is a bad idea.
> The "disable-legacy" option in particular is undesirable as that switches
> the device to virtio-1.0 only mode, which exposes a different PCI ID to
> the guest.
>=20
> If some options are incompatible with encryption, then we should raise a
> fatal error at startup, so applications/admins are aware that their reque=
sted
> config is broken.
>=20
> Regards,
> Daniel

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--AQYPrgrEUc/1pSX1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7sz5IACgkQbDjKyiDZ
s5J+8w/+JJK7plk6WUNFDCN0inRibIaHRp7R6OpBirGdfBHRI1bEAYrmm7cOnjhR
LQ67An6wmLV4QB7P+Kt7Ud1ppfskhG5Uz9xEmuFGS/fNycr3KXZ4q4OddDW7mI2/
PADqa5j+AaqWFh+hnw/Zux6jYUGi52aqFJfh6iluGZ2Be3sD17YFKpA/yytBecWH
dU8rFFovc4YOSHyjJEsMENtQ80qKTTObootZeTRqKQavrBQnfQ8W7GejOanVI5k9
xez40IKMLN1FNzKt0HwBIJVClQrOYXDhoY1ia3gATv1GJ/IT+3ARH3I+qfp9rPLm
8JyPaBgMzVv2sbRguF7nGblW58pnv4RqK9XuSpWMKfmIMtV0fm1B4R1cTwcDeaDW
R9aGfdUIolZKUIRwlbkPhjialYbOBgJ13BgIZrlvHl4PGR6ZSvoHHyjdrtfk2aYD
Uz/sq915JnDTHt2T1Y/I9I38Xu7HR7RAGUhSyG08kihRxBBVYqoeUldHmoOnyt3S
br6yo5JX9LjceRJR2VaGnY8yuKXMyXNEKLLQJF1qBqzzJfrpNH4UkzDFlaj8X9IA
/VCoiB2npTzwRCgTqNgxnCl//60s7oLx/KaEHvuB6iE4b9IZKrvWUcZADxXctxMn
lWwvRa5r5rMiB1sx0cBJS/MeqhDlB0BX4EXlEerznh86A3KMQrg=
=LRIe
-----END PGP SIGNATURE-----

--AQYPrgrEUc/1pSX1--
