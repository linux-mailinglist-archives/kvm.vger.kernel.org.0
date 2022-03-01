Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7D84C8A4B
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 12:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiCALHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 06:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiCALHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 06:07:39 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2222F8BF30;
        Tue,  1 Mar 2022 03:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646132819; x=1677668819;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=DplcUm3snQ+9f/2Kg7Iq3Eg7znZsn8k8xzccD8lBdvU=;
  b=Kbr+Q/7sCnOPhiqsHm1mzpFkr0luNGdSe87MNb264CegNzZT/S7ZP8oC
   MrXnQh60r9U6HJkVXRShGHj4uxEgqG8WeP5s1qUcVk73039KV421nFO7T
   RwAsaemeBfMlSS+wBsl4P7W32HYXC5mAFfsbZpz1reg7wwz1QMH++W/20
   quKJ0MoczW9SrO216RUhR9eIiQnomKI+xO+DmL1ZUrr4Bbl9lSQ1D7IkU
   atN+BD+++YxGtWZVhC2ss5U9oEi5D0tstlQGQcBstZz6DlFw6MJfcTAAE
   +0Nn4hl/GA1J5DuyD3URX/HFe6P2ipkdzqw/yx9aDceptF0uqp1rw7m50
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="316323870"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="316323870"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 03:06:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="685683786"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by fmsmga001.fm.intel.com with ESMTP; 01 Mar 2022 03:06:54 -0800
Message-ID: <9a1163af-7a6e-547b-7b2e-245f1a29b4d5@intel.com>
Date:   Tue, 1 Mar 2022 13:06:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 00/11] perf intel-pt: Add perf event clocks to better
 support VM tracing
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
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
        Leo Yan <leo.yan@linaro.org>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <4eaf42fd-f30f-e8ac-03f5-a364f7e28461@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <4eaf42fd-f30f-e8ac-03f5-a364f7e28461@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/2022 08:54, Adrian Hunter wrote:
> On 14/02/2022 13:09, Adrian Hunter wrote:
>> Hi
>>
>> These patches add 2 new perf event clocks based on TSC for use with VMs.
>>
>> The first patch is a minor fix, the next 2 patches add each of the 2 new
>> clocks.  The remaining patches add minimal tools support and are based on
>> top of the Intel PT Event Trace tools' patches.
>>
>> The future work, to add the ability to use perf inject to inject perf
>> events from a VM guest perf.data file into a VM host perf.data file,
>> has yet to be implemented.
>>
>>
>> Changes in V2:
>>       perf/x86: Fix native_perf_sched_clock_from_tsc() with __sched_clock_offset
>> 	  Add __sched_clock_offset unconditionally
>>
>>       perf/x86: Add support for TSC as a perf event clock
>> 	  Use an attribute bit 'ns_clockid' to identify non-standard clockids
>>
>>       perf/x86: Add support for TSC in nanoseconds as a perf event clock
>> 	  Do not affect use of __sched_clock_offset
>> 	  Adjust to use 'ns_clockid'
> 
> Any comments on version 2?

☺/
