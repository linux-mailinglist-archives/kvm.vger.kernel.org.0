Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD546CFC30
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 09:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjC3HEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 03:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjC3HEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 03:04:48 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F4661BF
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 00:04:27 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so12463606wmq.2
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 00:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680159861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nRGiYGWRgIJrDplYiJC4OiBTDpjb4NhXXJybivPhzkU=;
        b=G5Z6DmgR420dgC0k7KbGQW2vFAwxyBVgh4e5fs4et3PuZ4Ex8/MujEnrcXDSSzsKpb
         uAIRBudKdy5FDt8SF5RSvwilIuvBzCiUEAJQQRNkDIMo6KvRZ5vl9Zc+JQPcaU2EofAK
         c/RW2LHVjix3T1nKHVrtsmhHciU+cgax9vqTk4994C3Mxp4AuyB7KlePtKvxIfVMZVG/
         2Juzs9sbXTqbDYRgVb0gTRsPxFimEIFPb5srSPJjSMSeb5b22cDbupxeWqizJzjsnFu7
         JRvwIPZ3ZaTt2rr5TwOr9tU9Av9xNMBOuq+RZeCshQxjLId2kF8vKvQB3OCM6+W5QVds
         vN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680159861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRGiYGWRgIJrDplYiJC4OiBTDpjb4NhXXJybivPhzkU=;
        b=0liYE0ZdJRZW3tKMCAktvPbuZWkcveaHX9Du+Z4126i6KOqgX24M+sbhRBS8KxT/kA
         dVW/Cif02Dt2RPa2NVHRBnPrsARn1bIW+l52LFj0zAshSgldbTGv8D1DOsBR0qjonNPs
         CVkagTF8rDOp1xWx+LRYOR1aKMYi+GUHBVGfJdroKaufyg8lrNdoVd+E6FTi3QsS/St4
         T/ycSEgk9t5OoJZFy3nT62v40CQKz18J52wUhcGJkrGcxOsjDZKdjzJVc24lSkwZmANd
         ea1lAtSv9bMhY4HOYSpGRAKroSL3e4SFjQrt7mcs7KIAFZu8Q0ldoguqL6HIcgSViRjU
         96Yw==
X-Gm-Message-State: AAQBX9dRBx27y30kS+CaQQaY3UMt8CMUYJ4uv3D01FJlyF7bh4Dkytru
        WTp/jxKl13hVRaoXxIsEyWV8dw==
X-Google-Smtp-Source: AKy350Y9dd/w3dLzY2picTM4Z/c+Qx2PWAavqOB3PR4TxjvReyxdswF+WuyQBNgLPl7Z+/oanWuEug==
X-Received: by 2002:a7b:c8c5:0:b0:3ef:62cd:1ef with SMTP id f5-20020a7bc8c5000000b003ef62cd01efmr12918593wml.25.1680159861145;
        Thu, 30 Mar 2023 00:04:21 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id i22-20020a05600c355600b003ede6540190sm5122800wmq.0.2023.03.30.00.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 00:04:20 -0700 (PDT)
Date:   Thu, 30 Mar 2023 09:04:19 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] RISC-V: KVM: Add ONE_REG interface to
 enable/disable SBI extensions
Message-ID: <7gtvgdxjwa662kfafnd5xrgugjt3w6iwv4w7rbrfeooviq2cnb@dqplsikshpzw>
References: <20230330053135.1686577-1-apatel@ventanamicro.com>
 <20230330053135.1686577-2-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330053135.1686577-2-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 11:01:35AM +0530, Anup Patel wrote:
> We add ONE_REG interface to enable/disable SBI extensions (just
> like the ONE_REG interface for ISA extensions). This allows KVM
> user-space to decide the set of SBI extension enabled for a Guest
> and by default all SBI extensions are enabled.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
>  arch/riscv/include/uapi/asm/kvm.h     |  20 ++++
>  arch/riscv/kvm/vcpu.c                 |   2 +
>  arch/riscv/kvm/vcpu_sbi.c             | 150 +++++++++++++++++++++++---
>  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
>  5 files changed, 163 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 8425556af7d1..4278125a38a5 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -16,6 +16,7 @@
>  
>  struct kvm_vcpu_sbi_context {
>  	int return_handled;
> +	bool extension_disabled[KVM_RISCV_SBI_EXT_MAX];
>  };
>  
>  struct kvm_vcpu_sbi_return {
> @@ -45,7 +46,12 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
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
> index 92af6f3f057c..33c3457b94e7 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -108,6 +108,23 @@ enum KVM_RISCV_ISA_EXT_ID {
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
> +	KVM_RISCV_SBI_EXT_PMU,
> +	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
> +	KVM_RISCV_SBI_EXT_VENDOR,
> +	KVM_RISCV_SBI_EXT_MAX,
> +};
> +
>  /* Possible states for kvm_riscv_timer */
>  #define KVM_RISCV_TIMER_STATE_OFF	0
>  #define KVM_RISCV_TIMER_STATE_ON	1
> @@ -152,6 +169,9 @@ enum KVM_RISCV_ISA_EXT_ID {
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
> index 7d010b0be54e..311fd347c5a8 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -601,6 +601,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
>  						 KVM_REG_RISCV_FP_D);
>  	case KVM_REG_RISCV_ISA_EXT:
>  		return kvm_riscv_vcpu_set_reg_isa_ext(vcpu, reg);
> +	case KVM_REG_RISCV_SBI_EXT:
> +		return kvm_riscv_vcpu_set_reg_sbi_ext(vcpu, reg);
>  	default:
>  		break;
>  	}
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 15fde15f9fb8..bedd7d78a5f0 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -30,17 +30,52 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_pmu = {
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
> -	&vcpu_sbi_ext_pmu,
> -	&vcpu_sbi_ext_experimental,
> -	&vcpu_sbi_ext_vendor,
> +struct kvm_riscv_sbi_extension_entry {
> +	enum KVM_RISCV_SBI_EXT_ID dis_idx;
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
> +		.dis_idx = KVM_RISCV_SBI_EXT_PMU,
> +		.ext_ptr = &vcpu_sbi_ext_pmu,
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
> @@ -99,14 +134,95 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
> @@ -126,7 +242,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	};
>  	bool ext_is_v01 = false;
>  
> -	sbi_ext = kvm_vcpu_sbi_find_ext(cp->a7);
> +	sbi_ext = kvm_vcpu_sbi_find_ext(vcpu, cp->a7);
>  	if (sbi_ext && sbi_ext->handler) {
>  #ifdef CONFIG_RISCV_SBI_V01
>  		if (cp->a7 >= SBI_EXT_0_1_SET_TIMER &&
> diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
> index 9945aff34c14..5bc570b984f4 100644
> --- a/arch/riscv/kvm/vcpu_sbi_base.c
> +++ b/arch/riscv/kvm/vcpu_sbi_base.c
> @@ -44,7 +44,7 @@ static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  			kvm_riscv_vcpu_sbi_forward(vcpu, run);
>  			retdata->uexit = true;
>  		} else {
> -			sbi_ext = kvm_vcpu_sbi_find_ext(cp->a0);
> +			sbi_ext = kvm_vcpu_sbi_find_ext(vcpu, cp->a0);
>  			*out_val = sbi_ext && sbi_ext->probe ?
>  					   sbi_ext->probe(vcpu) : !!sbi_ext;
>  		}
> -- 
> 2.34.1
>

This looks good, but I wonder if we shouldn't instead get/set a bitmap of
all SBI extension enables at once for scalability.

Thanks,
drew
