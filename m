Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0085D2C57B5
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 15:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389898AbgKZO63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 09:58:29 -0500
Received: from foss.arm.com ([217.140.110.172]:35652 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389808AbgKZO62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 09:58:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 039F031B;
        Thu, 26 Nov 2020 06:58:28 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFE503F71F;
        Thu, 26 Nov 2020 06:58:26 -0800 (PST)
Subject: Re: [PATCH 3/8] KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at
 reset time
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-4-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <27c74186-d9d6-4021-c561-54ae4475bf88@arm.com>
Date:   Thu, 26 Nov 2020 14:59:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113182602.471776-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 11/13/20 6:25 PM, Marc Zyngier wrote:
> We accept to configure a PMU when a vcpu is created, even if the
> HW (or the host) doesn't support it. This results in failures
> when attributes get set, which is a bit odd as we should have
> failed the vcpu creation the first place.
>
> Move the check to the point where we check the vcpu feature set,
> and fail early if we cannot support a PMU. This further simplifies
> the attribute handling.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 4 ++--
>  arch/arm64/kvm/reset.c    | 4 ++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index e7e3b4629864..200f2a0d8d17 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -913,7 +913,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  
>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> -	if (!kvm_arm_support_pmu_v3() || !kvm_vcpu_has_pmu(vcpu))
> +	if (!kvm_vcpu_has_pmu(vcpu))
>  		return -ENODEV;
>  
>  	if (vcpu->arch.pmu.created)
> @@ -1034,7 +1034,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  	case KVM_ARM_VCPU_PMU_V3_IRQ:
>  	case KVM_ARM_VCPU_PMU_V3_INIT:
>  	case KVM_ARM_VCPU_PMU_V3_FILTER:
> -		if (kvm_arm_support_pmu_v3() && kvm_vcpu_has_pmu(vcpu))
> +		if (kvm_vcpu_has_pmu(vcpu))
>  			return 0;
>  	}
>  
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 74ce92a4988c..3e772ea4e066 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -285,6 +285,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  			pstate = VCPU_RESET_PSTATE_EL1;
>  		}
>  
> +		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
> +			ret = -EINVAL;
> +			goto out;
> +		}

This looks correct, but right at the beginning of the function, before this
non-preemptible section, we do kvm_pmu_vcpu_reset(), which is wrong for several
reasons:

- we don't check if the feature flag is set
- we don't check if the hardware supports a PMU
- kvm_pmu_vcpu_reset() relies on __vcpu_sys_reg(vcpu, PMCR_EL0), which is set in
kvm_reset_sys_regs() below when the VCPU is initialized.

This looks to me like a separate issue, I have a patch locally to fix it by moving
kvm_pmu_vcpu_reset() after the non-preemptible section, but it's fine by me if you
want to fold a fix into this patch.

Thanks,

Alex

>  		break;
>  	}
>  
