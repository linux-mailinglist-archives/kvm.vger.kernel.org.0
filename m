Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D22C5ACBCC
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 09:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiIEHFT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 03:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236854AbiIEHFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 03:05:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E615930F7A;
        Mon,  5 Sep 2022 00:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662361515; x=1693897515;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dSaImXYJDFJBjVkAy9D9i/aVykAxDgVnwzzvJ+cCifE=;
  b=caaVPj9U2W+gjdGcviWv1oL7xoABbkUz0qMJn7UUkt68VsMYYi+UhCMk
   Qtz10BQ4wNukKrqHaiP3AILdWQue6xv5nexnidmhOqd45Je1L2S8GiH+k
   W6MfYS32hh++6cDrmE4UJkgYkUX2JzvZiDtjTqvZ9NFM7B3Au0oI1IyqM
   Nxv1gbLDMT7gmM/p8lx2viF1hTkVT+afYX2LZQagdlEaeOjKo8f2v4vBp
   8GZiIlJAs4b/k6UB5hv+YCx9NfnDk5XoLMqAflzWPoteNc7wrITYn8SZf
   R6Z+TiWjTCO2fdke3pIPXZdUCwMcm0Og/zxyWxsm0l40C+uJt/10tO4Oq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="293908122"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="293908122"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2022 00:05:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="643690288"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga008.jf.intel.com with ESMTP; 05 Sep 2022 00:05:10 -0700
Date:   Mon, 5 Sep 2022 15:05:09 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 06/22] KVM: arm64: Simplify the CPUHP logic
Message-ID: <20220905070509.f5neutyqgvbklefi@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <72481a7bc0ff08093f4f0f04cece877ee82de0cf.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72481a7bc0ff08093f4f0f04cece877ee82de0cf.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:41PM -0700, isaku.yamahata@intel.com wrote:
> From: Marc Zyngier <maz@kernel.org>
>
> For a number of historical reasons, the KVM/arm64 hotplug setup is pretty
> complicated, and we have two extra CPUHP notifiers for vGIC and timers.
>
> It looks pretty pointless, and gets in the way of further changes.
> So let's just expose some helpers that can be called from the core
> CPUHP callback, and get rid of everything else.
>
> This gives us the opportunity to drop a useless notifier entry,
> as well as tidy-up the timer enable/disable, which was a bit odd.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Link: https://lore.kernel.org/r/20220216031528.92558-5-chao.gao@intel.com
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/arm64/kvm/arch_timer.c     | 27 ++++++++++-----------------
>  arch/arm64/kvm/arm.c            |  4 ++++
>  arch/arm64/kvm/vgic/vgic-init.c | 19 ++-----------------
>  include/kvm/arm_arch_timer.h    |  4 ++++
>  include/kvm/arm_vgic.h          |  4 ++++
>  include/linux/cpuhotplug.h      |  3 ---
>  6 files changed, 24 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index bb24a76b4224..33fca1a691a5 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -811,10 +811,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>  	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
>  }
>
> -static void kvm_timer_init_interrupt(void *info)
> +void kvm_timer_cpu_up(void)
>  {
>  	enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
> -	enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
> +	if (host_ptimer_irq)
> +		enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
> +}
> +
> +void kvm_timer_cpu_down(void)
> +{
> +	disable_percpu_irq(host_vtimer_irq);
> +	if (host_ptimer_irq)
> +		disable_percpu_irq(host_ptimer_irq);
>  }

Should "host_vtimer_irq" be checked yet as host_ptimer_irq ?  Because
the host_{v,p}timer_irq is set in same function kvm_irq_init() which
called AFTER the on_each_cpu(_kvm_arch_hardware_enable, NULL, 1) from
init_subsystems():

kvm_init()
  kvm_arch_init()
    init_subsystems()
      on_each_cpu(_kvm_arch_hardware_enable, NULL, 1);
      kvm_timer_hyp_init()
        kvm_irq_init()
          host_vtimer_irq = info->virtual_irq;
          host_ptimer_irq = info->physical_irq;
  hardware_enable_all()

>
>  int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
> @@ -976,18 +984,6 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
>  	preempt_enable();
>  }
>
> -static int kvm_timer_starting_cpu(unsigned int cpu)
> -{
> -	kvm_timer_init_interrupt(NULL);
> -	return 0;
> -}
> -
> -static int kvm_timer_dying_cpu(unsigned int cpu)
> -{
> -	disable_percpu_irq(host_vtimer_irq);
> -	return 0;
> -}
> -
>  static int timer_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
>  {
>  	if (vcpu)
> @@ -1185,9 +1181,6 @@ int kvm_timer_hyp_init(bool has_gic)
>  		goto out_free_irq;
>  	}
>
> -	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
> -			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
> -			  kvm_timer_dying_cpu);
>  	return 0;
>  out_free_irq:
>  	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3385fb57c11a..0a2f616c4d63 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1670,6 +1670,8 @@ static void _kvm_arch_hardware_enable(void *discard)
>  {
>  	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
>  		cpu_hyp_reinit();
> +		kvm_vgic_cpu_up();
> +		kvm_timer_cpu_up();
>  		__this_cpu_write(kvm_arm_hardware_enabled, 1);
>  	}
>  }
> @@ -1683,6 +1685,8 @@ int kvm_arch_hardware_enable(void)
>  static void _kvm_arch_hardware_disable(void *discard)
>  {
>  	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> +		kvm_timer_cpu_down();
> +		kvm_vgic_cpu_down();
>  		cpu_hyp_reset();
>  		__this_cpu_write(kvm_arm_hardware_enabled, 0);
>  	}
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index f6d4f4052555..6c7f6ae21ec0 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -465,17 +465,15 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>
>  /* GENERIC PROBE */
>
> -static int vgic_init_cpu_starting(unsigned int cpu)
> +void kvm_vgic_cpu_up(void)
>  {
>  	enable_percpu_irq(kvm_vgic_global_state.maint_irq, 0);
> -	return 0;
>  }
>
>
> -static int vgic_init_cpu_dying(unsigned int cpu)
> +void kvm_vgic_cpu_down(void)
>  {
>  	disable_percpu_irq(kvm_vgic_global_state.maint_irq);
> -	return 0;
>  }
>
>  static irqreturn_t vgic_maintenance_handler(int irq, void *data)
> @@ -584,19 +582,6 @@ int kvm_vgic_hyp_init(void)
>  		return ret;
>  	}
>
> -	ret = cpuhp_setup_state(CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
> -				"kvm/arm/vgic:starting",
> -				vgic_init_cpu_starting, vgic_init_cpu_dying);
> -	if (ret) {
> -		kvm_err("Cannot register vgic CPU notifier\n");
> -		goto out_free_irq;
> -	}
> -
>  	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
>  	return 0;
> -
> -out_free_irq:
> -	free_percpu_irq(kvm_vgic_global_state.maint_irq,
> -			kvm_get_running_vcpus());
> -	return ret;
>  }
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index cd6d8f260eab..1638418f72dd 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -104,4 +104,8 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
>  u32 timer_get_ctl(struct arch_timer_context *ctxt);
>  u64 timer_get_cval(struct arch_timer_context *ctxt);
>
> +/* CPU HP callbacks */
> +void kvm_timer_cpu_up(void);
> +void kvm_timer_cpu_down(void);
> +
>  #endif
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 4df9e73a8bb5..fc4acc91ba06 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -431,4 +431,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
>  void vgic_v4_commit(struct kvm_vcpu *vcpu);
>  int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
>
> +/* CPU HP callbacks */
> +void kvm_vgic_cpu_up(void);
> +void kvm_vgic_cpu_down(void);
> +
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index f61447913db9..7337414e4947 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -186,9 +186,6 @@ enum cpuhp_state {
>  	CPUHP_AP_TI_GP_TIMER_STARTING,
>  	CPUHP_AP_HYPERV_TIMER_STARTING,
>  	CPUHP_AP_KVM_STARTING,
> -	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
> -	CPUHP_AP_KVM_ARM_VGIC_STARTING,
> -	CPUHP_AP_KVM_ARM_TIMER_STARTING,
>  	/* Must be the last timer callback */
>  	CPUHP_AP_DUMMY_TIMER_STARTING,
>  	CPUHP_AP_ARM_XEN_STARTING,
> --
> 2.25.1
>
