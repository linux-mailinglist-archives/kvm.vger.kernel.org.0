Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE68775591
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbjHIIij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 04:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjHIIih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 04:38:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5841BD9;
        Wed,  9 Aug 2023 01:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691570315; x=1723106315;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tziAmXkAYaSE5qwVJW6lzgz/AleIpw8ZRRXgZDA5K74=;
  b=TSrw+8Vq9I3wg7rQagXRF6r3XXRm6DCQK5Iys1FF8DFiDLBJA584NQi4
   VZZICvCZgk86Ul8Svk+sJAjmDUEyQV0NCTRGurV2BoCBhr9wZSOKjmW3C
   EVHpRhwBiRqJLtFeVNQSjRq61io0YXfPZuz04MQPlNEFPRVHQe9+p/hjV
   7c3nLkJkXlBhgv4j0cwcTEOhEMG3cEYwmj6ATvPHoSxWQmN2WwSfmXqcl
   jeRYGKbHr8UsEOWPZz5jFjoY1oAY3SbCbO9J0j3/sHC/vzDuv9TrS3qB1
   9v89+fBzxF/1EFusymusCSBIpfGWFUgJd2p9j/5WTJGdW/Zj+E7uo3WnN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="351372949"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="351372949"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 01:38:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="797089523"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="797089523"
Received: from dmi-pnp-i7.sh.intel.com (HELO localhost) ([10.239.159.155])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2023 01:38:27 -0700
Date:   Wed, 9 Aug 2023 16:44:53 +0800
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH RFV v2 05/13] perf/core: Add function
 perf_event_create_group_kernel_counters()
Message-ID: <ZNNSBZIQERc/nZXQ@dmi-pnp-i7>
References: <20230808063111.1870070-1-dapeng1.mi@linux.intel.com>
 <20230808063111.1870070-6-dapeng1.mi@linux.intel.com>
 <20230808102127.GZ212435@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808102127.GZ212435@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023 at 12:21:27PM +0200, Peter Zijlstra wrote:
> Date: Tue, 8 Aug 2023 12:21:27 +0200
> From: Peter Zijlstra <peterz@infradead.org>
> Subject: Re: [PATCH RFV v2 05/13] perf/core: Add function
>  perf_event_create_group_kernel_counters()
> 
> On Tue, Aug 08, 2023 at 02:31:03PM +0800, Dapeng Mi wrote:
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 15eb82d1a010..1877171e9590 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -12762,11 +12762,34 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
> >  				 struct task_struct *task,
> >  				 perf_overflow_handler_t overflow_handler,
> >  				 void *context)
> > +{
> > +	return perf_event_create_group_kernel_counters(attr, cpu, task,
> > +			NULL, overflow_handler, context);
> > +}
> > +EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
> > +
> > +/**
> > + * perf_event_create_group_kernel_counters
> > + *
> > + * @attr: attributes of the counter to create
> > + * @cpu: cpu in which the counter is bound
> > + * @task: task to profile (NULL for percpu)
> > + * @group_leader: the group leader event of the created event
> > + * @overflow_handler: callback to trigger when we hit the event
> > + * @context: context data could be used in overflow_handler callback
> > + */
> > +struct perf_event *
> > +perf_event_create_group_kernel_counters(struct perf_event_attr *attr,
> > +					int cpu, struct task_struct *task,
> > +					struct perf_event *group_leader,
> > +					perf_overflow_handler_t overflow_handler,
> > +					void *context)
> 
> I would much prefer if you just add the argument to
> perf_event_create_kernel_counter(), there aren't *that* many users.

Sure. Thanks.

-- 
Thanks,
Dapeng Mi
