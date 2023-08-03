Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E477476F04B
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 19:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbjHCRFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 13:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjHCRFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 13:05:52 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCFA30D2
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 10:05:50 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99bf3f59905so166405366b.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691082349; x=1691687149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCXp7bnCQeJHembOcEQXDYLfhb8aJsvFXnOpWD7E2ZA=;
        b=nkbuVCky5eIYut5xJfnpTwEyqc7rBKJjKYsn6N3/A4qUDKOJ9tlAot8cNOq/SqrbOE
         bQ8cWWtVX56qnPCTpkOmEN58TXAcfFPqvLA6MDO4Kz9L5985cKntVWU4sTsaD3nB5d36
         aNkzGLVPOz8g0uVIRmfajzjCZZxv8uGw98ALm/GwDAkBVL9xkGKrYN0XLzcQm51xoCJY
         Vr0HvJu5qtSYxM02ER/JrWhjjf00aXiPPNsXpJHScL77h/eFgt/0O/3/prc3JwcOhUEx
         ieEsQx33jq0VSNoyRfC0uSBQw+qFbdZsFJcajFJRym4gM743qnBfuTO4PaULUeDTos4j
         dFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691082349; x=1691687149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCXp7bnCQeJHembOcEQXDYLfhb8aJsvFXnOpWD7E2ZA=;
        b=h4mvOfe3uKSCJ9nIIKgxsXvswWdelVL+zKDUYdmc+tmaHBnm1j5WW+ZyXnaACJagLV
         ANjw/cqV+9P8R5ZbvpI2EmXHp4ti0DCVgQVU3EVD6o3K32wuBlq5yLWjMLpmsp2c/URn
         4M1jZhbPjV6c4Om/ZPtZ092MQ6NU5VT7TbG6HqdLXbatRp6SQWTrtdx/SaIdtpK2b9MB
         9EwdkwwAReOguXkyAWI8Dxoo2aELi5ooQa7VrKqHLAXFxp1gDi5KZ+DmUlbkjy/3ztgw
         GD15ATG7Vzh1cVchVIiX4TK21lXA+yTZcBBk1t2P+4hAYsTMjGE2AjfrQg4+oPLEKfte
         oXsw==
X-Gm-Message-State: ABy/qLYLd/Vc4jXCLDPp0egTf002B6yTWy6vMZLnL9ZfqRD0UIgYqTQP
        4qk8qJOiGp4USDS/caKOb4jk0A==
X-Google-Smtp-Source: APBJJlG+zs5JImt9tHG4hc3+8c7LBgiyeeRh3j9Z3j3hqFOE5to+atpc30mSVh/tLX/dKoTvmROn7Q==
X-Received: by 2002:a17:907:7841:b0:993:22a2:8158 with SMTP id lb1-20020a170907784100b0099322a28158mr8135032ejc.61.1691082348817;
        Thu, 03 Aug 2023 10:05:48 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id i14-20020a170906114e00b00992dcae806bsm84195eja.5.2023.08.03.10.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 10:05:48 -0700 (PDT)
Date:   Thu, 3 Aug 2023 20:05:47 +0300
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org
Subject: Re: [PATCH v4 09/10] RISC-V: KVM: Improve vector save/restore errors
Message-ID: <20230803-b656c44ee07d661600b8696a@orel>
References: <20230803163302.445167-1-dbarboza@ventanamicro.com>
 <20230803163302.445167-10-dbarboza@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803163302.445167-10-dbarboza@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 01:33:01PM -0300, Daniel Henrique Barboza wrote:
> From: Andrew Jones <ajones@ventanamicro.com>
> 
> kvm_riscv_vcpu_(get/set)_reg_vector() now returns ENOENT if V is not
> available, EINVAL if reg type is not of VECTOR type, and any error that
> might be thrown by kvm_riscv_vcpu_vreg_addr().
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_vector.c | 60 ++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_vector.c b/arch/riscv/kvm/vcpu_vector.c
> index edd2eecbddc2..39c5bceb4d1b 100644
> --- a/arch/riscv/kvm/vcpu_vector.c
> +++ b/arch/riscv/kvm/vcpu_vector.c
> @@ -91,44 +91,44 @@ void kvm_riscv_vcpu_free_vector_context(struct kvm_vcpu *vcpu)
>  }
>  #endif
>  
> -static void *kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
> +static int kvm_riscv_vcpu_vreg_addr(struct kvm_vcpu *vcpu,
>  				      unsigned long reg_num,
> -				      size_t reg_size)
> +				      size_t reg_size,
> +				      void **reg_val)
>  {
>  	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> -	void *reg_val;
>  	size_t vlenb = riscv_v_vsize / 32;
>  
>  	if (reg_num < KVM_REG_RISCV_VECTOR_REG(0)) {
>  		if (reg_size != sizeof(unsigned long))
> -			return NULL;
> +			return -EINVAL;
>  		switch (reg_num) {
>  		case KVM_REG_RISCV_VECTOR_CSR_REG(vstart):
> -			reg_val = &cntx->vector.vstart;
> +			*reg_val = &cntx->vector.vstart;
>  			break;
>  		case KVM_REG_RISCV_VECTOR_CSR_REG(vl):
> -			reg_val = &cntx->vector.vl;
> +			*reg_val = &cntx->vector.vl;
>  			break;
>  		case KVM_REG_RISCV_VECTOR_CSR_REG(vtype):
> -			reg_val = &cntx->vector.vtype;
> +			*reg_val = &cntx->vector.vtype;
>  			break;
>  		case KVM_REG_RISCV_VECTOR_CSR_REG(vcsr):
> -			reg_val = &cntx->vector.vcsr;
> +			*reg_val = &cntx->vector.vcsr;
>  			break;
>  		case KVM_REG_RISCV_VECTOR_CSR_REG(datap):
>  		default:
> -			return NULL;
> +			return -ENOENT;
>  		}
>  	} else if (reg_num <= KVM_REG_RISCV_VECTOR_REG(31)) {
>  		if (reg_size != vlenb)
> -			return NULL;
> -		reg_val = cntx->vector.datap
> +			return -EINVAL;
> +		*reg_val = cntx->vector.datap
>  			  + (reg_num - KVM_REG_RISCV_VECTOR_REG(0)) * vlenb;
>  	} else {
> -		return NULL;
> +		return -ENOENT;
>  	}
>  
> -	return reg_val;
> +	return 0;
>  }
>  
>  int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
> @@ -141,17 +141,20 @@ int kvm_riscv_vcpu_get_reg_vector(struct kvm_vcpu *vcpu,
>  	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
>  					    KVM_REG_SIZE_MASK |
>  					    rtype);
> -	void *reg_val = NULL;
>  	size_t reg_size = KVM_REG_SIZE(reg->id);
> +	void *reg_val;
> +	int rc;
>  
> -	if (rtype == KVM_REG_RISCV_VECTOR &&
> -	    riscv_isa_extension_available(isa, v)) {
> -		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
> -	}
> -
> -	if (!reg_val)
> +	if (rtype != KVM_REG_RISCV_VECTOR)
>  		return -EINVAL;
>  
> +	if (!riscv_isa_extension_available(isa, v))
> +		return -ENOENT;
> +
> +	rc = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size, &reg_val);
> +	if (rc)
> +		return rc;
> +
>  	if (copy_to_user(uaddr, reg_val, reg_size))
>  		return -EFAULT;
>  
> @@ -168,17 +171,20 @@ int kvm_riscv_vcpu_set_reg_vector(struct kvm_vcpu *vcpu,
>  	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
>  					    KVM_REG_SIZE_MASK |
>  					    rtype);
> -	void *reg_val = NULL;
>  	size_t reg_size = KVM_REG_SIZE(reg->id);
> +	void *reg_val;
> +	int rc;
>  
> -	if (rtype == KVM_REG_RISCV_VECTOR &&
> -	    riscv_isa_extension_available(isa, v)) {
> -		reg_val = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size);
> -	}
> -
> -	if (!reg_val)
> +	if (rtype != KVM_REG_RISCV_VECTOR)
>  		return -EINVAL;
>  
> +	if (!riscv_isa_extension_available(isa, v))
> +		return -ENOENT;
> +
> +	rc = kvm_riscv_vcpu_vreg_addr(vcpu, reg_num, reg_size, &reg_val);
> +	if (rc)
> +		return rc;
> +
>  	if (copy_from_user(reg_val, uaddr, reg_size))
>  		return -EFAULT;

Ugh, this is totally wrong. We no longer set the register. I need to
rework this rework...

