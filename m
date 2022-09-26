Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6015E9CD8
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiIZJD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 05:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234733AbiIZJD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 05:03:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1833F33B
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 02:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664183003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EiRILOXIL9Cc1HhYfrtZucdPYwDfjfCh1nR/cVNCk6E=;
        b=Kc2uy9FO7YRi1bW+VuiSpiCEHie0EaRm0xW+aJLPL2eawFpVQrZ4BQapD/j1R1j8kmzEg7
        EjCkm8URvvJCHpbhRYVb3cVB861Cyf8ws/Mb7ZDLOpMisD6TCSP+bwf1a7nqGCKsWfy8iC
        hQq+K/hHgzAFZUrZZb5iJTq/38XzIXo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-368-4dl_0zArOiWVhr-Vvytw9g-1; Mon, 26 Sep 2022 05:03:22 -0400
X-MC-Unique: 4dl_0zArOiWVhr-Vvytw9g-1
Received: by mail-wm1-f70.google.com with SMTP id y20-20020a05600c365400b003b4d4ae666fso1617957wmq.4
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 02:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=EiRILOXIL9Cc1HhYfrtZucdPYwDfjfCh1nR/cVNCk6E=;
        b=C2P9UYTCA9+d4cy0JJNF9LU+iWiOkToqxiRhRyraiGlfLY0Lor+m78iQ6ZbsP8xM9Q
         P0Imp8wY0TtZcmG3H3dU4Q/BIbUAlK7+G3eIrpPp4hcHqUC47fYonAxJahUIlmkmx3Uz
         r65ynSMJXWuUpF36z5GoeyGeTCH/ndQP1WW81sPlmgc3otDBGZdo4jMIB0Gwa6qI2iWR
         ear1UebKNtn8KlAwDEeyKQ9TUEsS01dS8gLOce4HRpMnyOAMs3LEtsi8oZuoVqV2j0ei
         cj0qbum8UKqpRrGQxRsojm4hSahK+R6vtDjpI80IQBToO9HKKQOX9IvpQqmrekH8lN3p
         T5yQ==
X-Gm-Message-State: ACrzQf2fB0pzYLQgjI1iul2iu8RPrqEPtUBQwuTChcDJUkQ0BL0nW+PY
        wddsEiwm5mFDFTbaBUBGNovUwkUlRnmjKUcJ6KDKbNSTUgfGHzr3GPZ/GGh5ez1dP3+7EFfKLDt
        YEfNa1jzN+VDT
X-Received: by 2002:a5d:5847:0:b0:22b:377:6786 with SMTP id i7-20020a5d5847000000b0022b03776786mr12792777wrf.568.1664183001285;
        Mon, 26 Sep 2022 02:03:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ur8rzk7K6B14clro+Q+XG8+AsmvdgRy/j9ihfwytsbvFduuqzmuCbCZcTXjfSnXd4BFAxcw==
X-Received: by 2002:a5d:5847:0:b0:22b:377:6786 with SMTP id i7-20020a5d5847000000b0022b03776786mr12792756wrf.568.1664183000907;
        Mon, 26 Sep 2022 02:03:20 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:4b00:e090:7fa6:b7d6:d4a7? (p200300cbc7034b00e0907fa6b7d6d4a7.dip0.t-ipconnect.de. [2003:cb:c703:4b00:e090:7fa6:b7d6:d4a7])
        by smtp.gmail.com with ESMTPSA id e11-20020adfef0b000000b0022ae0965a8asm14030288wro.24.2022.09.26.02.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 02:03:20 -0700 (PDT)
Message-ID: <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
Date:   Mon, 26 Sep 2022 11:03:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
 <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
 <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
 <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
 <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.09.22 15:38, Emanuele Giuseppe Esposito wrote:
> 
> 
> Am 23/09/2022 um 15:21 schrieb David Hildenbrand:
>> On 23.09.22 15:10, Emanuele Giuseppe Esposito wrote:
>>>
>>>
>>> Am 19/09/2022 um 19:30 schrieb David Hildenbrand:
>>>> On 19.09.22 09:53, David Hildenbrand wrote:
>>>>> On 18.09.22 18:13, Emanuele Giuseppe Esposito wrote:
>>>>>>
>>>>>>
>>>>>> Am 09/09/2022 um 16:30 schrieb Sean Christopherson:
>>>>>>> On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
>>>>>>>> KVM is currently capable of receiving a single memslot update
>>>>>>>> through
>>>>>>>> the KVM_SET_USER_MEMORY_REGION ioctl.
>>>>>>>> The problem arises when we want to atomically perform multiple
>>>>>>>> updates,
>>>>>>>> so that readers of memslot active list avoid seeing incomplete
>>>>>>>> states.
>>>>>>>>
>>>>>>>> For example, in RHBZ
>>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1979276
>>>>>>>
>>>>>>> I don't have access.  Can you provide a TL;DR?
>>>>>>
>>>>>> You should be able to have access to it now.
>>>>>>
>>>>>>>
>>>>>>>> we see how non atomic updates cause boot failure, because vcpus
>>>>>>>> will se a partial update (old memslot delete, new one not yet
>>>>>>>> created)
>>>>>>>> and will crash.
>>>>>>>
>>>>>>> Why not simply pause vCPUs in this scenario?  This is an awful lot
>>>>>>> of a complexity
>>>>>>> to take on for something that appears to be solvable in userspace.
>>>>>>>
>>>>>>
>>>>>> I think it is not that easy to solve in userspace: see
>>>>>> https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> "Using pause_all_vcpus()/resume_all_vcpus() is not possible, as it
>>>>>> will
>>>>>> temporarily drop the BQL - something most callers can't handle (esp.
>>>>>> when called from vcpu context e.g., in virtio code)."
>>>>>
>>>>> Can you please comment on the bigger picture? The patch from me works
>>>>> around *exactly that*, and for that reason, contains that comment.
>>>>>
>>>>
>>>> FWIW, I hacked up my RFC to perform atomic updates on any memslot
>>>> transactions (not just resizes) where ranges do add overlap with ranges
>>>> to remove.
>>>>
>>>> https://github.com/davidhildenbrand/qemu/tree/memslot
>>>>
>>>>
>>>> I only performed simple boot check under x86-64 (where I can see region
>>>> resizes) and some make checks -- pretty sure it has some rough edges;
>>>> but should indicate what's possible and what the possible price might
>>>> be. [one could wire up a new KVM ioctl and call it conditionally on
>>>> support if really required]
>>>>
>>>
>>> A benefit of my ioctl implementation is that could be also used by other
>>> hypervisors, which then do not need to share this kind of "hack".
>>> However, after also talking with Maxim and Paolo, we all agreed that the
>>> main disadvantage of your approach is that is not scalable with the
>>> number of vcpus. It is also inferior to stop *all* vcpus just to allow a
>>> memslot update (KVM only pauses vCPUs that access the modified memslots
>>> instead).
>>>
>>> So I took some measurements, to see what is the performance difference
>>> between my implementation and yours. I used a machine where I could
>>> replicate the bug mentioned in bugzilla, an AMD EPYC 7413 24-Core
>>> Processor with kernel 5.19.0 (+ my patches).
>>>
>>> Then I measured the time it takes that QEMU spends in kvm_commit (ie in
>>> memslot updates) while booting a VM. In other words, if kvm_commit takes
>>> 10 ms and QEMU calls it 20 times, "time to boot" is 200ms. kvm_commit is
>>> not called anymore after boot, so this measurement is easy to compare
>>> over multiple invocations of QEMU.
>>>
>>> I ran the tests with different amount of cores: 1,2,4,8,16,32. QEMU
>>> command is the same to replicate the bug:
>>> ./qemu-system-x86_64 --overcommit cpu-pm=on --smp $v --accel kvm
>>> --display none >> ~/smp_$v;
>>>
>>> Each boot is reproduced 100 times, and then from results I measure
>>> average and stddev (in milliseconds).
>>>
>>> ioctl:
>>> -smp 1:        Average: 2.1ms        Stdev: 0.8ms
>>> -smp 2:        Average: 2.5ms        Stdev: 1.5ms
>>> -smp 4:        Average: 2.2ms        Stdev: 1.1ms
>>> -smp 8:        Average: 2.4ms        Stdev: 0.7ms
>>> -smp 16:       Average: 3.6ms        Stdev: 2.4ms  (1000 repetitions)
>>> -smp 24:       Average: 12.5ms        Stdev: 0.9ms  (1000 repetitions)
>>>
>>>
>>> pause/resume: (https://github.com/davidhildenbrand/qemu/tree/memslot)
>>> -smp 1:        Average: 2.2ms        Stdev: 1.2ms
>>> -smp 2:        Average: 3.0ms        Stdev: 1.4ms
>>> -smp 4:        Average: 3.1ms        Stdev: 1.3m
>>> -smp 8:        Average: 3.4ms        Stdev: 1.4ms
>>> -smp 16:       Average: 12ms        Stdev: 7.0ms  (1000 repetitions)
>>> -smp 24:       Average: 20ms        Stdev: 7.3ms  (1000 repetitions)
>>>
>>>
>>> Above 24 vCPUs performance gets worse quickly but I think it's already
>>> quite clear that the results for ioctl scale better as the number of
>>> vcpus increases, while pausing the vCPUs becomes slower already with 16
>>> vcpus.
>>
>> Right, the question is if it happens sufficiently enough that we even
>> care and if there are not ways to mitigate.
>>
>> It doesn't necessarily have to scale with the #VCPUs I think. What
>> should dominate the overall time in theory how long it takes for one
>> VCPU (the slowest one) to leave the kernel.
>>
>> I wondered if
>>
>> 1) it might be easier to have a single KVM mechanism/call to kick all
>> VCPUs out of KVM instead of doing it per VCPU. That might speed up
>> things eventually heavily already.
> 
> So if I understand correclty, this implies creating a new ioctl in KVM
> anyways? What would be then the difference with what I do? We are
> affecting the kernel anyways.
> 

If that turns out to be the actual bottleneck. I haven't analyzed what 
exactly is causing the delay with increasing # VCPUs, so I'm just guessing.

Right now, we primarily use pthread_kill(SIG_IPI) to send a signal to 
each VCPU thread.

>>
>> 2) One thing I wondered is whether the biggest overhead is actually
>> taking the locks in QEMU and not actually waiting for the VCPUs. Maybe
>> we could optimize that as well. (for now I use one lock per VCPU because
>> it felt like it would reduce the ioctl overhead; maybe there is a better
>> alternative to balance between both users)
>>
>> So treat my patch as a completely unoptimized version.
>>
> For what is worth, also my version performs #invalidate+1 swaps, which
> is not optimized.
> 
> Honestly, I don't see how the above is easier or simpler than what is
> being proposed here.

As Sean said "This is an awful lot of a complexity to take on for 
something that appears to be solvable in userspace."

I showed that it's possible. So from that point on, there has to be good 
justification why that complexity has to exist in kernel space to 
optimize this scenario.

Now, it's not my call to make. I'm just pointing out that it can be done 
and that there might be room for improvement in my quick prototype.

-- 
Thanks,

David / dhildenb

