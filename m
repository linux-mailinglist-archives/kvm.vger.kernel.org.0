Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA68223D6B6
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 08:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgHFGOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 02:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgHFGOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 02:14:48 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A507C061574
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 23:14:48 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BMdW4287Fz9sTM; Thu,  6 Aug 2020 16:14:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1596694480;
        bh=E94wXZ2GlavC447zASL2IKC3b3NumERC58sX0/K4mZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pPDsnCojqRzYzDke8RrPxvCY7sjGhqwIe3fqjbqo7m6td53TSr+KpXsutxC4HWqhb
         dPhixOHwAnpOWa8kB0wYDdjIgI5K5MPvxUHz0GMpFGKv7K3bOXq6b/MujvdmdSTQS7
         A+KZt/WzZlYhb+zGKJWcAFwUcRcwRgVhqLPptdr4=
Date:   Thu, 6 Aug 2020 16:14:12 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200806061412.GB157233@yekko.fritz.box>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-11-david@gibson.dropbear.id.au>
 <20200727175040.7beca3dd.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20200727175040.7beca3dd.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2020 at 05:50:40PM +0200, Cornelia Huck wrote:
> On Fri, 24 Jul 2020 12:57:44 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > At least some s390 cpu models support "Protected Virtualization" (PV),
> > a mechanism to protect guests from eavesdropping by a compromised
> > hypervisor.
> >=20
> > This is similar in function to other mechanisms like AMD's SEV and
> > POWER's PEF, which are controlled bythe "host-trust-limitation"
> > machine option.  s390 is a slightly special case, because we already
> > supported PV, simply by using a CPU model with the required feature
> > (S390_FEAT_UNPACK).
> >=20
> > To integrate this with the option used by other platforms, we
> > implement the following compromise:
> >=20
> >  - When the host-trust-limitation option is set, s390 will recognize
> >    it, verify that the CPU can support PV (failing if not) and set
> >    virtio default options necessary for encrypted or protected guests,
> >    as on other platforms.  i.e. if host-trust-limitation is set, we
> >    will either create a guest capable of entering PV mode, or fail
> >    outright
> >=20
> >  - If host-trust-limitation is not set, guest's might still be able to
> >    enter PV mode, if the CPU has the right model.  This may be a
> >    little surprising, but shouldn't actually be harmful.
>=20
> This could be workable, I guess. Would like a second opinion, though.
>=20
> >=20
> > To start a guest supporting Protected Virtualization using the new
> > option use the command line arguments:
> >     -object s390-pv-guest,id=3Dpv0 -machine host-trust-limitation=3Dpv0
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  hw/s390x/pv.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >=20
> > diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
> > index ab3a2482aa..4bf3b345b6 100644
> > --- a/hw/s390x/pv.c
> > +++ b/hw/s390x/pv.c
> > @@ -14,8 +14,11 @@
> >  #include <linux/kvm.h>
> > =20
> >  #include "cpu.h"
> > +#include "qapi/error.h"
> >  #include "qemu/error-report.h"
> >  #include "sysemu/kvm.h"
> > +#include "qom/object_interfaces.h"
> > +#include "exec/host-trust-limitation.h"
> >  #include "hw/s390x/ipl.h"
> >  #include "hw/s390x/pv.h"
> > =20
> > @@ -111,3 +114,61 @@ void s390_pv_inject_reset_error(CPUState *cs)
> >      /* Report that we are unable to enter protected mode */
> >      env->regs[r1 + 1] =3D DIAG_308_RC_INVAL_FOR_PV;
> >  }
> > +
> > +#define TYPE_S390_PV_GUEST "s390-pv-guest"
> > +#define S390_PV_GUEST(obj)                              \
> > +    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
> > +
> > +typedef struct S390PVGuestState S390PVGuestState;
> > +
> > +/**
> > + * S390PVGuestState:
> > + *
> > + * The S390PVGuestState object is basically a dummy used to tell the
> > + * host trust limitation system to use s390's PV mechanism.  guest.
> > + *
> > + * # $QEMU \
> > + *         -object s390-pv-guest,id=3Dpv0 \
> > + *         -machine ...,host-trust-limitation=3Dpv0
> > + */
> > +struct S390PVGuestState {
> > +    Object parent_obj;
> > +};
> > +
> > +static int s390_pv_kvm_init(HostTrustLimitation *gmpo, Error **errp)
> > +{
> > +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> > +        error_setg(errp,
> > +                   "CPU model does not support Protected Virtualizatio=
n");
> > +        return -1;
> > +    }
> > +
> > +    return 0;
> > +}
>=20
> So here's where I'm confused: If I follow the code correctly, the
> ->kvm_init callback is invoked before kvm_arch_init() is called. The
> kvm_arch_init() implementation for s390x checks whether
> KVM_CAP_S390_PROTECTED is available, which is a pre-req for
> S390_FEAT_UNPACK. Am I missing something? Can someone with access to PV
> hardware check whether this works as intended?

Ah, yes, I need to rethink this.  kvm_arch_init() happens
substantially earlier than I realized.  Plus the setup of s390 cpu
models is confusing to me, it seems to set up the model after the cpu
instance is created, rather than having cpu models correspond to cpu
classes and thus existing before the cpus are actually instantiated.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl8rn7IACgkQbDjKyiDZ
s5IjZxAAk1TG+FWxo6+7eJ2SPBjkDNS+NfsIKnPsEQkZ3wTEc1YzXH/9Jb0M1CHX
FNBBF4U+WtDiPpsRonouzEcXpclXmRZ/bz/WfN+rWi/o18sahgqZJohx5xQpKEhM
hWfXUcw9izpX7syLU+ss0DviRV8ngPibpWhE4Bz34Fpcb2pHc4BeIoF40ylX0R/d
oLag20XQy5XknpfKN5Zo6AmTyGWBNGPzGmH6wNMu0q+RZ8wvmZA8O4CociE5x32P
v/UePLQxX84+FWKTGZLi04Dmv5sYipPBWIrBXdoARDwM6sOzo40WtkRAoPtka/CM
I6DgWNZGGCtAJirTP9lsJYkvCsWyTH+O6KkGSLu4Zof18/dgT2IP9cKwSHf4dQ0X
5cnmPOlHedudfmHIT2px9XTynnu/Gwt8xubZRWsYlC3FsYhdlgXW1SCeIeRXUI7+
LC9CfnuDqX787au66KtORWM7J15Q5/dE8RwvCoQ55M/7vriPIXkR8Wqb1t+rhU75
1Apo2YITmWORQW4VMvtnOO3reGNZv++04yxLGCWNZNrCIR9M1tFG9j8sYEwidElk
p6AAnWrc9oV/V66GFUp0yO+z8xLxdkbw+zWjSVXqGiat92GgKGRCTfNG8xB96Lu2
9xN8xl++gLa3s3e2mzzip2s5zyaA7V2y/NsSczpWFr+7H1EVvbM=
=+kII
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
