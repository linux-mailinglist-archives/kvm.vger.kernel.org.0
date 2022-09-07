Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE85B0830
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiIGPMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiIGPMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:12:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA34F5FAEB;
        Wed,  7 Sep 2022 08:12:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u22so14839075plq.12;
        Wed, 07 Sep 2022 08:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=5qlPV74Pp3Ds4k5ap0cTIGdjJPYtwt6BD4m9h1Xc3wk=;
        b=g/oUwG7nDZnAY+SRO6rmpt7UgcU1TOLPhiiSgR2bw8ahfwXIMNyRkQhYP1t6pYAWTM
         aHp4x9x0/2FncovxGQvthm7APBEysbwJiqseWxd6YVyppa0csAAvTXjum2TR1bQMvW1Y
         TsLmcLeCz4KsYlyQ7wtbJOuA8lkWOzPFV4IpfsU4AvkL81hBLPvakmohZ+Ftc4XxHDed
         6Xwp7Mn1Q0YCpR/AKLGqU+aFv8/Lfc/auZUPK6cs1L73VT4FcejgR9WIuPhXsmLS0tWV
         mk7ySj+HL7wlFZjK4GqWjjGBeh0GQ1oYd7DcWb+U4mA4joVl3NBC53iMz26010VVcJpO
         eiOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5qlPV74Pp3Ds4k5ap0cTIGdjJPYtwt6BD4m9h1Xc3wk=;
        b=3cPNI9TrSvCtZeKnrQ3fsItrEoGAWTIFU9/3hY+1Fxv53msg2zSfpxTbyEcj/fDfqi
         I+xLddsAF0h9pX6aCO7gsBTAIgHj0dah2A69YeIke9JS8k16Fl3SrwckB+h03/uAZf8y
         phS/08kjZpWr13sWWLlLqVUg+sc2fzKO9kvye2ceAIaszPtqhV5ikeILxNdYw+kZJcv9
         ct3iUPxRfH3yACQebJLhFhUnTlekIzlweO8UoBKUbO4hXZ6RBmvLT/siBteVp1Rmbggt
         n7VfJSlBba6pphOP18StWG3wJ6b3fTA+nGpuKNSwY3R8p/xdtXZFddxvD54d/TcLIEc8
         HweA==
X-Gm-Message-State: ACgBeo22tkVdmHEMssRKeRF2Jyzys91qCALIDHOO+YFr5SSsCtkOlEq3
        lv0SdHYhtS2k73dtwbDzGFg=
X-Google-Smtp-Source: AA6agR6diMWa4vKZ7Z2eUcq9sBc3jDRr7sDRWe6tvb628y0j9mUtz05EnKrEHAXrHxghNRqjThUp/g==
X-Received: by 2002:a17:903:11c9:b0:172:6ea1:b727 with SMTP id q9-20020a17090311c900b001726ea1b727mr4457187plh.78.1662563525027;
        Wed, 07 Sep 2022 08:12:05 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id x20-20020aa79574000000b0053dec787698sm5827300pfq.175.2022.09.07.08.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:12:04 -0700 (PDT)
Date:   Wed, 7 Sep 2022 08:12:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@intel.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
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
Message-ID: <20220907151203.GA456048@ls.amr.corp.intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <72481a7bc0ff08093f4f0f04cece877ee82de0cf.1662084396.git.isaku.yamahata@intel.com>
 <20220905070509.f5neutyqgvbklefi@yy-desk-7060>
 <87pmgaqie6.wl-maz@kernel.org>
 <3cc7a3dffa4f12c4aa1f546f3e2d3952@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3cc7a3dffa4f12c4aa1f546f3e2d3952@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 05, 2022 at 01:39:20PM +0100,
Marc Zyngier <maz@kernel.org> wrote:

> On 2022-09-05 10:29, Marc Zyngier wrote:
> > On Mon, 05 Sep 2022 08:05:09 +0100,
> > Yuan Yao <yuan.yao@linux.intel.com> wrote:
> > > 
> > > On Thu, Sep 01, 2022 at 07:17:41PM -0700, isaku.yamahata@intel.com
> > > wrote:
> > > > From: Marc Zyngier <maz@kernel.org>
> > > >
> > > > For a number of historical reasons, the KVM/arm64 hotplug setup is pretty
> > > > complicated, and we have two extra CPUHP notifiers for vGIC and timers.
> > > >
> > > > It looks pretty pointless, and gets in the way of further changes.
> > > > So let's just expose some helpers that can be called from the core
> > > > CPUHP callback, and get rid of everything else.
> > > >
> > > > This gives us the opportunity to drop a useless notifier entry,
> > > > as well as tidy-up the timer enable/disable, which was a bit odd.
> > > >
> > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > > > Reviewed-by: Oliver Upton <oupton@google.com>
> > > > Link: https://lore.kernel.org/r/20220216031528.92558-5-chao.gao@intel.com
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > >  arch/arm64/kvm/arch_timer.c     | 27 ++++++++++-----------------
> > > >  arch/arm64/kvm/arm.c            |  4 ++++
> > > >  arch/arm64/kvm/vgic/vgic-init.c | 19 ++-----------------
> > > >  include/kvm/arm_arch_timer.h    |  4 ++++
> > > >  include/kvm/arm_vgic.h          |  4 ++++
> > > >  include/linux/cpuhotplug.h      |  3 ---
> > > >  6 files changed, 24 insertions(+), 37 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > > > index bb24a76b4224..33fca1a691a5 100644
> > > > --- a/arch/arm64/kvm/arch_timer.c
> > > > +++ b/arch/arm64/kvm/arch_timer.c
> > > > @@ -811,10 +811,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
> > > >  	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
> > > >  }
> > > >
> > > > -static void kvm_timer_init_interrupt(void *info)
> > > > +void kvm_timer_cpu_up(void)
> > > >  {
> > > >  	enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
> > > > -	enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
> > > > +	if (host_ptimer_irq)
> > > > +		enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
> > > > +}
> > > > +
> > > > +void kvm_timer_cpu_down(void)
> > > > +{
> > > > +	disable_percpu_irq(host_vtimer_irq);
> > > > +	if (host_ptimer_irq)
> > > > +		disable_percpu_irq(host_ptimer_irq);
> > > >  }
> > > 
> > > Should "host_vtimer_irq" be checked yet as host_ptimer_irq ?
> > 
> > No, because although the ptimer interrupt is optional (on older
> > systems, we fully emulate that timer, including the interrupt), the
> > vtimer interrupt is always present and can be used unconditionally.
> > 
> > > Because
> > > the host_{v,p}timer_irq is set in same function kvm_irq_init() which
> > > called AFTER the on_each_cpu(_kvm_arch_hardware_enable, NULL, 1) from
> > > init_subsystems():
> > > 
> > > kvm_init()
> > >   kvm_arch_init()
> > >     init_subsystems()
> > >       on_each_cpu(_kvm_arch_hardware_enable, NULL, 1);
> > >       kvm_timer_hyp_init()
> > >         kvm_irq_init()
> > >           host_vtimer_irq = info->virtual_irq;
> > >           host_ptimer_irq = info->physical_irq;
> > >   hardware_enable_all()
> > 
> > This, however, is a very nice catch. I doubt this results in anything
> > really bad (the interrupt enable will fail as the interrupt number
> > is 0, and the disable will also fail due to no prior enable), but
> > that's extremely ugly anyway.
> > 
> > The best course of action AFAICS is to differentiate between the
> > arm64-specific initialisation (which is a one-off) and the runtime
> > stuff. Something like the hack below, that I haven't tested yet:
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 32c1022eb4b3..65d03c28f32a 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1671,23 +1671,27 @@ static void _kvm_arch_hardware_enable(void
> > *discard)
> >  {
> >  	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
> >  		cpu_hyp_reinit();
> > -		kvm_vgic_cpu_up();
> > -		kvm_timer_cpu_up();
> >  		__this_cpu_write(kvm_arm_hardware_enabled, 1);
> >  	}
> >  }
> > 
> >  int kvm_arch_hardware_enable(void)
> >  {
> > +	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> > +
> >  	_kvm_arch_hardware_enable(NULL);
> > +
> > +	if (!was_enabled) {
> > +		kvm_vgic_cpu_up();
> > +		kvm_timer_cpu_up();
> > +	}
> > +
> >  	return 0;
> >  }
> > 
> >  static void _kvm_arch_hardware_disable(void *discard)
> >  {
> >  	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> > -		kvm_timer_cpu_down();
> > -		kvm_vgic_cpu_down();
> >  		cpu_hyp_reset();
> >  		__this_cpu_write(kvm_arm_hardware_enabled, 0);
> >  	}
> > @@ -1695,6 +1699,11 @@ static void _kvm_arch_hardware_disable(void
> > *discard)
> > 
> >  void kvm_arch_hardware_disable(void)
> >  {
> > +	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> > +		kvm_timer_cpu_down();
> > +		kvm_vgic_cpu_down();
> > +	}
> > +
> >  	if (!is_protected_kvm_enabled())
> >  		_kvm_arch_hardware_disable(NULL);
> >  }
> 
> OK, this seems to work here, at least based on a sample of 2
> systems, bringing CPUs up and down whist a VM is pinned to
> these CPUs.
> 
> Isaku, can you please squash this into the original patch
> and drop Oliver's Reviewed-by: tag, as this significantly
> changes the logic?
> 
> Alternatively, I can repost this patch as a standalone change.

I'll do with the next respin.  Anyway feel free to go before me.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
