Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E1C26FBE6
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 13:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIRL6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 07:58:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3611 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbgIRL6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 07:58:47 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id D749BC943E32EEFBD62F;
        Fri, 18 Sep 2020 19:58:44 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 19:58:44 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 19:58:44 +0800
Subject: Re: [RFC v2 1/7] arm64: add a helper function to traverse
 arm64_ftr_regs
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <maz@kernel.org>, <will@kernel.org>,
        <zhang.zhanghailiang@huawei.com>, <xiexiangyou@huawei.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-2-liangpeng10@huawei.com>
 <20200918071820.e6hghta4yclio7ca@kamzik.brq.redhat.com>
 <00293b67-e9bb-3ad1-d6db-adb35bcacba6@huawei.com>
 <20200918102808.gwpk6ggy36prq7iv@kamzik.brq.redhat.com>
From:   Peng Liang <liangpeng10@huawei.com>
Message-ID: <a0960559-ff81-cb30-ffa1-4ed1cdae65e7@huawei.com>
Date:   Fri, 18 Sep 2020 19:58:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918102808.gwpk6ggy36prq7iv@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/18/2020 6:28 PM, Andrew Jones wrote:
> On Fri, Sep 18, 2020 at 05:24:27PM +0800, Peng Liang wrote:
>> On 9/18/2020 3:18 PM, Andrew Jones wrote:
>>> On Thu, Sep 17, 2020 at 08:00:55PM +0800, Peng Liang wrote:
>>>> If we want to emulate ID registers, we need to initialize ID registers
>>>> firstly.  This commit is to add a helper function to traverse
>>>> arm64_ftr_regs so that we can initialize ID registers from
>>>> arm64_ftr_regs.
>>>>
>>>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>>>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>>>> ---
>>>>  arch/arm64/include/asm/cpufeature.h |  2 ++
>>>>  arch/arm64/kernel/cpufeature.c      | 13 +++++++++++++
>>>>  2 files changed, 15 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>>> index 89b4f0142c28..2ba7c4f11d8a 100644
>>>> --- a/arch/arm64/include/asm/cpufeature.h
>>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>>> @@ -79,6 +79,8 @@ struct arm64_ftr_reg {
>>>>  
>>>>  extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
>>>>  
>>>> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp);
>>>> +
>>>>  /*
>>>>   * CPU capabilities:
>>>>   *
>>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>>> index 6424584be01e..698b32705544 100644
>>>> --- a/arch/arm64/kernel/cpufeature.c
>>>> +++ b/arch/arm64/kernel/cpufeature.c
>>>> @@ -1112,6 +1112,19 @@ u64 read_sanitised_ftr_reg(u32 id)
>>>>  	return regp->sys_val;
>>>>  }
>>>>  
>>>> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp)
>>>> +{
>>>> +	int i, ret;
>>>> +
>>>> +	for (i = 0; i <  ARRAY_SIZE(arm64_ftr_regs); i++) {
>>>> +		ret = (*op)(arm64_ftr_regs[i].sys_id,
>>>> +			    arm64_ftr_regs[i].reg->sys_val, argp);
>>>> +		if (ret < 0)
>>>> +			return ret;
>>>> +	}
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  #define read_sysreg_case(r)	\
>>>>  	case r:		return read_sysreg_s(r)
>>>>  
>>>> -- 
>>>> 2.26.2
>>>>
>>>
>>> Skimming the rest of the patches to see how this is used I only saw a
>>> single callsite. Why wouldn't we just put this simple for-loop right
>>> there at that callsite? Or, IOW, I think this traverse function should
>>> be dropped.
>>>
>>> Thanks,
>>> drew
>>>
>>> .
>>>
>>
>> arm64_ftr_regs is defined as a static array in arch/arm64/kernel/cpufeature.c,
>> which is not a virtualization-related file.  Putting this simple for-loop
>> right there will make cpufeature.c depend on kvm_host.h.  Is this a good idea?
> 
> Well, the fact that arm64_ftr_regs is static to cpufeature.c is a clue
> that your implementation is likely playing with internal arm64_ftr
> state that it shouldn't be. If there's not an accessor function that
> works for you, then you can try adding one. Providing general functions
> like this, that are effectively just an odd way of removing 'static'
> from arm64_ftr_regs, breaks the encapsulation.
> 
> Thanks,
> drew
> 
> .
> 

I found get_arm64_ftr_reg_nowarn and get_arm64_ftr_reg in cpufeature.c which will
search and return the arm64_ftr_reg* according to the sys_id.  But they are all
static.  Hence, I think cpufeature.c don't want other modules to access the
arm64_ftr_reg*.  So I add arm64_cpu_ftr_regs_traverse to traverse the
arm64_ftr_regs and pass the id and value to op instead of the arm64_ftr_reg*.

Thanks,
Peng
