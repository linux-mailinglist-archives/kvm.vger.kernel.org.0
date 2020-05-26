Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5CD1E26FC
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbgEZQ3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:29:55 -0400
Received: from foss.arm.com ([217.140.110.172]:53306 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgEZQ3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 12:29:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 639A330E;
        Tue, 26 May 2020 09:29:54 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 676543F52E;
        Tue, 26 May 2020 09:29:52 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
Subject: Re: [PATCH 20/26] KVM: arm64: Move ELR_EL1 to the system register
 array
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-21-maz@kernel.org>
Message-ID: <b6a08ca6-1682-4fa6-e8f4-bb4adba5d19a@arm.com>
Date:   Tue, 26 May 2020 17:29:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-21-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 22/04/2020 13:00, Marc Zyngier wrote:
> As ELR-EL1 is a VNCR-capable register with ARMv8.4-NV, let's move it to
> the sys_regs array and repaint the accessors. While we're at it, let's
> kill the now useless accessors used only on the fault injection path.

Reviewed-by: James Morse <james.morse@arm.com>


A curiosity:

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 95977b80265ce..46949fce3e813 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -184,6 +184,8 @@ enum vcpu_sysreg {

Comment above the enum has some claims about the order, but its already out of order with
__vcpu_read_sys_reg_from_cpu()... (PAR_EL1 being the culprit)

(I think it only matters for searching by encoding, which is checked at boot.)


>  	APGAKEYLO_EL1,
>  	APGAKEYHI_EL1,
>  
> +	ELR_EL1,
> +
>  	/* 32bit specific registers. Keep them at the end of the range */
>  	DACR32_EL2,	/* Domain Access Control Register */
>  	IFSR32_EL2,	/* Instruction Fault Status Register */

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5bda4af36a0e7..7c2fffb20c217 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -95,6 +95,7 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
>  	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
>  	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
>  	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
> +	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
>  	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
>  	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
>  	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;



Thanks,

James
