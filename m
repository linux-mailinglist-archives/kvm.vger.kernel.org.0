Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29FF122EBB
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 15:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbfLQO2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 09:28:53 -0500
Received: from foss.arm.com ([217.140.110.172]:38860 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbfLQO2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 09:28:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F3E71FB;
        Tue, 17 Dec 2019 06:28:52 -0800 (PST)
Received: from arm.com (e112269-lin.cambridge.arm.com [10.1.196.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A44063F67D;
        Tue, 17 Dec 2019 06:28:50 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:28:48 +0000
From:   Steven Price <steven.price@arm.com>
To:     "yezengruan@huawei.com" <yezengruan@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "maz@kernel.org" <maz@kernel.org>,
        James Morse <James.Morse@arm.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 2/5] KVM: arm64: Implement PV_LOCK_FEATURES call
Message-ID: <20191217142848.GB38811@arm.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-3-yezengruan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217135549.3240-3-yezengruan@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 01:55:46PM +0000, yezengruan@huawei.com wrote:
> From: Zengruan Ye <yezengruan@huawei.com>
> 
> This provides a mechanism for querying which paravirtualized lock
> features are available in this hypervisor.
> 
> Also add the header file which defines the ABI for the paravirtualized
> lock features we're about to add.
> 
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> ---
>  arch/arm64/include/asm/pvlock-abi.h | 16 ++++++++++++++++
>  include/linux/arm-smccc.h           | 13 +++++++++++++
>  virt/kvm/arm/hypercalls.c           |  3 +++
>  3 files changed, 32 insertions(+)
>  create mode 100644 arch/arm64/include/asm/pvlock-abi.h
> 
> diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
> new file mode 100644
> index 000000000000..06e0c3d7710a
> --- /dev/null
> +++ b/arch/arm64/include/asm/pvlock-abi.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
> + * Author: Zengruan Ye <yezengruan@huawei.com>
> + */
> +
> +#ifndef __ASM_PVLOCK_ABI_H
> +#define __ASM_PVLOCK_ABI_H
> +
> +struct pvlock_vcpu_state {
> +	__le64 preempted;

Somewhere we need to document when 'preempted' is. It looks like it's a
1-bit field from the later patches.

> +	/* Structure must be 64 byte aligned, pad to that size */
> +	u8 padding[56];
> +} __packed;
> +
> +#endif
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 59494df0f55b..59e65a951959 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -377,5 +377,18 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>  			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
>  			   0x21)
>  
> +/* Paravirtualised lock calls */
> +#define ARM_SMCCC_HV_PV_LOCK_FEATURES				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   0x40)
> +
> +#define ARM_SMCCC_HV_PV_LOCK_PREEMPTED				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   0x41)
> +
>  #endif /*__ASSEMBLY__*/
>  #endif /*__LINUX_ARM_SMCCC_H*/
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index 550dfa3e53cd..ff13871fd85a 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -52,6 +52,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		case ARM_SMCCC_HV_PV_TIME_FEATURES:
>  			val = SMCCC_RET_SUCCESS;
>  			break;
> +		case ARM_SMCCC_HV_PV_LOCK_FEATURES:
> +			val = SMCCC_RET_SUCCESS;
> +			break;

Ideally you wouldn't report that PV_LOCK_FEATURES exists until the
actual hypercalls are wired up to avoid breaking a bisect.

Steve

>  		}
>  		break;
>  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -- 
> 2.19.1
> 
> 
