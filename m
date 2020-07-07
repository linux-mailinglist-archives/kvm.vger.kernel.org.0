Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73474216D42
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGGM6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 08:58:04 -0400
Received: from foss.arm.com ([217.140.110.172]:47688 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgGGM6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 08:58:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 848E1C0A;
        Tue,  7 Jul 2020 05:58:03 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 622E83F71E;
        Tue,  7 Jul 2020 05:58:01 -0700 (PDT)
Subject: Re: [PATCH v3 08/17] KVM: arm64: sve: Use __vcpu_sys_reg() instead of
 raw sys_regs access
To:     Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200706125425.1671020-1-maz@kernel.org>
 <20200706125425.1671020-9-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e93ff2cc-c641-391e-ad31-fc4da7176bdf@arm.com>
Date:   Tue, 7 Jul 2020 13:58:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200706125425.1671020-9-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 7/6/20 1:54 PM, Marc Zyngier wrote:
> Now that we have a wrapper for the sysreg accesses, let's use that
> consistently.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/fpsimd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
> index e329a36b2bee..e503caff14d1 100644
> --- a/arch/arm64/kvm/fpsimd.c
> +++ b/arch/arm64/kvm/fpsimd.c
> @@ -109,12 +109,10 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
>  	local_irq_save(flags);
>  
>  	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
> -		u64 *guest_zcr = &vcpu->arch.ctxt.sys_regs[ZCR_EL1];
> -
>  		fpsimd_save_and_flush_cpu_state();
>  
>  		if (guest_has_sve)
> -			*guest_zcr = read_sysreg_s(SYS_ZCR_EL12);
> +			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
>  	} else if (host_has_sve) {
>  		/*
>  		 * The FPSIMD/SVE state in the CPU has not been touched, and we

Looks fine to me, it's a good change:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
