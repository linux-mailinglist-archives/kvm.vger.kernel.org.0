Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27FA3197B8
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBLBFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 20:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhBLBFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 20:05:38 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57682C061756
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:04:58 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DcFf01gwbz9sS8; Fri, 12 Feb 2021 12:04:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1613091896;
        bh=xWgAjhN0D4vxzyZEfMWHtI8v3B2sEWgccscZkUJwXJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AgEA7vTxBO58TMRDn6ZfvxQK7OKmBDTEEDI8Rr2Lcf001d9J1/3mRO9bU/2jD7qO9
         7ItV6iMF1Om6yR1l+E293+b81LXhN4+sxKZn/otYC6eKUUSb9aT2tg4h7YGeI6H/jq
         pxNyh05Kx8S8qCmwFdmIWIv5a9czj6UMoAZics3s=
Date:   Fri, 12 Feb 2021 10:48:30 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com,
        pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v8 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <YCXCTs9fAJV/f7z/@yekko.fritz.box>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
 <20210202041315.196530-8-david@gibson.dropbear.id.au>
 <20210210162530.GA84305@dt>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="A3st2G4EAj1xJzch"
Content-Disposition: inline
In-Reply-To: <20210210162530.GA84305@dt>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--A3st2G4EAj1xJzch
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 10, 2021 at 10:25:30AM -0600, Venu Busireddy wrote:
> On 2021-02-02 15:13:09 +1100, David Gibson wrote:
> > The platform specific details of mechanisms for implementing
> > confidential guest support may require setup at various points during
> > initialization.  Thus, it's not really feasible to have a single cgs
> > initialization hook, but instead each mechanism needs its own
> > initialization calls in arch or machine specific code.
> >=20
> > However, to make it harder to have a bug where a mechanism isn't
> > properly initialized under some circumstances, we want to have a
> > common place, late in boot, where we verify that cgs has been
> > initialized if it was requested.
> >=20
> > This patch introduces a ready flag to the ConfidentialGuestSupport
> > base type to accomplish this, which we verify in
> > qemu_machine_creation_done().
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Reviewed-by: Greg Kurz <groug@kaod.org>
> > ---
> >  include/exec/confidential-guest-support.h | 24 +++++++++++++++++++++++
> >  softmmu/vl.c                              | 10 ++++++++++
> >  target/i386/sev.c                         |  2 ++
> >  3 files changed, 36 insertions(+)
> >=20
> > diff --git a/include/exec/confidential-guest-support.h b/include/exec/c=
onfidential-guest-support.h
> > index 3db6380e63..5dcf602047 100644
> > --- a/include/exec/confidential-guest-support.h
> > +++ b/include/exec/confidential-guest-support.h
> > @@ -27,6 +27,30 @@ OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport,=
 CONFIDENTIAL_GUEST_SUPPORT)
> > =20
> >  struct ConfidentialGuestSupport {
> >      Object parent;
> > +
> > +    /*
> > +     * ready: flag set by CGS initialization code once it's ready to
> > +     *        start executing instructions in a potentially-secure
> > +     *        guest
> > +     *
> > +     * The definition here is a bit fuzzy, because this is essentially
> > +     * part of a self-sanity-check, rather than a strict mechanism.
> > +     *
> > +     * It's not fasible to have a single point in the common machine
>=20
> Just a nit pick.
>=20
> s/fasible/feasible/

Already fixed in the version that got merged.

> > +     * init path to configure confidential guest support, because
> > +     * different mechanisms have different interdependencies requiring
> > +     * initialization in different places, often in arch or machine
> > +     * type specific code.  It's also usually not possible to check
> > +     * for invalid configurations until that initialization code.
> > +     * That means it would be very easy to have a bug allowing CGS
> > +     * init to be bypassed entirely in certain configurations.
> > +     *
> > +     * Silently ignoring a requested security feature would be bad, so
> > +     * to avoid that we check late in init that this 'ready' flag is
> > +     * set if CGS was requested.  If the CGS init hasn't happened, and
> > +     * so 'ready' is not set, we'll abort.
> > +     */
> > +    bool ready;
> >  };
> > =20
> >  typedef struct ConfidentialGuestSupportClass {
> > diff --git a/softmmu/vl.c b/softmmu/vl.c
> > index 1b464e3474..1869ed54a9 100644
> > --- a/softmmu/vl.c
> > +++ b/softmmu/vl.c
> > @@ -101,6 +101,7 @@
> >  #include "qemu/plugin.h"
> >  #include "qemu/queue.h"
> >  #include "sysemu/arch_init.h"
> > +#include "exec/confidential-guest-support.h"
> > =20
> >  #include "ui/qemu-spice.h"
> >  #include "qapi/string-input-visitor.h"
> > @@ -2497,6 +2498,8 @@ static void qemu_create_cli_devices(void)
> > =20
> >  static void qemu_machine_creation_done(void)
> >  {
> > +    MachineState *machine =3D MACHINE(qdev_get_machine());
> > +
> >      /* Did we create any drives that we failed to create a device for?=
 */
> >      drive_check_orphaned();
> > =20
> > @@ -2516,6 +2519,13 @@ static void qemu_machine_creation_done(void)
> > =20
> >      qdev_machine_creation_done();
> > =20
> > +    if (machine->cgs) {
> > +        /*
> > +         * Verify that Confidential Guest Support has actually been in=
itialized
> > +         */
> > +        assert(machine->cgs->ready);
> > +    }
> > +
> >      if (foreach_device_config(DEV_GDB, gdbserver_start) < 0) {
> >          exit(1);
> >      }
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 590cb31fa8..f9e9b5d8ae 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -737,6 +737,8 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Err=
or **errp)
> >      qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
> >      qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
> > =20
> > +    cgs->ready =3D true;
> > +
> >      return 0;
> >  err:
> >      sev_guest =3D NULL;
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--A3st2G4EAj1xJzch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAlwk4ACgkQbDjKyiDZ
s5JaSw//aZRxhFaO72/cinMj0mNK2Y0EJlhBPY8zYeG/1ln4zC8ZWHbfwYu0cTkR
4zm/VYydY6pUNd+pfH5qdxXoDHoHi1eHYD3Kqo7Hd9plmeJUBMj1MR70zNJ3i0jG
NBHJG0bPxIGk17jmaBSRWwrr2n+Hfls1TryAWf+G7IpPBuQAYQs4WmfUsLlLXc1e
z0qQM6YfRuVtlAsVz9wyzhM+WgRuWg9pczRC8iy6q9pL3EPuYphwvRwkK3kx1LoP
nngkOeu596DDgYSF0mEUBkILStcdC0EW5bBVrSUujwFwJ0AFeFPfhiNlmeXRzFPo
tZAOBtHmG0tkauxuFcP4bw2Y96JzVzS9ovP7a2TL6FgKUaC7ub/pCnX08d9f5Yab
z7JKepMveRU5DzSX0Dj5Z9cMe6IfCDQM77J/h6qAFb4xYuw5uH2mbPuvhXWB3U6g
xirFQRI3KP3iaSI1O5Yl5ODSWojYoLGFh8ukmsSSn87tEY21BlrpeIFnCgjUnySE
u8p2/ot3j6NuulvDTJS0wFnOberL7muWUFC+/hoWVvwXep2g8TU4WeiPhg9XDKJ+
itvCXBw+cL3SvYHbiHgHlIh6tY3wSFnbPtILpbhvAh0w+AOFsI6Kwju4cPxWwLDx
JaHJH07cNT7efAk9J+icUR1DDIHEeBOa814YEGgzF+wXPA8nDxA=
=qfTZ
-----END PGP SIGNATURE-----

--A3st2G4EAj1xJzch--
