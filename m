Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D8E43E4BD
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhJ1PRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231182AbhJ1PRP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 11:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635434087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CgLB+hml0Y7q7/T5mul1oJ9iyJp6xHKyNVaPuOUZPD4=;
        b=XVjGfsAZAhWTFtg5QXToO3iiycW1CQtvY7Ox3naz3JW2t99tsf1pOh7JZ6+cozpEZTLkP/
        GonRs9D43DddqIxjfhz+aC1Rb263Q/KkVUPJPBItQT1+kzQXg0J5y+ofu/sxv1mPhM+/ku
        pAnpBQnTH8maGX8fF4fDN8DICDnGBdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-7i2Vkjg3NLG5kTq--XeVvA-1; Thu, 28 Oct 2021 11:14:42 -0400
X-MC-Unique: 7i2Vkjg3NLG5kTq--XeVvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B87E100F95D;
        Thu, 28 Oct 2021 15:14:37 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E0E960FB8;
        Thu, 28 Oct 2021 15:14:06 +0000 (UTC)
Message-ID: <2e1f7a9c83f38f3262febf05b4d2acd5efc753b3.camel@redhat.com>
Subject: Re: [PATCH v2 29/43] KVM: VMX: Handle PI wakeup shenanigans during
 vcpu_put/load
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Thu, 28 Oct 2021 18:14:04 +0300
In-Reply-To: <20211009021236.4122790-30-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-30-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Move the posted interrupt pre/post_block logic into vcpu_put/load
> respectively, using the kvm_vcpu_is_blocking() to determining whether or
> not the wakeup handler needs to be set (and unset).  This avoids updating
> the PI descriptor if halt-polling is successful, reduces the number of
> touchpoints for updating the descriptor, and eliminates the confusing
> behavior of intentionally leaving a "stale" PI.NDST when a blocking vCPU
> is scheduled back in after preemption.
> 
> The downside is that KVM will do the PID update twice if the vCPU is
> preempted after prepare_to_rcuwait() but before schedule(), but that's a
> rare case (and non-existent on !PREEMPT kernels).
> 
> The notable wart is the need to send a self-IPI on the wakeup vector if
> an outstanding notification is pending after configuring the wakeup
> vector.  Ideally, KVM would just do a kvm_vcpu_wake_up() in this case,
> but the scheduler doesn't support waking a task from its preemption
> notifier callback, i.e. while the task is smack dab in the middle of
> being scheduled out.
> 
> Note, setting the wakeup vector before halt-polling is not necessary as
> the pending IRQ will be recorded in the PIR and detected as a blocking-
> breaking condition by kvm_vcpu_has_events() -> vmx_sync_pir_to_irr().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 162 ++++++++++++++-------------------
>  arch/x86/kvm/vmx/posted_intr.h |   8 +-
>  arch/x86/kvm/vmx/vmx.c         |   5 -
>  3 files changed, 75 insertions(+), 100 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 901b7a5f7777..d2b3d75c57d1 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -37,33 +37,45 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  	struct pi_desc old, new;
> +	unsigned long flags;
>  	unsigned int dest;
>  
>  	/*
> -	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST and
> -	 * PI.SN up-to-date even if there is no assigned device or if APICv is
> +	 * To simplify hot-plug and dynamic toggling of APICv, keep PI.NDST
> +	 * up-to-date even if there is no assigned device or if APICv is
>  	 * deactivated due to a dynamic inhibit bit, e.g. for Hyper-V's SyncIC.
>  	 */
>  	if (!enable_apicv || !lapic_in_kernel(vcpu))
>  		return;
>  
> -	/* Nothing to do if PI.SN==0 and the vCPU isn't being migrated. */
> -	if (!pi_test_sn(pi_desc) && vcpu->cpu == cpu)
> +	/*
> +	 * If the vCPU wasn't on the wakeup list and wasn't migrated, then the
> +	 * full update can be skipped as neither the vector nor the destination
> +	 * needs to be changed.
> +	 */
> +	if (pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu == cpu) {
> +		/*
> +		 * Clear SN if it was set due to being preempted.  Again, do
> +		 * this even if there is no assigned device for simplicity.
> +		 */
> +		if (pi_test_and_clear_sn(pi_desc))
> +			goto after_clear_sn;
>  		return;
> +	}
> +
> +	local_irq_save(flags);
>  
>  	/*
> -	 * If the 'nv' field is POSTED_INTR_WAKEUP_VECTOR, do not change
> -	 * PI.NDST: pi_post_block is the one expected to change PID.NDST and the
> -	 * wakeup handler expects the vCPU to be on the blocked_vcpu_list that
> -	 * matches PI.NDST. Otherwise, a vcpu may not be able to be woken up
> -	 * correctly.
> +	 * If the vCPU was waiting for wakeup, remove the vCPU from the wakeup
> +	 * list of the _previous_ pCPU, which will not be the same as the
> +	 * current pCPU if the task was migrated.
>  	 */
> -	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR || vcpu->cpu == cpu) {
> -		pi_clear_sn(pi_desc);
> -		goto after_clear_sn;
> +	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> +		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
> +		list_del(&vcpu->blocked_vcpu_list);
> +		spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
>  	}
>  
> -	/* The full case.  Set the new destination and clear SN. */
>  	dest = cpu_physical_id(cpu);
>  	if (!x2apic_mode)
>  		dest = (dest << 8) & 0xFF00;
> @@ -71,11 +83,23 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  	do {
>  		old.control = new.control = READ_ONCE(pi_desc->control);
>  
> +		/*
> +		 * Clear SN (as above) and refresh the destination APIC ID to
> +		 * handle task migration (@cpu != vcpu->cpu).
> +		 */
>  		new.ndst = dest;
>  		new.sn = 0;
> +
> +		/*
> +		 * Restore the notification vector; in the blocking case, the
> +		 * descriptor was modified on "put" to use the wakeup vector.
> +		 */
> +		new.nv = POSTED_INTR_VECTOR;
>  	} while (cmpxchg64(&pi_desc->control, old.control,
>  			   new.control) != old.control);
>  
> +	local_irq_restore(flags);
> +
>  after_clear_sn:
>  
>  	/*
> @@ -90,88 +114,24 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>  		pi_set_on(pi_desc);
>  }
>  
> -void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
> -{
> -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> -
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> -		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> -		!kvm_vcpu_apicv_active(vcpu))
> -		return;
> -
> -	/* Set SN when the vCPU is preempted */
> -	if (vcpu->preempted)
> -		pi_set_sn(pi_desc);
> -}
> -
> -static void __pi_post_block(struct kvm_vcpu *vcpu)
> -{
> -	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> -	struct pi_desc old, new;
> -	unsigned int dest;
> -
> -	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
> -	     "Wakeup handler not enabled while the vCPU was blocking");
> -
> -	/*
> -	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
> -	 * will not be the same as the current pCPU if the task was migrated.
> -	 */
> -	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -	list_del(&vcpu->blocked_vcpu_list);
> -	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> -
> -	dest = cpu_physical_id(vcpu->cpu);
> -	if (!x2apic_mode)
> -		dest = (dest << 8) & 0xFF00;
> -
> -	do {
> -		old.control = new.control = READ_ONCE(pi_desc->control);
> -
> -		new.ndst = dest;
> -
> -		/* set 'NV' to 'notification vector' */
> -		new.nv = POSTED_INTR_VECTOR;
> -	} while (cmpxchg64(&pi_desc->control, old.control,
> -			   new.control) != old.control);
> -
> -	vcpu->pre_pcpu = -1;
> -}
> -
>  /*
> - * This routine does the following things for vCPU which is going
> - * to be blocked if VT-d PI is enabled.
> - * - Store the vCPU to the wakeup list, so when interrupts happen
> - *   we can find the right vCPU to wake up.
> - * - Change the Posted-interrupt descriptor as below:
> - *      'NV' <-- POSTED_INTR_WAKEUP_VECTOR
> - * - If 'ON' is set during this process, which means at least one
> - *   interrupt is posted for this vCPU, we cannot block it, in
> - *   this case, return 1, otherwise, return 0.
> - *
> + * Put the vCPU on this pCPU's list of vCPUs that needs to be awakened and set
> + * WAKEUP as the notification vector in the PI descriptor.
>   */
> -int pi_pre_block(struct kvm_vcpu *vcpu)
> +static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  {
> -	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> +	struct pi_desc old, new;
>  	unsigned long flags;
>  
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> -	    !irq_remapping_cap(IRQ_POSTING_CAP) ||
> -	    !kvm_vcpu_apicv_active(vcpu) ||
> -	    vmx_interrupt_blocked(vcpu))
> -		return 0;
> -
>  	local_irq_save(flags);
>  
> -	vcpu->pre_pcpu = vcpu->cpu;
>  	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
>  	list_add_tail(&vcpu->blocked_vcpu_list,
>  		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
>  	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
>  
> -	WARN(pi_desc->sn == 1,
> -	     "Posted Interrupt Suppress Notification set before blocking");
> +	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
>  
>  	do {
>  		old.control = new.control = READ_ONCE(pi_desc->control);
> @@ -181,24 +141,40 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	} while (cmpxchg64(&pi_desc->control, old.control,
>  			   new.control) != old.control);
>  
> -	/* We should not block the vCPU if an interrupt is posted for it.  */
> -	if (pi_test_on(pi_desc))
> -		__pi_post_block(vcpu);
> +	/*
> +	 * Send a wakeup IPI to this CPU if an interrupt may have been posted
> +	 * before the notification vector was updated, in which case the IRQ
> +	 * will arrive on the non-wakeup vector.  An IPI is needed as calling
> +	 * try_to_wake_up() from ->sched_out() isn't allowed (IRQs are not
> +	 * enabled until it is safe to call try_to_wake_up() on the task being
> +	 * scheduled out).
> +	 */
> +	if (pi_test_on(&new))
> +		apic->send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
>  
>  	local_irq_restore(flags);
> -	return (vcpu->pre_pcpu == -1);
>  }
>  
> -void pi_post_block(struct kvm_vcpu *vcpu)
> +void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long flags;
> +	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (vcpu->pre_pcpu == -1)
> +	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> +	    !irq_remapping_cap(IRQ_POSTING_CAP)  ||
> +	    !kvm_vcpu_apicv_active(vcpu))
>  		return;
>  
> -	local_irq_save(flags);
> -	__pi_post_block(vcpu);
> -	local_irq_restore(flags);
> +	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
> +		pi_enable_wakeup_handler(vcpu);
> +
> +	/*
> +	 * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
> +	 * as blocking and preempted, e.g. if it's preempted between setting
> +	 * its wait state and manually scheduling out.  In that case, KVM will
> +	 * update
> +	 */
> +	if (vcpu->preempted)
> +		pi_set_sn(pi_desc);
>  }
>  
>  /*
> @@ -239,7 +215,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
>   * Bail out of the block loop if the VM has an assigned
>   * device, but the blocking vCPU didn't reconfigure the
>   * PI.NV to the wakeup vector, i.e. the assigned device
> - * came along after the initial check in pi_pre_block().
> + * came along after the initial check in vmx_vcpu_pi_put().
>   */
>  void vmx_pi_start_assignment(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index 36ae035f14aa..eb14e76b84ef 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -40,6 +40,12 @@ static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
>  			(unsigned long *)&pi_desc->control);
>  }
>  
> +static inline bool pi_test_and_clear_sn(struct pi_desc *pi_desc)
> +{
> +	return test_and_clear_bit(POSTED_INTR_SN,
> +			(unsigned long *)&pi_desc->control);
> +}
> +
>  static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
>  {
>  	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
> @@ -88,8 +94,6 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
>  
>  void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
>  void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
> -int pi_pre_block(struct kvm_vcpu *vcpu);
> -void pi_post_block(struct kvm_vcpu *vcpu);
>  void pi_wakeup_handler(void);
>  void __init pi_init_cpu(int cpu);
>  bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5517893f12fc..26ed8cd1a1f2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7462,9 +7462,6 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>  
>  static int vmx_pre_block(struct kvm_vcpu *vcpu)
>  {
> -	if (pi_pre_block(vcpu))
> -		return 1;
> -
>  	if (kvm_lapic_hv_timer_in_use(vcpu))
>  		kvm_lapic_switch_to_sw_timer(vcpu);
>  
> @@ -7475,8 +7472,6 @@ static void vmx_post_block(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_x86_ops.set_hv_timer)
>  		kvm_lapic_switch_to_hv_timer(vcpu);
> -
> -	pi_post_block(vcpu);
>  }
>  
>  static void vmx_setup_mce(struct kvm_vcpu *vcpu)


Looks OK to me, and IMHO is a very good step in direction to simplify that code,
but the logic is far from beeing simple so I might have missed something.

Especially, this should be tested with nested APICv, which I don't yet know well
enough to know if this can break it or not.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

