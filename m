Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F5229B3DD
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 15:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781897AbgJ0O4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 10:56:17 -0400
Received: from foss.arm.com ([217.140.110.172]:42846 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752716AbgJ0O4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 10:56:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22AE913D5;
        Tue, 27 Oct 2020 07:56:13 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 91B7D3F719;
        Tue, 27 Oct 2020 07:56:11 -0700 (PDT)
Subject: Re: [PATCH 04/11] KVM: arm64: Move PC rollback on SError to HYP
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-5-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <e2487f06-3f2f-1a0b-49d8-a72ea9288bb2@arm.com>
Date:   Tue, 27 Oct 2020 14:56:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026133450.73304-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 26/10/2020 13:34, Marc Zyngier wrote:
> Instead of handling the "PC rollback on SError during HVC" at EL1 (which
> requires disclosing PC to a potentially untrusted kernel), let's move
> this fixup to ... fixup_guest_exit(), which is where we do all fixups.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index d687e574cde5..668f02c7b0b3 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -411,6 +411,21 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>  		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>  
> +	if (ARM_SERROR_PENDING(*exit_code)) {
> +		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
> +
> +		/*
> +		 * HVC already have an adjusted PC, which we need to
> +		 * correct in order to return to after having injected
> +		 * the SError.
> +		 *
> +		 * SMC, on the other hand, is *trapped*, meaning its
> +		 * preferred return address is the SMC itself.
> +		 */
> +		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
> +			*vcpu_pc(vcpu) -= 4;

Isn't *vcpu_pc(vcpu) the PC of the previous entry for this vcpu?.... its not the PC of the
exit until __sysreg_save_el2_return_state() saves it, which happens just after
fixup_guest_exit().

Mess with ELR_EL2 directly?


Thanks,

James

> +	}
> +
>  	/*
>  	 * We're using the raw exception code in order to only process
>  	 * the trap if no SError is pending. We will come back to the
> 

