Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DF826F92D
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 11:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIRJZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 05:25:15 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:57382 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbgIRJZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 05:25:15 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 09048F025AF68B3D2055;
        Fri, 18 Sep 2020 17:25:12 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:25:11 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:25:11 +0800
Subject: Re: [RFC v2 2/7] arm64: introduce check_features
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <maz@kernel.org>, <will@kernel.org>,
        <zhang.zhanghailiang@huawei.com>, <xiexiangyou@huawei.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-3-liangpeng10@huawei.com>
 <20200918073059.izmscvrtbnsbgnlj@kamzik.brq.redhat.com>
From:   Peng Liang <liangpeng10@huawei.com>
Message-ID: <bc37052f-3719-ac71-ed86-0427e7fdecf2@huawei.com>
Date:   Fri, 18 Sep 2020 17:25:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918073059.izmscvrtbnsbgnlj@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/18/2020 3:30 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:00:56PM +0800, Peng Liang wrote:
>> To emulate ID registers, we need to validate the value of the register
>> defined by user space.  For most ID registers, we need to check whether
>> each field defined by user space is no more than that of host (whether
>> host support the corresponding features) and whether the fields are
>> supposed to be exposed to guest.  Introduce check_features to do those
>> jobs.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/include/asm/cpufeature.h |  2 ++
>>  arch/arm64/kernel/cpufeature.c      | 23 +++++++++++++++++++++++
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 2ba7c4f11d8a..954adc5ca72f 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -579,6 +579,8 @@ void check_local_cpu_capabilities(void);
>>  
>>  u64 read_sanitised_ftr_reg(u32 id);
>>  
>> +int check_features(u32 sys_reg, u64 val);
>> +
>>  static inline bool cpu_supports_mixed_endian_el0(void)
>>  {
>>  	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 698b32705544..e58926992a70 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2850,3 +2850,26 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>>  
>>  	return sprintf(buf, "Vulnerable\n");
>>  }
>> +
>> +int check_features(u32 sys_reg, u64 val)
>> +{
>> +	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
>> +	const struct arm64_ftr_bits *ftrp;
>> +	u64 exposed_mask = 0;
>> +
>> +	if (!reg)
>> +		return -ENOENT;
>> +
>> +	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
>> +		if (arm64_ftr_value(ftrp, reg->sys_val) <
>> +		    arm64_ftr_value(ftrp, val)) {
>> +			return -EINVAL;
> 
> This assumes that 0b1111 is invalid if the host has e.g. 0b0001,
> but, IIRC, there are some ID registers where 0b1111 means the
> feature is disabled.

I think arm64_ftr_value will handle it correctly.  If the value of
the field is 0b1111 and the field is signed, arm64_ftr_value will
return -1.

> 
>> +		}
>> +		exposed_mask |= arm64_ftr_mask(ftrp);
>> +	}
>> +
>> +	if (val & ~exposed_mask)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> -- 
>> 2.26.2
>>
> 
> I don't think we should be trying to do the verification at the ftr_bits
> level, at least not generally. Trying to handle all ID registers the
> same way is bound to fail, for the 0b1111 vs. 0b0000 reason pointed
> out above, and probably other reasons. As I stated before, we should be
> validating each feature of each ID register on a case by case basis,
> and we should be using higher level CPU feature checking APIs to get
> that right.
> 
> Also, what about validating that all VCPUs have consistent features
> exposed? Each VCPU could select a valid feature mask by this check,
> but different ones, which will obviously create a completely broken
> guest.
> 
> Thanks,
> drew
> 
> .
> 
Thank you for pointing this.  I haven't thought about it yet...

Thanks,
Peng
