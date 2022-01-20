Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61B9494FA7
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 14:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242624AbiATN5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 08:57:53 -0500
Received: from foss.arm.com ([217.140.110.172]:39108 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241081AbiATN5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 08:57:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 897671FB;
        Thu, 20 Jan 2022 05:57:52 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 321643F766;
        Thu, 20 Jan 2022 05:57:50 -0800 (PST)
Date:   Thu, 20 Jan 2022 13:58:02 +0000
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
Subject: Re: [PATCH v5 14/69] KVM: arm64: nv: Support virtual EL2 exceptions
Message-ID: <YelqampUOCIt3YZE@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-15-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-15-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Nov 29, 2021 at 08:00:55PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Support injecting exceptions and performing exception returns to and
> from virtual EL2.  This must be done entirely in software except when
> taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
> == {1,1}  (a VHE guest hypervisor).
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: switch to common exception injection framework]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>
> [..]
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> new file mode 100644
> index 000000000000..339e8272b01e
> --- /dev/null
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -0,0 +1,176 @@
> +/*
> + * Copyright (C) 2016 - Linaro and Columbia University
> + * Author: Jintack Lim <jintack.lim@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_nested.h>
> +
> +#include "hyp/include/hyp/adjust_pc.h"
> +
> +#include "trace.h"
> +
> +void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
> +{
> +	u64 spsr, elr, mode;
> +	bool direct_eret;
> +
> +	/*
> +	 * Going through the whole put/load motions is a waste of time
> +	 * if this is a VHE guest hypervisor returning to its own
> +	 * userspace, or the hypervisor performing a local exception
> +	 * return. No need to save/restore registers, no need to
> +	 * switch S2 MMU. Just do the canonical ERET.
> +	 */
> +	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
> +	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	direct_eret  = (mode == PSR_MODE_EL0t &&
> +			vcpu_el2_e2h_is_set(vcpu) &&
> +			vcpu_el2_tge_is_set(vcpu));
> +	direct_eret |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
> +
> +	if (direct_eret) {
> +		*vcpu_pc(vcpu) = vcpu_read_sys_reg(vcpu, ELR_EL2);
> +		*vcpu_cpsr(vcpu) = spsr;
> +		trace_kvm_nested_eret(vcpu, *vcpu_pc(vcpu), spsr);
> +		return;
> +	}
> +
> +	preempt_disable();
> +	kvm_arch_vcpu_put(vcpu);
> +
> +	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
> +
> +	trace_kvm_nested_eret(vcpu, elr, spsr);
> +
> +	/*
> +	 * Note that the current exception level is always the virtual EL2,
> +	 * since we set HCR_EL2.NV bit only when entering the virtual EL2.
> +	 */
> +	*vcpu_pc(vcpu) = elr;
> +	*vcpu_cpsr(vcpu) = spsr;
> +
> +	kvm_arch_vcpu_load(vcpu, smp_processor_id());
> +	preempt_enable();

According to ARM DDI 0487G.a, page D13-3289, ERET'ing to EL1 when HCR_EL2.TGE is
set is an illegal exception return. I don't see this case treated here.

Thanks,
Alex
