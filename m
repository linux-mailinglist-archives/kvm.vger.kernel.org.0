Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6C01EDCFB
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgFDGMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:12:30 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59099 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgFDGMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:12:30 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49cwRc4Xcsz9sSW; Thu,  4 Jun 2020 16:12:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1591251148;
        bh=skHKFfM08PW+iDP+ZREZ2CANvUrUMqna20Joj0faJlo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DKlolv+CSjDAvG4ipd1Q+qnZhrG62qXHfLEMc7rCnU2AXJd54WwN2dsLmbD/4t3dC
         i5AfvGcN4SBg8Hwh0gCFiPreiyRilXsHHjh0gq9DYpNPQHwaKOWWx8LY+prDmhnNg+
         Xhd420SuG+4SbxQoyF+nQBUgxgcGnVNYSvsu3q6A=
Date:   Thu, 4 Jun 2020 13:11:29 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, pair@us.ibm.com, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200604031129.GB228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200529221926.GA3168@linux.intel.com>
 <20200601091618.GC2743@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <20200601091618.GC2743@work-vm>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 01, 2020 at 10:16:18AM +0100, Dr. David Alan Gilbert wrote:
> * Sean Christopherson (sean.j.christopherson@intel.com) wrote:
> > On Thu, May 21, 2020 at 01:42:46PM +1000, David Gibson wrote:
> > > A number of hardware platforms are implementing mechanisms whereby the
> > > hypervisor does not have unfettered access to guest memory, in order
> > > to mitigate the security impact of a compromised hypervisor.
> > >=20
> > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > to accomplish this in a different way, using a new memory protection
> > > level plus a small trusted ultravisor.  s390 also has a protected
> > > execution environment.
> > >=20
> > > The current code (committed or draft) for these features has each
> > > platform's version configured entirely differently.  That doesn't seem
> > > ideal for users, or particularly for management layers.
> > >=20
> > > AMD SEV introduces a notionally generic machine option
> > > "machine-encryption", but it doesn't actually cover any cases other
> > > than SEV.
> > >=20
> > > This series is a proposal to at least partially unify configuration
> > > for these mechanisms, by renaming and generalizing AMD's
> > > "memory-encryption" property.  It is replaced by a
> > > "guest-memory-protection" property pointing to a platform specific
> > > object which configures and manages the specific details.
> > >=20
> > > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > > can be extended to cover the Intel and s390 mechanisms as well,
> > > though.
> > >=20
> > > Note: I'm using the term "guest memory protection" throughout to refer
> > > to mechanisms like this.  I don't particular like the term, it's both
> > > long and not really precise.  If someone can think of a succinct way
> > > of saying "a means of protecting guest memory from a possibly
> > > compromised hypervisor", I'd be grateful for the suggestion.
> >=20
> > Many of the features are also going far beyond just protecting memory, =
so
> > even the "memory" part feels wrong.  Maybe something like protected-gue=
st
> > or secure-guest?
> >=20
> > A little imprecision isn't necessarily a bad thing, e.g. memory-encrypt=
ion
> > is quite precise, but also wrong once it encompasses anything beyond pl=
ain
> > old encryption.
>=20
> The common thread I think is 'untrusted host' - but I don't know of a
> better way to describe that.

Hrm..  UntrustedHost? CompromisedHostMitigation? HostTrustMitigation
(that way it has the same abbreviation as hardware transactional
memory for extra confusion)?  HypervisorPowerLimitation?

HostTrustLimitation? "HTL". That's not too bad, actually, I might go
with that unless someone suggests something better.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl7YZmAACgkQbDjKyiDZ
s5Ltmw//bTeG5JOnhPRydtTzHoKYC49I47fHARgcf3iHR2ge3/7SbwFEYs/RMReQ
H69wZ6qZ46Ec0wD6KzKh5u7qt6gARW6lpEP3vQa1rNRx0tHtr9/E4isrzeSRNz0X
rM+mb8LyjEdTKJez/O42UfjFSoPz/aTehWWugH7n14RoxboCZi9IV0j/LN9Vb55N
M6sfSKYwR5BxpNIoX0WllQJEkU+xEyGCJMsBSkcGCTzV/fGl+WKnmUCK8TiPIXbv
EZw1Kg8iWd/qoEJ+w95FFpV6EhCDEUeW+4kOWj+R6AnplOXu9o5H1GW1iHvlDTZk
5uMNevgU+UwaqMhrNdNfVz0lurkU4+yHarbsqA+eIISFsOFQ5hnXP3k+nEWE4MR7
1zbnBJDA/Jjw7/J3DyqHiIJl1QPW11IrMn/5lQcGWuPn+NEK1ks4u+GVk8kfu2Z0
XwYZbky+VvbYWs7x8hIEK5sQ9iu0pvclj+Mil1sCChipmz//faYwZIlkp7kRdn+G
E4fWJt0wt5Drn5GTmiPO5hOvXyRyrjTc7SsI2Ry0WIHAaPmguueIM2CcbtPxMpGR
UcAxJIxaMIKF4GZIT2dB4pgt0YrOi2N+1uBlQrADjrurYfyBLk7FfhNMk6IpgiJh
SNL+GEcaQkf+OCGQgV2ZrKqj7NvtE2o4BOX3oLwLiAUw5JpmUog=
=iY53
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
