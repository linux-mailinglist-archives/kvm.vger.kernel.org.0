Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4654E6CFC22
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjC3HCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 03:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjC3HCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 03:02:22 -0400
Received: from out-27.mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809C940C9
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 00:02:19 -0700 (PDT)
Date:   Thu, 30 Mar 2023 07:02:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680159737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=inQR8SSL3A8SF2lOvjXIotjfddM6BcB/Maw7D6h3xMw=;
        b=g3B6Ekt6LSeZkbGRKUL4D5rIgaOwaa9DTjy/0Z2G+UQb/fXtDFlVunDvAV65UnATOetZlj
        dJLRJ/YW0jPVT+4H62KO07SgHmYFKsys48DGp7VGinVgQz5jiaompWWJW3RnDDKoHyZvd5
        1jpmh1PVRVph1n961kleNGweno0iFUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: Re: [PATCH v3 11/18] KVM: arm64: timers: Move the timer IRQs into
 arch_timer_vm_data
Message-ID: <ZCUz9aZRLuEjWu59@linux.dev>
References: <20230324144704.4193635-1-maz@kernel.org>
 <20230324144704.4193635-12-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324144704.4193635-12-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 02:46:57PM +0000, Marc Zyngier wrote:
> Having the timer IRQs duplicated into each vcpu isn't great, and
> becomes absolutely awful with NV. So let's move these into
> the per-VM arch_timer_vm_data structure.
> 
> This simplifies a lot of code, but requires us to introduce a
> mutex so that we can reason about userspace trying to change
> an interrupt number while another vcpu is running, something
> that wasn't really well handled so far.
> 
> Reviewed-by: Colton Lewis <coltonlewis@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |   2 +
>  arch/arm64/kvm/arch_timer.c       | 104 +++++++++++++++++-------------
>  arch/arm64/kvm/arm.c              |   2 +
>  include/kvm/arm_arch_timer.h      |  18 ++++--
>  4 files changed, 78 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 116233a390e9..1280154c9ef3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -223,6 +223,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED		5
>  	/* VM counter offset */
>  #define KVM_ARCH_FLAG_VM_COUNTER_OFFSET			6
> +	/* Timer PPIs made immutable */
> +#define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE		7
>  
>  	unsigned long flags;
>  
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 7cd0b0947454..88a38d45d352 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -851,7 +851,6 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>  
>  	hrtimer_init(&ctxt->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
>  	ctxt->hrtimer.function = kvm_hrtimer_expire;
> -	timer_irq(ctxt) = default_ppi[timerid];
>  
>  	switch (timerid) {
>  	case TIMER_PTIMER:
> @@ -880,6 +879,13 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  	timer->bg_timer.function = kvm_bg_timer_expire;
>  }
>  
> +void kvm_timer_init_vm(struct kvm *kvm)
> +{
> +	mutex_init(&kvm->arch.timer_data.lock);
> +	for (int i = 0; i < NR_KVM_TIMERS; i++)
> +		kvm->arch.timer_data.ppi[i] = default_ppi[i];
> +}
> +
>  void kvm_timer_cpu_up(void)
>  {
>  	enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
> @@ -1292,44 +1298,52 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
>  
>  static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
>  {
> -	int vtimer_irq, ptimer_irq, ret;
> -	unsigned long i;
> +	u32 ppis = 0;
>  
> -	vtimer_irq = timer_irq(vcpu_vtimer(vcpu));
> -	ret = kvm_vgic_set_owner(vcpu, vtimer_irq, vcpu_vtimer(vcpu));
> -	if (ret)
> -		return false;
> +	mutex_lock(&vcpu->kvm->arch.timer_data.lock);
>  
> -	ptimer_irq = timer_irq(vcpu_ptimer(vcpu));
> -	ret = kvm_vgic_set_owner(vcpu, ptimer_irq, vcpu_ptimer(vcpu));
> -	if (ret)
> -		return false;
> +	for (int i = 0; i < NR_KVM_TIMERS; i++) {
> +		struct arch_timer_context *ctx;
> +		int irq;
>  
> -	kvm_for_each_vcpu(i, vcpu, vcpu->kvm) {
> -		if (timer_irq(vcpu_vtimer(vcpu)) != vtimer_irq ||
> -		    timer_irq(vcpu_ptimer(vcpu)) != ptimer_irq)
> -			return false;
> +		ctx = vcpu_get_timer(vcpu, i);
> +		irq = timer_irq(ctx);
> +		if (kvm_vgic_set_owner(vcpu, irq, ctx))
> +			break;
> +
> +		/*
> +		 * We know by construction that we only have PPIs, so
> +		 * all values are less than 32.
> +		 */
> +		ppis |= BIT(irq);
>  	}
>  
> -	return true;
> +	set_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE, &vcpu->kvm->arch.flags);
> +
> +	mutex_unlock(&vcpu->kvm->arch.timer_data.lock);
> +
> +	return hweight32(ppis) == NR_KVM_TIMERS;

Does it make sense to only set the IMMUTABLE flag if the timer IRQs are
indeed valid? I doubt userspace would do anything when it gets the
EINVAL, but it is possible userspace could make another attempt at
configuring the IRQs correctly.

I believe that was the existing behavior of the UAPI.

-- 
Thanks,
Oliver
