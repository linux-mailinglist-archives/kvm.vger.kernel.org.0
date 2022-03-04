Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D234CD461
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 13:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbiCDMmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 07:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiCDMmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 07:42:09 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E908C1B3724;
        Fri,  4 Mar 2022 04:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646397681; x=1677933681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TMI1gQuIiE9qVU9EYYItY/+o7scD+fNPZ7hV8jCda1w=;
  b=ZMa8Yq0WkogyGZgeJX8QUk8XV0h6i7oCqihznP5KF2XJWMTZ5vsX9ihT
   kVdtgmZINBIO6KeZU8c8mnMFb2Fh2Ck3eoNJuEAhuRDbmJvxfFkSO0CYL
   Xu++wITKU6A+O2kl4YCHsz0Mqwqp0HriP8IQ7neHW/5lLIik5cAY1l6hA
   efUpGPG45d1ZyhwJibjRsV5zSPrHjm/d1mvW6UloZCJF/DMd9PHepNlTh
   sCG+vRpU6Rw5+86BBFAjFBIdkVMeqkZfIYeXR70W9gdjYKHWvnEBdOh/t
   c94eaCjVolO+H3+39STkUMLMttwtLwAEOFXbs7NzYuDPe5JbVzE5TS1na
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="254159938"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="254159938"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 04:41:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="576869723"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by orsmga001.jf.intel.com with ESMTP; 04 Mar 2022 04:41:17 -0800
Message-ID: <57bdc43e-4753-66f8-b54b-860be3239026@intel.com>
Date:   Fri, 4 Mar 2022 14:41:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 02/11] perf/x86: Add support for TSC as a perf event
 clock
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
        Leo Yan <leo.yan@linaro.org>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-3-adrian.hunter@intel.com>
 <YiIHJAfqY0XKsmya@hirez.programming.kicks-ass.net>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YiIHJAfqY0XKsmya@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/2022 14:33, Peter Zijlstra wrote:
> On Mon, Feb 14, 2022 at 01:09:05PM +0200, Adrian Hunter wrote:
>> +u64 perf_hw_clock(void)
>> +{
>> +	return rdtsc_ordered();
>> +}
> 
> Why the _ordered ?

To be on the safe-side - in case it matters.  trace_clock_x86_tsc() also uses the ordered variant.
