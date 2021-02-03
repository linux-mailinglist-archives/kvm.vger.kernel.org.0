Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A419430D2B0
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 05:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBCEzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 23:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhBCEzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 23:55:24 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EA4C061573
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 20:54:44 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DVq9F12dCz9tlJ; Wed,  3 Feb 2021 15:54:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612328081;
        bh=CNQgVW9SbTV4ZWlIklx+uRK7Uo+Sn+f3cTnJJojbiGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M8T83j8bh4wwrXJOaDH4Kjf9vSMABZO/RVe1xeJ26RfptpzrQ85gx4SZdYJLp4j09
         M3UCnxMPJE7nnjD0qtQf5zmVQx7bXO3Gqmq/FojBG6wzJGDGaEvPBshzwtE6wDGcyy
         8n6NWI7DXx8AfiLT4gDDTjCGN3Pj70ZGN+DIW1/o=
Date:   Wed, 3 Feb 2021 15:53:04 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com,
        pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        qemu-s390x@nongnu.org, thuth@redhat.com, frankja@linux.ibm.com,
        jun.nakajima@intel.com, andi.kleen@intel.com,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v8 12/13] confidential guest support: Alter virtio
 default properties for protected guests
Message-ID: <20210203045304.GE2251@yekko.fritz.box>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
 <20210202041315.196530-13-david@gibson.dropbear.id.au>
 <20210202180328-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T6xhMxlHU34Bk0ad"
Content-Disposition: inline
In-Reply-To: <20210202180328-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--T6xhMxlHU34Bk0ad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2021 at 06:06:34PM -0500, Michael S. Tsirkin wrote:
> On Tue, Feb 02, 2021 at 03:13:14PM +1100, David Gibson wrote:
> > The default behaviour for virtio devices is not to use the platforms no=
rmal
> > DMA paths, but instead to use the fact that it's running in a hypervisor
> > to directly access guest memory.  That doesn't work if the guest's memo=
ry
> > is protected from hypervisor access, such as with AMD's SEV or POWER's =
PEF.
> >=20
> > So, if a confidential guest mechanism is enabled, then apply the
> > iommu_platform=3Don option so it will go through normal DMA mechanisms.
> > Those will presumably have some way of marking memory as shared with
> > the hypervisor or hardware so that DMA will work.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> > Reviewed-by: Greg Kurz <groug@kaod.org>
>=20
>=20
> > ---
> >  hw/core/machine.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >=20
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index 94194ab82d..497949899b 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -33,6 +33,8 @@
> >  #include "migration/global_state.h"
> >  #include "migration/vmstate.h"
> >  #include "exec/confidential-guest-support.h"
> > +#include "hw/virtio/virtio.h"
> > +#include "hw/virtio/virtio-pci.h"
> > =20
> >  GlobalProperty hw_compat_5_2[] =3D {};
> >  const size_t hw_compat_5_2_len =3D G_N_ELEMENTS(hw_compat_5_2);
> > @@ -1196,6 +1198,17 @@ void machine_run_board_init(MachineState *machin=
e)
> >           * areas.
> >           */
> >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > +
> > +        /*
> > +         * Virtio devices can't count on directly accessing guest
> > +         * memory, so they need iommu_platform=3Don to use normal DMA
> > +         * mechanisms.  That requires also disabling legacy virtio
> > +         * support for those virtio pci devices which allow it.
> > +         */
> > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy",
> > +                                   "on", true);
> > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform=
",
> > +                                   "on", false);
>=20
> So overriding a boolean property always poses a problem:
> if user does set iommu_platform=3Doff we are ignoring this
> silently.

No, we don't.  That's why this is register_sugar_prop() rather than an
outright set_prop().  An explicitly given option will take precedence.

> Can we change iommu_platform to on/off/auto? Then we can
> change how does auto behave.

I've never had a satisfactory explanation of what the semantics of
"auto" need to be.

>=20
> Bonus points for adding "access_platform" and making it
> a synonym of platform_iommu.
>=20
> >      }
> > =20
> >      machine_class->init(machine);
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--T6xhMxlHU34Bk0ad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAaLC8ACgkQbDjKyiDZ
s5IKVg//VEhQsxG6YSNFZlvGHGLtCASQW+t3Zjixh4R2NV4hsDOfRRBFJOuiiemg
ZAHPLAEVQxAv0B4liBQoEuS3L+dysNEa7ZSKHkznHqwV1WpYSXjOcPysUPw6PZh6
ZNQ5C3YzeIvszZ32itr7ddk812Vqkpn70djTDg5qRcOnd+f1Q0IS9wN8msc6YkNe
7mK65RucgRZZPH3PDJCCti5YVXyxUP8KXVTgLQoJvSFrpN2Q0OY4UR05uYX2nJpD
Mh0jZPUa2ZAsBecpsiJHm21MaH07eUD7zVtHnXW4QgzGmqQjtlsQxXgZsXvFLmq+
TnkktW2GKqe/vsO6HdEE2upqXk7ILSs6sIqV5/L6O0/i9K9dJ+YaloLE/f1hH6sS
9GAXGVBO2hUd+Xfq5F8m4ykKkjAq9KQEXe4KUrfndGqKDUrJQYrThfvsSmTndk06
Bqd6NBelIvnZ7klrHhot1Q36cgEcq0OjD62rrHylf1uJKODStkkxaXDvRU9l1vng
aGSipPmfmRwfPUl0g6k7Lf2Pp8e+0h9FKTY771J0YZDerqa0gdWtKkc63TuQRYls
kDIWaKmD1bLxMFc9tI93hwweIA7ZRz5gXGGRC15KujIFsmLgHP9yJBanJLDdpJQL
7Bie7nZETgaqtCtKaqACRnD4Agk4Q65kxLbTYCuRXO5Ls3KHgbw=
=DMPf
-----END PGP SIGNATURE-----

--T6xhMxlHU34Bk0ad--
