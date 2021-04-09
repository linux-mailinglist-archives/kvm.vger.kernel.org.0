Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DA2359708
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 10:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhDIIBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 04:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhDIIBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 04:01:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE704C061760;
        Fri,  9 Apr 2021 01:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=FBBCcKjF57MH1xVZJbOS7A+iZ2Mlo9rVCVoyG7F1BLU=; b=LV3h7AtbxwmFNKcPt5ObCBvM1s
        0aReEqpIUgSik2JEt4mZYES0O2A0aYkUowCjLaMRUiK2b/SNVxRDoWi9g24/r7Rcw7x7R/7WyOe75
        FQzSbd0+9VFMhTyTmMNtXEOQrLLPnxGx5UdZ/2s2wpJZzWGLxyaTIUbyVl5fTSbKyuiKHNZqrMRnH
        Sc9TK/c54PCBUgHhvoF0Vl6um6aqYuH4/7qXczeDfZlmCZKqhhFHLsOhK/TcabaTupPwlv5ObtlDW
        HCJ+lpB0FHRzanOzelH4PHsvYS2Fje/l14BepCUrf6gsb2HTFPG3yA2qLfJbBWVzzdGorMolvIxdT
        q/nk9F1A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lUm36-0000t0-Fe; Fri, 09 Apr 2021 07:59:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3A6BF300036;
        Fri,  9 Apr 2021 09:59:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 14A072C71EDC4; Fri,  9 Apr 2021 09:59:26 +0200 (CEST)
Date:   Fri, 9 Apr 2021 09:59:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v4 08/16] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to
 manage guest DS buffer
Message-ID: <YHAJXh2AtSMcC5xf@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-9-like.xu@linux.intel.com>
 <YG3SPsiFJPeXQXhq@hirez.programming.kicks-ass.net>
 <610bfd14-3250-0542-2d93-cbd15f2b4e16@intel.com>
 <YG62VBBix2WVy3XA@hirez.programming.kicks-ass.net>
 <8695f271-9da9-f16d-15f2-e2757186db65@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8695f271-9da9-f16d-15f2-e2757186db65@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 03:07:38PM +0800, Xu, Like wrote:
> Hi Peter,
> 
> On 2021/4/8 15:52, Peter Zijlstra wrote:
> > > This is because in the early part of this function, we have operations:
> > > 
> > >      if (x86_pmu.flags & PMU_FL_PEBS_ALL)
> > >          arr[0].guest &= ~cpuc->pebs_enabled;
> > >      else
> > >          arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> > > 
> > > and if guest has PEBS_ENABLED, we need these bits back for PEBS counters:
> > > 
> > >      arr[0].guest |= arr[1].guest;
> 
> > I don't think that's right, who's to say they were set in the first
> > place? The guest's GLOBAL_CTRL could have had the bits cleared at VMEXIT
> > time. You can't unconditionally add PEBS_ENABLED into GLOBAL_CTRL,
> > that's wrong.

> I can't keep up with you on this comment and would you explain more ?

Well, it could be I'm terminally confused on how virt works (I usually
am, it just doesn't make any sense ever).

On top of that this code doesn't have any comments to help.

So perf_guest_switch_msr has two msr values: guest and host.

In my naive understanding guest is the msr value the guest sees and host
is the value the host has. If it is not that, then the naming is just
misleading at best.

But thinking more about it, if these are fully emulated MSRs (which I
think they are), then there might actually be 3 different values, not 2.

We have the value the guest sees when it uses {RD,WR}MSR.
We have the value the hardware has when it runs a guest.
We have the value the hardware has when it doesn't run a guest.

And somehow this code does something, but I can't for the life of me
figure out what and how.

> To address your previous comments, does the code below look good to you?
> 
> static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
> {
>     struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>     struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>     struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
>     struct kvm_pmu *pmu = (struct kvm_pmu *)data;
>     u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
>             cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);
>     int i = 0;
> 
>     arr[i].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>     arr[i].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>     arr[i].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
>     arr[i].guest &= ~pebs_mask;
> 
>     if (!x86_pmu.pebs)
>         goto out;
> 
>     /*
>      * If PMU counter has PEBS enabled it is not enough to
>      * disable counter on a guest entry since PEBS memory
>      * write can overshoot guest entry and corrupt guest
>      * memory. Disabling PEBS solves the problem.
>      *
>      * Don't do this if the CPU already enforces it.
>      */
>     if (x86_pmu.pebs_no_isolation) {
>         i++;
>         arr[i].msr = MSR_IA32_PEBS_ENABLE;
>         arr[i].host = cpuc->pebs_enabled;
>         arr[i].guest = 0;
>         goto out;
>     }
> 
>     if (!pmu || !x86_pmu.pebs_vmx)
>         goto out;
> 
>     i++;
>     arr[i].msr = MSR_IA32_DS_AREA;
>     arr[i].host = (unsigned long)ds;
>     arr[i].guest = pmu->ds_area;
> 
>     if (x86_pmu.intel_cap.pebs_baseline) {
>         i++;
>         arr[i].msr = MSR_PEBS_DATA_CFG;
>         arr[i].host = cpuc->pebs_data_cfg;
>         arr[i].guest = pmu->pebs_data_cfg;
>     }
> 
>     i++;
>     arr[i].msr = MSR_IA32_PEBS_ENABLE;
>     arr[i].host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask;
>     arr[i].guest = pebs_mask & ~cpuc->intel_ctrl_host_mask;
> 
>     if (arr[i].host) {
>         /* Disable guest PEBS if host PEBS is enabled. */
>         arr[i].guest = 0;
>     } else {
>         /* Disable guest PEBS for cross-mapped PEBS counters. */
>         arr[i].guest &= ~pmu->host_cross_mapped_mask;
>         arr[0].guest |= arr[i].guest;
>     }
> 
> out:
>     *nr = ++i;
>     return arr;
> }

The ++ is in a weird location, if you place it after filling out an
entry it makes more sense I think. Something like:

	arr[i].msr = MSR_CORE_PERF_GLOBAL_CTRL;
	arr[i].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
	arr[i].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
	arr[i].guest &= ~pebs_mask;
	i++;

or, perhaps even like:

	arr[i++] = (struct perf_guest_switch_msr){
		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
		.host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
		.guest = x86_pmu.intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
	};

But it doesn't address the fundamental confusion I seem to be having,
what actual msr value is what.
