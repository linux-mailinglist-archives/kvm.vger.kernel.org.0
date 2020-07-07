Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBF1216D90
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgGGNSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 09:18:49 -0400
Received: from foss.arm.com ([217.140.110.172]:49128 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgGGNSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 09:18:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C59AC0A;
        Tue,  7 Jul 2020 06:18:48 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 513D73F71E;
        Tue,  7 Jul 2020 06:18:46 -0700 (PDT)
Subject: Re: [PATCH v3 10/17] KVM: arm64: debug: Drop useless vpcu parameter
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
 <20200706125425.1671020-11-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9dc5698d-2782-c26e-156b-3d082fcfecf9@arm.com>
Date:   Tue, 7 Jul 2020 14:19:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706125425.1671020-11-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/6/20 1:54 PM, Marc Zyngier wrote:
> As part of the ongoing spring cleanup, remove the now useless
> vcpu parameter that is passed around (host and guest contexts
> give us everything we need).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> index 5499d6c1fd9f..0297dc63988c 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
> @@ -88,9 +88,8 @@
>  	default:	write_debug(ptr[0], reg, 0);			\
>  	}
>  
> -static inline void __debug_save_state(struct kvm_vcpu *vcpu,
> -				      struct kvm_guest_debug_arch *dbg,
> -				      struct kvm_cpu_context *ctxt)
> +static void __debug_save_state(struct kvm_guest_debug_arch *dbg,
> +			       struct kvm_cpu_context *ctxt)
>  {
>  	u64 aa64dfr0;
>  	int brps, wrps;
> @@ -107,9 +106,8 @@ static inline void __debug_save_state(struct kvm_vcpu *vcpu,
>  	ctxt_sys_reg(ctxt, MDCCINT_EL1) = read_sysreg(mdccint_el1);
>  }
>  
> -static inline void __debug_restore_state(struct kvm_vcpu *vcpu,
> -					 struct kvm_guest_debug_arch *dbg,
> -					 struct kvm_cpu_context *ctxt)
> +static void __debug_restore_state(struct kvm_guest_debug_arch *dbg,
> +				  struct kvm_cpu_context *ctxt)
>  {
>  	u64 aa64dfr0;
>  	int brps, wrps;
> @@ -142,8 +140,8 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
>  
> -	__debug_save_state(vcpu, host_dbg, host_ctxt);
> -	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
> +	__debug_save_state(host_dbg, host_ctxt);
> +	__debug_restore_state(guest_dbg, guest_ctxt);
>  }
>  
>  static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
> @@ -161,8 +159,8 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
>  	host_dbg = &vcpu->arch.host_debug_state.regs;
>  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
>  
> -	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
> -	__debug_restore_state(vcpu, host_dbg, host_ctxt);
> +	__debug_save_state(guest_dbg, guest_ctxt);
> +	__debug_restore_state(host_dbg, host_ctxt);
>  
>  	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
>  }

Looks fine to me. I also had a look at the other files where we started using the
__vcpu_sys_reg/ctxt_sys_reg accessors, and I didn't find any functions where we
could eliminate the vcpu parameter, like we did here:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
