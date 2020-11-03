Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECFB2A4EDD
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgKCS3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:29:33 -0500
Received: from foss.arm.com ([217.140.110.172]:54040 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbgKCS3c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 13:29:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7272E147A;
        Tue,  3 Nov 2020 10:29:32 -0800 (PST)
Received: from [172.16.1.113] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 619763F718;
        Tue,  3 Nov 2020 10:29:31 -0800 (PST)
Subject: Re: [PATCH 1/8] KVM: arm64: Move AArch32 exceptions over to AArch64
 sysregs
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20201102191609.265711-1-maz@kernel.org>
 <20201102191609.265711-2-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <58942c6b-9cf2-a0d7-3ba5-2fc42aeef779@arm.com>
Date:   Tue, 3 Nov 2020 18:29:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102191609.265711-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 02/11/2020 19:16, Marc Zyngier wrote:
> The use of the AArch32-specific accessors have always been a bit
> annoying on 64bit, and it is time for a change.
> 
> Let's move the AArch32 exception injection over to the AArch64 encoding,
> which requires us to split the two halves of FAR_EL1 into DFAR and IFAR.
> This enables us to drop the preempt_disable() games on VHE, and to kill
> the last user of the vcpu_cp15() macro.

Hurrah!


> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index e2a2e48ca371..975f65ba6a8b 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -100,39 +81,36 @@ static void inject_undef32(struct kvm_vcpu *vcpu)
>   * Modelled after TakeDataAbortException() and TakePrefetchAbortException
>   * pseudocode.
>   */
> -static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
> -			 unsigned long addr)
> +static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
>  {
> -	u32 *far, *fsr;
> -	bool is_lpae;
> -	bool loaded;
> +	u64 far;
> +	u32 fsr;


> +	/* Give the guest an IMPLEMENTATION DEFINED exception */
> +	if (__vcpu_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE) {

With VHE, won't __vcpu_sys_reg() read the potentially stale copy in the sys_reg array?

vcpu_read_sys_reg()?


> +		fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
> +	} else {
> +		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
> +		fsr = DFSR_FSC_EXTABT_nLPAE;
> +	}
>  
> -	loaded = pre_fault_synchronize(vcpu);
> +	far = vcpu_read_sys_reg(vcpu, FAR_EL1);


Thanks,

James
