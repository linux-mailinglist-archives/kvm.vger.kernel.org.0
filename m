Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBE1D25C6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 11:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbfJJIh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 04:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387443AbfJJIh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 04:37:56 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8BE08C0718BE
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 08:37:55 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id o8so2280283wmc.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 01:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xW15s2NstXaaA3qdwg/G4PRC3BhEpCuhnmS8SSNGd2E=;
        b=K1pDQFGwPEKw/XPRAocn0kNKjfqlxqLSW32B4/Ne2vEdIlOnSLKww2nVJtlOPKiheL
         PdQtkwDSkWTlngVXfSNTmllrE2rh0FzWOiIdQ/aDX8wtlfCALZil7jxLtigziP6ZsNl9
         rmenEeT8jCZaKFmQdXzz87XglIIliRfNlWmW0noGagRtObEmQq1qNltUT0BP701NNWVR
         R4ubvmUIU83ZcA+Fxsf/9MbjNnoHd0MFNShvdAc1nfyYnf1cn8Qxx/8wP2F1q34Zo/YT
         0mh1oxkmyzvpHS2mFtARsa/r9QXk1ONlNCQiFUZB1HYb34BnND1V5aJ+FQZnff9sfXi+
         tF7w==
X-Gm-Message-State: APjAAAW2cZW25hBUSOGOwgM2p+0veHnVvGkRk1byDb4j9JxCKP6jsMGZ
        a3zC5e83Q9mw2JIjqx2aeuxy1e/Xp/85tTUMQdA0OwVpVYk4Jmqw508V8mJiz3hNAZ3GWC7fTnR
        pyQfokfB4Z/ye
X-Received: by 2002:a5d:4a07:: with SMTP id m7mr7739418wrq.389.1570696674231;
        Thu, 10 Oct 2019 01:37:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxX3dQkfZobzxCD/uNXx+pfT2b43hKsJ8wqZ40NKUE007l3b910aZ/I2gB9Hnb4Akljql5TDQ==
X-Received: by 2002:a5d:4a07:: with SMTP id m7mr7739394wrq.389.1570696673901;
        Thu, 10 Oct 2019 01:37:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k24sm10444181wmi.1.2019.10.10.01.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:37:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     john.stultz@linaro.org, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ssouhlal@freebsd.org, tfiga@chromium.org,
        Suleiman Souhlal <suleiman@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de
Subject: Re: [RFC v2 2/2] x86/kvmclock: Introduce kvm-hostclock clocksource.
In-Reply-To: <20191010073055.183635-3-suleiman@google.com>
References: <20191010073055.183635-1-suleiman@google.com> <20191010073055.183635-3-suleiman@google.com>
Date:   Thu, 10 Oct 2019 10:37:52 +0200
Message-ID: <87wodd6lnj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suleiman Souhlal <suleiman@google.com> writes:

> When kvm-hostclock is selected, and the host supports it, update our
> timekeeping parameters to be the same as the host.
> This lets us have our time synchronized with the host's,
> even in the presence of host NTP or suspend.
>
> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  arch/x86/Kconfig                    |   9 ++
>  arch/x86/include/asm/kvmclock.h     |  12 +++
>  arch/x86/kernel/Makefile            |   2 +
>  arch/x86/kernel/kvmclock.c          |   5 +-
>  arch/x86/kernel/kvmhostclock.c      | 130 ++++++++++++++++++++++++++++
>  include/linux/timekeeper_internal.h |   8 ++
>  kernel/time/timekeeping.c           |   2 +
>  7 files changed, 167 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kernel/kvmhostclock.c
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d6e1faa28c58..c5b1257ea969 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -839,6 +839,15 @@ config PARAVIRT_TIME_ACCOUNTING
>  config PARAVIRT_CLOCK
>  	bool
>  
> +config KVM_HOSTCLOCK
> +	bool "kvmclock uses host timekeeping"
> +	depends on KVM_GUEST
> +	help
> +	  Select this option to make the guest use the same timekeeping
> +	  parameters as the host. This means that time will be almost
> +	  exactly the same between the two. Only works if the host uses "tsc"
> +	  clocksource.
> +
>  config JAILHOUSE_GUEST
>  	bool "Jailhouse non-root cell support"
>  	depends on X86_64 && PCI
> diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
> index eceea9299097..de1a590ff97e 100644
> --- a/arch/x86/include/asm/kvmclock.h
> +++ b/arch/x86/include/asm/kvmclock.h
> @@ -2,6 +2,18 @@
>  #ifndef _ASM_X86_KVM_CLOCK_H
>  #define _ASM_X86_KVM_CLOCK_H
>  
> +#include <linux/timekeeper_internal.h>
> +
>  extern struct clocksource kvm_clock;
>  
> +unsigned long kvm_get_tsc_khz(void);
> +
> +#ifdef CONFIG_KVM_HOSTCLOCK
> +void kvm_hostclock_init(void);
> +#else
> +static inline void kvm_hostclock_init(void)
> +{
> +}
> +#endif /* KVM_HOSTCLOCK */
> +
>  #endif /* _ASM_X86_KVM_CLOCK_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 3578ad248bc9..bc7be935fc5e 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -17,6 +17,7 @@ CFLAGS_REMOVE_tsc.o = -pg
>  CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
>  CFLAGS_REMOVE_pvclock.o = -pg
>  CFLAGS_REMOVE_kvmclock.o = -pg
> +CFLAGS_REMOVE_kvmhostclock.o = -pg
>  CFLAGS_REMOVE_ftrace.o = -pg
>  CFLAGS_REMOVE_early_printk.o = -pg
>  CFLAGS_REMOVE_head64.o = -pg
> @@ -112,6 +113,7 @@ obj-$(CONFIG_AMD_NB)		+= amd_nb.o
>  obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
>  
>  obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
> +obj-$(CONFIG_KVM_HOSTCLOCK)	+= kvmhostclock.o
>  obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch.o
>  obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
>  obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 904494b924c1..4ab862de9777 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -125,7 +125,7 @@ static inline void kvm_sched_clock_init(bool stable)
>   * poll of guests can be running and trouble each other. So we preset
>   * lpj here
>   */
> -static unsigned long kvm_get_tsc_khz(void)
> +unsigned long kvm_get_tsc_khz(void)
>  {
>  	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>  	return pvclock_tsc_khz(this_cpu_pvti());
> @@ -366,5 +366,8 @@ void __init kvmclock_init(void)
>  		kvm_clock.rating = 299;
>  
>  	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
> +
> +	kvm_hostclock_init();
> +
>  	pv_info.name = "KVM";
>  }
> diff --git a/arch/x86/kernel/kvmhostclock.c b/arch/x86/kernel/kvmhostclock.c
> new file mode 100644
> index 000000000000..9971343c2bed
> --- /dev/null
> +++ b/arch/x86/kernel/kvmhostclock.c
> @@ -0,0 +1,130 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * KVM clocksource that uses host timekeeping.
> + * Copyright (c) 2019 Suleiman Souhlal, Google LLC
> + */
> +
> +#include <linux/clocksource.h>
> +#include <linux/kvm_para.h>
> +#include <asm/pvclock.h>
> +#include <asm/msr.h>
> +#include <asm/kvmclock.h>
> +#include <linux/timekeeper_internal.h>
> +
> +struct pvclock_timekeeper pv_timekeeper;
> +
> +static bool pv_timekeeper_enabled;
> +static bool pv_timekeeper_present;
> +static int old_vclock_mode;
> +
> +static u64
> +kvm_hostclock_get_cycles(struct clocksource *cs)
> +{
> +	return rdtsc_ordered();
> +}
> +
> +static int
> +kvm_hostclock_enable(struct clocksource *cs)
> +{
> +	pv_timekeeper_enabled = 1;
> +
> +	old_vclock_mode = kvm_clock.archdata.vclock_mode;
> +	kvm_clock.archdata.vclock_mode = VCLOCK_TSC;
> +	return 0;
> +}
> +
> +static void
> +kvm_hostclock_disable(struct clocksource *cs)
> +{
> +	pv_timekeeper_enabled = 0;
> +	kvm_clock.archdata.vclock_mode = old_vclock_mode;
> +}
> +
> +struct clocksource kvm_hostclock = {
> +	.name = "kvm-hostclock",
> +	.read = kvm_hostclock_get_cycles,
> +	.enable = kvm_hostclock_enable,
> +	.disable = kvm_hostclock_disable,
> +	.rating = 401, /* Higher than kvm-clock */

I would've offload the decision which clock is better to the host. If I
understand corectly the new clock is not compatible with live migration,
right? So how can the guest know if the host plans to migrate it or not?
I'd suggest adding two separate CPUID bits:
- kvm-hostclock present and enabled
- kvm-hostclock is prefered over kvm-clock.

> +	.mask = CLOCKSOURCE_MASK(64),
> +	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
> +};
> +
> +static void
> +pvclock_copy_into_read_base(struct pvclock_timekeeper *pvtk,
> +    struct tk_read_base *tkr, struct pvclock_read_base *pvtkr)
> +{
> +	int shift_diff;
> +
> +	tkr->mask = pvtkr->mask;
> +	tkr->cycle_last = pvtkr->cycle_last + pvtk->tsc_offset;
> +	tkr->mult = pvtkr->mult;
> +	shift_diff = tkr->shift - pvtkr->shift;
> +	tkr->shift = pvtkr->shift;
> +	tkr->xtime_nsec = pvtkr->xtime_nsec;
> +	tkr->base = pvtkr->base;
> +}
> +
> +static u64
> +pvtk_read_begin(struct pvclock_timekeeper *pvtk)
> +{
> +	u64 gen;
> +
> +	gen = pvtk->gen & ~1;
> +	/* Make sure that the gen count is read before the data. */
> +	virt_rmb();
> +
> +	return gen;
> +}
> +
> +static bool
> +pvtk_read_retry(struct pvclock_timekeeper *pvtk, u64 gen)
> +{
> +	/* Make sure that the gen count is re-read after the data. */
> +	virt_rmb();
> +	return unlikely(gen != pvtk->gen);
> +}
> +
> +void
> +kvm_clock_copy_into_tk(struct timekeeper *tk)
> +{
> +	struct pvclock_timekeeper *pvtk;
> +	u64 gen;
> +
> +	if (!pv_timekeeper_enabled)
> +		return;
> +
> +	pvtk = &pv_timekeeper;
> +	do {
> +		gen = pvtk_read_begin(pvtk);
> +		if (!(pv_timekeeper.flags & PVCLOCK_TIMEKEEPER_ENABLED))
> +			return;
> +
> +		pvclock_copy_into_read_base(pvtk, &tk->tkr_mono,
> +		    &pvtk->tkr_mono);
> +		pvclock_copy_into_read_base(pvtk, &tk->tkr_raw, &pvtk->tkr_raw);
> +
> +		tk->xtime_sec = pvtk->xtime_sec;
> +		tk->ktime_sec = pvtk->ktime_sec;
> +		tk->wall_to_monotonic.tv_sec = pvtk->wall_to_monotonic_sec;
> +		tk->wall_to_monotonic.tv_nsec = pvtk->wall_to_monotonic_nsec;
> +		tk->offs_real = pvtk->offs_real;
> +		tk->offs_boot = pvtk->offs_boot;
> +		tk->offs_tai = pvtk->offs_tai;
> +		tk->raw_sec = pvtk->raw_sec;
> +	} while (pvtk_read_retry(pvtk, gen));
> +}
> +
> +void __init
> +kvm_hostclock_init(void)
> +{
> +	unsigned long pa;
> +
> +	pa = __pa(&pv_timekeeper);
> +	wrmsrl(MSR_KVM_TIMEKEEPER_EN, pa);

Shouldn't you check for the presence of the MSR somehow? (CPUID bit probably)

> +	if (pv_timekeeper.flags & PVCLOCK_TIMEKEEPER_ENABLED) {
> +		pv_timekeeper_present = 1;
> +
> +		clocksource_register_khz(&kvm_hostclock, kvm_get_tsc_khz());
> +	}
> +}
> diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
> index 84ff2844df2a..43b036375cdc 100644
> --- a/include/linux/timekeeper_internal.h
> +++ b/include/linux/timekeeper_internal.h
> @@ -153,4 +153,12 @@ static inline void update_vsyscall_tz(void)
>  }
>  #endif
>  
> +#ifdef CONFIG_KVM_HOSTCLOCK
> +void kvm_clock_copy_into_tk(struct timekeeper *tk);
> +#else
> +static inline void kvm_clock_copy_into_tk(struct timekeeper *tk)
> +{
> +}
> +#endif
> +
>  #endif /* _LINUX_TIMEKEEPER_INTERNAL_H */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index ca69290bee2a..09bcf13b2334 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -2107,6 +2107,8 @@ static void timekeeping_advance(enum timekeeping_adv_mode mode)
>  	clock_set |= accumulate_nsecs_to_secs(tk);
>  
>  	write_seqcount_begin(&tk_core.seq);
> +	kvm_clock_copy_into_tk(tk);
> +
>  	/*
>  	 * Update the real timekeeper.
>  	 *

-- 
Vitaly
