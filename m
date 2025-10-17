Return-Path: <kvm+bounces-60313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A2DBE8911
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA20B4F0C6C
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 12:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E9032ABC5;
	Fri, 17 Oct 2025 12:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YixIsK62"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A02C11F5
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 12:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760703684; cv=none; b=R6pFOjlF/MhnkgX7mik1vFiKsssY7gngecI3yAkxply2dh+Xbnc2zjgDURAJN0QnGoxGN4AcNSWfkOhIiUQa7l6VE8FkJozPMpf2z92xCuwN2/3wXSFz5wdVNRN7qDXup4zWJr1RWjwQgMq8P0l9eF2Ji8X742Pl3MYQ/jMQg/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760703684; c=relaxed/simple;
	bh=oF4rSMa84XiUMrFMQ8CCeEKgVEFBG4leS+kqpiZpjrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lfJ4844ulII7KzMscEQCGv+P0IHj+8lQpVgLy9xqeyOHwZ6lb5vu3CsVpr3CKENpz1MMPWFk79qjePFJ3cF+7SKyJqa88AnD9hDvhJSYumoJPYxT+ZTDGVHo5sHo9yXrkrJsa+xyqY9BzpX2B7UqzT64dWgtbIkZ62VUoCHBG98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YixIsK62; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-273a0aeed57so38653935ad.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 05:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760703681; x=1761308481; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jBoeFdlwNuRD0x8J8jqumWLa4C5c647eqsgbDy2o1WI=;
        b=YixIsK62npnqRDBZMKDC4yoAO372N4IOhCESrBw7SBqIPME7VAPkYpOVDVCEtohwNb
         PK2u4oqcngVDGW09PBotx8MbmJuwGvc3z4ubnwpvBkqTrF6ZxydxnyGfsd91VyD9PvuF
         VJ1W12Gurluxy3pB8bPXTV6SagCVUaX0xC8TK3/JoPSoovRNUAqzJuAwDb63kcuNEA9U
         Zd/QFdSyR8U/Id3uS29caApyuuTNL3ja8a5rQ89AD1OhG3nGOyeGdLgLvKC8VOAN72SQ
         5DX0OIyGj0sG7TxPkAG0b178/MpYYXqNxDKJjo/sY2BK4umzmButatc+6CcV3AySO3BB
         PO7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760703681; x=1761308481;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jBoeFdlwNuRD0x8J8jqumWLa4C5c647eqsgbDy2o1WI=;
        b=kzJ3BS6YGQL0WhGYoe+k2MjcGTLbvkutiXOysYazjJ0G1LqimerOYm8DfLhoOZDjCa
         h+2cysNEKCFDvRhDndNu6cdA1F6NyvFyR6csHHTOs0Iesd1p96jTDo9hovYywDIBfuKn
         Qbjkrpiu1PMRUcAJtFCTk1/krHOdgnff6JpI+oeAB4emnok7JHzxQvsxTcH//Opaf2JU
         Rx6qP1bKeJ9k8eMOzJVrP63sjjK84uKrgDnmJE51mw4PDrJIGzV+zmENqV3ZtEN+lOwP
         b8ZB0ZpvubIPynzV7DUXMeOCaGBq5apBjwUNXA0nwbCCHLQYbVnzPTCk56vlwFj2vy+B
         TBfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXq1KeSyqLNSDlpPWgRfhoZU5U5smomaoYPwrR/RAFWIZdoYYvuVqb/YiXbjfC65vI4lc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9TZ5wVqOJo1HyR0CN2DG8twO6sD8idg/jKSd/ZCo0ECzlhTDL
	mUKW02TLHLqkGKOORvv20ISN7r1fSCTvPNpA1yntt1Aqex0Ap2j62QTG
X-Gm-Gg: ASbGnctR8/UPnXam+BcW/dWcJwvm7Edbg3NZM+dblXLcmqJnGNgnSL4uOOs1cfkIJHM
	7ghQwVZCzm3i5NO9Akqp2EGlYZoLFBz7VTiKSjxT5popkkHEy+Ujakv8oEOr3Mzff1O+Y/LeHRd
	wWPZloGSWafyOGsN+YKIa28SUyMIGNuTexiagbTqfyn6QKTM44zHbXZq7GNYtzk8XwDXx5vI2sl
	CZqSr7XfmDiyFvtqiFjBLRBZR6emuM0S4ZXH0qBO5DELXEnOZGuYTWJME2XkQekmCjhpz2JwtU1
	7U3su7AvHXNTc5AHRcuV3CMPwcOerchXQAcy0wmoJhmC9HCgBQMkpIZRANyOa6lHIR40jGgrqQ0
	z0kQSTKaPAbgnuoI8w0OR/wL0uMhCWTjLZTitcXjuTIBhNT8rddHBwDsftT9+UXph5ammRygoGg
	76QBzWj9gjc0pNARiIvcR7bP0zW3X3jAFBbnA2e6yoXkN6z9jBvdxDa5opX3KVtUCJY5k1cMZW
X-Google-Smtp-Source: AGHT+IFL6v2XqQkA/lfaEqWZGlAj4AIcqlDCBw+g5JGkN430aHE/DTJbG5oBfoCOSziU7X7UqZjiRA==
X-Received: by 2002:a17:902:f64b:b0:262:f975:fcba with SMTP id d9443c01a7336-290c68e2eeemr41869345ad.9.1760703681317;
        Fri, 17 Oct 2025 05:21:21 -0700 (PDT)
Received: from ?IPV6:240f:c0ff:0:4:546b:8a06:6998:55b1? ([2408:80e0:41fc:0:5299:8a06:6998:55b1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a90csm62964205ad.19.2025.10.17.05.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 05:21:20 -0700 (PDT)
Message-ID: <c87d11a7-b4dd-463e-b40a-188fd2219b3b@gmail.com>
Date: Fri, 17 Oct 2025 20:21:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] avoid hv timer fallback to sw timer if delay
 exceeds period
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, yu chen <chen.yu@easystack.com>,
 dongxu zhang <dongxu.zhang@easystack.com>
References: <20251013125117.87739-1-fuqiang.wng@gmail.com>
 <aO2LV-ipewL59LC6@google.com>
From: fuqiang wang <fuqiang.wng@gmail.com>
In-Reply-To: <aO2LV-ipewL59LC6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/14/25 7:29 AM, Sean Christopherson wrote:
> On Wed, Oct 01, 2025, fuqiang wang wrote:
>> When the guest uses the APIC periodic timer, if the delay exceeds the
>> period, the delta will be negative.
> 
> IIUC, by "delay" you mean the time it takes for KVM to get (back) to
> advance_periodic_target_expiration().  If that's correct, I think it would be
> clearer to word this as:
> 
>    When the guest uses the APIC periodic timer, if the next period has already
>    expired, e.g. due to the period being smaller than the delay in processing
>    the timer, the delta will be negative.
> 

Indeed, this explanation is much clearer. I will adopt it in the next version
patch.

>> nsec_to_cycles() may then convert this
>> delta into an absolute value larger than guest_l1_tsc, resulting in a
>> negative tscdeadline. Since the hv timer supports a maximum bit width of
>> cpu_preemption_timer_multi + 32, this causes the hv timer setup to fail and
>> switch to the sw timer.
>>
>> Moreover, due to the commit 98c25ead5eda ("KVM: VMX: Move preemption timer
>> <=> hrtimer dance to common x86"), if the guest is using the sw timer
>> before blocking, it will continue to use the sw timer after being woken up,
>> and will not switch back to the hv timer until the relevant APIC timer
>> register is reprogrammed.  Since the periodic timer does not require
>> frequent APIC timer register programming, the guest may continue to use the
>> software timer for an extended period.
>>
>> The reproduction steps and patch verification results at link [1].
>>
>> [1]: https://github.com/cai-fuqiang/kernel_test/tree/master/period_timer_test
>>
>> Fixes: 98c25ead5eda ("KVM: VMX: Move preemption timer <=> hrtimer dance to common x86")

Yes, it's better, I will fix it.

> 
> I'm pretty sure this should be:
> 
>    Fixes: d8f2f498d9ed ("x86/kvm: fix LAPIC timer drift when guest uses periodic mode")
> 
> because that's where the bug with tsdeadline (incorrectly) wrapping was introduced.
> The aforementioned commit exacerbated (and likely exposed?) the bug, but AFAICT
> that commit itself didn't introduce any bugs (related to this issue).
> 
>> Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
>> ---
>>   arch/x86/kvm/lapic.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 5fc437341e03..afd349f4d933 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2036,6 +2036,9 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
>>   	u64 tscl = rdtsc();
>>   	ktime_t delta;
>>   
>> +	u64 delta_cycles_u;
>> +	u64 delta_cycles_s;
>> +
>>   	/*
>>   	 * Synchronize both deadlines to the same time source or
>>   	 * differences in the periods (caused by differences in the
>> @@ -2047,8 +2050,11 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
>>   		ktime_add_ns(apic->lapic_timer.target_expiration,
>>   				apic->lapic_timer.period);
>>   	delta = ktime_sub(apic->lapic_timer.target_expiration, now);
>> +	delta_cycles_u = nsec_to_cycles(apic->vcpu, abs(delta));
>> +	delta_cycles_s = delta > 0 ? delta_cycles_u : -delta_cycles_u;
>> +
>>   	apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
>> -		nsec_to_cycles(apic->vcpu, delta);
>> +		delta_cycles_s;
> 
> This isn't quite correct either.  E.g. if delta is negative while L1 TSC is tiny,
> then subtracting the delta will incorrectly result the deadline wrapping too.
> Very, very, theoretically, L1 TSC could even be '0', e.g. due to a weird offset
> for L1, so I don't think subtracting is ever safe.  Heh, of course we're hosed
> in that case no matter what since KVM treats tscdeadline==0 as "not programmed".
> 
> Anyways, can't we just skip adding negative value?  Whether or not the TSC deadline
> has expired is mostly a boolean value; for the vast majority of code it doesn't
> matter exactly when the timer expired.

I don’t think this patch will cause tscdeadline to wrap around to zero, because
the system is unlikely to start a timer when the guest tsc is zero and have it
expire immediately. However, keeping the logic to skip adding negative values is
a good idea, seems like there’s no downside.

> 
> The only code that cares is __kvm_wait_lapic_expire(), and the only downside to
> setting tscdeadline=L1.TSC is that adjust_lapic_timer_advance() won't adjust as
> aggressively as it probably should.

I am not sure which type of timers should use the "advanced tscdeadline hrtimer
expiration feature".

I list the history of this feature.

1. Marcelo first introduce this feature, only support the tscdeadline sw timer.
2. Yunhong introduce vmx preemption timer(hv), only support for tscdeadline.
3. Liwanpeng extend the hv timer to oneshot and period timers.
4. Liwanpeng extend this feature to hv timer.
5. Sean and liwanpeng fix some BUG extend this feature to hv period/oneshot timer.

[1] d0659d946be0("KVM: x86: add option to advance tscdeadline hrtimer expiration")
     Marcelo Tosatti     Dec 16 2014
[2] ce7a058a2117("KVM: x86: support using the vmx preemption timer for tsc deadline timer")
     Yunhong Jiang       Jun 13 2016
[3] 8003c9ae204e("KVM: LAPIC: add APIC Timer periodic/oneshot mode VMX preemption timer support")
     liwanpeng           Oct 24 2016
[4] c5ce8235cffa("KVM: VMX: Optimize tscdeadline timer latency")
     liwanpeng           May 29 2018
[5] ee66e453db13("KVM: lapic: Busy wait for timer to expire when using hv_timer")
     Sean Christopherson Apr 16 2019

     d981dd15498b("KVM: LAPIC: Accurately guarantee busy wait for timer to expire when using hv_timer")
     liwanpeng           Apr 28 2021

Now, timers supported for this feature includes:
- sw: tscdeadline
- hv: all (tscdeadline, oneshot, period)

====
IMHO
====

1. for period timer
===================

I think for periodic timers emulation, the expiration time is already adjusted
to compensate for the delays introduced by timer emulation, so don't need this
feature to adjust again. But after use the feature, the first timer expiration
may be relatively accurate.

E.g., At time 0, start a periodic task (period: 10,000 ns) with a simulated
delay of 100 ns.

With this feature enabled and reasonably accurate prediction, the expiration
time set seen by the guest are: 10000, 20000, 30000...

With this feature not enabled, the expiration times set: 10100, 20100, 30100...

But IMHO, for periodic timers, accuracy of the period seems to be the main
concern, because it does not frequently start and stop. The incorrect period
caused by the first timer expiration can be ignored.

2. for oneshot timer
====================

In [1], Marcelo treated oneshot and tscdeadline differently. Shouldn’t the
behavior of these two timers be similar? Unlike periodic timers, both oneshot
and tscdeadline timers set a specific expiration time, and what the guest cares
about is whether the expiration time is accurate. Moreover, this feature is
mainly intended to mitigate the latency introduced by timer virtualization.
Since software timers have higher latency compared to hardware virtual timers,
the need for this feature is actually more urgent for software timers. However,
in the current implementation, the feature is applied to hv oneshot/period
timers, but not to sw oneshot/period timers.

===============
Summary of IMHO
===============

The feature should be applied to the following timer types:
sw/hv tscdeadline and sw/hv oneshot

should not be applied to:
sw/hv period

However, so far I haven’t found any discussion on the mailing lists regarding
the commits summarized above. Please let me know if I’ve overlooked something.

> 
> Ha!  That's essentially what update_target_expiration() already does:
> 
> 	now = ktime_get();
> 	remaining = ktime_sub(apic->lapic_timer.target_expiration, now);
> 	if (ktime_to_ns(remaining) < 0)
> 		remaining = 0;
> 
> E.g.
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0ae7f913d782..2fb03a8a9ae9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2131,18 +2131,26 @@ static void advance_periodic_target_expiration(struct kvm_lapic *apic)
>          ktime_t delta;
>   
>          /*
> -        * Synchronize both deadlines to the same time source or
> -        * differences in the periods (caused by differences in the
> -        * underlying clocks or numerical approximation errors) will
> -        * cause the two to drift apart over time as the errors
> -        * accumulate.
> +        * Use kernel time as the time source for both deadlines so that they
> +        * stay synchronized.  Computing each deadline independently will cause
> +        * the two deadlines to drift apart over time as differences in the
> +        * periods accumulate, e.g. due to differences in the underlying clocks
> +        * or numerical approximation errors.
>           */
>          apic->lapic_timer.target_expiration =
>                  ktime_add_ns(apic->lapic_timer.target_expiration,
>                                  apic->lapic_timer.period);
>          delta = ktime_sub(apic->lapic_timer.target_expiration, now);
> -       apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl) +
> -               nsec_to_cycles(apic->vcpu, delta);
> +
> +       /*
> +        * Don't adjust the TSC deadline if the next period has already expired,
> +        * e.g. due to software overhead resulting in delays larger than the
> +        * period.  Blindly adding a negative delta could cause the deadline to
> +        * become excessively large due to the deadline being an unsigned value.
> +        */
> +       apic->lapic_timer.tscdeadline = kvm_read_l1_tsc(apic->vcpu, tscl);
> +       if (delta > 0)
> +               apic->lapic_timer.tscdeadline += nsec_to_cycles(apic->vcpu, delta);
>   }
>   
>   static void start_sw_period(struct kvm_lapic *apic)

Thank you for your patient explanations and for helping me make the revisions. I
will update this in the next patch version.

Regards,
fuqiang

