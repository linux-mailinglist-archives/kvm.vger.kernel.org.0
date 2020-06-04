Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9A1EDD1F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgFDGVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:21:35 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33051 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDGVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:21:35 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cwf4269Bz9sSf; Thu,  4 Jun 2020 16:21:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591251692;
        bh=WSRKKxwETOCL+crXoR6uGU8KuKdkAgnCfOE8wqV8RE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j5FCpNMk28ZK2Qz5mLZ4CworPhHz0W2adiMFNuKj/AsinD3MMISMJJjGtkhGc3xo2
         mcYWyekrjk+aFxXcJxycUpaDgsN2u6/zcqQ4Hyj5Xa4mSCnOMsKp/2SS30DCWYe+zf
         HRYK1aL4oJn0SE+9zUu6zsbh8dzp8j4TWeVUcv+0=
Date:   Thu, 4 Jun 2020 16:21:24 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     qemu-ppc@nongnu.org, qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200604062124.GG228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <87tuzr5ts5.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MrRUTeZlqqNo1jQ9"
Content-Disposition: inline
In-Reply-To: <87tuzr5ts5.fsf@morokweng.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--MrRUTeZlqqNo1jQ9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 04, 2020 at 01:39:22AM -0300, Thiago Jung Bauermann wrote:
>=20
> Hello David,
>=20
> David Gibson <david@gibson.dropbear.id.au> writes:
>=20
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> >
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> >
> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> >
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> >
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "guest-memory-protection" property pointing to a platform specific
> > object which configures and manages the specific details.
> >
> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
>=20
> Thank you very much for this series! Using a machine property is a nice
> way of configuring this.
>=20
> >From an end-user perspective, `-M pseries,guest-memory-protection` in
> the command line already expresses everything that QEMU needs to know,
> so having to add `-object pef-guest,id=3Dpef0` seems a bit redundant. Is
> it possible to make QEMU create the pef-guest object behind the scenes
> when the guest-memory-protection property is specified?

Not exactly - the object needs to exist for the QOM core to resolve it
before we'd have a chance to look at the value to conditionally create
the object.

What we could do, however, is always create a PEF object in the
machine, and it would just have no effect if the machine parameter
wasn't specified.

I did consider that option, but left it this way for greater
consistency with AMD SEV - there the object can't be auto-created,
since it has mandatory parameters needed to configure the encryption.

I'm open to persuasion about changing that, though.

> Regardless, I was able to successfuly launch POWER PEF guests using
> these patches:
>=20
> Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>

Ah, great.

> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.
> >
> > Note: I'm using the term "guest memory protection" throughout to refer
> > to mechanisms like this.  I don't particular like the term, it's both
> > long and not really precise.  If someone can think of a succinct way
> > of saying "a means of protecting guest memory from a possibly
> > compromised hypervisor", I'd be grateful for the suggestion.
>=20
> Is "opaque guest memory" any better? It's slightly shorter, and slightly
> more precise about what the main characteristic this guest property conve=
ys.
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--MrRUTeZlqqNo1jQ9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7YkuIACgkQbDjKyiDZ
s5J0eQ/+L0GJOeaVIQ6a2gJ+4H9gL8D/Dt7PydH5X7r9Aii9IjO+bGGEq1ZiabbV
q9p1WdYe4DrYSMr6rx/CFoBPsJ/HuoYtlO52k/Pz0kH7YpzlerTCKeZgeD6nIan6
lKaG6nXQVBz7HSMAo5QSd/PIa/oxGyf0P76efyhuAI+vwVsEQ3krLs9uEeGcCB6s
mKDFy55vkiyAXMyjvJlnAAiusrZEpWjr1Qt6S1HFtBu/DKJ9QqlJCY0tKiOWOOmv
4CEO8fYjFoPu9q/BjaPnO+HQnLpc4zwcaIf61osVxV1ix8gOGlf/P4ZeC54K5wDO
XM4IH2zQRfIhTqsQ7sh8I1kgczyULKH/f8w2O9j+uGMfgn3tIla63e/Bq42IygWh
6JXf1ypUe2RYO897eVJrgT9UVg3zQqAKgKv77LMX+tpUkUxke77pfT7xPPVcSIGz
JLqdre0rUwWI06ykdPnoe98GiyF1Zz4TtjwvEylERegBAZaF192MZWiBIqyq3Ncb
wUSekLQQobsLikgHPezYmEhGXfYQp/+4XP9Bt/uCyoViMw+BqkdEuddg81N2P4tY
kjz2zPvoC1HW3/EHwOfsIgsP30lvprLEhFvWwJSvnP5FX6qtevvSIwpKEYIZRLF/
99BC5nX/76JZW2z/jVkfWzRfKEnQFs9MTZPzW4cfdvUrbIdiWaM=
=s9HP
-----END PGP SIGNATURE-----

--MrRUTeZlqqNo1jQ9--
