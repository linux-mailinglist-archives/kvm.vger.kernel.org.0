Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E592B1EDD65
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgFDGoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgFDGoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:44:25 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B6CC05BD1E
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 23:44:25 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cx8R3zJ9z9sV7; Thu,  4 Jun 2020 16:44:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591253063;
        bh=Mc7WOmLvkTipmSQpkZ8c85cerVEcMMCMxKm/JInS22I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pi+L8mEw94m1b47hZrrzhV01IO+Y9HKptc7fdjSGP32vaR08vYjAM784unywZb5Yh
         897QuM226e7RaBg60WRl6vVguBmR246YCnS1sp8wRyJaEWQvhrHna3FHS5Lo0eg423
         gayPUgNuJKVb8jAp6RBUplrx2tGVbHxJN6xeVu7g=
Date:   Thu, 4 Jun 2020 16:44:14 +1000
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
Message-ID: <20200604064414.GI228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <87tuzr5ts5.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4BlIp4fARb6QCoOq"
Content-Disposition: inline
In-Reply-To: <87tuzr5ts5.fsf@morokweng.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--4BlIp4fARb6QCoOq
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
>=20
> Regardless, I was able to successfuly launch POWER PEF guests using
> these patches:
>=20
> Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
>=20
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

That's not a bad one, but for now I'm going with "host trust
limitation", since this might end up covering things other than just
memory protection.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--4BlIp4fARb6QCoOq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7YmDwACgkQbDjKyiDZ
s5I9XA/8Ch2ePqa6dC1C0UY+N36zI1Evzcryyl53MbEkYBAzCnNQWtbCUYy88uWI
HWyaw6W/HcTcuHSh5bBPC+H7sKkHpUFguUCdp5uIzGdWr4Bm3uTp+lWvgxJQmnmh
SopkxbIyASuNWLonBK6CaS/2p+60vwcIkWcrHccF1r6N11aPpUCuKQbkwOImnD1W
JTgUWN0LPSI6qdBLA0wAL/3vtUVGSqDT8O2VxldJBQbeDOu0w8Vog4euO3RhEZEV
85Of/utWgwKJScfNaXvOmiZ9cBMFs3Nu6pwQdVfOsFnOkGznaTDZIGd37/4CPFf8
lKYdpaX0qaP4w2qThZLqi8asayZDmYfkarxaDlYBlGBsd9m0iwMXalvBzteoiNrz
9FbObSoCIWbnhAoKsUuEbD/D+sGBMl1yIb5jwgiSTTYMaTM/9/Lwh2WKsG3LpS6I
plxNdA5vzSOboff9IftBlcDfxjBZB+4/x6ULDfWBHyViCY9BLlvoBD8vKSDGok+d
gVjXHR0Du3FcwZA3VVZuggO28zObVGx5d6i47zqwL0eo51XXrL3bCg/TytTrg4v0
Uc0j6PeUlyeo6epdzjrXlwluaHJjm/39sKNb/YJlFEg8XywHTRd1/Va5c67SikLS
USYa4hQqkTinT3yUsojh3p/5Nu+JqocYmpeqKyH6KJHVA1208Rg=
=HHjA
-----END PGP SIGNATURE-----

--4BlIp4fARb6QCoOq--
