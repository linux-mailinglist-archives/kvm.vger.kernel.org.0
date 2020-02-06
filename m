Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0661541F1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 11:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgBFKdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 05:33:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728261AbgBFKdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 05:33:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580985179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=hXG5Gyhg6oXEM4j7a2h5D7Ellay2evtCfvJQJgbN0Xs=;
        b=QLFIkjuEaRRM8/YoCw+adFwdC3ibQBzQmMSR1cWYLAwHPyKoPAz6EM4GRLI8yReiZE0eq7
        4QgIbxfpqz7Eiu/V0q095duzP6QSDfQYbWDqLtcFK0u6JCVNGW9S5QW7FHNCWkzu1YX+5B
        vqa0godf3OTlr7Bv0nP172d2urJIoTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-7MzDIo0LO_SJOh-svuhQGA-1; Thu, 06 Feb 2020 05:32:55 -0500
X-MC-Unique: 7MzDIo0LO_SJOh-svuhQGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B3E5802726;
        Thu,  6 Feb 2020 10:32:54 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-151.ams2.redhat.com [10.36.116.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C29D90060;
        Thu,  6 Feb 2020 10:32:49 +0000 (UTC)
Subject: Re: [RFCv2.1] KVM: S390: protvirt: Introduce instruction data area
 bounce buffer
To:     Christian Borntraeger <borntraeger@de.ibm.com>, david@redhat.com
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com, cohuck@redhat.com,
        frankja@linux.ibm.com, frankja@linux.vnet.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org
References: <4508d11e-455e-1496-f4a3-5a9c994a9126@redhat.com>
 <20200206093907.5784-1-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <6a6bda5f-a432-e0b1-6f74-3f916d7ec9a0@redhat.com>
Date:   Thu, 6 Feb 2020 11:32:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200206093907.5784-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/02/2020 10.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
>=20
> Now that we can't access guest memory anymore, we have a dedicated
> sattelite block that's a bounce buffer for instruction data.

s/sattelite/satellite/

> We re-use the memop interface to copy the instruction data to / from
> userspace. This lets us re-use a lot of QEMU code which used that
> interface to make logical guest memory accesses which are not possible
> anymore in protected mode anyway.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 11 ++++++-
>  arch/s390/kvm/kvm-s390.c         | 49 ++++++++++++++++++++++++++++++++
>  arch/s390/kvm/pv.c               |  9 ++++++
>  include/uapi/linux/kvm.h         | 10 +++++--
>  4 files changed, 76 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/k=
vm_host.h
> index 9d7b248dcadc..2fe8d3c81951 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -127,6 +127,12 @@ struct mcck_volatile_info {
>  #define CR14_INITIAL_MASK (CR14_UNUSED_32 | CR14_UNUSED_33 | \
>  			   CR14_EXTERNAL_DAMAGE_SUBMASK)
> =20
> +#define SIDAD_SIZE_MASK		0xff
> +#define sida_origin(sie_block) \
> +	(sie_block->sidad & PAGE_MASK)
> +#define sida_size(sie_block) \
> +	(((sie_block->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
> +
>  #define CPUSTAT_STOPPED    0x80000000
>  #define CPUSTAT_WAIT       0x10000000
>  #define CPUSTAT_ECALL_PEND 0x08000000
> @@ -315,7 +321,10 @@ struct kvm_s390_sie_block {
>  #define CRYCB_FORMAT2 0x00000003
>  	__u32	crycbd;			/* 0x00fc */
>  	__u64	gcr[16];		/* 0x0100 */
> -	__u64	gbea;			/* 0x0180 */
> +	union {
> +		__u64	gbea;			/* 0x0180 */

Maybe adjust the spaces before the comment.

> +		__u64	sidad;
> +	};
>  	__u8    reserved188[8];		/* 0x0188 */
>  	__u64   sdnxo;			/* 0x0190 */
>  	__u8    reserved198[8];		/* 0x0198 */
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6f90d16cad92..56488f9ed190 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4435,6 +4435,41 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_=
vcpu *vcpu,
>  	return r;
>  }
> =20
> +static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
> +				   struct kvm_s390_mem_op *mop)
> +{
> +	void __user *uaddr =3D (void __user *)mop->buf;
> +	int r =3D 0;
> +
> +	if (mop->flags || !mop->size)
> +		return -EINVAL;
> +
> +	if (mop->size > sida_size(vcpu->arch.sie_block))
> +		return -E2BIG;
> +
> +	if (mop->sida_offset > sida_size(vcpu->arch.sie_block))
> +		return -E2BIG;
> +
> +	if (mop->size + mop->sida_offset > sida_size(vcpu->arch.sie_block))
> +		return -E2BIG;
> +
> +	switch (mop->op) {
> +	case KVM_S390_MEMOP_SIDA_READ:
> +		r =3D 0;

r is alread pre-initialized with 0 where it is declared, so you could
remove the above line.

> +		if (copy_to_user(uaddr, (void *)(sida_origin(vcpu->arch.sie_block) +
> +				 mop->sida_offset), mop->size))
> +			r =3D -EFAULT;
> +
> +		break;
> +	case KVM_S390_MEMOP_SIDA_WRITE:
> +		r =3D 0;

dito.

> +		if (copy_from_user((void *)(sida_origin(vcpu->arch.sie_block) +
> +				   mop->sida_offset), uaddr, mop->size))
> +			r =3D -EFAULT;
> +		break;
> +	}
> +	return r;
> +}
>  static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
>  				  struct kvm_s390_mem_op *mop)
>  {
> @@ -4444,6 +4479,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu=
 *vcpu,
>  	const u64 supported_flags =3D KVM_S390_MEMOP_F_INJECT_EXCEPTION
>  				    | KVM_S390_MEMOP_F_CHECK_ONLY;
> =20
> +
> +	BUILD_BUG_ON(sizeof(*mop) !=3D 64);
>  	if (mop->flags & ~supported_flags || mop->ar >=3D NUM_ACRS || !mop->s=
ize)
>  		return -EINVAL;
> =20
> @@ -4460,6 +4497,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcp=
u *vcpu,
> =20
>  	switch (mop->op) {
>  	case KVM_S390_MEMOP_LOGICAL_READ:
> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			r =3D -EINVAL;
> +			break;
> +		}
>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>  			r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
>  					    mop->size, GACC_FETCH);
> @@ -4472,6 +4513,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcp=
u *vcpu,
>  		}
>  		break;
>  	case KVM_S390_MEMOP_LOGICAL_WRITE:
> +		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> +			r =3D -EINVAL;
> +			break;
> +		}
>  		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
>  			r =3D check_gva_range(vcpu, mop->gaddr, mop->ar,
>  					    mop->size, GACC_STORE);
> @@ -4483,6 +4528,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcp=
u *vcpu,
>  		}
>  		r =3D write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
>  		break;
> +	case KVM_S390_MEMOP_SIDA_READ:
> +	case KVM_S390_MEMOP_SIDA_WRITE:
> +		r =3D kvm_s390_guest_sida_op(vcpu, mop);
> +		break;
>  	default:
>  		r =3D -EINVAL;
>  	}
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 05e5ca8eab4f..d6345a0e348c 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -93,6 +93,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
> =20
>  	free_pages(vcpu->arch.pv.stor_base,
>  		   get_order(uv_info.guest_cpu_stor_len));
> +	free_page(sida_origin(vcpu->arch.sie_block));
>  	vcpu->arch.sie_block->pv_handle_cpu =3D 0;
>  	vcpu->arch.sie_block->pv_handle_config =3D 0;
>  	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
> @@ -122,6 +123,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
>  	uvcb.state_origin =3D (u64)vcpu->arch.sie_block;
>  	uvcb.stor_origin =3D (u64)vcpu->arch.pv.stor_base;
> =20
> +	/* Alloc Secure Instruction Data Area Designation */
> +	vcpu->arch.sie_block->sidad =3D __get_free_page(GFP_KERNEL | __GFP_ZE=
RO);
> +	if (!vcpu->arch.sie_block->sidad) {
> +		free_pages(vcpu->arch.pv.stor_base,
> +			   get_order(uv_info.guest_cpu_stor_len));
> +		return -ENOMEM;
> +	}
> +
>  	rc =3D uv_call(0, (u64)&uvcb);
>  	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x r=
rc %x",
>  		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index eab741bc12c3..a772771baf9f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -466,7 +466,7 @@ struct kvm_translation {
>  	__u8  pad[5];
>  };
> =20
> -/* for KVM_S390_MEM_OP */
> +/* for KVM_S390_MEM_OP and KVM_S390_SIDA_OP */

Remove this change now, please.

>  struct kvm_s390_mem_op {
>  	/* in */
>  	__u64 gaddr;		/* the guest address */
> @@ -475,11 +475,17 @@ struct kvm_s390_mem_op {
>  	__u32 op;		/* type of operation */
>  	__u64 buf;		/* buffer in userspace */
>  	__u8 ar;		/* the access register number */
> -	__u8 reserved[31];	/* should be set to 0 */
> +	__u8 reserved21[3];	/* should be set to 0 */
> +	__u32 sida_offset;	/* offset into the sida */
> +	__u8 reserved28[24];	/* should be set to 0 */
>  };
> +
> +
>  /* types for kvm_s390_mem_op->op */
>  #define KVM_S390_MEMOP_LOGICAL_READ	0
>  #define KVM_S390_MEMOP_LOGICAL_WRITE	1
> +#define KVM_S390_MEMOP_SIDA_READ	2
> +#define KVM_S390_MEMOP_SIDA_WRITE	3
>  /* flags for kvm_s390_mem_op->flags */
>  #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
>  #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)

With the nits fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>

