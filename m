Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC93D7D28
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhG0SLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhG0SLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6686056B;
        Tue, 27 Jul 2021 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627409498;
        bh=BEDd+h2W4eFzLeu2/Kd2s9Jkn7/PmvBnCgRz19A2CTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ndvRHWn3doV9PuLCYw5aGZyf9RmorsMksOc4AkU0fxy1AGJt5EjCMAk5jZFxQyiGF
         aURvGsNYuOnNBqaH4DSEPIFluR2Vb7dJpiZwFmr9iLRjiZtkYgdanBNZ+D6T1CHIqC
         xMxfIg95OFfkw86Q7XCXDRZtvoD/ySkxJXIgLwRvBOWXxBR5i+qDF/jlB3UDkKO1E5
         bSRZ0wIZa+EQVL6uNhwLIe9QvhM98PJb9EdckxgWqwyqd0+5ghqKye7tcTyMzyC+ay
         7Hua073iRgXf9Y6biPyVihRiG8ULriLeNTeKv4dd1vvgHBRgTy5+XyPARqMopwMtjF
         UDoPS8AY3SIrA==
Date:   Tue, 27 Jul 2021 19:11:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 06/16] KVM: arm64: Force a full unmap on vpcu reinit
Message-ID: <20210727181132.GE19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-7-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-7-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 05:31:49PM +0100, Marc Zyngier wrote:
> As we now keep information in the S2PT, we must be careful not
> to keep it across a VM reboot, which could otherwise lead to
> interesting problems.
> 
> Make sure that the S2 is completely discarded on reset of
> a vcpu, and remove the flag that enforces the MMIO check.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 97ab1512c44f..b0d2225190d2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1096,12 +1096,18 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
>  	 * ensuring that the data side is always coherent. We still
>  	 * need to invalidate the I-cache though, as FWB does *not*
>  	 * imply CTR_EL0.DIC.
> +	 *
> +	 * If the MMIO guard was enabled, we pay the price of a full
> +	 * unmap to get back to a sane state (and clear the flag).
>  	 */
>  	if (vcpu->arch.has_run_once) {
> -		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
> +		    test_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags))
>  			stage2_unmap_vm(vcpu->kvm);
>  		else
>  			icache_inval_all_pou();
> +
> +		clear_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);

What prevents this racing with another vCPU trying to set the bit?

Will
