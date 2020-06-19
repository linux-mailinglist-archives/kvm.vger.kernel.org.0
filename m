Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1295E2005B7
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbgFSJsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 05:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgFSJs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 05:48:29 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B36C06174E
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 02:48:29 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49pDWs72NPz9sRk; Fri, 19 Jun 2020 19:48:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592560106;
        bh=Ekm/xYDi3V6GtOmUswKGgxWYoM6fBANkvmJr7A0hObI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O9HRmw3cKjOq15hvRvKYJRavCBvwcvLMGe7Uyv2IgH5qNZHCw9N+8p5yJY4cHcuAW
         zPE9KcXx/Pbw8zLesy3xzJP1ssodf8eXXCdh8jhBdk8Wd7vLsEI/pZlQ0kwpkNyxba
         otojDE2vF2fdvGnhLMLKYnLT/Hn8EJ77zV9bWU5I=
Date:   Fri, 19 Jun 2020 19:48:20 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        cohuck@redhat.com, pasic@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200619094820.GJ17085@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1ou9v+QBCNysIXaH"
Content-Disposition: inline
In-Reply-To: <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--1ou9v+QBCNysIXaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 10:28:22AM +0200, David Hildenbrand wrote:
> On 19.06.20 04:05, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> >=20
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
>=20
> Each architecture finds its own way to vandalize the original
> architecture, some in more extreme/obscure ways than others. I guess in
> the long term we'll regret most of that, but what do I know :)

Well, sure, but that's no *more* true if we start from a common point.

> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> >=20
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> >=20
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "host-trust-limitation" property pointing to a platform specific
> > object which configures and manages the specific details.
>=20
> I consider the property name sub-optimal. Yes, I am aware that there are
> other approaches being discussed on the KVM list to disallow access to
> guest memory without memory encryption. (most of them sound like people
> are trying to convert KVM into XEN, but again, what do I know ... :)  )

I don't love the name, it's just the best I've thought of so far.

> "host-trust-limitation"  sounds like "I am the hypervisor, I configure
> limited trust into myself".

Which is kind of... accurate...

> Also, "untrusted-host" would be a little bit
> nicer (I think trust is a black/white thing).

> However, once we have multiple options to protect a guest (memory
> encryption, unmapping guest pages ,...) the name will no longer really
> suffice to configure QEMU, no?

That's why it takes a parameter.  It points to an object which can
itself have more properties to configure the details.  SEV already
needs that set up, though for both PEF and s390 PV we could pre-create
a standard htl object.

> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.
>=20
> The only approach on s390x to not glue command line properties to the
> cpu model would be to remove the CPU model feature and replace it by the
> command line parameter. But that would, of course, be an incompatible bre=
ak.

I don't really understand why you're so against setting the cpu
default parameters from the machine.  The machine already sets basic
configuration for all sorts of devices in the VM, that's kind of what
it's for.

> How do upper layers actually figure out if memory encryption etc is
> available? on s390x, it's simply via the expanded host CPU model.

Haven't really tackled that yet.  But one way that works for multiple
systems has got to be better than a separate one for each, right?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--1ou9v+QBCNysIXaH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7sieIACgkQbDjKyiDZ
s5J4mg//RS/XDakf/bfPZ+YL8in0nn6NYU2bvKSK0Ml3JM/IZY9+JB3Al005LIzW
C9+qd3GWezWKSnlUWXQv8qaI09kHvND7kPD/9/4/S+UIbKlBqn9SPY8Z1J9Cl/ny
awwOexHkg2zC5wlWPj4oQlMrR40bX6uI9AkfY9pTiVy4p97NHwNnf/uHJYEB47wX
zxPBLV13iqSdX8lIS8rs34df9dTw9H30ZlX+00Uk3SO75YJzpwUhzTVJCTjJyk2j
EmGz9SGyjzyd9eNM8CTXtnlpq5dJecAhywwcbQtedXTGqBW9nl/kXUhC7gaFkroD
KveW3sxDr8ZzKgKPCnEfBAntAH7Iz/4dBjXeQnvrCX5Km2OEkn7SNTPBBje0qMFR
JVvF924MkVM4d931lEcDdpeyBWaRBLTXJP+w1NW8wpv1M6r+Ampiaaj53liUcKQ/
b0Ro6/qDtkek8ivux4kh0DGPs4B6vQLCpZJI6NrEWBkACMZ036c0RofmpzeF57Yl
b0fegay1DBuN1XCY7OvlKYsxJjlNLo2K9tEFgZyS5kKavZwmb3FYSDwkk5Ry+QV/
Zagrj0qRvjoCPorzw2R3yUHj9jKzsUlTaWrZjXXuNVwigCHEGsUJMjE0gQOa1hUC
mQP0b4CS/JeA6wT2a/pI9wYKiTwVAhZbBVSzBHvv8MVCJKCfc5E=
=Lcwj
-----END PGP SIGNATURE-----

--1ou9v+QBCNysIXaH--
