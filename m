Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAC44C200
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 14:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhKJNWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 08:22:18 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14734 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhKJNWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 08:22:15 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hq53p6jBXzZcxW;
        Wed, 10 Nov 2021 21:17:10 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:19:25 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:19:23 +0800
Subject: Re: [PATCH v2 2/5] KVM: arm64: Get rid of host SVE tracking/saving
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, <broonie@kernel.org>,
        <kernel-team@android.com>
References: <20211028111640.3663631-1-maz@kernel.org>
 <20211028111640.3663631-3-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5ab3836f-2b39-2ff5-3286-8258addd01e4@huawei.com>
Date:   Wed, 10 Nov 2021 21:19:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20211028111640.3663631-3-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2021/10/28 19:16, Marc Zyngier wrote:
> The SVE host tracking in KVM is pretty involved. It relies on a
> set of flags tracking the ownership of the SVE register, as well
> as that of the EL0 access.
> 
> It is also pretty scary: __hyp_sve_save_host() computes
> a thread_struct pointer and obtains a sve_state which gets directly
> accessed without further ado, even on nVHE. How can this even work?
> 
> The answer to that is that it doesn't, and that this is mostly dead
> code. Closer examination shows that on executing a syscall, userspace
> loses its SVE state entirely. This is part of the ABI. Another
> thing to notice is that although the kernel provides helpers such as
> kernel_neon_begin()/end(), they only deal with the FP/NEON state,
> and not SVE.
> 
> Given that you can only execute a guest as the result of a syscall,
> and that the kernel cannot use SVE by itself, it becomes pretty
> obvious that there is never any host SVE state to save, and that
> this code is only there to increase confusion.
> 
> Get rid of the TIF_SVE tracking and host save infrastructure altogether.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 5621020b28de..38ca332c10fe 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -73,15 +73,11 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
>  {
>  	BUG_ON(!current->mm);
> +	BUG_ON(test_thread_flag(TIF_SVE));
>  
> -	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
> -			      KVM_ARM64_HOST_SVE_IN_USE |
> -			      KVM_ARM64_HOST_SVE_ENABLED);
> +	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
>  	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
>  
> -	if (test_thread_flag(TIF_SVE))
> -		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;

The comment about TIF_SVE on top of kvm_arch_vcpu_load_fp() becomes
obsolete now. Maybe worth removing it?

| *
| * TIF_SVE is backed up here, since it may get clobbered with guest state.
| * This flag is restored by kvm_arch_vcpu_put_fp(vcpu).

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index a0e78a6027be..722dfde7f1aa 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -207,16 +207,6 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
>  	return __get_fault_info(esr, &vcpu->arch.fault);
>  }
>  
> -static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
> -{
> -	struct thread_struct *thread;
> -
> -	thread = container_of(vcpu->arch.host_fpsimd_state, struct thread_struct,
> -			      uw.fpsimd_state);
> -
> -	__sve_save_state(sve_pffr(thread), &vcpu->arch.host_fpsimd_state->fpsr);
> -}

Nit: This removes the only user of __sve_save_state() helper. Should we
still keep it in fpsimd.S?

Thanks,
Zenghui
