Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FF53AACB2
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 08:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhFQGul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 02:50:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4824 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhFQGul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 02:50:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5CDx0683zXgkX;
        Thu, 17 Jun 2021 14:43:29 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 14:48:31 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 14:48:30 +0800
Subject: Re: [PATCH v6 1/4] KVM: arm64: Introduce cache maintenance callbacks
 for guest stage-2
To:     Marc Zyngier <maz@kernel.org>
CC:     Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>
References: <20210616095200.38008-1-wangyanan55@huawei.com>
 <20210616095200.38008-2-wangyanan55@huawei.com>
 <87eed2lzcc.wl-maz@kernel.org>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <8340be12-cc80-8c2a-3597-ecba05eaf35a@huawei.com>
Date:   Thu, 17 Jun 2021 14:48:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87eed2lzcc.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/6/16 21:21, Marc Zyngier wrote:
> Hi Yanan,
>
> On Wed, 16 Jun 2021 10:51:57 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> To prepare for performing guest CMOs in the fault handlers in pgtable.c,
>> introduce two cache maintenance callbacks in struct kvm_pgtable_mm_ops.
>>
>> The new callbacks are specific for guest stage-2, so they will only be
>> initialized in 'struct kvm_pgtable_mm_ops kvm_s2_mm_ops'.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_pgtable.h | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> index c3674c47d48c..302eca32e0af 100644
>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> @@ -44,6 +44,11 @@ typedef u64 kvm_pte_t;
>>    *			in the current context.
>>    * @virt_to_phys:	Convert a virtual address mapped in the current context
>>    *			into a physical address.
>> + * @flush_dcache:	Clean data cache for a guest page address range before
>> + *			creating the corresponding stage-2 mapping.
> Please don't reintroduce the word 'flush'. We are really trying to
> move away from it as it doesn't describe what we want to do.
I agree with this. I intended to make the names short and laconic, but this
missed the information about the callback's actual behaviors.
> Here this
> should be 'clean_invalidate_dcache' which, despite being a mouthful,
> describe accurately what we expect it to do.
Sure, I will change the name as you suggested.
> The comment is also missing the invalidate part, and we shouldn't
> assume that this is only used for S2 mapping.
Ok, will refine the comment. I think something like"Clean and invalidate the
date cache for the specified memory address range" may be generic enough.
>> + * @flush_icache:	Invalidate instruction cache for a guest page address
>> + *			range before creating or updating the corresponding
>> + *			stage-2 mapping.
> Same thing here; this should be 'invalidate_icache', and the comment
> cleaned up.
Thanks, I will also correct this part.

Besides the callback names and comments, is there anything else that still
needs some adjustment in the other three patches? :)

Regards,
Yanan
.
>>    */
>>   struct kvm_pgtable_mm_ops {
>>   	void*		(*zalloc_page)(void *arg);
>> @@ -54,6 +59,8 @@ struct kvm_pgtable_mm_ops {
>>   	int		(*page_count)(void *addr);
>>   	void*		(*phys_to_virt)(phys_addr_t phys);
>>   	phys_addr_t	(*virt_to_phys)(void *addr);
>> +	void		(*flush_dcache)(void *addr, size_t size);
>> +	void		(*flush_icache)(void *addr, size_t size);
>>   };
>>   
>>   /**
> Thanks,
>
> 	M.
>

