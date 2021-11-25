Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3185B45DD91
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 16:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356113AbhKYPkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 10:40:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:24672 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240693AbhKYPiV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Nov 2021 10:38:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637854510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Go3/6t5i9YcKtZRxRTqTsP/4631+JUTyvogPitjQiZI=;
        b=SKbK+ksD9cQTOUAVTQijYFxBZZk0jNp/FUuH9J0raa+B5vKx0drfx/vgRxCk6m703Op1F3
        P5nHOgwq8Y0m9yds2CcrWvIbU1/2FjZwzhtlREBcH7Cd/uAzwEivJ+eklzSmNlQUqNxHaa
        YFuORyOtHa6jzPg6wN8CqAm0XeDgRng=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-8ETH0L5rOia0Ciri931X8g-1; Thu, 25 Nov 2021 10:35:09 -0500
X-MC-Unique: 8ETH0L5rOia0Ciri931X8g-1
Received: by mail-wm1-f69.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so5147537wmc.7
        for <kvm@vger.kernel.org>; Thu, 25 Nov 2021 07:35:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Go3/6t5i9YcKtZRxRTqTsP/4631+JUTyvogPitjQiZI=;
        b=bWJH6wCpyQNHd2ACt7Mwv7Q+dpQLbYy6srCw7FT+kVS+QCFqR66rw0tPznXfl2S8dm
         FAt1/HZN3hIhHENNdHzZ6jR0rm11n2q7OPvf9RoIN0kzLiB/mSqpxXb6FDjsMqMAecF8
         8aAR1YIOCnNjpFKjtyHyzWQtI2QztjvPJst3HwE43jFdB0JDFPJrhZR/BHYTF6M587lw
         QUF/e9QD7pBYP0nYHvRBllqNiwJdvOXjCgCp4doNLKramIX++NcqcqK5D0lu7VNQiGwN
         rrDIu6yzfyFTEka4bDaIlDNbhu8N299lnigCSx+ui1r3eoLs9ySmA5R7Aan559xztvDy
         muhw==
X-Gm-Message-State: AOAM532LWsYnj6YDYzk3qTTyqF2dEEEGmM+TBACxXSTt9SkWnolRW7oH
        aPswJURJ2Cit8sc8h/N9WGdQOz4DIOqZhEnLJslle6nXPBIlxdb5bLra8m0KQoQppE26syxTGoW
        3IivGSXCFdMbD
X-Received: by 2002:a5d:47a9:: with SMTP id 9mr7627993wrb.42.1637854507692;
        Thu, 25 Nov 2021 07:35:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxONaqPlckK5+oTOGtTwnKy0JFj0xHVhrtDeA6V1AujrPVzPnIdMrmMdMFO/BwzAAN9h9y53w==
X-Received: by 2002:a5d:47a9:: with SMTP id 9mr7627951wrb.42.1637854507436;
        Thu, 25 Nov 2021 07:35:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f7sm3828066wri.74.2021.11.25.07.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:35:06 -0800 (PST)
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-5-reijiw@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com>
Date:   Thu, 25 Nov 2021 16:35:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-5-reijiw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
> userspace.
> 
> The CSV2/CSV3 fields of the register were already writable and values
> that were written for them affected all vCPUs before. Now they only
> affect the vCPU.
> Return an error if userspace tries to set SVE/GIC field of the register
> to a value that conflicts with SVE/GIC configuration for the guest.
> SIMD/FP/SVE fields of the requested value are validated according to
> Arm ARM.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
>  1 file changed, 103 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1552cd5581b7..35400869067a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
>  		id_reg->init(id_reg);
>  }
>  
> +#define	kvm_has_gic3(kvm)		\
> +	(irqchip_in_kernel(kvm) &&	\
> +	 (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
you may move this macro to kvm/arm_vgic.h as this may be used in
vgic/vgic-v3.c too
> +
> +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +				    const struct id_reg_info *id_reg, u64 val)
> +{
> +	int fp, simd;
> +	bool vcpu_has_sve = vcpu_has_sve(vcpu);
> +	bool pfr0_has_sve = id_aa64pfr0_sve(val);
> +	int gic;
> +
> +	simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
> +	fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
> +	if (simd != fp)
> +		return -EINVAL;
> +
> +	/* fp must be supported when sve is supported */
> +	if (pfr0_has_sve && (fp < 0))
> +		return -EINVAL;
> +
> +	/* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> +	if (vcpu_has_sve ^ pfr0_has_sve)
> +		return -EPERM;
> +
> +	gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
> +	if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
> +		return -EPERM;

Sometimes from a given architecture version, some lower values are not
allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
Shouldn't we handle that kind of check?
> +
> +	return 0;
> +}
> +
> +static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
> +{
> +	u64 limit = id_reg->vcpu_limit_val;
> +	unsigned int gic;
> +
> +	limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
> +	if (!system_supports_sve())
> +		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> +
> +	/*
> +	 * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
> +	 * isn't affected.  Userspace can override this as long as it
> +	 * doesn't promise the impossible.
> +	 */
> +	limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
> +		   ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
> +
> +	if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
> +		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
> +	if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
> +		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
> +
> +	gic = cpuid_feature_extract_unsigned_field(limit, ID_AA64PFR0_GIC_SHIFT);
> +	if (gic > 1) {
> +		/* Limit to GICv3.0/4.0 */
> +		limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
> +		limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
> +	}
> +	id_reg->vcpu_limit_val = limit;
> +}
> +
> +static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> +				     const struct id_reg_info *idr)
> +{
> +	u64 val = idr->vcpu_limit_val;
> +
> +	if (!vcpu_has_sve(vcpu))
> +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> +
> +	if (!kvm_has_gic3(vcpu->kvm))
> +		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
> +
> +	return val;
> +}
> +
> +static struct id_reg_info id_aa64pfr0_el1_info = {
> +	.sys_reg = SYS_ID_AA64PFR0_EL1,
> +	.ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
> +			   S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
is it needed as it is the default?
> +	.init = init_id_aa64pfr0_el1_info,
> +	.validate = validate_id_aa64pfr0_el1,
> +	.get_reset_val = get_reset_id_aa64pfr0_el1,
> +};
> +
>  /*
>   * An ID register that needs special handling to control the value for the
>   * guest must have its own id_reg_info in id_reg_info_table.
> @@ -409,7 +495,9 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
>   * validation, etc.)
>   */
>  #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
> -static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
> +static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
> +	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
> +};
>  
>  static int validate_id_reg(struct kvm_vcpu *vcpu,
>  			   const struct sys_reg_desc *rd, u64 val)
> @@ -1239,20 +1327,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
>  	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> +	u64 lim, gic, gic_lim;
> +	const struct id_reg_info *id_reg;
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> -		if (!vcpu_has_sve(vcpu))
> -			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), (u64)vcpu->kvm->arch.pfr0_csv2);
> -		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3);
> -		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
> -		if (irqchip_in_kernel(vcpu->kvm) &&
> -		    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
> -			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
> -			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
> +		gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
> +		if (kvm_has_gic3(vcpu->kvm) && (gic == 0)) {
> +			/*
> +			 * This is a case where userspace configured gic3 after
> +			 * the vcpu was created, and then it didn't set
> +			 * ID_AA64PFR0_EL1.
> +			 */
> +			id_reg = GET_ID_REG_INFO(id);
> +			lim = id_reg->vcpu_limit_val;
> +			gic_lim = cpuid_feature_extract_unsigned_field(lim, ID_AA64PFR0_GIC_SHIFT);
> +			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), gic_lim);
>  		}
>  		break;
>  	case SYS_ID_AA64PFR1_EL1:
> @@ -1373,48 +1463,6 @@ static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
>  	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
>  }
>  
> -static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> -			       const struct sys_reg_desc *rd,
> -			       const struct kvm_one_reg *reg, void __user *uaddr)
> -{
> -	const u64 id = sys_reg_to_index(rd);
> -	u8 csv2, csv3;
> -	int err;
> -	u64 val;
> -
> -	err = reg_from_user(&val, uaddr, id);
> -	if (err)
> -		return err;
> -
> -	/*
> -	 * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> -	 * it doesn't promise more than what is actually provided (the
> -	 * guest could otherwise be covered in ectoplasmic residue).
> -	 */
> -	csv2 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV2_SHIFT);
> -	if (csv2 > 1 ||
> -	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
> -		return -EINVAL;
> -
> -	/* Same thing for CSV3 */
> -	csv3 = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_CSV3_SHIFT);
> -	if (csv3 > 1 ||
> -	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
> -		return -EINVAL;
> -
> -	/* We can only differ with CSV[23], and anything else is an error */
> -	val ^= read_id_reg(vcpu, rd, false);
> -	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) |
> -		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
> -	if (val)
> -		return -EINVAL;
> -
> -	vcpu->kvm->arch.pfr0_csv2 = csv2;
> -	vcpu->kvm->arch.pfr0_csv3 = csv3 ;
> -
> -	return 0;
> -}
> -
>  /* cpufeature ID register user accessors */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1705,8 +1753,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	/* AArch64 ID registers */
>  	/* CRm=4 */
> -	{ SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
> -	  .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
> +	ID_SANITISED(ID_AA64PFR0_EL1),
>  	ID_SANITISED(ID_AA64PFR1_EL1),
>  	ID_UNALLOCATED(4,2),
>  	ID_UNALLOCATED(4,3),
> 

Thanks

Eric

