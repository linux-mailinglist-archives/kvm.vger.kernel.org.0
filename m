Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277F438AF59
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 14:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbhETM6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 08:58:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3627 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237405AbhETM5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 08:57:15 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fm8ms1KGbzmXlB;
        Thu, 20 May 2021 20:53:33 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 20:55:49 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 20:55:49 +0800
Subject: Re: [PATCH v4 09/66] KVM: arm64: nv: Support virtual EL2 exceptions
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <kernel-team@android.com>, Andre Przywara <andre.przywara@arm.com>,
        <christoffer.dall@arm.com>, <jintack@cs.columbia.edu>,
        <haibo.xu@linaro.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        <jintack.lim@linaro.org>
References: <20210510165920.1913477-1-maz@kernel.org>
 <20210510165920.1913477-10-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c573a93e-58ac-ae1e-2b84-9bc148d40e2f@huawei.com>
Date:   Thu, 20 May 2021 20:55:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210510165920.1913477-10-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/11 0:58, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Support injecting exceptions and performing exception returns to and
> from virtual EL2.  This must be done entirely in software except when
> taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
> == {1,1}  (a VHE guest hypervisor).
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: switch to common exception injection framework]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h     |  17 +++
>  arch/arm64/include/asm/kvm_emulate.h |  10 ++
>  arch/arm64/kvm/Makefile              |   2 +-
>  arch/arm64/kvm/emulate-nested.c      | 176 +++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/exception.c       |  45 +++++--
>  arch/arm64/kvm/inject_fault.c        |  63 ++++++++--
>  arch/arm64/kvm/trace_arm.h           |  59 +++++++++
>  7 files changed, 354 insertions(+), 18 deletions(-)
>  create mode 100644 arch/arm64/kvm/emulate-nested.c

[...]

>  static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
>  {
>  	unsigned long cpsr = *vcpu_cpsr(vcpu);
>  	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
>  	u32 esr = 0;
>  
> -	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
> -			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> -			     KVM_ARM64_PENDING_EXCEPTION);
> -
> -	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +	pend_sync_exception(vcpu);
>  
>  	/*
>  	 * Build an {i,d}abort, depending on the level and the
> @@ -45,16 +79,22 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>  	if (!is_iabt)
>  		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
>  
> -	vcpu_write_sys_reg(vcpu, esr | ESR_ELx_FSC_EXTABT, ESR_EL1);
> +	esr |= ESR_ELx_FSC_EXTABT;
> +
> +	if (vcpu->arch.flags & KVM_ARM64_EXCEPT_AA64_EL1) {

This isn't the right way to pick between EL1 and EL2 since
KVM_ARM64_EXCEPT_AA64_EL1 is (0 << 11), we will not be able
to inject abort to EL1 that way.

> +		vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	} else {
> +		vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);
> +	}
>  }
>  
>  static void inject_undef64(struct kvm_vcpu *vcpu)
>  {
>  	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
>  
> -	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
> -			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
> -			     KVM_ARM64_PENDING_EXCEPTION);
> +	pend_sync_exception(vcpu);
>  
>  	/*
>  	 * Build an unknown exception, depending on the instruction
> @@ -63,7 +103,10 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  	if (kvm_vcpu_trap_il_is32bit(vcpu))
>  		esr |= ESR_ELx_IL;
>  
> -	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	if (vcpu->arch.flags & KVM_ARM64_EXCEPT_AA64_EL1)
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +	else
> +		vcpu_write_sys_reg(vcpu, esr, ESR_EL2);

Same here.

Thanks,
Zenghui
