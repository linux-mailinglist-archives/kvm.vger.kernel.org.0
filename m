Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2562A4EE1
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgKCS3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:29:42 -0500
Received: from foss.arm.com ([217.140.110.172]:54088 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbgKCS3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 13:29:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4BA21474;
        Tue,  3 Nov 2020 10:29:41 -0800 (PST)
Received: from [172.16.1.113] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66983F718;
        Tue,  3 Nov 2020 10:29:40 -0800 (PST)
Subject: Re: [PATCH 4/8] KVM: arm64: Map AArch32 cp14 register to AArch64
 sysregs
To:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20201102191609.265711-1-maz@kernel.org>
 <20201102191609.265711-5-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <1830d62e-ac47-9b84-6375-baed62f8486e@arm.com>
Date:   Tue, 3 Nov 2020 18:29:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102191609.265711-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 02/11/2020 19:16, Marc Zyngier wrote:
> Similarly to what has been done on the cp15 front, repaint the
> debug registers to use their AArch64 counterparts. This results
> in some simplification as we can remove the 32bit-specific
> accessors.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 137818793a4a..c41e7ca60c8c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -361,26 +361,30 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
> -#define DBGBXVR(n)							\
> -	{ Op1( 0), CRn( 1), CRm((n)), Op2( 1), trap_xvr, NULL, n }
> +#define DBG_BCR_BVR_WCR_WVR(n)						      \
> +	/* DBGBVRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 4), trap_bvr, NULL, n }, \

Just to check I understand what is going on here: This BVR AA32(LO) is needed because the
dbg_bvr array is shared with the DBGBXVR registers...


> +	/* DBGBCRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 5), trap_bcr, NULL, n }, \
> +	/* DBGWVRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 6), trap_wvr, NULL, n }, \
> +	/* DBGWCRn */							      \
> +	{ AA32(LO), Op1( 0), CRn( 0), CRm((n)), Op2( 7), trap_wcr, NULL, n }

... these don't have an alias, but its harmless.

[...]

> @@ -1931,7 +1896,9 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	/* DFSR */
>  	{ Op1( 0), CRn( 5), CRm( 0), Op2( 0), access_vm_reg, NULL, ESR_EL1 },
>  	{ Op1( 0), CRn( 5), CRm( 0), Op2( 1), access_vm_reg, NULL, IFSR32_EL2 },
> +	/* ADFSR */
>  	{ Op1( 0), CRn( 5), CRm( 1), Op2( 0), access_vm_reg, NULL, AFSR0_EL1 },
> +	/* AIFSR */
>  	{ Op1( 0), CRn( 5), CRm( 1), Op2( 1), access_vm_reg, NULL, AFSR1_EL1 },
>  	/* DFAR */
>  	{ AA32(LO), Op1( 0), CRn( 6), CRm( 0), Op2( 0), access_vm_reg, NULL, FAR_EL1 },

I guess these were meant for the previous patch.


Thanks,

James
