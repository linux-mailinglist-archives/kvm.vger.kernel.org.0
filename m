Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7744B6DC8BD
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDJPsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjDJPsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:48:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED21F1702
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:48:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a1b23f49e2so333055ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681141728; x=1683733728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7l4iSC8HJNX/jqwH9S8F8xmqISL1JNp40w8q5yq7MLA=;
        b=qOUMHH8KIB770gVMIvx2ktjfp8phYFhR7RAiQVXTyHFtVFQwG2HAwIF1kiScaToT5T
         l6AoygbdvcrFkzeFgeD18FWlVfyjo+joDv+nJJ4OX67Qf9OQlbh4NdNHZI9tE3bQ80Xs
         9kxJrAi77Qr9qZHGpgVAVs/rJoNou3Z2dzMpklo3UALJpZ/JDjZkjiwD7PPjxafmHllC
         7adieNkkiemzP/hGwRe+swYMjwo7WcHwVPzyMSlU2FuDnsZ2+lOhtKR8MGxVXhwck/vb
         XVv3rARqzfC6aucNdObDhXocLVDST4+REEO/60FYVtPrf4/Zl1LUNkh52t3DTWarh0DR
         VfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681141728; x=1683733728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7l4iSC8HJNX/jqwH9S8F8xmqISL1JNp40w8q5yq7MLA=;
        b=YxVh2mPRwHz4wai1HZvYMqf/OwzRy0JT85uPW5vI4XPPzs6fRtJj4vbCZ0OiPiVKsp
         LapdmjEyTjFENfVkLNV4SbmDwzHUYItWvFkP6oZA+IlywLKeOUpJVOrhCvWDvW9al1VE
         2zk1WLH4UceSFOzjatoKzXPJzM8MTrEQT9/WrSpdJgQYncsAkGZUBHUWKYP1nlrIYFbX
         NoxYdcQO0q1e871nY+NgW74pADe10SsI12e6U1VjCeBkRGq3jMtAOtwtO7zKV3i3Yoc4
         kzFz6ikOyYIM0hDxC6QOWTH/qsj3MAdVwgBDmFj1gPi4QQSLglDdTVqc/roW1yySNADU
         mD7g==
X-Gm-Message-State: AAQBX9foj6l4nZMZWoP9HnYuJuEWqwOuk/kYoaCKwk0749Um6F4n8Vu/
        eGSkbp7zHgAX9ZdQ5m9kex4T2w==
X-Google-Smtp-Source: AKy350Y2lFHxocTI2qcWzUlXOekKkmNQbHsXKYtTNzae4FZttTk+OhuiKvvLIaVSc6k6NM18AnKqsg==
X-Received: by 2002:a17:902:d202:b0:1a1:c5e6:1177 with SMTP id t2-20020a170902d20200b001a1c5e61177mr529227ply.10.1681141728116;
        Mon, 10 Apr 2023 08:48:48 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090270c900b0019b089bc8d7sm5703143plt.78.2023.04.10.08.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 08:48:47 -0700 (PDT)
Date:   Mon, 10 Apr 2023 08:48:43 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: Re: [PATCH v4 04/20] KVM: arm64: timers: Use CNTPOFF_EL2 to offset
 the physical timer
Message-ID: <20230410154843.vin2tqxco2wwvu3f@google.com>
References: <20230330174800.2677007-1-maz@kernel.org>
 <20230330174800.2677007-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330174800.2677007-5-maz@kernel.org>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Mar 30, 2023 at 06:47:44PM +0100, Marc Zyngier wrote:
> With ECV and CNTPOFF_EL2, it is very easy to offer an offset for
> the physical timer. So let's do just that.
> 
> Nothing can set the offset yet, so this should have no effect
> whatsoever (famous last words...).
> 
> Reviewed-by: Colton Lewis <coltonlewis@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arch_timer.c          | 18 +++++++++++++++++-
>  arch/arm64/kvm/hypercalls.c          |  2 +-
>  include/clocksource/arm_arch_timer.h |  1 +
>  include/kvm/arm_arch_timer.h         |  2 ++
>  4 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 9515c645f03d..3118ea0a1b41 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -52,6 +52,11 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
>  			      struct arch_timer_context *timer,
>  			      enum kvm_arch_timer_regs treg);
>  
> +static bool has_cntpoff(void)
> +{
> +	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
> +}
> +
>  u32 timer_get_ctl(struct arch_timer_context *ctxt)
>  {
>  	struct kvm_vcpu *vcpu = ctxt->vcpu;
> @@ -84,7 +89,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
>  
>  static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
> -	if (ctxt->offset.vm_offset)
> +	if (ctxt && ctxt->offset.vm_offset)
>  		return *ctxt->offset.vm_offset;

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Nit: This particular change appears to be unnecessary in this patch.
(needed in the following patches ?)

Thank you,
Reiji

>  
>  	return 0;
> @@ -432,6 +437,12 @@ static void set_cntvoff(u64 cntvoff)
>  	kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
>  }
>  
> +static void set_cntpoff(u64 cntpoff)
> +{
> +	if (has_cntpoff())
> +		write_sysreg_s(cntpoff, SYS_CNTPOFF_EL2);
> +}
> +
>  static void timer_save_state(struct arch_timer_context *ctx)
>  {
>  	struct arch_timer_cpu *timer = vcpu_timer(ctx->vcpu);
> @@ -480,6 +491,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
>  		write_sysreg_el0(0, SYS_CNTP_CTL);
>  		isb();
>  
> +		set_cntpoff(0);
>  		break;
>  	case NR_KVM_TIMERS:
>  		BUG();
> @@ -550,6 +562,7 @@ static void timer_restore_state(struct arch_timer_context *ctx)
>  		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTV_CTL);
>  		break;
>  	case TIMER_PTIMER:
> +		set_cntpoff(timer_get_offset(ctx));
>  		write_sysreg_el0(timer_get_cval(ctx), SYS_CNTP_CVAL);
>  		isb();
>  		write_sysreg_el0(timer_get_ctl(ctx), SYS_CNTP_CTL);
> @@ -767,6 +780,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  	vtimer->vcpu = vcpu;
>  	vtimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.voffset;
>  	ptimer->vcpu = vcpu;
> +	ptimer->offset.vm_offset = &vcpu->kvm->arch.timer_data.poffset;
>  
>  	/* Synchronize cntvoff across all vtimers of a VM. */
>  	timer_set_offset(vtimer, kvm_phys_timer_read());
> @@ -1297,6 +1311,8 @@ void kvm_timer_init_vhe(void)
>  	val = read_sysreg(cnthctl_el2);
>  	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
>  	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
> +	if (cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF))
> +		val |= CNTHCTL_ECV;
>  	write_sysreg(val, cnthctl_el2);
>  }
>  
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 5da884e11337..39a4707e081d 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -47,7 +47,7 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>  		cycles = systime_snapshot.cycles - vcpu->kvm->arch.timer_data.voffset;
>  		break;
>  	case KVM_PTP_PHYS_COUNTER:
> -		cycles = systime_snapshot.cycles;
> +		cycles = systime_snapshot.cycles - vcpu->kvm->arch.timer_data.poffset;
>  		break;
>  	default:
>  		return;
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 057c8964aefb..cbbc9a6dc571 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -21,6 +21,7 @@
>  #define CNTHCTL_EVNTEN			(1 << 2)
>  #define CNTHCTL_EVNTDIR			(1 << 3)
>  #define CNTHCTL_EVNTI			(0xF << 4)
> +#define CNTHCTL_ECV			(1 << 12)
>  
>  enum arch_timer_reg {
>  	ARCH_TIMER_REG_CTRL,
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 70d47c4adc6a..2dd0fd2406fb 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -34,6 +34,8 @@ struct arch_timer_offset {
>  struct arch_timer_vm_data {
>  	/* Offset applied to the virtual timer/counter */
>  	u64	voffset;
> +	/* Offset applied to the physical timer/counter */
> +	u64	poffset;
>  };
>  
>  struct arch_timer_context {
> -- 
> 2.34.1
> 
