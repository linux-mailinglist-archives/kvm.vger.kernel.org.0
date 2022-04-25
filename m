Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBA250D8DE
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 07:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbiDYFfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 01:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239961AbiDYFfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 01:35:04 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48966263F;
        Sun, 24 Apr 2022 22:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650864721; x=1682400721;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=uRjpvrn6fat50gU61mLUaxLzgOtTofX/Vbsr1sYOfiE=;
  b=X8rEeaR2l2NB2wIWs511Lvv4BK8F/Fu8CjDWmJtf8+3jcZVXF+k/LgC/
   hZmZSNMrFVUs9YhFKNSTw4NsSfrm6PTLdXp8BOF7cUV8GwIs4p5jXa8wO
   IRIPWfR6N3eXS+SUoPVr2HW05ImIFDr4ig8+fWbw1JAjkCxGHqQZWX3Mw
   FYkG1hnbx7es7Hfg9g8CbzqoUBrnwEHAdYtrTZqeg/dnTI2F+rYeVSDzn
   ZqC+IR7abBotuvildJlAdRUlLOUeI9F4mEuWhM4D8P3gVLKPbzyYf766X
   ltPFhfZG5OdTJv3Y2zy3FR0bvZZlnFpaHM/Cez3xcTPk9WHqBOu/Gzbuq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="351592660"
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="351592660"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 22:31:06 -0700
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="579083258"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.46.155])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 22:30:59 -0700
Message-ID: <50fd2671-6070-0eba-ea68-9df9b79ccac3@intel.com>
Date:   Mon, 25 Apr 2022 08:30:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sdeep@vmware.com" <sdeep@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Andrew.Cooper3@citrix.com" <Andrew.Cooper3@citrix.com>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
 <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
 <YiYZv+LOmjzi5wcm@hirez.programming.kicks-ass.net>
 <013b5425-2a60-e4d4-b846-444a576f2b28@intel.com>
 <6f07a7d4e1ad4440bf6c502c8cb6c2ed@intel.com>
 <c3e1842b-79c3-634a-3121-938b5160ca4c@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <c3e1842b-79c3-634a-3121-938b5160ca4c@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/03/22 13:50, Adrian Hunter wrote:
> On 08/03/2022 23:06, Hall, Christopher S wrote:
>> Adrian Hunter wrote:
>>> On 7.3.2022 16.42, Peter Zijlstra wrote:
>>>> On Mon, Mar 07, 2022 at 02:36:03PM +0200, Adrian Hunter wrote:
>>>>
>>>>>> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
>>>>>> index 4420499f7bb4..a1f179ed39bf 100644
>>>>>> --- a/arch/x86/kernel/paravirt.c
>>>>>> +++ b/arch/x86/kernel/paravirt.c
>>>>>> @@ -145,6 +145,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
>>>>>>
>>>>>>  void paravirt_set_sched_clock(u64 (*func)(void))
>>>>>>  {
>>>>>> +	/*
>>>>>> +	 * Anything with ART on promises to have sane TSC, otherwise the whole
>>>>>> +	 * ART thing is useless. In order to make ART useful for guests, we
>>>>>> +	 * should continue to use the TSC. As such, ignore any paravirt
>>>>>> +	 * muckery.
>>>>>> +	 */
>>>>>> +	if (cpu_feature_enabled(X86_FEATURE_ART))
>>>>>
>>>>> Does not seem to work because the feature X86_FEATURE_ART does not seem to get set.
>>>>> Possibly because detect_art() excludes anything running on a hypervisor.
>>>>
>>>> Simple enough to delete that clause I suppose. Christopher, what is
>>>> needed to make that go away? I suppose the guest needs to be aware of
>>>> the active TSC scaling parameters to make it work ?
>>>
>>> There is also not X86_FEATURE_NONSTOP_TSC nor values for art_to_tsc_denominator
>>> or art_to_tsc_numerator.  Also, from the VM's point of view, TSC will jump
>>> forwards every VM-Exit / VM-Entry unless the hypervisor changes the offset
>>> every VM-Entry, which KVM does not, so it still cannot be used as a stable
>>> clocksource.
>>
>> Translating between ART and the guest TSC can be a difficult problem and ART software
>> support is disabled by default in a VM.
>>
>> There are two major issues translating ART to TSC in a VM:
>>
>> The range of the TSC scaling field in the VMCS is much larger than the range of values
>> that can be represented using CPUID[15H], i.e., it is not possible to communicate this
>> to the VM using the current CPUID interface. The range of scaling would need to be
>> restricted or another para-virtualized method - preferably OS/hypervisor agnostic - to
>> communicate the scaling factor to the guest needs to be invented.
>>
>> TSC offsetting may also be a problem. The VMCS TSC offset must be discoverable by the
>> guest. This can be done via TSC_ADJUST MSR. The offset in the VMCS and the guest
>> TSC_ADJUST MSR must always be equivalent, i.e. a write to TSC_ADJUST in the guest
>> must be reflected in the VMCS and any changes to the offset in the VMCS must be
>> reflected in the TSC_ADJUST MSR. Otherwise a para-virtualized method must
>> be invented to communicate an arbitrary VMCS TSC offset to the guest.
>>
> 
> In my view it is reasonable for perf to support TSC as a perf clock in any case
> because:
> 	a) it allows users to work entirely with TSC if they wish
> 	b) other kernel performance / debug facilities like ftrace already support TSC
> 	c) the patches to add TSC support are relatively small and straight-forward
> 
> May we have support for TSC as a perf event clock?

Any update on this?
