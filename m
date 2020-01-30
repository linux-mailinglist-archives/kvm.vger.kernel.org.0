Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86DF14D9C4
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgA3L3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:29:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30367 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726902AbgA3L3L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 06:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580383750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/NCND+HnTovENxeTR5Edg2mz99fK3M61gosDJh7qkyM=;
        b=gmkVTmsx86vDRqA3UFxAzBDlp2LsKrFsOE2Vh6IHIZfsBkAzrKqabrwAGX5b1aUng3bLMZ
        BKLjL6bC1YF4X0T6UEdtkDgIKAwQZwJlFw/65VTx63hCBPQH3xcK+iewtcnnFt2Sr1owTQ
        TALHT93tFROSmL3XPRT/KrZJINa13rE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-gSDpR6laPLKx5985YD9_5A-1; Thu, 30 Jan 2020 06:29:03 -0500
X-MC-Unique: gSDpR6laPLKx5985YD9_5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 860F21005512;
        Thu, 30 Jan 2020 11:29:02 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26F4E5DA7E;
        Thu, 30 Jan 2020 11:29:00 +0000 (UTC)
Date:   Thu, 30 Jan 2020 12:28:49 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH v8 4/4] selftests: KVM: testing the local IRQs resets
Message-ID: <20200130122849.763bd678.cohuck@redhat.com>
In-Reply-To: <bd7dc770-4613-5af5-e695-aabc70f84c16@linux.ibm.com>
References: <20200129200312.3200-1-frankja@linux.ibm.com>
        <20200129200312.3200-5-frankja@linux.ibm.com>
        <20200130115543.1f06a840.cohuck@redhat.com>
        <bd7dc770-4613-5af5-e695-aabc70f84c16@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; boundary="Sig_/IJGqp2CXGXJEd7ft5PTSr5h";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/IJGqp2CXGXJEd7ft5PTSr5h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jan 2020 12:18:31 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 1/30/20 11:55 AM, Cornelia Huck wrote:
> > On Wed, 29 Jan 2020 15:03:12 -0500
> > Janosch Frank <frankja@linux.ibm.com> wrote:

> >> +=09irq_state.len =3D sizeof(buf);
> >> +=09irq_state.buf =3D (unsigned long)buf;
> >> +=09irqs =3D _vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_sta=
te);
> >> +=09/*
> >> +=09 * irqs contains the number of retrieved interrupts, apart from th=
e
> >> +=09 * emergency call that should be cleared by the resets, there shou=
ld be
> >> +=09 * none. =20
> >=20
> > Even if there were any, they should have been cleared by the reset,
> > right? =20
>=20
> Yes, that's what "there should be none" should actually express.
> I added the comment before sending out.

So what about

/*
 * irqs contains the number of retrieved interrupts. Any interrupt
 * (notably, the emergency call interrupt we have injected) should
 * be cleared by the resets, so this should be 0.
 */

?

>=20
> >  =20
> >> +=09 */
> >> +=09if (irqs < 0)
> >> +=09=09printf("Error by getting IRQ: errno %d\n", errno); =20
> >=20
> > "Error getting pending IRQs" ? =20
>=20
> "Could not fetch IRQs: errno %d\n" ?

Sounds good.

>=20
> >  =20
> >> +
> >> +=09TEST_ASSERT(!irqs, "IRQ pending");
> >> +}

--Sig_/IJGqp2CXGXJEd7ft5PTSr5h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl4yvfIACgkQ3s9rk8bw
L68r3w//YBTijJZDcW9Iv0bPJd4yvD8TBHAh/e5eGYr3w6OLSz3iPe8o8R8dQ4eh
PBItGlSaFoCqXTFxi/D0Pmr0ZaS5jH9hwJTHNAN8rJiLGhZY0vOw5hVFhffck+u+
twM/Qq/oDJL/lMUVAAj1hHGb4Dvh1ExIixKkDAnHlcYTHatYmE1VPrc7OvV1VmxG
hdN+faSQEtZerhME/ujhgoz+VAP2JXOKbsp/+0nvW4twofrBYyRK4iyBWpJHOR9Z
XjiIbG0fflXi59vQ0Bm8l/Hoj7rzWRtcKdLQPgY1wbaoVzC0IHTg2esrucJis6Pv
musi9mRoDEFOZD5jhS069KcG6n10RKAIrf5Ap4NHQLneK0oLE7rJOFLiv+PFTNi3
/uVBik0MB8NI9qSiLR4bfEjWJ9dWTOQbPpsd1WcIWJ20TbX3AMo6DFYiM+2xsA16
4J6VvRV8N1hRIYzLwYn9UvAU5mp0c+racy6rWnqOv8SMWCxe0ZvWtFodLiiAopK+
SGHhcXagxEkTXQkCRMwFSJdli31IWAVji6p89yp32zk1nzZsxbFcvNp8jrywmGJN
GZxmjSaLk3cvG2bHvw5ZRyWuBC+5uEm6u/vc8rKSW/AhykenxiF56KttS72a5w4E
0Fv/TSjyM9kfQdR379VO937UiW5SxuPK2j+9XGcfHxshWLd4/yQ=
=ovR4
-----END PGP SIGNATURE-----

--Sig_/IJGqp2CXGXJEd7ft5PTSr5h--

