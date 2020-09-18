Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF5E26F935
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 11:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIRJZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 05:25:55 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3519 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbgIRJZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 05:25:54 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 31595E1EE9293CD5A916;
        Fri, 18 Sep 2020 17:25:53 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:25:52 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:25:52 +0800
Subject: Re: [RFC v2 4/7] kvm: arm64: introduce check_user
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <maz@kernel.org>, <will@kernel.org>,
        <zhang.zhanghailiang@huawei.com>, <xiexiangyou@huawei.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-5-liangpeng10@huawei.com>
 <20200918074135.67ahnd6rlh7db3is@kamzik.brq.redhat.com>
From:   Peng Liang <liangpeng10@huawei.com>
Message-ID: <20569744-7467-456f-3027-64d71d7c0b0c@huawei.com>
Date:   Fri, 18 Sep 2020 17:25:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918074135.67ahnd6rlh7db3is@kamzik.brq.redhat.com>
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

On 9/18/2020 3:41 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:00:58PM +0800, Peng Liang wrote:
>> Currently, if we need to check the value of the register defined by user
>> space, we should check it in set_user.  However, some system registers
>> may use the same set_user (for example, almost all ID registers), which
>> make it difficult to validate the value defined by user space.
> 
> If sharing set_user no longer makes sense for ID registers, then we need
> to rework the code so it's no longer shared. As I keep saying, we need
> to address this problem one ID register at a time. So, IMO, the approach
> should be to change one ID register at a time from using ID_SANITISED()
> to having its own table entry with its own set/get_user code. There may
> still be opportunity to share code among the ID registers, in which case
> refactoring can be done as needed too.
> 
> Thanks,
> drew
> 

Thank you for your advise.  Currently, the implementation is a little dirty.
Removing the shared set_user of ID registers should make it clean.  I will
refactor the code to make it in next version.

Thanks,
Peng

>>
>> Introduce check_user to solve the problem.  And apply check_user before
>> set_user to make sure that the value of register is valid.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 7 +++++++
>>  arch/arm64/kvm/sys_regs.h | 6 ++++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 2b0fa8d5ac62..86ebb8093c3c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2684,6 +2684,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>>  {
>>  	const struct sys_reg_desc *r;
>>  	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
>> +	int err;
>>  
>>  	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>>  		return demux_c15_set(reg->id, uaddr);
>> @@ -2699,6 +2700,12 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>>  	if (sysreg_hidden_from_user(vcpu, r))
>>  		return -ENOENT;
>>  
>> +	if (r->check_user) {
>> +		err = (r->check_user)(vcpu, r, reg, uaddr);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>>  	if (r->set_user)
>>  		return (r->set_user)(vcpu, r, reg, uaddr);
>>  
>> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
>> index 5a6fc30f5989..9bce5e9a3490 100644
>> --- a/arch/arm64/kvm/sys_regs.h
>> +++ b/arch/arm64/kvm/sys_regs.h
>> @@ -53,6 +53,12 @@ struct sys_reg_desc {
>>  			const struct kvm_one_reg *reg, void __user *uaddr);
>>  	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>>  			const struct kvm_one_reg *reg, void __user *uaddr);
>> +	/*
>> +	 * Check the value userspace passed.  It should return 0 on success and
>> +	 * otherwise on failure.
>> +	 */
>> +	int (*check_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>> +			  const struct kvm_one_reg *reg, void __user *uaddr);
>>  
>>  	/* Return mask of REG_* runtime visibility overrides */
>>  	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
>> -- 
>> 2.26.2
>>
> 
> .
> 
