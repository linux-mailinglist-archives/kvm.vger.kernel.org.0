Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA155126162
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 12:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfLSL7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 06:59:12 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2109 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726668AbfLSL7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 06:59:12 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 271993F2B861E22293DF;
        Thu, 19 Dec 2019 19:59:08 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 19 Dec 2019 19:59:07 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 19
 Dec 2019 19:59:06 +0800
Subject: Re: [PATCH 2/5] KVM: arm64: Implement PV_LOCK_FEATURES call
To:     Steven Price <steven.price@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "maz@kernel.org" <maz@kernel.org>,
        James Morse <James.Morse@arm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-3-yezengruan@huawei.com>
 <20191217142848.GB38811@arm.com>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <21910175-c89a-7a14-66a9-7b53d72a4543@huawei.com>
Date:   Thu, 19 Dec 2019 19:59:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191217142848.GB38811@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Steve,

On 2019/12/17 22:28, Steven Price wrote:
> On Tue, Dec 17, 2019 at 01:55:46PM +0000, yezengruan@huawei.com wrote:
>> From: Zengruan Ye <yezengruan@huawei.com>
>>
>> This provides a mechanism for querying which paravirtualized lock
>> features are available in this hypervisor.
>>
>> Also add the header file which defines the ABI for the paravirtualized
>> lock features we're about to add.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> ---
>>  arch/arm64/include/asm/pvlock-abi.h | 16 ++++++++++++++++
>>  include/linux/arm-smccc.h           | 13 +++++++++++++
>>  virt/kvm/arm/hypercalls.c           |  3 +++
>>  3 files changed, 32 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/pvlock-abi.h
>>
>> diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
>> new file mode 100644
>> index 000000000000..06e0c3d7710a
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pvlock-abi.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
>> + * Author: Zengruan Ye <yezengruan@huawei.com>
>> + */
>> +
>> +#ifndef __ASM_PVLOCK_ABI_H
>> +#define __ASM_PVLOCK_ABI_H
>> +
>> +struct pvlock_vcpu_state {
>> +	__le64 preempted;
> 
> Somewhere we need to document when 'preempted' is. It looks like it's a
> 1-bit field from the later patches.

Good point, I'll document this in the pvlock doc.

> 
>> +	/* Structure must be 64 byte aligned, pad to that size */
>> +	u8 padding[56];
>> +} __packed;
>> +
>> +#endif
>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>> index 59494df0f55b..59e65a951959 100644
>> --- a/include/linux/arm-smccc.h
>> +++ b/include/linux/arm-smccc.h
>> @@ -377,5 +377,18 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>>  			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
>>  			   0x21)
>>  
>> +/* Paravirtualised lock calls */
>> +#define ARM_SMCCC_HV_PV_LOCK_FEATURES				\
>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
>> +			   ARM_SMCCC_SMC_64,			\
>> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
>> +			   0x40)
>> +
>> +#define ARM_SMCCC_HV_PV_LOCK_PREEMPTED				\
>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
>> +			   ARM_SMCCC_SMC_64,			\
>> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
>> +			   0x41)
>> +
>>  #endif /*__ASSEMBLY__*/
>>  #endif /*__LINUX_ARM_SMCCC_H*/
>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>> index 550dfa3e53cd..ff13871fd85a 100644
>> --- a/virt/kvm/arm/hypercalls.c
>> +++ b/virt/kvm/arm/hypercalls.c
>> @@ -52,6 +52,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>  		case ARM_SMCCC_HV_PV_TIME_FEATURES:
>>  			val = SMCCC_RET_SUCCESS;
>>  			break;
>> +		case ARM_SMCCC_HV_PV_LOCK_FEATURES:
>> +			val = SMCCC_RET_SUCCESS;
>> +			break;
> 
> Ideally you wouldn't report that PV_LOCK_FEATURES exists until the
> actual hypercalls are wired up to avoid breaking a bisect.

Thanks for pointing it out to me! I'll update the code.

> 
> Steve
> 
>>  		}
>>  		break;
>>  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
>> -- 
>> 2.19.1
>>
>>
> 
> .
> 

Thanks,

Zengruan


