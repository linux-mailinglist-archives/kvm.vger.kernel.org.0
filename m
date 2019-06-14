Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C696F460B7
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 16:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfFNO2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 10:28:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40258 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbfFNO2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 10:28:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so2536866wmj.5
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 07:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gJhQ1swIhwsziMzQ39z2HtlgHPGl8G/dIf/ljZ3Elzc=;
        b=NzGe0lBZPlBdzTofmXIqrp22eBCKs83VYeCnTK1eLSFKeAtWNjdsyZ2C+eNgP34v6z
         egu+yF4BKK1a/sX3NPASmkynDghdKukYbeAAArjve9Vm9PVY37mF1MlfL6i7cnC4S/jk
         0jlTWuGX3rjIy7t9ZjO+eB1yi8wAYgeGDeHIDst0kFOxPIx1gWQC3mqbmK/Z0JzH8lOh
         15Q/Ju47sxgD5mGMCu2/Jq0peO7YPgQHySPoTjD3MDzwE8D6Ab+JiHN4+eYCfR9qeC1z
         ou79yxXjD2bH/FKleRdybm5V1f34MAS6rLu1cvz+J6VpQVOpJ7u3D0PYOLlSoNPlkZpK
         Dp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gJhQ1swIhwsziMzQ39z2HtlgHPGl8G/dIf/ljZ3Elzc=;
        b=uKNrCILws5OCOK/5iZ+gIqO1uMk0mlvOnUjeMALfFI40yj9bEMsNciSpyu9nwYKnbT
         xJ60dcF4MUFoIYqAEmzLvci5k3K6KlR2QBNKBTblg3CqKyCrJ+nhJ2SzFb1MDteCD3Pp
         AC0g/20xBS9+DQBRyiUZ0mwIgV7mssLiqzF48dI+7ozipn5mJA6ZpCSiNRDQLhKet3Im
         B1DXFcW9DQbXYpkI+wPnpzPgRn0WRkh/bjEzqMjXCtwE6YdfMcKVfdO3KgDDoblhRCNv
         AfZqmM6/RmvEuT4VjnqgyU1dn/NbByN67qoDanHDUBKUDT/wdfJ0U3zt90yYylu8KERQ
         nalg==
X-Gm-Message-State: APjAAAXpUvahjjuS3dpUTTYb3bP+EFgZDoB3YJ2BWN3ID8YzBSx5Axpg
        eZhqQKNa2Zep/dHAcldeK6JFEA==
X-Google-Smtp-Source: APXvYqzSaBn/LW5PNl3Fw68CoiWJ8zHyUfbFM0QEo1S/tMx9V8OOACrj70RsjtKYpezFPjq9p2+eYw==
X-Received: by 2002:a1c:208c:: with SMTP id g134mr8349611wmg.112.1560522519747;
        Fri, 14 Jun 2019 07:28:39 -0700 (PDT)
Received: from [10.83.36.153] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id f2sm4990720wrq.48.2019.06.14.07.28.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 07:28:38 -0700 (PDT)
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting
 reenlightenment vector
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org,
        Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
References: <20190611212003.26382-1-dima@arista.com>
 <8736kff6q3.fsf@vitty.brq.redhat.com>
 <20190614082807.GV3436@hirez.programming.kicks-ass.net>
 <877e9o7a4e.fsf@vitty.brq.redhat.com>
 <cb9e1645-98c2-4341-d6da-4effa4f57fb1@arista.com>
 <20190614122726.GL3436@hirez.programming.kicks-ass.net>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <d0ea735e-487e-8205-9415-8708a686ede9@arista.com>
Date:   Fri, 14 Jun 2019 15:28:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614122726.GL3436@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/14/19 1:27 PM, Peter Zijlstra wrote:
> On Fri, Jun 14, 2019 at 12:50:51PM +0100, Dmitry Safonov wrote:
>> On 6/14/19 11:08 AM, Vitaly Kuznetsov wrote:
>>> Peter Zijlstra <peterz@infradead.org> writes:
>>>
>>>> @@ -182,7 +182,7 @@ void set_hv_tscchange_cb(void (*cb)(void))
>>>>  	struct hv_reenlightenment_control re_ctrl = {
>>>>  		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
>>>>  		.enabled = 1,
>>>> -		.target_vp = hv_vp_index[smp_processor_id()]
>>>> +		.target_vp = hv_vp_index[raw_smp_processor_id()]
>>>>  	};
>>>>  	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
>>>>  
>>>
>>> Yes, this should do, thanks! I'd also suggest to leave a comment like
>>> 	/* 
>>>          * This function can get preemted and migrate to a different CPU
>>> 	 * but this doesn't matter. We just need to assign
>>> 	 * reenlightenment notification to some online CPU. In case this
>>>          * CPU goes offline, hv_cpu_die() will re-assign it to some
>>>  	 * other online CPU.
>>> 	 */
>>
>> What if the cpu goes down just before wrmsrl()?
>> I mean, hv_cpu_die() will reassign another cpu, but this thread will be
>> resumed on some other cpu and will write cpu number which is at that
>> moment already down?
>>
>> (probably I miss something)
>>
>> And I presume it's guaranteed that during hv_cpu_die() no other cpu may
>> go down:
>> :	new_cpu = cpumask_any_but(cpu_online_mask, cpu);
>> :	re_ctrl.target_vp = hv_vp_index[new_cpu];
>> :	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
> 
> Then cpus_read_lock() is the right interface, not preempt_disable().
> 
> I know you probably can't change the HV interface, but I'm thinking its
> rather daft you have to specify a CPU at all for this. The HV can just
> pick one and send the notification there, who cares.

Heh, I thought cpus_read_lock() is more "internal" api and
preempt_diable() is prefered ;-)

Will send v2 with the suggested comment and cpus_read_lock().

-- 
          Dima
