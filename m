Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3C32656D8
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 04:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgIKCEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 22:04:51 -0400
Received: from ozlabs.org ([203.11.71.1]:35827 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbgIKCEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 22:04:51 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BnfG760H0z9sVD; Fri, 11 Sep 2020 12:04:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1599789887;
        bh=UEYW9bd4ufUoKe/6L46GU0olcLvQXPJyyqz3qnQQFNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cVpjOr9dW+lEJbnJyXROtSVk6K90ja5dYhsNlxXkr25fkWIBhb3eK+cyM0bvViP7x
         RjDeXE76qlwn1hy5O8l4Pr/oHOuPQh00ARQKCsuH05baiiNKNlwHAFsw5nzHx85sp4
         DsGQAfm3QlzcBGtVtp8mioEtWi7TVseOeRDsiOuU=
Date:   Fri, 11 Sep 2020 12:04:42 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Boris Fiuczynski <fiuczy@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>
Subject: Re: [for-5.2 v4 09/10] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200911020442.GH66834@yekko.fritz.box>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-10-david@gibson.dropbear.id.au>
 <20200907171046.18211111.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Bg2esWel0ueIH/G/"
Content-Disposition: inline
In-Reply-To: <20200907171046.18211111.pasic@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Bg2esWel0ueIH/G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 07, 2020 at 05:10:46PM +0200, Halil Pasic wrote:
> On Fri, 24 Jul 2020 12:57:43 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
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
>=20
> Sorry for being this late. I had to do some high priority debugging,
> which made me drop everything else, and after that I had some vacation.
>=20
> I have some questions about the bigger picture. The promised benefit of
> this patch for users that invoke QEMU manually is relatively clear: it
> alters the default value of some virtio properties, so that using the
> defaults does not result in a bugous configuration.

Right.

> This comes at a price. I used to think of device property default values
> like this. If I don't specify it and I use the default machine, I will
> effectively get the the default value of of the property (as reported by
> qemu -device dev-name,?). If I use a compat machine, then I will get the
> compatibility default value: i.e. the what is reported as the default
> value, if I invoke the binary whose default machine is my compat machine.

Hm, ok.  My mental model has always been that defaults were
essentially per-machine-type.  Which, I grant you isn't really
consistent with the existence of the -device dev,? probing.  On the
other hand, it's possible for a machine/platforms to impose
restrictions on almost any property of almost any device, and it would
suck for the user to have to know all of them just in order to start
things up with default options.

Given that model, extending that to per-machine-variant, including
machine options like htl seemed natural.

> With this patch, that reasoning is not valid any more. Did we do
> something like this before, or is this the first time we introduce this
> complication?

I don't know off hand if we have per-machine differences for certain
options in practice, or only in theory.

> In any case, I suppose, this change needs a documentation update, which I
> could not find in the series.

Uh.. fair enough.. I just need to figure out where.

> How are things supposed to pan out when QEMU is used with management
> software?
>=20
> I was told that libvirt's policy is to be explicit and not let QEMU use
> defaults. But this policy does not seem to apply to iommu_platform -- at
> least not on s390x. Why is this? Is this likely to change in the future?

Ugh.. so.  That policy of libvirt's is very double edged.  It's there
because it allows libvirt to create consistent machines that can be
migrated properly and so forth.  However, it basically locks libvirt
into having to know about every option of qemu, ever.  Unsurprisingly
there are some gaps, hence things like this.

Unfortunately that can't be fixed without substantially redesigning
libvirt in a way that can't maintain compatibility.

> Furthermore, the libvirt documentation is IMHO not that great when it
> comes to iommu_platform. All I've found is=20
>=20
> """
> Virtio-related options
>=20
>=20
> QEMU's virtio devices have some attributes related to the virtio transpor=
t under the driver element: The iommu attribute enables the use of emulated=
 IOMMU by the device.=20
> """
>=20
> which:
> * Is not explicit about the default, but suggests that default is off
>   (because it needs to be enabled), which would reflect the current state
>   of affairs (without this patch).
> * Makes me wonder, to what extent does the libvirt concept correspond
>   to the virtio semantics of _F_ACCESS_PLATFORM. I.e. we don't really
>   do any IOMMU emulation with virtio-ccw.
>=20
> I guess host trust limitation is something that is to be expressed in
> libvirt, or? Do we have a design for that?

Yeah, I guess we'd need to.  See "having to know about every option"
above :/.  No, I haven't thought about a design for that.

> I was also reflecting on how does this patch compare to on/off/auto, but
> this email is already too long, so decided keep my thoughts for myself
> -- for now.

on/off/auto works for your case on s390, but I don't think it works
for POWER, though I forget the details, so maybe I'm wrong about that.


>=20
> Regards,
> Halil
>=20
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  hw/core/machine.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >=20
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index b599b0ba65..2a723bf07b 100644
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
> > @@ -1161,6 +1163,15 @@ void machine_run_board_init(MachineState *machin=
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
> > =20
> >      machine_class->init(machine);
>=20
>=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--Bg2esWel0ueIH/G/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl9a2zgACgkQbDjKyiDZ
s5LUWQ/+JAEQF1QbBjie/H5DePAHcxyz0RicZ/ylbFd9VrPJxg4Xtmjb5SEZZNLu
HelpPexAlX58cpxwyCdRYcBEKlaxowOXsxcPoQ33wwXaksLNuneyi+fB3QuE6y51
VMm3xwieIun9oBWsNZZ4Bfl0uvsZlxAozqFAekcqpJKWwo4egSTAfkIfXWyC2ayd
XRBTPucT60ZrJ34eMKD2r9eSTjjHo/hL1/pTheRnBVaJuz6HxiCV+qkGueqhWkTQ
SfYD6iTcezjZ9Rk46KBSjv1dgQgWSIfv9sXuobuumvmDTJkGucOkQOJu3tOXn1ib
bOpSsjdY+p4X18QynQcJV51VbltL2Oi3dzo0X2JbdrB1QBdldZXlEl7PeRzTDXzD
cB07l0EYKHX7ylAj902/5w+H0D+vgWDzaygxA0GqdeRS678HW7NyW+oRJ+TaS/os
Q/VWrEyeczGqMFT3O9nLosBTTIzc7Pv8yo25QJOSAwNYgJZUSdeGfjszg4w7PTgQ
Kbn6iN6NSYwTFumlmr5ncE9RK6QmqIgIkF34Of9zkvNmsDgxAGPPuRao94oQSzQO
fOhXuZzNMWYu/3BkyIUv3YrmeFABpvQDD9naN4sRWRfbgyuujdAljudRn8mkEY1s
KTI7N3VfJ0kQ5p79OD5wY/GCC7jhShEXq9K69ANiDW6Z5DaabNU=
=rqX/
-----END PGP SIGNATURE-----

--Bg2esWel0ueIH/G/--
