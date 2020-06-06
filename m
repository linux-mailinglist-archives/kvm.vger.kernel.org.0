Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4929F1F05D6
	for <lists+kvm@lfdr.de>; Sat,  6 Jun 2020 10:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgFFIp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jun 2020 04:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgFFIp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jun 2020 04:45:56 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4879BC08C5C2
        for <kvm@vger.kernel.org>; Sat,  6 Jun 2020 01:45:56 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49fClh5Xbfz9sRh; Sat,  6 Jun 2020 18:45:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591433152;
        bh=MD9Vy9t80FMoa1MWr1bErDl8DYW9eXWurKymfv5V+hg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dj0x4Ld0zGOyYNvHNh34xSS4k7ShfK/bK0chdoJDc0pBfrqf+sCLBNp0gwHAaRaDr
         mWy4S0YAEaNqCSOohcM3XnZB2EwqoRv1iriIZGC+0b4erf2zuXdujnnHximcLEuO49
         HJMDjkcDf+UOA7pp3S2yyl7g8S/weSqIQBjTk6OY=
Date:   Sat, 6 Jun 2020 18:44:09 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200606084409.GL228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200605125505.3fdd7de8.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vTUhhhdwRI43FzeR"
Content-Disposition: inline
In-Reply-To: <20200605125505.3fdd7de8.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--vTUhhhdwRI43FzeR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 05, 2020 at 12:55:05PM +0200, Cornelia Huck wrote:
> On Thu, 21 May 2020 13:42:46 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
>=20
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> >=20
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> >=20
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
> > "guest-memory-protection" property pointing to a platform specific
> > object which configures and manages the specific details.
> >=20
> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.
>=20
> For s390, there's the 'unpack' cpu facility bit, which is indicated iff
> the kernel indicates availability of the feature (depending on hardware
> support). If that cpu facility is available, a guest can choose to
> transition into protected mode. The current state (protected mode or
> not) is tracked in the s390 ccw machine.
>=20
> If I understand the series here correctly (I only did a quick
> read-through), the user has to instruct QEMU to make protection
> available, via a new machine property that links to an object?

Correct.  We used to have basically the same model for POWER - the
guest just talks to the ultravisor to enter secure mode.  But we
realized that model is broken.  You're effectively advertising
availability of a guest hardware feature based on host kernel or
hardware properties.  That means if you try to migrate from a host
with the facility to one without, you won't know there's a problem
until too late.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--vTUhhhdwRI43FzeR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7bV1cACgkQbDjKyiDZ
s5KuTxAAuHsZpdab6NhUviRv5pmLEZ0qSYnV6DIZFKYl6a6Uv5G7n/HFqTlvizXl
IBnDK/W/fGxSjnmYel9i7aGptRKkli5Vuxg+Iafwn8oIu5RiIqUA0CmgWCdwC2ys
6d4S3l4ZocqAAqFbDzjRW5FhyH0E09aCqn4dLUYDHkYZQYM+vq8kusMSGQ5v4rEr
DgMbyDtV0AMlmqsfdVG7GPifQCY5s5Eo6SbdsQ2swY2Krt+p85+yt5KQYrdZGyxy
37L/QlFjbFFiYYXJ19JuMHIdK86kIc9SaJEUcc282jCJuLCQHs0l4nsel4lOjhkB
ud86lwTeR00ruFjnwH9VKHKc13V6EkY3VL8sTpb7Ckvz6AT5fum7QsayXC7P5ZNC
tg/xbryLE36+J+bwT3/djtYcNUrDMhIgeVQNPfvDXfuPU2bajx6qsnsIub/8Adio
4me8QeHyGOL6I0vrffMEfEAZIGGyEQhRFbhlRKorMzoKij8iv/eMcUVyJTzbqNDd
vcF5KeoxglpeodzvmR60GfYgJLjpXh1S6fQL2kHAr+tbZaD9GVewhlKN0NUFQTCF
t7ijyD3WKcBEWCVsqk9QtdvYLwCGxdXjOQmYJo4RceVoy6nQUs4xwBnnWT5ACvrZ
qRCz7P8nWYrYtr1VVYdzv6IVAg9a0uGjHPkVO2DrNyGRnmqZh4A=
=yDWK
-----END PGP SIGNATURE-----

--vTUhhhdwRI43FzeR--
