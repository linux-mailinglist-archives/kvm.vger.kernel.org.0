Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF6F1E3E80
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 12:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgE0KEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 06:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgE0KEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 06:04:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBCA2084C;
        Wed, 27 May 2020 10:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590573850;
        bh=zSIdbYQzBzwhjrQI1hWwupDBNv6wpaxUIuCkjXojSUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mdxZIF05SH6elzOSo9ZapHNOQTVJUmqp6M8R2ruYxkwZfsnML55SowgexSg4vGSjR
         9BrMXLjFGrYP0ZeSZ8q1G2q8UjOZL+OwezjpS3XZ4MXV1NuaCWhNoG73aOTLSrtsLc
         wS9UJZ2vgVazwPa9OxZQ4zUZbrOv7fmLZg4hCw9E=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jdsuu-00Ff8O-Pj; Wed, 27 May 2020 11:04:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 May 2020 11:04:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
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
Subject: Re: [PATCH 10/26] KVM: arm64: Refactor vcpu_{read,write}_sys_reg
In-Reply-To: <09da829c-1640-40fe-313f-df021759fb34@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-11-maz@kernel.org>
 <09da829c-1640-40fe-313f-df021759fb34@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <1612302e289ba15fb0ffbfba5ea18e3b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-05-26 17:28, James Morse wrote:
> Hi Marc,
> 
> On 22/04/2020 13:00, Marc Zyngier wrote:
>> Extract the direct HW accessors for later reuse.
> 
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 51db934702b64..46f218982df8c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
> 
>> +u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
>> +{
>> +	u64 val = 0x8badf00d8badf00d;
>> +
>> +	if (!vcpu->arch.sysregs_loaded_on_cpu) {
>> +		goto memory_read;
>>  	}
>> 
>> -immediate_write:
>> +	if (__vcpu_read_sys_reg_from_cpu(reg, &val))
>> +		return val;
>> +
>> +memory_read:
>> +	return __vcpu_sys_reg(vcpu, reg);
>> +}
> 
> 
> The goto here is a bit odd, is it just an artefact of how we got here?

That's because a lot of this changes when NV gets added to the mix,
see [1].

> Is this easier on the eye?:
> | u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> | {
> |	u64 val = 0x8badf00d8badf00d;
> |
> |	if (vcpu->arch.sysregs_loaded_on_cpu &&
> |	    __vcpu_read_sys_reg_from_cpu(reg, &val))
> |		return val;
> |
> | 	return __vcpu_sys_reg(vcpu, reg);
> | }

Definitely. I don't mind reworking the NV branch so that the label
gets introduced there.

>> +void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>> +{
>> +	if (!vcpu->arch.sysregs_loaded_on_cpu)
>> +		goto memory_write;
>> +
>> +	if (__vcpu_write_sys_reg_to_cpu(val, reg))
>> +		return;
>> +
>> +memory_write:
>>  	 __vcpu_sys_reg(vcpu, reg) = val;
>>  }
> 
> Again I think its clearer without the goto....
> 
> 
> Regardless:
> Reviewed-by: James Morse <james.morse@arm.com>

Thanks,

         M.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/nv-5.7-rc1-WIP&id=11f3217d39a602cbfac7d08064c8b31afb57348e
-- 
Jazz is not dead. It just smells funny...
