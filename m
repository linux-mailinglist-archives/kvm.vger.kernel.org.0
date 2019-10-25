Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C306E4673
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438227AbfJYI6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:58:45 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438224AbfJYI6p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 04:58:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571993923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M41G2w+O8Mx0UQQ4bIwvciBHKxnAcQr7Ku4dej0H6Xw=;
        b=Qnrsl1ZV67m88M+7wl8cTouhKt/i8DBkBkJHBgx/dwPIIs6KJI27LCGzcFtI7++gvvFDWf
        5R11KBtTtEfQawnutZ93Hj5AVOru/aGig2Pxb57/fTOXKhEFk78NAsYzQhoW9smZljb2kf
        s22A8nD5LdXo2r6hx7zxksg9ytgMSkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-sQUUiYnqO5W0gApkOIlb6g-1; Fri, 25 Oct 2019 04:58:40 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3892E100551F;
        Fri, 25 Oct 2019 08:58:39 +0000 (UTC)
Received: from [10.36.116.205] (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0540510027A4;
        Fri, 25 Oct 2019 08:58:36 +0000 (UTC)
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-5-frankja@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <1e698aca-8d5d-ef0a-02bf-75b35a168755@redhat.com>
Date:   Fri, 25 Oct 2019 10:58:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-5-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: sQUUiYnqO5W0gApkOIlb6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.19 13:40, Janosch Frank wrote:
> Let's add a KVM interface to create and destroy protected VMs.

More details please.

[...]

>  =20
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

So ... I can create multiple VMs?

Especially, I can call KVM_PV_VM_CREATE two times, setting=20
"kvm->arch.pv.stor_var =3D NULL and leaking memory" on the second call.=20
Not sure if that's desirable.


Shouldn't this be something like "KVM_PV_VM_INIT" and then make sure it=20
can only be called once?

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

Then please verify that? "KVM_PV_VM_DEINIT"

Also, who guarantees that user space calls this at all? Why is that=20
needed? (IOW, when does user space call this?)

> +=09=09mutex_lock(&kvm->lock);
> +=09=09kvm_s390_vcpu_block_all(kvm);
> +=09=09r =3D kvm_s390_pv_destroy_vm(kvm);
> +=09=09if (!r)
> +=09=09=09kvm_s390_pv_dealloc_vm(kvm);
> +=09=09kvm_s390_vcpu_unblock_all(kvm);
> +=09=09mutex_unlock(&kvm->lock);
> +=09=09break;
> +=09}
> +=09case KVM_PV_VM_SET_SEC_PARMS: {
> +=09=09struct kvm_s390_pv_sec_parm parms =3D {};
> +=09=09void *hdr;
> +
> +=09=09r =3D -EFAULT;
> +=09=09if (copy_from_user(&parms, argp, sizeof(parms)))
> +=09=09=09break;
> +
> +=09=09/* Currently restricted to 8KB */
> +=09=09r =3D -EINVAL;
> +=09=09if (parms.length > PAGE_SIZE * 2)
> +=09=09=09break;
> +
> +=09=09r =3D -ENOMEM;
> +=09=09hdr =3D vmalloc(parms.length);
> +=09=09if (!hdr)
> +=09=09=09break;
> +
> +=09=09r =3D -EFAULT;
> +=09=09if (!copy_from_user(hdr, (void __user *)parms.origin,
> +=09=09=09=09   parms.length))
> +=09=09=09r =3D kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length);
> +
> +=09=09vfree(hdr);
> +=09=09break;
> +=09}
> +=09case KVM_PV_VM_UNPACK: {
> +=09=09struct kvm_s390_pv_unp unp =3D {};
> +
> +=09=09r =3D -EFAULT;
> +=09=09if (copy_from_user(&unp, argp, sizeof(unp)))
> +=09=09=09break;
> +
> +=09=09r =3D kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak);
> +=09=09break;
> +=09}
> +=09case KVM_PV_VM_VERIFY: {
> +=09=09u32 ret;
> +
> +=09=09r =3D -EINVAL;
> +=09=09if (!kvm_s390_pv_is_protected(kvm))
> +=09=09=09break;
> +
> +=09=09r =3D uv_cmd_nodata(kvm_s390_pv_handle(kvm),
> +=09=09=09=09  UVC_CMD_VERIFY_IMG,
> +=09=09=09=09  &ret);
> +=09=09VM_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x",
> +=09=09=09 ret >> 16, ret & 0x0000ffff);
> +=09=09break;
> +=09}
> +=09default:
> +=09=09return -ENOTTY;
> +=09}
> +=09return r;
> +}
> +#endif
> +
>   long kvm_arch_vm_ioctl(struct file *filp,
>   =09=09       unsigned int ioctl, unsigned long arg)
>   {
> @@ -2254,6 +2351,22 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   =09=09mutex_unlock(&kvm->slots_lock);
>   =09=09break;
>   =09}
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +=09case KVM_S390_PV_COMMAND: {
> +=09=09struct kvm_pv_cmd args;
> +
> +=09=09r =3D -EINVAL;
> +=09=09if (!is_prot_virt_host())
> +=09=09=09break;
> +
> +=09=09r =3D -EFAULT;
> +=09=09if (copy_from_user(&args, argp, sizeof(args)))
> +=09=09=09break;
> +
> +=09=09r =3D kvm_s390_handle_pv(kvm, &args);
> +=09=09break;
> +=09}
> +#endif
>   =09default:
>   =09=09r =3D -ENOTTY;
>   =09}
> @@ -2529,6 +2642,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  =20
>   =09if (vcpu->kvm->arch.use_cmma)
>   =09=09kvm_s390_vcpu_unsetup_cmma(vcpu);
> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
> +=09    kvm_s390_pv_handle_cpu(vcpu))
> +=09=09kvm_s390_pv_destroy_cpu(vcpu);
>   =09free_page((unsigned long)(vcpu->arch.sie_block));
>  =20
>   =09kvm_vcpu_uninit(vcpu);
> @@ -2555,8 +2671,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   {
>   =09kvm_free_vcpus(kvm);
>   =09sca_dispose(kvm);
> -=09debug_unregister(kvm->arch.dbf);
>   =09kvm_s390_gisa_destroy(kvm);
> +=09if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
> +=09    kvm_s390_pv_is_protected(kvm)) {
> +=09=09kvm_s390_pv_destroy_vm(kvm);
> +=09=09kvm_s390_pv_dealloc_vm(kvm);
> +=09}
> +=09debug_unregister(kvm->arch.dbf);
>   =09free_page((unsigned long)kvm->arch.sie_page2);
>   =09if (!kvm_is_ucontrol(kvm))
>   =09=09gmap_remove(kvm->arch.gmap);
> @@ -2652,6 +2773,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
>   =09unsigned int vcpu_idx;
>   =09u32 scaol, scaoh;
>  =20
> +=09if (kvm->arch.use_esca)
> +=09=09return 0;
> +
>   =09new_sca =3D alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZER=
O);
>   =09if (!new_sca)
>   =09=09return -ENOMEM;
> @@ -3073,6 +3197,15 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *=
kvm,
>   =09rc =3D kvm_vcpu_init(vcpu, kvm, id);
>   =09if (rc)
>   =09=09goto out_free_sie_block;
> +
> +=09if (kvm_s390_pv_is_protected(kvm)) {
> +=09=09rc =3D kvm_s390_pv_create_cpu(vcpu);
> +=09=09if (rc) {
> +=09=09=09kvm_vcpu_uninit(vcpu);
> +=09=09=09goto out_free_sie_block;
> +=09=09}
> +=09}
> +
>   =09VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, v=
cpu,
>   =09=09 vcpu->arch.sie_block);
>   =09trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
> @@ -4338,6 +4471,28 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
>   =09return -ENOIOCTLCMD;
>   }
>  =20
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
> +=09=09=09=09   struct kvm_pv_cmd *cmd)
> +{
> +=09int r =3D 0;
> +
> +=09switch (cmd->cmd) {
> +=09case KVM_PV_VCPU_CREATE: {
> +=09=09r =3D kvm_s390_pv_create_cpu(vcpu);
> +=09=09break;
> +=09}
> +=09case KVM_PV_VCPU_DESTROY: {
> +=09=09r =3D kvm_s390_pv_destroy_cpu(vcpu);
> +=09=09break;
> +=09}
> +=09default:
> +=09=09r =3D -ENOTTY;
> +=09}
> +=09return r;
> +}
> +#endif
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   =09=09=09 unsigned int ioctl, unsigned long arg)
>   {
> @@ -4470,6 +4625,22 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   =09=09=09=09=09   irq_state.len);
>   =09=09break;
>   =09}
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +=09case KVM_S390_PV_COMMAND_VCPU: {
> +=09=09struct kvm_pv_cmd args;
> +
> +=09=09r =3D -EINVAL;
> +=09=09if (!is_prot_virt_host())
> +=09=09=09break;
> +
> +=09=09r =3D -EFAULT;
> +=09=09if (copy_from_user(&args, argp, sizeof(args)))
> +=09=09=09break;
> +
> +=09=09r =3D kvm_s390_handle_pv_vcpu(vcpu, &args);
> +=09=09break;
> +=09}
> +#endif
>   =09default:
>   =09=09r =3D -ENOTTY;
>   =09}
> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
> index 6d9448dbd052..0d61dcc51f0e 100644
> --- a/arch/s390/kvm/kvm-s390.h
> +++ b/arch/s390/kvm/kvm-s390.h
> @@ -196,6 +196,53 @@ static inline int kvm_s390_user_cpu_state_ctrl(struc=
t kvm *kvm)
>   =09return kvm->arch.user_cpu_state_ctrl !=3D 0;
>   }
>  =20
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
>   /* implemented in interrupt.c */
>   int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
>   void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> new file mode 100644
> index 000000000000..94cf16f40f25
> --- /dev/null
> +++ b/arch/s390/kvm/pv.c
> @@ -0,0 +1,237 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hosting Secure Execution virtual machines
> + *
> + * Copyright IBM Corp. 2019
> + *    Author(s): Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/pagemap.h>
> +#include <asm/pgalloc.h>
> +#include <asm/gmap.h>
> +#include <asm/uv.h>
> +#include <asm/gmap.h>
> +#include <asm/mman.h>
> +#include "kvm-s390.h"
> +
> +void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
> +{
> +=09vfree(kvm->arch.pv.stor_var);
> +=09free_pages(kvm->arch.pv.stor_base,
> +=09=09   get_order(uv_info.guest_base_stor_len));
> +=09memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
> +}
> +
> +int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> +{
> +=09unsigned long base =3D uv_info.guest_base_stor_len;
> +=09unsigned long virt =3D uv_info.guest_virt_var_stor_len;
> +=09unsigned long npages =3D 0, vlen =3D 0;
> +=09struct kvm_memslots *slots;
> +=09struct kvm_memory_slot *memslot;
> +
> +=09kvm->arch.pv.stor_var =3D NULL;
> +=09kvm->arch.pv.stor_base =3D __get_free_pages(GFP_KERNEL, get_order(bas=
e));
> +=09if (!kvm->arch.pv.stor_base)
> +=09=09return -ENOMEM;
> +
> +=09/*
> +=09 * Calculate current guest storage for allocation of the
> +=09 * variable storage, which is based on the length in MB.
> +=09 *
> +=09 * Slots are sorted by GFN
> +=09 */
> +=09mutex_lock(&kvm->slots_lock);
> +=09slots =3D kvm_memslots(kvm);
> +=09memslot =3D slots->memslots;
> +=09npages =3D memslot->base_gfn + memslot->npages;

What if

a) your guest has multiple memory slots
b) you hotplug memory and add memslots later

Do you dence that, and if so, how?

> +
> +=09mutex_unlock(&kvm->slots_lock);
> +=09kvm->arch.pv.guest_len =3D npages * PAGE_SIZE;
> +
> +=09/* Allocate variable storage */
> +=09vlen =3D ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE)=
;

I get the feeling that prot virt mainly consumes memory ;)

> +=09vlen +=3D uv_info.guest_virt_base_stor_len;
> +=09kvm->arch.pv.stor_var =3D vzalloc(vlen);
> +=09if (!kvm->arch.pv.stor_var) {
> +=09=09kvm_s390_pv_dealloc_vm(kvm);
> +=09=09return -ENOMEM;
> +=09}
> +=09return 0;
> +}
> +
> +int kvm_s390_pv_destroy_vm(struct kvm *kvm)
> +{
> +=09int rc;
> +=09u32 ret;
> +
> +=09rc =3D uv_cmd_nodata(kvm_s390_pv_handle(kvm),
> +=09=09=09   UVC_CMD_DESTROY_SEC_CONF, &ret);
> +=09VM_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
> +=09=09 ret >> 16, ret & 0x0000ffff);
> +=09return rc;
> +}
> +
> +int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
> +{
> +=09int rc =3D 0;
> +=09u32 ret;
> +
> +=09if (kvm_s390_pv_handle_cpu(vcpu)) {
> +=09=09rc =3D uv_cmd_nodata(kvm_s390_pv_handle_cpu(vcpu),
> +=09=09=09=09   UVC_CMD_DESTROY_SEC_CPU,
> +=09=09=09=09   &ret);
> +
> +=09=09VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
> +=09=09=09   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
> +=09}
> +
> +=09free_pages(vcpu->arch.pv.stor_base,
> +=09=09   get_order(uv_info.guest_cpu_stor_len));
> +=09/* Clear cpu and vm handle */
> +=09memset(&vcpu->arch.sie_block->reserved10, 0,
> +=09       sizeof(vcpu->arch.sie_block->reserved10));
> +=09memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
> +=09vcpu->arch.sie_block->sdf =3D 0;
> +=09return rc;
> +}
> +
> +int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
> +{
> +=09int rc;
> +=09struct uv_cb_csc uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_CREATE_SEC_CPU,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09};
> +
> +=09/* EEXIST and ENOENT? */
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
> +
> +int kvm_s390_pv_create_vm(struct kvm *kvm)
> +{
> +=09int rc;
> +
> +=09struct uv_cb_cgc uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_CREATE_SEC_CONF,
> +=09=09.header.len =3D sizeof(uvcb)
> +=09};
> +
> +=09if (kvm_s390_pv_handle(kvm))
> +=09=09return -EINVAL;
> +
> +=09/* Inputs */
> +=09uvcb.guest_stor_origin =3D 0; /* MSO is 0 for KVM */
> +=09uvcb.guest_stor_len =3D kvm->arch.pv.guest_len;
> +=09uvcb.guest_asce =3D kvm->arch.gmap->asce;
> +=09uvcb.conf_base_stor_origin =3D (u64)kvm->arch.pv.stor_base;
> +=09uvcb.conf_var_stor_origin =3D (u64)kvm->arch.pv.stor_var;
> +
> +=09rc =3D uv_call(0, (u64)&uvcb);
> +=09VM_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc =
%x",
> +=09=09 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
> +=09=09 uvcb.header.rrc);
> +
> +=09/* Outputs */
> +=09kvm->arch.pv.handle =3D uvcb.guest_handle;
> +
> +=09if (rc && (uvcb.header.rc & 0x8000)) {
> +=09=09kvm_s390_pv_destroy_vm(kvm);
> +=09=09kvm_s390_pv_dealloc_vm(kvm);
> +=09=09return -EINVAL;
> +=09}
> +=09return rc;
> +}
> +
> +int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
> +=09=09=09      void *hdr, u64 length)
> +{
> +=09int rc;
> +=09struct uv_cb_ssc uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_SET_SEC_CONF_PARAMS,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.sec_header_origin =3D (u64)hdr,
> +=09=09.sec_header_len =3D length,
> +=09=09.guest_handle =3D kvm_s390_pv_handle(kvm),
> +=09};
> +
> +=09if (!kvm_s390_pv_handle(kvm))
> +=09=09return -EINVAL;
> +
> +=09rc =3D uv_call(0, (u64)&uvcb);
> +=09VM_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
> +=09=09 uvcb.header.rc, uvcb.header.rrc);
> +=09if (rc)
> +=09=09return -EINVAL;
> +=09return 0;
> +}
> +
> +int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned lon=
g size,
> +=09=09       unsigned long tweak)
> +{
> +=09int i, rc =3D 0;
> +=09struct uv_cb_unp uvcb =3D {
> +=09=09.header.cmd =3D UVC_CMD_UNPACK_IMG,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.guest_handle =3D kvm_s390_pv_handle(kvm),
> +=09=09.tweak[0] =3D tweak
> +=09};
> +
> +=09if (addr & ~PAGE_MASK || size & ~PAGE_MASK)
> +=09=09return -EINVAL;
> +
> +
> +=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: start addr %lx size %lx",
> +=09=09 addr, size);
> +=09for (i =3D 0; i < size / PAGE_SIZE; i++) {
> +=09=09uvcb.gaddr =3D addr + i * PAGE_SIZE;
> +=09=09uvcb.tweak[1] =3D i * PAGE_SIZE;
> +retry:
> +=09=09rc =3D uv_call(0, (u64)&uvcb);
> +=09=09if (!rc)
> +=09=09=09continue;
> +=09=09/* If not yet mapped fault and retry */
> +=09=09if (uvcb.header.rc =3D=3D 0x10a) {
> +=09=09=09rc =3D gmap_fault(kvm->arch.gmap, uvcb.gaddr,
> +=09=09=09=09=09FAULT_FLAG_WRITE);
> +=09=09=09if (rc)
> +=09=09=09=09return rc;
> +=09=09=09goto retry;
> +=09=09}
> +=09=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: failed addr %llx rc %x rrc %=
x",
> +=09=09=09 uvcb.gaddr, uvcb.header.rc, uvcb.header.rrc);
> +=09=09break;
> +=09}
> +=09VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x rrc %x",
> +=09=09 uvcb.header.rc, uvcb.header.rrc);
> +=09return rc;
> +}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52641d8ca9e8..bb37d5710c89 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1000,6 +1000,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_PMU_EVENT_FILTER 173
>   #define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
>   #define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
> +#define KVM_CAP_S390_PROTECTED 180
>  =20
>   #ifdef KVM_CAP_IRQ_ROUTING
>  =20
> @@ -1461,6 +1462,38 @@ struct kvm_enc_region {
>   /* Available with KVM_CAP_ARM_SVE */
>   #define KVM_ARM_VCPU_FINALIZE=09  _IOW(KVMIO,  0xc2, int)
>  =20
> +struct kvm_s390_pv_sec_parm {
> +=09__u64=09origin;
> +=09__u64=09length;
> +};
> +
> +struct kvm_s390_pv_unp {
> +=09__u64 addr;
> +=09__u64 size;
> +=09__u64 tweak;
> +};
> +
> +enum pv_cmd_id {
> +=09KVM_PV_VM_CREATE,
> +=09KVM_PV_VM_DESTROY,
> +=09KVM_PV_VM_SET_SEC_PARMS,
> +=09KVM_PV_VM_UNPACK,
> +=09KVM_PV_VM_VERIFY,
> +=09KVM_PV_VCPU_CREATE,
> +=09KVM_PV_VCPU_DESTROY,
> +};
> +
> +struct kvm_pv_cmd {
> +=09__u32=09cmd;
> +=09__u16=09rc;
> +=09__u16=09rrc;
> +=09__u64=09data;
> +};
> +
> +/* Available with KVM_CAP_S390_SE */
> +#define KVM_S390_PV_COMMAND=09=09_IOW(KVMIO, 0xc3, struct kvm_pv_cmd)
> +#define KVM_S390_PV_COMMAND_VCPU=09_IOW(KVMIO, 0xc4, struct kvm_pv_cmd)
> +
>   /* Secure Encrypted Virtualization command */
>   enum sev_cmd_id {
>   =09/* Guest initialization commands */
>=20

This is a lengthy patch and I ahven't explored anything yet :)

I do wonder if it makes sense to split this up. VM, VCPUs, parameters,=20
Extract+verify ...

--=20

Thanks,

David / dhildenb

