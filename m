Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3937788E0
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 10:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbjHKIYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 04:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjHKIYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 04:24:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702082727;
        Fri, 11 Aug 2023 01:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691742276; x=1723278276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hunoZPyF1UuHXl0aPeu/n25+zNkrKtkZP3CSrhp4N34=;
  b=IlcYmxAwcImjwIiRJY3Stc/tFNT2girOKX+dIAICcbGaYU7D1vcpQLuQ
   UIIAgMM4VLrBGAgM3nd6sOc5uG6qB72xq0HU/d7UzWMub264OulzcEy0h
   MJPSOp42phZ0hwW5nvyHHQtiPPkxHBEgDiGQaxuYj2vdZwbqpW9/Poy9M
   q9weHbWvnQAYv23q2G0aJblebORPUizMOiQkwenyvHOVvk+s1m+MrX4Ls
   yjHpL7AHRewafZKUuKfFqmtY/ZA/oafBhW+rGptjs1nL+Y16w5QEkF/7S
   uAfFVWbF2rGl9hHVlHIDM/k73cxlTEXsQ0Cc6V/McY/yfG7laHwQz5NFj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="351950693"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="351950693"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2023 01:24:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="709459432"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="709459432"
Received: from dmi-pnp-i7.sh.intel.com (HELO localhost) ([10.239.159.155])
  by orsmga006.jf.intel.com with ESMTP; 11 Aug 2023 01:24:31 -0700
Date:   Fri, 11 Aug 2023 16:30:57 +0800
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Like Xu <likexu@tencent.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
Message-ID: <ZNXxwaLId2Z4DAsD@dmi-pnp-i7>
References: <20230504120042.785651-1-rkagan@amazon.de>
 <ZH6DJ8aFq/LM6Bk9@google.com>
 <CALMp9eS3F08cwUJbKjTRAEL0KyZ=MC==YSH+DW-qsFkNfMpqEQ@mail.gmail.com>
 <ZJ4dmrQSduY8aWap@google.com>
 <ZJ65CiW0eEL2mGg8@u40bc5e070a0153.ant.amazon.com>
 <ZJ7mjdZ8h/RSilFX@google.com>
 <ZJ7y9DuedQyBb9eU@u40bc5e070a0153.ant.amazon.com>
 <ZJ74gELkj4DgAk4S@google.com>
 <ZJ9IaskpbIK9q4rt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ9IaskpbIK9q4rt@google.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 02:26:02PM -0700, Sean Christopherson wrote:
> Date: Fri, 30 Jun 2023 14:26:02 -0700
> From: Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
> 
> On Fri, Jun 30, 2023, Sean Christopherson wrote:
> > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > On Fri, Jun 30, 2023 at 07:28:29AM -0700, Sean Christopherson wrote:
> > > > On Fri, Jun 30, 2023, Roman Kagan wrote:
> > > > > On Thu, Jun 29, 2023 at 05:11:06PM -0700, Sean Christopherson wrote:
> > > > > > @@ -74,6 +74,14 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
> > > > > >         return counter & pmc_bitmask(pmc);
> > > > > >  }
> > > > > >
> > > > > > +static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> > > > > > +{
> > > > > > +       if (pmc->perf_event && !pmc->is_paused)
> > > > > > +               perf_event_set_count(pmc->perf_event, val);
> > > > > > +
> > > > > > +       pmc->counter = val;
> > > > >
> > > > > Doesn't this still have the original problem of storing wider value than
> > > > > allowed?
> > > > 
> > > > Yes, this was just to fix the counter offset weirdness.  My plan is to apply your
> > > > patch on top.  Sorry for not making that clear.
> > > 
> > > Ah, got it, thanks!
> > > 
> > > Also I'm now chasing a problem that we occasionally see
> > > 
> > > [3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
> > > [3939579.462836] Do you have a strange power saving mode enabled?
> > > [3939579.462836] Dazed and confused, but trying to continue
> > > 
> > > in the guests when perf is used.  These messages disappear when
> > > 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions") is
> > > reverted.  I haven't yet figured out where exactly the culprit is.
> > 
> > Can you reverting de0f619564f4 ("KVM: x86/pmu: Defer counter emulated overflow
> > via pmc->prev_counter")?  I suspect the problem is the prev_counter mess.
> 
> Ugh, yeah, de0f619564f4 created a bit of a mess.  The underlying issue that it
> was solving is that perf_event_read_value() and friends might sleep (yay mutex),
> and so can't be called from KVM's fastpath (IRQs disabled).
> 
> However, detecting overflow requires reading perf_event_read_value() to gather
> the accumulated count from the hardware event in order to add it to the emulated
> count from software.  E.g. if pmc->counter is X and the perf event counter is Y,
> KVM needs to factor in Y because X+Y+1 might overflow even if X+1 does not.
> 
> Trying to snapshot the previous counter value is a bit of a mess.  It could probably
> made to work, but it's hard to reason about what the snapshot actually contains
> and when it should be cleared, especially when factoring in the wrapping logic.
> 
> Rather than snapshot the previous counter, I think it makes sense to:
> 
>   1) Track the number of emulated counter events
>   2) Accumulate and reset the counts from perf_event and emulated_counter into
>      pmc->counter when pausing the PMC
>   3) Pause and reprogram the PMC on writes (instead of the current approach of
>      blindly updating the sample period)
>   4) Pause the counter when stopping the perf_event to ensure pmc->counter is
>      fresh (instead of manually updating pmc->counter)
> 
> IMO, that yields more intuitive logic, and makes it easier to reason about
> correctness since the behavior is easily define: pmc->counter holds the counts
> that have been gathered and processed, perf_event and emulated_counter hold
> outstanding counts on top.  E.g. on a WRMSR to the counter, both the emulated
> counter and the hardware counter are reset, because whatever counts existed
> previously are irrelevant.
> 
> Pausing the counter _might_ make WRMSR slower, but we need to get this all
> functionally correct before worrying too much about performance.
> 
> Diff below for what I'm thinking (needs to be split into multiple patches).  It's
> *very* lightly tested.
> 
> I'm about to disappear for a week, I'll pick this back up when I get return.  In
> the meantime, any testing and/or input would be much appreciated!

We also observed this PMI injection deadloop issue, especially when the
counters are in non-full-width mode and the MSB of counter value is 1,
the deadloop issue is quite easily triggered. The PMI injection deadloop
would cause PMI storm and exhaust all CPU resource eventually.

We verified either Roman or Sean's patch can fix this PMI deadloop issue
on Intel Sapphire Rapids platform.

The Perf command in validation comes from Mingwei and it is

sudo ./perf record -N -B -T --sample-cpu                                                                            \
--clockid=CLOCK_MONOTONIC_RAW                                                                                            \
-e cpu/period=0xcdfe60,event=0x3c,name='CPU_CLK_UNHALTED.THREAD'/Duk                                                     \
-e cpu/period=0xcdfe60,umask=0x3,name='CPU_CLK_UNHALTED.REF_TSC'/Duk                                                     \
-e cpu/period=0xcdfe60,event=0xc0,name='INST_RETIRED.ANY'/Duk                                                            \
-e cpu/period=0xcdfe60,event=0xec,umask=0x2,name='CPU_CLK_UNHALTED.DISTRIBUTED'/uk                                           \
-e cpu/period=0x98968f,event=0x3c,name='CPU_CLK_UNHALTED.THREAD_P'/uk                                                    \
-e cpu/period=0x98968f,event=0xa6,umask=0x21,cmask=0x5,name='EXE_ACTIVITY.BOUND_ON_LOADS'/uk                             \
-e cpu/period=0x4c4b4f,event=0x9c,umask=0x1,name='IDQ_UOPS_NOT_DELIVERED.CORE'/uk                                        \
-e cpu/period=0x4c4b4f,event=0xad,umask=0x10,name='INT_MISC.UOP_DROPPING'/uk                                             \
-e cpu/period=0x4c4b4f,event=0x47,umask=0x3,cmask=0x3,name='MEMORY_ACTIVITY.STALLS_L1D_MISS'/uk                          \
-e cpu/period=0x4c4b4f,event=0x47,umask=0x5,cmask=0x5,name='MEMORY_ACTIVITY.STALLS_L2_MISS'/uk                           \
-e cpu/period=0x4c4b4f,event=0x47,umask=0x9,cmask=0x9,name='MEMORY_ACTIVITY.STALLS_L3_MISS'/uk                           \
-e cpu/period=0x7a143,event=0xd3,umask=0x1,name='MEM_LOAD_L3_MISS_RETIRED.LOCAL_DRAM'/uk                                 \
-e cpu/period=0x4c4b4f,event=0xd3,umask=0x2,name='MEM_LOAD_L3_MISS_RETIRED.REMOTE_DRAM'/uk                               \
-e cpu/period=0x7a143,event=0xd3,umask=0x8,name='MEM_LOAD_L3_MISS_RETIRED.REMOTE_FWD'/uk                                 \
-e cpu/period=0x4c4b4f,event=0xd3,umask=0x4,name='MEM_LOAD_L3_MISS_RETIRED.REMOTE_HITM'/uk                               \
-e cpu/period=0x7a143,event=0xd3,umask=0x10,name='MEM_LOAD_L3_MISS_RETIRED.REMOTE_PMM'/uk                                \
-e cpu/period=0x7a143,event=0xd1,umask=0x40,name='MEM_LOAD_RETIRED.FB_HIT'/uk                                            \
-e cpu/period=0x4c4b4f,event=0xd1,umask=0x1,name='MEM_LOAD_RETIRED.L1_HIT'/uk                                            \
-e cpu/period=0xf424f,event=0xd1,umask=0x8,name='MEM_LOAD_RETIRED.L1_MISS'/uk                                            \
-e cpu/period=0xf424f,event=0xd1,umask=0x2,name='MEM_LOAD_RETIRED.L2_HIT'/uk                                             \
-e cpu/period=0x7a189,event=0xd1,umask=0x4,name='MEM_LOAD_RETIRED.L3_HIT'/uk                                             \
-e cpu/period=0x3d0f9,event=0xd1,umask=0x20,name='MEM_LOAD_RETIRED.L3_MISS'/uk                                           \
-e cpu/period=0x4c4b4f,event=0xd1,umask=0x80,name='MEM_LOAD_RETIRED.LOCAL_PMM'/uk                                        \
-e cpu/period=0x4c4b4f,event=0x20,umask=0x8,cmask=0x4,name='OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD_cmask_4'/uk         \
-e cpu/period=0x4c4b4f,event=0x20,umask=0x8,cmask=0x1,name='OFFCORE_REQUESTS_OUTSTANDING.CYCLES_WITH_DATA_RD'/uk         \
-e cpu/period=0x2faf090,event=0xa4,umask=0x2,name='TOPDOWN.BACKEND_BOUND_SLOTS'/uk                                       \
-e cpu/period=0x2faf090,event=0xa4,umask=0x10,name='TOPDOWN.MEMORY_BOUND_SLOTS'/uk                                       \
-e cpu/period=0x98968f,event=0xc2,umask=0x2,name='UOPS_RETIRED.SLOTS'/uk                                                 \
-e cpu/period=0x7a12f,event=0xd0,umask=0x82,name='MEM_INST_RETIRED.ALL_STORES'/uk                                        \
-e cpu/period=0x7a12f,event=0xd0,umask=0x81,name='MEM_INST_RETIRED.ALL_LOADS'/uk                                         \
-e cpu/period=0x98968f,event=0xc7,umask=0x2,name='FP_ARITH_INST_RETIRED.SCALAR_SINGLE'/uk                                \
-e cpu/period=0x98968f,event=0xc7,umask=0x8,name='FP_ARITH_INST_RETIRED.128B_PACKED_SINGLE'/uk                           \
-e cpu/period=0x98968f,event=0xc7,umask=0x20,name='FP_ARITH_INST_RETIRED.256B_PACKED_SINGLE'/uk                          \
-e cpu/period=0x98968f,event=0xc7,umask=0x1,name='FP_ARITH_INST_RETIRED.SCALAR_DOUBLE'/uk                                \
-e cpu/period=0x98968f,event=0xc7,umask=0x4,name='FP_ARITH_INST_RETIRED.128B_PACKED_DOUBLE'/uk                           \
-e cpu/period=0x98968f,event=0xc7,umask=0x10,name='FP_ARITH_INST_RETIRED.256B_PACKED_DOUBLE'/uk                          \
-e cpu/period=0x98968f,event=0xb1,umask=0x10,name='UOPS_EXECUTED.X87'/uk                                                 \
-e cpu/period=0x98968f,event=0xb1,umask=0x1,name='UOPS_EXECUTED.THREAD'/uk                                               \
-e cpu/period=0x98968f,event=0xc7,umask=0x40,name='FP_ARITH_INST_RETIRED.512B_PACKED_DOUBLE'/uk                          \
-e cpu/period=0x98968f,event=0xc7,umask=0x80,name='FP_ARITH_INST_RETIRED.512B_PACKED_SINGLE'/uk                          \
-e cpu/period=0x98968f,event=0xce,umask=0x1,name='AMX_OPS_RETIRED.INT8'/uk                                               \
-e cpu/period=0x98968f,event=0xce,umask=0x2,name='AMX_OPS_RETIRED.BF16'/uk                                               \
-e cpu/period=0x98968f,event=0xcf,umask=0x1,name='FP_ARITH_INST_RETIRED2.SCALAR_HALF'/uk                                 \
-e cpu/period=0x98968f,event=0xcf,umask=0x4,name='FP_ARITH_INST_RETIRED2.128B_PACKED_HALF'/uk                            \
-e cpu/period=0x98968f,event=0xcf,umask=0x8,name='FP_ARITH_INST_RETIRED2.256B_PACKED_HALF'/uk                            \
-e cpu/period=0x98968f,event=0xcf,umask=0x10,name='FP_ARITH_INST_RETIRED2.512B_PACKED_HALF'/uk                           \
-e cpu/period=0xcdfe60,event=0xc0,name='INST_RETIRED.ANY_P'/uk                                                           \
-e cpu/period=0x2faf090,event=0xa4,umask=0x1,name='TOPDOWN.SLOTS_P'/uk


> 
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 +-
>  arch/x86/include/asm/kvm_host.h        | 11 ++-
>  arch/x86/kvm/pmu.c                     | 94 ++++++++++++++++++++++----
>  arch/x86/kvm/pmu.h                     | 53 +++------------
>  arch/x86/kvm/svm/pmu.c                 | 19 +-----
>  arch/x86/kvm/vmx/pmu_intel.c           | 26 +------
>  6 files changed, 103 insertions(+), 102 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index 6c98f4bb4228..058bc636356a 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -22,7 +22,7 @@ KVM_X86_PMU_OP(get_msr)
>  KVM_X86_PMU_OP(set_msr)
>  KVM_X86_PMU_OP(refresh)
>  KVM_X86_PMU_OP(init)
> -KVM_X86_PMU_OP(reset)
> +KVM_X86_PMU_OP_OPTIONAL(reset)
>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 28bd38303d70..337f5e1da57c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -492,8 +492,17 @@ struct kvm_pmc {
>  	u8 idx;
>  	bool is_paused;
>  	bool intr;
> +	/*
> +	 * Value of the PMC counter that has been gathered from the associated
> +	 * perf_event and from emulated_counter.  This is *not* the current
> +	 * value as seen by the guest or userspace.
> +	 */
>  	u64 counter;
> -	u64 prev_counter;
> +	/*
> +	 * PMC events triggered by KVM emulation that haven't been fully
> +	 * procssed, e.g. haven't undergone overflow detection.
> +	 */
> +	u64 emulated_counter;
>  	u64 eventsel;
>  	struct perf_event *perf_event;
>  	struct kvm_vcpu *vcpu;
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index bf653df86112..472e45f5993f 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -148,9 +148,9 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
>  	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
>  
>  	/*
> -	 * Ignore overflow events for counters that are scheduled to be
> -	 * reprogrammed, e.g. if a PMI for the previous event races with KVM's
> -	 * handling of a related guest WRMSR.
> +	 * Ignore asynchronous overflow events for counters that are scheduled
> +	 * to be reprogrammed, e.g. if a PMI for the previous event races with
> +	 * KVM's handling of a related guest WRMSR.
>  	 */
>  	if (test_and_set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi))
>  		return;
> @@ -182,6 +182,21 @@ static u64 pmc_get_pebs_precise_level(struct kvm_pmc *pmc)
>  	return 1;
>  }
>  
> +static u64 pmc_get_sample_period(struct kvm_pmc *pmc)
> +{
> +	u64 sample_period = (-pmc->counter) & pmc_bitmask(pmc);
> +
> +	/*
> +	 * Verify pmc->counter is fresh, i.e. that the perf event is paused and
> +	 * emulated events have been gathered.
> +	 */
> +	WARN_ON_ONCE(pmc->emulated_counter || (pmc->perf_event && !pmc->is_paused));
> +
> +	if (!sample_period)
> +		sample_period = pmc_bitmask(pmc) + 1;
> +	return sample_period;
> +}
> +
>  static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
>  				 bool exclude_user, bool exclude_kernel,
>  				 bool intr)
> @@ -200,7 +215,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
>  	};
>  	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
>  
> -	attr.sample_period = get_sample_period(pmc, pmc->counter);
> +	attr.sample_period = pmc_get_sample_period(pmc);
>  
>  	if ((attr.config & HSW_IN_TX_CHECKPOINTED) &&
>  	    guest_cpuid_is_intel(pmc->vcpu)) {
> @@ -238,13 +253,19 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
>  
>  static void pmc_pause_counter(struct kvm_pmc *pmc)
>  {
> -	u64 counter = pmc->counter;
> +	/*
> +	 * Accumulate emulated events, even if the PMC was already paused, e.g.
> +	 * if KVM emulated an event after a WRMSR, but before reprogramming, or
> +	 * if KVM couldn't create a perf event.
> +	 */
> +	u64 counter = pmc->counter + pmc->emulated_counter;
>  
> -	if (!pmc->perf_event || pmc->is_paused)
> -		return;
> +	pmc->emulated_counter = 0;
>  
>  	/* update counter, reset event value to avoid redundant accumulation */
> -	counter += perf_event_pause(pmc->perf_event, true);
> +	if (pmc->perf_event && !pmc->is_paused)
> +		counter += perf_event_pause(pmc->perf_event, true);
> +
>  	pmc->counter = counter & pmc_bitmask(pmc);
>  	pmc->is_paused = true;
>  }
> @@ -256,8 +277,7 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>  
>  	/* recalibrate sample period and check if it's accepted by perf core */
>  	if (is_sampling_event(pmc->perf_event) &&
> -	    perf_event_period(pmc->perf_event,
> -			      get_sample_period(pmc, pmc->counter)))
> +	    perf_event_period(pmc->perf_event, pmc_get_sample_period(pmc)))
>  		return false;
>  
>  	if (test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) !=
> @@ -395,6 +415,32 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>  	return is_fixed_event_allowed(filter, pmc->idx);
>  }
>  
> +void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
> +{
> +	pmc_pause_counter(pmc);
> +	pmc->counter = val & pmc_bitmask(pmc);
> +	kvm_pmu_request_counter_reprogram(pmc);
> +}
> +EXPORT_SYMBOL_GPL(pmc_write_counter);
> +
> +static void pmc_release_perf_event(struct kvm_pmc *pmc)
> +{
> +	if (pmc->perf_event) {
> +		perf_event_release_kernel(pmc->perf_event);
> +		pmc->perf_event = NULL;
> +		pmc->current_config = 0;
> +		pmc_to_pmu(pmc)->event_count--;
> +	}
> +}
> +
> +static void pmc_stop_counter(struct kvm_pmc *pmc)
> +{
> +	if (pmc->perf_event) {
> +		pmc_pause_counter(pmc);
> +		pmc_release_perf_event(pmc);
> +	}
> +}
> +
>  static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
>  {
>  	return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc) &&
> @@ -404,6 +450,7 @@ static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
>  static void reprogram_counter(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +	u64 prev_counter = pmc->counter;
>  	u64 eventsel = pmc->eventsel;
>  	u64 new_config = eventsel;
>  	u8 fixed_ctr_ctrl;
> @@ -413,7 +460,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>  	if (!pmc_event_is_allowed(pmc))
>  		goto reprogram_complete;
>  
> -	if (pmc->counter < pmc->prev_counter)
> +	if (pmc->counter < prev_counter)
>  		__kvm_perf_overflow(pmc, false);
>  
>  	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
> @@ -453,7 +500,6 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>  
>  reprogram_complete:
>  	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
> -	pmc->prev_counter = 0;
>  }
>  
>  void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
> @@ -678,9 +724,28 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc;
> +	int i;
>  
>  	irq_work_sync(&pmu->irq_work);
> -	static_call(kvm_x86_pmu_reset)(vcpu);
> +
> +	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
> +
> +	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
> +		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
> +		if (!pmc)
> +			continue;
> +
> +		pmc_stop_counter(pmc);
> +		pmc->counter = 0;
> +
> +		if (pmc_is_gp(pmc))
> +			pmc->eventsel = 0;
> +	};
> +
> +	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
> +
> +	static_call_cond(kvm_x86_pmu_reset)(vcpu);
>  }
>  
>  void kvm_pmu_init(struct kvm_vcpu *vcpu)
> @@ -727,8 +792,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>  
>  static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
>  {
> -	pmc->prev_counter = pmc->counter;
> -	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
> +	pmc->emulated_counter++;
>  	kvm_pmu_request_counter_reprogram(pmc);
>  }
>  
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7d9ba301c090..0ac60ffae944 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -55,6 +55,12 @@ static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
>  	return pmu->version > 1;
>  }
>  
> +static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
> +{
> +	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
> +	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> +}
> +
>  static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -66,31 +72,17 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
>  {
>  	u64 counter, enabled, running;
>  
> -	counter = pmc->counter;
> +	counter = pmc->counter + pmc->emulated_counter;
> +
>  	if (pmc->perf_event && !pmc->is_paused)
>  		counter += perf_event_read_value(pmc->perf_event,
>  						 &enabled, &running);
> +
>  	/* FIXME: Scaling needed? */
>  	return counter & pmc_bitmask(pmc);
>  }
>  
> -static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
> -{
> -	if (pmc->perf_event) {
> -		perf_event_release_kernel(pmc->perf_event);
> -		pmc->perf_event = NULL;
> -		pmc->current_config = 0;
> -		pmc_to_pmu(pmc)->event_count--;
> -	}
> -}
> -
> -static inline void pmc_stop_counter(struct kvm_pmc *pmc)
> -{
> -	if (pmc->perf_event) {
> -		pmc->counter = pmc_read_counter(pmc);
> -		pmc_release_perf_event(pmc);
> -	}
> -}
> +void pmc_write_counter(struct kvm_pmc *pmc, u64 val);
>  
>  static inline bool pmc_is_gp(struct kvm_pmc *pmc)
>  {
> @@ -140,25 +132,6 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
>  	return NULL;
>  }
>  
> -static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
> -{
> -	u64 sample_period = (-counter_value) & pmc_bitmask(pmc);
> -
> -	if (!sample_period)
> -		sample_period = pmc_bitmask(pmc) + 1;
> -	return sample_period;
> -}
> -
> -static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
> -{
> -	if (!pmc->perf_event || pmc->is_paused ||
> -	    !is_sampling_event(pmc->perf_event))
> -		return;
> -
> -	perf_event_period(pmc->perf_event,
> -			  get_sample_period(pmc, pmc->counter));
> -}
> -
>  static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -214,12 +187,6 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  					     KVM_PMC_MAX_FIXED);
>  }
>  
> -static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
> -{
> -	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
> -	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> -}
> -
>  static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
>  {
>  	int bit;
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index cef5a3d0abd0..b6a7ad4d6914 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -160,8 +160,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	/* MSR_PERFCTRn */
>  	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
>  	if (pmc) {
> -		pmc->counter += data - pmc_read_counter(pmc);
> -		pmc_update_sample_period(pmc);
> +		pmc_write_counter(pmc, data);
>  		return 0;
>  	}
>  	/* MSR_EVNTSELn */
> @@ -233,21 +232,6 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static void amd_pmu_reset(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	int i;
> -
> -	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
> -		struct kvm_pmc *pmc = &pmu->gp_counters[i];
> -
> -		pmc_stop_counter(pmc);
> -		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
> -	}
> -
> -	pmu->global_ctrl = pmu->global_status = 0;
> -}
> -
>  struct kvm_pmu_ops amd_pmu_ops __initdata = {
>  	.hw_event_available = amd_hw_event_available,
>  	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
> @@ -259,7 +243,6 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>  	.set_msr = amd_pmu_set_msr,
>  	.refresh = amd_pmu_refresh,
>  	.init = amd_pmu_init,
> -	.reset = amd_pmu_reset,
>  	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
>  	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
>  	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 80c769c58a87..ce49d060bc96 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -406,12 +406,10 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			if (!msr_info->host_initiated &&
>  			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
>  				data = (s64)(s32)data;
> -			pmc->counter += data - pmc_read_counter(pmc);
> -			pmc_update_sample_period(pmc);
> +			pmc_write_counter(pmc, data);
>  			break;
>  		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
> -			pmc->counter += data - pmc_read_counter(pmc);
> -			pmc_update_sample_period(pmc);
> +			pmc_write_counter(pmc, data);
>  			break;
>  		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
>  			reserved_bits = pmu->reserved_bits;
> @@ -603,26 +601,6 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
>  
>  static void intel_pmu_reset(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	struct kvm_pmc *pmc = NULL;
> -	int i;
> -
> -	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
> -		pmc = &pmu->gp_counters[i];
> -
> -		pmc_stop_counter(pmc);
> -		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
> -	}
> -
> -	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
> -		pmc = &pmu->fixed_counters[i];
> -
> -		pmc_stop_counter(pmc);
> -		pmc->counter = pmc->prev_counter = 0;
> -	}
> -
> -	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
> -
>  	intel_pmu_release_guest_lbr_event(vcpu);
>  }
>  
> 
> base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
> -- 
> 

-- 
Thanks,
Dapeng Mi
