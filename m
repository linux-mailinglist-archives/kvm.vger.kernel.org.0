Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16E16125E
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 13:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgBQMwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 07:52:44 -0500
Received: from foss.arm.com ([217.140.110.172]:35368 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726797AbgBQMwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 07:52:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9ED0330E;
        Mon, 17 Feb 2020 04:52:43 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B75A73F703;
        Mon, 17 Feb 2020 04:52:42 -0800 (PST)
Date:   Mon, 17 Feb 2020 12:52:40 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 09/94] KVM: arm64: nv: Support virtual EL2 exceptions
Message-ID: <20200217125240.GC47755@lakrids.cambridge.arm.com>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-10-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211174938.27809-10-maz@kernel.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 05:48:13PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> Support injecting exceptions and performing exception returns to and
> from virtual EL2.  This must be done entirely in software except when
> taking an exception from vEL0 to vEL2 when the virtual HCR_EL2.{E2H,TGE}
> == {1,1}  (a VHE guest hypervisor).
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h     |  17 +++
>  arch/arm64/include/asm/kvm_emulate.h |  22 ++++
>  arch/arm64/kvm/Makefile              |   2 +
>  arch/arm64/kvm/emulate-nested.c      | 183 +++++++++++++++++++++++++++
>  arch/arm64/kvm/inject_fault.c        |  12 --
>  arch/arm64/kvm/trace.h               |  56 ++++++++
>  6 files changed, 280 insertions(+), 12 deletions(-)
>  create mode 100644 arch/arm64/kvm/emulate-nested.c

[...]

> +static void enter_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
> +				enum exception_type type)
> +{
> +	trace_kvm_inject_nested_exception(vcpu, esr_el2, type);
> +
> +	vcpu_write_sys_reg(vcpu, *vcpu_cpsr(vcpu), SPSR_EL2);
> +	vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
> +	vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
> +
> +	*vcpu_pc(vcpu) = get_el2_except_vector(vcpu, type);
> +	/* On an exception, PSTATE.SP becomes 1 */
> +	*vcpu_cpsr(vcpu) = PSR_MODE_EL2h;
> +	*vcpu_cpsr(vcpu) |= PSR_A_BIT | PSR_F_BIT | PSR_I_BIT | PSR_D_BIT;
> +}

This needs to be fixed up to handle the rest of the PSTATE bits.

It should be possible to refactor get_except64_pstate() for that. I
*think* the only differences are bits affects by SCTLR controls, but
someone should audit that -- good thing we added references. :)

Thanks,
Mark.
