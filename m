Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52E5805F6
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 13:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbfHCLVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 07:21:35 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:37015 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389618AbfHCLVf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Aug 2019 07:21:35 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Aug 2019 07:21:33 EDT
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1hts6I-0007Dy-TI; Sat, 03 Aug 2019 13:21:27 +0200
Date:   Sat, 3 Aug 2019 12:21:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Steven Price <steven.price@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] KVM: arm64: Implement PV_FEATURES call
Message-ID: <20190803122124.7700f700@why>
In-Reply-To: <20190802145017.42543-4-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
        <20190802145017.42543-4-steven.price@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Aug 2019 15:50:11 +0100
Steven Price <steven.price@arm.com> wrote:

> This provides a mechanism for querying which paravirtualized features
> are available in this hypervisor.
> 
> Also add the header file which defines the ABI for the paravirtualized
> clock features we're about to add.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/pvclock-abi.h | 20 ++++++++++++++++++++
>  include/linux/arm-smccc.h            | 14 ++++++++++++++
>  virt/kvm/arm/hypercalls.c            |  9 +++++++++
>  3 files changed, 43 insertions(+)
>  create mode 100644 arch/arm64/include/asm/pvclock-abi.h
> 
> diff --git a/arch/arm64/include/asm/pvclock-abi.h b/arch/arm64/include/asm/pvclock-abi.h
> new file mode 100644
> index 000000000000..1f7cdc102691
> --- /dev/null
> +++ b/arch/arm64/include/asm/pvclock-abi.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2019 Arm Ltd. */
> +
> +#ifndef __ASM_PVCLOCK_ABI_H
> +#define __ASM_PVCLOCK_ABI_H
> +
> +/* The below structures and constants are defined in ARM DEN0057A */
> +
> +struct pvclock_vcpu_stolen_time_info {
> +	__le32 revision;
> +	__le32 attributes;
> +	__le64 stolen_time;
> +	/* Structure must be 64 byte aligned, pad to that size */
> +	u8 padding[48];
> +} __packed;
> +
> +#define PV_VM_TIME_NOT_SUPPORTED	-1

Isn't the intent for this to be the same value as
SMCCC_RET_NOT_SUPPORTED?

> +#define PV_VM_TIME_INVALID_PARAMETERS	-2

It overlaps with SMCCC_RET_NOT_REQUIRED. Is that a problem? Should we
consider a spec change for this?

> +
> +#endif
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 080012a6f025..e7f129f26ebd 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -45,6 +45,7 @@
>  #define ARM_SMCCC_OWNER_SIP		2
>  #define ARM_SMCCC_OWNER_OEM		3
>  #define ARM_SMCCC_OWNER_STANDARD	4
> +#define ARM_SMCCC_OWNER_STANDARD_HYP	5
>  #define ARM_SMCCC_OWNER_TRUSTED_APP	48
>  #define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
>  #define ARM_SMCCC_OWNER_TRUSTED_OS	50
> @@ -302,5 +303,18 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>  #define SMCCC_RET_NOT_SUPPORTED			-1
>  #define SMCCC_RET_NOT_REQUIRED			-2
>  
> +/* Paravirtualised time calls (defined by ARM DEN0057A) */
> +#define ARM_SMCCC_HV_PV_FEATURES				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   0x20)
> +
> +#define ARM_SMCCC_HV_PV_TIME_ST					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
> +			   0x22)
> +
>  #endif /*__ASSEMBLY__*/
>  #endif /*__LINUX_ARM_SMCCC_H*/
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index f875241bd030..2906b2df99df 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -5,6 +5,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/pvclock-abi.h>
>  
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_psci.h>
> @@ -48,6 +49,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  				break;
>  			}
>  			break;
> +		case ARM_SMCCC_HV_PV_FEATURES:
> +			val = SMCCC_RET_SUCCESS;
> +			break;
> +		}
> +		break;
> +	case ARM_SMCCC_HV_PV_FEATURES:
> +		feature = smccc_get_arg1(vcpu);
> +		switch (feature) {
>  		}
>  		break;
>  	default:


Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
