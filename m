Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20E216D63
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 15:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGGNEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 09:04:42 -0400
Received: from foss.arm.com ([217.140.110.172]:48200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgGGNEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 09:04:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 079AAC0A;
        Tue,  7 Jul 2020 06:04:41 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7D873F71E;
        Tue,  7 Jul 2020 06:04:38 -0700 (PDT)
Subject: Re: [PATCH v3 09/17] KVM: arm64: pauth: Use ctxt_sys_reg() instead of
 raw sys_regs access
To:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200706125425.1671020-1-maz@kernel.org>
 <20200706125425.1671020-10-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9689172f-a6c2-dd5b-6b0d-bbc1700cdb31@arm.com>
Date:   Tue, 7 Jul 2020 14:05:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706125425.1671020-10-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 7/6/20 1:54 PM, Marc Zyngier wrote:
> Now that we have a wrapper for the sysreg accesses, let's use that
> consistently.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 7cf14e4f9f77..70367699d69a 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -364,11 +364,14 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
>  	return false;
>  }
>  
> -#define __ptrauth_save_key(regs, key)						\
> -({										\
> -	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
> -	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
> -})
> +#define __ptrauth_save_key(ctxt, key)					\
> +	do {								\

Nitpick: the indentation for the do instruction doesn't match the indentation for
while(0).

> +	u64 __val;                                                      \
> +	__val = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);                \
> +	ctxt_sys_reg(ctxt, key ## KEYLO_EL1) = __val;                   \
> +	__val = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);                \
> +	ctxt_sys_reg(ctxt, key ## KEYHI_EL1) = __val;                   \
> +} while(0)
>  
>  static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  {
> @@ -380,11 +383,11 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  		return false;
>  
>  	ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
> -	__ptrauth_save_key(ctxt->sys_regs, APIA);
> -	__ptrauth_save_key(ctxt->sys_regs, APIB);
> -	__ptrauth_save_key(ctxt->sys_regs, APDA);
> -	__ptrauth_save_key(ctxt->sys_regs, APDB);
> -	__ptrauth_save_key(ctxt->sys_regs, APGA);
> +	__ptrauth_save_key(ctxt, APIA);
> +	__ptrauth_save_key(ctxt, APIB);
> +	__ptrauth_save_key(ctxt, APDA);
> +	__ptrauth_save_key(ctxt, APDB);
> +	__ptrauth_save_key(ctxt, APGA);
>  
>  	vcpu_ptrauth_enable(vcpu);
>  

Looks good to me. I also grep'ed for sys_regs at the top level of the sources and
I didn't find any instances that we could replace with the accessors:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
