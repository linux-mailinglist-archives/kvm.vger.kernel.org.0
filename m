Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B173DFF61
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 12:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbhHDKZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 06:25:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44310 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235383AbhHDKZ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 06:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628072744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/dh0XveA2tRdR86ekoEcjKfOMTNwMf1qc/oepL3g3Eo=;
        b=JdI1aph3UrxICv1LwegqGsJ1nfBdlZyDn2N5fQdCDKnJ7FuTB3nk7mBV3o10HcQKl53cwd
        +AvoGx+BBHTueKm04oXJeHxyvnx2sE75Q6UdAFJIvQq0+bg2n8tZkoO20F7en6iYm6OCAP
        KVbdTNlNTq1hdo/eAmC3Atu0IHtdT4w=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-ZjH4E-InPFi66sSr0CEoWA-1; Wed, 04 Aug 2021 06:25:43 -0400
X-MC-Unique: ZjH4E-InPFi66sSr0CEoWA-1
Received: by mail-ed1-f70.google.com with SMTP id eg53-20020a05640228b5b02903bd6e6f620cso1207686edb.23
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 03:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/dh0XveA2tRdR86ekoEcjKfOMTNwMf1qc/oepL3g3Eo=;
        b=ciNRkazyqArYvLgMkmRY8hb9aXdmSlS/Kzf1z+SaR7ci0WnVJy5h8AiDcX6EM6bKgB
         21qHbbeTeCRU9wmz8ZiUUxBl8HRb9TE4iew1IEiNO2wiiwIuaYLx6eOJmsiimYF7qUWw
         HvZVahO47UujcPKTGehokHn4tvKWJQdPG+rE6kTxNFIun+YKm1S2/6OXRF4B/B7EQ35i
         O2aFNMohRVxLsBhHUBdZMdjknNAY66AFGPtdjj9ZBr9D83dTN0H646c152kZUxsFfh1D
         uF/4zz4DcE1RhSDurd0nXsbW8A+KEPXB6GprQcc1dNy+BqOXfcQ6s4vwqPdFpAmXoBCN
         fdhg==
X-Gm-Message-State: AOAM53306dvoOy7gRtmps9gaKbEqywsNVVHlsHMRWAeznZqaK7MUmsGP
        pAPZmj+bGXjFGgTjRCfy+vC4xnLh8jBx8s0YzooQI5t0fAzXdfIns8BjtYUBcxftC62xb2Y6Nka
        2Npx3xUV353GK
X-Received: by 2002:a50:8d8c:: with SMTP id r12mr31140623edh.99.1628072742227;
        Wed, 04 Aug 2021 03:25:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhWkWNUQ6HtRYDgaJL2+7vGqrK616hPjU3P+qoXMZQXZlcYgAGMb+FE/+6EFllwfEXAiURHQ==
X-Received: by 2002:a50:8d8c:: with SMTP id r12mr31140602edh.99.1628072742037;
        Wed, 04 Aug 2021 03:25:42 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id q11sm550145ejb.10.2021.08.04.03.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 03:25:41 -0700 (PDT)
Date:   Wed, 4 Aug 2021 12:25:39 +0200
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
Subject: Re: [PATCH v6 18/21] KVM: arm64: Configure timer traps in
 vcpu_load() for VHE
Message-ID: <20210804102539.yczeevsaqlhptgib@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-19-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804085819.846610-19-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 08:58:16AM +0000, Oliver Upton wrote:
> In preparation for emulated physical counter-timer offsetting, configure
> traps on every vcpu_load() for VHE systems. As before, these trap
> settings do not affect host userspace, and are only active for the
> guest.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arch_timer.c  | 10 +++++++---
>  arch/arm64/kvm/arm.c         |  4 +---
>  include/kvm/arm_arch_timer.h |  2 --
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index f15058612994..9ead94aa867d 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -51,6 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
>  static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>  			      struct arch_timer_context *timer,
>  			      enum kvm_arch_timer_regs treg);
> +static void kvm_timer_enable_traps_vhe(void);
>  
>  u32 timer_get_ctl(struct arch_timer_context *ctxt)
>  {
> @@ -668,6 +669,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
>  
>  	if (map.emul_ptimer)
>  		timer_emulate(map.emul_ptimer);
> +
> +	if (has_vhe())
> +		kvm_timer_enable_traps_vhe();
>  }
>  
>  bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
> @@ -1383,12 +1387,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  }
>  
>  /*
> - * On VHE system, we only need to configure the EL2 timer trap register once,
> - * not for every world switch.
> + * On VHE system, we only need to configure the EL2 timer trap register on
> + * vcpu_load(), but not every world switch into the guest.
>   * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
>   * and this makes those bits have no effect for the host kernel execution.
>   */
> -void kvm_timer_init_vhe(void)
> +static void kvm_timer_enable_traps_vhe(void)
>  {
>  	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
>  	u32 cnthctl_shift = 10;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..47ea1e1ba80b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1558,9 +1558,7 @@ static void cpu_hyp_reinit(void)
>  
>  	cpu_hyp_reset();
>  
> -	if (is_kernel_in_hyp_mode())
> -		kvm_timer_init_vhe();
> -	else
> +	if (!is_kernel_in_hyp_mode())
>  		cpu_init_hyp_mode();
>  
>  	cpu_set_hyp_vector();
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 615f9314f6a5..254653b42da0 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -87,8 +87,6 @@ u64 kvm_phys_timer_read(void);
>  void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
>  
> -void kvm_timer_init_vhe(void);
> -
>  bool kvm_arch_timer_get_input_level(int vintid);
>  
>  #define vcpu_timer(v)	(&(v)->arch.timer_cpu)
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

