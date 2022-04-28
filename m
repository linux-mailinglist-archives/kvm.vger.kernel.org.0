Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D69512EF0
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 10:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343950AbiD1IvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 04:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244028AbiD1Iuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 04:50:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11187DF06
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 01:46:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD9FF1474;
        Thu, 28 Apr 2022 01:46:21 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09E693F774;
        Thu, 28 Apr 2022 01:46:19 -0700 (PDT)
Date:   Thu, 28 Apr 2022 09:46:21 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Inject exception on out-of-IPA-range
 translation fault
Message-ID: <YmpUXWRJc3Kq3wGE@monolith.localdoman>
References: <20220427220434.3097449-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427220434.3097449-1-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, Apr 27, 2022 at 11:04:34PM +0100, Marc Zyngier wrote:
> When taking a translation fault for an IPA that is outside of
> the range defined by the hypervisor (between the HW PARange and
> the IPA range), we stupidly treat it as an IO and forward the access
> to userspace. Of course, userspace can't do much with it, and things
> end badly.
> 
> Arguably, the guest is braindead, but we should at least catch the
> case and inject an exception.
> 
> Check the faulting IPA against:
> - the sanitised PARange: inject an address size fault
> - the IPA size: inject an abort
> 
> Reported-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h |  1 +
>  arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/mmu.c                 | 19 +++++++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 7496deab025a..f71358271b71 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -40,6 +40,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu);
>  void kvm_inject_vabt(struct kvm_vcpu *vcpu);
>  void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
>  void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
> +void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
>  
>  void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index b47df73e98d7..ba20405d2dc2 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -145,6 +145,34 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
>  		inject_abt64(vcpu, true, addr);
>  }
>  
> +void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long addr, esr;
> +
> +	addr  = kvm_vcpu_get_fault_ipa(vcpu);
> +	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +
> +	if (kvm_vcpu_trap_is_iabt(vcpu))
> +		kvm_inject_pabt(vcpu, addr);
> +	else
> +		kvm_inject_dabt(vcpu, addr);
> +
> +	/*
> +	 * If AArch64 or LPAE, set FSC to 0 to indicate an Address
> +	 * Size Fault at level 0, as if exceeding PARange.
> +	 *
> +	 * Non-LPAE guests will only get the external abort, as there
> +	 * is no way to to describe the ASF.
> +	 */
> +	if (vcpu_el1_is_32bit(vcpu) &&
> +	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
> +		return;
> +
> +	esr = vcpu_read_sys_reg(vcpu, ESR_EL1);
> +	esr &= ~GENMASK_ULL(5, 0);
> +	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> +}
> +
>  /**
>   * kvm_inject_undefined - inject an undefined instruction into the guest
>   * @vcpu: The vCPU in which to inject the exception
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..5400fc020164 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1337,6 +1337,25 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>  
> +	if (fault_status == FSC_FAULT) {
> +		/* Beyond sanitised PARange (which is the IPA limit) */
> +		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> +			kvm_inject_size_fault(vcpu);
> +			return 1;
> +		}
> +
> +		/* Falls between the IPA range and the PARange? */
> +		if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
> +			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> +
> +			if (is_iabt)
> +				kvm_inject_pabt(vcpu, fault_ipa);
> +			else
> +				kvm_inject_dabt(vcpu, fault_ipa);
> +			return 1;
> +		}

Doesn't KVM treat faults outside a valid memslot (aka guest RAM) as MMIO
aborts? From the guest's point of view, the IPA is valid because it's
inside the HW PARange, so it's not entirely impossible that the VMM put a
device there.

Thanks,
Alex

> +	}
> +
>  	/* Synchronous External Abort? */
>  	if (kvm_vcpu_abt_issea(vcpu)) {
>  		/*
> -- 
> 2.34.1
> 
