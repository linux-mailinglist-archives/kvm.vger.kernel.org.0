Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C031F4C85
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 06:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgFJEqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 00:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgFJEqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 00:46:12 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D5C05BD1E
        for <kvm@vger.kernel.org>; Tue,  9 Jun 2020 21:46:11 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49hZFC4Sfcz9sSf; Wed, 10 Jun 2020 14:46:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591764367;
        bh=xI1LVAdzVfoGGosUupL+fXC/IP9TGBExUdIO9fFVnoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KtdYgiZb6/73I23C6hrE3AE0lmCS3luNtylhenXUxlgz2QP1oPt00hjQFWgW5TR9G
         mdkpOtXRr2mm09VJ9Cyi6sOLtieKKnhQN+GI+BYiou8Wk81BNYho0xfsa6psU4p0x7
         3iE7KqvfF1IEP3chCj4CAIUx8tvjd9OY0vQ7j7dY=
Date:   Wed, 10 Jun 2020 14:36:21 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, dgilbert@redhat.com,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200610043621.GH494336@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200605125505.3fdd7de8.cohuck@redhat.com>
 <20200606084409.GL228651@umbus.fritz.box>
 <20200609121105.50588db9.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zhtSGe8h3+lMyY1M"
Content-Disposition: inline
In-Reply-To: <20200609121105.50588db9.pasic@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zhtSGe8h3+lMyY1M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 09, 2020 at 12:11:05PM +0200, Halil Pasic wrote:
> On Sat, 6 Jun 2020 18:44:09 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > On Fri, Jun 05, 2020 at 12:55:05PM +0200, Cornelia Huck wrote:
> > > On Thu, 21 May 2020 13:42:46 +1000
> > > David Gibson <david@gibson.dropbear.id.au> wrote:
> > >=20
> > > > A number of hardware platforms are implementing mechanisms whereby =
the
> > > > hypervisor does not have unfettered access to guest memory, in order
> > > > to mitigate the security impact of a compromised hypervisor.
> > > >=20
> > > > AMD's SEV implements this with in-cpu memory encryption, and Intel =
has
> > > > its own memory encryption mechanism.  POWER has an upcoming mechani=
sm
> > > > to accomplish this in a different way, using a new memory protection
> > > > level plus a small trusted ultravisor.  s390 also has a protected
> > > > execution environment.
> > > >=20
> > > > The current code (committed or draft) for these features has each
> > > > platform's version configured entirely differently.  That doesn't s=
eem
> > > > ideal for users, or particularly for management layers.
> > > >=20
> > > > AMD SEV introduces a notionally generic machine option
> > > > "machine-encryption", but it doesn't actually cover any cases other
> > > > than SEV.
> > > >=20
> > > > This series is a proposal to at least partially unify configuration
> > > > for these mechanisms, by renaming and generalizing AMD's
> > > > "memory-encryption" property.  It is replaced by a
> > > > "guest-memory-protection" property pointing to a platform specific
> > > > object which configures and manages the specific details.
> > > >=20
> > > > For now this series covers just AMD SEV and POWER PEF.  I'm hoping =
it
> > > > can be extended to cover the Intel and s390 mechanisms as well,
> > > > though.
> > >=20
> > > For s390, there's the 'unpack' cpu facility bit, which is indicated i=
ff
> > > the kernel indicates availability of the feature (depending on hardwa=
re
> > > support). If that cpu facility is available, a guest can choose to
> > > transition into protected mode. The current state (protected mode or
> > > not) is tracked in the s390 ccw machine.
> > >=20
> > > If I understand the series here correctly (I only did a quick
> > > read-through), the user has to instruct QEMU to make protection
> > > available, via a new machine property that links to an object?
> >=20
> > Correct.  We used to have basically the same model for POWER - the
> > guest just talks to the ultravisor to enter secure mode.  But we
> > realized that model is broken.  You're effectively advertising
> > availability of a guest hardware feature based on host kernel or
> > hardware properties.  That means if you try to migrate from a host
> > with the facility to one without, you won't know there's a problem
> > until too late.
> >=20
>=20
> Sorry, I don't quite understand the migration problem described here. If
> you have this modeled via a CPU model facility, then you can't migrate
> from a host with the facility to one without, except if the user
> specified CPU model does not include the facility in question. Or am I
> missing something?

Ah, sorry, my mistake.  If it's all based on a cpu model facility that
must be explicitly selected by the user (not based on host
capbilities) then that's ok as well.

The problem comes if you base guest availability on host availability,
which early proposals for the POWER version did involve.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--zhtSGe8h3+lMyY1M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7gY0UACgkQbDjKyiDZ
s5IejRAAtjMH9eFvNDqgz5oCfKYEzNSAqc3CD8MHrKOQ23blnzfRbVdMcVr9apii
CuKm4FBmpluNAdj+5QOjqyHIpVqzY/Xn5xhJJp8TE2GGEyUVVWFRcCt6ga/XThTg
e/IOlC/K4dzHJ10pIhfKf4Dmmyyo2FQxxZbjmc6vtQkElELv5+q4WABn6+4puF3s
TMlpK6qtlO/onDNXpypk0c+b3yltKK7UUaJGw0yCVGbOT05yDbYOHHmmTDnlsd3j
3di7VGUNC5pta5EiwrxZWbpw/lVAtPe9VSCScPdZOhjYb431WUuPHc3JRHEy8ABF
dfbs1VBM2abQSXDxoh+x3RDZtv3uAtEJUhVW7TQe4ixQ3RANbE2aBHV+tV2LVUt5
c/mmSVr4ij/CqNdirH8QMC9jBW6+gmzrsh9Assu0MU7scPn3sdn4GVz/PEtw+R9D
Dki3l3BsHJHVVeVb/j1nERmTI9sqmSwI0TIkgD8XhMYEyLAEVJLDCoODZrKfVmny
IuyUH4PsSQ1bWR/I+k85x1C5k8vy/C2YNxsQXSmDNRwBB4j9Gn1feRI0P6gSlWgH
eOPpUTi8LVS+29FSbDwq10I5vwQMIjpjgoBvz6bLn15ON5ShX0/r9JBMdsudMEFF
vtIHo/c97gLkQN72/Q9Uv7uUj5WuZQiRCh4T4Erq5IwgDope8B0=
=3eJu
-----END PGP SIGNATURE-----

--zhtSGe8h3+lMyY1M--
