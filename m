Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922B81D9492
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgESKpf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 06:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgESKpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 06:45:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508B0C061A0C;
        Tue, 19 May 2020 03:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pB5NRJiuRUwl08JuJrqjBdvxfdMkqgbTh44+AX2Pej4=; b=JM3gb/rwk7cxihpdlXrca4GnSh
        +KvmhEWySmqxKBMY3vYlLXBmCoYc+OHTDmsKLPdQnumlYHB1kmX4/y838TAHRgESKpsYMQdVssDMn
        YjqUsSQO7uigXSpqd/+Z0z/r050D6Pu4FMvM7anscLFMHNtAZutmrRgxuOOMTj//WYYIz8Hsk1W75
        3GHqyedbNnLXF8BUNCKPJ0hmGO8ZkgJCO6qfZTCnEcgQk9Hu8qnKRlUbmAJS8NaDEeqVHSVoPGRZC
        XSmSqp3NDgFaXAzDBBt9TWs6BHdR5cUnSc+yN4cdbT4H3ZI/d5huiC+ns0OoyHg00Mp1ZQrog83w3
        5fjNukvA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jazkS-0004tF-BY; Tue, 19 May 2020 10:45:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CAF1E30067C;
        Tue, 19 May 2020 12:45:20 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B72A52105F3B6; Tue, 19 May 2020 12:45:20 +0200 (CEST)
Date:   Tue, 19 May 2020 12:45:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 05/11] perf/x86: Keep LBR stack unchanged in host
 context for guest LBR event
Message-ID: <20200519104520.GE279861@hirez.programming.kicks-ass.net>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-6-like.xu@linux.intel.com>
 <20200518120205.GF277222@hirez.programming.kicks-ass.net>
 <dd6b0ab0-0209-e1e5-550c-24e2ad101b15@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd6b0ab0-0209-e1e5-550c-24e2ad101b15@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 11:08:41AM +0800, Like Xu wrote:

> Sure, I could reuse cpuc->intel_ctrl_guest_mask to rewrite this part:
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index d788edb7c1f9..f1243e8211ca 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2189,7 +2189,8 @@ static void intel_pmu_disable_event(struct perf_event
> *event)
>         } else if (idx == INTEL_PMC_IDX_FIXED_BTS) {
>                 intel_pmu_disable_bts();
>                 intel_pmu_drain_bts_buffer();
> -       }
> +       } else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
> +               intel_clear_masks(event, idx);
> 
>         /*
>          * Needs to be called after x86_pmu_disable_event,
> @@ -2271,7 +2272,8 @@ static void intel_pmu_enable_event(struct perf_event
> *event)
>                 if (!__this_cpu_read(cpu_hw_events.enabled))
>                         return;
>                 intel_pmu_enable_bts(hwc->config);
> -       }
> +       } else if (idx == INTEL_PMC_IDX_FIXED_VLBR)
> +               intel_set_masks(event, idx);
>  }

This makes me wonder if we can pull intel_{set,clear}_masks() out of
that if()-forest, but that's something for later...

>  static void intel_pmu_add_event(struct perf_event *event)
> diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
> index b8dabf1698d6..1b30c76815dd 100644
> --- a/arch/x86/events/intel/lbr.c
> +++ b/arch/x86/events/intel/lbr.c
> @@ -552,11 +552,19 @@ void intel_pmu_lbr_del(struct perf_event *event)
>         perf_sched_cb_dec(event->ctx->pmu);
>  }
> 
> +static inline bool vlbr_is_enabled(void)
> +{
> +       struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> +
> +       return test_bit(INTEL_PMC_IDX_FIXED_VLBR,
> +               (unsigned long *)&cpuc->intel_ctrl_guest_mask);
> +}

Maybe call this: vlbr_exclude_host() ?

> +
>  void intel_pmu_lbr_enable_all(bool pmi)
>  {
>         struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> 
> -       if (cpuc->lbr_users)
> +       if (cpuc->lbr_users && !vlbr_is_enabled())
>                 __intel_pmu_lbr_enable(pmi);
>  }
> 
> @@ -564,7 +572,7 @@ void intel_pmu_lbr_disable_all(void)
>  {
>         struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> 
> -       if (cpuc->lbr_users)
> +       if (cpuc->lbr_users && !vlbr_is_enabled())
>                 __intel_pmu_lbr_disable();
>  }
> 
> @@ -706,7 +714,8 @@ void intel_pmu_lbr_read(void)
>          * This could be smarter and actually check the event,
>          * but this simple approach seems to work for now.
>          */
> -       if (!cpuc->lbr_users || cpuc->lbr_users == cpuc->lbr_pebs_users)
> +       if (!cpuc->lbr_users || vlbr_is_enabled() ||
> +               cpuc->lbr_users == cpuc->lbr_pebs_users)
>                 return;
> 
>         if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
> 
> Is this acceptable to you ?

Yeah, looks about right. Let me stare at the rest.
