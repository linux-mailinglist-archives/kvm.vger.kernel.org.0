Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C915734078B
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhCROOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 10:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231317AbhCROOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 10:14:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE7464E01;
        Thu, 18 Mar 2021 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616076844;
        bh=aUVF0Ydr7cFuRiZVzu9loYt6i7SML2c2a9mIIBakwxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XffV7mEr8cWu7NBXBLOufsNJUerPiVzf6ncfT+/kpr+PJChg1Io5bvtS036WzRaF6
         HbloftOXtPrFEKvbjOnaas3BiPyBf6bHzDmOJcC/GOIvdnn/kXRs//4JZLfYdiSXzL
         vHDGgsH05fJqFJbAh9I2ox/dCANiytHXoGUyAHenReMUnxktogaenPEXMJUuQm74yY
         XOhmBOrKmqHILKnmJrSOOAvVIlgDrxNQh37XYft851Y6hJjgKH0+yGY8usdokklTlU
         F8h5GuqDACqlfK6VS2gtP+NcrwPsSa2mjhENjemy3Zz3M3WAuGD3vLiHBw2G5/a9na
         FNR6nuH3RyUFg==
Date:   Thu, 18 Mar 2021 14:13:58 +0000
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
Subject: Re: [PATCH v2 10/11] KVM: arm64: Save/restore SVE state for nVHE
Message-ID: <20210318141358.GF7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-11-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-11-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:25:31PM +0000, Marc Zyngier wrote:
> Implement the SVE save/restore for nVHE, following a similar
> logic to that of the VHE implementation:
> 
> - the SVE state is switched on trap from EL1 to EL2
> 
> - no further changes to ZCR_EL2 occur as long as the guest isn't
>   preempted or exit to userspace
> 
> - ZCR_EL2 is reset to its default value on the first SVE access from
>   the host EL1, and ZCR_EL1 restored to the default guest value in
>   vcpu_put()
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c                 | 10 +++++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++----------------
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  4 +--
>  3 files changed, 23 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index 14ea05c5134a..5621020b28de 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -121,11 +121,17 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> -		if (guest_has_sve)
> +		if (guest_has_sve) {
>  			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
>  
> +			/* Restore the VL that was saved when bound to the CPU */
> +			if (!has_vhe())
> +				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
> +						       SYS_ZCR_EL1);

You end up reading ZCR_EL1 twice here, but it's probably not the end of the
world.

Anyway:

Acked-by: Will Deacon <will@kernel.org>

Will
