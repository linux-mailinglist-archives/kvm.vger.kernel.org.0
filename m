Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FA239A124
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhFCMgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:36:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3412 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhFCMgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:36:51 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fwldb544qz6tsl;
        Thu,  3 Jun 2021 20:32:03 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:35:01 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 20:34:59 +0800
Subject: Re: [PATCH v5 4/6] KVM: arm64: Provide invalidate_icache_range at
 non-VHE EL2
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
References: <20210415115032.35760-1-wangyanan55@huawei.com>
 <20210415115032.35760-5-wangyanan55@huawei.com>
 <875yyw1s73.wl-maz@kernel.org>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <4169bbfc-0b63-5d2f-9ac5-27bea3e7ea46@huawei.com>
Date:   Thu, 3 Jun 2021 20:34:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <875yyw1s73.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/6/2 18:22, Marc Zyngier wrote:
> On Thu, 15 Apr 2021 12:50:30 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> We want to move I-cache maintenance for the guest to the stage-2
>> page table code for performance improvement. Before it can work,
>> we should first make function invalidate_icache_range available
>> to non-VHE EL2 to avoid compiling or program running error, as
>> pgtable.c is now linked into the non-VHE EL2 code for pKVM mode.
>>
>> In this patch, we only introduce symbol of invalidate_icache_range
>> with no real functionality in nvhe/cache.S, because there haven't
>> been situations found currently where I-cache maintenance is also
>> needed in non-VHE EL2 for pKVM mode.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/kvm/hyp/nvhe/cache.S | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
>> index 36cef6915428..a125ec9aeed2 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/cache.S
>> +++ b/arch/arm64/kvm/hyp/nvhe/cache.S
>> @@ -11,3 +11,14 @@ SYM_FUNC_START_PI(__flush_dcache_area)
>>   	dcache_by_line_op civac, sy, x0, x1, x2, x3
>>   	ret
>>   SYM_FUNC_END_PI(__flush_dcache_area)
>> +
>> +/*
>> + *	invalidate_icache_range(start,end)
>> + *
>> + *	Ensure that the I cache is invalid within specified region.
>> + *
>> + *	- start   - virtual start address of region
>> + *	- end     - virtual end address of region
>> + */
>> +SYM_FUNC_START(invalidate_icache_range)
>> +SYM_FUNC_END(invalidate_icache_range)
> This is a good indication that something is really wrong.
>
> If you were to provide cache management callbacks as part of the
> mm_ops themselves (or a similar abstraction), you wouldn't have to do
> these things.
Yes, we definitely don't need this work if we do that.

Thanks,
Yanan
>
> 	M.
>

