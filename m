Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D971F096D
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 05:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgFGDVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 23:21:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50697 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgFGDVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 23:21:22 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49fhVl42Z1z9sSf; Sun,  7 Jun 2020 13:21:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591500079;
        bh=sjxcB2ZCXQs3QAHxQ+jllLLgJ3Mg6gEnyr8XxHJVoes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d4OhZP2gompTbni7TJSU3GiP+7lrPUYcdefp9fn4Et0l/jj1HhNx9vOSU7wCR1QCQ
         aDwnLMbB0d6RWdcoijAIMSqv/aNGeR+pBY9eFBfYRdPsixtF/OgF056S7AYyS8jNLA
         B83auEeeC1HOkUUuCLT7w2XjNHjqGBlTaK40BNik=
Date:   Sun, 7 Jun 2020 13:07:35 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 18/18] guest memory protection: Alter virtio default
 properties for protected guests
Message-ID: <20200607030735.GN228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-19-david@gibson.dropbear.id.au>
 <20200606162014-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WeDu0lr7bteb/II5"
Content-Disposition: inline
In-Reply-To: <20200606162014-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--WeDu0lr7bteb/II5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 06, 2020 at 04:21:31PM -0400, Michael S. Tsirkin wrote:
> On Thu, May 21, 2020 at 01:43:04PM +1000, David Gibson wrote:
> > The default behaviour for virtio devices is not to use the platforms no=
rmal
> > DMA paths, but instead to use the fact that it's running in a hypervisor
> > to directly access guest memory.  That doesn't work if the guest's memo=
ry
> > is protected from hypervisor access, such as with AMD's SEV or POWER's =
PEF.
> >=20
> > So, if a guest memory protection mechanism is enabled, then apply the
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
> > index 88d699bceb..cb6580954e 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -28,6 +28,8 @@
> >  #include "hw/mem/nvdimm.h"
> >  #include "migration/vmstate.h"
> >  #include "exec/guest-memory-protection.h"
> > +#include "hw/virtio/virtio.h"
> > +#include "hw/virtio/virtio-pci.h"
> > =20
> >  GlobalProperty hw_compat_5_0[] =3D {};
> >  const size_t hw_compat_5_0_len =3D G_N_ELEMENTS(hw_compat_5_0);
> > @@ -1159,6 +1161,15 @@ void machine_run_board_init(MachineState *machin=
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
>=20
> I think it's a reasonable way to address this overall.
> As Cornelia has commented, addressing ccw as well

Sure.  I was assuming somebody who actually knows ccw could do that as
a follow up.

> as cases where user has
> specified the property manually could be worth-while.

I don't really see what's to be done there.  I'm assuming that if the
user specifies it, they know what they're doing - particularly with
nonstandard guests there are some odd edge cases where those
combinations might work, they're just not very likely.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--WeDu0lr7bteb/II5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7cWeoACgkQbDjKyiDZ
s5KsURAAhiR6V12OFx0b5uCHQEi27xZICTkD74JVTRf00hH+bj7Lt2QZP4u1E/LX
Bdrz2en9NcEm0c58y/ksosrzrq1stDpcepqJT27EES8GfNJ+O0b/4OA4w3EglxC4
xrs6P7zlihJBf7X5jTRRbdwz7pmvismuPewerVGfcBBtQYWNnKko/6DHMYVi4Zqg
W4YdWv0uhEUGI2uxQvU5II6Bo5sUiQlr6AyecP6i+uG0+0zMfjMDnz8WL+IlaOfJ
+4KW1qqa2tTRUfz0XpXZNETTyjQJT2wuUFcc7n7bTQGHvtFrRu4snDzHX63fSlpP
F//JMD6X0rtMXsGCD0wRHZoljBOUXCF17+hF4w3+aQXdw4g+H93RYZlslV2L9IQE
TS35iCtGka8cRUPHxPhMT1hnQUInHTqFEW+bUqonhZZpx8iiZosoLeryrvKVEaUn
AQY6UJty6NN+vaGbBDAQK5mnO1eFuiyB7SItwTguH0yqy4J1hsxo1/XNUPLpk1i5
T7PgRcRGpA3hQefM8yhPlKTtRVoX+fpzeN9MOqE9a4PSaGN8OAKoX1ylvdTEv7IK
IEd/I54C0BrwFoQxnQJ8ciEsuZAC0j8IqYoEwvb3FXh59OvWwO06+QFJaJXwuQ1c
l30E6wGpXz0boBr+cIFc/8QFQjKS1paMBBbI52dmvaUlBppRG8k=
=XDyW
-----END PGP SIGNATURE-----

--WeDu0lr7bteb/II5--
