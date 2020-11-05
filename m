Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B022A8A0C
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 23:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgKEWot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 17:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKEWot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 17:44:49 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D44D920782;
        Thu,  5 Nov 2020 22:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604616288;
        bh=/Kd2xNCOmDzNtR70KzNcw4Z8JWC+xMw9qKRE7OK3bac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2LiuAR18Ux0P973OaySkVkPpt3P6fwmSgZgTiPjIGvxuIjR/aMjDBUycHHzgJQ4l
         fJkliNgpB1nPep4i9w/sV05yfNT9fK8E0BSbiMIkuv8OcRsI9JA7Xm02nHquIQX2Ns
         2P9jpMfDFBlkSHL1Dl9cuzF1cDPhALpC+Y7VSkaA=
Date:   Thu, 5 Nov 2020 22:44:43 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Peng Liang <liangpeng10@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 1/3] KVM: arm64: Allow setting of ID_AA64PFR0_EL1.CSV2
 from userspace
Message-ID: <20201105224442.GD8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103171445.271195-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 05:14:43PM +0000, Marc Zyngier wrote:
> We now expose ID_AA64PFR0_EL1.CSV2=1 to guests running on hosts
> that are immune to Spectre-v2, but that don't have this field set,
> most likely because they predate the specification.
> 
> However, this prevents the migration of guests that have started on
> a host the doesn't fake this CSV2 setting to one that does, as KVM
> rejects the write to ID_AA64PFR0_EL2 on the grounds that it isn't
> what is already there.
> 
> In order to fix this, allow userspace to set this field as long as
> this doesn't result in a promising more than what is already there
> (setting CSV2 to 0 is acceptable, but setting it to 1 when it is
> already set to 0 isn't).
> 
> Fixes: e1026237f9067 ("KVM: arm64: Set CSV2 for guests on hardware unaffected by Spectre-v2")
> Reported-by: Peng Liang <liangpeng10@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/arm.c              | 16 +++++++++++++
>  arch/arm64/kvm/sys_regs.c         | 38 +++++++++++++++++++++++++++----
>  3 files changed, 52 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 781d029b8aa8..0cd9f0f75c13 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -118,6 +118,8 @@ struct kvm_arch {
>  	 */
>  	unsigned long *pmu_filter;
>  	unsigned int pmuver;
> +
> +	u8 pfr0_csv2;
>  };
>  
>  struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 5750ec34960e..c0ffb019ca8b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -102,6 +102,20 @@ static int kvm_arm_default_max_vcpus(void)
>  	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>  }
>  
> +static void set_default_csv2(struct kvm *kvm)
> +{
> +	/*
> +	 * The default is to expose CSV2 == 1 if the HW isn't affected.
> +	 * Although this is a per-CPU feature, we make it global because
> +	 * asymmetric systems are just a nuisance.
> +	 *
> +	 * Userspace can override this as long as it doesn't promise
> +	 * the impossible.
> +	 */
> +	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> +		kvm->arch.pfr0_csv2 = 1;
> +}
> +
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
>   * @kvm:	pointer to the KVM struct
> @@ -127,6 +141,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	/* The maximum number of VCPUs is limited by the host's GIC model */
>  	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>  
> +	set_default_csv2(kvm);
> +
>  	return ret;
>  out_free_stage2_pgd:
>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index fb12d3ef423a..61789027b92b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1128,9 +1128,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		if (!vcpu_has_sve(vcpu))
>  			val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
>  		val &= ~(0xfUL << ID_AA64PFR0_AMU_SHIFT);
> -		if (!(val & (0xfUL << ID_AA64PFR0_CSV2_SHIFT)) &&
> -		    arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> -			val |= (1UL << ID_AA64PFR0_CSV2_SHIFT);
> +		val &= ~(0xfUL << ID_AA64PFR0_CSV2_SHIFT);
> +		val |= ((u64)vcpu->kvm->arch.pfr0_csv2 << ID_AA64PFR0_CSV2_SHIFT);
>  	} else if (id == SYS_ID_AA64PFR1_EL1) {
>  		val &= ~(0xfUL << ID_AA64PFR1_MTE_SHIFT);
>  	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> @@ -1260,6 +1259,36 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +			       const struct sys_reg_desc *rd,
> +			       const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	const u64 id = sys_reg_to_index(rd);
> +	int err;
> +	u64 val;
> +	u8 csv2;
> +
> +	err = reg_from_user(&val, uaddr, id);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> +	 * it doesn't promise more than what is actually provided (the
> +	 * guest could otherwise be covered in ectoplasmic residue).
> +	 */
> +	csv2 = FIELD_GET(0xfUL << ID_AA64PFR0_CSV2_SHIFT, val);

cpuid_feature_extract_unsigned_field() instead?

> +	if (csv2 > vcpu->kvm->arch.pfr0_csv2)
> +		return -EINVAL;
> +	vcpu->kvm->arch.pfr0_csv2 = csv2;
> +
> +	/* This is what we mean by invariant: you can't change it. */
> +	if (val != read_id_reg(vcpu, rd, false))
> +		return -EINVAL;

I think it's quite confusing to return -EINVAL in the case that we have
actually updated arch.pfr0_csv2, as it's indistinguishable from the case
when csv2 was invalid and the field wasn't updated.

Will
