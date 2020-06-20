Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEEE20229A
	for <lists+kvm@lfdr.de>; Sat, 20 Jun 2020 10:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgFTIYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Jun 2020 04:24:40 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43205 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgFTIYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Jun 2020 04:24:39 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49ppcj0CfPz9sRh; Sat, 20 Jun 2020 18:24:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592641477;
        bh=W38gQ8kAX055GFm1vlm4XFMgXT6TAso2CKHgAagLEDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gOKShuaDtZTlQUv5OT6rfvdnBWF/EcOzPzNOVllcLC3My5sM3/tLrGX1WsFdSUblR
         LmQ2ZJtF27ciH3tx3oKHEPpx3m9GaG9lgXD9i+0Ddcaf9Pg2mHWnbpc5M8e/2DVzh7
         wAGixsJmMv3w67MtBbz43+mwFBjYpX3J+VOx/QOc=
Date:   Sat, 20 Jun 2020 18:24:27 +1000
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
Message-ID: <20200620082427.GP17085@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
 <20200619144541.GM17085@umbus.fritz.box>
 <20200619150556.GW700896@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ftQmbtOmUf2cr8rB"
Content-Disposition: inline
In-Reply-To: <20200619150556.GW700896@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ftQmbtOmUf2cr8rB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 04:05:56PM +0100, Daniel P. Berrang=E9 wrote:
> On Sat, Jun 20, 2020 at 12:45:41AM +1000, David Gibson wrote:
> > On Fri, Jun 19, 2020 at 11:12:45AM +0100, Daniel P. Berrang=E9 wrote:
> > > On Fri, Jun 19, 2020 at 12:06:02PM +1000, David Gibson wrote:
> > > > The default behaviour for virtio devices is not to use the platform=
s normal
> > > > DMA paths, but instead to use the fact that it's running in a hyper=
visor
> > > > to directly access guest memory.  That doesn't work if the guest's =
memory
> > > > is protected from hypervisor access, such as with AMD's SEV or POWE=
R's PEF.
> > > >=20
> > > > So, if a host trust limitation mechanism is enabled, then apply the
> > > > iommu_platform=3Don option so it will go through normal DMA mechani=
sms.
> > > > Those will presumably have some way of marking memory as shared wit=
h the
> > > > hypervisor or hardware so that DMA will work.
> > > >=20
> > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > ---
> > > >  hw/core/machine.c | 11 +++++++++++
> > > >  1 file changed, 11 insertions(+)
> > > >=20
> > > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > > index a71792bc16..8dfc1bb3f8 100644
> > > > --- a/hw/core/machine.c
> > > > +++ b/hw/core/machine.c
> > > > @@ -28,6 +28,8 @@
> > > >  #include "hw/mem/nvdimm.h"
> > > >  #include "migration/vmstate.h"
> > > >  #include "exec/host-trust-limitation.h"
> > > > +#include "hw/virtio/virtio.h"
> > > > +#include "hw/virtio/virtio-pci.h"
> > > > =20
> > > >  GlobalProperty hw_compat_5_0[] =3D {
> > > >      { "virtio-balloon-device", "page-poison", "false" },
> > > > @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *ma=
chine)
> > > >           * areas.
> > > >           */
> > > >          machine_set_mem_merge(OBJECT(machine), false, &error_abort=
);
> > > > +
> > > > +        /*
> > > > +         * Virtio devices can't count on directly accessing guest
> > > > +         * memory, so they need iommu_platform=3Don to use normal =
DMA
> > > > +         * mechanisms.  That requires disabling legacy virtio supp=
ort
> > > > +         * for virtio pci devices
> > > > +         */
> > > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legac=
y", "on");
> > > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_plat=
form", "on");
> > > >      }
> > >=20
> > > Silently changing the user's request configuration like this
> >=20
> > It doesn't, though.  register_sugar_prop() effectively registers a
> > default, so if the user has explicitly specified something, that will
> > take precedence.
>=20
> Don't assume that the user has set "disable-legacy=3Doff". People who wan=
t to
> have a transtional device are almost certainly pasing "-device virtio-blk=
-pci",
> because historical behaviour is that this is sufficient to give you a
> transitional device. Changing the default of disable-legacy=3Don has not
> honoured the users' requested config.

Umm.. by this argument we can never change any default, ever.  But we
do that routinely with new machine versions.  How is changing based on
a machine option different from that?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ftQmbtOmUf2cr8rB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7tx7sACgkQbDjKyiDZ
s5Lk1Q/9EyZXMK2UB/lzd6fAojOLADfFhZxOt+1U1YObtM8o8pRBIcXCzGtvzgHU
533geSroEFIm+4Y8Mq41KigHqV95a5roJE+UpfZ/AJkB/VZyOiEtr4oFubj+a3OW
zTk4pwCfEq7dtrK/UVJbBeebDuKioGX5mhMXBbbsHPDUITNDb++FjT2dMLG2aiOF
HOtzzc1lFkZnEAnUf8rHcsulFeihNG50qARa5BxPlcRFvuOWFperm8SGCxYbHuRv
cjHOQCRBw4HTSO3kz8TKo6uK1OB3jw9XuSRsmmczPDiwJvpFrJ9BHF4e45e+9xjy
A19ESEqV0fTfr67YxTinyLeiXHxvJXPPr1ASV0lTif0rpVqbfshf7jW66LqHo0Ss
cCxXOkgiyQEwGEhmcUzoQ/nGonhvz/i1zKR1xoApjK6DfbuW102ojdxesxMNyEM1
Rp2xy2b2Et0cuiIFVOZwG+5KkeQ9VHIgnlrYPA2hQNoas3hSzYa+8V7cqo/ELd+3
eccQaHAR0nNEsV/Fk5ppJ+VSPmjLVvB4rff0xv/m9e+z2GFJdFfV58vNTV/d5l4P
t3Mdm0gCP27shb7jZm3eQHzQLcqUGoUOUppTALP1E4lQSlCF/cKigUjmyvzOMmc8
ZIfbz0dxlSqQIhiJF/SPCic83D6Hg9ucyoEPmuRUkHpLIfMEvCM=
=GaO6
-----END PGP SIGNATURE-----

--ftQmbtOmUf2cr8rB--
