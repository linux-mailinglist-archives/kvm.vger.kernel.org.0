Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C078A5E09D
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 11:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfGCJLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 05:11:07 -0400
Received: from foss.arm.com ([217.140.110.172]:41974 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfGCJLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 05:11:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DE15344;
        Wed,  3 Jul 2019 02:11:02 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D43CF3F246;
        Wed,  3 Jul 2019 02:11:00 -0700 (PDT)
Subject: Re: [PATCH 28/59] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit
 setting
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-29-marc.zyngier@arm.com>
 <f19e36aa-2468-899c-6f7c-bc215e4128eb@arm.com>
Message-ID: <4e0f2630-2405-e0f2-c745-131e1027b3bc@arm.com>
Date:   Wed, 3 Jul 2019 10:10:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <f19e36aa-2468-899c-6f7c-bc215e4128eb@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/2/19 5:32 PM, Alexandru Elisei wrote:
> On 6/21/19 10:38 AM, Marc Zyngier wrote:
>> From: Jintack Lim <jintack@cs.columbia.edu>
>>
>> Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
>> virtual HCR_EL2.NV bit is set.
> HCR_EL2.NV1?
>> This is for recursive nested virtualization.
>>
>> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_arm.h |  1 +
>>  arch/arm64/kvm/sys_regs.c        | 19 +++++++++++++++++--
>>  2 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index d21486274eeb..55f4525c112c 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -24,6 +24,7 @@
>>  
>>  /* Hyp Configuration Register (HCR) bits */
>>  #define HCR_FWB		(UL(1) << 46)
>> +#define HCR_NV1		(UL(1) << 43)
>>  #define HCR_NV		(UL(1) << 42)
>>  #define HCR_API		(UL(1) << 41)
>>  #define HCR_APK		(UL(1) << 40)
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 0f74b9277a86..beadebcfc888 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -473,8 +473,10 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>>  		return false;
>>  
>> -	if (!el12_reg(p) && forward_vm_traps(vcpu, p))
>> -		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +	if (!el12_reg(p) && forward_vm_traps(vcpu, p)) {
>> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>> +		return false;
>> +	}
>>  
>>  	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
>>  
>> @@ -1643,6 +1645,13 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>>  	return true;
>>  }
>>  
>> +
>> +/* This function is to support the recursive nested virtualization */
>> +static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> Why the struct sys_reg_params *p argument? It isn't used by the function.
>> +{
>> +	return forward_traps(vcpu, HCR_NV1);
>> +}
>> +
>>  static bool access_elr(struct kvm_vcpu *vcpu,
>>  		       struct sys_reg_params *p,
>>  		       const struct sys_reg_desc *r)
>> @@ -1650,6 +1659,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
>>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>>  		return false;
>>  
>> +	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
>> +		return false;
>> +
>>  	if (p->is_write)
>>  		vcpu->arch.ctxt.gp_regs.elr_el1 = p->regval;
>>  	else
>> @@ -1665,6 +1677,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>>  		return false;
>>  
>> +	if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
>> +		return false;
>> +
>>  	if (p->is_write)
>>  		vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1] = p->regval;
>>  	else
> The commit message mentions VBAR_EL1, but there's no change related to it.
> Parhaps you're missing this (build tested only):
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index bd21f0f45a86..082dc31ff533 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -401,6 +401,12 @@ static bool el12_reg(struct sys_reg_params *p)
>         return (p->Op1 == 5);
>  }
>  
> +/* This function is to support the recursive nested virtualization */
> +static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> +{
> +       return forward_traps(vcpu, HCR_NV1);
> +}
> +
>  static bool access_rw(struct kvm_vcpu *vcpu,
>                       struct sys_reg_params *p,
>                       const struct sys_reg_desc *r)
> @@ -408,6 +414,10 @@ static bool access_rw(struct kvm_vcpu *vcpu,
>         if (el12_reg(p) && forward_nv_traps(vcpu))
>                 return false;
>  
> +       if (sys_reg(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2) == SYS_VBAR_EL1 &&
> +           forward_nv1_traps(vcpu, p))

Ahem... this is probably better:

+       if (r->reg == VBAR_EL1 && forward_nv1_traps(vcpu, p))

> +               return false;
> +
>         if (p->is_write)
>                 vcpu_write_sys_reg(vcpu, p->regval, r->reg);
>         else
> @@ -1794,12 +1804,6 @@ static bool forward_ttlb_traps(struct kvm_vcpu *vcpu)
>         return forward_traps(vcpu, HCR_TTLB);
>  }
>  
> -/* This function is to support the recursive nested virtualization */
> -static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> -{
> -       return forward_traps(vcpu, HCR_NV1);
> -}
> -
>  static bool access_elr(struct kvm_vcpu *vcpu,
>                        struct sys_reg_params *p,
>                        const struct sys_reg_desc *r)
>
