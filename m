Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1242CE8B0
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 08:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgLDHgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 02:36:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9010 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgLDHgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 02:36:39 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CnPcx6ktLzhmMj;
        Fri,  4 Dec 2020 15:35:29 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Dec 2020 15:35:50 +0800
Subject: Re: [PATCH v2 1/2] clocksource: arm_arch_timer: Use stable count
 reader in erratum sne
To:     Marc Zyngier <maz@kernel.org>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
 <20200818032814.15968-2-zhukeqian1@huawei.com>
 <c8e0506a7976deef0427a30b0d10e35b@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>
From:   zhukeqian <zhukeqian1@huawei.com>
Message-ID: <e83c5aa4-3d1a-7647-dea6-4713606bacf8@huawei.com>
Date:   Fri, 4 Dec 2020 15:35:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <c8e0506a7976deef0427a30b0d10e35b@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/12/3 22:58, Marc Zyngier wrote:
> On 2020-08-18 04:28, Keqian Zhu wrote:
>> In commit 0ea415390cd3 ("clocksource/arm_arch_timer: Use arch_timer_read_counter
>> to access stable counters"), we separate stable and normal count reader to omit
>> unnecessary overhead on systems that have no timer erratum.
>>
>> However, in erratum_set_next_event_tval_generic(), count reader becomes normal
>> reader. This converts it to stable reader.
>>
>> Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use
>>        arch_timer_read_counter to access stable counters")
> 
> On a single line.
Addressed. Thanks.

> 
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/clocksource/arm_arch_timer.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/clocksource/arm_arch_timer.c
>> b/drivers/clocksource/arm_arch_timer.c
>> index 6c3e841..777d38c 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -396,10 +396,10 @@ static void
>> erratum_set_next_event_tval_generic(const int access, unsigned long
>>      ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
>>
>>      if (access == ARCH_TIMER_PHYS_ACCESS) {
>> -        cval = evt + arch_counter_get_cntpct();
>> +        cval = evt + arch_counter_get_cntpct_stable();
>>          write_sysreg(cval, cntp_cval_el0);
>>      } else {
>> -        cval = evt + arch_counter_get_cntvct();
>> +        cval = evt + arch_counter_get_cntvct_stable();
>>          write_sysreg(cval, cntv_cval_el0);
>>      }
> 
> With that fixed:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>
> 
> This should go via the clocksource tree.
Added Cc to it's maintainers, thanks.

> 
> Thanks,
> 
>         M.
Cheers,
Keqian
