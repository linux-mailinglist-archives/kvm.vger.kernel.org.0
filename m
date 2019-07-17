Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138676B8C0
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbfGQI62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 04:58:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54718 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfGQI61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 04:58:27 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3FE53B411F28E99262E4;
        Wed, 17 Jul 2019 16:58:22 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 17 Jul 2019
 16:58:13 +0800
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 kvm_pmu_get_canonical_pmc+0x48/0x78
To:     Andrew Murray <andrew.murray@arm.com>
CC:     <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <kasan-dev@googlegroups.com>, <kvm@vger.kernel.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <644e3455-ea6d-697a-e452-b58961341381@huawei.com>
 <f9d5d18a-7631-f3e2-d73a-21d8eee183f1@huawei.com>
 <20190716185043.GV7227@e119886-lin.cambridge.arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3b128267-7879-0205-3571-e219fc7b8d42@huawei.com>
Date:   Wed, 17 Jul 2019 16:54:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190716185043.GV7227@e119886-lin.cambridge.arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 2019/7/17 2:50, Andrew Murray wrote:
> On Tue, Jul 16, 2019 at 11:14:37PM +0800, Zenghui Yu wrote:
>>
>> On 2019/7/16 23:05, Zenghui Yu wrote:
>>> Hi folks,
>>>
>>> Running the latest kernel with KASAN enabled, we will hit the following
>>> KASAN BUG during guest's boot process.
>>>
>>> I'm in commit 9637d517347e80ee2fe1c5d8ce45ba1b88d8b5cd.
>>>
>>> Any problems in the chained PMU code? Or just a false positive?
>>>
>>> ---8<---
>>>
>>> [  654.706268]
>>> ==================================================================
>>> [  654.706280] BUG: KASAN: slab-out-of-bounds in
>>> kvm_pmu_get_canonical_pmc+0x48/0x78
>>> [  654.706286] Read of size 8 at addr ffff801d6c8fea38 by task
>>> qemu-kvm/23268
>>>
>>> [  654.706296] CPU: 2 PID: 23268 Comm: qemu-kvm Not tainted 5.2.0+ #178
>>> [  654.706301] Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.58
>>> 10/24/2018
>>> [  654.706305] Call trace:
>>> [  654.706311]  dump_backtrace+0x0/0x238
>>> [  654.706317]  show_stack+0x24/0x30
>>> [  654.706325]  dump_stack+0xe0/0x134
>>> [  654.706332]  print_address_description+0x80/0x408
>>> [  654.706338]  __kasan_report+0x164/0x1a0
>>> [  654.706343]  kasan_report+0xc/0x18
>>> [  654.706348]  __asan_load8+0x88/0xb0
>>> [  654.706353]  kvm_pmu_get_canonical_pmc+0x48/0x78
>>
>> I noticed that we will use "pmc->idx" and the "chained" bitmap to
>> determine if the pmc is chained, in kvm_pmu_pmc_is_chained().
>>
>> Should we initialize the idx and the bitmap appropriately before
>> doing kvm_pmu_stop_counter()?  Like:
> 
> Hi Zenghui,
> 
> Thanks for spotting this and investigating - I'll make sure to use KASAN
> in the future when testing...
> 
>>
>>
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index 3dd8238..cf3119a 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -224,12 +224,12 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>>   	int i;
>>   	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>>
>> +	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>> +
>>   	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
>> -		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
>>   		pmu->pmc[i].idx = i;
>> +		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
>>   	}
>> -
>> -	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>>   }
> 
> We have to be a little careful here, as the vcpu may be reset after use.
> Upon resetting we must ensure that any existing perf_events are released -
> this is why kvm_pmu_stop_counter is called before bitmap_zero (as
> kvm_pmu_stop_counter relies on kvm_pmu_pmc_is_chained).
> 
> (For example, by clearing the bitmap before stopping the counters, we will
> attempt to release the perf event for both pmc's in a chained pair. Whereas
> we should only release the canonical pmc. It's actually OK right now as we
> set the non-canonical pmc perf_event will be NULL - but who knows that this
> will hold true in the future. The code makes the assumption that the
> non-canonical perf event isn't touched on a chained pair).

Indeed!

> The KASAN bug gets fixed by moving the assignment of idx before
> kvm_pmu_stop_counter. Therefore I'd suggest you drop the bitmap_zero hunks.
> 
> Can you send a patch with just the idx assignment hunk please?

Sure. I will send a patch with your Suggested-by, after some tests.


Thanks,
zenghui

