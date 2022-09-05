Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54ACB5AD326
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 14:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbiIEMnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 08:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbiIEMmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 08:42:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E6A186;
        Mon,  5 Sep 2022 05:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0006A6126C;
        Mon,  5 Sep 2022 12:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54743C433D6;
        Mon,  5 Sep 2022 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662381563;
        bh=wajMAYR/6iyAha7UYq8ObcxEz88rw+3AXM+f88aytXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RFdfKOjWqyrq4X/O7u9ZVh0PSCo3sNw3s6CuXWKaPSlFQcYWGvLA6NFOAc2OJFU9v
         KYy4dJ2BoDtrfO2wiPB8o/60EkewsHpgEL4gU06uZRo3QDJ4IEqu4L3Dw5AwGKPDl1
         uVSVpzO1oJ/LVYyYHgCiUmc/kT8228gfHsqY+1JPuar7Be6KaaRxjOGm0eU93RbBo0
         sovoYI8wSOdUL4JmOLG9ZUN1427VBr9tuYw7b9Nl00TTaGMmbf3hUNOqZGaG3s3w3/
         ojg3GiSaJ5+8/j/gStH66kHXy6GpHREKoqXNDgOt145r0LCB4l8FOR7sKk7VwbSYJU
         vBJUguwH2tv9Q==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oVBNp-0084sf-0j;
        Mon, 05 Sep 2022 13:39:21 +0100
MIME-Version: 1.0
Date:   Mon, 05 Sep 2022 13:39:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
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
In-Reply-To: <87pmgaqie6.wl-maz@kernel.org>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <72481a7bc0ff08093f4f0f04cece877ee82de0cf.1662084396.git.isaku.yamahata@intel.com>
 <20220905070509.f5neutyqgvbklefi@yy-desk-7060>
 <87pmgaqie6.wl-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3cc7a3dffa4f12c4aa1f546f3e2d3952@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuan.yao@linux.intel.com, isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, will@kernel.org, isaku.yamahata@gmail.com, kai.huang@intel.com, chao.gao@intel.com, atishp@atishpatra.org, zhangshaokun@hisilicon.com, liuqi115@huawei.com, john.garry@huawei.com, daniel.lezcano@linaro.org, ying.huang@intel.com, chenhuacai@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de, oupton@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-05 10:29, Marc Zyngier wrote:
> On Mon, 05 Sep 2022 08:05:09 +0100,
> Yuan Yao <yuan.yao@linux.intel.com> wrote:
>> 
>> On Thu, Sep 01, 2022 at 07:17:41PM -0700, isaku.yamahata@intel.com 
>> wrote:
>> > From: Marc Zyngier <maz@kernel.org>
>> >
>> > For a number of historical reasons, the KVM/arm64 hotplug setup is pretty
>> > complicated, and we have two extra CPUHP notifiers for vGIC and timers.
>> >
>> > It looks pretty pointless, and gets in the way of further changes.
>> > So let's just expose some helpers that can be called from the core
>> > CPUHP callback, and get rid of everything else.
>> >
>> > This gives us the opportunity to drop a useless notifier entry,
>> > as well as tidy-up the timer enable/disable, which was a bit odd.
>> >
>> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > Signed-off-by: Chao Gao <chao.gao@intel.com>
>> > Reviewed-by: Oliver Upton <oupton@google.com>
>> > Link: https://lore.kernel.org/r/20220216031528.92558-5-chao.gao@intel.com
>> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> > ---
>> >  arch/arm64/kvm/arch_timer.c     | 27 ++++++++++-----------------
>> >  arch/arm64/kvm/arm.c            |  4 ++++
>> >  arch/arm64/kvm/vgic/vgic-init.c | 19 ++-----------------
>> >  include/kvm/arm_arch_timer.h    |  4 ++++
>> >  include/kvm/arm_vgic.h          |  4 ++++
>> >  include/linux/cpuhotplug.h      |  3 ---
>> >  6 files changed, 24 insertions(+), 37 deletions(-)
>> >
>> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
>> > index bb24a76b4224..33fca1a691a5 100644
>> > --- a/arch/arm64/kvm/arch_timer.c
>> > +++ b/arch/arm64/kvm/arch_timer.c
>> > @@ -811,10 +811,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>> >  	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
>> >  }
>> >
>> > -static void kvm_timer_init_interrupt(void *info)
>> > +void kvm_timer_cpu_up(void)
>> >  {
>> >  	enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
>> > -	enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
>> > +	if (host_ptimer_irq)
>> > +		enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
>> > +}
>> > +
>> > +void kvm_timer_cpu_down(void)
>> > +{
>> > +	disable_percpu_irq(host_vtimer_irq);
>> > +	if (host_ptimer_irq)
>> > +		disable_percpu_irq(host_ptimer_irq);
>> >  }
>> 
>> Should "host_vtimer_irq" be checked yet as host_ptimer_irq ?
> 
> No, because although the ptimer interrupt is optional (on older
> systems, we fully emulate that timer, including the interrupt), the
> vtimer interrupt is always present and can be used unconditionally.
> 
>> Because
>> the host_{v,p}timer_irq is set in same function kvm_irq_init() which
>> called AFTER the on_each_cpu(_kvm_arch_hardware_enable, NULL, 1) from
>> init_subsystems():
>> 
>> kvm_init()
>>   kvm_arch_init()
>>     init_subsystems()
>>       on_each_cpu(_kvm_arch_hardware_enable, NULL, 1);
>>       kvm_timer_hyp_init()
>>         kvm_irq_init()
>>           host_vtimer_irq = info->virtual_irq;
>>           host_ptimer_irq = info->physical_irq;
>>   hardware_enable_all()
> 
> This, however, is a very nice catch. I doubt this results in anything
> really bad (the interrupt enable will fail as the interrupt number
> is 0, and the disable will also fail due to no prior enable), but
> that's extremely ugly anyway.
> 
> The best course of action AFAICS is to differentiate between the
> arm64-specific initialisation (which is a one-off) and the runtime
> stuff. Something like the hack below, that I haven't tested yet:
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 32c1022eb4b3..65d03c28f32a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1671,23 +1671,27 @@ static void _kvm_arch_hardware_enable(void 
> *discard)
>  {
>  	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
>  		cpu_hyp_reinit();
> -		kvm_vgic_cpu_up();
> -		kvm_timer_cpu_up();
>  		__this_cpu_write(kvm_arm_hardware_enabled, 1);
>  	}
>  }
> 
>  int kvm_arch_hardware_enable(void)
>  {
> +	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> +
>  	_kvm_arch_hardware_enable(NULL);
> +
> +	if (!was_enabled) {
> +		kvm_vgic_cpu_up();
> +		kvm_timer_cpu_up();
> +	}
> +
>  	return 0;
>  }
> 
>  static void _kvm_arch_hardware_disable(void *discard)
>  {
>  	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> -		kvm_timer_cpu_down();
> -		kvm_vgic_cpu_down();
>  		cpu_hyp_reset();
>  		__this_cpu_write(kvm_arm_hardware_enabled, 0);
>  	}
> @@ -1695,6 +1699,11 @@ static void _kvm_arch_hardware_disable(void 
> *discard)
> 
>  void kvm_arch_hardware_disable(void)
>  {
> +	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> +		kvm_timer_cpu_down();
> +		kvm_vgic_cpu_down();
> +	}
> +
>  	if (!is_protected_kvm_enabled())
>  		_kvm_arch_hardware_disable(NULL);
>  }

OK, this seems to work here, at least based on a sample of 2
systems, bringing CPUs up and down whist a VM is pinned to
these CPUs.

Isaku, can you please squash this into the original patch
and drop Oliver's Reviewed-by: tag, as this significantly
changes the logic?

Alternatively, I can repost this patch as a standalone change.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
