Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C284D1A57
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 15:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242213AbiCHOYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 09:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiCHOYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 09:24:55 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E1049920;
        Tue,  8 Mar 2022 06:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646749438; x=1678285438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/XXipzH9LpSlloOthwoAzcFwTx0U+s0Ur50YTY714mc=;
  b=ZviHOMu9oZcY/LSfVmVfOz0olivD7WIjxU+Qvz2zVxPEg7AHu/7OQlDr
   agG82al115GE27ZXfQxqKl+pXdfT+lLTppxfVIXdoNMXATQzu5ga5G4bg
   zoeEetZKRYYsZPwGvNb9sFvXHKbg/7XzEhZR/fEvs3JgKXdroJIgVeDeg
   5eOG/e5MqltZUYungJO2K9KGP7IwxmJR0q1HWxQ10Ss1XhDN2Vm0WKvsw
   5CsnzT2AeYr+Pk4RLYhG83h+g8y+igNfU3/59wviWt2t+Jaf1a3zmRbmp
   PgM7V96ZARD4ke0bxYtPlFEkclBEZwlw6RCCA+JJuGseaOHz2j3F1ky5B
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="254419987"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="254419987"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 06:23:30 -0800
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="553634238"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.46.193])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 06:23:24 -0800
Message-ID: <013b5425-2a60-e4d4-b846-444a576f2b28@intel.com>
Date:   Tue, 8 Mar 2022 16:23:18 +0200
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
        Andrew.Cooper3@citrix.com, christopher.s.hall@intel.com
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
 <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
 <YiYZv+LOmjzi5wcm@hirez.programming.kicks-ass.net>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YiYZv+LOmjzi5wcm@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7.3.2022 16.42, Peter Zijlstra wrote:
> On Mon, Mar 07, 2022 at 02:36:03PM +0200, Adrian Hunter wrote:
> 
>>> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
>>> index 4420499f7bb4..a1f179ed39bf 100644
>>> --- a/arch/x86/kernel/paravirt.c
>>> +++ b/arch/x86/kernel/paravirt.c
>>> @@ -145,6 +145,15 @@ DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
>>>  
>>>  void paravirt_set_sched_clock(u64 (*func)(void))
>>>  {
>>> +	/*
>>> +	 * Anything with ART on promises to have sane TSC, otherwise the whole
>>> +	 * ART thing is useless. In order to make ART useful for guests, we
>>> +	 * should continue to use the TSC. As such, ignore any paravirt
>>> +	 * muckery.
>>> +	 */
>>> +	if (cpu_feature_enabled(X86_FEATURE_ART))
>>
>> Does not seem to work because the feature X86_FEATURE_ART does not seem to get set.
>> Possibly because detect_art() excludes anything running on a hypervisor.
> 
> Simple enough to delete that clause I suppose. Christopher, what is
> needed to make that go away? I suppose the guest needs to be aware of
> the active TSC scaling parameters to make it work ?

There is also not X86_FEATURE_NONSTOP_TSC nor values for art_to_tsc_denominator
or art_to_tsc_numerator.  Also, from the VM's point of view, TSC will jump
forwards every VM-Exit / VM-Entry unless the hypervisor changes the offset
every VM-Entry, which KVM does not, so it still cannot be used as a stable
clocksource.

