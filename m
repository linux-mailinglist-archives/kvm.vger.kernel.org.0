Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F69F4D6B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 14:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfKHNoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 08:44:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34800 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726005AbfKHNoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 08:44:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573220654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXHxRCJ3JN8sb2Qs9lYmlT9pRr2Bjf+8AfwFMpZllcA=;
        b=Pkm0c6B82GzQ0GJ1hehcwP68ByVQaMQoVsLCS8C06zkh6R9fwxHF1uDOtH/j4BDSsmDJI3
        L6/UPMfb8PvLSRL8+IgfenBJmcb6NH3CJZn4jRethMSrOq8t+g+WuU5v1DqcaMjR/Rlmai
        /vpQp+q1eNefNudft0aT4cfbuYfZA1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-7391B91bOkC1fnfgKj05JA-1; Fri, 08 Nov 2019 08:44:11 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C4238017DE;
        Fri,  8 Nov 2019 13:44:10 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 277335DA7F;
        Fri,  8 Nov 2019 13:44:04 +0000 (UTC)
Subject: Re: [RFC 04/37] KVM: s390: protvirt: Add initial lifecycle handling
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <1ff4397e-04b6-1398-69bc-d6a5d085fcd7@redhat.com>
Date:   Fri, 8 Nov 2019 14:44:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-5-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 7391B91bOkC1fnfgKj05JA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Let's add a KVM interface to create and destroy protected VMs.

I agree with David, some more description here would be helpful.

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  24 +++-
>   arch/s390/include/asm/uv.h       | 110 ++++++++++++++
>   arch/s390/kvm/Makefile           |   2 +-
>   arch/s390/kvm/kvm-s390.c         | 173 +++++++++++++++++++++-
>   arch/s390/kvm/kvm-s390.h         |  47 ++++++
>   arch/s390/kvm/pv.c               | 237 +++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h         |  33 +++++
>   7 files changed, 622 insertions(+), 4 deletions(-)
>   create mode 100644 arch/s390/kvm/pv.c
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm=
_host.h
> index 02f4c21c57f6..d4fd0f3af676 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -155,7 +155,13 @@ struct kvm_s390_sie_block {
>   =09__u8=09reserved08[4];=09=09/* 0x0008 */
>   #define PROG_IN_SIE (1<<0)
>   =09__u32=09prog0c;=09=09=09/* 0x000c */
> -=09__u8=09reserved10[16];=09=09/* 0x0010 */
> +=09union {
> +=09=09__u8=09reserved10[16];=09=09/* 0x0010 */
> +=09=09struct {
> +=09=09=09__u64=09pv_handle_cpu;
> +=09=09=09__u64=09pv_handle_config;
> +=09=09};
> +=09};

Why do you need to keep reserved10[] here? Simply replace it with the=20
two new fields, and get rid of the union?


> +/*
> + * Generic cmd executor for calls that only transport the cpu or guest
> + * handle and the command.
> + */
> +static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret)
> +{
> +=09int rc;
> +=09struct uv_cb_nodata uvcb =3D {
> +=09=09.header.cmd =3D cmd,
> +=09=09.header.len =3D sizeof(uvcb),
> +=09=09.handle =3D handle,
> +=09};
> +
> +=09WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);

If this is not supposed to happen, I thing you should return here=20
instead of doing the uv_call() below?
Or maybe even turn this into a BUG() statement?

> +=09rc =3D uv_call(0, (u64)&uvcb);
> +=09if (ret)
> +=09=09*ret =3D *(u32 *)&uvcb.header.rc;
> +=09return rc ? -EINVAL : 0;
> +}
[...]
> @@ -2157,6 +2164,96 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
>   =09return r;
>   }
>  =20
> +#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
> +static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
> +{
> +=09int r =3D 0;
> +=09void __user *argp =3D (void __user *)cmd->data;
> +
> +=09switch (cmd->cmd) {

Why are you using curly braces for the case statements below? They do=20
not seem to be necessary in most cases?

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

I think you should also check fr parms.length =3D=3D 0 ... otherwise you'll=
=20
get an unfriendly complaint from vmalloc().

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

Is ENOTTY the right thing to return for an invalid cmd here? It might=20
get confused with the ioctl not being available at all? Maybe EINVAL=20
would be better?

> +=09}
> +=09return r;
> +}
> +#endif
> +
[...]
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

Also no need for the curly braces of the case statements here?

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

Or EINVAL?

> +=09}
> +=09return r;
> +}
> +#endif

  Thomas

