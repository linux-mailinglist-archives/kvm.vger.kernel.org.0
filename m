Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F96D21A3
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbjCaNrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCaNrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:47:20 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B375D468F
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:47:18 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x3so89746895edb.10
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680270437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0mLh+XUTx4g87iH06ThLncQPc7iUTCzoPcHW2jAuS0Y=;
        b=RIWgMJTKPkbR7DmLcPs9WpKgalexcaM0TTMbhXtyaJ74pIRvxvJpbKH+CiEbQQfxDt
         yQXNIBwmQeZtFiPnX8r5xdEDxRdyB+S8ECVu00yEIhOPgbbdID83JeRaZ9KQ7O9Nt28l
         DZ7xA2Lz4YUgEdqAIrxnNnC3fHCjl0RBnNKhZ4kfrnmzFDNTgo4mF2kWAAvuLlKWIc0s
         p251yw8kYKv1sCR+gGYZpKskOJPB9LsYWCWVJGGMfwOBef4JiMlU28X89+6H3iq6Qx0t
         RiVpLtodbBkv+CfysCBfJbXP5jWqYXzpzc+qd0ZE1TcFV5R/H28JdMLvLH8SRk8zwczv
         LE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680270437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0mLh+XUTx4g87iH06ThLncQPc7iUTCzoPcHW2jAuS0Y=;
        b=SRX4UV9uHlrakH0GOZuz8COnSLjxDpFRiBjtykD8Exi0RcQoEug7Y/Kpow5bEqp+hw
         EySg77RnO4/RyGfKERQztNe31g6qAtyr55OiBXm3GOdV+Mvovw2LwXYdyuuxamfmHgii
         7sOjBqGlWywaMv7izyuRE+pLxoTLqjABDLIS5s8KH4ZJP10hQwjiWTYaugbzNvTPArLr
         NYlKANzq7dHubLBX3/NkbTNtkVhmbA+WzWB5XJPwHvttch7ANpDHtlLoUddw6/QhH81X
         2Kc7oRytC1CDzvH+Oj3pciVOxTjM0DfS4OYEMMBfba3joKbzZowGnlLPDm1pyY1RFQ+g
         l7Jg==
X-Gm-Message-State: AAQBX9fg5XqXjyFtIXjK/dIKJDJIX79SmOjUwsUw9YH7QUWec13784kH
        SHfozssPNsZl2fdM47z0UpZyXw==
X-Google-Smtp-Source: AKy350ZRp8030l2Cdvye899p50zpajWeCx8jna8pTvFo68tfQis8l8vp2ise6WlEq2cuqJL6ud7RwA==
X-Received: by 2002:aa7:d611:0:b0:502:30e6:1e47 with SMTP id c17-20020aa7d611000000b0050230e61e47mr21884058edr.13.1680270437189;
        Fri, 31 Mar 2023 06:47:17 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id i24-20020a508718000000b005024aff3bb5sm1065384edb.80.2023.03.31.06.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:47:16 -0700 (PDT)
Date:   Fri, 31 Mar 2023 15:47:15 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] RISC-V: KVM: Add ONE_REG interface to
 enable/disable SBI extensions
Message-ID: <a5b4bt6pggh42iaenmtwpjyniues2s2w33umrz2akn5gs67ndr@4medbq2mil6a>
References: <20230331123655.1991260-1-apatel@ventanamicro.com>
 <20230331123655.1991260-2-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331123655.1991260-2-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023 at 06:06:55PM +0530, Anup Patel wrote:
> We add ONE_REG interface to enable/disable SBI extensions (just
> like the ONE_REG interface for ISA extensions). This allows KVM
> user-space to decide the set of SBI extension enabled for a Guest
> and by default all SBI extensions are enabled.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
>  arch/riscv/include/uapi/asm/kvm.h     |  32 ++++
>  arch/riscv/kvm/vcpu.c                 |   2 +
>  arch/riscv/kvm/vcpu_sbi.c             | 245 ++++++++++++++++++++++++--
>  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
>  5 files changed, 270 insertions(+), 19 deletions(-)
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

This could be a bitmap too, but maybe we can defer the conversion until
later when there are more SBI extensions.

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
> index 92af6f3f057c..d8ead5952ed9 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -12,6 +12,7 @@
>  #ifndef __ASSEMBLY__
>  
>  #include <linux/types.h>
> +#include <asm/bitsperlong.h>
>  #include <asm/ptrace.h>
>  
>  #define __KVM_HAVE_READONLY_MEM
> @@ -108,6 +109,23 @@ enum KVM_RISCV_ISA_EXT_ID {
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
> @@ -118,6 +136,8 @@ enum KVM_RISCV_ISA_EXT_ID {
>  /* If you need to interpret the index values, here is the key: */
>  #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
>  #define KVM_REG_RISCV_TYPE_SHIFT	24
> +#define KVM_REG_RISCV_SUBTYPE_MASK	0x0000000000FF0000
> +#define KVM_REG_RISCV_SUBTYPE_SHIFT	16
>  
>  /* Config registers are mapped as type 1 */
>  #define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
> @@ -152,6 +172,18 @@ enum KVM_RISCV_ISA_EXT_ID {
>  /* ISA Extension registers are mapped as type 7 */
>  #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
>  
> +/* SBI extension registers are mapped as type 8 */
> +#define KVM_REG_RISCV_SBI_EXT		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
> +#define KVM_REG_RISCV_SBI_SINGLE	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
> +#define KVM_REG_RISCV_SBI_MULTI_EN	(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
> +#define KVM_REG_RISCV_SBI_MULTI_DIS	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
> +#define KVM_REG_RISCV_SBI_MULTI_REG(__ext_id)	\
> +		((__ext_id) / __BITS_PER_LONG)
> +#define KVM_REG_RISCV_SBI_MULTI_MASK(__ext_id)	\
> +		(1UL << ((__ext_id) % __BITS_PER_LONG))
> +#define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
> +		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
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

Missing the kvm_riscv_vcpu_get_reg() change.

> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 15fde15f9fb8..89e3e7bace6c 100644
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
> @@ -99,14 +134,190 @@ int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	return 0;
>  }
>  
> -const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid)
> +static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
> +					 unsigned long reg_num,
> +					 unsigned long reg_val)
> +{
> +	unsigned long i;
> +	const struct kvm_riscv_sbi_extension_entry *sext = NULL;
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> +
> +	if (reg_num >= KVM_RISCV_SBI_EXT_MAX ||
> +	    (reg_val != 1 && reg_val != 0))
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
> +	scontext->extension_disabled[sext->dis_idx] = !reg_val;
> +
> +	return 0;
> +}
> +
> +static int riscv_vcpu_get_sbi_ext_single(struct kvm_vcpu *vcpu,
> +					 unsigned long reg_num,
> +					 unsigned long *reg_val)
> +{
> +	unsigned long i;
> +	const struct kvm_riscv_sbi_extension_entry *sext = NULL;
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
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
> +	*reg_val = !scontext->extension_disabled[sext->dis_idx];
> +
> +	return 0;
> +}
> +
> +static int riscv_vcpu_set_sbi_ext_multi(struct kvm_vcpu *vcpu,
> +					unsigned long reg_num,
> +					unsigned long reg_val, bool enable)
> +{
> +	unsigned long i, ext_id;
> +
> +	if (reg_num > KVM_REG_RISCV_SBI_MULTI_REG_LAST)
> +		return -EINVAL;
> +
> +	for_each_set_bit(i, &reg_val, BITS_PER_LONG) {
> +		ext_id = i + reg_num * BITS_PER_LONG;
> +		if (ext_id >= KVM_RISCV_SBI_EXT_MAX)
> +			break;
> +
> +		riscv_vcpu_set_sbi_ext_single(vcpu, ext_id, enable);
> +	}
> +
> +	return 0;
> +}
> +
> +static int riscv_vcpu_get_sbi_ext_multi(struct kvm_vcpu *vcpu,
> +					unsigned long reg_num,
> +					unsigned long *reg_val)
> +{
> +	unsigned long i, ext_id, ext_val;
> +
> +	if (reg_num > KVM_REG_RISCV_SBI_MULTI_REG_LAST)
> +		return -EINVAL;
> +
> +	for (i = 0; i < BITS_PER_LONG; i++) {
> +		ext_id = i + reg_num * BITS_PER_LONG;
> +		if (ext_id >= KVM_RISCV_SBI_EXT_MAX)
> +			break;
> +
> +		ext_val = 0;
> +		riscv_vcpu_get_sbi_ext_single(vcpu, ext_id, &ext_val);
> +		if (ext_val)
> +			*reg_val |= KVM_REG_RISCV_SBI_MULTI_MASK(ext_id);
> +	}
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	unsigned long __user *uaddr =
> +			(unsigned long __user *)(unsigned long)reg->addr;
> +	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +					    KVM_REG_SIZE_MASK |
> +					    KVM_REG_RISCV_SBI_EXT);
> +	unsigned long reg_val, reg_subtype;
> +
> +	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +		return -EINVAL;
> +
> +	if (vcpu->arch.ran_atleast_once)
> +		return -EBUSY;
> +
> +	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> +	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
> +
> +	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
> +
> +	switch (reg_subtype) {
> +	case KVM_REG_RISCV_SBI_SINGLE:
> +		return riscv_vcpu_set_sbi_ext_single(vcpu, reg_num, reg_val);
> +	case KVM_REG_RISCV_SBI_MULTI_EN:
> +		return riscv_vcpu_set_sbi_ext_multi(vcpu, reg_num, reg_val, true);
> +	case KVM_REG_RISCV_SBI_MULTI_DIS:
> +		return riscv_vcpu_set_sbi_ext_multi(vcpu, reg_num, reg_val, false);
> +	default:
> +		return -EINVAL;
> +	};
> +
> +	return 0;
> +}
> +
> +int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
> +				   const struct kvm_one_reg *reg)
> +{
> +	int rc;
> +	unsigned long __user *uaddr =
> +			(unsigned long __user *)(unsigned long)reg->addr;
> +	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
> +					    KVM_REG_SIZE_MASK |
> +					    KVM_REG_RISCV_SBI_EXT);
> +	unsigned long reg_val, reg_subtype;
> +
> +	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
> +		return -EINVAL;
> +
> +	reg_subtype = reg_num & KVM_REG_RISCV_SUBTYPE_MASK;
> +	reg_num &= ~KVM_REG_RISCV_SUBTYPE_MASK;
> +
> +	reg_val = 0;
> +	switch (reg_subtype) {
> +	case KVM_REG_RISCV_SBI_SINGLE:
> +		rc = riscv_vcpu_get_sbi_ext_single(vcpu, reg_num, &reg_val);
> +		break;
> +	case KVM_REG_RISCV_SBI_MULTI_EN:
> +	case KVM_REG_RISCV_SBI_MULTI_DIS:
> +		rc = riscv_vcpu_get_sbi_ext_multi(vcpu, reg_num, &reg_val);

It seems odd that a user calling GET(KVM_REG_RISCV_SBI_MULTI_DIS) will get
all the enabled extensions.

> +		break;
> +	default:
> +		rc = -EINVAL;
> +	};
> +	if (rc)
> +		return rc;
> +
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
> @@ -126,7 +337,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
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

Thanks,
drew
