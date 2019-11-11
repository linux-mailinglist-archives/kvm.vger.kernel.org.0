Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E37F78BA
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKKQ0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:26:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbfKKQ0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:26:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573489581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zCTkYzqymPCcXrOHdRh7cCtF0cBwrt5l2QNg+d+KuAA=;
        b=DS/RyjX5Viv8Jbmv3AWQisCdFFjdww5Ht/RR1PiDwFZhtGP5Qq9pA400pGmufb+rxDntaw
        7tt3zpdvKLKR6hWTi3UgNBXu0T9Yk2DOFHIrW+nVw0iokmVyXk3AWwfpFLzq6ecPa/TcKT
        lCVcjN0N85SPxtxj7fbyYJf3+SHzUDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-o1UoMp8XMXCWzqDaRlK2VA-1; Mon, 11 Nov 2019 11:26:18 -0500
X-MC-Unique: o1UoMp8XMXCWzqDaRlK2VA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5CB4DBFF;
        Mon, 11 Nov 2019 16:26:16 +0000 (UTC)
Received: from gondolin (ovpn-117-4.ams2.redhat.com [10.36.117.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DA6610027A5;
        Mon, 11 Nov 2019 16:26:11 +0000 (UTC)
Date:   Mon, 11 Nov 2019 17:25:58 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
Message-ID: <20191111172558.731a0d8b.cohuck@redhat.com>
In-Reply-To: <8989f705-ce14-7b85-e5b6-6d87803db491@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-5-frankja@linux.ibm.com>
        <20191107172956.4f4d8a90.cohuck@redhat.com>
        <8989f705-ce14-7b85-e5b6-6d87803db491@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; boundary="Sig_/=Bz.swff5m_75zBIaFx83X5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/=Bz.swff5m_75zBIaFx83X5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Nov 2019 08:36:35 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/7/19 5:29 PM, Cornelia Huck wrote:
> > On Thu, 24 Oct 2019 07:40:26 -0400
> > Janosch Frank <frankja@linux.ibm.com> wrote:

> >> @@ -2157,6 +2164,96 @@ static int kvm_s390_set_cmma_bits(struct kvm *k=
vm,
> >>  =09return r;
> >>  }
> >> =20
> >> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> >> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd=
)
> >> +{
> >> +=09int r =3D 0;
> >> +=09void __user *argp =3D (void __user *)cmd->data;
> >> +
> >> +=09switch (cmd->cmd) {
> >> +=09case KVM_PV_VM_CREATE: {
> >> +=09=09r =3D kvm_s390_pv_alloc_vm(kvm);
> >> +=09=09if (r)
> >> +=09=09=09break;
> >> +
> >> +=09=09mutex_lock(&kvm->lock);
> >> +=09=09kvm_s390_vcpu_block_all(kvm);
> >> +=09=09/* FMT 4 SIE needs esca */
> >> +=09=09r =3D sca_switch_to_extended(kvm);

Looking at this again: this function calls kvm_s390_vcpu_block_all()
(which probably does not hurt), but then kvm_s390_vcpu_unblock_all()...
don't we want to keep the block across pv_create_vm() as well?

Also, can you maybe skip calling this function if we use the esca
already?

> >> +=09=09if (!r)
> >> +=09=09=09r =3D kvm_s390_pv_create_vm(kvm);
> >> +=09=09kvm_s390_vcpu_unblock_all(kvm);
> >> +=09=09mutex_unlock(&kvm->lock);
> >> +=09=09break;
> >> +=09}
> >> +=09case KVM_PV_VM_DESTROY: {
> >> +=09=09/* All VCPUs have to be destroyed before this call. */
> >> +=09=09mutex_lock(&kvm->lock);
> >> +=09=09kvm_s390_vcpu_block_all(kvm);
> >> +=09=09r =3D kvm_s390_pv_destroy_vm(kvm);
> >> +=09=09if (!r)
> >> +=09=09=09kvm_s390_pv_dealloc_vm(kvm);
> >> +=09=09kvm_s390_vcpu_unblock_all(kvm);
> >> +=09=09mutex_unlock(&kvm->lock);
> >> +=09=09break;
> >> +=09} =20
> >=20
> > Would be helpful to have some code that shows when/how these are called
> > - do you have any plans to post something soon? =20
>=20
> Qemu patches will be in internal review soonish and afterwards I'll post
> them upstream

Great, looking forward to this :)

>=20
> >=20
> > (...)
> >  =20
> >> @@ -2529,6 +2642,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu=
)
> >> =20
> >>  =09if (vcpu->kvm->arch.use_cmma)
> >>  =09=09kvm_s390_vcpu_unsetup_cmma(vcpu);
> >> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
> >> +=09    kvm_s390_pv_handle_cpu(vcpu)) =20
> >=20
> > I was a bit confused by that function name... maybe
> > kvm_s390_pv_cpu_get_handle()? =20
>=20
> Sure
>=20
> >=20
> > Also, if this always returns 0 if the config option is off, you
> > probably don't need to check for that option? =20
>=20
> Hmm, if we decide to remove the config option altogether then it's not
> needed anyway and I think that's what Christian wants.

That would be fine with me as well (I have not yet thought about all
implications there, though.)

>=20
> >  =20
> >> +=09=09kvm_s390_pv_destroy_cpu(vcpu);
> >>  =09free_page((unsigned long)(vcpu->arch.sie_block));
> >> =20
> >>  =09kvm_vcpu_uninit(vcpu);
> >> @@ -2555,8 +2671,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> >>  {
> >>  =09kvm_free_vcpus(kvm);
> >>  =09sca_dispose(kvm);
> >> -=09debug_unregister(kvm->arch.dbf);
> >>  =09kvm_s390_gisa_destroy(kvm);
> >> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
> >> +=09    kvm_s390_pv_is_protected(kvm)) {
> >> +=09=09kvm_s390_pv_destroy_vm(kvm);
> >> +=09=09kvm_s390_pv_dealloc_vm(kvm); =20
> >=20
> > It seems the pv vm can be either destroyed via the ioctl above or in
> > the course of normal vm destruction. When is which way supposed to be
> > used? Also, it seems kvm_s390_pv_destroy_vm() can fail -- can that be a
> > problem in this code path? =20
>=20
> On a reboot we need to tear down the protected VM and boot from
> unprotected mode again. If the VM shuts down we go through this cleanup
> path. If it fails the kernel will loose the memory that was allocated to
> start the VM.

Shouldn't you at least log a moan in that case? Hopefully, this happens
very rarely, but the dbf will be gone...

>=20
> >  =20
> >> +=09}
> >> +=09debug_unregister(kvm->arch.dbf);
> >>  =09free_page((unsigned long)kvm->arch.sie_page2);
> >>  =09if (!kvm_is_ucontrol(kvm))
> >>  =09=09gmap_remove(kvm->arch.gmap); =20
> >=20
> > (...)
> >  =20
> >> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> >> index 6d9448dbd052..0d61dcc51f0e 100644
> >> --- a/arch/s390/kvm/kvm-s390.h
> >> +++ b/arch/s390/kvm/kvm-s390.h
> >> @@ -196,6 +196,53 @@ static inline int kvm_s390_user_cpu_state_ctrl(st=
ruct kvm *kvm)
> >>  =09return kvm->arch.user_cpu_state_ctrl !=3D 0;
> >>  }
> >> =20
> >> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> >> +/* implemented in pv.c */
> >> +void kvm_s390_pv_unpin(struct kvm *kvm);
> >> +void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
> >> +int kvm_s390_pv_alloc_vm(struct kvm *kvm);
> >> +int kvm_s390_pv_create_vm(struct kvm *kvm);
> >> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu);
> >> +int kvm_s390_pv_destroy_vm(struct kvm *kvm);
> >> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu);
> >> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length)=
;
> >> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned =
long size,
> >> +=09=09       unsigned long tweak);
> >> +int kvm_s390_pv_verify(struct kvm *kvm);
> >> +
> >> +static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
> >> +{
> >> +=09return !!kvm->arch.pv.handle;
> >> +}
> >> +
> >> +static inline u64 kvm_s390_pv_handle(struct kvm *kvm) =20
> >=20
> > This function name is less confusing than the one below, but maybe also
> > rename this to kvm_s390_pv_get_handle() for consistency? =20
>=20
> kvm_s390_pv_kvm_handle?

kvm_s390_pv_kvm_get_handle() would mirror the cpu function :) </bikeshed>

>=20
> >  =20
> >> +{
> >> +=09return kvm->arch.pv.handle;
> >> +}
> >> +
> >> +static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu)
> >> +{
> >> +=09return vcpu->arch.pv.handle;
> >> +}
> >> +#else
> >> +static inline void kvm_s390_pv_unpin(struct kvm *kvm) {}
> >> +static inline void kvm_s390_pv_dealloc_vm(struct kvm *kvm) {}
> >> +static inline int kvm_s390_pv_alloc_vm(struct kvm *kvm) { return 0; }
> >> +static inline int kvm_s390_pv_create_vm(struct kvm *kvm) { return 0; =
}
> >> +static inline int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu) { ret=
urn 0; }
> >> +static inline int kvm_s390_pv_destroy_vm(struct kvm *kvm) { return 0;=
 }
> >> +static inline int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu) { re=
turn 0; }
> >> +static inline int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
> >> +=09=09=09=09=09    u64 origin, u64 length) { return 0; }
> >> +static inline int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long a=
ddr,
> >> +=09=09=09=09     unsigned long size,  unsigned long tweak)
> >> +{ return 0; }
> >> +static inline int kvm_s390_pv_verify(struct kvm *kvm) { return 0; }
> >> +static inline bool kvm_s390_pv_is_protected(struct kvm *kvm) { return=
 0; }
> >> +static inline u64 kvm_s390_pv_handle(struct kvm *kvm) { return 0; }
> >> +static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu) { ret=
urn 0; }
> >> +#endif
> >> +
> >>  /* implemented in interrupt.c */
> >>  int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
> >>  void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu); =20
> >=20
> > (...)
> >  =20
> >> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
> >> +{
> >> +=09int rc;
> >> +=09struct uv_cb_csc uvcb =3D {
> >> +=09=09.header.cmd =3D UVC_CMD_CREATE_SEC_CPU,
> >> +=09=09.header.len =3D sizeof(uvcb),
> >> +=09};
> >> +
> >> +=09/* EEXIST and ENOENT? */ =20
> >=20
> > ? =20
>=20
> I was asking myself if EEXIST or ENOENT would be better error values
> than EINVAL.

EEXIST might be better, but I don't really like ENOENT.

>=20
> >  =20
> >> +=09if (kvm_s390_pv_handle_cpu(vcpu))
> >> +=09=09return -EINVAL;
> >> +
> >> +=09vcpu->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL,
> >> +=09=09=09=09=09=09   get_order(uv_info.guest_cpu_stor_len));
> >> +=09if (!vcpu->arch.pv.stor_base)
> >> +=09=09return -ENOMEM;
> >> +
> >> +=09/* Input */
> >> +=09uvcb.guest_handle =3D kvm_s390_pv_handle(vcpu->kvm);
> >> +=09uvcb.num =3D vcpu->arch.sie_block->icpua;
> >> +=09uvcb.state_origin =3D (u64)vcpu->arch.sie_block;
> >> +=09uvcb.stor_origin =3D (u64)vcpu->arch.pv.stor_base;
> >> +
> >> +=09rc =3D uv_call(0, (u64)&uvcb);
> >> +=09VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %=
x rrc %x",
> >> +=09=09   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
> >> +=09=09   uvcb.header.rrc);
> >> +
> >> +=09/* Output */
> >> +=09vcpu->arch.pv.handle =3D uvcb.cpu_handle;
> >> +=09vcpu->arch.sie_block->pv_handle_cpu =3D uvcb.cpu_handle;
> >> +=09vcpu->arch.sie_block->pv_handle_config =3D kvm_s390_pv_handle(vcpu=
->kvm);
> >> +=09vcpu->arch.sie_block->sdf =3D 2;
> >> +=09if (!rc)
> >> +=09=09return 0;
> >> +
> >> +=09kvm_s390_pv_destroy_cpu(vcpu);
> >> +=09return -EINVAL;
> >> +} =20
> >=20
> > (...)
> >=20
> > Only a quick readthrough, as this patch is longish.
> >  =20
>=20
>=20


--Sig_/=Bz.swff5m_75zBIaFx83X5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw9DWbcNiT/aowBjO3s9rk8bwL68FAl3Ji5YACgkQ3s9rk8bw
L6+nqhAAtSAC5DCFbZk3dTBYI0AGeyB9WVc1XuCfXTxbF7k+USm1dRQhfX6bzL60
InG0Hf2XMiM6fV/GHvUUb9UHmkUBCkndYp61yioaDaoLqu9DEQR3YBdRUAr6W1EB
OYIVRzorIBSUG/X7gelcNQVayDUuh64/eEoRioK9mscpig8FxnEE1ekgDT5GiZBE
UGqqm0BCBp8e+1dAj8gXIjpoPSMuXEilnktW68WrO03jM4JBGP8L1CNSnj8X4m+Q
9x4DTNH1eNgEAVEyjc/KNjvlyoAuqaPSVck7hAQZKYjnHRJHOJO3jTJOF1kgmAre
CS0LlJj0PrkdZD9EwQn7TONqbFbxdrKEAoBFwCDSeMgsHokd49Wbc1oGgnLLv1AF
DccWst6jSt/djdgt8TCzeS5Lra8IBJDBKbu18tTqmTmicYvvb7fo+BmmaHNjY/GG
B5HHksEJyk+pKFPStXh8CUng3RCupgZuR4u7mZnx59qedYiTzN/khBpc9zg/SaU0
csdvAfMr+WpoVC5fKqZhJ+3ZAwCbS88hpTQ6R9paYaJCm/RibdnBFHdn5/ReqDLS
4+CA71FKsoiWrRB/UNsl8wnHczH8jq9gTOP9c09Jzw3e/JJeGDNWSKmgI0PCep16
77NWPrDXBOo0GEZhqYPDYogRzdNNHjX6f9qSd/5ASBQ+OrWR8Es=
=N6o7
-----END PGP SIGNATURE-----

--Sig_/=Bz.swff5m_75zBIaFx83X5--

