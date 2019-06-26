Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452C05633A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 09:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfFZHXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 03:23:11 -0400
Received: from foss.arm.com ([217.140.110.172]:55388 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfFZHXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 03:23:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 252582B;
        Wed, 26 Jun 2019 00:23:10 -0700 (PDT)
Received: from [10.37.8.13] (unknown [10.37.8.13])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 298C73F246;
        Wed, 26 Jun 2019 00:23:07 -0700 (PDT)
Subject: Re: [PATCH 28/59] KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit
 setting
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
 <20190621093843.220980-29-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <c2e2095a-8619-12df-845c-78dbf04efefe@arm.com>
Date:   Wed, 26 Jun 2019 08:23:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-29-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/21/2019 10:38 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack@cs.columbia.edu>
> 
> Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
> virtual HCR_EL2.NV bit is set.
> 
> This is for recursive nested virtualization.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h |  1 +
>  arch/arm64/kvm/sys_regs.c        | 19 +++++++++++++++++--
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index d21486274eeb..55f4525c112c 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -24,6 +24,7 @@
>  
>  /* Hyp Configuration Register (HCR) bits */
>  #define HCR_FWB		(UL(1) << 46)
> +#define HCR_NV1		(UL(1) << 43)
>  #define HCR_NV		(UL(1) << 42)
>  #define HCR_API		(UL(1) << 41)
>  #define HCR_APK		(UL(1) << 40)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0f74b9277a86..beadebcfc888 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -473,8 +473,10 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	if (el12_reg(p) && forward_nv_traps(vcpu))
>  		return false;
>  
> -	if (!el12_reg(p) && forward_vm_traps(vcpu, p))
> -		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +	if (!el12_reg(p) && forward_vm_traps(vcpu, p)) {
> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +		return false;

I feel like this change is actually intended to be part of the previous
patch.

Cheers,

Julien
