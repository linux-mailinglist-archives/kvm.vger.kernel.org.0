Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B8A42F1BF
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 15:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239289AbhJONLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 09:11:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47636 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235689AbhJONL3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 09:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634303362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BLbKqYqpIN8Ja2kVeWEWl5tGGqw23sSzKTE1tUG4uzk=;
        b=IPIcPkuaYJErwVCzDqhfYPFaoWre8l9sDXOwfl0nwtzJf6FWEFUv7XryCOmNUYysh/a0Jq
        Tc1iCPQxIXE7Vuwi+bQ/c6n7voPcrmlZvnNIvMwprBaNAylA2dsKxFFOimVT2ABEs2y+sg
        RdLGceJJfGcVOobhFeKucwynyefrtTI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405--Tud8UXNMXCiXYGkWD5-BA-1; Fri, 15 Oct 2021 09:09:21 -0400
X-MC-Unique: -Tud8UXNMXCiXYGkWD5-BA-1
Received: by mail-wm1-f71.google.com with SMTP id z26-20020a05600c221a00b0030da55bc454so658791wml.4
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 06:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BLbKqYqpIN8Ja2kVeWEWl5tGGqw23sSzKTE1tUG4uzk=;
        b=f/EdPzYn74LOmUeuqo4xgR4WlHImQ2mjQeMj3t/WtnjX2AHTidNN2+VqMPsKJecGfz
         jasfzMwa1zQJ89gh2PQpe8l/XKMOVIs2Q2gl7MleEjgxmX/oAS5gGvIZFO+SZvrXlYd/
         8YDqyVZ9yKzuUY+0B8TmpSAXqiDRqm6ZMoTHJKxl7CjOMOc80Uj44vMvlV8nmzmqsh7C
         9x92hLOgo3FRdsQZW6VtlxiDA6tTefUZxDk1fy6fccg/wCPZ3U7eRCMDrsNG431aUI+F
         l/+R/9oJ9WOKeruWuBe/y03s39JVCzxa2aeyRmnyNRr5hxTR2o/OG2nXXPp5XKPwcXmM
         gY4w==
X-Gm-Message-State: AOAM532EwEBGmYvY3vR2dcIE595LA1HkvTmg5nzP1OV8w3DRIrLdl9GE
        V9PCpa97vHFzSTAn5nvkMqWMDNew7rBP+4m4ASeyseVEtOEcI8VB6i1fVIirq87vCmKyQ0k0hwD
        jMPVMvrY234Gj
X-Received: by 2002:a5d:6e8d:: with SMTP id k13mr14355107wrz.295.1634303360402;
        Fri, 15 Oct 2021 06:09:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxic2R6KXXZZ57/dhqX3xAovzW11pgEB61Y/9hhSMf4P+hqbB1TynbVpy39qNRQfsYQIVpJmg==
X-Received: by 2002:a5d:6e8d:: with SMTP id k13mr14355062wrz.295.1634303360180;
        Fri, 15 Oct 2021 06:09:20 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id v10sm5197903wri.29.2021.10.15.06.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 06:09:19 -0700 (PDT)
Date:   Fri, 15 Oct 2021 15:09:18 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value
 per vCPU
Message-ID: <20211015130918.ezlygga73doepbw6@gator>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-3-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012043535.500493-3-reijiw@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 11, 2021 at 09:35:12PM -0700, Reiji Watanabe wrote:
> Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> registers' sanitized value in the array for the vCPU at the first
> vCPU reset. Use the saved ones when ID registers are read by
> userspace (via KVM_GET_ONE_REG) or the guest.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
>  arch/arm64/kvm/sys_regs.c         | 26 ++++++++++++++++++--------
>  2 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9b5e7a3b6011..0cd351099adf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
>  	u64 disr_el1;		/* Deferred [SError] Status Register */
>  };
>  
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.

crm is 4 bits, so this should be 0 <= crm < 16 and...

> + */
> +#define KVM_ARM_ID_REG_MAX_NUM 64

...this should be 128. Or am I missing something?


> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +#define IDREG_SYS_IDX(id)	(ID_REG_BASE + IDREG_IDX(id))
> +
>  enum vcpu_sysreg {
>  	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
>  	MPIDR_EL1,	/* MultiProcessor Affinity Register */
> @@ -209,6 +217,8 @@ enum vcpu_sysreg {
>  	CNTP_CVAL_EL0,
>  	CNTP_CTL_EL0,
>  
> +	ID_REG_BASE,
> +	ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
>  	/* Memory Tagging Extension registers */
>  	RGSR_EL1,	/* Random Allocation Tag Seed Register */
>  	GCR_EL1,	/* Tag Control Register */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1d46e185f31e..72ca518e7944 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> +	u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
>  	u32 sr = reg_to_encoding(r);
>  
>  	if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> @@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
>  {
>  	u32 id = reg_to_encoding(r);
> -	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> +	u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
>  
>  	switch (id) {
>  	case SYS_ID_AA64PFR0_EL1:
> @@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  	return REG_HIDDEN;
>  }
>  
> +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)

Since not all ID registers will use this, then maybe name it
reset_sanitised_id_reg?

> +{
> +	u32 id = reg_to_encoding(rd);
> +
> +	if (vcpu_has_reset_once(vcpu))
> +		return;

Ah, I see my kvm_vcpu_initialized() won't work since vcpu->arch.target is
set before the first reset. While vcpu->arch.target is only being used
like a "is_initialized" boolean at this time, I guess we better keep it
in case we ever want to implement CPU models (which this series gets us a
step closer to). 

> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> +}
> +
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  			       const struct sys_reg_desc *rd,
>  			       const struct kvm_one_reg *reg, void __user *uaddr)
> @@ -1219,9 +1228,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
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
> @@ -1375,6 +1382,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
>  	.access	= access_id_reg,		\
> +	.reset	= reset_id_reg,			\
>  	.get_user = get_id_reg,			\
>  	.set_user = set_id_reg,			\
>  	.visibility = id_visibility,		\
> @@ -1830,8 +1838,10 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		return ignore_write(vcpu, p);
>  	} else {
> -		u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> -		u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +		u64 dfr = __vcpu_sys_reg(vcpu,
> +					 IDREG_SYS_IDX(SYS_ID_AA64DFR0_EL1));
> +		u64 pfr = __vcpu_sys_reg(vcpu,
> +					 IDREG_SYS_IDX(SYS_ID_AA64PFR0_EL1));

Please avoid these ugly line breaks when we're well under Linux's max
length, which is 100.

>  		u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>  
>  		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
> -- 
> 2.33.0.882.g93a45727a2-goog
>

Thanks,
drew

