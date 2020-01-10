Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5649E136CC6
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 13:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgAJMLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 07:11:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29519 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727979AbgAJMLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 07:11:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578658310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=bz8pJLMFYDaMjoJs/HvPCOO2pcdV+oR4zQCxVZZnXws=;
        b=HVuON6gbly3nTdrghdcoUGuIZbGBoae/m8NKjSSyCzrtkg4bwfcGJEivOpNv4Ub699uRka
        cTE1l51EvnlKgma3iPidKUd0+AKDS3uIdBEdabWjNBN7m3a40JIJGb229e4Q6yuRoUoH1k
        e1NYw+sTr/7ToDcaALuwG0NaxSx1+eI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-h_Q-sLq5O0CVuHf_eYfMCw-1; Fri, 10 Jan 2020 07:11:46 -0500
X-MC-Unique: h_Q-sLq5O0CVuHf_eYfMCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89ABC1800D4E;
        Fri, 10 Jan 2020 12:11:45 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-154.ams2.redhat.com [10.36.116.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5211819C58;
        Fri, 10 Jan 2020 12:11:41 +0000 (UTC)
Subject: Re: [PATCH v7] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, borntraeger@de.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        cohuck@redhat.com
References: <20200110114540.90713-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f6c54d4e-6b31-d93f-e919-45781aadfd55@redhat.com>
Date:   Fri, 10 Jan 2020 13:11:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200110114540.90713-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/2020 12.45, Janosch Frank wrote:
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
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  Documentation/virt/kvm/api.txt |  43 +++++++++++++
>  arch/s390/kvm/kvm-s390.c       | 112 +++++++++++++++++++++++----------
>  include/uapi/linux/kvm.h       |   5 ++
>  3 files changed, 127 insertions(+), 33 deletions(-)
>=20
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/ap=
i.txt
> index ebb37b34dcfc..73448764f544 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4168,6 +4168,42 @@ This ioctl issues an ultravisor call to terminat=
e the secure guest,
>  unpins the VPA pages and releases all the device pages that are used t=
o
>  track the secure pages by hypervisor.
> =20
> +4.122 KVM_S390_NORMAL_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the cpu reset definition in the POP (Principles Of Operation).
> +
> +4.123 KVM_S390_INITIAL_RESET
> +
> +Capability: none
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the initial cpu reset definition in the POP. However, the cpu is not
> +put into ESA mode. This reset is a superset of the normal reset.
> +
> +4.124 KVM_S390_CLEAR_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the clear cpu reset definition in the POP. However, the cpu is not put
> +into ESA mode. This reset is a superset of the initial reset.
> +
> +
>  5. The kvm_run structure
>  ------------------------
> =20
> @@ -5396,3 +5432,10 @@ handling by KVM (as some KVM hypercall may be mi=
stakenly treated as TLB
>  flush hypercalls by Hyper-V) so userspace should disable KVM identific=
ation
>  in CPUID and only exposes Hyper-V identification. In this case, guest
>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> +
> +8.22 KVM_CAP_S390_VCPU_RESETS
> +
> +Architectures: s390
> +
> +This capability indicates that the KVM_S390_NORMAL_RESET and
> +KVM_S390_CLEAR_RESET ioctls are available.
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d9e6bf3d54f0..5640f3d6f98d 100644
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
> @@ -3287,10 +3259,75 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(stru=
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

s/kvm_arch_vcpu_ioctl_normal_reset/kvm_arch_vcpu_ioctl_initial_reset/

> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
> +	/* Will be picked up because of save_fpu_regs() in the initial reset =
*/
> +	memset(&current->thread.fpu.vxrs, 0, sizeof(current->thread.fpu.vxrs)=
);

I'm still not 100% sure about whether current->thread.fpu.vxrs is always
fine here? But I hope Christian can give an ACK for that...

 Thomas

