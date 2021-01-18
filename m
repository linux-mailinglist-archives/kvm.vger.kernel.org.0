Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146392F974D
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 02:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbhARBTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 20:19:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11032 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729570AbhARBTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 20:19:44 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DJv6X6JWVzj3w7;
        Mon, 18 Jan 2021 09:17:56 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 09:18:52 +0800
Subject: Re: [PATCH] kvm: arm64: Properly align the end address of table walk
To:     Will Deacon <will@kernel.org>
References: <20210115095307.12912-1-zhukeqian1@huawei.com>
 <20210115102334.GA14167@willie-the-truck>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <a184c21f-2b1f-bd00-5ca9-be7649b33ccd@huawei.com>
Date:   Mon, 18 Jan 2021 09:18:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115102334.GA14167@willie-the-truck>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/15 18:23, Will Deacon wrote:
> On Fri, Jan 15, 2021 at 05:53:07PM +0800, Keqian Zhu wrote:
>> When align the end address, ought to use its original value.
>>
>> Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker infrastructure")
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index bdf8e55ed308..670b0ef12440 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -296,7 +296,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>  	struct kvm_pgtable_walk_data walk_data = {
>>  		.pgt	= pgt,
>>  		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
>> -		.end	= PAGE_ALIGN(walk_data.addr + size),
>> +		.end	= PAGE_ALIGN(addr + size),
>>  		.walker	= walker,
> 
> Hmm, this is a change in behaviour, no (consider the case where both 'addr'
> and 'size' are misaligned)? The current code is consistent with the
> kerneldoc in asm/kvm_pgtable.h, so I don't see the motivation to change it.
> 
> Did you hit a bug somewhere?
> 
> Will
> .
>
Not hit a bug, I just read the code to implement a new idea of stage2 DBM
support [1]. Yes, according to doc, this is not an issue ("The offset of
@addr within a page is ignored."). Sorry to disturb ;-).

[1] https://lore.kernel.org/kvmarm/fd26654b-8258-061c-2a69-90b961c1c71b@huawei.com/

Thanks,
Keqian





