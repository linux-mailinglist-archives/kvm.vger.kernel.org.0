Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7C43D7D25
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhG0SL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhG0SL0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:11:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01DAC60238;
        Tue, 27 Jul 2021 18:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627409486;
        bh=0Jhkgmh6Ersm+31Lg4gnjVYrCD7edJaSvbSGVWBYdT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aEo+ZjkFl3s1oc/YPiigC8mZLpoTBobYxMg7UMrG5iZwmmZ5CUVeiYXiDwiderPT8
         3JZVL7uOJSbxd9ws0mVcCkV3pQprki0dluggC5mgJtgLBl2Gknzl/vOF60otnzx+yk
         1lqJ8f3bStaeaueb2NFv8oYwwqUmHS0fm+0w5lnCPRSM4fUQh9nDqR25XOzOFgb4YO
         gP975XKAkYFibjNx5fQUL5qG8dTFZEDN0cB+rGT/5Nesv2P2d8R3f0GYSI2PHU7oOw
         mAIBJWyrbth71xGb9Gg3BtEkv8kCrqDr8M8OE2KkazLDrB0RLy6OTfQvCBOVcYZg1R
         kUi+UtM2Y9SNQ==
Date:   Tue, 27 Jul 2021 19:11:21 +0100
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
Subject: Re: [PATCH 05/16] KVM: arm64: Plumb MMIO checking into the fault
 handling
Message-ID: <20210727181120.GD19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-6-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 05:31:48PM +0100, Marc Zyngier wrote:
> Plumb the MMIO checking code into the MMIO fault handling code.
> Nothing allows a region to be registered yet, so there should be
> no funtional change either.

Typo: functional

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmio.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> index 3dd38a151d2a..fd5747279d27 100644
> --- a/arch/arm64/kvm/mmio.c
> +++ b/arch/arm64/kvm/mmio.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  #include <trace/events/kvm.h>
>  
>  #include "trace.h"
> @@ -130,6 +131,10 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	int len;
>  	u8 data_buf[8];
>  
> +	/* Check failed? Return to the guest for debriefing... */
> +	if (!kvm_check_ioguard_page(vcpu, fault_ipa))
> +		return 1;
> +
>  	/*
>  	 * No valid syndrome? Ask userspace for help if it has
>  	 * volunteered to do so, and bail out otherwise.
> @@ -156,6 +161,11 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  	len = kvm_vcpu_dabt_get_as(vcpu);
>  	rt = kvm_vcpu_dabt_get_rd(vcpu);
>  
> +	/* If we cross a page boundary, check that too... */
> +	if (((fault_ipa + len - 1) & PAGE_MASK) != (fault_ipa & PAGE_MASK) &&
> +	    !kvm_check_ioguard_page(vcpu, fault_ipa + len - 1))
> +		return 1;
> +

I find this a little odd as the checks straddle the invalid syndrome check,
meaning that the relative priorities of KVM_ARCH_FLAG_MMIO_GUARD and
KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER are unclear.

Will
