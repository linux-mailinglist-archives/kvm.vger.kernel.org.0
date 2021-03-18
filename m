Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0805C340777
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 15:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhCROMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 10:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231153AbhCROLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 10:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C3E864E20;
        Thu, 18 Mar 2021 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616076710;
        bh=4YnHl7gwi81S3iAatlqSlG18VzXM0SPmU2vgnSIIf3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fh2gNeYjcMWWFPwQqw4SYwLfgxcV0fBUXg8sg3atSau6iSq6CVtcHPp52yB1lkqpm
         fj5jpdHAg5baOPGc3/Y9DzFKhMlVybiwVQecYwnIfgT10tJs1Bq0ro3ApT9UkWaiVC
         LMrmjLc39vwweMHb5cKh/qY7qePKmlEaptG5/BJ29L8pjO6t/Rc9vbEaDvC5sOgOhX
         lQKyJIm+8TbX8Ct5ntM2eHCYuT19ovuZsbv18x9Q+WzVZKaGp3V6a1dccAoj5NWuFi
         u9Qn7ODTHk4zaWrQVYT7B2O7N/doi1FfnRpBf+asYvE+SZb7Nhl3BEcV1KyxHUGMH2
         8hrCsRPyiZBNQ==
Date:   Thu, 18 Mar 2021 14:11:44 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, ascull@google.com, qperret@google.com,
        kernel-team@android.com
Subject: Re: [PATCH v2 09/11] KVM: arm64: Trap host SVE accesses when the
 FPSIMD state is dirty
Message-ID: <20210318141144.GE7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-10-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:25:30PM +0000, Marc Zyngier wrote:
> ZCR_EL2 controls the upper bound for ZCR_EL1, and is set to
> a potentially lower limit when the guest uses SVE. In order
> to restore the SVE state on the EL1 host, we must first
> reset ZCR_EL2 to its original value.
> 
> To make it as lazy as possible on the EL1 host side, set
> the SVE trapping in place when returning exiting from

"returning exiting"?

> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f3d0e9eca56c..60adc7ff4caa 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -68,7 +68,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  {
>  	extern char __kvm_hyp_host_vector[];
> -	u64 mdcr_el2;
> +	u64 mdcr_el2, cptr;
>  
>  	___deactivate_traps(vcpu);
>  
> @@ -101,7 +101,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  		write_sysreg(HCR_HOST_NVHE_PROTECTED_FLAGS, hcr_el2);
>  	else
>  		write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
> -	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
> +
> +	cptr = CPTR_EL2_DEFAULT;
> +	if (vcpu_has_sve(vcpu) && (vcpu->arch.flags & KVM_ARM64_FP_ENABLED))
> +		cptr |= CPTR_EL2_TZ;

Acked-by: Will Deacon <will@kernel.org>

Will
