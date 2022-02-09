Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D936E4AF30E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 14:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbiBINjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 08:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiBINjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 08:39:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A264C0613CA;
        Wed,  9 Feb 2022 05:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644413976; x=1675949976;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gd6ZEnBAbYljc4qYbITsbhR7ugEZ0yEc2B6DfLnt/gw=;
  b=QeMrEjwXb0E1iZDu6EBaKkV0dHyq8NiL6AhONJvUOlTqx5DtCyhLdDiQ
   jThQWuzm0+OJV/AlRsaBhlO1IekO+3NTqKCEyG1SmfbWravZWXDj6Y3b8
   5nxgC1zOj8LXuN69Rqt+EPHY7kzA24y9dFoTq0R4NIhnZyVvloDnzqwP1
   mJPEKDzLn1uXNmY2tnzpMU5z/G3X95unwo5/dHk6ofortIyRmree36WvB
   /RJGkNWxAMsV85SZuR2vEfWzJx9XaKN+HDOnouqO1oxYVkRy/T/YCcZg3
   HRSgIffcYPjulRcEEy5VkeVIYzj8fuWvdOB8OVDo/OCd04Fy8S3HUeh/r
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="335606447"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="335606447"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 05:39:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="536932775"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.92]) ([10.237.72.92])
  by fmsmga007.fm.intel.com with ESMTP; 09 Feb 2022 05:39:32 -0800
Message-ID: <e955e3b5-08b8-0092-92cc-c59420e3e748@intel.com>
Date:   Wed, 9 Feb 2022 15:39:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH 02/11] perf/x86: Add support for TSC as a perf event clock
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
 <20220209084929.54331-3-adrian.hunter@intel.com>
 <YgO9cdEvs7mhjTNp@hirez.programming.kicks-ass.net>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <YgO9cdEvs7mhjTNp@hirez.programming.kicks-ass.net>
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

On 09/02/2022 15:11, Peter Zijlstra wrote:
> On Wed, Feb 09, 2022 at 10:49:20AM +0200, Adrian Hunter wrote:
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index 82858b697c05..150d2b70a41f 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -290,6 +290,14 @@ enum {
>>  	PERF_TXN_ABORT_SHIFT = 32,
>>  };
>>  
>> +/*
>> + * If supported, clockid value to select an architecture dependent hardware
>> + * clock. Note this means the unit of time is ticks not nanoseconds.
>> + * On x86, this is provided by the rdtsc instruction, and is not
>> + * paravirtualized.
>> + */
>> +#define CLOCK_PERF_HW_CLOCK		0x10000000
> 
> This steps on the clockid_t space; are we good with that?
> 
> At some point there was talk of dynamic clock ids, that would complicate
> things more than they are today.

There are 16 clock IDs at the moment and perf only supports a few of them.

If there were a conflict in the future, then an attribute bit would be needed
to differentiate the 2 cases: standard clock IDs vs non-standard "perf" clock IDs.
An alternative would be to add that attribute bit now.
