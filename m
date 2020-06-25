Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FC720998B
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 07:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbgFYFrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 01:47:31 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37267 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgFYFra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 01:47:30 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49spv44XjNz9sPF; Thu, 25 Jun 2020 15:47:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1593064048;
        bh=GkVzyXSXG/m9y99EQdJFlFv6/XgZsZ6nBBLs6h9Ykhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPUHTbqsHK7ZY/SHQQjiykOlbSH7WwgLo9UOx18O4A+uLTfbV5TitlIzigCzMTlyj
         231CQWI644T7Q/x3iqgoL08h0EvHK6cT0S9VRwbVd2qgBOrB+W/NiDgspvv3Gc6BYA
         emtE4yRkGKrRG05rITKYjTFLCYtECb02m2UVLo0Q=
Date:   Thu, 25 Jun 2020 15:02:17 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        pasic@linux.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 9/9] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200625050217.GB172395@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
 <20200619074432-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20200619074432-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 07:46:10AM -0400, Michael S. Tsirkin wrote:
> On Fri, Jun 19, 2020 at 11:12:45AM +0100, Daniel P. Berrang=C3=A9 wrote:
> > On Fri, Jun 19, 2020 at 12:06:02PM +1000, David Gibson wrote:
> > > The default behaviour for virtio devices is not to use the platforms =
normal
> > > DMA paths, but instead to use the fact that it's running in a hypervi=
sor
> > > to directly access guest memory.  That doesn't work if the guest's me=
mory
> > > is protected from hypervisor access, such as with AMD's SEV or POWER'=
s PEF.
> > >=20
> > > So, if a host trust limitation mechanism is enabled, then apply the
> > > iommu_platform=3Don option so it will go through normal DMA mechanism=
s.
> > > Those will presumably have some way of marking memory as shared with =
the
> > > hypervisor or hardware so that DMA will work.
> > >=20
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > ---
> > >  hw/core/machine.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >=20
> > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > index a71792bc16..8dfc1bb3f8 100644
> > > --- a/hw/core/machine.c
> > > +++ b/hw/core/machine.c
> > > @@ -28,6 +28,8 @@
> > >  #include "hw/mem/nvdimm.h"
> > >  #include "migration/vmstate.h"
> > >  #include "exec/host-trust-limitation.h"
> > > +#include "hw/virtio/virtio.h"
> > > +#include "hw/virtio/virtio-pci.h"
> > > =20
> > >  GlobalProperty hw_compat_5_0[] =3D {
> > >      { "virtio-balloon-device", "page-poison", "false" },
> > > @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *mach=
ine)
> > >           * areas.
> > >           */
> > >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > > +
> > > +        /*
> > > +         * Virtio devices can't count on directly accessing guest
> > > +         * memory, so they need iommu_platform=3Don to use normal DMA
> > > +         * mechanisms.  That requires disabling legacy virtio support
> > > +         * for virtio pci devices
> > > +         */
> > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy"=
, "on");
> > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platfo=
rm", "on");
> > >      }
> >=20
> > Silently changing the user's request configuration like this is a bad i=
dea.
> > The "disable-legacy" option in particular is undesirable as that switch=
es
> > the device to virtio-1.0 only mode, which exposes a different PCI ID to
> > the guest.
> >=20
> > If some options are incompatible with encryption, then we should raise a
> > fatal error at startup, so applications/admins are aware that their req=
uested
> > config is broken.
> >=20
> > Regards,
> > Daniel
>=20
> Agreed - my suggestion is an on/off/auto property, auto value
> changes automatically, on/off is validated.

So, I think you're specifically suggesting this for the
"iommu_platform" property, by delaying determining which mode to use
until the guest activates the device.  Is that correct?

That might work on s390, but I don't think it will work on POWER on at
least 2 counts:

1) qemu doesn't actually have a natural way of determining if a guest
   is in secure mode (that's handled directly between the guest and
   the ultravisor).  So even at driver init time, we won't know the
   right value.

2) for virtio-pci, iommu_platform=3Don requires a "modern" device, not a
   legacy or transitional one.  That changes the PCI ID, which means
   we can't delay deciding it until driver init

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl70L9kACgkQbDjKyiDZ
s5I6Hg//Rx5B/v6Y8PzHwMOhv7I/WYbRPF1knRhJJ8Ap0q8PVd1GgnGb9gGVpY/8
JsGhuwVXuyt/DwZXuwp4wgWdwzNaS8ewB6UBRezkBRh9oqRfXumEWDJP0kTmDabt
NuvAPuBanETHEk5mN3oOoACz0C2+UgtOMoBqId13DBb7hvJLEXlov5Je3LjPYgE4
5mjHIMFDpXm8cj7v8zPBn/Sh8JrKdpZIahy4v1br0Z723A9QnSmQYaOn7aYI+9xE
v7VF56HWP9W5L7kJ7SblvIxzP4ZJtObJqGX87u1Lx5/3XsJLO3AFnkXA2JJX8mv8
LQnfI5RdwEruNM4cMF1fUNP02bOeOckW/4OD339ZPgXKcO4kUB6dwoCI0g7BNy87
f80Y8gxRkpSu1v1wmf3q7ve2DPu52TStAMH2TOI2FNhpQ4j/qWk5JCeOStXzAfUd
4rxp01ud86Z3hCcz36aobYQ94d2ZqgKtU355+0I925verK5zlQ+6xR1J1NuLKtW3
BjAiQSAYEygs/QBTGHsUkbD2FFpeVxUZtwchxVA3TQ+F47yGHrkniWe82TCPx6y8
Vl33PVmJh2Mugm325YkGWv8aFDbQdBl2xVj89VIEq8ttDncB74BDM2fw3ghTLfNp
XTRIvXQZNZO+jmXohuv7T5GNH9e/0oGkj9Qb/AJgvohziYZxwwU=
=EYAo
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
