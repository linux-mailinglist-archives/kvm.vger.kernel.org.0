Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2833310FB5
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhBEQdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:33:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:49244 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbhBEQaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 11:30:19 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612548718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8qV9v/K2lxNxsR8YJvL5ct/YqU7RQt8EG0Rbp/C23iI=;
        b=jniSzr8Lu2VBdkiUvXjjlf22cCfgEGwW1BmLpWnxEPeC3O//srmHOOaA0qPrJl777qpnRe
        PHn0odrgZVD0TgzwljCilGHLOMhKGYlo850z9aQUER0vWc+WEGEU19ejjICfks48hzJNAs
        7m1cAqZN9He8ayFfRRA4aGKIUe7wio4tBLgnVj02NWgL3ZyS75x7BYabHesudxNWH+IWpF
        3/UjnPO4qPWAckb25DFeSMEDLUIZm5BnX5Onfc9qoCQzLKEYH3JLGprW1N+OdmSEISzQcV
        AlEZ3OagRI5z7Ei8ht0p6EV1hXxrHeRl1uVd4X/w9SGsOId47k4j4lOXVdVIEw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612548718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8qV9v/K2lxNxsR8YJvL5ct/YqU7RQt8EG0Rbp/C23iI=;
        b=VPjqPm5SndO3SvjK6y7I7e35S8P5Rl0EQnoiMmcg5IgyYlMqtyCZAXePVzzEdkz2/nghGa
        QfpTsfCRx2wmuGDQ==
To:     Zhimin Feng <fengzhimin@bytedance.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, fweisbec@gmail.com,
        zhouyibo@bytedance.com, zhanghaozhong@bytedance.com,
        Zhimin Feng <fengzhimin@bytedance.com>
Subject: Re: [RFC: timer passthrough 1/9] KVM: vmx: hook set_next_event for getting the host tscd
In-Reply-To: <20210205100317.24174-2-fengzhimin@bytedance.com>
References: <20210205100317.24174-1-fengzhimin@bytedance.com> <20210205100317.24174-2-fengzhimin@bytedance.com>
Date:   Fri, 05 Feb 2021 19:11:58 +0100
Message-ID: <87ft2a8jv5.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05 2021 at 18:03, Zhimin Feng wrote:
> @@ -520,6 +521,24 @@ struct kvm_vcpu_hv {
>  	cpumask_t tlb_flush;
>  };
>  
> +enum tick_device_mode {
> +	TICKDEV_MODE_PERIODIC,
> +	TICKDEV_MODE_ONESHOT,
> +};
> +
> +struct tick_device {
> +	struct clock_event_device *evtdev;
> +	enum tick_device_mode mode;
> +};

There is a reason why these things are defined in a header file which is
not public. Nothing outside of kernel/time/ has to fiddle with
this. Aside of that how are these things supposed to stay in sync?

> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 6c9c342dd0e5..bc50f4a1a7c0 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -26,6 +26,7 @@
>   * Tick devices
>   */
>  DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
> +EXPORT_SYMBOL_GPL(tick_cpu_device);

Not going to happen ever.

> +#define TSC_DIVISOR  8
> +static DEFINE_PER_CPU(struct timer_passth_info, passth_info);
> +
> +static int override_lapic_next_event(unsigned long delta,
> +		struct clock_event_device *evt)
> +{
> +	struct timer_passth_info *local_timer_info;
> +	u64 tsc;
> +	u64 tscd;
> +
> +	local_timer_info = &per_cpu(passth_info, smp_processor_id());
> +	tsc = rdtsc();
> +	tscd = tsc + (((u64) delta) * TSC_DIVISOR);
> +	local_timer_info->host_tscd = tscd;
> +	wrmsrl(MSR_IA32_TSCDEADLINE, tscd);
> +	return 0;
> +}
> +
> +static void vmx_host_timer_passth_init(void *junk)
> +{
> +	struct timer_passth_info *local_timer_info;
> +	int cpu = smp_processor_id();
> +
> +	local_timer_info = &per_cpu(passth_info, cpu);
> +	local_timer_info->curr_dev = per_cpu(tick_cpu_device, cpu).evtdev;
> +	local_timer_info->orig_set_next_event =
> +		local_timer_info->curr_dev->set_next_event;
> +	local_timer_info->curr_dev->set_next_event = override_lapic_next_event;

So when loading the KVM module you steal the set_next_event pointer of
the clock event device which is currently active. What guarantees that

    1) The current active device is the tsc deadline timer
    2) The active device does not change

Nothing.

Thanks,

        tglx
