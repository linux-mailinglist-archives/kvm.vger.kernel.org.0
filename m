Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E3F6E727C
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 07:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjDSE76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 00:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjDSE7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 00:59:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83587D84
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 21:59:48 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a812c6ba89so92245ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 21:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681880388; x=1684472388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4mz6cGy73AZYs8+3ljWHHCJqX3qnaxhlqUqq2wx0kTE=;
        b=eBKVq4hg3sc2KTuRuE33L13anm+vfJzg9mmAddJ7qPNWESlbnfk8e1v7/h2FONuX7D
         EqdVpMIuA6fw/Pwm2B3+U0dZb3lpzd/YYKGlUEYo6k5mZG2pIZPZidrCVvpj1vyYaMfq
         LA9agLi1DNQdAOb20v+iB36NIQf0uXLAyPyk6nHW+HO0HznruxwNBiZZPrwLovbuM6v0
         bYYruy6owmVjDLcMTINjDxLg2cMQMEo/vfQ/1DkCWyrVK6s+iPm7NsB2z8fAfitrGcXV
         ak1ungrUjWqLuNp4AlRp+103x8iiXcd04Df7OLF3f6VxaZR93yG8kUjXiCi15d87azgJ
         ZZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681880388; x=1684472388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mz6cGy73AZYs8+3ljWHHCJqX3qnaxhlqUqq2wx0kTE=;
        b=jTXH2UrkNTPPFSen6B6Tfqo137zjinVFKUge3XoeD/ZlvDxKfnbhNsakivioqVdsRA
         yew7Cy6ZcwcvKa5YvXYmObIQY/y3jR0KUxEhIjygcH+2KIct7q5Sm2eGCq+sznsKSunz
         GlNv4MtkBRuA+kGMX9tUYdiG0VaJizpfwsPgyDqIR45UeyNBHT3vHuc7wtOhh4sPjkfF
         TKyRIQfwqK4ba9048gsuoHEgdDYInr/sWTR9KIeoO9djov7VcRfB7Y2zo0R5WupjeIsj
         anCRNhHH6ny9APRTEV+ZCNYVMg+JEXMOY2JHsRhqSHWk4y9dUQEEbPmdHUKq+m9h6bVC
         7TGg==
X-Gm-Message-State: AAQBX9eofJcyBz1MmNZykNE87tgcpH4OsSLJ3nATi0djndoVYCPPzMYK
        xcy3+E4OTFVNEjmJcsHSQhkrRL1LDpuRQDpMLY28VA==
X-Google-Smtp-Source: AKy350bNBqsOjwM65A0sFB+kNPhS9g3uMDT0XwLcNjmkoB25uaKZF9rUpilpHN2SrKN4jYr8CO8VjA==
X-Received: by 2002:a17:902:e1c2:b0:1a5:2e85:94a1 with SMTP id t2-20020a170902e1c200b001a52e8594a1mr174173pla.14.1681880388150;
        Tue, 18 Apr 2023 21:59:48 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id io15-20020a17090312cf00b0019ea9e5815bsm4236098plb.45.2023.04.18.21.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:59:47 -0700 (PDT)
Date:   Tue, 18 Apr 2023 21:59:43 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v6 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
Message-ID: <20230419045943.bxt2xizlgslaoggi@google.com>
References: <20230404035344.4043856-1-jingzhangos@google.com>
 <20230404035344.4043856-7-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404035344.4043856-7-jingzhangos@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Tue, Apr 04, 2023 at 03:53:44AM +0000, Jing Zhang wrote:
> Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> introduced by ID register descriptor array.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/cpufeature.h |   1 +
>  arch/arm64/kernel/cpufeature.c      |   2 +-
>  arch/arm64/kvm/id_regs.c            | 284 ++++++++++++++++++++--------
>  3 files changed, 203 insertions(+), 84 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 6bf013fb110d..dc769c2eb7a4 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -915,6 +915,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
>  	return 8;
>  }
>  
> +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
>  struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
>  
>  extern struct arm64_ftr_override id_aa64mmfr1_override;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 2e3e55139777..677ec4fe9f6b 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -791,7 +791,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
>  	return reg;
>  }
>  
> -static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
> +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
>  				s64 cur)
>  {
>  	s64 ret = 0;
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index fe37b6786b4c..33968ada29bb 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -18,6 +18,66 @@
>  
>  #include "sys_regs.h"
>  
> +/**
> + * arm64_check_features() - Check if a feature register value constitutes
> + * a subset of features indicated by the idreg's KVM sanitised limit.
> + *
> + * This function will check if each feature field of @val is the "safe" value
> + * against idreg's KVM sanitised limit return from reset() callback.
> + * If a field value in @val is the same as the one in limit, it is always
> + * considered the safe value regardless For register fields that are not in
> + * writable, only the value in limit is considered the safe value.
> + *
> + * Return: 0 if all the fields are safe. Otherwise, return negative errno.
> + */
> +static int arm64_check_features(struct kvm_vcpu *vcpu,
> +				const struct sys_reg_desc *rd,
> +				u64 val)
> +{
> +	const struct arm64_ftr_reg *ftr_reg;
> +	const struct arm64_ftr_bits *ftrp = NULL;
> +	u32 id = reg_to_encoding(rd);
> +	u64 writable_mask = rd->val;
> +	u64 limit = 0;
> +	u64 mask = 0;
> +
> +	/* For hidden and unallocated idregs without reset, only val = 0 is allowed. */
> +	if (rd->reset) {
> +		limit = rd->reset(vcpu, rd);
> +		ftr_reg = get_arm64_ftr_reg(id);
> +		if (!ftr_reg)
> +			return -EINVAL;
> +		ftrp = ftr_reg->ftr_bits;
> +	}
> +
> +	for (; ftrp && ftrp->width; ftrp++) {
> +		s64 f_val, f_lim, safe_val;
> +		u64 ftr_mask;
> +
> +		ftr_mask = arm64_ftr_mask(ftrp);
> +		if ((ftr_mask & writable_mask) != ftr_mask)
> +			continue;
> +
> +		f_val = arm64_ftr_value(ftrp, val);
> +		f_lim = arm64_ftr_value(ftrp, limit);
> +		mask |= ftr_mask;
> +
> +		if (f_val == f_lim)
> +			safe_val = f_val;
> +		else
> +			safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);

Since PMUVer and PerfMon is defined as FTR_EXACT, I believe having lower
value in those two fields than the limit always ends up getting -E2BIG.
Or am I missing something ?? 
FYI. IIRC, we have some more fields in other ID registers that KVM
shouldn't use as is.

> +
> +		if (safe_val != f_val)
> +			return -E2BIG;
> +	}
> +
> +	/* For fields that are not writable, values in limit are the safe values. */
> +	if ((val & ~mask) != (limit & ~mask))
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +
>  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_vcpu_has_pmu(vcpu))
> @@ -68,7 +128,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  	case SYS_ID_AA64PFR0_EL1:
>  		if (!vcpu_has_sve(vcpu))
>  			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
>  		if (kvm_vgic_global_state.type == VGIC_V3) {
>  			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
>  			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
> @@ -95,15 +154,10 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
>  		break;
>  	case SYS_ID_AA64DFR0_EL1:
> -		/* Limit debug to ARMv8.0 */
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
>  		/* Set PMUver to the required version */
>  		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
>  		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
>  				  vcpu_pmuver(vcpu));
> -		/* Hide SPE from guests */
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
>  		break;
>  	case SYS_ID_DFR0_EL1:
>  		val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> @@ -162,9 +216,14 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		      u64 val)
>  {
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd))
> -		return -EINVAL;
> +	u32 id = reg_to_encoding(rd);
> +	int ret;
> +
> +	ret = arm64_check_features(vcpu, rd, val);
> +	if (ret)
> +		return ret;
> +
> +	IDREG(vcpu->kvm, id) = val;
>  
>  	return 0;
>  }
> @@ -198,12 +257,40 @@ static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
>  	return id_visibility(vcpu, r);
>  }
>  
> +static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +					  const struct sys_reg_desc *rd)
> +{
> +	u64 val;
> +	u32 id = reg_to_encoding(rd);
> +
> +	val = read_sanitised_ftr_reg(id);
> +	/*
> +	 * The default is to expose CSV2 == 1 if the HW isn't affected.
> +	 * Although this is a per-CPU feature, we make it global because
> +	 * asymmetric systems are just a nuisance.
> +	 *
> +	 * Userspace can override this as long as it doesn't promise
> +	 * the impossible.
> +	 */
> +	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
> +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> +		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> +	}
> +	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
> +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> +		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> +	}
> +
> +	val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> +
> +	return val;
> +}
> +
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  			       const struct sys_reg_desc *rd,
>  			       u64 val)
>  {
>  	u8 csv2, csv3;
> -	u64 sval = val;
>  
>  	/*
>  	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> @@ -219,16 +306,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
>  		return -EINVAL;
>  
> -	/* We can only differ with CSV[23], and anything else is an error */
> -	val ^= read_id_reg(vcpu, rd);
> -	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> -		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> -	if (val)
> -		return -EINVAL;
> +	return set_id_reg(vcpu, rd, val);
> +}
> +
> +static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> +					  const struct sys_reg_desc *rd)
> +{
> +	u64 val;
> +	u32 id = reg_to_encoding(rd);
>  
> -	IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
> +	val = read_sanitised_ftr_reg(id);
> +	/* Limit debug to ARMv8.0 */
> +	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> +	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
> +	/*
> +	 * Initialise the default PMUver before there is a chance to
> +	 * create an actual PMU.
> +	 */
> +	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +			  kvm_arm_pmu_get_pmuver_limit());
> +	/* Hide SPE from guests */
> +	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
>  
> -	return 0;
> +	return val;
>  }
>  
>  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> @@ -237,6 +338,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>  {
>  	u8 pmuver, host_pmuver;
>  	bool valid_pmu;
> +	int ret;
>  
>  	host_pmuver = kvm_arm_pmu_get_pmuver_limit();
>  
> @@ -256,36 +358,61 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>  	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
>  		return -EINVAL;
>  
> -	/* We can only differ with PMUver, and anything else is an error */
> -	val ^= read_id_reg(vcpu, rd);
> -	val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> -	if (val)
> -		return -EINVAL;
> +	if (!valid_pmu) {
> +		/*
> +		 * Ignore the PMUVer filed in @val. The PMUVer would be determined
> +		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> +		 */
> +		pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK, read_id_reg(vcpu, rd));

As vPMU is not configured for this vCPU, I believe pmuver will be 
0x0 or 0xf.  I think that is not what we want there.
Or am I missing something ?


> +		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> +		val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
> +	}
>  
> -	if (valid_pmu) {
> -		mutex_lock(&vcpu->kvm->arch.config_lock);
> -		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> -		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> -								    pmuver);
> +	mutex_lock(&vcpu->kvm->arch.config_lock);
>  
> -		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> -		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> -								pmuver_to_perfmon(pmuver));
> +	ret = set_id_reg(vcpu, rd, val);
> +	if (ret) {
>  		mutex_unlock(&vcpu->kvm->arch.config_lock);
> -	} else {
> +		return ret;
> +	}
> +
> +	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> +	IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> +							pmuver_to_perfmon(pmuver));
> +
> +	if (!valid_pmu)
>  		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
>  			   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> -	}
> +
> +	mutex_unlock(&vcpu->kvm->arch.config_lock);
>  
>  	return 0;
>  }
>  
> +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> +				      const struct sys_reg_desc *rd)
> +{
> +	u64 val;
> +	u32 id = reg_to_encoding(rd);
> +
> +	val = read_sanitised_ftr_reg(id);
> +	/*
> +	 * Initialise the default PMUver before there is a chance to
> +	 * create an actual PMU.
> +	 */
> +	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> +	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), kvm_arm_pmu_get_pmuver_limit());
> +
> +	return val;
> +}
> +
>  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  			   const struct sys_reg_desc *rd,
>  			   u64 val)
>  {
>  	u8 perfmon, host_perfmon;
>  	bool valid_pmu;
> +	int ret;
>  
>  	host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
>  
> @@ -306,25 +433,33 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  	if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
>  		return -EINVAL;
>  
> -	/* We can only differ with PerfMon, and anything else is an error */
> -	val ^= read_id_reg(vcpu, rd);
> -	val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> -	if (val)
> -		return -EINVAL;
> +	if (!valid_pmu) {
> +		/*
> +		 * Ignore the PerfMon filed in @val. The PerfMon would be determined
> +		 * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> +		 */

I have the same comment as set_id_aa64dfr0_el1().

Thank you,
Reiji

> +		perfmon = FIELD_GET(ID_DFR0_EL1_PerfMon_MASK, read_id_reg(vcpu, rd));
> +		val &= ~ID_DFR0_EL1_PerfMon_MASK;
> +		val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> +	}
>  
> -	if (valid_pmu) {
> -		mutex_lock(&vcpu->kvm->arch.config_lock);
> -		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> -		IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> +	mutex_lock(&vcpu->kvm->arch.config_lock);
>  
> -		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> -		IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> -								    perfmon_to_pmuver(perfmon));
> +	ret = set_id_reg(vcpu, rd, val);
> +	if (ret) {
>  		mutex_unlock(&vcpu->kvm->arch.config_lock);
> -	} else {
> +		return ret;
> +	}
> +
> +	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> +	IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> +							    perfmon_to_pmuver(perfmon));
> +
> +	if (!valid_pmu)
>  		assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
>  			   perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
> -	}
> +
> +	mutex_unlock(&vcpu->kvm->arch.config_lock);
>  
>  	return 0;
>  }
> @@ -402,9 +537,13 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
>  	/* CRm=1 */
>  	AA32_ID_SANITISED(ID_PFR0_EL1),
>  	AA32_ID_SANITISED(ID_PFR1_EL1),
> -	{ SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
> -	  .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
> -	  .visibility = aa32_id_visibility, },
> +	{ SYS_DESC(SYS_ID_DFR0_EL1),
> +	  .access = access_id_reg,
> +	  .get_user = get_id_reg,
> +	  .set_user = set_id_dfr0_el1,
> +	  .visibility = aa32_id_visibility,
> +	  .reset = read_sanitised_id_dfr0_el1,
> +	  .val = ID_DFR0_EL1_PerfMon_MASK, },
>  	ID_HIDDEN(ID_AFR0_EL1),
>  	AA32_ID_SANITISED(ID_MMFR0_EL1),
>  	AA32_ID_SANITISED(ID_MMFR1_EL1),
> @@ -433,8 +572,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
>  
>  	/* AArch64 ID registers */
>  	/* CRm=4 */
> -	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
> -	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
> +	{ SYS_DESC(SYS_ID_AA64PFR0_EL1),
> +	  .access = access_id_reg,
> +	  .get_user = get_id_reg,
> +	  .set_user = set_id_aa64pfr0_el1,
> +	  .reset = read_sanitised_id_aa64pfr0_el1,
> +	  .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
>  	ID_SANITISED(ID_AA64PFR1_EL1),
>  	ID_UNALLOCATED(4, 2),
>  	ID_UNALLOCATED(4, 3),
> @@ -444,8 +587,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
>  	ID_UNALLOCATED(4, 7),
>  
>  	/* CRm=5 */
> -	{ SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
> -	  .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
> +	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
> +	  .access = access_id_reg,
> +	  .get_user = get_id_reg,
> +	  .set_user = set_id_aa64dfr0_el1,
> +	  .reset = read_sanitised_id_aa64dfr0_el1,
> +	  .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
>  	ID_SANITISED(ID_AA64DFR1_EL1),
>  	ID_UNALLOCATED(5, 2),
>  	ID_UNALLOCATED(5, 3),
> @@ -520,33 +667,4 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
>  
>  		IDREG(kvm, id) = val;
>  	}
> -
> -	/*
> -	 * The default is to expose CSV2 == 1 if the HW isn't affected.
> -	 * Although this is a per-CPU feature, we make it global because
> -	 * asymmetric systems are just a nuisance.
> -	 *
> -	 * Userspace can override this as long as it doesn't promise
> -	 * the impossible.
> -	 */
> -	val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
> -
> -	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> -	}
> -	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> -	}
> -
> -	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
> -
> -	/*
> -	 * Initialise the default PMUver before there is a chance to
> -	 * create an actual PMU.
> -	 */
> -	IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> -	IDREG(kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> -						      kvm_arm_pmu_get_pmuver_limit());
>  }
> -- 
> 2.40.0.348.gf938b09366-goog
> 
