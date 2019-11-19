Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C93102114
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 10:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfKSJpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 04:45:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60486 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbfKSJps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 04:45:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574156748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9AUb92RYFJFMPUckMcMKSsMU74llM5H5sHH7q4HkSEU=;
        b=B2l+u0/WC4cEcuhrJGHM35AbO6xbMw77jf9S8MY4g23nBcPDiOVQD9P2jYl3uheKw34HKG
        OjynOZD/JCsotVOXRGVhFRIvWp56xstmZk1zNM3YIr7hT6oKzHs+c+P0EPlDGdTXBDztgE
        J+xIJnyJcLDfGSlCz43mQz7HXrdfc3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-vHhsPlpiO1GWTroyzCkHnw-1; Tue, 19 Nov 2019 04:45:46 -0500
X-MC-Unique: vHhsPlpiO1GWTroyzCkHnw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B6821852E20;
        Tue, 19 Nov 2019 09:45:45 +0000 (UTC)
Received: from gondolin (ovpn-117-102.ams2.redhat.com [10.36.117.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A299627DE;
        Tue, 19 Nov 2019 09:45:40 +0000 (UTC)
Date:   Tue, 19 Nov 2019 10:45:28 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 23/37] KVM: s390: protvirt: Make sure prefix is always
 protected
Message-ID: <20191119104528.3f3c2620.cohuck@redhat.com>
In-Reply-To: <db54630b-8959-feba-168e-0afecc30d4b9@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-24-frankja@linux.ibm.com>
        <20191118173942.0252b731.cohuck@redhat.com>
        <db54630b-8959-feba-168e-0afecc30d4b9@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; boundary="Sig_/zhv7PoOZ1lQTw1Ax=3I64YS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/zhv7PoOZ1lQTw1Ax=3I64YS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Nov 2019 09:11:11 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/18/19 5:39 PM, Cornelia Huck wrote:
> > On Thu, 24 Oct 2019 07:40:45 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >=20
> > Add at least a short sentence here? =20
>=20
> For protected VMs the lowcore does not only need to be mapped, but also
> needs to be protected memory, if not we'll get a validity interception
> when trying to run it.

Much better, thanks!

>=20
> >  =20
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>  arch/s390/kvm/kvm-s390.c | 9 +++++++++
> >>  1 file changed, 9 insertions(+)
> >>
> >> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >> index eddc9508c1b1..17a78774c617 100644
> >> --- a/arch/s390/kvm/kvm-s390.c
> >> +++ b/arch/s390/kvm/kvm-s390.c
> >> @@ -3646,6 +3646,15 @@ static int kvm_s390_handle_requests(struct kvm_=
vcpu *vcpu)
> >>  =09=09rc =3D gmap_mprotect_notify(vcpu->arch.gmap,
> >>  =09=09=09=09=09  kvm_s390_get_prefix(vcpu),
> >>  =09=09=09=09=09  PAGE_SIZE * 2, PROT_WRITE);
> >> +=09=09if (!rc && kvm_s390_pv_is_protected(vcpu->kvm)) {
> >> +=09=09=09rc =3D uv_convert_to_secure(vcpu->arch.gmap,
> >> +=09=09=09=09=09=09  kvm_s390_get_prefix(vcpu));
> >> +=09=09=09WARN_ON_ONCE(rc && rc !=3D -EEXIST);
> >> +=09=09=09rc =3D uv_convert_to_secure(vcpu->arch.gmap,
> >> +=09=09=09=09=09=09  kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
> >> +=09=09=09WARN_ON_ONCE(rc && rc !=3D -EEXIST);
> >> +=09=09=09rc =3D 0; =20
> >=20
> > So, what happens if we have an error other than -EEXIST (which
> > presumably means that we already protected it) here? The page is not
> > protected, and further accesses will get an error? (Another question:
> > what can actually go wrong here?) =20
>=20
> If KVM or QEMU write into a lowcore, we will fail the integrity check on
> import and this cpu will never run again.

From the guest's POV, is that similar to a cpu going into xstop?
=20
> In retrospect a warn_on_once might be the wrong error handling here.
>=20
> >  =20
> >> +=09=09}
> >>  =09=09if (rc) {
> >>  =09=09=09kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> >>  =09=09=09return rc; =20
> >  =20
>=20
>=20


--Sig_/zhv7PoOZ1lQTw1Ax=3I64YS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl3TubgACgkQ3s9rk8bw
L68TyxAAj7WCu4pHHzMaOOfcByYdpzzcqt4Z1xEWoh20i9FK+b7uRAQRBA0WdIBA
RcxwMzsjNwJAspxH4/g/1agXJvDb5GK5ryaqvqBvOIm8cHLUOewT/jC0L+1qIC6J
6w9yXU4Ml813k7hEj/qLwcjRqYIwxQe5r18IHGoI6tXnfBn2WYkokBzI4TzlADLr
tpRIc6WvSQSorTqTm0xckBPJ+X3hL2/HWfq54SWl6XFdKbvmP0kQRvvZq6+UEaPs
bbJ4AV6qGiWPzNt/yuv/9wKlS9zVTdnip5Tv1SZ/I2r8HQCyCZcG5yNUszCjKhp7
P6pSIIvesjVXRVdPlWILoBZKxEcHLHD8yXhpjOcv9gn5ES3BcRrnT+wIuZbfTk8b
3s1mgjAukFFOB/dvAFt1+bx5a2J7d3i1YlXSyTVRIbvdS1UK5hpwFFRP05GpAZpv
cRdZ392oN5siqAOOgHuvwOGMOpMQYK4Zl55X1lCuV4uqdUe7s4EOVH1/qu8M8zoU
ifeS0LTc3RAp0rbKEbqMffWw+8MiZ42SFSo3BXeQvn97tK52budt2nphwdA8PGsE
CsmFM0P4Rgbal5i7MAx5vHvJVFEgcsEiBdlZ1XUo2aaGyGJ2bmfvTilJW1jRbJgd
WyTWhPnpZnN+QLuZmSM2ESZmxg64QS3hCsZwllJJ3kB8JK6fkBw=
=vkoq
-----END PGP SIGNATURE-----

--Sig_/zhv7PoOZ1lQTw1Ax=3I64YS--

