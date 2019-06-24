Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387485089A
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 12:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfFXKTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 06:19:09 -0400
Received: from foss.arm.com ([217.140.110.172]:46122 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbfFXKTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 06:19:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E7952B;
        Mon, 24 Jun 2019 03:19:08 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 023573F718;
        Mon, 24 Jun 2019 03:19:06 -0700 (PDT)
Subject: Re: [PATCH 05/59] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU
 nested virt is set
To:     marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, christoffer.dall@arm.com,
        dave.martin@arm.com, jintack@cs.columbia.edu,
        julien.thierry@arm.com, james.morse@arm.com
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-6-marc.zyngier@arm.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <8f545b5a-ceb6-a5c9-ad21-485f0e63f6e5@arm.com>
Date:   Mon, 24 Jun 2019 11:19:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-6-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/06/2019 10:37, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   arch/arm64/kvm/reset.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 1140b4485575..675ca07dbb05 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -52,6 +52,11 @@ static const struct kvm_regs default_regs_reset = {
>   			PSR_F_BIT | PSR_D_BIT),
>   };
>   
> +static const struct kvm_regs default_regs_reset_el2 = {
> +	.regs.pstate = (PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT |
> +			PSR_F_BIT | PSR_D_BIT),
> +};
> +
>   static const struct kvm_regs default_regs_reset32 = {
>   	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
>   			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> @@ -302,6 +307,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>   			if (!cpu_has_32bit_el1())
>   				goto out;
>   			cpu_reset = &default_regs_reset32;
> +		} else if (test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features)) {

minor nit: "else if nested_virt_in_use(vcpu)" ?

Either ways:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
