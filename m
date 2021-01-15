Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9292F6F60
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 01:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbhAOAUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 19:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731202AbhAOAUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 19:20:15 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54C4C0613C1
        for <kvm@vger.kernel.org>; Thu, 14 Jan 2021 16:19:34 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DH1yV6T8Gz9sRR; Fri, 15 Jan 2021 11:19:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610669970;
        bh=6rt0Brp3CktLo2ypYITM1g/ZFLRPD910BAU72R0cilE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FYDuAjxwhiUNKxS9D35s9dvZZmwu0f3se06n5K9yHIarBa8dXbQrzonT4pCCdOJ6s
         dcBA0D0OmDA7npY1IrgnZY89HWSnX8tCaZ0Cpi2XGobOJ5xO8fOYooWZ+RabDG8mq0
         yKQqoicd5A8fzMBzZ7RrVmpOxu1zcgt0osyxfpqI=
Date:   Fri, 15 Jan 2021 11:13:27 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org, cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210115001327.GP435587@yekko.fritz.box>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
 <20210113235811.1909610-14-david@gibson.dropbear.id.au>
 <ba08f5da-e31f-7ae2-898d-a090c5c1b1cf@de.ibm.com>
 <aa72b499-1b84-54a3-fd06-2fec4402b699@de.ibm.com>
 <471babb9-9d5a-a2fa-7d90-f14a7d289b8d@de.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qSHHer9gQ0dtepKr"
Content-Disposition: inline
In-Reply-To: <471babb9-9d5a-a2fa-7d90-f14a7d289b8d@de.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--qSHHer9gQ0dtepKr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 14, 2021 at 10:24:57AM +0100, Christian Borntraeger wrote:
>=20
>=20
> On 14.01.21 10:19, Christian Borntraeger wrote:
> >=20
> >=20
> > On 14.01.21 10:10, Christian Borntraeger wrote:
> >>
> >>
> >> On 14.01.21 00:58, David Gibson wrote:
> >> [...]
> >>> +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
> >>> +{
> >>> +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
> >>> +        return 0;
> >>> +    }
> >>> +
> >>> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> >>> +        error_setg(errp,
> >>> +                   "CPU model does not support Protected Virtualizat=
ion");
> >>> +        return -1;
> >>> +    }
> >>
> >> I am triggering this and I guess this is because the cpu model is not =
yet initialized at
> >> this point in time.
> >>
> > When I remove the check, things seems to work though ( I can access vir=
tio-blk devices without
> > specifying iommu for example)
>=20
> Maybe we can turn things around and check in apply_cpu_model if the objec=
t exists but
> unpack was not specified?

That might work.  If unpack *is* specified, you'd also need to set the
ready flag there, of course.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--qSHHer9gQ0dtepKr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmAA3iUACgkQbDjKyiDZ
s5JVOg//ZK/jqzfMra5QZC8J9RxUz3vcxD/TjIOg6c+ekzbJMveK1GpkYS7O25T1
3R90+6T+/6ZQm419GJrsD/46MsH+DrXTx4y+eWdwWqHzxcrANHIA99dwEepJfj8m
ZQqXtMx4uWi4hVtVyyIkYmosN8sinTHl0XbYr65dg7etNXvASyeDx8xGi+4niVm1
mGJGHouxCsJzN0ov2eLzwr8hx4rlrUXobiIGOfpTtBNNlOvokz73ZF+zAb6VL/si
QBV8fYuiDBcUqRNUTV5xHWjmbfS+qOC/Dw+S/ad07LUtPS/oQVB/dej86HGi6UeW
FaPR/qXL/6vwEhtgychNj3a5TillBjTlbRLVDuYRVzbB5eJD9ORA7pcanS8RjEHa
z9IUEt+SnzUfIZTpI4kjiwdwDYfoySs7tWxdJZUMmCiw1RQCaOQXqdlXqk4Kk7mr
Pq4rIB/Prh4g59IX9ZDymFFYYNQo4urvLb3wJifJquk0NPNmYN1p3v2QdKGtVn41
MRih1c/f51v5Q03k/UU0TAtPKKzyWfLlcAP6BfNz8lY8jrcmn2j1kyhd7vKZyyI/
kf+2jdS2o0QkGb0A6uIWP+IHbXgBo8M6YoOWOcM+v2eDfNLJL8CyMCFjxZdEOXLJ
DfyvIypwN/ASmS7N3s4PaBSKaA1CzcgQmdK8F0lSI5ySD0O0cKg=
=ydH6
-----END PGP SIGNATURE-----

--qSHHer9gQ0dtepKr--
