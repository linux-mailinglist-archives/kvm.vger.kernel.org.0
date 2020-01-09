Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F327A135EE3
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgAIRIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 12:08:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49162 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731395AbgAIRIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 12:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578589730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yIBsCtp3fW0rPPOfLb5V3w4m2bp1K36Vz4t6cH/tyWw=;
        b=LOUGgQSWb/Rh+9PtA2NxzGuTtJHgXfn+26zEcNnA/r/o5+T9be+kWduHiqqnXDxmWx8PxX
        Kdu0l+nhfRaeq2iwmcVHbOzd3O+DJbwYL2gW5usGc2UVrvBX2OsmZONLFY4bFTqfak9LAg
        fYQvljTJcgGm0LnQZGj3fZjYmjzlPcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-kctYQVKPMSKD1vDD3dXzgw-1; Thu, 09 Jan 2020 12:08:48 -0500
X-MC-Unique: kctYQVKPMSKD1vDD3dXzgw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FDA7801F91;
        Thu,  9 Jan 2020 17:08:47 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFA6F80602;
        Thu,  9 Jan 2020 17:08:43 +0000 (UTC)
Date:   Thu, 9 Jan 2020 18:08:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH v4] KVM: s390: Add new reset vcpu API
Message-ID: <20200109180841.6843cb92.cohuck@redhat.com>
In-Reply-To: <20200109155602.18985-1-frankja@linux.ibm.com>
References: <20200109155602.18985-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Jan 2020 10:56:01 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that on a normal reset.
> 
> Let's implement an interface for the missing normal and clear resets
> and reset all local IRQs, registers and control structures as stated
> in the architecture.
> 
> Userspace might already reset the registers via the vcpu run struct,
> but as we need the interface for the interrupt clearing part anyway,
> we implement the resets fully and don't rely on userspace to reset the
> rest.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> I dropped the reviews, as I changed quite a lot.  
> 
> Keep in mind, that now we'll need a new parameter in normal and
> initial reset for protected virtualization to indicate that we need to
> do the reset via the UV call. The Ultravisor does only accept the
> needed reset, not any subset resets.

In the interface, or externally?

[Apologies, but the details of the protected virt stuff are no longer
in my cache.]

> 
> ---
>  Documentation/virt/kvm/api.txt |  46 ++++++++++++++
>  arch/s390/kvm/kvm-s390.c       | 106 +++++++++++++++++++++++----------
>  include/uapi/linux/kvm.h       |   5 ++
>  3 files changed, 127 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index ebb37b34dcfc..734fbe992ed6 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4168,6 +4168,45 @@ This ioctl issues an ultravisor call to terminate the secure guest,
>  unpins the VPA pages and releases all the device pages that are used to
>  track the secure pages by hypervisor.
>  
> +4.122 KVM_S390_NORMAL_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures. It is
> +intended to be called when a normal reset is performed on the vcpu and
> +clears local interrupts, the riccb and PSW bit 24.

I'm not sure you'd want to specify the actual values to be reset here;
you'd always need to remember to update them when the architecture is
extended... just refer to the POP instead?

> +
> +4.123 KVM_S390_INITIAL_RESET
> +
> +Capability: none
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures. It is
> +intended to be called when an initial reset (which is a superset of
> +the normal reset) is performed on the vcpu and additionally clears the
> +psw, prefix, timing related registers, as well as setting the control
> +registers to their initial value.

Same here.

> +
> +4.124 KVM_S390_CLEAR_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures. It is
> +intended to be called when a clear reset (which is a superset of the
> +initial reset) is performed on the vcpu and additionally clears
> +general, access, floating point and vector registers.

And here.

> +
>  5. The kvm_run structure
>  ------------------------
>  
> @@ -5396,3 +5435,10 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
>  flush hypercalls by Hyper-V) so userspace should disable KVM identification
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
> index d9e6bf3d54f0..c338a49331e5 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_S390_CMMA_MIGRATION:
>  	case KVM_CAP_S390_AIS:
>  	case KVM_CAP_S390_AIS_MIGRATION:
> +	case KVM_CAP_S390_VCPU_RESETS:
>  		r = 1;
>  		break;
>  	case KVM_CAP_S390_HPAGE_1M:
> @@ -2844,35 +2845,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  
>  }
>  
> -static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
> -{
> -	/* this equals initial cpu reset in pop, but we don't switch to ESA */
> -	vcpu->arch.sie_block->gpsw.mask = 0UL;
> -	vcpu->arch.sie_block->gpsw.addr = 0UL;
> -	kvm_s390_set_prefix(vcpu, 0);
> -	kvm_s390_set_cpu_timer(vcpu, 0);
> -	vcpu->arch.sie_block->ckc       = 0UL;
> -	vcpu->arch.sie_block->todpr     = 0;
> -	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
> -	vcpu->arch.sie_block->gcr[0]  = CR0_UNUSED_56 |
> -					CR0_INTERRUPT_KEY_SUBMASK |
> -					CR0_MEASUREMENT_ALERT_SUBMASK;
> -	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
> -					CR14_UNUSED_33 |
> -					CR14_EXTERNAL_DAMAGE_SUBMASK;
> -	/* make sure the new fpc will be lazily loaded */
> -	save_fpu_regs();
> -	current->thread.fpu.fpc = 0;
> -	vcpu->arch.sie_block->gbea = 1;
> -	vcpu->arch.sie_block->pp = 0;
> -	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
> -	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
> -	kvm_clear_async_pf_completion_queue(vcpu);
> -	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
> -		kvm_s390_vcpu_stop(vcpu);
> -	kvm_s390_clear_local_irqs(vcpu);
> -}
> -
>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  {
>  	mutex_lock(&vcpu->kvm->lock);
> @@ -3287,9 +3259,76 @@ static int kvm_arch_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> +static int kvm_arch_vcpu_ioctl_normal_reset(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.sie_block->gpsw.mask = ~PSW_MASK_RI;
> +	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
> +	memset(vcpu->run->s.regs.riccb, 0, sizeof(vcpu->run->s.regs.riccb));
> +
> +	kvm_clear_async_pf_completion_queue(vcpu);
> +	if (!kvm_s390_user_cpu_state_ctrl(vcpu->kvm))
> +		kvm_s390_vcpu_stop(vcpu);
> +	kvm_s390_clear_local_irqs(vcpu);
> +
> +	return 0;
> +}
> +
>  static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>  {
> -	kvm_s390_vcpu_initial_reset(vcpu);
> +	/* this equals initial cpu reset in pop, but we don't switch to ESA */

Maybe also mention that in the documentation?

> +	vcpu->arch.sie_block->gpsw.mask = 0UL;
> +	vcpu->arch.sie_block->gpsw.addr = 0UL;
> +	kvm_s390_set_prefix(vcpu, 0);
> +	kvm_s390_set_cpu_timer(vcpu, 0);
> +	vcpu->arch.sie_block->ckc       = 0UL;
> +	vcpu->arch.sie_block->todpr     = 0;
> +	memset(vcpu->arch.sie_block->gcr, 0, 16 * sizeof(__u64));
> +	vcpu->arch.sie_block->gcr[0]  = CR0_UNUSED_56 |
> +					CR0_INTERRUPT_KEY_SUBMASK |
> +					CR0_MEASUREMENT_ALERT_SUBMASK;
> +	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
> +					CR14_UNUSED_33 |
> +					CR14_EXTERNAL_DAMAGE_SUBMASK;
> +	/* make sure the new fpc will be lazily loaded */
> +	save_fpu_regs();
> +	current->thread.fpu.fpc = 0;
> +	vcpu->arch.sie_block->gbea = 1;
> +	vcpu->arch.sie_block->pp = 0;
> +	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
> +

Add a comment that the remaining work will be done in normal_reset?

> +	return 0;
> +}
> +
> +static int kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
> +
> +	memset(&regs->gprs, 0, sizeof(regs->gprs));
> +	/*
> +	 * Will be picked up via save_fpu_regs() in the initial reset
> +	 * fallthrough.
> +	 */

This comment is a bit confusing... what does 'picked up' mean?

(Maybe I'm just too tired, sorry...)

> +	memset(&regs->vrs, 0, sizeof(regs->vrs));
> +	memset(&regs->acrs, 0, sizeof(regs->acrs));
> +
> +	regs->etoken = 0;
> +	regs->etoken_extension = 0;
> +
> +	memset(&regs->gscb, 0, sizeof(regs->gscb));
> +	if (MACHINE_HAS_GS) {
> +		preempt_disable();
> +		__ctl_set_bit(2, 4);
> +		if (current->thread.gs_cb) {
> +			vcpu->arch.host_gscb = current->thread.gs_cb;
> +			save_gs_cb(vcpu->arch.host_gscb);
> +		}
> +		if (vcpu->arch.gs_enabled) {
> +			current->thread.gs_cb = (struct gs_cb *)
> +				&vcpu->run->s.regs.gscb;
> +			restore_gs_cb(current->thread.gs_cb);
> +		}
> +		preempt_enable();
> +	}

And here that the remaining work will be done in initial_reset and
normal_reset?

>  	return 0;
>  }
>  
> @@ -4363,8 +4402,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		r = kvm_arch_vcpu_ioctl_set_initial_psw(vcpu, psw);
>  		break;
>  	}
> +
> +	case KVM_S390_CLEAR_RESET:
> +		r = kvm_arch_vcpu_ioctl_clear_reset(vcpu);
> +		/* fallthrough */
>  	case KVM_S390_INITIAL_RESET:
>  		r = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
> +		/* fallthrough */
> +	case KVM_S390_NORMAL_RESET:
> +		r = kvm_arch_vcpu_ioctl_normal_reset(vcpu);

Can any of these functions return !0 when the protected virt stuff is
done on top? If not, can we make them void and just set r=0; here?

>  		break;
>  	case KVM_SET_ONE_REG:
>  	case KVM_GET_ONE_REG: {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f0a16b4adbbd..4b95f9a31a2f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1009,6 +1009,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
>  #define KVM_CAP_ARM_NISV_TO_USER 177
>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
> +#define KVM_CAP_S390_VCPU_RESETS 179
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -1473,6 +1474,10 @@ struct kvm_enc_region {
>  /* Available with KVM_CAP_ARM_SVE */
>  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
>  
> +/* Available with  KVM_CAP_S390_VCPU_RESETS */
> +#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
> +#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */

