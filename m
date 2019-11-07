Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95BEF34A5
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 17:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbfKGQaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 11:30:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40363 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727606AbfKGQaR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Nov 2019 11:30:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573144216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9iUGIATPWGlrCyytMv5PoDcROBcbF2ZwF3JfqkMtX+g=;
        b=MCvryzhy057Wm0iP4LTOAfxAghT8SAGdF8MrnnDn9MZqdYKmgGIXcFoKkl0f0P8r58anlb
        v3iQ8jFV5Gsih/8Dt02QbQ+6DQ1mRMl/9BLPPL270qqK92Y7HOSrnUQIdkqsZvqo+/4OCb
        GqFC7guSfrh/Q3FmDiq4LnzXv8nD9no=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-PZX1kUoWOgWyf1ry26GILw-1; Thu, 07 Nov 2019 11:30:13 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA51D107ACC4;
        Thu,  7 Nov 2019 16:30:11 +0000 (UTC)
Received: from gondolin (ovpn-117-222.ams2.redhat.com [10.36.117.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 044E2600F0;
        Thu,  7 Nov 2019 16:30:01 +0000 (UTC)
Date:   Thu, 7 Nov 2019 17:29:56 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
Message-ID: <20191107172956.4f4d8a90.cohuck@redhat.com>
In-Reply-To: <20191024114059.102802-5-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
        <20191024114059.102802-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: PZX1kUoWOgWyf1ry26GILw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 07:40:26 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's add a KVM interface to create and destroy protected VMs.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  24 +++-
>  arch/s390/include/asm/uv.h       | 110 ++++++++++++++
>  arch/s390/kvm/Makefile           |   2 +-
>  arch/s390/kvm/kvm-s390.c         | 173 +++++++++++++++++++++-
>  arch/s390/kvm/kvm-s390.h         |  47 ++++++
>  arch/s390/kvm/pv.c               | 237 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h         |  33 +++++

Any new ioctls and caps probably want a mention in
Documentation/virt/kvm/api.txt :)

>  7 files changed, 622 insertions(+), 4 deletions(-)
>  create mode 100644 arch/s390/kvm/pv.c

(...)

> @@ -2157,6 +2164,96 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
>  =09return r;
>  }
> =20
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +=09int r =3D 0;
> +=09void __user *argp =3D (void __user *)cmd->data;
> +
> +=09switch (cmd->cmd) {
> +=09case KVM_PV_VM_CREATE: {
> +=09=09r =3D kvm_s390_pv_alloc_vm(kvm);
> +=09=09if (r)
> +=09=09=09break;
> +
> +=09=09mutex_lock(&kvm->lock);
> +=09=09kvm_s390_vcpu_block_all(kvm);
> +=09=09/* FMT 4 SIE needs esca */
> +=09=09r =3D sca_switch_to_extended(kvm);
> +=09=09if (!r)
> +=09=09=09r =3D kvm_s390_pv_create_vm(kvm);
> +=09=09kvm_s390_vcpu_unblock_all(kvm);
> +=09=09mutex_unlock(&kvm->lock);
> +=09=09break;
> +=09}
> +=09case KVM_PV_VM_DESTROY: {
> +=09=09/* All VCPUs have to be destroyed before this call. */
> +=09=09mutex_lock(&kvm->lock);
> +=09=09kvm_s390_vcpu_block_all(kvm);
> +=09=09r =3D kvm_s390_pv_destroy_vm(kvm);
> +=09=09if (!r)
> +=09=09=09kvm_s390_pv_dealloc_vm(kvm);
> +=09=09kvm_s390_vcpu_unblock_all(kvm);
> +=09=09mutex_unlock(&kvm->lock);
> +=09=09break;
> +=09}

Would be helpful to have some code that shows when/how these are called
- do you have any plans to post something soon?

(...)

> @@ -2529,6 +2642,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> =20
>  =09if (vcpu->kvm->arch.use_cmma)
>  =09=09kvm_s390_vcpu_unsetup_cmma(vcpu);
> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
> +=09    kvm_s390_pv_handle_cpu(vcpu))

I was a bit confused by that function name... maybe
kvm_s390_pv_cpu_get_handle()?

Also, if this always returns 0 if the config option is off, you
probably don't need to check for that option?

> +=09=09kvm_s390_pv_destroy_cpu(vcpu);
>  =09free_page((unsigned long)(vcpu->arch.sie_block));
> =20
>  =09kvm_vcpu_uninit(vcpu);
> @@ -2555,8 +2671,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>  =09kvm_free_vcpus(kvm);
>  =09sca_dispose(kvm);
> -=09debug_unregister(kvm->arch.dbf);
>  =09kvm_s390_gisa_destroy(kvm);
> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
> +=09    kvm_s390_pv_is_protected(kvm)) {
> +=09=09kvm_s390_pv_destroy_vm(kvm);
> +=09=09kvm_s390_pv_dealloc_vm(kvm);

It seems the pv vm can be either destroyed via the ioctl above or in
the course of normal vm destruction. When is which way supposed to be
used? Also, it seems kvm_s390_pv_destroy_vm() can fail -- can that be a
problem in this code path?

> +=09}
> +=09debug_unregister(kvm->arch.dbf);
>  =09free_page((unsigned long)kvm->arch.sie_page2);
>  =09if (!kvm_is_ucontrol(kvm))
>  =09=09gmap_remove(kvm->arch.gmap);

(...)

> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 6d9448dbd052..0d61dcc51f0e 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -196,6 +196,53 @@ static inline int kvm_s390_user_cpu_state_ctrl(struc=
t kvm *kvm)
>  =09return kvm->arch.user_cpu_state_ctrl !=3D 0;
>  }
> =20
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +/* implemented in pv.c */
> +void kvm_s390_pv_unpin(struct kvm *kvm);
> +void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
> +int kvm_s390_pv_alloc_vm(struct kvm *kvm);
> +int kvm_s390_pv_create_vm(struct kvm *kvm);
> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu);
> +int kvm_s390_pv_destroy_vm(struct kvm *kvm);
> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu);
> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length);
> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned lon=
g size,
> +=09=09       unsigned long tweak);
> +int kvm_s390_pv_verify(struct kvm *kvm);
> +
> +static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
> +{
> +=09return !!kvm->arch.pv.handle;
> +}
> +
> +static inline u64 kvm_s390_pv_handle(struct kvm *kvm)

This function name is less confusing than the one below, but maybe also
rename this to kvm_s390_pv_get_handle() for consistency?

> +{
> +=09return kvm->arch.pv.handle;
> +}
> +
> +static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu)
> +{
> +=09return vcpu->arch.pv.handle;
> +}
> +#else
> +static inline void kvm_s390_pv_unpin(struct kvm *kvm) {}
> +static inline void kvm_s390_pv_dealloc_vm(struct kvm *kvm) {}
> +static inline int kvm_s390_pv_alloc_vm(struct kvm *kvm) { return 0; }
> +static inline int kvm_s390_pv_create_vm(struct kvm *kvm) { return 0; }
> +static inline int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu) { return=
 0; }
> +static inline int kvm_s390_pv_destroy_vm(struct kvm *kvm) { return 0; }
> +static inline int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu) { retur=
n 0; }
> +static inline int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
> +=09=09=09=09=09    u64 origin, u64 length) { return 0; }
> +static inline int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr=
,
> +=09=09=09=09     unsigned long size,  unsigned long tweak)
> +{ return 0; }
> +static inline int kvm_s390_pv_verify(struct kvm *kvm) { return 0; }
> +static inline bool kvm_s390_pv_is_protected(struct kvm *kvm) { return 0;=
 }
> +static inline u64 kvm_s390_pv_handle(struct kvm *kvm) { return 0; }
> +static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu) { return=
 0; }
> +#endif
> +
>  /* implemented in interrupt.c */
>  int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
>  void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);

(...)

> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
> +{
> +=09int rc;
> +=09struct uv_cb_csc uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_CREATE_SEC_CPU,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09};
> +
> +=09/* EEXIST and ENOENT? */

?

> +=09if (kvm_s390_pv_handle_cpu(vcpu))
> +=09=09return -EINVAL;
> +
> +=09vcpu->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL,
> +=09=09=09=09=09=09   get_order(uv_info.guest_cpu_stor_len));
> +=09if (!vcpu->arch.pv.stor_base)
> +=09=09return -ENOMEM;
> +
> +=09/* Input */
> +=09uvcb.guest_handle =3D kvm_s390_pv_handle(vcpu->kvm);
> +=09uvcb.num =3D vcpu->arch.sie_block->icpua;
> +=09uvcb.state_origin =3D (u64)vcpu->arch.sie_block;
> +=09uvcb.stor_origin =3D (u64)vcpu->arch.pv.stor_base;
> +
> +=09rc =3D uv_call(0, (u64)&uvcb);
> +=09VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x r=
rc %x",
> +=09=09   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
> +=09=09   uvcb.header.rrc);
> +
> +=09/* Output */
> +=09vcpu->arch.pv.handle =3D uvcb.cpu_handle;
> +=09vcpu->arch.sie_block->pv_handle_cpu =3D uvcb.cpu_handle;
> +=09vcpu->arch.sie_block->pv_handle_config =3D kvm_s390_pv_handle(vcpu->k=
vm);
> +=09vcpu->arch.sie_block->sdf =3D 2;
> +=09if (!rc)
> +=09=09return 0;
> +
> +=09kvm_s390_pv_destroy_cpu(vcpu);
> +=09return -EINVAL;
> +}

(...)

Only a quick readthrough, as this patch is longish.

