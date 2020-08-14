Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2603B2449AA
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgHNMUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 08:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgHNMUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 08:20:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A7B20B1F;
        Fri, 14 Aug 2020 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597407615;
        bh=WRJyherRjLrCaZgbzjavfajQO8Ry3yRQJoXHt7KW0Fs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tCCUfWdFl60w2kum7ODRJLIRWxzhrBW63N0ZniMzJMnD2Tdh4kbUd0ar+GnSK4tWK
         yu9a/mnnBNbV7Bv6a5qNWWtmb2yeDX7XcQTM1BWTHtGx5QdpMHyIsnjrAFmz3NmGko
         eOPTHtTikh3N2fC8928L216OwCvbVPWrQVgmEqTc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k6Ygv-0029eY-6N; Fri, 14 Aug 2020 13:20:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 Aug 2020 13:20:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Peng Liang <liangpeng10@huawei.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org,
        zhang.zhanghailiang@huawei.com, xiexiangyou@huawei.com
Subject: Re: [RFC 2/4] kvm: arm64: emulate the ID registers
In-Reply-To: <20200813060517.2360048-3-liangpeng10@huawei.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-3-liangpeng10@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <08de5a7ea8d371a5328044cb2039ea83@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: liangpeng10@huawei.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, zhang.zhanghailiang@huawei.com, xiexiangyou@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-13 07:05, Peng Liang wrote:
> To emulate the ID registers, we need a place to storage the values of
> the ID regsiters.  Maybe putting in kvm_arch_vcpu is a good idea.
> 
> This commit has no functional changes but only code refactor.  When
> initializing a vcpu, get the values of the ID registers from
> arm64_ftr_regs and storage them in kvm_arch_vcpu.  And we just read
> the value from kvm_arch_vcpu when getting/setting the value of the ID
> regs.
> 
> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/arm.c              | 20 ++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c         | 27 +++++++++++++++++++++++----
>  include/uapi/linux/kvm.h          | 11 +++++++++++
>  4 files changed, 56 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index f81151ad3d3c..7f7bd36702f7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -336,6 +336,8 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +
> +	struct id_registers idregs;

System registers are to be stored in the sysreg file. I've already
spent enough time moving them out of the various subsystems.

>  };
> 
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 73e12869afe3..18ebbe1c64ee 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -262,6 +262,24 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm,
> unsigned int id)
>  	return 0;
>  }
> 
> +static int get_cpu_ftr(u32 id, u64 val, void *argp)
> +{
> +	struct id_registers *idregs = argp;
> +
> +	/*
> +	 * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> +	 * where 1<=crm<8, 0<=op2<8.
> +	 */
> +	if (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
> +	    sys_reg_CRn(id) == 0 && sys_reg_CRm(id) > 0) {
> +		idregs->regs[idregs->num].sys_id = id;
> +		idregs->regs[idregs->num].sys_val = val;
> +		idregs->num++;
> +	}
> +
> +	return 0;
> +}
> +
>  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>  	int err;
> @@ -285,6 +303,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (err)
>  		return err;
> 
> +	arm64_cpu_ftr_regs_traverse(get_cpu_ftr, &vcpu->arch.idregs);
> +
>  	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
>  }
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 138961d7ebe3..776c2757a01e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1092,13 +1092,32 @@ static bool access_arch_timer(struct kvm_vcpu 
> *vcpu,
>  	return true;
>  }
> 
> +static struct id_reg_info *kvm_id_reg(struct kvm_vcpu *vcpu, u64 id)
> +{
> +	int i;
> +
> +	for (i = 0; i < vcpu->arch.idregs.num; ++i) {
> +		if (vcpu->arch.idregs.regs[i].sys_id == id)
> +			return &vcpu->arch.idregs.regs[i];
> +	}
> +	return NULL;
> +}
> +
> +static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, u64 id)
> +{
> +	struct id_reg_info *ri = kvm_id_reg(vcpu, id);
> +
> +	BUG_ON(!ri);
> +	return ri->sys_val;
> +}
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> +static u64 read_id_reg(struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
>  {
>  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> -	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> +	u64 val = raz ? 0 : kvm_get_id_reg(vcpu, id);
> 
>  	if (id == SYS_ID_AA64PFR0_EL1) {
>  		if (!vcpu_has_sve(vcpu))
> @@ -1238,7 +1257,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu 
> *vcpu,
>   * are stored, and for set_id_reg() we don't allow the effective value
>   * to be changed.
>   */
> -static int __get_id_reg(const struct kvm_vcpu *vcpu,
> +static int __get_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
> @@ -1248,7 +1267,7 @@ static int __get_id_reg(const struct kvm_vcpu 
> *vcpu,
>  	return reg_to_user(uaddr, &val, id);
>  }
> 
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +static int __set_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f6d86033c4fa..1029444d04aa 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1272,6 +1272,17 @@ struct kvm_vfio_spapr_tce {
>  	__s32	tablefd;
>  };
> 
> +#define ID_REG_MAX_NUMS 64
> +struct id_reg_info {
> +	uint64_t sys_id;
> +	uint64_t sys_val;
> +};
> +
> +struct id_registers {
> +	struct id_reg_info regs[ID_REG_MAX_NUMS];
> +	uint64_t num;
> +};
> +
>  /*
>   * ioctls for VM fds
>   */

No way this is an acceptable interface. We have the one-reg interface,
which takes a system register encoding.

         M.
-- 
Jazz is not dead. It just smells funny...
