Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795572F26CE
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 04:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbhALDu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 22:50:27 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:34369 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbhALDu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 22:50:27 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFGmR6wtWz9sWL; Tue, 12 Jan 2021 14:49:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610423383;
        bh=GOPARHl2Um0wlY8mSkWS1A+Okstbf4+CZEKk7OTEAuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GizeGJ8fT5fZp0PaNju9Vhw2AQ64lxlUzkkXtPdhEKC+G84KceTrjQE2zSBLbMVFX
         abcyYNdjZWcEj0vYuJxZMcCq6ZKD0Wy3KBqKqi75iZaqVEKYnHLMf4UWixjC1X0FTd
         GNDHtfV0Y1VUOgrA4PN2ljilC0YIulkGThPDnHrU=
Date:   Tue, 12 Jan 2021 14:03:22 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        thuth@redhat.com, cohuck@redhat.com, berrange@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        rth@twiddle.net
Subject: Re: [for-6.0 v5 06/13] securable guest memory: Decouple
 kvm_memcrypt_*() helpers from KVM
Message-ID: <20210112030322.GK3051@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-7-david@gibson.dropbear.id.au>
 <e8c1f2a7-e5b9-8181-2c7b-0287699ac9c9@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zYjDATHXTWnytHRU"
Content-Disposition: inline
In-Reply-To: <e8c1f2a7-e5b9-8181-2c7b-0287699ac9c9@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zYjDATHXTWnytHRU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 11, 2021 at 07:13:27PM +0100, Philippe Mathieu-Daud=E9 wrote:
> On 12/4/20 6:44 AM, David Gibson wrote:
> > The kvm_memcrypt_enabled() and kvm_memcrypt_encrypt_data() helper funct=
ions
> > don't conceptually have any connection to KVM (although it's not possib=
le
> > in practice to use them without it).
> >=20
> > They also rely on looking at the global KVMState.  But the same informa=
tion
> > is available from the machine, and the only existing callers have natur=
al
> > access to the machine state.
> >=20
> > Therefore, move and rename them to helpers in securable-guest-memory.h,
> > taking an explicit machine parameter.
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> > ---
> >  accel/kvm/kvm-all.c                   | 27 --------------------
> >  accel/stubs/kvm-stub.c                | 10 --------
> >  hw/i386/pc_sysfw.c                    |  6 +++--
> >  include/exec/securable-guest-memory.h | 36 +++++++++++++++++++++++++++
> >  include/sysemu/kvm.h                  | 17 -------------
> >  5 files changed, 40 insertions(+), 56 deletions(-)
> ...
>=20
> > +static inline int securable_guest_memory_encrypt(MachineState *machine,
> > +                                              uint8_t *ptr, uint64_t l=
en)
> > +{
> > +    SecurableGuestMemory *sgm =3D machine->sgm;
> > +
> > +    if (sgm) {
> > +        SecurableGuestMemoryClass *sgmc =3D SECURABLE_GUEST_MEMORY_GET=
_CLASS(sgm);
> > +
> > +        if (sgmc->encrypt_data) {
>=20
> Can this ever happen? Maybe use assert(sgmc->encrypt_data) instead?

It's made moot by changes in the next spin.

>=20
> Otherwise:
> Reviewed-by: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
>=20
> > +            return sgmc->encrypt_data(sgm, ptr, len);
> > +        }
> > +    }
> > +
> > +    return 1;
> > +}
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--zYjDATHXTWnytHRU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/9EXoACgkQbDjKyiDZ
s5KvzQ/9EugoRV/WIF4Cga4OBwqfG0O80793x36mlNZm4fotE3mrayRqFRAhQ5jF
E4xbG69Bp5GPK+9YzDAOWrGlNBBw9z0LSGQlBytS9hEODtAOFJfRsUT4Tn5eohJr
liADZgHG9cQtOCZTpX8zp5LDT2XSsiLhorfuHXG7QzOJmEzTJRXLccpmdbOyQnYO
wsHHXy/ZEocPVSsHCJU015hoB67JJYnIRj/tEv9WbasWFf3QlQF/IvB3oetmemZ1
uTPwUAfD58PAf6G7/JQ3Qkj1HqpRBou/n7rp3pBtj4t+zqL4shv2SH1sJBICRvJK
l9CLHpkNfUhPERZMKTw76EyqZWttBKyhlaxSgRBvnZXsRBdW/LX02ytC35r4g1wc
eMVpb/1HAJjOnhS97O+F0BivaOvz5t3/TSUuR0Nkdlhk8bOJyb7pXIW81YGuLcio
OJa7O38z3nyOd8CNtfm0NHCpUYI/OYR5APkVTqmKNBsLttWRvGVv8NNM+7hs0kZh
KUSg/x2JSm2MkgwIU4E1wkF8V38wDXPJsWOelzWLRZSfUELOWRjSveuNeH3PLjHx
fFdwDEY4G19X4/IIegPoC2TWZDngKot5bD3qiOqUxLfnpaCe2jN5k8hmk9ImWYqe
3SUuZXrWZyFsbBugLr/LLPUcDbZWuCxuV+4f1ntHeqlySS5Z/r4=
=2yF9
-----END PGP SIGNATURE-----

--zYjDATHXTWnytHRU--
