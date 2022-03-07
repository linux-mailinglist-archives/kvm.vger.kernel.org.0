Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3594CFEE9
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 13:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbiCGMhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbiCGMh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:37:26 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F57D424AF;
        Mon,  7 Mar 2022 04:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646656571; x=1678192571;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yrdF25iT52XAtwb6HtvmSGaVHOaZC8q1BXW6Q9LjzsY=;
  b=Uxdah2WaBk/CB1XOwLG6S6/SMecoYLQN0FVfcnoLg2mvbVH74PLFyIMR
   IZPwJh3STm9/+pmO/xzBaN43c9fzw3LKXErwqPjEjPYhREBLhutiIAWWd
   67RRXBqXDCs/X6pG+Bh55J6CncMVq4KEJ7mhJVK4Yyds2oucfZePMhHCO
   RFujHfXbnT2Cw/Q57CQ7KR/GhwKXNUgbbN6N5vrmihux2KlDcGjxuVYhO
   e8AeQcWJI4bEzhoaeu4sORwCI11YAcqBIcDMlVNVBhSSyLtiiCMltIkEe
   aiD2jX85odKb/vzmridtBeLip/P6z2iOpsS7LuZ5fjCoYszZ2KfNLwM3F
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="317610619"
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="317610619"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 04:36:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="553136286"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by orsmga008.jf.intel.com with ESMTP; 07 Mar 2022 04:36:04 -0800
Message-ID: <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
Date:   Mon, 7 Mar 2022 14:36:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>, jgross@suse.com,
        sdeep@vmware.com, pv-drivers@vmware.com, pbonzini@redhat.com,
        seanjc@google.com, kys@microsoft.com, sthemmin@microsoft.com,
        virtualization@lists.linux-foundation.org,
        Andrew.Cooper3@citrix.com
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/03/2022 11:50, Peter Zijlstra wrote:
> On Fri, Mar 04, 2022 at 08:27:45PM +0200, Adrian Hunter wrote:
>> On 04/03/2022 15:41, Peter Zijlstra wrote:
>>> On Mon, Feb 14, 2022 at 01:09:06PM +0200, Adrian Hunter wrote:
>>>> Currently, when Intel PT is used within a VM guest, it is not possible to
>>>> make use of TSC because perf clock is subject to paravirtualization.
>>>
>>> Yeah, so how much of that still makes sense, or ever did? AFAIK the
>>> whole pv_clock thing is utter crazy. Should we not fix that instead?
>>
>> Presumably pv_clock must work with different host operating systems.
>> Similarly, KVM must work with different guest operating systems.
>> Perhaps I'm wrong, but I imagine re-engineering time virtualization
>> might be a pretty big deal,  far exceeding the scope of these patches.
> 
> I think not; on both counts. That is, I don't think it's going to be
> hard, and even it if were, it would still be the right thing to do.
> 
> We're not going to add interface just to work around a known broken
> piece of crap just because we don't want to fix it.
> 
> So I'm thinking we should do the below and simply ignore any paravirt
> sched clock offered when there's ART on.
> 
> ---
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 4420499f7bb4..a1f179ed39bf 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -145,6 +145,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
>  
>  void paravirt_set_sched_clock(u64 (*func)(void))
>  {
> +	/*
> +	 * Anything with ART on promises to have sane TSC, otherwise the whole
> +	 * ART thing is useless. In order to make ART useful for guests, we
> +	 * should continue to use the TSC. As such, ignore any paravirt
> +	 * muckery.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_ART))

Does not seem to work because the feature X86_FEATURE_ART does not seem to get set.
Possibly because detect_art() excludes anything running on a hypervisor.

> +		return;
> +
>  	static_call_update(pv_sched_clock, func);
>  }
>  

