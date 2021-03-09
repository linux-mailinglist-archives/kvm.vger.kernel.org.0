Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51D53320C2
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhCIIe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:59 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:3296 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCIIer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:47 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DvpN94kWnz1436s;
        Tue,  9 Mar 2021 16:31:53 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 9 Mar 2021 16:34:44 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 16:34:44 +0800
Subject: Re: [PATCH 2/2] KVM: arm64: Skip the cache flush when coalescing
 tables into a block
To:     Will Deacon <will@kernel.org>
CC:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>
References: <20210125141044.380156-1-wangyanan55@huawei.com>
 <20210125141044.380156-3-wangyanan55@huawei.com>
 <20210308163454.GA26561@willie-the-truck>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <8a947c73-16e9-7ca7-c185-d4c951938505@huawei.com>
Date:   Tue, 9 Mar 2021 16:34:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210308163454.GA26561@willie-the-truck>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/3/9 0:34, Will Deacon wrote:
> On Mon, Jan 25, 2021 at 10:10:44PM +0800, Yanan Wang wrote:
>> After dirty-logging is stopped for a VM configured with huge mappings,
>> KVM will recover the table mappings back to block mappings. As we only
>> replace the existing page tables with a block entry and the cacheability
>> has not been changed, the cache maintenance opreations can be skipped.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 8e8549ea1d70..37b427dcbc4f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -744,7 +744,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   {
>>   	int ret = 0;
>>   	bool write_fault, writable, force_pte = false;
>> -	bool exec_fault;
>> +	bool exec_fault, adjust_hugepage;
>>   	bool device = false;
>>   	unsigned long mmu_seq;
>>   	struct kvm *kvm = vcpu->kvm;
>> @@ -872,12 +872,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   		mark_page_dirty(kvm, gfn);
>>   	}
>>   
>> -	if (fault_status != FSC_PERM && !device)
>> +	/*
>> +	 * There is no necessity to perform cache maintenance operations if we
>> +	 * will only replace the existing table mappings with a block mapping.
>> +	 */
>> +	adjust_hugepage = fault_granule < vma_pagesize ? true : false;
> nit: you don't need the '? true : false' part
>
> That said, your previous patch checks for 'fault_granule > vma_pagesize',
> so I'm not sure the local variable helps all that much here because it
> obscures the size checks in my opinion. It would be more straight-forward
> if we could structure the logic as:
>
>
> 	if (fault_granule < vma_pagesize) {
>
> 	} else if (fault_granule > vma_page_size) {
>
> 	} else {
>
> 	}
>
> With some comments describing what we can infer about the memcache and cache
> maintenance requirements for each case.
Thanks for your suggestion here, Will.
But I have resent another newer series [1] (KVM: arm64: Improve 
efficiency of stage2 page table)
recently, which has the same theme but different solutions that I think 
are better.
[1] 
https://lore.kernel.org/lkml/20210208112250.163568-1-wangyanan55@huawei.com/

Could you please comment on that series ?  I think it can be found in 
your inbox :).

Thanks,

Yanan
>
> Will
> .
