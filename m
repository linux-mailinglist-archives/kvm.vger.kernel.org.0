Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E10F793B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKKQyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:54:45 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32642 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726924AbfKKQyp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 11:54:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573491283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FW0ghkTNRFakkJKOxKKtNLRjEwoYfRw/+6ARHgx/6so=;
        b=SFzYhyK6K2oaBMrJBLJIaKVKmPlMq221+us48Am7ByEeh7VSI5lYfAl+qKaC7HKm/m1Rl+
        EoJPGH0pn16tneEjmPHj2ZUho2ZrXCbRtn1zXeRRr4aVxXqvjZO29bxeoDrGMyZjeO3bDo
        8nZPuO7oxMG26iKfzRfE94RIqKmhyLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240--bSLdSWhMTGee7aJD0jtMQ-1; Mon, 11 Nov 2019 11:54:40 -0500
X-MC-Unique: -bSLdSWhMTGee7aJD0jtMQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF51E107ACC4;
        Mon, 11 Nov 2019 16:54:38 +0000 (UTC)
Received: from gondolin (ovpn-117-4.ams2.redhat.com [10.36.117.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D2D10027A5;
        Mon, 11 Nov 2019 16:54:33 +0000 (UTC)
Date:   Mon, 11 Nov 2019 17:54:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
Message-ID: <20191111175421.11424cb0.cohuck@redhat.com>
In-Reply-To: <a99a9155-64cb-a083-07ee-a3fb543b40b5@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-5-frankja@linux.ibm.com>
        <20191107172956.4f4d8a90.cohuck@redhat.com>
        <8989f705-ce14-7b85-e5b6-6d87803db491@linux.ibm.com>
        <20191111172558.731a0d8b.cohuck@redhat.com>
        <a99a9155-64cb-a083-07ee-a3fb543b40b5@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; boundary="Sig_/MC6yGPU+m8kG.Km8/6Gka7/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/MC6yGPU+m8kG.Km8/6Gka7/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Nov 2019 17:39:15 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/11/19 5:25 PM, Cornelia Huck wrote:
> > On Fri, 8 Nov 2019 08:36:35 +0100
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >  =20
> >> On 11/7/19 5:29 PM, Cornelia Huck wrote: =20
> >>> On Thu, 24 Oct 2019 07:40:26 -0400
> >>> Janosch Frank <frankja@linux.ibm.com> wrote: =20
> >  =20
> >>>> @@ -2157,6 +2164,96 @@ static int kvm_s390_set_cmma_bits(struct kvm =
*kvm,
> >>>>  =09return r;
> >>>>  }
> >>>> =20
> >>>> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> >>>> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *c=
md)
> >>>> +{
> >>>> +=09int r =3D 0;
> >>>> +=09void __user *argp =3D (void __user *)cmd->data;
> >>>> +
> >>>> +=09switch (cmd->cmd) {
> >>>> +=09case KVM_PV_VM_CREATE: {
> >>>> +=09=09r =3D kvm_s390_pv_alloc_vm(kvm);
> >>>> +=09=09if (r)
> >>>> +=09=09=09break;
> >>>> +
> >>>> +=09=09mutex_lock(&kvm->lock);
> >>>> +=09=09kvm_s390_vcpu_block_all(kvm);
> >>>> +=09=09/* FMT 4 SIE needs esca */
> >>>> +=09=09r =3D sca_switch_to_extended(kvm); =20
> >=20
> > Looking at this again: this function calls kvm_s390_vcpu_block_all()
> > (which probably does not hurt), but then kvm_s390_vcpu_unblock_all()...
> > don't we want to keep the block across pv_create_vm() as well? =20
>=20
> Yeah
>=20
> >=20
> > Also, can you maybe skip calling this function if we use the esca
> > already? =20
>=20
> Did I forget to include that in the patchset?
> I extended sca_switch_to_extended() to just return in that case.

If you did, I likely missed it; way too much stuff to review :)

>=20
> >  =20
> >>>> +=09=09if (!r)
> >>>> +=09=09=09r =3D kvm_s390_pv_create_vm(kvm);
> >>>> +=09=09kvm_s390_vcpu_unblock_all(kvm);
> >>>> +=09=09mutex_unlock(&kvm->lock);
> >>>> +=09=09break;
> >>>> +=09}

(...)

> >>>> @@ -2555,8 +2671,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >>>>  {
> >>>>  =09kvm_free_vcpus(kvm);
> >>>>  =09sca_dispose(kvm);
> >>>> -=09debug_unregister(kvm->arch.dbf);
> >>>>  =09kvm_s390_gisa_destroy(kvm);
> >>>> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
> >>>> +=09    kvm_s390_pv_is_protected(kvm)) {
> >>>> +=09=09kvm_s390_pv_destroy_vm(kvm);
> >>>> +=09=09kvm_s390_pv_dealloc_vm(kvm);   =20
> >>>
> >>> It seems the pv vm can be either destroyed via the ioctl above or in
> >>> the course of normal vm destruction. When is which way supposed to be
> >>> used? Also, it seems kvm_s390_pv_destroy_vm() can fail -- can that be=
 a
> >>> problem in this code path?   =20
> >>
> >> On a reboot we need to tear down the protected VM and boot from
> >> unprotected mode again. If the VM shuts down we go through this cleanu=
p
> >> path. If it fails the kernel will loose the memory that was allocated =
to
> >> start the VM. =20
> >=20
> > Shouldn't you at least log a moan in that case? Hopefully, this happens
> > very rarely, but the dbf will be gone... =20
>=20
> That's why I created the uv dbf :-)

Again, way too easy to get lost in these changes :)

> Well, it shouldn't happen at all so maybe a WARN will be a good option

Yeah, if it this is one of these "should not happen" things, a WARN
sounds good.

>=20
> >  =20
> >> =20
> >>>    =20
> >>>> +=09}
> >>>> +=09debug_unregister(kvm->arch.dbf);
> >>>>  =09free_page((unsigned long)kvm->arch.sie_page2);
> >>>>  =09if (!kvm_is_ucontrol(kvm))
> >>>>  =09=09gmap_remove(kvm->arch.gmap);   =20

--Sig_/MC6yGPU+m8kG.Km8/6Gka7/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl3Jkj0ACgkQ3s9rk8bw
L6+82A/+LHWboMq9UZVl7tJU6hYxG6blsNyA6gGqRavPCwvyrDfV+9NOnUExV3be
WHSvkks+kPPsdBF8QPQRzrhEftaAa5Sti2rPincSVf37/FJOYZZrl44nW5RTmflw
ENZLeU94+v4E7Z0n89xXhetlucpW+HPZx4sj0ulEZWkCmEXYPCDHbyK074ayM6dw
f9LHzKwFu0gnJD8T5hs8VsdpOkeZpVVrlq8QjcNReNV3jc0ZYujVRbiU0tr58iFg
oTtkTlUJ3ustxXfQ05LTTDMwhKLs1mgdBQ5H8KiDnR46tqbGHCqfjTdc0Utvv/El
U6nZFfuZV+q3X4yp0Ri2mAagm7h1BUXhA6sa5Ej3xjKlDXPVHzmO9uKGdPg2uLaM
TTIkApJsi4iqGnOzx66/2ADSMCTkHcvxBsaipKEeASpp51ns4pcVQx4W/2AgQSZI
GgVAe3mgdh4657n34sO36WVAlMMl9GOrgIcsZeDgPpZwzMggEVLI7nsiHOSeIqJw
ehCBMcV1OxDoqsift6tK+Vw8Hf5kV2Jtt233eqKFraZL1F/pnnJkoo2/q0ZgFvlv
Hvyc+Jvld/2/EpJc7R6wpBBobZaA8pldOT/+LC6XtSf9t3fy9Qn0rR3UQpmelbLM
IObX5ep3zswpBu8ms8A2tVy916Y5m8axnyYW15g4LR6aybib/jM=
=yq0B
-----END PGP SIGNATURE-----

--Sig_/MC6yGPU+m8kG.Km8/6Gka7/--

