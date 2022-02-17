Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672A94B980B
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 06:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiBQFPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 00:15:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBQFPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 00:15:02 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429B32A598B
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 21:14:48 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id o2so1450520ilm.13
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 21:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oZFftC7fjW59EFI2OJ05JcjnYAHcobyzdot6u9knipQ=;
        b=BNDVfa01xGmS4GmqZnKf735+pTjc4BIfyPDkoEIXx9TDMgjjmLJorWkLT5hhFvVhac
         w7OTnzjVVQ/AAk0whse6lRC/sU/PIo0UZ9lTS8bHltgAzAK56QahfMKa37p6YXHHh56V
         LZuXVsvCynOR0OVBLPKWnZSjOMrDzMwqG7p+3jnK3w54MxLJEvdDjkX3+Aylrkw/+xBq
         ZbAU4LFujAlKBtXPGN4vH/EWFx9bdxA6NwL0iZyYuA1YgcMojPGu3h6PlsEDJquKGnKe
         i8WEMTL6iJyRJwzFKBJ0Bmtpuyu75baz2/KKtTW5FCdut5Rlx6k5nQ2Wj011ZZqZ3fQN
         tUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oZFftC7fjW59EFI2OJ05JcjnYAHcobyzdot6u9knipQ=;
        b=f3kqS1QBYNMYhqrqx8AOtgrPlAlf4zgZfnf1ChC0ic2rxRF8c1Tz5Qjp1U8JPUqqvK
         mWmEJ2+a+7CXIePnOEybXBgfe2TlifhWOcgJM6Vaf4y+ZVZA3WI6UPSNVIpA5b3AiLhb
         x7KWreoX6D8pmSz3TySjo2KxoTNECVIDJZGI0Vh7O8wHNGa+7QBCHfn6IJsH3co3McOV
         mm2O6ipVrbujPCIUJTxFdvfD+9Wks1ZNhk851FdiXu4eLxCwg/2mfWLpfs8RodJsu8jV
         wP+QTs+qEtOvc5YpBgKHPC4bAUavHSv9FnOpSrbGyMh5IPKz0RkxcinHfUYeskkO97lA
         nFrw==
X-Gm-Message-State: AOAM531c61GITSvkE6lpBp2BrvVpxzm4Z1sR25mcAaMpJXFSMd45BwKl
        qot4pRqzkhUxZjnOn9v061Xfyw==
X-Google-Smtp-Source: ABdhPJwr6SWqMRMsK8z5hvqUbyL9j3RC/hMinu+q2RslmhxLbsdlKV8g68vEYWAUbtrPi1LLcVlNbA==
X-Received: by 2002:a05:6e02:1c22:b0:2b9:dcbb:e810 with SMTP id m2-20020a056e021c2200b002b9dcbbe810mr892199ilh.262.1645074887254;
        Wed, 16 Feb 2022 21:14:47 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id l1sm1420860iln.29.2022.02.16.21.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 21:14:45 -0800 (PST)
Date:   Thu, 17 Feb 2022 05:14:42 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v5 03/27] KVM: arm64: Introduce struct id_reg_info
Message-ID: <Yg3ZwuW+ykGJt2A5@google.com>
References: <20220214065746.1230608-1-reijiw@google.com>
 <20220214065746.1230608-4-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214065746.1230608-4-reijiw@google.com>
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

On Sun, Feb 13, 2022 at 10:57:22PM -0800, Reiji Watanabe wrote:
> This patch lays the groundwork to make ID registers writable.
> 
> Introduce struct id_reg_info for an ID register to manage the
> register specific control of its value for the guest, and provide set
> of functions commonly used for ID registers to make them writable.
> 
> The id_reg_info is used to do register specific initialization,
> validation of the ID register and etc.  Not all ID registers must
> have the id_reg_info. ID registers that don't have the id_reg_info
> are handled in a common way that is applied to all ID registers.
> 
> At present, changing an ID register from userspace is allowed only
> if the ID register has the id_reg_info, but that will be changed
> by the following patches.
> 
> No ID register has the structure yet and the following patches
> will add the id_reg_info for some ID registers.
> 
> kvm_set_id_reg_feature(), which is introduced in this patch,
> is going to be used by the following patch outsdie from sys_regs.c

typo: outside

> when an ID register field needs to be updated.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |   1 +
>  arch/arm64/include/asm/sysreg.h   |   1 +
>  arch/arm64/kvm/sys_regs.c         | 280 ++++++++++++++++++++++++++++--
>  3 files changed, 268 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c041e5afe3d2..9ffe6604a58a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -747,6 +747,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  				struct kvm_arm_copy_mte_tags *copy_tags);
>  
>  void set_default_id_regs(struct kvm *kvm);
> +int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
>  
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 898bee0004ae..3f12e7036985 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1214,6 +1214,7 @@
>  #define ICH_VTR_TDS_MASK	(1 << ICH_VTR_TDS_SHIFT)
>  
>  #define ARM64_FEATURE_FIELD_BITS	4
> +#define ARM64_FEATURE_FIELD_MASK	((1ull << ARM64_FEATURE_FIELD_BITS) - 1)

nit: use GENMASK_ULL()

>  /* Create a mask for the feature bits of the specified feature. */
>  #define ARM64_FEATURE_MASK(x)	(GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))

nit: make use of the newly-minted ARM64_FEATURE_FIELD_MASK in this
macro.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 080908c60fa6..da76516f2aad 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -265,6 +265,113 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  		return read_zero(vcpu, p);
>  }
>  
> +struct id_reg_info {
> +	/* Register ID */
> +	u32	sys_reg;
> +
> +	/*
> +	 * Limit value of the register for a vcpu. The value is the sanitized
> +	 * system value with bits set/cleared for unsupported features for the
> +	 * guest.
> +	 */
> +	u64	vcpu_limit_val;
> +
> +	/* Fields that are not validated by arm64_check_features_kvm. */
> +	u64	ignore_mask;
> +
> +	/* An optional initialization function of the id_reg_info */
> +	void (*init)(struct id_reg_info *id_reg);
> +
> +	/*
> +	 * This is an optional ID register specific validation function. When
> +	 * userspace tries to set the ID register, arm64_check_features_kvm()
> +	 * will check if the requested value indicates any features that cannot
> +	 * be supported by KVM on the host.  But, some ID register fields need
> +	 * a special checking, and this function can be used for such fields.
> +	 * e.g. When SVE is configured for a vCPU by KVM_ARM_VCPU_INIT,
> +	 * ID_AA64PFR0_EL1.SVE shouldn't be set to 0 for the vCPU.
> +	 * The validation function for ID_AA64PFR0_EL1 could be used to check
> +	 * the field is consistent with SVE configuration.
> +	 */
> +	int (*validate)(struct kvm_vcpu *vcpu, const struct id_reg_info *id_reg,
> +			u64 val);
> +
> +	/*
> +	 * Return a bitmask of the vCPU's ID register fields that are not
> +	 * synced with saved (per VM) ID register value, which usually
> +	 * indicates opt-in CPU features that are not configured for the vCPU.
> +	 * ID registers are saved per VM, but some opt-in CPU features can
> +	 * be configured per vCPU.  The saved (per VM) values for such
> +	 * features are for vCPUs with the features (and zero for
> +	 * vCPUs without the features).
> +	 * Return value of this function is used to handle such fields
> +	 * for per vCPU ID register read/write request with saved per VM
> +	 * ID register.  See the __write_id_reg's comment for more detail.
> +	 */
> +	u64 (*vcpu_mask)(const struct kvm_vcpu *vcpu,
> +			 const struct id_reg_info *id_reg);
> +};
> +
> +static void id_reg_info_init(struct id_reg_info *id_reg)
> +{
> +	u64 val = read_sanitised_ftr_reg(id_reg->sys_reg);
> +
> +	id_reg->vcpu_limit_val = val;
> +	if (id_reg->init)
> +		id_reg->init(id_reg);
> +
> +	/*
> +	 * id_reg->init() might update id_reg->vcpu_limit_val.
> +	 * Make sure that id_reg->vcpu_limit_val, which will be the default
> +	 * register value for guests, is a safe value to use for guests
> +	 * on the host.
> +	 */
> +	WARN_ON_ONCE(arm64_check_features_kvm(id_reg->sys_reg,
> +					      id_reg->vcpu_limit_val, val));
> +}
> +
> +/*
> + * An ID register that needs special handling to control the value for the
> + * guest must have its own id_reg_info in id_reg_info_table.
> + * (i.e. the reset value is different from the host's sanitized value,
> + * the value is affected by opt-in features, some fields need specific
> + * validation, etc.)
> + */
> +#define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
> +static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};

It seems a bit peculiar that we effectively have two arrays that
describe feature ID registers now. IMO, it might be a bit cleaner to
sweep all relevant data into this array and just remove them from the
general system register array altogether.

We are already adding a lot of special-case handling for feature ID
registers, and that is only bound to increase as the architecture is
extended upon further.

> +static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
> +{
> +	const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> +	u64 limit, tmp_val;
> +	int err;
> +
> +	if (id_reg) {
> +		limit = id_reg->vcpu_limit_val;
> +		/*
> +		 * Replace the fields that are indicated in ignore_mask with
> +		 * the value in the limit to not have arm64_check_features_kvm()
> +		 * check the field in @val.
> +		 */
> +		tmp_val = val & ~id_reg->ignore_mask;
> +		tmp_val |= (limit & id_reg->ignore_mask);
> +	} else {
> +		limit = read_sanitised_ftr_reg(id);
> +		tmp_val = val;
> +	}
> +
> +	/* Check if the value indicates any feature that is not in the limit. */
> +	err = arm64_check_features_kvm(id, tmp_val, limit);
> +	if (err)
> +		return err;
> +
> +	if (id_reg && id_reg->validate)
> +		/* Run the ID register specific validity check. */
> +		err = id_reg->validate(vcpu, id_reg, val);
> +
> +	return err;
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -1068,9 +1175,91 @@ static bool is_id_reg(u32 id)
>  		sys_reg_CRm(id) < 8);
>  }
>  
> +static u64 read_kvm_id_reg(struct kvm *kvm, u32 id)
> +{
> +	return kvm->arch.id_regs[IDREG_IDX(id)];
> +}
> +
> +static int __modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
> +			     u64 preserve_mask)
> +{
> +	u64 old, new;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	old = kvm->arch.id_regs[IDREG_IDX(id)];
> +
> +	/* Preserve the value at the bit position set in preserve_mask */
> +	new = old & preserve_mask;
> +	new |= (val & ~preserve_mask);
> +
> +	/* Don't allow to modify ID register value after KVM_RUN on any vCPUs */
> +	if (kvm->arch.ran_once && new != old)
> +		return -EBUSY;
> +
> +	WRITE_ONCE(kvm->arch.id_regs[IDREG_IDX(id)], new);
> +
> +	return 0;
> +}
> +
> +static int modify_kvm_id_reg(struct kvm *kvm, u32 id, u64 val,
> +			     u64 preserve_mask)
> +{
> +	int ret;
> +
> +	mutex_lock(&kvm->lock);
> +	ret = __modify_kvm_id_reg(kvm, id, val, preserve_mask);
> +	mutex_unlock(&kvm->lock);
> +
> +	return ret;
> +}
> +
> +static int write_kvm_id_reg(struct kvm *kvm, u32 id, u64 val)
> +{
> +	return modify_kvm_id_reg(kvm, id, val, 0);
> +}
> +
> +/*
> + * KVM basically forces all vCPUs of the guest to have a uniform value for
> + * each ID register (it means KVM_SET_ONE_REG for a vCPU affects all
> + * the vCPUs of the guest), and the id_regs[] of kvm_arch holds values
> + * of ID registers for the guest.  However, there is an exception for
> + * ID register fields corresponding to CPU features that can be
> + * configured per vCPU by KVM_ARM_VCPU_INIT, or etc (e.g. PMUv3, SVE, etc).
> + * For such fields, all vCPUs that have the feature will have a non-zero
> + * uniform value, which can be updated by userspace, but the vCPUs that
> + * don't have the feature will have zero for the fields.
> + * Values that @id_regs holds are for vCPUs that have such features.  So,
> + * to get the ID register value for a vCPU that doesn't have those features,
> + * the corresponding fields in id_regs[] needs to be cleared.
> + * A bitmask of the fields are provided by id_reg_info's vcpu_mask(), and
> + * __write_id_reg() and __read_id_reg() take care of those fields using
> + * the bitmask.
> + */
> +static int __write_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
> +{
> +	const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> +	u64 mask = 0;
> +
> +	if (id_reg && id_reg->vcpu_mask)
> +		mask = id_reg->vcpu_mask(vcpu, id_reg);
> +
> +	/*
> +	 * Update the ID register for the guest with @val, except for fields
> +	 * that are set in the mask, which indicates fields for opt-in
> +	 * features that are not configured for the vCPU.
> +	 */
> +	return modify_kvm_id_reg(vcpu->kvm, id, val, mask);
> +}
> +
>  static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -	u64 val = vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
> +	const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> +	u64 val = read_kvm_id_reg(vcpu->kvm, id);
> +
> +	if (id_reg && id_reg->vcpu_mask)
> +		/* Clear fields for opt-in features that are not configured. */
> +		val &= ~(id_reg->vcpu_mask(vcpu, id_reg));
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -1229,12 +1418,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -/*
> - * cpufeature ID register user accessors
> - *
> - * For now, these registers are immutable for userspace, so for set_id_reg()
> - * we don't allow the effective value to be changed.
> - */
> +/* cpufeature ID register user accessors */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
> @@ -1245,11 +1429,31 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  	return reg_to_user(uaddr, &val, id);
>  }
>  
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +/*
> + * Check if the given id indicates AArch32 ID register encoding.
> + */
> +static bool is_aarch32_id_reg(u32 id)
> +{
> +	u32 crm, op2;
> +
> +	if (!is_id_reg(id))
> +		return false;
> +
> +	crm = sys_reg_CRm(id);
> +	op2 = sys_reg_Op2(id);
> +	if (crm == 1 || crm == 2 || (crm == 3 && (op2 != 3 && op2 != 7)))
> +		/* AArch32 ID register */
> +		return true;
> +
> +	return false;
> +}
> +
> +static int __set_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
>  	const u64 id = sys_reg_to_index(rd);
> +	u32 encoding = reg_to_encoding(rd);
>  	int err;
>  	u64 val;
>  
> @@ -1257,11 +1461,28 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
>  	if (err)
>  		return err;
>  
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd, raz))
> +	if (val == read_id_reg(vcpu, rd, raz))
> +		/* The value is same as the current value. Nothing to do. */
> +		return 0;
> +
> +	/*
> +	 * Don't allow to modify the register's value if the register is raz,
> +	 * or the reg doesn't have the id_reg_info.
> +	 */
> +	if (raz || !GET_ID_REG_INFO(encoding))
>  		return -EINVAL;
>  
> -	return 0;
> +	/*
> +	 * Skip the validation of AArch32 ID registers if the system doesn't
> +	 * 32bit EL0 (their value are UNKNOWN).
> +	 */
> +	if (system_supports_32bit_el0() || !is_aarch32_id_reg(encoding)) {
> +		err = validate_id_reg(vcpu, encoding, val);
> +		if (err)
> +			return err;
> +	}
> +
> +	return __write_id_reg(vcpu, encoding, val);
>  }
>  
>  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> @@ -2823,6 +3044,20 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	return write_demux_regids(uindices);
>  }
>  
> +static void id_reg_info_init_all(void)
> +{
> +	int i;
> +	struct id_reg_info *id_reg;
> +
> +	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
> +		id_reg = (struct id_reg_info *)id_reg_info_table[i];
> +		if (!id_reg)
> +			continue;
> +
> +		id_reg_info_init(id_reg);
> +	}
> +}
> +
>  void kvm_sys_reg_table_init(void)
>  {
>  	unsigned int i;
> @@ -2857,6 +3092,8 @@ void kvm_sys_reg_table_init(void)
>  			break;
>  	/* Clear all higher bits. */
>  	cache_levels &= (1 << (i*3))-1;
> +
> +	id_reg_info_init_all();
>  }
>  
>  /*
> @@ -2869,11 +3106,12 @@ void set_default_id_regs(struct kvm *kvm)
>  	u32 id;
>  	const struct sys_reg_desc *rd;
>  	u64 val;
> +	struct id_reg_info *idr;
>  
>  	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
>  		rd = &sys_reg_descs[i];
>  		if (rd->access != access_id_reg)
> -			/* Not ID register, or hidden/reserved ID register */
> +			/* Not ID register or hidden/reserved ID register */
>  			continue;
>  
>  		id = reg_to_encoding(rd);
> @@ -2881,7 +3119,21 @@ void set_default_id_regs(struct kvm *kvm)
>  			/* Shouldn't happen */
>  			continue;
>  
> -		val = read_sanitised_ftr_reg(id);
> -		kvm->arch.id_regs[IDREG_IDX(id)] = val;
> +		idr = GET_ID_REG_INFO(id);
> +		val = idr ? idr->vcpu_limit_val : read_sanitised_ftr_reg(id);
> +		WARN_ON_ONCE(write_kvm_id_reg(kvm, id, val));
>  	}
>  }
> +
> +/*
> + * Update the ID register's field with @fval for the guest.
> + * The caller is expected to hold the kvm->lock.
> + * This will not fail unless any vCPUs in the guest have started.
> + */
> +int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval)
> +{
> +	u64 val = ((u64)fval & ARM64_FEATURE_FIELD_MASK) << field_shift;
> +	u64 preserve_mask = ~(ARM64_FEATURE_FIELD_MASK << field_shift);
> +
> +	return __modify_kvm_id_reg(kvm, id, val, preserve_mask);
> +}
> -- 
> 2.35.1.265.g69c8d7142f-goog
> 

--
Thanks,
Oliver
