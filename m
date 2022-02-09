Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030554AF3FE
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 15:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiBIO0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 09:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiBIO0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 09:26:07 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9FEC0613C9;
        Wed,  9 Feb 2022 06:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644416768; x=1675952768;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SlHuQRIQBVThpgneakK6VCjSbkHhDko9Wm2yuTFALKs=;
  b=Qw+fhiCilLBuoZ/b5OQ7SdofNd5BtU1Eu2v078TR5agDRr6E3U++Gq/7
   EW4m6A8PZL+G3WzGaG1zb69BDgQBsu+cOgyO89dgzfVlNQRPvBE9ATg/K
   IWIro1pxZVgB0g3By4YKDbX+GAo+Qq/IPdCmH0dvc+yPgJRJCKfS2ZE3X
   SvnUtVhvHktDzN4fBvnyxCIzA3NEzexk6lYYmGVBebtTgvkcF6SWlycV0
   bK6yqfFpPw/vewgDFgYATAVKaDodMdzlhfVS3RRSZY5TR/ZB0FP/9NBHb
   kKTbKvcx6kY+59NGPO38lZuXQZOOVyDKBEFZKijrMKwxp26e0xkTp08Rr
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="248045883"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="248045883"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 06:26:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="536944646"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by fmsmga007.fm.intel.com with ESMTP; 09 Feb 2022 06:26:03 -0800
Message-ID: <30c756f4-4b4b-1b32-d8b6-c785a6cabe45@intel.com>
Date:   Wed, 9 Feb 2022 16:26:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH 01/11] perf/x86: Fix native_perf_sched_clock_from_tsc()
 with __sched_clock_offset
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
References: <20220209084929.54331-1-adrian.hunter@intel.com>
 <20220209084929.54331-2-adrian.hunter@intel.com>
 <YgO5f8DFd2onnTOE@hirez.programming.kicks-ass.net>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YgO5f8DFd2onnTOE@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2022 14:54, Peter Zijlstra wrote:
> On Wed, Feb 09, 2022 at 10:49:19AM +0200, Adrian Hunter wrote:
>> native_perf_sched_clock_from_tsc() is used to produce a time value that can
>> be consistent with perf_clock().  Consequently, it should be adjusted by
>> __sched_clock_offset, the same as perf_clock() would be.
>>
>> Fixes: 698eff6355f735 ("sched/clock, x86/perf: Fix perf test tsc")
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  arch/x86/kernel/tsc.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>> index a698196377be..c1c73fe324cd 100644
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -242,7 +242,8 @@ u64 native_sched_clock(void)
>>   */
>>  u64 native_sched_clock_from_tsc(u64 tsc)
>>  {
>> -	return cycles_2_ns(tsc);
>> +	return cycles_2_ns(tsc) +
>> +	       (sched_clock_stable() ? __sched_clock_offset : 0);
>>  }
> 
> Why do we care about the !sched_clock_stable() case?

I guess we don't.  So add __sched_clock_offset unconditionally then?
