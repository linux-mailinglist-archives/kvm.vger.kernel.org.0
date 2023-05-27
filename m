Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AABE713285
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 06:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjE0ERJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 00:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjE0ERG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 00:17:06 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF57DF
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:17:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b025aaeddbso48465ad.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685161025; x=1687753025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tTkVIXYjWmne41FQ3L+MqOdG7qcUyKdU8JEYz2d+D7Q=;
        b=qnfs8Yo51WZXY0HkSSiZwEyOlDUAggGU9Ibvh5q0GZnFlkuc/YWDU6Rm9pKa3MzYVY
         0LmO9WFUdGcv0MGaxGc2DA87CDeJ8A3kbJuRQoVYn/KL+66EWA2CQ38ATcyIBHl4LdMN
         SwXXLqTI6qZmg/mgh1o7nT37CIoDt0sd3cOxoPqaJkJhE26jrvVeXCR7us+VIvsLPweh
         x6UNqTGuLnOBZRLU3b6AsdDKbaa56syacA9uiRCz1gGNpajUfb36wxzuDjSXiqhnJK2v
         E6VKMgJNXuw3LSeuy/wOEcGYvthEyw793PWdb4fwXvVuBa9az1a1UBKc9fEKd4Uwvz/U
         Y9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685161025; x=1687753025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTkVIXYjWmne41FQ3L+MqOdG7qcUyKdU8JEYz2d+D7Q=;
        b=Lj53o+T0A6jPuB3vI9ERrO6jDwTwTFQbCkWDYpV/j0migd1bhCU11z3kI1Jgy2QMOw
         2YMBkyaxF78O/tdT7ovZJxKyRrPZw8NOWNErT9IeFGzxDlqDFblsOg7Ff6ay4ug+V+6Q
         /wZ9Ut6kqBAWADr0qx/jxPGYfIKkSuVPiXgWs0ah20l06lBB/9Gbfxn7jCfWl6vd5zEJ
         kl6nMEm9E8HqB/Y/b9W1rhBecIHDJUpWJcli7VYd5LEyczzF4Um0rq0KNSl1rcJe0X0q
         cjokZkvdRbwWm3nBWNehYnQLRFAD/gQ6jC3kCwM8dwCp7OvQG5AxOMb+hSOntbmbjXXt
         JwrQ==
X-Gm-Message-State: AC+VfDy5s843OWcMU+i0PW15kkwv3fy6gJ8spBIoGbQcykieot7NU/3s
        ZObKm9fiYmPQhQ1L5axVdi2hSA==
X-Google-Smtp-Source: ACHHUZ5DaOGqibQNNDW0I0W+/JEbCkQd8Ae7x++7CZXwBh74PbWHKgNbD6xrC8JOc4mOiVkoXAVZGA==
X-Received: by 2002:a17:903:228e:b0:1b0:cea:294d with SMTP id b14-20020a170903228e00b001b00cea294dmr109847plh.20.1685161024446;
        Fri, 26 May 2023 21:17:04 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id g18-20020a170902869200b001b0034557afsm2681019plo.15.2023.05.26.21.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 21:17:03 -0700 (PDT)
Date:   Fri, 26 May 2023 21:16:58 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with
 vcpu loaded
Message-ID: <20230527041658.zgftvtaskylzmr6l@google.com>
References: <20230415164029.526895-1-reijiw@google.com>
 <20230415164029.526895-3-reijiw@google.com>
 <ZG/w95pYjWnMJB62@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG/w95pYjWnMJB62@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, May 25, 2023 at 11:36:23PM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> Apologies, this fell off my list of reviews.
> 
> On Sat, Apr 15, 2023 at 09:40:29AM -0700, Reiji Watanabe wrote:
> 
> [...]
> 
> >  static void armv8pmu_enable_event(struct perf_event *event)
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 6718731729fd..7e73be12cfaf 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -82,12 +82,24 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> >  	 */
> >  	if (kvm_arm_support_pmu_v3()) {
> >  		struct kvm_cpu_context *hctxt;
> > +		unsigned long flags;
> >  
> >  		write_sysreg(0, pmselr_el0);
> >  
> >  		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +
> > +		/*
> > +		 * Disable IRQs to prevent a race condition between the
> > +		 * following code and IPIs that attempts to update
> > +		 * PMUSERENR_EL0. See also kvm_set_pmuserenr().
> > +		 */
> > +		local_irq_save(flags);
> > +
> >  		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
> >  		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> > +		vcpu_set_flag(vcpu, PMUSERENR_ON_CPU);
> > +
> > +		local_irq_restore(flags);
> 
> Can the IRQ save/restore be moved to {activate,deactivate}_traps_vhe_{load,put}()?
> 
> That'd eliminate the dance to avoid using kernel-only symbols in nVHE
> and would be consistent with the existing usage of
> __{activate,deactivate}_traps_common() from nVHE (IRQs already
> disabled).
> 
> IMO, the less nVHE knows about the kernel the better.

Thank you for the comments.
Sure, I will move them to {activate,deactivate}_traps_vhe_{load,put}().


> 
> >  	}
> >  
> >  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
> > @@ -112,9 +124,21 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> >  	write_sysreg(0, hstr_el2);
> >  	if (kvm_arm_support_pmu_v3()) {
> >  		struct kvm_cpu_context *hctxt;
> > +		unsigned long flags;
> >  
> >  		hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +
> > +		/*
> > +		 * Disable IRQs to prevent a race condition between the
> > +		 * following code and IPIs that attempts to update
> > +		 * PMUSERENR_EL0. See also kvm_set_pmuserenr().
> > +		 */
> > +		local_irq_save(flags);
> > +
> >  		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
> > +		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
> > +
> > +		local_irq_restore(flags);
> >  	}
> >  
> >  	if (cpus_have_final_cap(ARM64_SME)) {
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index 530347cdebe3..2c08a54ca7d9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -10,7 +10,7 @@ asflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS
> >  # will explode instantly (Words of Marc Zyngier). So introduce a generic flag
> >  # __DISABLE_TRACE_MMIO__ to disable MMIO tracing for nVHE KVM.
> >  ccflags-y := -D__KVM_NVHE_HYPERVISOR__ -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
> > -ccflags-y += -fno-stack-protector	\
> > +ccflags-y += -fno-stack-protector -DNO_TRACE_IRQFLAGS \
> >  	     -DDISABLE_BRANCH_PROFILING	\
> >  	     $(DISABLE_STACKLEAK_PLUGIN)
> >  
> > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > index 7887133d15f0..d6a863853bfe 100644
> > --- a/arch/arm64/kvm/pmu.c
> > +++ b/arch/arm64/kvm/pmu.c
> > @@ -209,3 +209,28 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
> >  	kvm_vcpu_pmu_enable_el0(events_host);
> >  	kvm_vcpu_pmu_disable_el0(events_guest);
> >  }
> > +
> > +/*
> > + * With VHE, keep track of the PMUSERENR_EL0 value for the host EL0 on the pCPU
> > + * where PMUSERENR_EL0 for the guest is loaded, since PMUSERENR_EL0 is switched
> > + * to the value for the guest on vcpu_load().  The value for the host EL0
> > + * will be restored on vcpu_put(), before returning to the EL0.
> 
> wording: s/the EL0/EL0. Or, alternatively, to avoid repeating yourself
> you can just say "returning to userspace".
> 
> You may also want to mention in passing why this isn't necessary for
> nVHE, as the register is context switched for every guest enter/exit.

Thank you for the suggestions. I will fix those.

Thank you,
Reiji


> 
> > + *
> > + * Return true if KVM takes care of the register. Otherwise return false.
> > + */
> > +bool kvm_set_pmuserenr(u64 val)
> > +{
> > +	struct kvm_cpu_context *hctxt;
> > +	struct kvm_vcpu *vcpu;
> > +
> > +	if (!kvm_arm_support_pmu_v3() || !has_vhe())
> > +		return false;
> > +
> > +	vcpu = kvm_get_running_vcpu();
> > +	if (!vcpu || !vcpu_get_flag(vcpu, PMUSERENR_ON_CPU))
> > +		return false;
> > +
> > +	hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > +	ctxt_sys_reg(hctxt, PMUSERENR_EL0) = val;
> > +	return true;
> > +}
> 
> -- 
> Thanks,
> Oliver
