Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0336B3C9C4C
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 12:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbhGOKDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 06:03:45 -0400
Received: from foss.arm.com ([217.140.110.172]:50398 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233629AbhGOKDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 06:03:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB15431B;
        Thu, 15 Jul 2021 03:00:48 -0700 (PDT)
Received: from [10.57.36.240] (unknown [10.57.36.240])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FAED3F694;
        Thu, 15 Jul 2021 03:00:48 -0700 (PDT)
Subject: Re: Any way to disable KVM VHE extension?
To:     Qu Wenruo <wqu@suse.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
 <e17449e7-b91d-d288-ff1c-e9451f9d1973@arm.com>
 <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <6331dfe5-a028-4a71-6cc1-479003a58f47@arm.com>
Date:   Thu, 15 Jul 2021 11:00:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0e992d47-1f17-d49f-8341-670770ac49ef@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-15 10:44, Qu Wenruo wrote:
> 
> 
> On 2021/7/15 下午5:28, Robin Murphy wrote:
>> On 2021-07-15 09:55, Qu Wenruo wrote:
>>> Hi,
>>>
>>> Recently I'm playing around the Nvidia Xavier AGX board, which has 
>>> VHE extension support.
>>>
>>> In theory, considering the CPU and memory, it should be pretty 
>>> powerful compared to boards like RPI CM4.
>>>
>>> But to my surprise, KVM runs pretty poor on Xavier.
>>>
>>> Just booting the edk2 firmware could take over 10s, and 20s to fully 
>>> boot the kernel.
>>> Even my VM on RPI CM4 has way faster boot time, even just running on 
>>> PCIE2.0 x1 lane NVME, and just 4 2.1Ghz A72 core.
>>>
>>> This is definitely out of my expectation, I double checked to be sure 
>>> that it's running in KVM mode.
>>>
>>> But further digging shows that, since Xavier AGX CPU supports VHE, 
>>> kvm is running in VHE mode other than HYP mode on CM4.
>>>
>>> Is there anyway to manually disable VHE mode to test the more common 
>>> HYP mode on Xavier?
>>
>> According to kernel-parameters.txt, "kvm-arm.mode=nvhe" (or its 
>> low-level equivalent "id_aa64mmfr1.vh=0") on the command line should 
>> do that.
> 
> Thanks for this one, I stupidly only searched modinfo of kvm, and didn't 
> even bother to search arch/arm64/kvm...
> 
>>
>> However I'd imagine the discrepancy is likely to be something more 
>> fundamental to the wildly different microarchitectures. There's 
>> certainly no harm in giving non-VHE a go for comparison, but I 
>> wouldn't be surprised if it turns out even slower...
> 
> You're totally right, with nvhe mode, it's still the same slow speed.
> 
> BTW, what did you mean by the "wildly different microarch"?
> Is ARMv8.2 arch that different from ARMv8 of RPI4?

I don't mean Armv8.x architectural features, I mean the actual 
implementation of NVIDIA's Carmel core is very, very different from 
Cortex-A72 or indeed our newer v8.2 Cortex-A designs.

> And any extra methods I could try to explore the reason of the slowness?

I guess the first check would be whether you're trapping and exiting the 
VM significantly more. I believe there are stats somewhere, but I don't 
know exactly where, sorry - I know very little about actually *using* KVM :)

If it's not that, then it might just be that EDK2 is doing a lot of 
cache maintenance or system register modification or some other 
operation that happens to be slower on Carmel compared to Cortex-A72.

Robin.

> At least RPI CM4 is beyond my expectation and is working pretty fine.
> 
> Thanks,
> Qu
> 
>>
>> Robin.
>>
>>> BTW, this is the dmesg related to KVM on Xavier, running v5.13 
>>> upstream kernel, with 64K page size:
>>> [    0.852357] kvm [1]: IPA Size Limit: 40 bits
>>> [    0.857378] kvm [1]: vgic interrupt IRQ9
>>> [    0.862122] kvm: pmu event creation failed -2
>>> [    0.866734] kvm [1]: VHE mode initialized successfully
>>>
>>> While on CM4, the host runs v5.12.10 upstream kernel (with downstream 
>>> dtb), with 4K page size:
>>> [    1.276818] kvm [1]: IPA Size Limit: 44 bits
>>> [    1.278425] kvm [1]: vgic interrupt IRQ9
>>> [    1.278620] kvm [1]: Hyp mode initialized successfully
>>>
>>> Could it be the PAGE size causing problem?
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 
