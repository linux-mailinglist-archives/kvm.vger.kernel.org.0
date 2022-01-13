Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E76948D981
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiAMOKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 09:10:31 -0500
Received: from foss.arm.com ([217.140.110.172]:46506 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbiAMOKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 09:10:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB3ABED1;
        Thu, 13 Jan 2022 06:10:30 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50EFF3F766;
        Thu, 13 Jan 2022 06:10:28 -0800 (PST)
Date:   Thu, 13 Jan 2022 14:10:39 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v5 07/69] KVM: arm64: nv: Introduce nested virtualization
 VCPU feature
Message-ID: <YeAy371xsAUiSzj+@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-8-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Nov 29, 2021 at 08:00:48PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Introduce the feature bit and a primitive that checks if the feature is
> set behind a static key check based on the cpus_have_const_cap check.
> 
> Checking nested_virt_in_use() on systems without nested virt enabled
> should have neglgible overhead.
> 
> We don't yet allow userspace to actually set this feature.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h | 14 ++++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h   |  1 +
>  2 files changed, 15 insertions(+)
>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
> 
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> new file mode 100644
> index 000000000000..1028ac65a897
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ARM64_KVM_NESTED_H
> +#define __ARM64_KVM_NESTED_H
> +
> +#include <linux/kvm_host.h>
> +
> +static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
> +{
> +	return (!__is_defined(__KVM_NVHE_HYPERVISOR__) &&
> +		cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
> +		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));

kvm_vcpu_init_nested() checks the ARM64_HAS_NESTED_VIRT cap before setting
the features bit, so I guess you can drop this check here if you're
interested in correctness.

But the reason the cap check done is performance, right? Same with the NVHE
define.

Thanks,
Alex

> +}
> +
> +#endif /* __ARM64_KVM_NESTED_H */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b3edde68bc3e..395a4c039bcc 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -106,6 +106,7 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
>  #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
> +#define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> -- 
> 2.30.2
> 
