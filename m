Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0689D2D2216
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 05:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgLHE16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 23:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLHE16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 23:27:58 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BB5C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 20:27:17 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CqnFt0gnCz9sW0; Tue,  8 Dec 2020 15:27:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607401634;
        bh=mLyOVhZ4oR5+tNvzHEh2SyeDztIphEHMovVY51ggypE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=otGoUEr3F0jJHjzIxwnmjcR/tXCYQC2ipuLDclv8VzbiVgvpfU5F5eRLIYtg3mdaR
         RM3hjKME3yJn/yUcBMAL1ZeV26OnYJYCEf2TFfQBdvYBp1uEsslbMMYjsOSb7meJsV
         eceQkRMNUelGTQi0VrNCFDbimXn86KdQKWr1S+MM=
Date:   Tue, 8 Dec 2020 13:57:28 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201208025728.GD2555@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <f2419585-4e39-1f3d-9e38-9095e26a6410@de.ibm.com>
 <20201204140205.66e205da.cohuck@redhat.com>
 <20201204130727.GD2883@work-vm>
 <20201204141229.688b11e4.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <20201204141229.688b11e4.cohuck@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 04, 2020 at 02:12:29PM +0100, Cornelia Huck wrote:
> On Fri, 4 Dec 2020 13:07:27 +0000
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
>=20
> > * Cornelia Huck (cohuck@redhat.com) wrote:
> > > On Fri, 4 Dec 2020 09:06:50 +0100
> > > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > >  =20
> > > > On 04.12.20 06:44, David Gibson wrote: =20
> > > > > A number of hardware platforms are implementing mechanisms whereb=
y the
> > > > > hypervisor does not have unfettered access to guest memory, in or=
der
> > > > > to mitigate the security impact of a compromised hypervisor.
> > > > >=20
> > > > > AMD's SEV implements this with in-cpu memory encryption, and Inte=
l has
> > > > > its own memory encryption mechanism.  POWER has an upcoming mecha=
nism
> > > > > to accomplish this in a different way, using a new memory protect=
ion
> > > > > level plus a small trusted ultravisor.  s390 also has a protected
> > > > > execution environment.
> > > > >=20
> > > > > The current code (committed or draft) for these features has each
> > > > > platform's version configured entirely differently.  That doesn't=
 seem
> > > > > ideal for users, or particularly for management layers.
> > > > >=20
> > > > > AMD SEV introduces a notionally generic machine option
> > > > > "machine-encryption", but it doesn't actually cover any cases oth=
er
> > > > > than SEV.
> > > > >=20
> > > > > This series is a proposal to at least partially unify configurati=
on
> > > > > for these mechanisms, by renaming and generalizing AMD's
> > > > > "memory-encryption" property.  It is replaced by a
> > > > > "securable-guest-memory" property pointing to a platform specific=
   =20
> > > >=20
> > > > Can we do "securable-guest" ?
> > > > s390x also protects registers and integrity. memory is only one pie=
ce
> > > > of the puzzle and what we protect might differ from platform to=20
> > > > platform.
> > > >  =20
> > >=20
> > > I agree. Even technologies that currently only do memory encryption m=
ay
> > > be enhanced with more protections later. =20
> >=20
> > There's already SEV-ES patches onlist for this on the SEV side.
> >=20
> > <sigh on haggling over the name>
> >=20
> > Perhaps 'confidential guest' is actually what we need, since the
> > marketing folks seem to have started labelling this whole idea
> > 'confidential computing'.

That's not a bad idea, much as I usually hate marketing terms.  But it
does seem to be becoming a general term for this style of thing, and
it doesn't overlap too badly with other terms ("secure" and
"protected" are also used for hypervisor-from-guest and
guest-from-guest protection).

> It's more like a 'possibly confidential guest', though.

Hmm.  What about "Confidential Guest Facility" or "Confidential Guest
Mechanism"?  The implication being that the facility is there, whether
or not the guest actually uses it.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/O65gACgkQbDjKyiDZ
s5K/UA/+IsN6RwpL+fkyBxLWOZDGgN+J2SzXhKj69pySp0MURKke9NxwOk+eGLA0
kzp7GMc4DMKivbwu7WIWbE0J/sAGpBURt8EJUegobAdWAGqaaAsjBADsgpSXRqK2
qP2GXt0SzNowq3oE3oHDsWKC2URhiyk28pWYqWQ1UwTqJFQOi2+7+jK1KqFMGadP
u3B1IM01wpa6WFxhZe8U1VQP2Xe5xvMwK95f0HFsaXlWSP4iOHArJbTXgNPkCJPR
WAbS1cIVsns7g5qs+4kIxSkVeHzstx5wnd5IB1AfCkrSrJIbsxw1KErZkTPnWvqc
bTm09YN0H2pNwUTKxjnpbdxMdrI5oh3BDW5ZozIc7Q7c/wgxg5yQygDhTln2egiU
I63P/yXLC1vWQGOwQ9ajf73xxzV8CkJmiL/f7tqAXYq6YyilDYh0yZkd1z1s4Jop
DRtoQnFImaH7AI0T15ss188NCAkicODrBTO7Xziuv9BQLGEx1kFMatsk3CwE0dfU
Fyr/w2wpEWze42MHfO35yrR8YAdC0RhcHs3WOdc/w3XVoGjPS8zOj16NTSQnRgHj
2Ul+EcqqUhIiNGlN4pZTsLV6i/IA1W4lOjsmwkczN7VRxDVf/HYtMjVzgAgJaElY
vLnLkH94h5xcWW9BFdixZUGq0KYFIAsoGzP+46TZr3gup6mUdYE=
=WW47
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
