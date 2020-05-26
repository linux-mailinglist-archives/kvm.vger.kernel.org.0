Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1D1E26EE
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgEZQ26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:28:58 -0400
Received: from foss.arm.com ([217.140.110.172]:53204 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgEZQ26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 12:28:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C079730E;
        Tue, 26 May 2020 09:28:57 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE2CF3F52E;
        Tue, 26 May 2020 09:28:55 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
Subject: Re: [PATCH 10/26] KVM: arm64: Refactor vcpu_{read,write}_sys_reg
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
 <20200422120050.3693593-11-maz@kernel.org>
Message-ID: <09da829c-1640-40fe-313f-df021759fb34@arm.com>
Date:   Tue, 26 May 2020 17:28:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-11-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 22/04/2020 13:00, Marc Zyngier wrote:
> Extract the direct HW accessors for later reuse.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 51db934702b64..46f218982df8c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

> +u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> +{
> +	u64 val = 0x8badf00d8badf00d;
> +
> +	if (!vcpu->arch.sysregs_loaded_on_cpu) {
> +		goto memory_read;
>  	}
>  
> -immediate_write:
> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
> +		return val;
> +
> +memory_read:
> +	return __vcpu_sys_reg(vcpu, reg);
> +}


The goto here is a bit odd, is it just an artefact of how we got here?
Is this easier on the eye?:
| u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
| {
|	u64 val = 0x8badf00d8badf00d;
|
|	if (vcpu->arch.sysregs_loaded_on_cpu &&
|	    __vcpu_read_sys_reg_from_cpu(reg, &val))
|		return val;
|
| 	return __vcpu_sys_reg(vcpu, reg);
| }


> +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> +{
> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
> +		goto memory_write;
> +
> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
> +		return;
> +
> +memory_write:
>  	 __vcpu_sys_reg(vcpu, reg) = val;
>  }

Again I think its clearer without the goto....


Regardless:
Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
