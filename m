Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9B135EFC5
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 10:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350124AbhDNIfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 04:35:37 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16911 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350116AbhDNIfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 04:35:32 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FKwj851vkzkk2r;
        Wed, 14 Apr 2021 16:33:16 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 16:35:00 +0800
Subject: Re: [RFC PATCH] KVM: x86: Support write protect huge pages lazily
To:     Ben Gardon <bgardon@google.com>
References: <20200828081157.15748-1-zhukeqian1@huawei.com>
 <107696eb-755f-7807-a484-da63aad01ce4@huawei.com>
 <YGzxzsRlqouaJv6a@google.com>
 <CANgfPd8g3o2mJZi8rtR6jBNeYJTNWR0LTEcD2PeNLJk9JTz4CQ@mail.gmail.com>
 <ff6a2cbb-7b18-9528-4e13-8728966e8c84@huawei.com>
 <CANgfPd_h509o3kQGEQjuy2tzqnQ+toR4snJVAug=N2TULce3ag@mail.gmail.com>
CC:     Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <f09aabf2-a94c-9176-098f-fee810b99d0c@huawei.com>
Date:   Wed, 14 Apr 2021 16:35:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd_h509o3kQGEQjuy2tzqnQ+toR4snJVAug=N2TULce3ag@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

On 2021/4/14 0:43, Ben Gardon wrote:
> On Tue, Apr 13, 2021 at 2:39 AM Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
>>
>>
>> On 2021/4/13 1:19, Ben Gardon wrote:
>>> On Tue, Apr 6, 2021 at 4:42 PM Sean Christopherson <seanjc@google.com> wrote:
>>>>
>>>> +Ben
>>>>
>>>> On Tue, Apr 06, 2021, Keqian Zhu wrote:
>>>>> Hi Paolo,
>>>>>
>>>>> I plan to rework this patch and do full test. What do you think about this idea
>>>>> (enable dirty logging for huge pages lazily)?
>>>>
>>>> Ben, don't you also have something similar (or maybe the exact opposite?) in the
>>>> hopper?  This sounds very familiar, but I can't quite connect the dots that are
>>>> floating around my head...
>>>
>>> Sorry for the late response, I was out of office last week.
>> Never mind, Sean has told to me. :)
>>
>>>
>>> Yes, we have two relevant features I'd like to reconcile somehow:
>>> 1.) Large page shattering - Instead of clearing a large TDP mapping,
>>> flushing the TLBs, then replacing it with an empty TDP page table, go
>>> straight from the large mapping to a fully pre-populated table. This
>>> is slightly slower because the table needs to be pre-populated, but it
>>> saves many vCPU page faults.
>>> 2.) Eager page splitting - split all large mappings down to 4k when
>>> enabling dirty logging, using large page shattering. This makes
>>> enabling dirty logging much slower, but speeds up the first round (and
>>> later rounds) of gathering / clearing the dirty log and reduces the
>>> number of vCPU page faults. We've prefered to do this when enabling
>>> dirty logging because it's a little less perf-sensitive than the later
>>> passes where latency and convergence are critical.
>> OK, I see. I think the lock stuff is an important part, so one question is that
>> the shattering process is designed to be locked (i.e., protect mapping) or lock-less?
>>
>> If it's locked, vCPU thread may be blocked for a long time (For arm, there is a
>> mmu_lock per VM). If it's lock-less, how can we ensure the synchronization of
>> mapping?
> 
> The TDP MMU for x86 could do it under the MMU read lock, but the
> legacy / shadow x86 MMU and other architectures would need the whole
> MMU lock.
> While we do increase the time required to address a large SPTE, we can
> completely avoid the vCPU needing the MMU lock on an access to that
> SPTE as the translation goes straight from a large, writable SPTE, to
> a 4k spte with either the d bit cleared or write protected. If it's
> write protected, the fault can (at least on x86) be resolved without
> the MMU lock.
That's sounds good! In terms of lock, x86 is better than arm64. For arm64,
we must hold whole MMU lock both for split large page or change permission
for 4K page.

> 
> When I'm able to put together a large page shattering series, I'll do
> some performance analysis and see how it changes things, but that part
OK.

> is sort of orthogonal to this change. The more I think about it, the
> better the init-all-set approach for large pages sounds, compared to
> eager splitting. I'm definitely in support of this patch and am happy
> to help review when you send out the v2 with TDP MMU support and such.
Thanks a lot. :)

> 
>>
>>>
>>> Large page shattering can happen in the NPT page fault handler or the
>>> thread enabling dirty logging / clearing the dirty log, so it's
>>> more-or-less orthogonal to this patch.
>>>
>>> Eager page splitting on the other hand takes the opposite approach to
>>> this patch, frontloading as much of the work to enable dirty logging
>>> as possible. Which approach is better is going to depend a lot on the
>>> guest workload, your live migration constraints, and how the
>>> user-space hypervisor makes use of KVM's growing number of dirty
>>> logging options. In our case, the time to migrate a VM is usually less
>>> of a concern than the performance degradation the guest experiences,
>>> so we want to do everything we can to minimize vCPU exits and exit
>>> latency.
>> Yes, make sense to me.
>>
>>>
>>> I think this is a reasonable change in principle if we're not write
>>> protecting 4k pages already, but it's hard to really validate all the
>>> performance implications. With this change we'd move pretty much all
>>> the work to the first pass of clearing the dirty log, which is
>>> probably an improvement since it's much more granular. The downside is
>> Yes, at least split large page lazily is better than current logic.
>>
>>> that we do more work when we'd really like to be converging the dirty
>>> set as opposed to earlier when we know all pages are dirty anyway.
>> I think the dirty collecting procedure is not affected, do I miss something?
> 
> Oh yeah, good point. Since the splitting of large SPTEs is happening
> in the vCPU threads it wouldn't slow dirty log collection at all. We
> would have to do slightly more work to write protect the large SPTEs
> that weren't written to, but that's a relatively small amount of work.
Indeed.


BRs,
Keqian
