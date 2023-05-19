Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B8A70A382
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 01:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjESXwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 19:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjESXwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 19:52:32 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0C31B7
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 16:52:31 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ac65ab7432so70265ad.0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 16:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684540351; x=1687132351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AzrOripG/0UM1uy77HwHWNetJDSTuSvHzc6hXIhMhWw=;
        b=ztclACejKwTWFaL3X/RbGIQnScMluaN1oIR1hZYwXOz+C/OyHuvIvs3K0Y1GL4wHaZ
         VrgyuxSDG+eh+BdkyG6clAJmtU9Hk2TUU4QMLPjSljUd9TLl9O6llq75vlYmcclUey+o
         16NbBU/FNYY6lQSqiUTvQB26r+OD5mZc4m0Tb4311pYxbuQSBpfD8SoYWD0/1R9GTKm0
         ouqBbPj+/oFD8Cvea6hKh6sugxzXbV4AhIrO7uELcfBJbUEx3eL2yynucn0d+R0dXUnt
         yGsCXNHoq7FpDGgxU6mbETF/J87rkv/TQiHTSLml6oCBfqJ3bmMDvzpvQ5B/563/d8gm
         RVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684540351; x=1687132351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzrOripG/0UM1uy77HwHWNetJDSTuSvHzc6hXIhMhWw=;
        b=J/oy/Daow3Oaj1Kk0kWuMUyhOep19LbudlAI0murCfa1tKQDY2/zN33NpOUIME51jv
         VeNIAy3JPd1LeKw6N0UI2rPB36ftX0R+m+6/4l8Lfrg97dIb09CqQtt210tMWOXfcuA1
         ZNgrWxJXh0IubhEWMaBFu2F6abPdlICBBSKG75Fa3tf3V1H5r9+vYPKqJj2v3oyUt/3e
         5e+qincoAX7/ch8goPj6nGAQ5cySVoCxXtTyqmtdkX9q54pD+lQ/yzPSwU3YCzq6rQXC
         WFET0T0J9NxIO0IrQVNvvrMlT2L78UuWeYT9EOrQjPUgqiEElOT2JLd3zYSCslyfq29m
         PU6w==
X-Gm-Message-State: AC+VfDyWVuAGbrwLxsFKxI/jBTyNvepkD56cz2aTqW4eetg9TASv5jGN
        X+E9M4WmOhr4J1pb62q861g/2g==
X-Google-Smtp-Source: ACHHUZ5pX7dUvCsCqV97saKwVL7mSfDd219hgxmRjo6mr9ahRBM6g4j++Tsv7Kcp2ZMl0g+ahMwLyQ==
X-Received: by 2002:a17:903:230f:b0:1aa:ea22:8043 with SMTP id d15-20020a170903230f00b001aaea228043mr392586plh.7.1684540350977;
        Fri, 19 May 2023 16:52:30 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id c18-20020a170902d49200b001a064282b11sm181265plg.151.2023.05.19.16.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 16:52:29 -0700 (PDT)
Date:   Fri, 19 May 2023 16:52:25 -0700
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
Subject: Re: [PATCH v9 2/5] KVM: arm64: Use per guest ID register for
 ID_AA64PFR0_EL1.[CSV2|CSV3]
Message-ID: <20230519235225.jotppbswdvmjcanj@google.com>
References: <20230517061015.1915934-1-jingzhangos@google.com>
 <20230517061015.1915934-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517061015.1915934-3-jingzhangos@google.com>
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

On Wed, May 17, 2023 at 06:10:11AM +0000, Jing Zhang wrote:
> With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
> userspace can be stored in its corresponding ID register.
> 
> The setting of CSV bits for protected VMs are removed according to the
> discussion from Fuad below:
> https://lore.kernel.org/all/CA+EHjTwXA9TprX4jeG+-D+c8v9XG+oFdU1o6TSkvVye145_OvA@mail.gmail.com
> 
> Besides the removal of CSV bits setting for protected VMs, No other
> functional change intended.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 --
>  arch/arm64/kvm/arm.c              | 17 ----------
>  arch/arm64/kvm/sys_regs.c         | 55 +++++++++++++++++++++++++------
>  3 files changed, 45 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 949a4a782844..07f0e091ae48 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -257,8 +257,6 @@ struct kvm_arch {
>  
>  	cpumask_var_t supported_cpus;
>  
> -	u8 pfr0_csv2;
> -	u8 pfr0_csv3;
>  	struct {
>  		u8 imp:4;
>  		u8 unimp:4;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 774656a0718d..5114521ace60 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -102,22 +102,6 @@ static int kvm_arm_default_max_vcpus(void)
>  	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>  }
>  
> -static void set_default_spectre(struct kvm *kvm)
> -{
> -	/*
> -	 * The default is to expose CSV2 == 1 if the HW isn't affected.
> -	 * Although this is a per-CPU feature, we make it global because
> -	 * asymmetric systems are just a nuisance.
> -	 *
> -	 * Userspace can override this as long as it doesn't promise
> -	 * the impossible.
> -	 */
> -	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> -		kvm->arch.pfr0_csv2 = 1;
> -	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
> -		kvm->arch.pfr0_csv3 = 1;
> -}
> -
>  /**
>   * kvm_arch_init_vm - initializes a VM data structure
>   * @kvm:	pointer to the KVM struct
> @@ -161,7 +145,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	/* The maximum number of VCPUs is limited by the host's GIC model */
>  	kvm->max_vcpus = kvm_arm_default_max_vcpus();
>  
> -	set_default_spectre(kvm);
>  	kvm_arm_init_hypercalls(kvm);
>  	kvm_arm_init_id_regs(kvm);
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d2ee3a1c7f03..3c52b136ade3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1218,10 +1218,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  		if (!vcpu_has_sve(vcpu))
>  			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
>  		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
>  		if (kvm_vgic_global_state.type == VGIC_V3) {
>  			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
>  			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
> @@ -1359,7 +1355,10 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  			       const struct sys_reg_desc *rd,
>  			       u64 val)
>  {
> +	struct kvm_arch *arch = &vcpu->kvm->arch;
> +	u64 sval = val;
>  	u8 csv2, csv3;
> +	int ret = 0;
>  
>  	/*
>  	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> @@ -1377,17 +1376,26 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
>  		return -EINVAL;
>  
> +	mutex_lock(&arch->config_lock);
>  	/* We can only differ with CSV[23], and anything else is an error */
>  	val ^= read_id_reg(vcpu, rd);
>  	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
>  		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> -	if (val)
> -		return -EINVAL;
> -
> -	vcpu->kvm->arch.pfr0_csv2 = csv2;
> -	vcpu->kvm->arch.pfr0_csv3 = csv3;
> +	if (val) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>  
> -	return 0;
> +	/* Only allow userspace to change the idregs before VM running */
> +	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags)) {

How about using kvm_vm_has_ran_once() instead ?


> +		if (sval != read_id_reg(vcpu, rd))

Rather than calling read_id_reg() twice in this function,
perhaps you might want to save the original val we got earlier
and re-use it here ?

Thank you,
Reiji




> +			ret = -EBUSY;
> +	} else {
> +		IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
> +	}
> +out:
> +	mutex_unlock(&arch->config_lock);
> +	return ret;
>  }
>  
>  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> @@ -1479,7 +1487,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		      u64 *val)
>  {
> +	struct kvm_arch *arch = &vcpu->kvm->arch;
> +
> +	mutex_lock(&arch->config_lock);
>  	*val = read_id_reg(vcpu, rd);
> +	mutex_unlock(&arch->config_lock);
> +
>  	return 0;
>  }
>  
> @@ -3364,6 +3377,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
>  {
>  	const struct sys_reg_desc *idreg;
>  	struct sys_reg_params params;
> +	u64 val;
>  	u32 id;
>  
>  	/* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
> @@ -3386,6 +3400,27 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
>  		idreg++;
>  		id = reg_to_encoding(idreg);
>  	}
> +
> +	/*
> +	 * The default is to expose CSV2 == 1 if the HW isn't affected.
> +	 * Although this is a per-CPU feature, we make it global because
> +	 * asymmetric systems are just a nuisance.
> +	 *
> +	 * Userspace can override this as long as it doesn't promise
> +	 * the impossible.
> +	 */
> +	val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
> +
> +	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
> +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> +		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> +	}
> +	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
> +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> +		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> +	}
> +
> +	IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
>  }
>  
>  int __init kvm_sys_reg_table_init(void)
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
