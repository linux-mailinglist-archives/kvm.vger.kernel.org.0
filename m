Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F60E2EECDA
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 06:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbhAHFUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 00:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbhAHFUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 00:20:12 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFFFC0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 21:19:31 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DBrxq2LW5z9sWc; Fri,  8 Jan 2021 16:19:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610083167;
        bh=10pRltwJwzOkdN7mhNTBSGaf0kxqc7JDgVdLQdMlTSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lv6It7gqYmQbvx3xp+rcMnGXo9jc2ttqKwRQmz2zvRQ4aTYyX3X3xTGj7u4Q5nbJM
         c9ywxrQowVJ8FnVju9oInROQxxYUm+GcZNLt74hF3tm9plk4JCgTr7NF9dlLAuZskY
         fAmYJ3hKysSGCjiXGzUH5HZJcSfmOFLFVodOXGPw=
Date:   Fri, 8 Jan 2021 11:34:38 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Ram Pai <linuxram@us.ibm.com>
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
Subject: Re: [for-6.0 v5 10/13] spapr: Add PEF based securable guest memory
Message-ID: <20210108003438.GG3209@yekko.fritz.box>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-11-david@gibson.dropbear.id.au>
 <20210105233438.GB22585@ram-ibm-com.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4ndw/alBWmZEhfcZ"
Content-Disposition: inline
In-Reply-To: <20210105233438.GB22585@ram-ibm-com.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--4ndw/alBWmZEhfcZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 05, 2021 at 03:34:38PM -0800, Ram Pai wrote:
> On Fri, Dec 04, 2020 at 04:44:12PM +1100, David Gibson wrote:
> > Some upcoming POWER machines have a system called PEF (Protected
> > Execution Facility) which uses a small ultravisor to allow guests to
> > run in a way that they can't be eavesdropped by the hypervisor.  The
> > effect is roughly similar to AMD SEV, although the mechanisms are
> > quite different.
> >=20
> > Most of the work of this is done between the guest, KVM and the
> > ultravisor, with little need for involvement by qemu.  However qemu
> > does need to tell KVM to allow secure VMs.
> >=20
> > Because the availability of secure mode is a guest visible difference
> > which depends on having the right hardware and firmware, we don't
> > enable this by default.  In order to run a secure guest you need to
> > create a "pef-guest" object and set the securable-guest-memory machine
> > property to point to it.
> >=20
> > Note that this just *allows* secure guests, the architecture of PEF is
> > such that the guest still needs to talk to the ultravisor to enter
> > secure mode.  Qemu has no directl way of knowing if the guest is in
> > secure mode, and certainly can't know until well after machine
> > creation time.
> >=20
> > To start a PEF-capable guest, use the command line options:
> >     -object pef-guest,id=3Dpef0 -machine securable-guest-memory=3Dpef0
> >=20
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > Acked-by: Ram Pai <linuxram@us.ibm.com>
> > ---
> >  hw/ppc/meson.build   |   1 +
> >  hw/ppc/pef.c         | 115 +++++++++++++++++++++++++++++++++++++++++++
> >  hw/ppc/spapr.c       |  10 ++++
> >  include/hw/ppc/pef.h |  26 ++++++++++
> >  target/ppc/kvm.c     |  18 -------
> >  target/ppc/kvm_ppc.h |   6 ---
> >  6 files changed, 152 insertions(+), 24 deletions(-)
> >  create mode 100644 hw/ppc/pef.c
> >  create mode 100644 include/hw/ppc/pef.h
> >=20
> > diff --git a/hw/ppc/meson.build b/hw/ppc/meson.build
> > index ffa2ec37fa..218631c883 100644
> > --- a/hw/ppc/meson.build
> > +++ b/hw/ppc/meson.build
> > @@ -27,6 +27,7 @@ ppc_ss.add(when: 'CONFIG_PSERIES', if_true: files(
> >    'spapr_nvdimm.c',
> >    'spapr_rtas_ddw.c',
> >    'spapr_numa.c',
> > +  'pef.c',
> >  ))
> >  ppc_ss.add(when: 'CONFIG_SPAPR_RNG', if_true: files('spapr_rng.c'))
> >  ppc_ss.add(when: ['CONFIG_PSERIES', 'CONFIG_LINUX'], if_true: files(
> > diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> > new file mode 100644
> > index 0000000000..3ae3059cfe
> > --- /dev/null
> > +++ b/hw/ppc/pef.c
> > @@ -0,0 +1,115 @@
> > +/*
> > + * PEF (Protected Execution Facility) for POWER support
> > + *
> > + * Copyright David Gibson, Redhat Inc. 2020
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or =
later.
> > + * See the COPYING file in the top-level directory.
> > + *
> > + */
> > +
> > +#include "qemu/osdep.h"
> > +
> > +#include "qapi/error.h"
> > +#include "qom/object_interfaces.h"
> > +#include "sysemu/kvm.h"
> > +#include "migration/blocker.h"
> > +#include "exec/securable-guest-memory.h"
> > +#include "hw/ppc/pef.h"
> > +
> > +#define TYPE_PEF_GUEST "pef-guest"
> > +#define PEF_GUEST(obj)                                  \
> > +    OBJECT_CHECK(PefGuestState, (obj), TYPE_PEF_GUEST)
> > +
> > +typedef struct PefGuestState PefGuestState;
> > +
> > +/**
> > + * PefGuestState:
> > + *
> > + * The PefGuestState object is used for creating and managing a PEF
> > + * guest.
> > + *
> > + * # $QEMU \
> > + *         -object pef-guest,id=3Dpef0 \
> > + *         -machine ...,securable-guest-memory=3Dpef0
> > + */
> > +struct PefGuestState {
> > +    Object parent_obj;
> > +};
> > +
> > +#ifdef CONFIG_KVM
> > +static int kvmppc_svm_init(Error **errp)
> > +{
> > +    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)) {
>                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^
> KVM defines this macro as KVM_CAP_PPC_SECURE_GUEST. Unless we patch KVM,
>     we are stuck with KVM_CAP_PPC_SECURE_GUEST.

Oops, made an over-zealous search and replace.  Fixed now.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--4ndw/alBWmZEhfcZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl/3qJsACgkQbDjKyiDZ
s5IANQ/+J2DKwAaHGUe/L8Mc/Q4ZWxGd3BNXR1m7x/uq8d5WBiZO4oluS7iFz5Ti
/HZNZogvQcIRu6bbM4GAYmXGv9V4eqIJ5fKiti/EXb0cus0+7VwbWecgfJQQspma
W1EwAXRw0GGspVH4JYfdJDXPp4c30SR7HnJRP1MWq9KBq99tVWGiqOpsOiTsz6/8
iF6mOGp53mq3QqEP9n4yz2WGVwKpRqtHuyTOLbOqTjg/uLIlHJugknB4TU5gFNsB
8DoukIeE2Jzyk1B0sSv0qloYCP3FesZxkM0zcbr1iSSWrdj5cRVzmrMV3GKxwbbZ
Dh4JCstjg7/NVnpNCJwCdV5awi6U7Y3JuWrY6QXaUOXsJHJQVIQcib5MPYDiJU/j
zwalQVEx5MYAKQEu0kDg3vnDM3YNSdk/yuJYs0CKhFTsPkc1d4Qn+P/v6kY1JkW/
vn1ZDQmWh9gRbnXJzOkbasAVSayvLSFTjZr8k3KhvuLguohu80XxadqHSk3Uf+i4
L4gx8b3SFeDbYg88fbhsZA8PPqHPqJ4He7Y+544T5LLiQH+6ht/RYsZQhoYHP/ze
RO/S0hOFOnXQrDlf9I2xISwtcljtSVRZA04YVb+LcWOcP6i5YzXN/0nkPJIOzWn5
FAsbAhX+nGYty6xLBv7+FoZuTRm9VYv0IoBtsbHqsokDTSTw+FA=
=bbwY
-----END PGP SIGNATURE-----

--4ndw/alBWmZEhfcZ--
