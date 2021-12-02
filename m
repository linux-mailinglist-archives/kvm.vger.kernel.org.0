Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE84661D6
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 11:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357087AbhLBLCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 06:02:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356693AbhLBLCQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 06:02:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638442734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wRIl4oD7Y5fkUN5tfay4kekz4HgS1IifoWLggGlVW1I=;
        b=PqTU0J2QvLYOTWuMuXOYgSfWcNEfElkSvQjzdV82ylVbk8FmneTiTArWGLGE0m+kcC1fMT
        YrT4lthFlI0Dqh+XGdtq2825o+Jl3uu4KifjIxmCljcey+QeFpyF51om+eB7ffSBgx3EeW
        YbA/0PpDC/X7Z97g5vTl6nrvqv5z/hI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-qA7IP1TAPFOYNs0UNunuhw-1; Thu, 02 Dec 2021 05:58:53 -0500
X-MC-Unique: qA7IP1TAPFOYNs0UNunuhw-1
Received: by mail-wr1-f69.google.com with SMTP id q17-20020adff791000000b00183e734ba48so4919166wrp.8
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 02:58:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wRIl4oD7Y5fkUN5tfay4kekz4HgS1IifoWLggGlVW1I=;
        b=MLKzriAo/oglQzmL2MLmHcglyKxXclFZcMmnoFak4NekrwwZ4GcpN97qEWd6SxnWmA
         81iMHs89FPgbQ65wUc7QgI4bWI7pGPJ0gJ1sJ+nyMy1bvoLSS4Wyn5XwHnFebe6dJGdU
         /y/Ho9IspXtmHGO8fg5Jw/o/UEsIYdqJbPB0It3Qs5uvBbOKqP/VE4cTS56ZSbzoeRLM
         6O1emh8wHoOCnyxdvgZqyyMMs+AzyfP0IW2wtgfdnNqjUzySetNutvNInMIBUslOurxz
         5/TOQfujyGpBun3C3uzjozVODs1kEpTeqrgZ3Kdr1jSDfN4cnapkhYDPN9HIJgvLA09J
         n7KA==
X-Gm-Message-State: AOAM5312Wy/mpQ6iJC6ONlfbYzc1lvdEpY2kCYR/ylAVeEGcu2qwFuBt
        7zacY8lRQhf91InT+Fc/oZWcj8oJEdeUeZFfis1ZP9cYgkJZAEe4hR2JNpVpqyyCEH3fTwORlNv
        5OAUdfHB4KPwu
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr13407439wrr.365.1638442732141;
        Thu, 02 Dec 2021 02:58:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdyKWGj2oyPnzq4Mdj75inkETU6TFWFE6xL8kZngxharwOb3Jh07jKn6KFiajYEjau2R9aEw==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr13407422wrr.365.1638442731933;
        Thu, 02 Dec 2021 02:58:51 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id c1sm2247743wrt.14.2021.12.02.02.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:58:51 -0800 (PST)
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-3-reijiw@google.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <9f6e8b7e-c2b3-5883-f934-5b537c4ce19b@redhat.com>
Date:   Thu, 2 Dec 2021 11:58:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211117064359.2362060-3-reijiw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> registers' sanitized value in the array for the vCPU at the first
> vCPU reset. Use the saved ones when ID registers are read by
> userspace (via KVM_GET_ONE_REG) or the guest.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 10 +++++++
>  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
>  2 files changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index edbe2cb21947..72db73c79403 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
>  	u64 disr_el1;		/* Deferred [SError] Status Register */
>  };
>  
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.
> + */
> +#define KVM_ARM_ID_REG_MAX_NUM 64
> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +#define IDREG_SYS_IDX(id)	(ID_REG_BASE + IDREG_IDX(id))
> +
>  enum vcpu_sysreg {
>  	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
>  	MPIDR_EL1,	/* MultiProcessor Affinity Register */
> @@ -210,6 +218,8 @@ enum vcpu_sysreg {
>  	CNTP_CVAL_EL0,
>  	CNTP_CTL_EL0,
>  
> +	ID_REG_BASE,
> +	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
>  	/* Memory Tagging Extension registers */
>  	RGSR_EL1,	/* Random Allocation Tag Seed Register */
>  	GCR_EL1,	/* Tag Control Register */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3ec1a44f94d..5608d3410660 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -33,6 +33,8 @@
>  
>  #include "trace.h"
>  
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> +
>  /*
>   * All of this file is extremely similar to the ARM coproc.c, but the
>   * types are different. My gut feeling is that it should be pretty
> @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>  	u32 sr = reg_to_encoding(r);
>  
>  	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> -		struct sys_reg_desc const *r, bool raz)
> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>  {
> -	u32 id = reg_to_encoding(r);
> -	u64 val;
> -
> -	if (raz)
> -		return 0;
> -
> -	val = read_sanitised_ftr_reg(id);
> +	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	return val;
>  }
>  
> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +		       struct sys_reg_desc const *r, bool raz)
> +{
> +	u32 id = reg_to_encoding(r);
> +
> +	return raz ? 0 : __read_id_reg(vcpu, id);
> +}
> +
>  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
>  				  const struct sys_reg_desc *r)
>  {
> @@ -1178,6 +1180,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> +{
> +	u32 id = reg_to_encoding(rd);
> +
> +	if (vcpu_has_reset_once(vcpu))
> +		return;
The KVM API allows to call VCPU_INIT several times (with same
target/feature). With above check on the second call the ID_REGS won't
be reset. Somehow this is aligned with target/feature behavior. However
if this is what we want, I think we would need to document it in the KVM
API doc.

Thanks

Eric
> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> +}
> +
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  			       const struct sys_reg_desc *rd,
>  			       const struct kvm_one_reg *reg, void __user *uaddr)
> @@ -1223,9 +1235,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  /*
>   * cpufeature ID register user accessors
>   *
> - * For now, these registers are immutable for userspace, so no values
> - * are stored, and for set_id_reg() we don't allow the effective value
> - * to be changed.
> + * We don't allow the effective value to be changed.
>   */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
> @@ -1382,6 +1392,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
>  	.access	= access_id_reg,		\
> +	.reset	= reset_id_reg,			\
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = id_visibility,		\
> @@ -1837,8 +1848,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> -		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +		u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> +		u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
>  		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
>  		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> 

