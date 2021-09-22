Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B830B414DE4
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 18:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhIVQRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 12:17:39 -0400
Received: from foss.arm.com ([217.140.110.172]:51214 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233094AbhIVQRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 12:17:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B3F5113E;
        Wed, 22 Sep 2021 09:16:08 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 866393F719;
        Wed, 22 Sep 2021 09:16:05 -0700 (PDT)
Message-ID: <138537dc-64ef-ab3b-6977-4cc19de7fee3@arm.com>
Date:   Wed, 22 Sep 2021 17:17:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v8 2/8] KVM: arm64: Separate guest/host counter offset
 values
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-3-oupton@google.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <20210916181510.963449-3-oupton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

I don't understand what this patch is trying to achieve, so I'm just going to ask
some high level questions before I go through the code.

On 9/16/21 19:15, Oliver Upton wrote:
> In some instances, a VMM may want to update the guest's counter-timer
> offset in a transparent manner, meaning that changes to the hardware
> value do not affect the synthetic register presented to the guest or the
> VMM through said guest's architectural state. Lay the groundwork to
> separate guest offset register writes from the hardware values utilized
> by KVM.

I find this description very hard to parse. What do you mean by the "register
presented to the guest or the VMM through said guest's architectural state"?

If I understand the code correctly, what the patch does is to create another copy
of __vcpu_sys_reg(CNTVOFF_EL2) in vcpu_vtimer(vcpu)->host_offset in a very
roundabout manner, in the function timer_set_guest_offset() (please correct me if
I'm wrong). The commit doesn't explain why that is done at all, except for this
part: "In some instances, a VMM may want to update the guest's counter-timer
offset in a transparent manner", which looks very cryptic, at least to me.

In the cover letter, you mention adding support for a physical timer offset. I
think it would make the commits clearer to follow if there was a better
distinction between changes to the virtual timer offset and physical timer offsets.

>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/arch_timer.c  | 42 +++++++++++++++++++++++++++---------
>  include/kvm/arm_arch_timer.h |  3 +++
>  2 files changed, 35 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index c0101db75ad4..cf2f4a034dbe 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -84,11 +84,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
>  
>  static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
> -	struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
>  	switch(arch_timer_ctx_index(ctxt)) {
>  	case TIMER_VTIMER:
> -		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> +		return ctxt->host_offset;
>  	default:
>  		return 0;
>  	}
> @@ -128,17 +126,33 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>  
>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
> -	struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
>  	switch(arch_timer_ctx_index(ctxt)) {
>  	case TIMER_VTIMER:
> -		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +		ctxt->host_offset = offset;
>  		break;
>  	default:
>  		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>  	}
>  }
>  
> +static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
> +{
> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +	switch (arch_timer_ctx_index(ctxt)) {
> +	case TIMER_VTIMER: {
> +		u64 host_offset = timer_get_offset(ctxt);
> +
> +		host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> +		__vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +		timer_set_offset(ctxt, host_offset);
> +		break;
> +	}
> +	default:
> +		WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +	}
> +}
> +
>  u64 kvm_phys_timer_read(void)
>  {
>  	return timecounter->cc->read(timecounter->cc);
> @@ -749,7 +763,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  
>  /* Make offset updates for all timer contexts atomic */
>  static void update_timer_offset(struct kvm_vcpu *vcpu,
> -				enum kvm_arch_timers timer, u64 offset)
> +				enum kvm_arch_timers timer, u64 offset,
> +				bool guest_visible)
>  {
>  	int i;
>  	struct kvm *kvm = vcpu->kvm;
> @@ -758,13 +773,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
>  	lockdep_assert_held(&kvm->lock);
>  
>  	kvm_for_each_vcpu(i, tmp, kvm)
> -		timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> +		if (guest_visible)
> +			timer_set_guest_offset(vcpu_get_timer(tmp, timer),
> +					       offset);
> +		else
> +			timer_set_offset(vcpu_get_timer(tmp, timer), offset);
>  
>  	/*
>  	 * When called from the vcpu create path, the CPU being created is not
>  	 * included in the loop above, so we just set it here as well.
>  	 */
> -	timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> +	if (guest_visible)
> +		timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
> +	else
> +		timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
>  }
>  
>  static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> @@ -772,7 +794,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>  	struct kvm *kvm = vcpu->kvm;
>  
>  	mutex_lock(&kvm->lock);
> -	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
> +	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, true);
>  	mutex_unlock(&kvm->lock);
>  }
>  
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 51c19381108c..9d65d4a29f81 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -42,6 +42,9 @@ struct arch_timer_context {
>  	/* Duplicated state from arch_timer.c for convenience */
>  	u32				host_timer_irq;
>  	u32				host_timer_irq_flags;
> +
> +	/* offset relative to the host's physical counter-timer */
> +	u64				host_offset;

I find the name and the comment very confusing. The name makes me think it
represents the host's virtual timer offset, but that is always 0. Judging from the
code, host_offset refers to the guest's virtual timer offset. The comment refers
to the host's physical counter-timer, which makes me believe the opposite, that
it's the offset from the physical timer.

Thanks,

Alex

>  };
>  
>  struct timer_map {
