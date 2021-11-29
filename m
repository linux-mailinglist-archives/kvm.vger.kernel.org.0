Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219F0461C52
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 17:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347466AbhK2RCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 12:02:49 -0500
Received: from foss.arm.com ([217.140.110.172]:43604 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346849AbhK2RAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 12:00:48 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A0371063;
        Mon, 29 Nov 2021 08:57:30 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B16303F5A1;
        Mon, 29 Nov 2021 08:57:28 -0800 (PST)
Date:   Mon, 29 Nov 2021 16:59:21 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Add minimal handling for the ARMv8.7 PMU
Message-ID: <YaUG6TtiiIRyzL/y@monolith.localdoman>
References: <20211126115533.217903-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126115533.217903-1-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Tested on FVP and the nasty splat goes away, so it works for me:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

The guest visible PMCR_EL0.FZ0 bit added by FEAT_PMUv3p7 is cleared on
register reset/write because ARMV8_PMU_PMCR_MASK is 0xff. This makes the
bit behave as RES0, which is the architectural value for the field when
FEAT_PMUv3p7 is absent. So the patch looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Fri, Nov 26, 2021 at 11:55:33AM +0000, Marc Zyngier wrote:
> When running a KVM guest hosted on an ARMv8.7 machine, the host
> kernel complains that it doesn't know about the architected number
> of events.
> 
> Fix it by adding the PMUver code corresponding to PMUv3 for ARMv8.7.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 1 +
>  arch/arm64/kvm/pmu-emul.c       | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index cdb590840b3f..5de90138d0a4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1036,6 +1036,7 @@
>  #define ID_AA64DFR0_PMUVER_8_1		0x4
>  #define ID_AA64DFR0_PMUVER_8_4		0x5
>  #define ID_AA64DFR0_PMUVER_8_5		0x6
> +#define ID_AA64DFR0_PMUVER_8_7		0x7
>  #define ID_AA64DFR0_PMUVER_IMP_DEF	0xf
>  
>  #define ID_AA64DFR0_PMSVER_8_2		0x1
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index a5e4bbf5e68f..ca92cc5c71c6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -28,6 +28,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  	case ID_AA64DFR0_PMUVER_8_1:
>  	case ID_AA64DFR0_PMUVER_8_4:
>  	case ID_AA64DFR0_PMUVER_8_5:
> +	case ID_AA64DFR0_PMUVER_8_7:
>  		return GENMASK(15, 0);
>  	default:		/* Shouldn't be here, just for sanity */
>  		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
> -- 
> 2.30.2
> 
