Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CFE2498D7
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 10:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgHSI4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 04:56:12 -0400
Received: from foss.arm.com ([217.140.110.172]:58728 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHSIys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 04:54:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30EB231B;
        Wed, 19 Aug 2020 01:54:47 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C32DD3F6CF;
        Wed, 19 Aug 2020 01:54:45 -0700 (PDT)
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Add pvtime LPT support
To:     Marc Zyngier <maz@kernel.org>, Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
 <8308f52e4c906cad710575724f9e3855@kernel.org>
From:   Steven Price <steven.price@arm.com>
Message-ID: <f14cfd5b-c103-5d56-82fb-59d0371c6f21@arm.com>
Date:   Wed, 19 Aug 2020 09:54:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8308f52e4c906cad710575724f9e3855@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/2020 15:41, Marc Zyngier wrote:
> On 2020-08-17 09:41, Keqian Zhu wrote:
>> Hi all,
>>
>> This patch series picks up the LPT pvtime feature originally developed
>> by Steven Price: https://patchwork.kernel.org/cover/10726499/
>>
>> Backgroud:
>>
>> There is demand for cross-platform migration, which means we have to
>> solve different CPU features and arch counter frequency between hosts.
>> This patch series can solve the latter problem.
>>
>> About LPT:
>>
>> This implements support for Live Physical Time (LPT) which provides the
>> guest with a method to derive a stable counter of time during which the
>> guest is executing even when the guest is being migrated between hosts
>> with different physical counter frequencies.
>>
>> Changes on Steven Price's work:
>> 1. LPT structure: use symmatical semantics of scale multiplier, and use
>>    fraction bits instead of "shift" to make everything clear.
>> 2. Structure allocation: host kernel does not allocates the LPT 
>> structure,
>>    instead it is allocated by userspace through VM attributes. The 
>> save/restore
>>    functionality can be removed.
>> 3. Since LPT structure just need update once for each guest run, add a 
>> flag to
>>    indicate the update status. This has two benifits: 1) avoid 
>> multiple update
>>    by each vCPUs. 2) If the update flag is not set, then return NOT 
>> SUPPORT for
>>    coressponding guest HVC call.
>> 4. Add VM device attributes interface for userspace configuration.
>> 5. Add a base LPT read/write layer to reduce code.
>> 6. Support ptimer scaling.
>> 7. Support timer event stream translation.
>>
>> Things need concern:
>> 1. https://developer.arm.com/docs/den0057/a needs update.
> 
> LPT was explicitly removed from the spec because it doesn't really
> solve the problem, specially for the firmware: EFI knows
> nothing about this, for example. How is it going to work?
> Also, nobody was ever able to explain how this would work for
> nested virt.
> 
> ARMv8.4 and ARMv8.6 have the feature set that is required to solve
> this problem without adding more PV to the kernel.

Hi Marc,

These are good points, however we do still have the situation that CPUs 
that don't have ARMv8.4/8.6 clearly cannot implement this. I presume the 
use-case Keqian is looking at predates the necessary support in the CPU 
- Keqian if you can provide more details on the architecture(s) involved 
that would be helpful.

Nested virt is indeed more of an issue - we did have some ideas around 
using SDEI that never made it to the spec. However I would argue that 
the most pragmatic approach would be to not support the combination of 
nested virt and LPT. Hopefully that can wait until the counter scaling 
support is available and not require PV.

We are discussing (re-)releasing the spec with the LPT parts added. If 
you have fundamental objections then please me know.

Thanks,

Steve
