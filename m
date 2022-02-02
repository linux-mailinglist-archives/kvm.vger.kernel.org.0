Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1FB4A7059
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 12:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbiBBLxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 06:53:31 -0500
Received: from foss.arm.com ([217.140.110.172]:53758 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbiBBLx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 06:53:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2F691FB;
        Wed,  2 Feb 2022 03:53:28 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FCB93F718;
        Wed,  2 Feb 2022 03:53:25 -0800 (PST)
Date:   Wed, 2 Feb 2022 11:53:35 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 04/64] KVM: arm64: nv: Allow userspace to set
 PSR_MODE_EL2x
Message-ID: <YfpwvyqpL80yA8k7@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jan 28, 2022 at 12:18:12PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> We were not allowing userspace to set a more privileged mode for the VCPU
> than EL1, but we should allow this when nested virtualization is enabled
> for the VCPU.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/guest.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index e116c7767730..db6209622be9 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -24,6 +24,7 @@
>  #include <asm/fpsimd.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/sigcontext.h>
>  
>  #include "trace.h"
> @@ -259,6 +260,11 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  			if (vcpu_el1_is_32bit(vcpu))
>  				return -EINVAL;
>  			break;
> +		case PSR_MODE_EL2h:
> +		case PSR_MODE_EL2t:
> +			if (vcpu_el1_is_32bit(vcpu) || !vcpu_has_nv(vcpu))

I'm a bit confused about the vcpu_el1_is_32bit() check. The function tests
that HCR_EL2.RW is not set. HCR_EL2.RW is cleared when the
KVM_ARM_VCPU_EL1_32BIT feature is preset for the VCPU. But the EL2 and the
32BIT features are incompatible (kvm_reset_vcpu() returns an error when
both are set). Wouldn't checking only !vcpu_has_nv() be enough here?

Thanks,
Alex

> +				return -EINVAL;
> +			break;
>  		default:
>  			err = -EINVAL;
>  			goto out;
> -- 
> 2.30.2
> 
