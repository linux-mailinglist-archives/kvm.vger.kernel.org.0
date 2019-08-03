Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78B218058C
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 11:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbfHCJ36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 05:29:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4161 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388126AbfHCJ35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 05:29:57 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 85F24A8D23FCA1D8907A;
        Sat,  3 Aug 2019 17:29:55 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sat, 3 Aug 2019
 17:29:44 +0800
Subject: Re: kvm-unit-tests: psci_cpu_on_test FAILed
To:     Marc Zyngier <maz@kernel.org>, <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        <julien.thierry.kdev@gmail.com>, <suzuki.poulose@arm.com>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <3ddf8766-6f02-b655-1b80-d8a7fd016509@huawei.com>
 <48a18685-ee81-83a7-9eea-63fe26690903@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f58de1d7-a6ca-bd6d-8423-01d27326e078@huawei.com>
Date:   Sat, 3 Aug 2019 17:27:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <48a18685-ee81-83a7-9eea-63fe26690903@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2019/8/2 23:56, Marc Zyngier wrote:
> On 02/08/2019 11:56, Zenghui Yu wrote:
>> Hi folks,
>>
>> Running kvm-unit-tests with Linux 5.3.0-rc2 on Kunpeng 920, we will get
>> the following fail info:
>>
>> 	[...]
>> 	FAIL psci (4 tests, 1 unexpected failures)
>> 	[...]
>> and
>> 	[...]
>> 	INFO: unexpected cpu_on return value: caller=CPU9, ret=-2
>> 	FAIL: cpu-on
>> 	SUMMARY: 4 tests, 1 unexpected failures
>>
>>
>> I think this is an issue had been fixed once by commit 6c7a5dce22b3
>> ("KVM: arm/arm64: fix races in kvm_psci_vcpu_on"), which makes use of
>> kvm->lock mutex to fix the race between two PSCI_CPU_ON calls - one
>> does reset on the MPIDR register whilst another reads it.
>>
>> But commit 358b28f09f0 ("arm/arm64: KVM: Allow a VCPU to fully reset
>> itself") later moves the reset work into check_vcpu_requests(), by
>> making a KVM_REQ_VCPU_RESET request in PSCI code. Thus the reset work
>> has not been protected by kvm->lock mutex anymore, and the race shows up
>> again...
>>
>> Do we need a fix for this issue? At least achieve a mutex execution
>> between the reset of MPIDR and kvm_mpidr_to_vcpu()?
> 
> The thing is that the way we reset registers is marginally insane.
> Yes, it catches most reset bugs. It also introduces many more in
> the rest of the paths.
> 
> The fun part is that there is hardly a need for resetting MPIDR.
> It has already been set when we've created the vcpu. It is the

(That means we can let reset_mpidr() do nothing?)

> poisoning of the sysreg array that creates a situation where
> the MPIDR is temporarily invalid.
> 
> So instead of poisoning the array, how about we just keep
> track of the registers for which we've called a reset function?
> It should be enough to track the most obvious bugs... I've

The reset of DBG{BCR,BVR,WVR,WCR}n_EL1 registers will also be tracked.
It may affect our judgment?

> cobbled the following patch together, which seems to fix the
> issue on my TX2 with 64 vcpus.
> 
> Thoughts?
> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f26e181d881c..17f46ee7dc83 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2254,13 +2254,17 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
>   }
>   
>   static void reset_sys_reg_descs(struct kvm_vcpu *vcpu,
> -			      const struct sys_reg_desc *table, size_t num)
> +				const struct sys_reg_desc *table, size_t num,
> +				unsigned long *bmap)
>   {
>   	unsigned long i;
>   
>   	for (i = 0; i < num; i++)
> -		if (table[i].reset)
> +		if (table[i].reset) {
>   			table[i].reset(vcpu, &table[i]);
> +			if (bmap)
> +				set_bit(i, bmap);

I think this should be:
	set_bit(table[i].reg, bmap);

Am I wrong?

> +		}
>   }
>   
>   /**
> @@ -2772,21 +2776,23 @@ void kvm_sys_reg_table_init(void)
>    */
>   void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>   {
> +	unsigned long *bmap;
>   	size_t num;
>   	const struct sys_reg_desc *table;
>   
> -	/* Catch someone adding a register without putting in reset entry. */
> -	memset(&vcpu->arch.ctxt.sys_regs, 0x42, sizeof(vcpu->arch.ctxt.sys_regs));
> +	bmap = bitmap_alloc(NR_SYS_REGS, GFP_KERNEL);

LOCKDEP kernel will be not happy with this bitmap_alloc:

" BUG: sleeping function called from invalid context at mm/slab.h:501
   in_atomic(): 1, irqs_disabled(): 0, pid: 8710, name: qemu-system-aar "

>   
>   	/* Generic chip reset first (so target could override). */
> -	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
> +	reset_sys_reg_descs(vcpu, sys_reg_descs, ARRAY_SIZE(sys_reg_descs), bmap);
>   
>   	table = get_target_table(vcpu->arch.target, true, &num);
> -	reset_sys_reg_descs(vcpu, table, num);
> +	reset_sys_reg_descs(vcpu, table, num, bmap);
>   
>   	for (num = 1; num < NR_SYS_REGS; num++) {
> -		if (WARN(__vcpu_sys_reg(vcpu, num) == 0x4242424242424242,
> +		if (WARN(bmap && !test_bit(num, bmap),
>   			 "Didn't reset __vcpu_sys_reg(%zi)\n", num))
>   			break;
>   	}
> +
> +	kfree(bmap);
>   }
> 
> 

Some other minor questions about the sys reg resetting:
1. Pointer Authentication Registers haven't have reset entry yet,
    do they need? The same for ACTLR_EL1.
2. Why does PMCR_EL0 register have no "reg" field, in sys_reg_descs[]?

I will test this patch with kvm-unit-tests next week!


Thanks,
zenghui

