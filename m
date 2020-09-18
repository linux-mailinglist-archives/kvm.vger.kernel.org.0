Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169EF26F93D
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 11:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgIRJ0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 05:26:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3521 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbgIRJ0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 05:26:42 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 7F36C44C79EC4DF2539F;
        Fri, 18 Sep 2020 17:26:40 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:26:38 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:26:38 +0800
Subject: Re: [RFC v2 6/7] kvm: arm64: make ID registers configurable
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <maz@kernel.org>, <will@kernel.org>,
        <zhang.zhanghailiang@huawei.com>, <xiexiangyou@huawei.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-7-liangpeng10@huawei.com>
 <20200918075039.36eezfwbsiearq3h@kamzik.brq.redhat.com>
From:   Peng Liang <liangpeng10@huawei.com>
Message-ID: <96d2155f-6ba8-6eee-8eff-354c026232f3@huawei.com>
Date:   Fri, 18 Sep 2020 17:26:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918075039.36eezfwbsiearq3h@kamzik.brq.redhat.com>
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

On 9/18/2020 3:50 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:01:00PM +0800, Peng Liang wrote:
>> It's time to make ID registers configurable.  When userspace (but not
>> guest) want to set the values of ID registers, save the value in
>> sysreg file so that guest can read the modified values.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 16 +++++++++-------
>>  1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index a642ecfebe0a..881b66494524 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1263,10 +1263,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>>  
>>  /*
>>   * cpufeature ID register user accessors
>> - *
>> - * For now, these registers are immutable for userspace, so no values
>> - * are stored, and for set_id_reg() we don't allow the effective value
>> - * to be changed.
>>   */
>>  static int __get_id_reg(struct kvm_vcpu *vcpu,
>>  			const struct sys_reg_desc *rd, void __user *uaddr,
>> @@ -1290,9 +1286,15 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>>  	if (err)
>>  		return err;
>>  
>> -	/* This is what we mean by invariant: you can't change it. */
>> -	if (val != read_id_reg(vcpu, rd, raz))
>> -		return -EINVAL;
>> +	if (raz) {
>> +		if (val != read_id_reg(vcpu, rd, raz))
> 
> val != 0 ?

Thanks for you advise.  It will make it much clearer.  I'll change it in next
version.

Thanks,
Peng

> 
>> +			return -EINVAL;
>> +	} else {
>> +		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
>> +				     (u32)rd->CRm, (u32)rd->Op2);
>> +		/* val should be checked in check_user */
> 
> It really doesn't make sense to share this trivial set_user function and
> have different check functions. Just don't share the set_user function.
> 
>> +		__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
>> +	}
>>  
>>  	return 0;
>>  }
>> -- 
>> 2.26.2
>>
> 
> Thanks,
> drew
> 
> .
>
