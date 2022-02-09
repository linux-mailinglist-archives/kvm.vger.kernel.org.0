Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C22C4AF88F
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbiBIRdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbiBIRdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:33:35 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66BEBC0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:33:38 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A7A1ED1;
        Wed,  9 Feb 2022 09:33:38 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C30C93F73B;
        Wed,  9 Feb 2022 09:33:34 -0800 (PST)
Date:   Wed, 9 Feb 2022 17:33:46 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 32/64] KVM: arm64: nv: Filter out unsupported features
 from ID regs
Message-ID: <YgP6+j5D1PuvoVUi@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-33-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-33-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 28, 2022 at 12:18:40PM +0000, Marc Zyngier wrote:
> As there is a number of features that we either can't support,
> or don't want to support right away with NV, let's add some
> basic filtering so that we don't advertize silly things to the
> EL2 guest.
> 
> Whilst we are at it, advertize ARMv8.4-TTL as well as ARMv8.5-GTG.
> 
> Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |   6 ++
>  arch/arm64/kvm/nested.c             | 157 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c           |   4 +-
>  arch/arm64/kvm/sys_regs.h           |   2 +
>  4 files changed, 168 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 047ca700163b..7d398510fd9d 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -72,4 +72,10 @@ extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
>  extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
>  extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
>  
> +struct sys_reg_params;
> +struct sys_reg_desc;
> +
> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r);
> +
>  #endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 5e1104f8e765..254152cd791e 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -8,6 +8,10 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
> +#include <asm/sysreg.h>
> +
> +#include "sys_regs.h"
>  
>  /*
>   * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
> @@ -26,3 +30,156 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
>  
>  	return -EINVAL;
>  }
> +
> +/*
> + * Our emulated CPU doesn't support all the possible features. For the
> + * sake of simplicity (and probably mental sanity), wipe out a number
> + * of feature bits we don't intend to support for the time being.
> + * This list should get updated as new features get added to the NV
> + * support, and new extension to the architecture.
> + */
> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> +	u64 val, tmp;
> +
> +	if (!vcpu_has_nv(v))
> +		return;
> +
> +	val = p->regval;
> +
> +	switch (id) {
> +	case SYS_ID_AA64ISAR0_EL1:
> +		/* Support everything but O.S. and Range TLBIs */
> +		val &= ~(FEATURE(ID_AA64ISAR0_TLB)	|
> +			 GENMASK_ULL(27, 24)		|
> +			 GENMASK_ULL(3, 0));
> +		break;
> +
> +	case SYS_ID_AA64ISAR1_EL1:
> +		/* Support everything but PtrAuth and Spec Invalidation */
> +		val &= ~(GENMASK_ULL(63, 56)		|
> +			 FEATURE(ID_AA64ISAR1_SPECRES)	|
> +			 FEATURE(ID_AA64ISAR1_GPI)	|
> +			 FEATURE(ID_AA64ISAR1_GPA)	|
> +			 FEATURE(ID_AA64ISAR1_API)	|
> +			 FEATURE(ID_AA64ISAR1_APA));
> +		break;
> +
> +	case SYS_ID_AA64PFR0_EL1:
> +		/* No AMU, MPAM, S-EL2, RAS or SVE */
> +		val &= ~(GENMASK_ULL(55, 52)		|
> +			 FEATURE(ID_AA64PFR0_AMU)	|
> +			 FEATURE(ID_AA64PFR0_MPAM)	|
> +			 FEATURE(ID_AA64PFR0_SEL2)	|
> +			 FEATURE(ID_AA64PFR0_RAS)	|
> +			 FEATURE(ID_AA64PFR0_SVE)	|
> +			 FEATURE(ID_AA64PFR0_EL3)	|
> +			 FEATURE(ID_AA64PFR0_EL2));
> +		/* 64bit EL2/EL3 only */
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), 0b0001);

Since KVM doesn't support virtual EL1 running in AArch32 mode when vcpu_has_nv()
(according to kvm_check_illegal_exception_return()), would it make sense to hide
the feature here?

> +		break;
> +
> +	case SYS_ID_AA64PFR1_EL1:
> +		/* Only support SSBS */
> +		val &= FEATURE(ID_AA64PFR1_SSBS);
> +		break;
> +
> +	case SYS_ID_AA64MMFR0_EL1:
> +		/* Hide ECV, FGT, ExS, Secure Memory */
> +		val &= ~(GENMASK_ULL(63, 43)			|
> +			 FEATURE(ID_AA64MMFR0_TGRAN4_2)		|
> +			 FEATURE(ID_AA64MMFR0_TGRAN16_2)	|
> +			 FEATURE(ID_AA64MMFR0_TGRAN64_2)	|
> +			 FEATURE(ID_AA64MMFR0_SNSMEM));
> +
> +		/* Disallow unsupported S2 page sizes */
> +		switch (PAGE_SIZE) {
> +		case SZ_64K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
> +			fallthrough;
> +		case SZ_16K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
> +			fallthrough;
> +		case SZ_4K:
> +			/* Support everything */
> +			break;
> +		}
> +		/*
> +		 * Since we can't support a guest S2 page size smaller than
> +		 * the host's own page size (due to KVM only populating its
> +		 * own S2 using the kernel's page size), advertise the
> +		 * limitation using FEAT_GTG.
> +		 */
> +		switch (PAGE_SIZE) {
> +		case SZ_4K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
> +			fallthrough;
> +		case SZ_16K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0010);
> +			fallthrough;
> +		case SZ_64K:
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64_2), 0b0010);
> +			break;
> +		}
> +		/* Cap PARange to 40bits */
> +		tmp = FIELD_GET(FEATURE(ID_AA64MMFR0_PARANGE), val);
> +		if (tmp > 0b0010) {
> +			val &= ~FEATURE(ID_AA64MMFR0_PARANGE);
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), 0b0010);
> +		}
> +		break;
> +
> +	case SYS_ID_AA64MMFR1_EL1:
> +		val &= (FEATURE(ID_AA64MMFR1_PAN)	|
> +			FEATURE(ID_AA64MMFR1_LOR)	|
> +			FEATURE(ID_AA64MMFR1_HPD)	|
> +			FEATURE(ID_AA64MMFR1_VHE)	|
> +			FEATURE(ID_AA64MMFR1_VMIDBITS));
> +		break;
> +
> +	case SYS_ID_AA64MMFR2_EL1:
> +		val &= ~(FEATURE(ID_AA64MMFR2_EVT)	|
> +			 FEATURE(ID_AA64MMFR2_BBM)	|
> +			 FEATURE(ID_AA64MMFR2_TTL)	|
> +			 GENMASK_ULL(47, 44)		|
> +			 FEATURE(ID_AA64MMFR2_ST)	|
> +			 FEATURE(ID_AA64MMFR2_CCIDX)	|
> +			 FEATURE(ID_AA64MMFR2_LVA));
> +
> +		/* Force TTL support */
> +		val |= FIELD_PREP(FEATURE(ID_AA64MMFR2_TTL), 0b0001);
> +		break;
> +
> +	case SYS_ID_AA64DFR0_EL1:
> +		/* Only limited support for PMU, Debug, BPs and WPs */
> +		val &= (FEATURE(ID_AA64DFR0_PMSVER)	|
> +			FEATURE(ID_AA64DFR0_WRPS)	|
> +			FEATURE(ID_AA64DFR0_BRPS)	|
> +			FEATURE(ID_AA64DFR0_DEBUGVER));
> +
> +		/* Cap PMU to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), val);
> +		if (tmp > 0b0100) {
> +			val &= ~FEATURE(ID_AA64DFR0_PMUVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 0b0100);
> +		}
> +		/* Cap Debug to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_DEBUGVER), val);
> +		if (tmp > 0b0111) {
> +			val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 0b0111);
> +		}
> +		break;
> +
> +	default:
> +		/* Unknown register, just wipe it clean */
> +		val = 0;
> +		break;
> +	}
> +
> +	p->regval = val;
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3e1f37c507a8..ebcdf2714b73 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1394,8 +1394,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
>  			  const struct sys_reg_desc *r)
>  {
>  	bool raz = sysreg_visible_as_raz(vcpu, r);
> +	bool ret = __access_id_reg(vcpu, p, r, raz);
>  
> -	return __access_id_reg(vcpu, p, r, raz);
> +	access_nested_id_reg(vcpu, p, r);

Looks like when the guest tries to *write* to an ID reg, __access_id_reg() above
returns false. It also looks like access_nested_id_reg() assumes that the access
is a read. Shouldn't the call to access_nested_id_reg() be gated by ret == true?

Thanks,
Alex

> +	return ret;
>  }
>  
>  static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 850629f083a3..b82683224250 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -211,4 +211,6 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
>  	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
>  	Op2(sys_reg_Op2(reg))
>  
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> +
>  #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
> -- 
> 2.30.2
> 
