Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C0D22D1
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 10:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733253AbfJJIbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 04:31:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57195 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbfJJIbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 04:31:19 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3C7911A22
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 08:31:18 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id v17so2369508wru.12
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 01:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dnxA342uWQGojBc2trI0QZPTLR8iPWlQv7iUQgbZnxo=;
        b=aTnaV5ynRdKJ2rgCJgYwEJUGE8CIqMVRutz8w+Z+2BfU1yAiRvQcf8oHffpEmedtu0
         ISVXt0asog2QOM4Gn/8oFgjSWGhBWpFNst56T8iKrARB+spxGb4/DVdnspKbqt8jtNcK
         Ld517H2bdOxJyfmX4hyxb7YVtzMYZvckvmbbPf7rlSBF4q4qMxzkho5h62zRMK6WY8HO
         +xNTvPa6dK2EzLZHctSTKjl8WCvLlWW9wKqGbbjffXTyHzq6uGF6qsOQpzcaONt52rTC
         ilugPZGqwkH4kZquNsC1yEJzdtVAu7qofgqiEgAQek/irl+NPzYajDzfwGd+OVkYtbzr
         xWKA==
X-Gm-Message-State: APjAAAVAfD2hb3a26XvRL+H4F9fWXpXlsLhOaWBqJtVcXomp4Bdncy/T
        CBfhKsrWTzBlbXln40JHrqBt92jalSkg46UC0+nqe3aw4vmvxdeznX8oQ+E/Ci2zU7izAbLtIXC
        n86Igd2vK3G35
X-Received: by 2002:a05:6000:11cc:: with SMTP id i12mr7557587wrx.241.1570696277524;
        Thu, 10 Oct 2019 01:31:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxcoEwqyOpgdABShTXsK2c7PElGcMyZ78gwFcFLBMKOwWSikEuQunfReN0aH+kZaOM5HXg0KQ==
X-Received: by 2002:a05:6000:11cc:: with SMTP id i12mr7557558wrx.241.1570696277187;
        Thu, 10 Oct 2019 01:31:17 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id l6sm3569647wmg.2.2019.10.10.01.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:31:16 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suleiman Souhlal <suleiman@google.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ssouhlal@freebsd.org, tfiga@chromium.org,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC v2 1/2] kvm: Mechanism to copy host timekeeping parameters into guest.
In-Reply-To: <20191010073055.183635-2-suleiman@google.com>
References: <20191010073055.183635-1-suleiman@google.com> <20191010073055.183635-2-suleiman@google.com>
Date:   Thu, 10 Oct 2019 10:31:15 +0200
Message-ID: <87zhi96lyk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suleiman Souhlal <suleiman@google.com> writes:

> This is used to synchronize time between host and guest.
> The guest can request the (guest) physical address it wants the
> data in through the MSR_KVM_TIMEKEEPER_EN MSR.
>
> It currently assumes the host timekeeper is "tsc".
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h      |   3 +
>  arch/x86/include/asm/pvclock-abi.h   |  27 ++++++
>  arch/x86/include/uapi/asm/kvm_para.h |   1 +
>  arch/x86/kvm/x86.c                   | 121 +++++++++++++++++++++++++++
>  4 files changed, 152 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 50eb430b0ad8..4d622450cb4a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -659,7 +659,10 @@ struct kvm_vcpu_arch {
>  	struct pvclock_vcpu_time_info hv_clock;
>  	unsigned int hw_tsc_khz;
>  	struct gfn_to_hva_cache pv_time;
> +	struct gfn_to_hva_cache pv_timekeeper_g2h;
> +	struct pvclock_timekeeper pv_timekeeper;
>  	bool pv_time_enabled;
> +	bool pv_timekeeper_enabled;
>  	/* set guest stopped flag in pvclock flags field */
>  	bool pvclock_set_guest_stopped_request;
>  
> diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
> index 1436226efe3e..2809008b9b26 100644
> --- a/arch/x86/include/asm/pvclock-abi.h
> +++ b/arch/x86/include/asm/pvclock-abi.h
> @@ -40,6 +40,33 @@ struct pvclock_wall_clock {
>  	u32   nsec;
>  } __attribute__((__packed__));
>  
> +struct pvclock_read_base {
> +	u64 mask;
> +	u64 cycle_last;
> +	u32 mult;
> +	u32 shift;
> +	u64 xtime_nsec;
> +	u64 base;
> +} __attribute__((__packed__));
> +
> +struct pvclock_timekeeper {
> +	u64 gen;
> +	u64 flags;
> +	struct pvclock_read_base tkr_mono;
> +	struct pvclock_read_base tkr_raw;
> +	u64 xtime_sec;
> +	u64 ktime_sec;
> +	u64 wall_to_monotonic_sec;
> +	u64 wall_to_monotonic_nsec;
> +	u64 offs_real;
> +	u64 offs_boot;
> +	u64 offs_tai;
> +	u64 raw_sec;
> +	u64 tsc_offset;
> +} __attribute__((__packed__));
> +

AFAIU these structures mirror struct tk_read_base and struct timekeeper
but these are intenal to timekeeper so the risk I see is: we decide to
change timekeeper internals and these structures become hard-to-mirror
so I'd think about versioning them from the very beginning, e.g.: host
reports supported timekeer versions in MSR_KVM_TIMEKEEPER_EN (renamed)
and then guest asks for a particular version. This way we can deprecate
old versions eventually.

> +#define	PVCLOCK_TIMEKEEPER_ENABLED (1 << 0)
> +
>  #define PVCLOCK_TSC_STABLE_BIT	(1 << 0)
>  #define PVCLOCK_GUEST_STOPPED	(1 << 1)
>  /* PVCLOCK_COUNTS_FROM_ZERO broke ABI and can't be used anymore. */
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 2a8e0b6b9805..3ebb1d87db3a 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -50,6 +50,7 @@
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
>  #define MSR_KVM_PV_EOI_EN      0x4b564d04
>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
> +#define MSR_KVM_TIMEKEEPER_EN	0x4b564d06
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf38526..937f83cdda4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -157,6 +157,8 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
>  int __read_mostly pi_inject_timer = -1;
>  module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  
> +static atomic_t pv_timekeepers_nr;
> +
>  #define KVM_NR_SHARED_MSRS 16
>  
>  struct kvm_shared_msrs_global {
> @@ -2729,6 +2731,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  		break;
>  	}
> +	case MSR_KVM_TIMEKEEPER_EN:
> +		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
> +		    &vcpu->arch.pv_timekeeper_g2h, data,
> +		    sizeof(struct pvclock_timekeeper)))
> +			vcpu->arch.pv_timekeeper_enabled = false;
> +		else {
> +			vcpu->arch.pv_timekeeper_enabled = true;
> +			atomic_inc(&pv_timekeepers_nr);
> +		}
> +		break;
>  	case MSR_KVM_ASYNC_PF_EN:
>  		if (kvm_pv_enable_async_pf(vcpu, data))
>  			return 1;
> @@ -7097,6 +7109,109 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
>  };
>  
>  #ifdef CONFIG_X86_64
> +static DEFINE_SPINLOCK(shadow_pvtk_lock);
> +static struct pvclock_timekeeper shadow_pvtk;
> +
> +static void
> +pvclock_copy_read_base(struct pvclock_read_base *pvtkr,
> +    struct tk_read_base *tkr)
> +{
> +	pvtkr->cycle_last = tkr->cycle_last;
> +	pvtkr->mult = tkr->mult;
> +	pvtkr->shift = tkr->shift;
> +	pvtkr->mask = tkr->mask;
> +	pvtkr->xtime_nsec = tkr->xtime_nsec;
> +	pvtkr->base = tkr->base;
> +}
> +
> +static void
> +kvm_copy_into_pvtk(struct kvm_vcpu *vcpu)
> +{
> +	struct pvclock_timekeeper *pvtk;
> +	unsigned long flags;
> +
> +	if (!vcpu->arch.pv_timekeeper_enabled)
> +		return;
> +
> +	pvtk = &vcpu->arch.pv_timekeeper;
> +	if (pvclock_gtod_data.clock.vclock_mode == VCLOCK_TSC) {
> +		pvtk->flags |= PVCLOCK_TIMEKEEPER_ENABLED;
> +		spin_lock_irqsave(&shadow_pvtk_lock, flags);
> +		pvtk->tkr_mono = shadow_pvtk.tkr_mono;
> +		pvtk->tkr_raw = shadow_pvtk.tkr_raw;
> +
> +		pvtk->xtime_sec = shadow_pvtk.xtime_sec;
> +		pvtk->ktime_sec = shadow_pvtk.ktime_sec;
> +		pvtk->wall_to_monotonic_sec =
> +		    shadow_pvtk.wall_to_monotonic_sec;
> +		pvtk->wall_to_monotonic_nsec =
> +		    shadow_pvtk.wall_to_monotonic_nsec;
> +		pvtk->offs_real = shadow_pvtk.offs_real;
> +		pvtk->offs_boot = shadow_pvtk.offs_boot;
> +		pvtk->offs_tai = shadow_pvtk.offs_tai;
> +		pvtk->raw_sec = shadow_pvtk.raw_sec;
> +		spin_unlock_irqrestore(&shadow_pvtk_lock, flags);
> +
> +		pvtk->tsc_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
> +	} else
> +		pvtk->flags &= ~PVCLOCK_TIMEKEEPER_ENABLED;
> +
> +	BUILD_BUG_ON(offsetof(struct pvclock_timekeeper, gen) != 0);
> +
> +	/*
> +	 * Make the gen count odd to indicate we are in the process of
> +	 * updating.
> +	 */
> +	vcpu->arch.pv_timekeeper.gen++;
> +	vcpu->arch.pv_timekeeper.gen |= 1;
> +
> +	/*
> +	 * See comment in kvm_guest_time_update() for why we have to do
> +	 * multiple writes.
> +	 */
> +	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_timekeeper_g2h,
> +	    &vcpu->arch.pv_timekeeper, sizeof(vcpu->arch.pv_timekeeper.gen));
> +
> +	smp_wmb();
> +
> +	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_timekeeper_g2h,
> +	    &vcpu->arch.pv_timekeeper, sizeof(vcpu->arch.pv_timekeeper));
> +
> +	smp_wmb();
> +
> +	vcpu->arch.pv_timekeeper.gen++;
> +
> +	kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.pv_timekeeper_g2h,
> +	    &vcpu->arch.pv_timekeeper, sizeof(vcpu->arch.pv_timekeeper.gen));
> +}
> +
> +static void
> +update_shadow_pvtk(struct timekeeper *tk)
> +{
> +	struct pvclock_timekeeper *pvtk;
> +	unsigned long flags;
> +
> +	pvtk = &shadow_pvtk;
> +
> +	if (atomic_read(&pv_timekeepers_nr) == 0 ||
> +	    pvclock_gtod_data.clock.vclock_mode != VCLOCK_TSC)
> +		return;
> +
> +	spin_lock_irqsave(&shadow_pvtk_lock, flags);
> +	pvclock_copy_read_base(&pvtk->tkr_mono, &tk->tkr_mono);
> +	pvclock_copy_read_base(&pvtk->tkr_raw, &tk->tkr_raw);
> +
> +	pvtk->xtime_sec = tk->xtime_sec;
> +	pvtk->ktime_sec = tk->ktime_sec;
> +	pvtk->wall_to_monotonic_sec = tk->wall_to_monotonic.tv_sec;
> +	pvtk->wall_to_monotonic_nsec = tk->wall_to_monotonic.tv_nsec;
> +	pvtk->offs_real = tk->offs_real;
> +	pvtk->offs_boot = tk->offs_boot;
> +	pvtk->offs_tai = tk->offs_tai;
> +	pvtk->raw_sec = tk->raw_sec;
> +	spin_unlock_irqrestore(&shadow_pvtk_lock, flags);
> +}
> +
>  static void pvclock_gtod_update_fn(struct work_struct *work)
>  {
>  	struct kvm *kvm;
> @@ -7124,6 +7239,7 @@ static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
>  	struct timekeeper *tk = priv;
>  
>  	update_pvclock_gtod(tk);
> +	update_shadow_pvtk(tk);
>  
>  	/* disable master clock if host does not trust, or does not
>  	 * use, TSC based clocksource.
> @@ -7940,6 +8056,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	bool req_immediate_exit = false;
>  
> +	kvm_copy_into_pvtk(vcpu);

It doesn't matter for pvclock_gtod_update_fn() but vcpu_enter_guest() is
performance critical. I would suggest to introduce a static key to avoid
this completely when no guest is using this new timekeeper.

> +
>  	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu))
>  			kvm_x86_ops->get_vmcs12_pages(vcpu);
> @@ -9020,6 +9138,9 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
>  
>  	kvmclock_reset(vcpu);
>  
> +	if (vcpu->arch.pv_timekeeper_enabled)
> +		atomic_dec(&pv_timekeepers_nr);
> +
>  	kvm_x86_ops->vcpu_free(vcpu);
>  	free_cpumask_var(wbinvd_dirty_mask);
>  }

-- 
Vitaly
