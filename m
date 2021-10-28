Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB8743E564
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhJ1Psj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:48:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230265AbhJ1Psi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 11:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635435970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4tMjT47BZ3DwbmAEWq81W0GAGbuRTe5m3IotIof8YU=;
        b=BjqOJFROTIOhDmJkCsO6Exs79jec8AvAq0YcQV3+y6zihBb/DGdQas3lnaz5aNxZE2hqbK
        WhObPml9ixi3GkAgkTvb2ovSasE+MsFT1a5iP4142pp+zyc0PR58hxt5QbukfE3NmyqktO
        zLewA7VN5IUax5mM4WnTFZ7PBNDdWt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-HPiuQd71NyeJUfJbOWNqdw-1; Thu, 28 Oct 2021 11:46:07 -0400
X-MC-Unique: HPiuQd71NyeJUfJbOWNqdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F02CB19251A0;
        Thu, 28 Oct 2021 15:46:02 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9106C5DA61;
        Thu, 28 Oct 2021 15:45:15 +0000 (UTC)
Message-ID: <06ed37a510347fdc7c6f7ce46fd98ce5b9ff7554.camel@redhat.com>
Subject: Re: [PATCH v2 32/43] KVM: VMX: Move preemption timer <=> hrtimer
 dance to common x86
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
Date:   Thu, 28 Oct 2021 18:45:14 +0300
In-Reply-To: <20211009021236.4122790-33-seanjc@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-33-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> Handle the switch to/from the hypervisor/software timer when a vCPU is
> blocking in common x86 instead of in VMX.  Even though VMX is the only
> user of a hypervisor timer, the logic and all functions involved are
> generic x86 (unless future CPUs do something completely different and
> implement a hypervisor timer that runs regardless of mode).
> 
> Handling the switch in common x86 will allow for the elimination of the
> pre/post_blocks hooks, and also lets KVM switch back to the hypervisor
> timer if and only if it was in use (without additional params).  Add a
> comment explaining why the switch cannot be deferred to kvm_sched_out()
> or kvm_vcpu_block().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |  6 +-----
>  arch/x86/kvm/x86.c     | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b3bb2031a7ac..a24f19874716 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7464,16 +7464,12 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>  
>  static int vmx_pre_block(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_lapic_hv_timer_in_use(vcpu))
> -		kvm_lapic_switch_to_sw_timer(vcpu);
> -
>  	return 0;
>  }
>  
>  static void vmx_post_block(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_x86_ops.set_hv_timer)
> -		kvm_lapic_switch_to_hv_timer(vcpu);
> +
>  }
>  
>  static void vmx_setup_mce(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0219acfd9cf..909e932a7ae7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9896,8 +9896,21 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  {
> +	bool hv_timer;
> +
>  	if (!kvm_arch_vcpu_runnable(vcpu) &&
>  	    (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu) == 0)) {
> +		/*
> +		 * Switch to the software timer before halt-polling/blocking as
> +		 * the guest's timer may be a break event for the vCPU, and the
> +		 * hypervisor timer runs only when the CPU is in guest mode.
> +		 * Switch before halt-polling so that KVM recognizes an expired
> +		 * timer before blocking.
> +		 */

I didn't knew about this until now but it all makes sense. The comment is very good.

> +		hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
> +		if (hv_timer)
> +			kvm_lapic_switch_to_sw_timer(vcpu);
> +
>  		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>  		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
>  			kvm_vcpu_halt(vcpu);
> @@ -9905,6 +9918,9 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  			kvm_vcpu_block(vcpu);
>  		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  
> +		if (hv_timer)
> +			kvm_lapic_switch_to_hv_timer(vcpu);
> +
>  		if (kvm_x86_ops.post_block)
>  			static_call(kvm_x86_post_block)(vcpu);
>  
> @@ -10136,6 +10152,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  			r = -EINTR;
>  			goto out;
>  		}
> +		/*
> +		 * It should be impossible for the hypervisor timer to be in
> +		 * use before KVM has ever run the vCPU.
> +		 */
> +		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
>  		kvm_vcpu_block(vcpu);
>  		if (kvm_apic_accept_events(vcpu) < 0) {
>  			r = 0;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

