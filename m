Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47761F5209
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 12:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgFJKPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 06:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJKPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 06:15:43 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B55C03E96B
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 03:15:42 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49hjYT1vynz9sRW; Wed, 10 Jun 2020 20:15:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591784141;
        bh=5gLDvASBqH5FgJ9nZHm6ipJ5CX5BAt2ppNrnlbEf/u0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nj5nPdDqcl+C7G8P7eev2c+MIkh/GMrm/Sk0vIRrQrU4fCV2MxGeO4btse7Li7f34
         BDzEJwxNfuBtWgpPlimjYvAZRfroPBiihTqfJVxNju/Htgf3VCIS9ikcsau6y3pNMm
         i7m8YAeoTSQ6XSz4rWFIxf3c8rcfJkMTPYwyfGjs=
Date:   Wed, 10 Jun 2020 20:07:29 +1000
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
Message-ID: <20200610100729.GN494336@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-19-david@gibson.dropbear.id.au>
 <20200606162014-mutt-send-email-mst@kernel.org>
 <20200607030735.GN228651@umbus.fritz.box>
 <20200609121641.5b3ffa48.cohuck@redhat.com>
 <20200610043922.GI494336@umbus.fritz.box>
 <20200610104842.2687215a.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="b1ERR0FXR0PvNIRE"
Content-Disposition: inline
In-Reply-To: <20200610104842.2687215a.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--b1ERR0FXR0PvNIRE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2020 at 10:48:42AM +0200, Cornelia Huck wrote:
> On Wed, 10 Jun 2020 14:39:22 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > On Tue, Jun 09, 2020 at 12:16:41PM +0200, Cornelia Huck wrote:
> > > On Sun, 7 Jun 2020 13:07:35 +1000
> > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > >  =20
> > > > On Sat, Jun 06, 2020 at 04:21:31PM -0400, Michael S. Tsirkin wrote:=
 =20
> > > > > On Thu, May 21, 2020 at 01:43:04PM +1000, David Gibson wrote:   =
=20
> > > > > > The default behaviour for virtio devices is not to use the plat=
forms normal
> > > > > > DMA paths, but instead to use the fact that it's running in a h=
ypervisor
> > > > > > to directly access guest memory.  That doesn't work if the gues=
t's memory
> > > > > > is protected from hypervisor access, such as with AMD's SEV or =
POWER's PEF.
> > > > > >=20
> > > > > > So, if a guest memory protection mechanism is enabled, then app=
ly the
> > > > > > iommu_platform=3Don option so it will go through normal DMA mec=
hanisms.
> > > > > > Those will presumably have some way of marking memory as shared=
 with the
> > > > > > hypervisor or hardware so that DMA will work.
> > > > > >=20
> > > > > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > > > > ---
> > > > > >  hw/core/machine.c | 11 +++++++++++
> > > > > >  1 file changed, 11 insertions(+)
> > > > > >=20
> > > > > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > > > > index 88d699bceb..cb6580954e 100644
> > > > > > --- a/hw/core/machine.c
> > > > > > +++ b/hw/core/machine.c
> > > > > > @@ -28,6 +28,8 @@
> > > > > >  #include "hw/mem/nvdimm.h"
> > > > > >  #include "migration/vmstate.h"
> > > > > >  #include "exec/guest-memory-protection.h"
> > > > > > +#include "hw/virtio/virtio.h"
> > > > > > +#include "hw/virtio/virtio-pci.h"
> > > > > > =20
> > > > > >  GlobalProperty hw_compat_5_0[] =3D {};
> > > > > >  const size_t hw_compat_5_0_len =3D G_N_ELEMENTS(hw_compat_5_0);
> > > > > > @@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState=
 *machine)
> > > > > >           * areas.
> > > > > >           */
> > > > > >          machine_set_mem_merge(OBJECT(machine), false, &error_a=
bort);
> > > > > > +
> > > > > > +        /*
> > > > > > +         * Virtio devices can't count on directly accessing gu=
est
> > > > > > +         * memory, so they need iommu_platform=3Don to use nor=
mal DMA
> > > > > > +         * mechanisms.  That requires disabling legacy virtio =
support
> > > > > > +         * for virtio pci devices
> > > > > > +         */
> > > > > > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-l=
egacy", "on");
> > > > > > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_=
platform", "on");
> > > > > >      }
> > > > > >     =20
> > > > >=20
> > > > > I think it's a reasonable way to address this overall.
> > > > > As Cornelia has commented, addressing ccw as well   =20
> > > >=20
> > > > Sure.  I was assuming somebody who actually knows ccw could do that=
 as
> > > > a follow up. =20
> > >=20
> > > FWIW, I think we could simply enable iommu_platform for protected
> > > guests for ccw; no prereqs like pci's disable-legacy. =20
> >=20
> > Right, and the code above should in fact already do so, since it
> > applies that to TYPE_VIRTIO_DEVICE, which is common.  The
> > disable-legacy part should be harmless for s390, since this is
> > effectively just setting a default, and we don't expect any
> > TYPE_VIRTIO_PCI devices to be instantiated on z.
>=20
> Well, virtio-pci is available on s390, so people could try to use it --
> however, forcing disable-legacy won't hurt in that case, as it won't
> make the situation worse (I don't expect virtio-pci to work on s390
> protected guests.)

Sure, and if by whatever chance it does work, then you'll need
iommu_platform, and therefore disable-legacy for it.

> > > > > as cases where user has
> > > > > specified the property manually could be worth-while.   =20
> > > >=20
> > > > I don't really see what's to be done there.  I'm assuming that if t=
he
> > > > user specifies it, they know what they're doing - particularly with
> > > > nonstandard guests there are some odd edge cases where those
> > > > combinations might work, they're just not very likely. =20
> > >=20
> > > If I understood Halil correctly, devices without iommu_platform
> > > apparently can crash protected guests on s390. Is that supposed to be=
 a
> > > "if it breaks, you get to keep the pieces" situation, or do we really
> > > want to enforce iommu_platform? =20
> >=20
> > I actually think "if you broke it, keep the pieces" is an acceptable
> > approach here, but that doesn't preclude some further enforcement to
> > improve UX.
>=20
> I'm worried about spreading dealing with this over too many code areas,
> though.



--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--b1ERR0FXR0PvNIRE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7gsN4ACgkQbDjKyiDZ
s5KZvhAA4chv1INn0PbPqyDhAHGi2hmU1pJWnjBL7KwGBYE0AvU/n3yweh9j3Qb1
Glzz/R3XAar8hDpMtZNbdonCj/QQ5Q/DdW/VaS93Ly/exm41AXKrU6h+inKFFq8E
RMQXqXssLWDkKEhk3JlyTj4VWPtvUIQJmG9p1DO4WgT8LdQk5gH0VLMR9mbmILVc
j74YSBuwKRv3gQ7+fSll+qcEN4wYRi4ZQl1skIeWVzVErynKa9CwcOHhw2RK9fZV
vBpMUjQvSKqYaxyb4aFsAidx9sB89o2CkXqgUeUYFUNQUUylALq4KJaL7z+abXjl
fGCSGxGNwifxIQtfnhmUuvK8P5OyQ8ubxZP7JVpjPb1YFXGvYAnFXoylqUlBSVdx
g6zN0QwGCnPDqUbBkOmtTBslYnFbGkp44EEDgIM9jZJpYWm670617iLIMr0mjT/N
ua1+FmiSwCUOJE5j1GsT08R3z9MhBSk5B5u4pG9NQiwICGK7UCcZVvb3ZolFgRvb
zjX9RESTthsoL2ZyKU/RuefLAJog5SYPUc0mxsCBM3X1Zij+kUcEOnHrNsOCcygb
IrjJlQBEQoUJE7zMQZ/zSGpx2jg4Ky/88Za45aOSaZTgnfe5bVa3hpHqQnZE9bXH
nK6Dy+3Uw/SdgC/mEaNjoEIQnMFho0qxGacFcq5FKqbADOp569Y=
=B8IL
-----END PGP SIGNATURE-----

--b1ERR0FXR0PvNIRE--
