Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55542F56DB
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbhANBxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbhAMX7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 18:59:08 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD42C061786
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 15:58:20 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXP6JWrz9sWC; Thu, 14 Jan 2021 10:58:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582293;
        bh=nGtVdJLJCKqUWV/HXYXHb49Ayq+DLtWoYF9H0m46txY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T4OiI22q43gfVnYl0FBDX6F0W3TCx1mMaxdtWf5zzbzBz7oDiTXOEjWFzoZd1AU9p
         VtkZI68q02SuvqgHjmAr4kc4bL1pozDmKlVAFhUqyzOZ0LDj71QqxEiEfuyV/DyEDb
         Y09xQM1AxHi3rm2NQYNBt7exLJOICj8t3PlVhef4=
Date:   Thu, 14 Jan 2021 10:56:20 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, pasic@linux.ibm.com,
        brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        qemu-devel@nongnu.org, andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        richard.henderson@linaro.org, kvm@vger.kernel.org,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        mst@redhat.com, qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210113235620.GL435587@yekko.fritz.box>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-14-david@gibson.dropbear.id.au>
 <fcafba03-3701-93af-8eb7-17bd0d14d167@de.ibm.com>
 <20210112123607.39597e3d.cohuck@redhat.com>
 <20210113005748.GD435587@yekko.fritz.box>
 <3e524040-826f-623d-6cd5-0946af51ca57@de.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9JSHP372f+2dzJ8X"
Content-Disposition: inline
In-Reply-To: <3e524040-826f-623d-6cd5-0946af51ca57@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13, 2021 at 07:57:41AM +0100, Christian Borntraeger wrote:
>=20
>=20
> On 13.01.21 01:57, David Gibson wrote:
> > On Tue, Jan 12, 2021 at 12:36:07PM +0100, Cornelia Huck wrote:
> > 65;6201;1c> On Tue, 12 Jan 2021 09:15:26 +0100
> >> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >>
> >>> On 12.01.21 05:45, David Gibson wrote:
> >>>> At least some s390 cpu models support "Protected Virtualization" (PV=
),
> >>>> a mechanism to protect guests from eavesdropping by a compromised
> >>>> hypervisor.
> >>>>
> >>>> This is similar in function to other mechanisms like AMD's SEV and
> >>>> POWER's PEF, which are controlled by the "confidential-guest-support"
> >>>> machine option.  s390 is a slightly special case, because we already
> >>>> supported PV, simply by using a CPU model with the required feature
> >>>> (S390_FEAT_UNPACK).
> >>>>
> >>>> To integrate this with the option used by other platforms, we
> >>>> implement the following compromise:
> >>>>
> >>>>  - When the confidential-guest-support option is set, s390 will
> >>>>    recognize it, verify that the CPU can support PV (failing if not)
> >>>>    and set virtio default options necessary for encrypted or protect=
ed
> >>>>    guests, as on other platforms.  i.e. if confidential-guest-support
> >>>>    is set, we will either create a guest capable of entering PV mode,
> >>>>    or fail outright.
> >>>>
> >>>>  - If confidential-guest-support is not set, guests might still be
> >>>>    able to enter PV mode, if the CPU has the right model.  This may =
be
> >>>>    a little surprising, but shouldn't actually be harmful.
> >>>>
> >>>> To start a guest supporting Protected Virtualization using the new
> >>>> option use the command line arguments:
> >>>>     -object s390-pv-guest,id=3Dpv0 -machine confidential-guest-suppo=
rt=3Dpv0 =20
> >>>
> >>>
> >>> This results in
> >>>
> >>> [cborntra@t35lp61 qemu]$ qemu-system-s390x -enable-kvm -nographic -m =
2G -kernel ~/full.normal=20
> >>> **
> >>> ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent-=
>instance_size <=3D ti->instance_size)
> >>> Bail out! ERROR:../qom/object.c:317:type_initialize: assertion failed=
: (parent->instance_size <=3D ti->instance_size)
> >>> Aborted (core dumped)
> >>>
> >>
> >>>> +static const TypeInfo s390_pv_guest_info =3D {
> >>>> +    .parent =3D TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> >>>> +    .name =3D TYPE_S390_PV_GUEST,
> >>>> +    .instance_size =3D sizeof(S390PVGuestState),
> >>>> +    .interfaces =3D (InterfaceInfo[]) {
> >>>> +        { TYPE_USER_CREATABLE },
> >>>> +        { }
> >>>> +    }
> >>>> +};
> >>
> >> I think this needs TYPE_OBJECT in .parent and
> >> TYPE_CONFIDENTIAL_GUEST_SUPPORT as an interface to fix the crash.
> >=20
> > No, that was true of an earlier revision, but parent is correct in the
> > current version.
>=20
> right now parent is obviously wrong as it triggers the above warning (and=
 all other
> variants in the previous patches also use TYPE_OBJECT). It is probably th=
e right
> thing when you fix
>=20
> +struct S390PVGuestState {
> +    Object parent_obj;
> +};
> +
>=20
> and change Object to the proper type I guess.=20

Yes, I think so.  In the next spin I've fixed the parent_obj field (as
well as moving to OBJECT_DEFINE_TYPE()) and it's passing the gitlab
CI, at least.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--9JSHP372f+2dzJ8X
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl//iKAACgkQbDjKyiDZ
s5IR0A/7BBeaYAmNps8ImKrO4gmSvb0Jig0f5roEqltdtvjDftPVyERhoLlmNy/5
5T7F5E1y8zCDNAogE4vR20KzAWt02b6No74Hv0syBg6B2MKbiOeUgLj2mewW/EHK
SDM9OOt5DmqZoc66h4wwWXxQtFcCF5nIHa0cBcOebz4xSwlqCYgQsKMAkynHhDH/
aPiUaOnnxsKHRZvBVxZ5nEQIvXtCuWNQZ900EYcxkh9dOyVqoi9Jc5dioJs7ssI4
60OSboTJD9dLqIXCIV8ByNlB2VaByBjupMbKFZ8xxgL/jy6qciq4wVkliA0Sdh4y
uNm4jlCLKcnK/Lu5PpNCdPIZynsF5LemnT87GkycwcYRF9gWsoilcWpjHQJxD4jM
ZcpViwd72wd9nYAHq9CJbQeZUSi6Zmw63XbzoTDibt+pXT/5s8XNU8Kw1Jg/Afzg
IBl8MHanbvqO7LkRLTOUPm3zid3MT4SQmiEi3znnbSgYWD6M1HdNsr+Gp1y8DE7G
erkAlkasZqVoXTNp6YCAb10rLy8IG9+AIlCiuXQ+yAgdxEc9uCsXma4jj2Bc/ZiL
yEw4BBtxmtvhadShuikPPCQwipgZpKHPy97tqIqF3v4+yNLu6UKtCH4uwDF5wBQA
OQCmQ68LLyXmp17KG6DqbJ+Jsiekdk8ChGaZhpyIjsL5EIZHMyU=
=VKL8
-----END PGP SIGNATURE-----

--9JSHP372f+2dzJ8X--
