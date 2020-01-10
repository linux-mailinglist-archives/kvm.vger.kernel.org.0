Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09513136B2B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 11:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgAJKg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 05:36:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60278 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727352AbgAJKgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 05:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578652614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=wTsn85XMuUpJ5S4/MLL/kbkajYi8zCp0ZxBQzSb2F1g=;
        b=gzVSaFRf7ZOFfAuRT5l3uqJ+ewfYakU3C/whkcYEJkfN95Yxj8a4b/uxHFklER2UP6VRHU
        KJ6gakitZO4RTi1Vz7QSZIUqK0ftK/fVebnQ+cg2sx0WzXkn7ARtEYU5YxpocyYSCIJY0D
        3jHET/X8Tm6WVjFijquDzp+F7oJbNME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-54qkeP8DNMCrAC0Csd9XvQ-1; Fri, 10 Jan 2020 05:36:51 -0500
X-MC-Unique: 54qkeP8DNMCrAC0Csd9XvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70DEE107ACC5;
        Fri, 10 Jan 2020 10:36:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-154.ams2.redhat.com [10.36.116.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3685687EC0;
        Fri, 10 Jan 2020 10:36:46 +0000 (UTC)
Subject: Re: [PATCH v6] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200110101906.54291-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9b9c3e09-e3ec-0ef2-0aef-a31ff34df33b@redhat.com>
Date:   Fri, 10 Jan 2020 11:36:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200110101906.54291-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/2020 11.19, Janosch Frank wrote:
> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that on a normal reset.
>=20
> Let's implement an interface for the missing normal and clear resets
> and reset all local IRQs, registers and control structures as stated
> in the architecture.
>=20
> Userspace might already reset the registers via the vcpu run struct,
> but as we need the interface for the interrupt clearing part anyway,
> we implement the resets fully and don't rely on userspace to reset the
> rest.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
[...]
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d9e6bf3d54f0..4936f9499291 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong ext)
>  	case KVM_CAP_S390_CMMA_MIGRATION:
>  	case KVM_CAP_S390_AIS:
>  	case KVM_CAP_S390_AIS_MIGRATION:
> +	case KVM_CAP_S390_VCPU_RESETS:
>  		r =3D 1;
>  		break;
>  	case KVM_CAP_S390_HPAGE_1M:
> @@ -2844,35 +2845,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> =20
>  }
> =20
> -static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
> -{
> -	/* this equals initial cpu reset in pop, but we don't switch to ESA *=
/
> -	vcpu->arch.sie_block->gpsw.mask =3D 0UL;
> -	vcpu->arch.sie_block->gpsw.addr =3D 0UL;
> -	kvm_s390_set_prefix(vcpu, 0);
> -	kvm_s390_set_cpu_timer(vcpu, 0);
> -	vcpu->arch.sie_block->ckc       =3D 0UL;
> -	vcpu->arch.sie_block->todpr     =3D 0;
> -	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
> -	vcpu->arch.sie_block->gcr[0]  =3D CR0_UNUSED_56 |
> -					CR0_INTERRUPT_KEY_SUBMASK |
> -					CR0_MEASUREMENT_ALERT_SUBMASK;
> -	vcpu->arch.sie_block->gcr[14] =3D CR14_UNUSED_32 |
> -					CR14_UNUSED_33 |
> -					CR14_EXTERNAL_DAMAGE_SUBMASK;
> -	/* make sure the new fpc will be lazily loaded */
> -	save_fpu_regs();
> -	current->thread.fpu.fpc =3D 0;
> -	vcpu->arch.sie_block->gbea =3D 1;
> -	vcpu->arch.sie_block->pp =3D 0;
> -	vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
> -	vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
> -	kvm_clear_async_pf_completion_queue(vcpu);
> -	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
> -		kvm_s390_vcpu_stop(vcpu);
> -	kvm_s390_clear_local_irqs(vcpu);
> -}
> -
>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  {
>  	mutex_lock(&vcpu->kvm->lock);
> @@ -3287,10 +3259,78 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(stru=
ct kvm_vcpu *vcpu,
>  	return r;
>  }
> =20
> -static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
> +static void kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
>  {
> -	kvm_s390_vcpu_initial_reset(vcpu);
> -	return 0;
> +	vcpu->arch.sie_block->gpsw.mask =3D ~PSW_MASK_RI;
> +	vcpu->arch.pfault_token =3D KVM_S390_PFAULT_TOKEN_INVALID;
> +	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
> +
> +	kvm_clear_async_pf_completion_queue(vcpu);
> +	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
> +		kvm_s390_vcpu_stop(vcpu);
> +	kvm_s390_clear_local_irqs(vcpu);
> +}
> +
> +static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
> +{
> +	/* Initial reset is a superset of the normal reset */
> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> +
> +	/* this equals initial cpu reset in pop, but we don't switch to ESA *=
/
> +	vcpu->arch.sie_block->gpsw.mask =3D 0UL;
> +	vcpu->arch.sie_block->gpsw.addr =3D 0UL;
> +	kvm_s390_set_prefix(vcpu, 0);
> +	kvm_s390_set_cpu_timer(vcpu, 0);
> +	vcpu->arch.sie_block->ckc       =3D 0UL;
> +	vcpu->arch.sie_block->todpr     =3D 0;
> +	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
> +	vcpu->arch.sie_block->gcr[0]  =3D CR0_UNUSED_56 |
> +					CR0_INTERRUPT_KEY_SUBMASK |
> +					CR0_MEASUREMENT_ALERT_SUBMASK;
> +	vcpu->arch.sie_block->gcr[14] =3D CR14_UNUSED_32 |
> +					CR14_UNUSED_33 |
> +					CR14_EXTERNAL_DAMAGE_SUBMASK;
> +	/* make sure the new fpc will be lazily loaded */
> +	save_fpu_regs();
> +	current->thread.fpu.fpc =3D 0;
> +	vcpu->arch.sie_block->gbea =3D 1;
> +	vcpu->arch.sie_block->pp =3D 0;
> +	vcpu->arch.sie_block->fpf &=3D ~FPF_BPBC;
> +}
> +
> +static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sync_regs *regs =3D &vcpu->run->s.regs;
> +
> +	/* Clear reset is a superset of the initial reset */
> +	kvm_arch_vcpu_ioctl_normal_reset(vcpu);
> +
> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
> +	/*
> +	 * Will be picked up via save_fpu_regs() in the initial reset
> +	 * fallthrough.

The word "fallthrough" now likely should be removed from the comment.

Also, I'm not an expert in this lazy-fpu stuff, but don't you rather
have to deal with current->thread.fpu.regs here instead?

> +	 */
> +	memset(&regs->vrs, 0, sizeof(regs->vrs));
> +	memset(&regs->acrs, 0, sizeof(regs->acrs));
> +
> +	regs->etoken =3D 0;
> +	regs->etoken_extension =3D 0;
> +
> +	memset(&regs->gscb, 0, sizeof(regs->gscb));
> +	if (MACHINE_HAS_GS) {
> +		preempt_disable();
> +		__ctl_set_bit(2, 4);
> +		if (current->thread.gs_cb) {
> +			vcpu->arch.host_gscb =3D current->thread.gs_cb;
> +			save_gs_cb(vcpu->arch.host_gscb);
> +		}
> +		if (vcpu->arch.gs_enabled) {
> +			current->thread.gs_cb =3D (struct gs_cb *)
> +				&vcpu->run->s.regs.gscb;
> +			restore_gs_cb(current->thread.gs_cb);
> +		}
> +		preempt_enable();
> +	}
>  }

 Thomas

