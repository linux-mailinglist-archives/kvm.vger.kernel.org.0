Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3ED3DFF55
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 12:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbhHDKTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 06:19:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235522AbhHDKTV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 06:19:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628072348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JpNym3PhHBiG2R7OBr9EbOywreJxnv7DJQK3hgv/PcA=;
        b=Qy8nHwoPvzjqk0HrVIjnThJsp9Et/zd5Gua8uVq7EJFYe4ip6HAFG/tRUAYbvFfSQ4V2Tq
        Rs9qBWepMnP/qAd7mv+xGxt18GyXtfyVrKVIEiprwh6z8lU6Ar4f6VEgN44gvLLUHLdRdF
        nnxlYOgDQtslbnglZVdqvMBnrLIuYEQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-I80oAytYORKfLtIrS0QM8Q-1; Wed, 04 Aug 2021 06:19:07 -0400
X-MC-Unique: I80oAytYORKfLtIrS0QM8Q-1
Received: by mail-ed1-f69.google.com with SMTP id cm18-20020a0564020c92b02903bc7f21d540so1209711edb.13
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 03:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JpNym3PhHBiG2R7OBr9EbOywreJxnv7DJQK3hgv/PcA=;
        b=H2RSLcZkG+j1YZpfZkfAoc6vhMQ1BFUu/tK4LVLSpXepGFBuepqf8ZwZUrMdaRvGGS
         6fzoE6bJblpY6wt3xGCOs/TvZ+icfckfDV0zgaB4PzhDq1OZfS1K6Av3bk3LxpssCrtp
         5PQ94Yco5fqbfpYUB/hNENmM/BFBXmcilZX8qegT6zsS9TosQl97O4DKEykO6knXgXXG
         o8k/7kjT5yo0ewc+ffVblhQGRZC5T/Qkp8htWdTZtgnPFEDYnopsu6rtWhp8dsJ8KjTm
         H1Oyptwl1R29oaa+nv49GXJ7Bl5zFW6hefhlM+iCLPX9ZXh8Qhr/3m/h+B4B5RLZrBdD
         VPjw==
X-Gm-Message-State: AOAM531lbAvok/HKeBBXcMM9yNAW20w+3jaPaVVlK/cvRyTJ/M89S7Nk
        xG3saChzUapTnuUay4iL8hZ2VtUzcKjNfyTGgYlcZ/4M+NTnVOAjUcy/444akFaNN/4EGfpsBau
        AWE9mm5oUO89N
X-Received: by 2002:a05:6402:22b0:: with SMTP id cx16mr31181348edb.185.1628072346269;
        Wed, 04 Aug 2021 03:19:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynmhEZkIMhWx+PRVqGR61bwf7cgXKe96j5baJK90yrMt+GBIqVMmzYMWmFgf1rT3lH7xIO0w==
X-Received: by 2002:a05:6402:22b0:: with SMTP id cx16mr31181329edb.185.1628072346086;
        Wed, 04 Aug 2021 03:19:06 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id r27sm762827edb.66.2021.08.04.03.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 03:19:05 -0700 (PDT)
Date:   Wed, 4 Aug 2021 12:19:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 12/21] KVM: arm64: Separate guest/host counter offset
 values
Message-ID: <20210804101903.3grfwrv5mlm5sydd@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-13-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804085819.846610-13-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 08:58:10AM +0000, Oliver Upton wrote:
> In some instances, a VMM may want to update the guest's counter-timer
> offset in a transparent manner, meaning that changes to the hardware
> value do not affect the synthetic register presented to the guest or the
> VMM through said guest's architectural state. Lay the groundwork to
> separate guest offset register writes from the hardware values utilized
> by KVM.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arch_timer.c  | 48 ++++++++++++++++++++++++++++++++----
>  include/kvm/arm_arch_timer.h |  3 +++
>  2 files changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index c0101db75ad4..4c2b763a8849 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -87,6 +87,18 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  	struct kvm_vcpu *vcpu = ctxt->vcpu;
>  
>  	switch(arch_timer_ctx_index(ctxt)) {
> +	case TIMER_VTIMER:
> +		return ctxt->host_offset;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static u64 timer_get_guest_offset(struct arch_timer_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +	switch (arch_timer_ctx_index(ctxt)) {
>  	case TIMER_VTIMER:
>  		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
>  	default:
> @@ -132,13 +144,31 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  
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
> @@ -749,7 +779,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>  
>  /* Make offset updates for all timer contexts atomic */
>  static void update_timer_offset(struct kvm_vcpu *vcpu,
> -				enum kvm_arch_timers timer, u64 offset)
> +				enum kvm_arch_timers timer, u64 offset,
> +				bool guest_visible)
>  {
>  	int i;
>  	struct kvm *kvm = vcpu->kvm;
> @@ -758,13 +789,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
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
> @@ -772,7 +810,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
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
>  };
>  
>  struct timer_map {
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

