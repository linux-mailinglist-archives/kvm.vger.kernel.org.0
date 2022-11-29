Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCE463B9AE
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 07:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiK2GKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 01:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiK2GKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 01:10:04 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFA627168
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 22:10:02 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id x5so20437615wrt.7
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 22:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lCJr20iCMO6otrQBLXdW84k1SNgZ6wNsrM0AUCRs1UA=;
        b=ISzaeFn3uoNDt02J+sG4PnZ1Lso401mtGM3hlWF/gfMv79L88pJ4hF0vsORNDciczJ
         KtTWvcOu5RPtvW4s8l87/3RvavhxB6QF83W5aHqz8V4Xi+0u7/C1Eb7uLiFrvon8BGzv
         O2PJKqzY6ON61qbgqIz0DbBSwbEcUii0+8b7oranzDpwTdjJyXfmFj0J+Ln/OfDowu4c
         lYlucUlaVlX7ZFbSuDiZJ0vmxBBMurnvimEqFUkneJsu5nHQ+RciwfbJqhcfSFuDnIqf
         b/Gt5EqeHwUwegnZQJZxr454fwNNaxneC533ER76h5j1z8WfMHgrLVGwUMRt7mDp+/al
         fQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCJr20iCMO6otrQBLXdW84k1SNgZ6wNsrM0AUCRs1UA=;
        b=T61HHu97aJ3rM+6ez5uMCwCLAkVYQ4J2u1sLuiPXyEZ9k8KR7PvkLo/NOlRaCA/8rT
         x6LIrEQxJMYDbOMlXIKlDWtNhcn6qMLex/SaBXeS5AXCuia8EuIQ3LaiHehtHMiLbME8
         +mH+LgCju0E+BdxHt3St4ZoWpgKwFDqQpuUSFmYuh3UW/KMyb5RGTPpyEB/xJ8IJ2+Sw
         42AMfamuiwy/SeUgyGtry8yweN872MItrvixIBsQv0z8/ZhlJI7T9bcVKacWkWh20kWI
         fDB7WePj0/Qq8M0RZifx4uAt70IJPdZsaVbWffe8qa5a8717JVjM556SkhL5Fv10AoCs
         klmg==
X-Gm-Message-State: ANoB5pmf6csK5CORDKSJYEhDJelCS122DsDTfQqAe6lLj4Fu37U8akHF
        FovSLul7L38yo9kxdPZVHBAQPg==
X-Google-Smtp-Source: AA0mqf7Schvqa46O8DCpJF5MxZhzBfKcgwF9BClCyujBG1g0PEJC6cXxmPuDeQZtGyoJW1P9MoRRxg==
X-Received: by 2002:a05:6000:a05:b0:242:1836:c955 with SMTP id co5-20020a0560000a0500b002421836c955mr5165937wrb.37.1669702201363;
        Mon, 28 Nov 2022 22:10:01 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id y19-20020a1c4b13000000b003cf6a55d8e8sm858631wma.7.2022.11.28.22.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 22:10:01 -0800 (PST)
Date:   Tue, 29 Nov 2022 07:09:59 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] RISC-V: KVM: Add ONE_REG interface to enable/disable
 SBI extensions
Message-ID: <20221129060959.2ei473bvveo4u6a5@kamzik>
References: <20221128161424.608889-1-apatel@ventanamicro.com>
 <20221128161424.608889-10-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221128161424.608889-10-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 09:44:24PM +0530, Anup Patel wrote:
> We add ONE_REG interface to enable/disable SBI extensions (just
> like the ONE_REG interface for ISA extensions). This allows KVM
> user-space to decide the set of SBI extension enabled for a Guest
> and by default all SBI extensions are enabled.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
>  arch/riscv/include/uapi/asm/kvm.h     |  19 ++++
>  arch/riscv/kvm/vcpu.c                 |   2 +
>  arch/riscv/kvm/vcpu_sbi.c             | 145 +++++++++++++++++++++++---
>  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
>  5 files changed, 158 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index f79478a85d2d..baa342dadf95 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -16,6 +16,7 @@
>  
>  struct kvm_vcpu_sbi_context {
>  	int return_handled;
> +	bool extension_disabled[KVM_RISCV_SBI_EXT_MAX];
>  };
>  
>  struct kvm_vcpu_sbi_extension {
> @@ -36,7 +37,12 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
>  				     struct kvm_run *run,
>  				     u32 type, u64 flags);
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
> -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
> +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg);
> +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg);
> +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> +				struct kvm_vcpu *vcpu, unsigned long extid);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
>  #ifdef CONFIG_RISCV_SBI_V01
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 92af6f3f057c..71992ff1f9dd 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -108,6 +108,22 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> +/*
> + * SBI extension IDs specific to KVM. This is not the same as the SBI
> + * extension IDs defined by the RISC-V SBI specification.
> + */
> +enum KVM_RISCV_SBI_EXT_ID {
> +	KVM_RISCV_SBI_EXT_V01 = 0,
> +	KVM_RISCV_SBI_EXT_TIME,
> +	KVM_RISCV_SBI_EXT_IPI,
> +	KVM_RISCV_SBI_EXT_RFENCE,
> +	KVM_RISCV_SBI_EXT_SRST,
> +	KVM_RISCV_SBI_EXT_HSM,
> +	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> +	KVM_RISCV_SBI_EXT_VENDOR,
> +	KVM_RISCV_SBI_EXT_MAX,
> +};
> +
>  /* Possible states for kvm_riscv_timer */
>  #define KVM_RISCV_TIMER_STATE_OFF	0
>  #define KVM_RISCV_TIMER_STATE_ON	1
> @@ -152,6 +168,9 @@ enum KVM_RISCV_ISA_EXT_ID {
>  /* ISA Extension registers are mapped as type 7 */
>  #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
>  
> +/* SBI extension registers are mapped as type 8 */
> +#define KVM_REG_RISCV_SBI_EXT		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
> +
>  #endif
>  
>  #endif /* __LINUX_KVM_RISCV_H */
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 7c08567097f0..2260adaf2de8 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -594,6 +594,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
>  						 KVM_REG_RISCV_FP_D);
>  	case KVM_REG_RISCV_ISA_EXT:
>  		return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
> +	case KVM_REG_RISCV_SBI_EXT:
> +		return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
>  	default:
>  		break;
>  	}
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index f96991d230bf..0abb44f8f4d1 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -40,16 +40,48 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>  };
>  #endif
>  
> -static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
> -	&vcpu_sbi_ext_v01,
> -	&vcpu_sbi_ext_base,
> -	&vcpu_sbi_ext_time,
> -	&vcpu_sbi_ext_ipi,
> -	&vcpu_sbi_ext_rfence,
> -	&vcpu_sbi_ext_srst,
> -	&vcpu_sbi_ext_hsm,
> -	&vcpu_sbi_ext_experimental,
> -	&vcpu_sbi_ext_vendor,
> +struct kvm_riscv_sbi_extension_entry {
> +	enum KVM_RISCV_SBI_EXT_ID dis_idx;

nit: I think I'd prefer this to be spelled out (disable_idx)
(although keeping it 7 chars does make the table below line up nicely :-)

> +	const struct kvm_vcpu_sbi_extension *ext_ptr;
> +};
> +
> +static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_V01,
> +		.ext_ptr = &vcpu_sbi_ext_v01,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled */
> +		.ext_ptr = &vcpu_sbi_ext_base,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_TIME,
> +		.ext_ptr = &vcpu_sbi_ext_time,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_IPI,
> +		.ext_ptr = &vcpu_sbi_ext_ipi,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_RFENCE,
> +		.ext_ptr = &vcpu_sbi_ext_rfence,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_SRST,
> +		.ext_ptr = &vcpu_sbi_ext_srst,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_HSM,
> +		.ext_ptr = &vcpu_sbi_ext_hsm,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> +		.ext_ptr = &vcpu_sbi_ext_experimental,
> +	},
> +	{
> +		.dis_idx = KVM_RISCV_SBI_EXT_VENDOR,
> +		.ext_ptr = &vcpu_sbi_ext_vendor,
> +	},
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
> @@ -108,14 +140,95 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 0;
>  }
>  
> -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
> +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	unsigned long __user *uaddr =
> +			(unsigned long __user *)(unsigned long)reg->addr;
> +	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +					    KVM_REG_SIZE_MASK |
> +					    KVM_REG_RISCV_SBI_EXT);

I think we should create a macro that extracts reg_num from reg->id for
all types, i.e.

 #define KVM_REG_NUM(id) ((id) & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_RISCV_TYPE_MASK))

and then we can use it throughout this file.


> +	unsigned long i, reg_val;
> +	const struct kvm_riscv_sbi_extension_entry *sext = NULL;
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> +
> +	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
> +	if (reg_num >= KVM_RISCV_SBI_EXT_MAX ||
> +	    (reg_val != 1 && reg_val != 0))
> +		return -EINVAL;

Maybe

 if (reg_num >= KVM_RISCV_SBI_EXT_MAX)
     return -ENOENT;

 if (reg_val != 1 && reg_val != 0)
    return -EINVAL;

> +
> +	if (vcpu->arch.ran_atleast_once)
> +		return -EBUSY;
> +
> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +		if (sbi_ext[i].dis_idx == reg_num) {
> +			sext = &sbi_ext[i];
> +			break;
> +		}
> +	}
> +	if (!sext)
> +		return -ENOENT;
> +
> +	scontext->extension_disabled[sext->dis_idx] = !reg_val;
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	unsigned long __user *uaddr =
> +			(unsigned long __user *)(unsigned long)reg->addr;
> +	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +					    KVM_REG_SIZE_MASK |
> +					    KVM_REG_RISCV_SBI_EXT);
> +	unsigned long i, reg_val;
> +	const struct kvm_riscv_sbi_extension_entry *sext = NULL;
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> +
> +	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +		return -EINVAL;
> +
> +	if (reg_num >= KVM_RISCV_SBI_EXT_MAX)
> +		return -EINVAL;

ENOENT?

> +
> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +		if (sbi_ext[i].dis_idx == reg_num) {
> +			sext = &sbi_ext[i];
> +			break;
> +		}
> +	}
> +	if (!sext)
> +		return -ENOENT;
> +
> +	reg_val = !scontext->extension_disabled[sext->dis_idx];
> +	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
> +				struct kvm_vcpu *vcpu, unsigned long extid)
>  {
> -	int i = 0;
> +	int i;
> +	const struct kvm_riscv_sbi_extension_entry *sext;
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
>  
>  	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> -		if (sbi_ext[i]->extid_start <= extid &&
> -		    sbi_ext[i]->extid_end >= extid)
> -			return sbi_ext[i];
> +		sext = &sbi_ext[i];
> +		if (sext->ext_ptr->extid_start <= extid &&
> +		    sext->ext_ptr->extid_end >= extid) {
> +			if (sext->dis_idx < KVM_RISCV_SBI_EXT_MAX &&
> +			    scontext->extension_disabled[sext->dis_idx])
> +				return NULL;
> +			return sbi_ext[i].ext_ptr;
> +		}
>  	}
>  
>  	return NULL;
> @@ -132,7 +245,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	unsigned long out_val = 0;
>  	bool ext_is_v01 = false;
>  
> -	sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> +	sbi_ext = kvm_vcpu_sbi_find_ext(vcpu, cp->a7);
>  	if (sbi_ext && sbi_ext->handler) {
>  #ifdef CONFIG_RISCV_SBI_V01
>  		if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 5d65c634d301..a51ed0c615bf 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -44,7 +44,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			kvm_riscv_vcpu_sbi_forward(vcpu, run);
>  			*exit = true;
>  		} else
> -			*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
> +			*out_val = kvm_vcpu_sbi_find_ext(vcpu, cp->a0) ? 1 : 0;
>  		break;
>  	case SBI_EXT_BASE_GET_MVENDORID:
>  		*out_val = vcpu->arch.mvendorid;
> -- 
> 2.34.1
>

Other than the EINVAL / ENOENT comment and the nits and stuff that can be
done later, this looks good to me, so

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
