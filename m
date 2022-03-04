Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896364CDB53
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 18:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbiCDRxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 12:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241063AbiCDRws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 12:52:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA0213EF93;
        Fri,  4 Mar 2022 09:52:00 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646416319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j8OFCPFSa6oQfjH+iv/tB8o6jAu2gKimlCc9TJAIFy4=;
        b=zZo0ux5V+K2cHYZx+23tEprylvn8885sqVfywbNmkqh4PJt9ktHZfmbab7xedzO7x/z7zv
        mM1k4p8UYnqBeX4x3Yqmzs0DiUtbl6lGEu8qT7o6S8Fp0h+mMlgnhsnOeiVDUXtLxHREm+
        bsQRbGBZvjvJYS6qsQjnvf7Q8SJINPCk8l47XO/vxqJoKKYo9aYzmFx2CuAx9g4I87veLY
        aEe7DGH7+Q0tklQByR+Bjm29+xPviSbL/3kUPXfX6rWoo7zAcrNMaEdTHlbK/v+mEd3N2D
        BvullKcUGpqpJR9ECDrMqtn/BJCn70vPpcpPTsJ2VXg+1xDN5iuSOnEN+Up6ow==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646416319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j8OFCPFSa6oQfjH+iv/tB8o6jAu2gKimlCc9TJAIFy4=;
        b=m8wUOgmZAnt2ufWtq4MkGU/TECRfVyX9MQkTHQ3irsIx3NsvyFOgiMG1jE/wIlmEu7ZnqZ
        i0CIcaePnxtZOgAQ==
To:     Peter Zijlstra <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH V2 02/11] perf/x86: Add support for TSC as a perf event
 clock
In-Reply-To: <YiIGwyhOrYid5qyF@hirez.programming.kicks-ass.net>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-3-adrian.hunter@intel.com>
 <YiIGwyhOrYid5qyF@hirez.programming.kicks-ass.net>
Date:   Fri, 04 Mar 2022 18:51:58 +0100
Message-ID: <8735jxa9mp.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04 2022 at 13:32, Peter Zijlstra wrote:
> On Mon, Feb 14, 2022 at 01:09:05PM +0200, Adrian Hunter wrote:
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index 82858b697c05..e8617efd552b 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -290,6 +290,15 @@ enum {
>>  	PERF_TXN_ABORT_SHIFT = 32,
>>  };
>>  
>> +/*
>> + * If supported, clockid value to select an architecture dependent hardware
>> + * clock. Note this means the unit of time is ticks not nanoseconds.
>> + * Requires ns_clockid to be set in addition to use_clockid.
>> + * On x86, this clock is provided by the rdtsc instruction, and is not
>> + * paravirtualized.
>> + */
>> +#define CLOCK_PERF_HW_CLOCK		0x10000000
>> +
>>  /*
>>   * The format of the data returned by read() on a perf event fd,
>>   * as specified by attr.read_format:
>> @@ -409,7 +418,8 @@ struct perf_event_attr {
>>  				inherit_thread :  1, /* children only inherit if cloned with CLONE_THREAD */
>>  				remove_on_exec :  1, /* event is removed from task on exec */
>>  				sigtrap        :  1, /* send synchronous SIGTRAP on event */
>> -				__reserved_1   : 26;
>> +				ns_clockid     :  1, /* non-standard clockid */
>> +				__reserved_1   : 25;
>>  
>>  	union {
>>  		__u32		wakeup_events;	  /* wakeup every n events */
>
> Thomas, do we want to gate this behind this magic flag, or can that
> CLOCKID be granted unconditionally?

I'm not seeing a point in that flag and please define the clock id where
the other clockids are defined. We want a proper ID range for such
magically defined clocks.

We use INT_MIN < id < 16 today. I have plans to expand the ID space past
16, so using something like the above is fine.

Thanks,

        tglx

