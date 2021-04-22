Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87430367748
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhDVCRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbhDVCRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:17:11 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8466C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:16:37 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FQgyn4qmNz9sWH; Thu, 22 Apr 2021 12:16:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1619057793;
        bh=pjSD6fcv7y2AmKG8yk1op9b+9G3r+6kNIDFjYZVL5Rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nS3tbAP5+NiJ89vIjYU2uKmJ40TGt6jSSKqa5m8Vc7KDsQWi6SwhdeviK6muaqJcg
         nntvUxj7qQxQpga27gptdgmPdwJi18zwgKNmqzAEJZhnFKrYEF1UQsR6lRlRqNJ572
         aBPNN+BYxaUD28Hrffi2grDso0TSKuNEYqosKnIM=
Date:   Thu, 22 Apr 2021 11:56:54 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        paulus@samba.org, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org, cohuck@redhat.com,
        groug@kaod.org
Subject: Re: [PATCH v5 3/3] ppc: Enable 2nd DAWR support on p10
Message-ID: <YIDX5nRJ2NWdGvlj@yekko.fritz.box>
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
 <20210412114433.129702-4-ravi.bangoria@linux.ibm.com>
 <YH0M1YdINJqbdqP+@yekko.fritz.box>
 <ca21d852-4b54-01d3-baab-cc8d0d50e505@linux.ibm.com>
 <8020c404-d8ce-2758-d936-fc5e851017f0@kaod.org>
 <0b6e1a4a-eed2-1a45-50bf-2ccab398f4ed@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3/7Eip2jHCSaf7Bo"
Content-Disposition: inline
In-Reply-To: <0b6e1a4a-eed2-1a45-50bf-2ccab398f4ed@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3/7Eip2jHCSaf7Bo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 21, 2021 at 12:24:22PM +0530, Ravi Bangoria wrote:
> Hi Cedric,
>=20
> On 4/21/21 12:01 PM, C=E9dric Le Goater wrote:
> > On 4/21/21 8:20 AM, Ravi Bangoria wrote:
> > > Hi David,
> > >=20
> > > On 4/19/21 10:23 AM, David Gibson wrote:
> > > > On Mon, Apr 12, 2021 at 05:14:33PM +0530, Ravi Bangoria wrote:
> > > > > As per the PAPR, bit 0 of byte 64 in pa-features property indicat=
es
> > > > > availability of 2nd DAWR registers. i.e. If this bit is set, 2nd
> > > > > DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability =
to
> > > > > find whether kvm supports 2nd DAWR or not. If it's supported, all=
ow
> > > > > user to set the pa-feature bit in guest DT using cap-dawr1 machine
> > > > > capability. Though, watchpoint on powerpc TCG guest is not suppor=
ted
> > > > > and thus 2nd DAWR is not enabled for TCG mode.
> > > > >=20
> > > > > Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> > > > > Reviewed-by: Greg Kurz <groug@kaod.org>
> > > >=20
> > > > So, I'm actually not sure if using an spapr capability is what we w=
ant
> > > > to do here.=A0 The problem is that presumably the idea is to at some
> > > > point make the DAWR1 capability default to on (on POWER10, at least=
).
> > > > But at that point you'll no longer to be able to start TCG guests
> > > > without explicitly disabling it.=A0 That's technically correct, sin=
ce we
> > > > don't implement DAWR1 in TCG, but then we also don't implement DAWR0
> > > > and we let that slide... which I think is probably going to cause l=
ess
> > > > irritation on balance.
> > >=20
> > > Ok. Probably something like this is what you want?
> > >=20
> > > Power10 behavior:
> > >  =A0 - KVM does not support DAWR1: Boot the guest without DAWR1
> > >  =A0=A0=A0 support (No warnings). Error out only if user tries with
> > >  =A0=A0=A0 cap-dawr1=3Don.
> > >  =A0 - KVM supports DAWR1: Boot the guest with DAWR1 support, unless
> > >  =A0=A0=A0 user specifies cap-dawr1=3Doff.
> > >  =A0 - TCG guest: Ignore cap-dawr1 i.e. boot as if there is only
> > >  =A0=A0=A0 DAWR0 (Should be fixed in future while adding PowerPC watc=
h-
> > >  =A0=A0=A0 point support in TCG mode)
> > >=20
> > > Power10 predecessor behavior:
> > >  =A0 - KVM guest: Boot the guest without DAWR1 support. Error out
> > >  =A0=A0=A0 if user tries with cap-dawr1=3Don.
> > >  =A0 - TCG guest: Ignore cap-dawr1 i.e. boot as if there is only
> > >  =A0=A0=A0 DAWR0 (Should be fixed in future while adding PowerPC watc=
h-
> > >  =A0=A0=A0 point support in TCG mode)
> > >=20
> > > > I'm wondering if we're actually just better off setting the pa feat=
ure
> > > > just based on the guest CPU model.=A0 TCG will be broken if you try=
 to
> > > > use it, but then, it already is.=A0 AFAIK there's no inherent reaso=
n we
> > > > couldn't implement DAWR support in TCG, it's just never been worth =
the
> > > > trouble.
> > >=20
> > > Correct. Probably there is no practical usecase for DAWR in TCG mode.
> >=20
> > What's the expected behavior ? Is it to generate a DSI if we have a DAWR
> > match ?
>=20
> Yes. DSI is the main thing. But many auxiliary stuff, off the top of my
> head:
>  - DAR needs to be set. Now, DAR value is set differently on p8 vs p10
>    (not sure about p9 because there was hw bug and thus we needed to
>    fully disable DAWR on p9).
>  - DAWR matching criteria for quadword instruction are different for
>    p8/p9 vs p10.
>  - P10 supports 512 byte unaligned watchpoints but p8/p9 does not.
>=20
> Kernel is aware of these differences and thus handles these scenarios,
> sometimes as special case. i.e. Qemu will need to mimic the exact hw
> behavior for the specific revision of processor.

I don't actually know if qemu has TCG watchpoint support on any
hardware.  Presumably it would mean instrumenting all the tcg loads
and stores.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--3/7Eip2jHCSaf7Bo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCA1+IACgkQbDjKyiDZ
s5LP5Q//Ujw4smdW1zVoaAZ3zFdodt7i1Gw10c+1Pu1c+yfNpa2u1XbsZH1n+vQB
zFg6GGwDmerSlIrhqgm5VJBvx7hMJYxiSzYhMarwdborj/aRSGF69orMsNJBWot9
Dth9cl+qs7RVO9KuRmUj9FNRZnoeRY54W+Dw5JF8xmVecJ8ceCXjmbbXqQcB0WQ0
aLqXVSmxMjClLkzURLw4JZRVSJIxdGXtESckg3ErkMYQPhOKekgY8y39D1urEtd5
/Jhz1wXz0yHQPmLj284Rwu65EOWMMiwt4MQiRg7wEX/MQHWZSwbTcffWWydNLQlJ
YNDBNJA+fiz9yMK/VoLTqctTa1vAb9R4WGp6YdmO0JyAIIq1GbGR8hOThrB100BR
6oi2cpnGg9SYa9ewNXvmP61KMIoVZOD+Iv2dVi/Doo+fHukQ5s8kZITTDocQBdCG
i1njE/oGwVWQVGASKVrVhS9hrRMpreK5ry8NlrmHa25YzXrOA6fHSVkyyomor9jr
hDYzr+WB8n1BvVWScaGdv8oLikHYRjPJlhh5Kz6Ah5okkqR6gF4X4/t5eIQw32Dv
NegGS0FhYMNGMmz9zWa+2TovDG4jQ+NsdDKfLz2RLt3xIN/gmyd8zAG/y7hHXZuA
9KrID/PydAO/ms9w6kzuzlf9di3GyyNE4j5q7Nf07ity6S+Tubs=
=Ulnm
-----END PGP SIGNATURE-----

--3/7Eip2jHCSaf7Bo--
