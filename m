Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5698D13DE44
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 16:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgAPPF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 10:05:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52865 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726160AbgAPPF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 10:05:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579187156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kOmwz01mePXBYnhHcPG/iYv5hOVqKYDvyGKmU7ezAzA=;
        b=g+ARaspYq/yEOK+w3myQugj3lAkJ34Pbd612zRxxReNEFtNdSWvsXz+JxrIw6e0V8ISgcy
        nVtZuHCRJM5qTnw3VDtMRKOh11kUyP2jDr/y8tz8ExFrEnAOMhzxakLoUOqE/wSkv/zpJo
        cqrrYvnwGVUqG6ON/phLI4lYQBTNg6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295--MG8eiINP0KTyi1ma6Rk6g-1; Thu, 16 Jan 2020 10:05:52 -0500
X-MC-Unique: -MG8eiINP0KTyi1ma6Rk6g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B603D8010C1;
        Thu, 16 Jan 2020 15:05:49 +0000 (UTC)
Received: from gondolin (unknown [10.36.117.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D64F05D9C9;
        Thu, 16 Jan 2020 15:05:45 +0000 (UTC)
Date:   Thu, 16 Jan 2020 16:05:43 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] s390x: smp: Rework cpu start and
 active tracking
Message-ID: <20200116160543.70f52cb2.cohuck@redhat.com>
In-Reply-To: <4e4587a6-efba-6f40-306b-3704e53aafc3@linux.ibm.com>
References: <20200116120513.2244-1-frankja@linux.ibm.com>
        <20200116120513.2244-5-frankja@linux.ibm.com>
        <20200116151453.186cbf94.cohuck@redhat.com>
        <4e4587a6-efba-6f40-306b-3704e53aafc3@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/edF2O_rEm1wXQnnHeEgIQQj";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/edF2O_rEm1wXQnnHeEgIQQj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Jan 2020 15:44:24 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/16/20 3:14 PM, Cornelia Huck wrote:
> > On Thu, 16 Jan 2020 07:05:10 -0500
> > Janosch Frank <frankja@linux.ibm.com> wrote:

> >> +static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
> >> +{
> >> +=09int rc;
> >> +=09struct cpu *cpu =3D smp_cpu_from_addr(addr);
> >> +
> >> +=09if (!cpu)
> >> +=09=09return -1;
> >> +=09if (psw) {
> >> +=09=09cpu->lowcore->restart_new_psw.mask =3D psw->mask;
> >> +=09=09cpu->lowcore->restart_new_psw.addr =3D psw->addr;
> >> +=09}
> >> +=09rc =3D sigp(addr, SIGP_RESTART, 0, NULL);
> >> +=09if (rc)
> >> +=09=09return rc;
> >> +=09while (!smp_cpu_running(addr)) { mb(); } =20
> >=20
> > Maybe split this statement? Also, maybe add a comment =20
>=20
> /* Wait until the target cpu is running */
> ?

Fine with me as well :)

>=20
> This is not QEMU with two line ifs taking up 3 lines :)

Heh, it's just the style I'm used to :)

>=20
> >=20
> > /*
> >  * The order has been accepted, but the actual restart may not
> >  * have been performed yet, so wait until the cpu is running.
> >  */
> >=20
> > ?
> >  =20
> >> +=09cpu->active =3D true;
> >> +=09return 0;
> >> +} =20
> >=20
> > The changes look good to me AFAICS.
> >=20
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com> =20
>=20
> Thanks!
>=20
>=20


--Sig_/edF2O_rEm1wXQnnHeEgIQQj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl4ge8cACgkQ3s9rk8bw
L6+ffA//dmfYUxNJy7AWz/pDhnlAUYTWjuVjyNWTtA2QOrrfuTNqwtluEHwd1+jV
6mB/24dhB1ItAnPY7cvdNrotGDDI5fsIPbX4Am02H1fTVFbR7yH72vMuiGzclJSG
bW2Cml07cVMYUKqjEmE9MzB9sM5dta9k6wV1i4WkjF+rNXDpKBDPDbb9fi00Hozq
s1km3hclXtZVwwiFAdvMKFpX2MjpLR9vEkQCCMgHSS/KEO1O9pJQi+GwIBpnaSEe
kpt2DfHpmkTzeEYEZbFlYrydN0HZT+3o8nfWfq1IZwm/mDsoLgcqU2VM/em98BpL
b//VtTHxKIKz0h9z754QQS/ENRP6V5R6ReWlJo2ddzdlLniIf3B8Vdb4UgLRo3bi
JucKJDECd3TxCd4g1zQ7BlADt0oqq+16wb1Jhm3wFjQkoFNYVd7Ad3kuHORtVpI+
yfw4AJjWdzf9nUppCnLYm7toHqks5fos/JdfQH+95ItH/SzO+YNonar9nSjvyaT2
98y75kIcJ+qsjEWtmgSuTJzDgJVLdbLogjJGx4FFJgK1KYigML6JVPJCsTE/Ph1M
lo3wm5E798fheX6+Kw4obQBwR4lfbyKm5SqzILFiykvuWHsy6qpkc/UJl3PSRpur
S1u4xEBtGiTXJpqNv5evsUqVfR107k+8j75gauKscY/GLYmFXHY=
=I70c
-----END PGP SIGNATURE-----

--Sig_/edF2O_rEm1wXQnnHeEgIQQj--

