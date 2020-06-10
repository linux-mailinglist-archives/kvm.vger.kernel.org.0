Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80871F4C83
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 06:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgFJEqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 00:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgFJEqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 00:46:13 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7098FC03E96F
        for <kvm@vger.kernel.org>; Tue,  9 Jun 2020 21:46:11 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49hZFD1CVYz9sTF; Wed, 10 Jun 2020 14:46:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591764368;
        bh=Osaf39fCSY/1qSzfninEWFGQENOi5n5CA+3SvumXfy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THxvZXdqGTXnESoQQpJeej6P8xYOT8lMa9o4VHfZe1Dkmug+Jy8W9b0CK0OECSjn4
         m36BI71Pl0ZljmzxZUsQtFIPMOWYRk8VFJxEwhbtPKFJOI21tJZdTICuikrvmWofXd
         3++xX9IW6CIhlFTEqxHHgwQ5yFTlFbNZ/nuYeF4c=
Date:   Wed, 10 Jun 2020 14:39:22 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com, qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [RFC v2 18/18] guest memory protection: Alter virtio default
 properties for protected guests
Message-ID: <20200610043922.GI494336@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-19-david@gibson.dropbear.id.au>
 <20200606162014-mutt-send-email-mst@kernel.org>
 <20200607030735.GN228651@umbus.fritz.box>
 <20200609121641.5b3ffa48.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="e5GLnnZ8mDMEwH4V"
Content-Disposition: inline
In-Reply-To: <20200609121641.5b3ffa48.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--e5GLnnZ8mDMEwH4V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 09, 2020 at 12:16:41PM +0200, Cornelia Huck wrote:
> On Sun, 7 Jun 2020 13:07:35 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > On Sat, Jun 06, 2020 at 04:21:31PM -0400, Michael S. Tsirkin wrote:
> > > On Thu, May 21, 2020 at 01:43:04PM +1000, David Gibson wrote: =20
> > > > The default behaviour for virtio devices is not to use the platform=
s normal
> > > > DMA paths, but instead to use the fact that it's running in a hyper=
visor
> > > > to directly access guest memory.  That doesn't work if the guest's =
memory
> > > > is protected from hypervisor access, such as with AMD's SEV or POWE=
R's PEF.
> > > >=20
> > > > So, if a guest memory protection mechanism is enabled, then apply t=
he
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
> > > > index 88d699bceb..cb6580954e 100644
> > > > --- a/hw/core/machine.c
> > > > +++ b/hw/core/machine.c
> > > > @@ -28,6 +28,8 @@
> > > >  #include "hw/mem/nvdimm.h"
> > > >  #include "migration/vmstate.h"
> > > >  #include "exec/guest-memory-protection.h"
> > > > +#include "hw/virtio/virtio.h"
> > > > +#include "hw/virtio/virtio-pci.h"
> > > > =20
> > > >  GlobalProperty hw_compat_5_0[] =3D {};
> > > >  const size_t hw_compat_5_0_len =3D G_N_ELEMENTS(hw_compat_5_0);
> > > > @@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState *ma=
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
> > > >   =20
> > >=20
> > > I think it's a reasonable way to address this overall.
> > > As Cornelia has commented, addressing ccw as well =20
> >=20
> > Sure.  I was assuming somebody who actually knows ccw could do that as
> > a follow up.
>=20
> FWIW, I think we could simply enable iommu_platform for protected
> guests for ccw; no prereqs like pci's disable-legacy.

Right, and the code above should in fact already do so, since it
applies that to TYPE_VIRTIO_DEVICE, which is common.  The
disable-legacy part should be harmless for s390, since this is
effectively just setting a default, and we don't expect any
TYPE_VIRTIO_PCI devices to be instantiated on z.

> > > as cases where user has
> > > specified the property manually could be worth-while. =20
> >=20
> > I don't really see what's to be done there.  I'm assuming that if the
> > user specifies it, they know what they're doing - particularly with
> > nonstandard guests there are some odd edge cases where those
> > combinations might work, they're just not very likely.
>=20
> If I understood Halil correctly, devices without iommu_platform
> apparently can crash protected guests on s390. Is that supposed to be a
> "if it breaks, you get to keep the pieces" situation, or do we really
> want to enforce iommu_platform?

I actually think "if you broke it, keep the pieces" is an acceptable
approach here, but that doesn't preclude some further enforcement to
improve UX.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--e5GLnnZ8mDMEwH4V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7gY/oACgkQbDjKyiDZ
s5J87RAAq/uYcRY7iinhqt7d90hLrzoey+nofzsZB08Y44dLMeaixQhv/77xbJHs
iOQybdAm7owLeR5Q3JcbS9FqitLKAcHVVDqat4CNNCTpjMOKleUEJXqQFQ1erbQp
IDwSXElAVM1GgUU2C3M1MllHNCV+dPawFJxn6XZvBWh4gPbweckzpjdJw3HQ9acg
X19RTUwsnYf1igM6FyQ+8Yw3xWFyRkw0qGiIPS21sGLWXxYmYdp+/ljxTjnKVhj0
ZR4290u/8KBbo8W8Tz4q19bEYiIlDe9mTunH25fQZ1bhGVqp1S5tV04+c63qSjpL
5B343P1INwA0ZIYpbltqgRylnIJqGq9jQ6hWLcOQHumomFIFgTHMNMI/U4DuqyQr
7gRJWLpElF8Enh8zLE+bpi04daDr4gCzkEubBWxIDoCp9wHxniVaFco1OmBHXST/
P9HnCt2XYeBKXPbItdEQA/Yaog4uRxb8qckybQbaLhGxe83hN4R5oI10bX0qpwEk
gCuBOdqc1ST54neeievQ+GSNlHQ6d538ffzFwfjb9+4l+ba9cbwKkfvJSytY9RnE
rWCGR2HPR97cpMHybqk8UDNWAVSTLKpj2b3gKhaMfmwKtIJTz+O49btyj92WXVH2
qGLzrVUFi/rtuTqtpY7+aGLxYhh1uXQjQ4+65trpwhXnLNCuNRo=
=pTND
-----END PGP SIGNATURE-----

--e5GLnnZ8mDMEwH4V--
