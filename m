Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C771D77B4FC
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 11:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbjHNJBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 05:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbjHNJAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 05:00:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6B8E7D;
        Mon, 14 Aug 2023 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692003629; x=1723539629;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3jcFsF+OYtyq8O7AiwBKLe5ZEJI+kHYPzlC6RX/3rjc=;
  b=FS0aSP2kEE2Tm1nnBQQ3Pwx19DzZjl9k7tTcQRYk/lDvNOUQdabR0xsY
   m8KKYk+O7nPKD87tkRgn4wSxvm1LeLiss6o0YH9qBehXdJ3P2y0i3oALO
   8v96uWxMt0MVY+KDVkuPfSF06mLKuIyBt9RPjqXedpzWGcslZnXNPtEq+
   R24QKft5zaTO/m8SE1Jg/pKRaUPKXe62UaXYgOMU4kT8CvyOqGoau9W6D
   +TfupMgXe9ZMSnXtcU3K639xsNVhGsQhnWkXTBCDSbAEcTgWNky1M8ww8
   pOE2MUSbvd+I2hd8IE3oTYGFlcPqKwGm6FusBKctS58H5SoYrZKb933Rl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="362147268"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="362147268"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 01:58:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="907160790"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="907160790"
Received: from dmi-pnp-i7.sh.intel.com (HELO localhost) ([10.239.159.155])
  by orsmga005.jf.intel.com with ESMTP; 14 Aug 2023 01:58:08 -0700
Date:   Mon, 14 Aug 2023 17:04:33 +0800
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
Message-ID: <ZNnuIbG74jQpAsm1@dmi-pnp-i7>
References: <20230808051502.1831199-1-dapeng1.mi@linux.intel.com>
 <ZNatr1M6xddAxaWG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNatr1M6xddAxaWG@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023 at 02:52:47PM -0700, Sean Christopherson wrote:
> Date: Fri, 11 Aug 2023 14:52:47 -0700
> From: Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
> 
> On Tue, Aug 08, 2023, Dapeng Mi wrote:
> > Magic numbers are used to manipulate the bit fields of
> > FIXED_CTR_CTRL MSR. This is not read-friendly and use macros to replace
> > these magic numbers to increase the readability.
> > 
> > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > ---
> >  arch/x86/include/asm/perf_event.h |  2 ++
> >  arch/x86/kvm/pmu.c                | 16 +++++++---------
> >  arch/x86/kvm/pmu.h                | 10 +++++++---
> >  3 files changed, 16 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> > index 85a9fd5a3ec3..018441211af1 100644
> > --- a/arch/x86/include/asm/perf_event.h
> > +++ b/arch/x86/include/asm/perf_event.h
> > @@ -38,6 +38,8 @@
> >  #define INTEL_FIXED_0_USER				(1ULL << 1)
> >  #define INTEL_FIXED_0_ANYTHREAD			(1ULL << 2)
> >  #define INTEL_FIXED_0_ENABLE_PMI			(1ULL << 3)
> > +#define INTEL_FIXED_0_ENABLE	\
> > +	(INTEL_FIXED_0_KERNEL |	INTEL_FIXED_0_USER)
> 
> I vote to omit INTEL_FIXED_0_ENABLE and open code the "KERNEL | USER" logic in
> the one place that uses it.  I dislike macros that sneakily cover multiple bits,
> i.e. don't have a name that strongly suggests a multi-bit masks.  It's too easy
> to misread the code, especially for readers that aren't familiar with PMCs, e.g.
> in the usage below, it's not at all obvious that the "in use" check will evaluate
> true if the PMC is enabled for the kernel *or* user.
> 

Ok, you convinced me. I would drop this change. Thanks.


> >  #define HSW_IN_TX					(1ULL << 32)
> >  #define HSW_IN_TX_CHECKPOINTED				(1ULL << 33)
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index edb89b51b383..03fb6b4bca2c 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -418,13 +418,12 @@ static void reprogram_counter(struct kvm_pmc *pmc)
> >  		printk_once("kvm pmu: pin control bit is ignored\n");
> >  
> >  	if (pmc_is_fixed(pmc)) {
> > -		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> > -						  pmc->idx - INTEL_PMC_IDX_FIXED);
> > -		if (fixed_ctr_ctrl & 0x1)
> > +		fixed_ctr_ctrl = pmu_fixed_ctrl_field(pmu, pmc->idx);
> > +		if (fixed_ctr_ctrl & INTEL_FIXED_0_KERNEL)
> >  			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
> 
> Please split this into two patches, one to do a straight replacement of literals
> with existing macros, and one to add pmu_fixed_ctrl_field().  Using existing
> macros is a no-brainer, but I'm less convinced that pmu_fixed_ctrl_field() is
> a good idea, e.g. both pmu_fixed_ctrl_field() and fixed_ctrl_field() take "idx",
> but use a different base.  That is bound to cause problems.

Ok. It makes sense. It may be a good thing that let users know some
details. Would drop this new macro. Thanks.
> 
> > -		if (fixed_ctr_ctrl & 0x2)
> > +		if (fixed_ctr_ctrl & INTEL_FIXED_0_USER)
> >  			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
> > -		if (fixed_ctr_ctrl & 0x8)
> > +		if (fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI)
> >  			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
> >  		new_config = (u64)fixed_ctr_ctrl;
> >  	}
> > @@ -747,10 +746,9 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
> >  		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
> >  		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
> >  	} else {
> > -		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
> > -					  pmc->idx - INTEL_PMC_IDX_FIXED);
> > -		select_os = config & 0x1;
> > -		select_user = config & 0x2;
> > +		config = pmu_fixed_ctrl_field(pmc_to_pmu(pmc), pmc->idx);
> > +		select_os = config & INTEL_FIXED_0_KERNEL;
> > +		select_user = config & INTEL_FIXED_0_USER;
> >  	}
> >  
> >  	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index 7d9ba301c090..2d098aa2fcc6 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -12,7 +12,11 @@
> >  					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
> >  
> >  /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
> > -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
> > +#define fixed_ctrl_field(ctrl_reg, idx) \
> > +	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
> > +
> > +#define pmu_fixed_ctrl_field(pmu, idx)	\
> > +	fixed_ctrl_field((pmu)->fixed_ctr_ctrl, (idx) - INTEL_PMC_IDX_FIXED)
> >  
> >  #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
> >  #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
> > @@ -164,8 +168,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
> >  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> >  
> >  	if (pmc_is_fixed(pmc))
> > -		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> > -					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
> > +		return pmu_fixed_ctrl_field(pmu, pmc->idx) &
> > +		       INTEL_FIXED_0_ENABLE;
> >  
> >  	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
> >  }
> > -- 
> > 2.34.1
> > 

-- 
Thanks,
Dapeng Mi
