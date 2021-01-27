Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12323305AFD
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbhA0MPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:15:37 -0500
Received: from foss.arm.com ([217.140.110.172]:42956 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237586AbhA0MNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 07:13:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8AE61FB;
        Wed, 27 Jan 2021 04:12:36 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5F733F68F;
        Wed, 27 Jan 2021 04:12:35 -0800 (PST)
Subject: Re: [PATCH v2 4/7] KVM: arm64: Refactor filtering of ID registers
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-5-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <40ec07fc-2f2f-742d-f656-8eefd6cc179d@arm.com>
Date:   Wed, 27 Jan 2021 12:12:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125122638.2947058-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/25/21 12:26 PM, Marc Zyngier wrote:
> Our current ID register filtering is starting to be a mess of if()
> statements, and isn't going to get any saner.
>
> Let's turn it into a switch(), which has a chance of being more
> readable, and introduce a FEATURE() macro that allows easy generation
> of feature masks.
>
> No functionnal change intended.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 51 +++++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2bea0494b81d..dda16d60197b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -9,6 +9,7 @@
>   *          Christoffer Dall <c.dall@virtualopensystems.com>
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/bsearch.h>
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
> @@ -1016,6 +1017,8 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -1024,36 +1027,38 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>  	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
>  
> -	if (id == SYS_ID_AA64PFR0_EL1) {
> +	switch (id) {
> +	case SYS_ID_AA64PFR0_EL1:
>  		if (!vcpu_has_sve(vcpu))
> -			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
> -		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
> -		val &= ~(0xfUL << ID_AA64PFR0_CSV3_SHIFT);
> -		val |= ((u64)vcpu->kvm->arch.pfr0_csv3 << ID_AA64PFR0_CSV3_SHIFT);
> -	} else if (id == SYS_ID_AA64PFR1_EL1) {
> -		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
> -	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> -		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> -	} else if (id == SYS_ID_AA64DFR0_EL1) {
> -		u64 cap = 0;
> -
> +			val &= ~FEATURE(ID_AA64PFR0_SVE);
> +		val &= ~FEATURE(ID_AA64PFR0_AMU);
> +		val &= ~FEATURE(ID_AA64PFR0_CSV2);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
> +		val &= ~FEATURE(ID_AA64PFR0_CSV3);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);

The patch ends up looking really nice (checked that the previous behaviour is
preserved). It also ends up making the code more robust because we make sure that
we only do bitwise or on the first 4 bits of pfr0_csv2 and pfr0_csv3:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

> +		break;
> +	case SYS_ID_AA64PFR1_EL1:
> +		val &= ~FEATURE(ID_AA64PFR1_MTE);
> +		break;
> +	case SYS_ID_AA64ISAR1_EL1:
> +		if (!vcpu_has_ptrauth(vcpu))
> +			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
> +				 FEATURE(ID_AA64ISAR1_API) |
> +				 FEATURE(ID_AA64ISAR1_GPA) |
> +				 FEATURE(ID_AA64ISAR1_GPI));
> +		break;
> +	case SYS_ID_AA64DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.1 */
> -		if (kvm_vcpu_has_pmu(vcpu))
> -			cap = ID_AA64DFR0_PMUVER_8_1;
> -
>  		val = cpuid_feature_cap_perfmon_field(val,
> -						ID_AA64DFR0_PMUVER_SHIFT,
> -						cap);
> -	} else if (id == SYS_ID_DFR0_EL1) {
> +						      ID_AA64DFR0_PMUVER_SHIFT,
> +						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
> +		break;
> +	case SYS_ID_DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.1 */
>  		val = cpuid_feature_cap_perfmon_field(val,
>  						      ID_DFR0_PERFMON_SHIFT,
>  						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
> +		break;
>  	}
>  
>  	return val;
