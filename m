Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D392236E3B2
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 05:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhD2Dbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 23:31:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16166 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhD2Dbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 23:31:46 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FW1Cp45ChzpcHN;
        Thu, 29 Apr 2021 11:27:50 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Thu, 29 Apr 2021 11:30:52 +0800
Subject: Re: [RFC PATCH v2 2/2] KVM: x86: Not wr-protect huge page with
 init_all_set dirty log
To:     Ben Gardon <bgardon@google.com>
References: <20210416082511.2856-1-zhukeqian1@huawei.com>
 <20210416082511.2856-3-zhukeqian1@huawei.com>
 <CANgfPd_WzX6Fm7BiMoBoehuLL8tjh4WEqehUhF8biPyL8vS4XQ@mail.gmail.com>
 <49e6bf4f-0142-c9ea-a8c1-7cfe211c8d7b@huawei.com>
 <CANgfPd840MmH5zKRHb4p1Rk0QEDu8iJoMJZGxWF6fhqxANrptg@mail.gmail.com>
 <f0651fce-3b39-3ca7-6681-9fbc6edf8480@huawei.com>
 <CANgfPd_xJbL388zmirbQW-pSw+o0csmNe=uLA1yV_Zk-QMvDfA@mail.gmail.com>
 <4f71baed-544b-81b2-dfa6-f04016966a5a@huawei.com>
 <60894846.1c69fb81.6e765.161bSMTPIN_ADDED_BROKEN@mx.google.com>
 <CANgfPd_FceqBOf3j-o91rZ_Ziq4vNj_0SVMrzfDVsr6PrweL4A@mail.gmail.com>
CC:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <d2dd806f-7df4-1ba4-9da5-073aece6da1c@huawei.com>
Date:   Thu, 29 Apr 2021 11:30:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd_FceqBOf3j-o91rZ_Ziq4vNj_0SVMrzfDVsr6PrweL4A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

On 2021/4/29 0:22, Ben Gardon wrote:
> On Wed, Apr 28, 2021 at 4:34 AM zhukeqian <zhukeqian1@huawei.com> wrote:
>>
>> Oh, I have to correct myself.
>>
>> without this opt:
>> first round dirtying: write fault and split large mapping
>> second round: write fault
>>
>> with this opt:
>> first round dirtying: no write fault
>> second round: write fault and split large mapping
>>
>> the total test time is expected to be reduced.
> 
> Oh yeah, good point. So we should really see the savings in the first
> round dirty memory time. Good catch.
> 
[...]

>>> It would probably also serve us well to have some kind of "hot" subset
>>> of memory for each vCPU, since some of the benefit of lazy large page
>>> splitting depend on that access pattern.
>>>
>>> 3. Lockstep dirtying and dirty log collection
>>> While this test is currently great for timing dirty logging
>>> operations, it's not great for trickier analysis, especially
>>> reductions to guest degradation. In order to measure that we'd need to
>>> change the test to collect the dirty log as quickly as possible,
>>> independent of what the guest is doing and then also record how much
>>> "progress" the guest is able to make while all that is happening.
>> Yes, make sense.
>>
>> Does the "dirty log collection" contains "dirty log clear"? As I understand, the dirty log
>> collection is very fast, just some memory copy. But for "dirty log clear", we should modify mappings
>> and perform TLBI, the time is much longer.
> 
> Yeah, sorry. By dirty log collection I meant get + clear since the
> test does both before it waits for the guest to dirty all memory
> again.
I see.

> 
>>
>>>
>>> I'd be happy to help review any improvements to the test which you
>>> feel like making.
>> Thanks, Ben. emm... I feel very sorry that perhaps I don't have enough time to do this, many works are queued...
>> On the other hand, I think the "Dirtying memory time" of first round can show us the optimization.
> 
> No worries, I think this is a good patch either way. No need to block
> on test improvements, from my perspective.
OK, thanks.


BRs,
Keqian
