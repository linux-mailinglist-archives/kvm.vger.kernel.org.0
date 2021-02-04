Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8C130EA71
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 03:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhBDCvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 21:51:32 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:51745 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233875AbhBDCvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 21:51:31 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DWNMr3fwqz9t0J; Thu,  4 Feb 2021 13:50:48 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612407048;
        bh=v1ouEE19lRP4+g+UVF5ceV1+C7vNtzNzXxc2/9RESoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VtC/qSJrg+g8MjkZbYfGVu/t+QQVGEB4OmOz1hlU0/Z5hb9pmKn7Rw/Tj0XGv4sIK
         +xLh/ceMnvEK2mA1fMU0aIplF6BFnTb1i6POojdKmza+p5XO1GuQk218vcwjrV/pur
         1vi/wTljZpYXJasWmI31nweXaJpuWBQ8ziQZwJ9g=
Date:   Thu, 4 Feb 2021 13:45:48 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Greg Kurz <groug@kaod.org>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com,
        pragyansri.pathi@intel.com, richard.henderson@linaro.org,
        berrange@redhat.com, David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v8 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210204024548.GA4729@yekko.fritz.box>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
 <20210202041315.196530-8-david@gibson.dropbear.id.au>
 <20210203171548.0d8e0494@bahia.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20210203171548.0d8e0494@bahia.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 03, 2021 at 05:15:48PM +0100, Greg Kurz wrote:
> On Tue,  2 Feb 2021 15:13:09 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
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
> s/fasible/feasible

Fixed, thanks.

>=20
> Anyway,
>=20
> Reviewed-by: Greg Kurz <groug@kaod.org>
>=20
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

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAbX9wACgkQbDjKyiDZ
s5Ki0Q/9Hg8APeo1nsowCYqfcZ0BZzznrNdkwS+B0W8Z+6wHYanCfzzBT+pOFLPo
elnkQbhAjJZkzOPsLGtS0vnbMZ0fG8xr8y5HQtIwutak/gLvgzrFFFVIwg5YjJlW
l/Y69O1DghWe+cWC/M7hH6j2oReAFCCDa1ep5xYsYSe8bkPZGkiswKdFNVLtcwY/
0vgIutDYHhSlFiJWoHCQcHfCf8DXRaADWJJ9H5LhwPFG3qs04IYy8+RarAkxURFN
DgoAbi52SosvX5UiEFf4ddyuzCshvxXH1aq3am+mR7ffdvifMArgmd0MCm/MMI3Z
7QF8/Yzp7epiUzZnlwjh/qPOrRbukWvqw+csO62TbcmHQhWGzhgwsMFdPJLrNwQj
0H2Wjb36Cw43b+iAVSMN9rkIlXulO2l4KvBB+VtiCHHnzNdo8lV808OB+LxL9cLg
7/a98502L8r+2jn8FtY+PSClak6ah2yvhe40G9M4R90nCqcLVMRfczYhIgsiJ2iU
EwAFYjVr/dXRtytT8sGvXr7yksHVz6vXtlydslaG0nTVaZIhntS0BGYQeC6Z794Y
QPTpMpEiic/weHP5DICtGZ8zDELO8u7WjXTUeNDSTWnEO9wDoTDe2zXE8F7ysjt4
tenERcGGd3yfReUkwmCp1sbLYcMxtBeZpmYQ33fOqUKYRJGjI6Y=
=Km6C
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
