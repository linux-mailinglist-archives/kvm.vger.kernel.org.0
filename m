Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F691B6C6A
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 06:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgDXEIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 00:08:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2850 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgDXEIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 00:08:06 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7E6B1DEC27DDEED61367;
        Fri, 24 Apr 2020 12:08:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 12:07:52 +0800
Subject: Re: [PATCH 18/26] KVM: arm64: Don't use empty structures as CPU reset
 state
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-19-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <77963c60-bcc4-0c9e-fd35-d696827ea55c@huawei.com>
Date:   Fri, 24 Apr 2020 12:07:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-19-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/4/22 20:00, Marc Zyngier wrote:
> Keeping empty structure as the vcpu state initializer is slightly
> wasteful: we only want to set pstate, and zero everything else.
> Just do that.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/reset.c | 20 +++++++++-----------
>   1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 241db35a7ef4f..895d7d9ad1866 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -37,15 +37,11 @@ static u32 kvm_ipa_limit;
>   /*
>    * ARMv8 Reset Values
>    */
> -static const struct kvm_regs default_regs_reset = {
> -	.regs.pstate = (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT |
> -			PSR_F_BIT | PSR_D_BIT),
> -};
> +#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> +				 PSR_F_BIT | PSR_D_BIT)
>   
> -static const struct kvm_regs default_regs_reset32 = {
> -	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
> -			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> -};
> +#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
> +				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>   
>   static bool cpu_has_32bit_el1(void)
>   {
> @@ -261,6 +257,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   	const struct kvm_regs *cpu_reset;
>   	int ret = -EINVAL;
>   	bool loaded;
> +	u32 pstate;
>   
>   	/* Reset PMU outside of the non-preemptible section */
>   	kvm_pmu_vcpu_reset(vcpu);
> @@ -291,16 +288,17 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>   			if (!cpu_has_32bit_el1())
>   				goto out;
> -			cpu_reset = &default_regs_reset32;
> +			pstate = VCPU_RESET_PSTATE_SVC;
>   		} else {
> -			cpu_reset = &default_regs_reset;
> +			pstate = VCPU_RESET_PSTATE_EL1;
>   		}
>   
>   		break;
>   	}
>   
>   	/* Reset core registers */
> -	memcpy(vcpu_gp_regs(vcpu), cpu_reset, sizeof(*cpu_reset));
> +	memset(vcpu_gp_regs(vcpu), 0, sizeof(*cpu_reset));

Be careful that we can *not* use 'sizeof(*cpu_reset)' here anymore.  As
you're going to refactor the layout of the core registers whilst keeping
the kvm_regs API unchanged.  Resetting the whole kvm_regs will go
corrupting some affected registers and make them temporarily invalid.
The bad thing will show up after you start moving ELR_EL1 around,
specifically in patch #20...

And the first victim is ... MPIDR_EL1 (the first one in sys_regs array).
Now you know how this was spotted ;-)  I think this should be the root
cause of what Zengtao had previously reported [*].

If these registers are all expected to be reset to architecturally
UNKNOWN values, I think we can just drop this memset(), though haven't
check with the ARM ARM carefully.


Thanks,
Zenghui


[*] 
https://lore.kernel.org/kvmarm/f55386a9-8eaa-944f-453d-9c3c4abee5fb@arm.com/T/#mc6c7268755f5cdaff7a23c34e6e16ea36bcfbe22

> +	vcpu_gp_regs(vcpu)->regs.pstate = pstate;
>   
>   	/* Reset system registers */
>   	kvm_reset_sys_regs(vcpu);
> 

