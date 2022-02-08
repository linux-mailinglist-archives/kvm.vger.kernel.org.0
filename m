Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041CA4AD7F3
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 12:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244652AbiBHLwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 06:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239521AbiBHLwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 06:52:54 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F48CC03FEC0;
        Tue,  8 Feb 2022 03:52:53 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id qe15so6515535pjb.3;
        Tue, 08 Feb 2022 03:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=DRIuUc2VDgRmjcevfIz/V5hKd5UgUekQHsS7kXsTMhA=;
        b=QKI0U/4xxaT2com3DuGoQVRH9mne7idQfR9378gfAFlSah1PStbuQ9B85ooqlRIxnp
         T28Zw7GJE/sM1hfJ2T5XmY5uDLDGaiSkGD/d+QYqXsnecgaI47QHjT/Q2/CODjHf9FvA
         Pm8wrhQ0vfpAjs1T93rmyqWEj/sZgDCXgd/8ITYb92/ZmncGwL+2MHTC/B8CZzHzO4lm
         7bxkue+PlQ6BI46uFF/hOovMlUUr6JMArMwdKitcUA/Y4HfSJQGg/ZB031Y1qMUuOO3y
         65ZWx+ucRsIYYTCX0xD6EhaVHHlxgQOSu3VqEZTWISl+mvVCm+HZ7R8E9oVcqH7gIViR
         7tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=DRIuUc2VDgRmjcevfIz/V5hKd5UgUekQHsS7kXsTMhA=;
        b=VXM8Xkb6cxECM0L3tqfWEBpw35SPRWqoOo6ip1Gzqbyv3RJXRHJqEsRP5TgrhgARUM
         qa4xdZgZ+S9HmQS+roKrXe8/OW1sR425yLkuGPtEc7Te6XAKaD10vqqGX6XMybvRcC3m
         zkg+H5qBFk+p8EAc6JxxKTAd88V41ql7Q05LrQ2yHVe8LRCtYzkit3NcOnh0tHOKcPWw
         1C5f4MMxmmKXdgYnMToHXoLKu/mxYnABpfAED6SwCKw2STxdFH+LvDWU0z63e3TetP0k
         NzgKRA11NxzrUrFAn/R0cKged1MCZ7/NRtwNicE3uKTbrQgXvB/oSBPC3OTVwLTFV6Em
         cDgQ==
X-Gm-Message-State: AOAM532yN4rnH+5CzJvEVvJzXBmZMCP9X3LH6VXVpCjnj8OHIaqs76+5
        9g6ZeW75U8vpwbsAo4lEsbz2stU++z77HQ==
X-Google-Smtp-Source: ABdhPJzYHJeYL4cKG1G4ja0goc702EwvDIt/NyPpJMLgZUDpZ9o4TUGSoI/uApB9b8L9616LwKmT6w==
X-Received: by 2002:a17:902:7049:: with SMTP id h9mr4334023plt.121.1644321172817;
        Tue, 08 Feb 2022 03:52:52 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ml19sm2789049pjb.52.2022.02.08.03.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 03:52:52 -0800 (PST)
Message-ID: <319bd90e-5315-35c2-0d0c-32ced685a147@gmail.com>
Date:   Tue, 8 Feb 2022 19:52:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220202144308.GB20638@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/2022 10:43 pm, Peter Zijlstra wrote:
> On Mon, Jan 17, 2022 at 04:53:06PM +0800, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Currently, we have [intel|knc|p4|p6]_perfmon_event_map on the Intel
>> platforms and amd_[f17h]_perfmon_event_map on the AMD platforms.
>>
>> Early clumsy KVM code or other potential perf_event users may have
>> hard-coded these perfmon_maps (e.g., arch/x86/kvm/svm/pmu.c), so
>> it would not make sense to program a common hardware event based
>> on the generic "enum perf_hw_id" once the two tables do not match.
>>
>> Let's provide an interface for callers outside the perf subsystem to get
>> the counter config based on the perfmon_event_map currently in use,
>> and it also helps to save bytes.
>>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/events/core.c            | 9 +++++++++
>>   arch/x86/include/asm/perf_event.h | 2 ++
>>   2 files changed, 11 insertions(+)
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 38b2c779146f..751048f4cc97 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -693,6 +693,15 @@ void x86_pmu_disable_all(void)
>>   	}
>>   }
>>   
>> +u64 perf_get_hw_event_config(int perf_hw_id)
>> +{
>> +	if (perf_hw_id < x86_pmu.max_events)
>> +		return x86_pmu.event_map(perf_hw_id);
>> +
>> +	return 0;
>> +}
> 
> Where does perf_hw_id come from? Does this need to be
> array_index_nospec() ?

A valid incoming parameter will be a member of the generic "enum perf_hw_id" table.

If array_index_nospec() helps, how about:

+u64 perf_get_hw_event_config(int hw_event)
+{
+	int max = x86_pmu.max_events;
+
+	if (hw_event < max)
+		return x86_pmu.event_map(array_index_nospec(hw_event, max));
+
+	return 0;
+}

> 
>> +EXPORT_SYMBOL_GPL(perf_get_hw_event_config);
> 
> Urgh... hate on kvm being a module again. We really need something like
> EXPORT_SYMBOL_KVM() or something.

As opposed to maintaining the obsolete {intel|amd}_event_mapping[] in the out 
context of perf,
a more appropriate method is to set up the table in the KVM through the new perf 
interface.

Well, I probably need Paolo's clarity to trigger more changes, whether it's 
introducing EXPORT_SYMBOL_KVM or a built-in KVM as a necessary prerequisite for 
vPMU.

> 
> 
>>   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
>>   {
>>   	return static_call(x86_pmu_guest_get_msrs)(nr);
>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>> index 8fc1b5003713..d1e325517b74 100644
>> --- a/arch/x86/include/asm/perf_event.h
>> +++ b/arch/x86/include/asm/perf_event.h
>> @@ -492,9 +492,11 @@ static inline void perf_check_microcode(void) { }
>>   
>>   #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
>>   extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
>> +extern u64 perf_get_hw_event_config(int perf_hw_id);
>>   extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
>>   #else
>>   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
>> +u64 perf_get_hw_event_config(int perf_hw_id);
> 
> I think Paolo already spotted this one.

Indeed, I will apply it.

> 
>>   static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
>>   {
>>   	return -1;
>> -- 
>> 2.33.1
>>
