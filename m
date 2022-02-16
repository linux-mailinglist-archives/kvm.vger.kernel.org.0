Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82A74B81F3
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 08:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiBPHok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 02:44:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiBPHoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 02:44:38 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0F018B326;
        Tue, 15 Feb 2022 23:44:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b8so1698275pjb.4;
        Tue, 15 Feb 2022 23:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=KjyiB4oe2UgRaagEunQWB/cqQBQkKmQNg7Q7gBoEQ8Y=;
        b=PAi4F0tNpJVGT+YHKu1FhHsi0Zuw065ICyGZuy8CZbf4wVdz4C5i3MS8Lqt7GEkPJU
         t87l6ZNbOQaXqGjNm7XxHbPLXWnAWDPd5ZiQWcGGGaFXvOPhHkoxZnDuPIretW3gmJZL
         kn1dInwOAKfwzPxVuSAojkZdK4Jr5GOEupbnGZEyibMA/7FBVNs0UhMACWY730FVr3FC
         gORr6LzITU8f/METwHdsayXhT2+onP+unXqjDroLPBidvv5sEQPyQHdJkyesodaYgH3o
         Xa+vVH1xWlS32p8YGuxNn2fQhpCxPqvJuEbDdzy1JSy08DeTenzmLxbZ1GgePKTWJx6D
         RAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=KjyiB4oe2UgRaagEunQWB/cqQBQkKmQNg7Q7gBoEQ8Y=;
        b=n44qgXXUJYxkmlglvLcbhig9XQduspqIQpkh1nUeFWVMP59T+FrnUHybZazgNrK7wT
         5cuo/NHz78jcLpkijXX5rXhy4cx1HQ1pkDeknZocVoxEJBoYh7FkF0i2DqSV7kb8C9KW
         f+CGrw1e0IkOHUGhBf9sOR0r4g9c5EsgiEm1zBMHk3r1FqahfcOnHlXLzChabOSfyO4d
         DpFq1/pSZiImWJHoPoyN5OP7jPvCeBEgCl0kh/FvV0p6I7Js927IB7XQSAdlRZMJaplr
         EAJnIPYoIZBNZWOnOsN7XWBCZYIS3SuDzrZLCiCTOYdPQHDRwmLxZ9kGnFSoL8tiN9t4
         P1FA==
X-Gm-Message-State: AOAM5300/k7G1q9OYmKRydVuGjRT/chSgZFsvt4K2ttrU94I6jsNoy7L
        WcQ+vANatnMXPTWClXpvcjU=
X-Google-Smtp-Source: ABdhPJwQdilXqV6xdeV2/P8S1VH9zYJZCsJE2ZmXd8ova9N24AJUwvcr9N4ZfXc0kFk+lowwj/WGoQ==
X-Received: by 2002:a17:902:d886:b0:14d:5b6f:5bbe with SMTP id b6-20020a170902d88600b0014d5b6f5bbemr1315538plz.127.1644997454528;
        Tue, 15 Feb 2022 23:44:14 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f8sm43168547pfv.24.2022.02.15.23.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 23:44:14 -0800 (PST)
Message-ID: <71689d29-caf8-ed7e-2cd7-61cbab0fc7e0@gmail.com>
Date:   Wed, 16 Feb 2022 15:44:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 2/6] KVM: x86/pmu: Refactoring find_arch_event() to
 pmc_perf_hw_id()
Content-Language: en-US
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Dunn <daviddunn@google.com>,
        Stephane Eranian <eranian@google.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jim Mattson <jmattson@google.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-3-likexu@tencent.com>
 <CALMp9eQG7eqq+u3igApsRDV=tt0LdjZzmD_dC8zw=gt=f5NjSA@mail.gmail.com>
 <7de112b2-e6d1-1f9d-a040-1c4cfee40b22@gmail.com>
 <CALMp9eTVxN34fCV8q53_38R2DxNdR9_1aSoRmF8gKt2yhOMndg@mail.gmail.com>
 <3bedc79a-5e60-677c-465b-3bc8aa2daad8@gmail.com>
 <d4dae262-3063-3225-c6e1-3a8513a497ec@amd.com>
 <CALMp9eShc-o+OZ3j4kDkTbXmY58wQu6Rq6qviZAHsDr4X21a5Q@mail.gmail.com>
 <4373e8d7-e3e8-164c-75e3-6ca495a79167@amd.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <4373e8d7-e3e8-164c-75e3-6ca495a79167@amd.com>
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

On 14/2/2022 6:14 pm, Ravi Bangoria wrote:
> 
> 
> On 11-Feb-22 11:46 PM, Jim Mattson wrote:
>> On Fri, Feb 11, 2022 at 1:56 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>
>>>
>>>
>>> On 10-Feb-22 4:58 PM, Like Xu wrote:
>>>> cc Kim and Ravi to help confirm more details about this change.
>>>>
>>>> On 10/2/2022 3:30 am, Jim Mattson wrote:
>>>>> By the way, the following events from amd_event_mapping[] are not
>>>>> listed in the Milan PPR:
>>>>> { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES }
>>>>> { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES }
>>>>> { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND }
>>>>> { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND }
>>>>>
>>>>> Perhaps we should build a table based on amd_f17h_perfmon_event_map[]
>>>>> for newer AMD processors?

So do we need another amd_f19h_perfmon_event_map[] in the host perf code ?

>>>
>>> I think Like's other patch series to unify event mapping across kvm
>>> and host will fix it. No?
>>> https://lore.kernel.org/lkml/20220117085307.93030-4-likexu@tencent.com
>>
>> Yes, that should fix it. But why do we even bother? What is the
>> downside of using PERF_TYPE_RAW all of the time?
> 
> There are few places where PERF_TYPE_HARDWARE and PERF_TYPE_RAW are treated
> differently. Ex, x86_pmu_event_init(), perf_init_event(). So I think it makes
> sense to keep using PERF_TYPE_HARDWARE for generalized events?
> 
> Ravi
