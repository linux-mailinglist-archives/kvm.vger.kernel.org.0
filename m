Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B335E7BAF
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiIWNV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 09:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiIWNVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 09:21:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091C6142E04
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 06:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663939310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zo6WLSvgjbrNE/HT5ShlnCmyG13/PZcEnNZ7Uz62d/E=;
        b=Brlqu/Aby8Wa+A0BVHOfZ0wSl0bh1VSn8vVOJrGeg4XaaCZW5B82JFnziPc30hF2HnK3qf
        CNUj548RlAladxWRQ1PfNzJ2O5MqxjqL1F6gWSuNYZQoflBpYMwP6OO7FQBoIZsF2qd3iV
        la3sv0obAUF+RX8cI9/g2mMjyj3DuPI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-63-e6SlTSxENIuJ8CUJyeSaRw-1; Fri, 23 Sep 2022 09:21:49 -0400
X-MC-Unique: e6SlTSxENIuJ8CUJyeSaRw-1
Received: by mail-wm1-f71.google.com with SMTP id r7-20020a1c4407000000b003b3309435a9so2320845wma.6
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 06:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=zo6WLSvgjbrNE/HT5ShlnCmyG13/PZcEnNZ7Uz62d/E=;
        b=Ftlt5IXzY06jNJ3HoiG7tTVlKuC8QBiEHYKeFNvOP4Tpvmv+nxnP2u3vERy3DM0UnN
         zlfx8HBG7vIHji3gQvB5JHxJNlK2HRstRromvV5qKzdWIRnoG+YoT+ooLz06rT9G/szT
         BtPTeBsEjl9hVCSDVsIy2hFqRODMX7UbByXUvFgODaSrgorRFs9kpI2SCVOLaS/Xjdyp
         kjpB+h8DlgPAcISQ1VVGDksEDBVneCRUD8M657KEWGLeRwJuXEpWynX2yYnkZwThBwZE
         DNvuaGzMBtst7gcabrrLnZOK5lCaygYlSxM2us8jm2/3r6pzt1SvqKNK5VoP8NhqtYAW
         9yLg==
X-Gm-Message-State: ACrzQf3O6HGB09uDMzrC4zpOgGIBsVNnegHY4m9ffcg1jkt9zyTLhACc
        2mAld8ece5wNDY/RJ3d9u+YOWDrJ8gTZOZQUAV3ykQsz8b3ViDYcdCEIEYZ7vWV60abMSecE9N5
        HtZyjZf1XK1DT
X-Received: by 2002:a05:600c:2253:b0:3b4:61f2:3bba with SMTP id a19-20020a05600c225300b003b461f23bbamr5972839wmm.112.1663939308191;
        Fri, 23 Sep 2022 06:21:48 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5wpyYX1B8XjDJvb1BxPgQzUfqIN8t9rWyUWO5Vw1dKdHk1TTaCeGhR2BL/1P0Orzn+Mx1JiQ==
X-Received: by 2002:a05:600c:2253:b0:3b4:61f2:3bba with SMTP id a19-20020a05600c225300b003b461f23bbamr5972817wmm.112.1663939307867;
        Fri, 23 Sep 2022 06:21:47 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:cc00:4585:a83b:64f2:ad21? (p200300cbc704cc004585a83b64f2ad21.dip0.t-ipconnect.de. [2003:cb:c704:cc00:4585:a83b:64f2:ad21])
        by smtp.gmail.com with ESMTPSA id r14-20020a0560001b8e00b0022afcc11f65sm7383443wru.47.2022.09.23.06.21.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 06:21:47 -0700 (PDT)
Message-ID: <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
Date:   Fri, 23 Sep 2022 15:21:45 +0200
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.09.22 15:10, Emanuele Giuseppe Esposito wrote:
> 
> 
> Am 19/09/2022 um 19:30 schrieb David Hildenbrand:
>> On 19.09.22 09:53, David Hildenbrand wrote:
>>> On 18.09.22 18:13, Emanuele Giuseppe Esposito wrote:
>>>>
>>>>
>>>> Am 09/09/2022 um 16:30 schrieb Sean Christopherson:
>>>>> On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
>>>>>> KVM is currently capable of receiving a single memslot update through
>>>>>> the KVM_SET_USER_MEMORY_REGION ioctl.
>>>>>> The problem arises when we want to atomically perform multiple
>>>>>> updates,
>>>>>> so that readers of memslot active list avoid seeing incomplete states.
>>>>>>
>>>>>> For example, in RHBZ
>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1979276
>>>>>
>>>>> I don't have access.  Can you provide a TL;DR?
>>>>
>>>> You should be able to have access to it now.
>>>>
>>>>>
>>>>>> we see how non atomic updates cause boot failure, because vcpus
>>>>>> will se a partial update (old memslot delete, new one not yet created)
>>>>>> and will crash.
>>>>>
>>>>> Why not simply pause vCPUs in this scenario?  This is an awful lot
>>>>> of a complexity
>>>>> to take on for something that appears to be solvable in userspace.
>>>>>
>>>>
>>>> I think it is not that easy to solve in userspace: see
>>>> https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/
>>>>
>>>>
>>>>
>>>> "Using pause_all_vcpus()/resume_all_vcpus() is not possible, as it will
>>>> temporarily drop the BQL - something most callers can't handle (esp.
>>>> when called from vcpu context e.g., in virtio code)."
>>>
>>> Can you please comment on the bigger picture? The patch from me works
>>> around *exactly that*, and for that reason, contains that comment.
>>>
>>
>> FWIW, I hacked up my RFC to perform atomic updates on any memslot
>> transactions (not just resizes) where ranges do add overlap with ranges
>> to remove.
>>
>> https://github.com/davidhildenbrand/qemu/tree/memslot
>>
>>
>> I only performed simple boot check under x86-64 (where I can see region
>> resizes) and some make checks -- pretty sure it has some rough edges;
>> but should indicate what's possible and what the possible price might
>> be. [one could wire up a new KVM ioctl and call it conditionally on
>> support if really required]
>>
> 
> A benefit of my ioctl implementation is that could be also used by other
> hypervisors, which then do not need to share this kind of "hack".
> However, after also talking with Maxim and Paolo, we all agreed that the
> main disadvantage of your approach is that is not scalable with the
> number of vcpus. It is also inferior to stop *all* vcpus just to allow a
> memslot update (KVM only pauses vCPUs that access the modified memslots
> instead).
> 
> So I took some measurements, to see what is the performance difference
> between my implementation and yours. I used a machine where I could
> replicate the bug mentioned in bugzilla, an AMD EPYC 7413 24-Core
> Processor with kernel 5.19.0 (+ my patches).
> 
> Then I measured the time it takes that QEMU spends in kvm_commit (ie in
> memslot updates) while booting a VM. In other words, if kvm_commit takes
> 10 ms and QEMU calls it 20 times, "time to boot" is 200ms. kvm_commit is
> not called anymore after boot, so this measurement is easy to compare
> over multiple invocations of QEMU.
> 
> I ran the tests with different amount of cores: 1,2,4,8,16,32. QEMU
> command is the same to replicate the bug:
> ./qemu-system-x86_64 --overcommit cpu-pm=on --smp $v --accel kvm
> --display none >> ~/smp_$v;
> 
> Each boot is reproduced 100 times, and then from results I measure
> average and stddev (in milliseconds).
> 
> ioctl:
> -smp 1:        Average: 2.1ms        Stdev: 0.8ms
> -smp 2:        Average: 2.5ms        Stdev: 1.5ms
> -smp 4:        Average: 2.2ms        Stdev: 1.1ms
> -smp 8:        Average: 2.4ms        Stdev: 0.7ms
> -smp 16:       Average: 3.6ms        Stdev: 2.4ms  (1000 repetitions)
> -smp 24:       Average: 12.5ms        Stdev: 0.9ms  (1000 repetitions)
> 
> 
> pause/resume: (https://github.com/davidhildenbrand/qemu/tree/memslot)
> -smp 1:        Average: 2.2ms        Stdev: 1.2ms
> -smp 2:        Average: 3.0ms        Stdev: 1.4ms
> -smp 4:        Average: 3.1ms        Stdev: 1.3m
> -smp 8:        Average: 3.4ms        Stdev: 1.4ms
> -smp 16:       Average: 12ms        Stdev: 7.0ms  (1000 repetitions)
> -smp 24:       Average: 20ms        Stdev: 7.3ms  (1000 repetitions)
> 
> 
> Above 24 vCPUs performance gets worse quickly but I think it's already
> quite clear that the results for ioctl scale better as the number of
> vcpus increases, while pausing the vCPUs becomes slower already with 16
> vcpus.

Right, the question is if it happens sufficiently enough that we even 
care and if there are not ways to mitigate.

It doesn't necessarily have to scale with the #VCPUs I think. What 
should dominate the overall time in theory how long it takes for one 
VCPU (the slowest one) to leave the kernel.

I wondered if

1) it might be easier to have a single KVM mechanism/call to kick all 
VCPUs out of KVM instead of doing it per VCPU. That might speed up 
things eventually heavily already.

2) One thing I wondered is whether the biggest overhead is actually 
taking the locks in QEMU and not actually waiting for the VCPUs. Maybe 
we could optimize that as well. (for now I use one lock per VCPU because 
it felt like it would reduce the ioctl overhead; maybe there is a better 
alternative to balance between both users)

So treat my patch as a completely unoptimized version.

-- 
Thanks,

David / dhildenb

