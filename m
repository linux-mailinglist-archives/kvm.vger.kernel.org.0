Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED51E59FE49
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239530AbiHXP0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 11:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238525AbiHXP0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 11:26:48 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8789A9A687
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:26:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m15so9359594pjj.3
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 08:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=7cYr8vAfRHCWuiirD4vPsPn+6q5Wbv188oHbQU7Rxhk=;
        b=mgRkttJT3eCwZMRg+uvkdAvCsSWdhcCN9w9fVa3lDY8f/I4OgJwYT2zDhiFRZHZA8Q
         qX4oX5RQiF26QWesS358K6RkTJId0PuSWWLSd1tmG0sq+8IMis3L7hBwoptwTfXT5EiW
         M5UB4ltzcs5FDAKDpj+i88uB3XsIIX6mk3ftHKylzKRAM/BxmXMOMwMnqYauTifoghcE
         s9OhNfLStbubvbhs8v6JFMGt71eSlVtJCBi6koG9daNoODMbScFqlVtMWdpW9C4lYlHI
         eUVdmVyFvq4o48IUZUoWMuDpvFBOZ+X4KAG0UxrAovnc1f3LICr55Ghq97sE4LuTsklX
         q/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=7cYr8vAfRHCWuiirD4vPsPn+6q5Wbv188oHbQU7Rxhk=;
        b=YjJli1xY0mrvls+yALYjfxAiVh6Pk64vb5ZOVpyafkS6c8gOXc/KnA62uCbEvA/N53
         l0+MJlogr8veCCvt44KXGivs1jHKJxohKtEGCc7KK9rGyGWEYwlyBhGKBH5M7fC5ribK
         Wh/9qVWwuwKSo/tzal9DpPdWwKriRjtswGnu7oVaUKbsOXJ4mP+/JxyNmsgC9k1TIgsr
         ptniVvvVQLkuUU0Bl/JeI1kvKVgv9/ZtQcvHeJbvqa1QJz8snrC4zWOYGQvHzoDwKbz7
         sT5QvdnQv7PPHfB7BTtuN2BSra65VODOJZhTkQAyscVQzY51TJR8f7Gw5SjZoGzJh1Df
         s8tw==
X-Gm-Message-State: ACgBeo1FPIyhhqn+21/B9pXGGKVRaDZuXaG946+53i0DT33j+SNFYB4c
        8GJTyVp2PcFTX+xtIjJaeugOS3xg6KZnaw==
X-Google-Smtp-Source: AA6agR5piYiLGl91DJ+WGiCQqFgwEJssZpJdddayt4oyPxEfPJpGKcc+JSQkywuvBiPbxPtQrUz4Kg==
X-Received: by 2002:a17:903:11c7:b0:170:cde7:d24a with SMTP id q7-20020a17090311c700b00170cde7d24amr29338758plh.91.1661354803396;
        Wed, 24 Aug 2022 08:26:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id qi3-20020a17090b274300b001f3162e4e55sm1538091pjb.35.2022.08.24.08.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 08:26:43 -0700 (PDT)
Date:   Wed, 24 Aug 2022 15:26:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dapeng Mi <dapeng1.mi@intel.com>
Cc:     rafael@kernel.org, daniel.lezcano@linaro.org, pbonzini@redhat.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, zhenyuw@linux.intel.com
Subject: Re: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Message-ID: <YwZDL4yv7F2Y4JBP@google.com>
References: <20220824091117.767363-1-dapeng1.mi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824091117.767363-1-dapeng1.mi@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022, Dapeng Mi wrote:
> TPAUSE is a new instruction on Intel processors which can instruct
> processor enters a power/performance optimized state. Halt polling
> uses PAUSE instruction to wait vCPU is waked up. The polling time
> could be long and cause extra power consumption in some cases.
> 
> Use TPAUSE to replace the PAUSE instruction in halt polling to get
> a better power saving and performance.

Better power savings, yes.  Better performance?  Not necessarily.  Using TPAUSE
for  a "successful" halt poll is likely to yield _worse_ performance from the
vCPU's perspective due to the increased latency.

> Signed-off-by: Dapeng Mi <dapeng1.mi@intel.com>
> ---
>  drivers/cpuidle/poll_state.c |  3 ++-
>  include/linux/kvm_host.h     | 20 ++++++++++++++++++++
>  virt/kvm/kvm_main.c          |  2 +-
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index f7e83613ae94..51ec333cbf80 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -7,6 +7,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/clock.h>
>  #include <linux/sched/idle.h>
> +#include <linux/kvm_host.h>
>  
>  #define POLL_IDLE_RELAX_COUNT	200
>  
> @@ -25,7 +26,7 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>  		limit = cpuidle_poll_time(drv, dev);
>  
>  		while (!need_resched()) {
> -			cpu_relax();
> +			kvm_cpu_poll_pause(limit);

poll_idle() absolutely should not be calling into KVM code.

>  			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>  				continue;
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f4519d3689e1..810e749949b7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -35,6 +35,7 @@
>  #include <linux/interval_tree.h>
>  #include <linux/rbtree.h>
>  #include <linux/xarray.h>
> +#include <linux/delay.h>
>  #include <asm/signal.h>
>  
>  #include <linux/kvm.h>
> @@ -2247,6 +2248,25 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +/*
> + * This function is intended to replace the cpu_relax function in
> + * halt polling. If TPAUSE instruction is supported, use TPAUSE
> + * instead fo PAUSE to get better power saving and performance.
> + * Selecting 1 us is a compromise between scheduling latency and
> + * power saving time.
> + */
> +static inline void kvm_cpu_poll_pause(u64 timeout_ns)
> +{
> +#ifdef CONFIG_X86

This is not preferred the way to insert arch-specific behavior into common KVM code.
Assuming the goal is to avoid a function call, use an #ifndef here and then #define
the flag in x86's kvm_host.h, e.g.

#ifndef CONFIG_HAVE_KVM_ARCH_HALT_POLL_PAUSE
static inline kvm_cpu_halt_poll_pause(u64 timeout_ns)
{
	cpu_relax();
}
#endif

It's not obvious that we need to avoid a call here though, in which case a

  __weak void kvm_arch_cpu_halt_poll_pause(struct kvm *kvm)
  {

  }

with an x86 implementation will suffice.


> +	if (static_cpu_has(X86_FEATURE_WAITPKG) && timeout_ns > 1000)
> +		udelay(1);

This is far too arbitrary.  Wake events from other vCPU are not necessarily
accompanied by an IRQ, which means that delaying for 1us may really truly delay
for 1us before detecting a pending wake event.

If this is something we want to utilize in KVM, it should be controllable by
userspace, probably via module param, and likely off by default.

E.g. 

  unsigned int halt_poll_tpause_ns;

and then

  if (timeout_ns >= halt_poll_tpause_ns)
  	udelay(halt_poll_tpause_ns);

with halt_poll_tpause_ns zeroed out during setup if TPAUSE isn't supported.

I say "if", because I think this needs to come with performance numbers to show
the impact on guest latency so that KVM and its users can make an informed decision.
And if it's unlikely that anyone will ever want to enable TPAUSE for halt polling,
then it's not worth the extra complexity in KVM.

> +	else
> +		cpu_relax();
> +#else
> +	cpu_relax();
> +#endif
> +}
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 584a5bab3af3..4afa776d21bd 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3510,7 +3510,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  			 */
>  			if (kvm_vcpu_check_block(vcpu) < 0)
>  				goto out;
> -			cpu_relax();
> +			kvm_cpu_poll_pause(vcpu->halt_poll_ns);

This is wrong, vcpu->halt_poll_ns is the total poll time, not the time remaining.
E.g. if the max poll time is 1001 ns, and KVM has already waited for 1000 ns, then
udelay(1) will cause KVM to wait for ~2000ns total.  There's always going to be
some amount of overrun, but overrun by a few ns is quite different than overrun
by a few thousand ns.

>  			poll_end = cur = ktime_get();
>  		} while (kvm_vcpu_can_poll(cur, stop));
>  	}
> -- 
> 2.34.1
> 
