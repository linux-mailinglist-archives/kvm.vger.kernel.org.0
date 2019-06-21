Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F175E4E891
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFUNI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:08:29 -0400
Received: from foss.arm.com ([217.140.110.172]:60184 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbfFUNI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:08:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B006142F;
        Fri, 21 Jun 2019 06:08:28 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 407DF3F246;
        Fri, 21 Jun 2019 06:08:27 -0700 (PDT)
Subject: Re: [PATCH 04/59] KVM: arm64: nv: Introduce nested virtualization
 VCPU feature
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-5-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <95a96d6c-ada4-289c-2634-9877fa04086a@arm.com>
Date:   Fri, 21 Jun 2019 14:08:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-5-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/06/2019 10:37, Marc Zyngier wrote:
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
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_nested.h   |  9 +++++++++
>  arch/arm64/include/asm/kvm_nested.h | 13 +++++++++++++
>  arch/arm64/include/uapi/asm/kvm.h   |  1 +
>  3 files changed, 23 insertions(+)
>  create mode 100644 arch/arm/include/asm/kvm_nested.h
>  create mode 100644 arch/arm64/include/asm/kvm_nested.h
> 
> diff --git a/arch/arm/include/asm/kvm_nested.h b/arch/arm/include/asm/kvm_nested.h
> new file mode 100644
> index 000000000000..124ff6445f8f
> --- /dev/null
> +++ b/arch/arm/include/asm/kvm_nested.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ARM_KVM_NESTED_H
> +#define __ARM_KVM_NESTED_H
> +
> +#include <linux/kvm_host.h>
> +
> +static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu) { return false; }
> +
> +#endif /* __ARM_KVM_NESTED_H */
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> new file mode 100644
> index 000000000000..8a3d121a0b42
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ARM64_KVM_NESTED_H
> +#define __ARM64_KVM_NESTED_H
> +
> +#include <linux/kvm_host.h>
> +
> +static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
> +{
> +	return cpus_have_const_cap(ARM64_HAS_NESTED_VIRT) &&
> +		test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features);

Nit: You could make it even cheaper for some systems by adding
IS_DEFINED(CONFIG_ARM64_VHE). It would also make the dependency between
NV and VHE more explicit.

Otherwise:

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Cheers,

-- 
Julien Thierry
