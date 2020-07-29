Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFC42317DF
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 04:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731163AbgG2C5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 22:57:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8846 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728401AbgG2C5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 22:57:41 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DEDAF5C6B6236BE30C72;
        Wed, 29 Jul 2020 10:57:38 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Jul 2020 10:57:30 +0800
From:   zhukeqian <zhukeqian1@huawei.com>
Subject: Re: [PATCH 0/9] arm64: Stolen time support
To:     Steven Price <steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <1611996b-1ec1-dee7-ed61-b3b9df23f138@huawei.com>
 <25c7f2e2-e779-4e97-fdc5-0aba9fcf0fbc@arm.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <linux-doc@vger.kernel.org>, Russell King <linux@armlinux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <xiexiangyou@huawei.com>, <yebiaoxiang@huawei.com>,
        "wanghaibin.wang@huawei.com >> Wanghaibin (D)" 
        <wanghaibin.wang@huawei.com>
Message-ID: <816e3b46-07fc-0274-deb2-0d026d50b989@huawei.com>
Date:   Wed, 29 Jul 2020 10:57:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <25c7f2e2-e779-4e97-fdc5-0aba9fcf0fbc@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steven,

On 2020/7/27 18:48, Steven Price wrote:
> On 21/07/2020 04:26, zhukeqian wrote:
>> Hi Steven,
> 
> Hi Keqian,
> 
>> On 2019/8/2 22:50, Steven Price wrote:
>>> This series add support for paravirtualized time for arm64 guests and
>>> KVM hosts following the specification in Arm's document DEN 0057A:
>>>
>>> https://developer.arm.com/docs/den0057/a
>>>
>>> It implements support for stolen time, allowing the guest to
>>> identify time when it is forcibly not executing.
>>>
>>> It doesn't implement support for Live Physical Time (LPT) as there are
>>> some concerns about the overheads and approach in the above
>> Do you plan to pick up LPT support? As there is demand of cross-frequency migration
>> (from older platform to newer platform).
> 
> I don't have any plans to pick up the LPT support at the moment - feel free to pick it up! ;)
> 
>> I am not clear about the overheads and approach problem here, could you please
>> give some detail information? Maybe we can work together to solve these concerns. :-)
> 
> Fundamentally the issue here is that LPT only solves one small part of migration between different hosts. To successfully migrate between hosts with different CPU implementations it is also necessary to be able to virtualise various ID registers (e.g. MIDR_EL1, REVIDR_EL1, AIDR_EL1) which we have no support for currently.
> 
Yeah, currently we are trying to do both timer freq virtualization and CPU feature virtualization.

> The problem with just virtualising the registers is how you handle errata. The guest will currently use those (and other) ID registers to decide whether to enable specific errata workarounds. But what errata should be enabled for a guest which might migrate to another host?
> 
Thanks for pointing this out.

I think the most important thing is that we should introduce a concept named CPU baseline which represents a standard platform.
If we bring up a guest with a specific CPU baseline, then this guest can only run on a platform that is compatible with this CPU baseline.
So "baseline" and "compatible" are the key point to promise successful cross-platform migration.


> What we ideally need is a mechanism to communicate to the guest what workarounds are required to successfully run on any of the hosts that the guest may be migrated to. You may also have the situation where the workarounds required for two hosts are mutually incompatible - something needs to understand this and do the "right thing" (most likely just reject this situation, i.e. prevent the migration).
> 
> There are various options here: e.g. a para-virtualised interface to describe the workarounds (but this is hard to do in an OS-agnostic way), or virtual-ID registers describing an idealised environment where no workarounds are required (and only hosts that have no errata affecting a guest would be able to provide this).
> 
My idea is similar with the "idealised environment", but errata workaround still exists.
We do not provide para-virtualised interface, and migration is restricted between platforms that are compatible with baseline.

Baseline should has two aspects: CPU feature and errata. These platforms that are compatible with a specific baseline should have the corresponding CPU feature and errata.

> Given the above complexity and the fact that Armv8.6-A standardises the frequency to 1GHz this didn't seem worth continuing with. So LPT was dropped from the spec and patches to avoid holding up the stolen time support.
> 
> However, if you have a use case which doesn't require such a generic migration (e.g. perhaps old and new platforms are based on the same IP) then it might be worth looking at bring this back. But to make the problem solvable it either needs to be restricted to platforms which are substantially the same (so the errata list will be identical), or there's work to be done in preparation to deal with migrating a guest successfully between hosts with potentially different errata requirements.
> 
> Can you share more details about the hosts that you are interested in migrating between?
Here we have new platform with 1GHz timer, and old platform is 100MHZ, so we want to solve the cross-platform migration firstly.

Thanks,
Keqian
> 
> Thanks,
> 
> Steve
> .
> 
