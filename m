Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13486322B3C
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 14:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhBWNIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 08:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbhBWNIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 08:08:37 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1C2C061574
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 05:07:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t25so12322121pga.2
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 05:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=vuDCQjPHpW2W/RRC7MxCqnjH5uwfq99HojvmeGSPmzE=;
        b=WI4R9QKudc2VpGzt96CWPx5Yx0Tt4A0l7O4AO4MVazJJ0SoDptkJyI4jDmFeVTawCF
         A+IZT/WPcPklZn/CfA48Y/aPoeacx9rwXWl6vwg5BkfDnI+dGIZjCKFJdsGnNYMMkT6Y
         oupDqON9OD/y7Ux2XHeyWPXtTQTLlUyWhbCa/Quu+dYk9ohE9zkei+IuwIJz8v6eMAif
         o2RiJxcNS02ZQc5tv+5rbrQl82oREwcK0XhG9LOrn2mcpxtlv4U6oop92XuGHmAZ8SnC
         g6dy2Z/ab+/xdjntNAok0tpEwDroxwoSl6IxCytgY+L7Ww3PnGjBZl8fOxT6Z+JXzle6
         Aa9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=vuDCQjPHpW2W/RRC7MxCqnjH5uwfq99HojvmeGSPmzE=;
        b=hfxS8PIv9PqRiRpnhQY46BCO3H0BoEn5nEhTflM9rKx+YdvTaLTckifBtlg/N25l+i
         ZjQtHFx2qnxgZCk4xjVJHl4Y9j8/6p3SKKsz0O16frb3nr4JmJR8unG+okB6HM47rmEW
         2mY5YKwahmsYCDdHe9Oy+jve5B/7+yyx07Q7LvMDAef4xAwEZY+FzLK7ST89CKge26ZP
         Rn8v5SZUcmlOx1fbsN3QW7L5GsI68N2LkcRNhOl9tMLrUV8mKoey3Mv9MrWclrToRM/7
         y1nb+3wbq5XbJke5SDdYNb1nYI7vaGLi/kGSOblV5t6vE7NHRKoJn/vnNCxy5a9jtQhB
         KaWw==
X-Gm-Message-State: AOAM530nn2rF6F8gKCu+AzacoFnWNw+E8CT0mncgXjIyxA6z6fNmCc5H
        ikpNISzktGpLIDWd0hQYJBaQ5g==
X-Google-Smtp-Source: ABdhPJz2IS1tTz23bXe5XUHYjZbPd8wUb+tcayoN1kKsLrDBnO5kdi0ufmUNmu2LI8keX9dk/B1X4A==
X-Received: by 2002:a62:7d8a:0:b029:1ed:7164:291 with SMTP id y132-20020a627d8a0000b02901ed71640291mr14176641pfc.65.1614085676394;
        Tue, 23 Feb 2021 05:07:56 -0800 (PST)
Received: from [10.85.116.39] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id t6sm21550974pgp.57.2021.02.23.05.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 05:07:55 -0800 (PST)
Subject: Re: [External] Re: [RFC: timer passthrough 1/9] KVM: vmx: hook
 set_next_event for getting the host tscd
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, fweisbec@gmail.com,
        zhouyibo@bytedance.com, zhanghaozhong@bytedance.com
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
 <20210205100317.24174-2-fengzhimin@bytedance.com>
 <87ft2a8jv5.fsf@nanos.tec.linutronix.de>
From:   Zhimin Feng <fengzhimin@bytedance.com>
Message-ID: <de39a4cf-8286-1511-1e94-1cf5d6da91cc@bytedance.com>
Date:   Tue, 23 Feb 2021 21:07:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87ft2a8jv5.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi tglx

This question is very nice,  we should be considered to judge whether 
the current active device is the tsc deadline timer. I will fix this in V2.

Thanks

Zhimin

在 2021/2/6 上午2:11, Thomas Gleixner 写道:
> On Fri, Feb 05 2021 at 18:03, Zhimin Feng wrote:
>> @@ -520,6 +521,24 @@ struct kvm_vcpu_hv {
>>   	cpumask_t tlb_flush;
>>   };
>>   
>> +enum tick_device_mode {
>> +	TICKDEV_MODE_PERIODIC,
>> +	TICKDEV_MODE_ONESHOT,
>> +};
>> +
>> +struct tick_device {
>> +	struct clock_event_device *evtdev;
>> +	enum tick_device_mode mode;
>> +};
> There is a reason why these things are defined in a header file which is
> not public. Nothing outside of kernel/time/ has to fiddle with
> this. Aside of that how are these things supposed to stay in sync?
>
>> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
>> index 6c9c342dd0e5..bc50f4a1a7c0 100644
>> --- a/kernel/time/tick-common.c
>> +++ b/kernel/time/tick-common.c
>> @@ -26,6 +26,7 @@
>>    * Tick devices
>>    */
>>   DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
>> +EXPORT_SYMBOL_GPL(tick_cpu_device);
> Not going to happen ever.
>
>> +#define TSC_DIVISOR  8
>> +static DEFINE_PER_CPU(struct timer_passth_info, passth_info);
>> +
>> +static int override_lapic_next_event(unsigned long delta,
>> +		struct clock_event_device *evt)
>> +{
>> +	struct timer_passth_info *local_timer_info;
>> +	u64 tsc;
>> +	u64 tscd;
>> +
>> +	local_timer_info = &per_cpu(passth_info, smp_processor_id());
>> +	tsc = rdtsc();
>> +	tscd = tsc + (((u64) delta) * TSC_DIVISOR);
>> +	local_timer_info->host_tscd = tscd;
>> +	wrmsrl(MSR_IA32_TSCDEADLINE, tscd);
>> +	return 0;
>> +}
>> +
>> +static void vmx_host_timer_passth_init(void *junk)
>> +{
>> +	struct timer_passth_info *local_timer_info;
>> +	int cpu = smp_processor_id();
>> +
>> +	local_timer_info = &per_cpu(passth_info, cpu);
>> +	local_timer_info->curr_dev = per_cpu(tick_cpu_device, cpu).evtdev;
>> +	local_timer_info->orig_set_next_event =
>> +		local_timer_info->curr_dev->set_next_event;
>> +	local_timer_info->curr_dev->set_next_event = override_lapic_next_event;
> So when loading the KVM module you steal the set_next_event pointer of
> the clock event device which is currently active. What guarantees that
>
>      1) The current active device is the tsc deadline timer
>      2) The active device does not change
>
> Nothing.
>
> Thanks,
>
>          tglx
