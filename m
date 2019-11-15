Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A53FD96A
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 10:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKOJgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 04:36:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60513 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725829AbfKOJgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 04:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573810614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1K0N5EtXLNsgdWi2VFMHeVE8x/kum7atoFT8YmihZjI=;
        b=aK+vxwe2zY1lWTDhbCh9V7g2pTZT0D8PUoH4DQ/l68nlqkd3MpH6AJ/vqpa4wJ3blOfQHz
        C/eNklpprg9iP8pIMkvxPSGURJ6EQNyo8jmba6J23lKx2Jr+EF/f3f+oaTKvjE8t7UFNOq
        eoGvztPwhrr5BnriP/9EWqJosPICKAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-mcOA3YeOO2W-DUdPppWtFQ-1; Fri, 15 Nov 2019 04:36:51 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8EB018B9FCC;
        Fri, 15 Nov 2019 09:36:49 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCDEA1B2E7;
        Fri, 15 Nov 2019 09:36:43 +0000 (UTC)
Subject: Re: [RFC 29/37] KVM: s390: protvirt: Sync pv state
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-30-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e60f6e74-2d0f-36a8-cde7-1b6054370ba8@redhat.com>
Date:   Fri, 15 Nov 2019 10:36:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-30-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: mcOA3YeOO2W-DUdPppWtFQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Indicate via register sync if the VM is in secure mode.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/uapi/asm/kvm.h | 5 ++++-
>  arch/s390/kvm/kvm-s390.c         | 7 ++++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/as=
m/kvm.h
> index 436ec7636927..b44c02426c2e 100644
> --- a/arch/s390/include/uapi/asm/kvm.h
> +++ b/arch/s390/include/uapi/asm/kvm.h
> @@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
>  #define KVM_SYNC_GSCB   (1UL << 9)
>  #define KVM_SYNC_BPBC   (1UL << 10)
>  #define KVM_SYNC_ETOKEN (1UL << 11)
> +#define KVM_SYNC_PV=09(1UL << 12)
> =20
>  #define KVM_SYNC_S390_VALID_FIELDS \
>  =09(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
>  =09 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
> -=09 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
> +=09 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \
> +=09 KVM_SYNC_PV)
> =20
>  /* length and alignment of the sdnx as a power of two */
>  #define SDNXC 8
> @@ -261,6 +263,7 @@ struct kvm_sync_regs {
>  =09__u8  reserved[512];=09/* for future vector expansion */
>  =09__u32 fpc;=09=09/* valid on KVM_SYNC_VRS or KVM_SYNC_FPRS */
>  =09__u8 bpbc : 1;=09=09/* bp mode */
> +=09__u8 pv : 1;=09=09/* pv mode */
>  =09__u8 reserved2 : 7;

Don't you want to decrease the reserved2 bits to 6 ? ...

>  =09__u8 padding1[51];=09/* riccb needs to be 64byte aligned */

... otherwise you might mess up the alignment here!

>  =09__u8 riccb[64];=09=09/* runtime instrumentation controls block */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index f623c64aeade..500972a1f742 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2856,6 +2856,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  =09=09vcpu->run->kvm_valid_regs |=3D KVM_SYNC_GSCB;
>  =09if (test_kvm_facility(vcpu->kvm, 156))
>  =09=09vcpu->run->kvm_valid_regs |=3D KVM_SYNC_ETOKEN;
> +=09if (test_kvm_facility(vcpu->kvm, 161))
> +=09=09vcpu->run->kvm_valid_regs |=3D KVM_SYNC_PV;
>  =09/* fprs can be synchronized via vrs, even if the guest has no vx. Wit=
h
>  =09 * MACHINE_HAS_VX, (load|store)_fpu_regs() will work with vrs format.
>  =09 */
> @@ -4136,6 +4138,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu, =
struct kvm_run *kvm_run)
>  {
>  =09kvm_run->s.regs.gbea =3D vcpu->arch.sie_block->gbea;
>  =09kvm_run->s.regs.bpbc =3D (vcpu->arch.sie_block->fpf & FPF_BPBC) =3D=
=3D FPF_BPBC;
> +=09kvm_run->s.regs.pv =3D 0;
>  =09if (MACHINE_HAS_GS) {
>  =09=09__ctl_set_bit(2, 4);
>  =09=09if (vcpu->arch.gs_enabled)
> @@ -4172,8 +4175,10 @@ static void store_regs(struct kvm_vcpu *vcpu, stru=
ct kvm_run *kvm_run)
>  =09/* Restore will be done lazily at return */
>  =09current->thread.fpu.fpc =3D vcpu->arch.host_fpregs.fpc;
>  =09current->thread.fpu.regs =3D vcpu->arch.host_fpregs.regs;
> -=09if (likely(!kvm_s390_pv_is_protected(vcpu->kvm)))
> +=09if (likely(!kvm_s390_pv_handle_cpu(vcpu)))

Why change the if-statement now? Should this maybe rather be squashed
into the patch that introduced the if-statement?

>  =09=09store_regs_fmt2(vcpu, kvm_run);
> +=09else
> +=09=09kvm_run->s.regs.pv =3D 1;
>  }
> =20
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_r=
un)
>=20

 Thomas

