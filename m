Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8F29C045
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817123AbgJ0RNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1784592AbgJ0O7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 10:59:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D27921527;
        Tue, 27 Oct 2020 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810756;
        bh=KPDhQ2eC+hxI1es67zSQER6Oyh7tou/MgdkaJjDBDL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ridBwbprwzCFa4wXIdwtXZVVKi1mGH8VqkUUTTXXSqR7UrtScoEKRIle+aKYuYPHL
         2vQ8dVOZcHXd3PlnG02Q6EsT2WNKYfP5N6BPTLuICkH/5EdF2cERPlNSHof9RaAlKx
         z2f+tg5T2ahGYsctfyn48UXBCZKU7LvYteIZ4D0s=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXQRO-004l60-7t; Tue, 27 Oct 2020 14:59:14 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 14:59:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kernel-team@android.com
Subject: Re: [PATCH 04/11] KVM: arm64: Move PC rollback on SError to HYP
In-Reply-To: <e2487f06-3f2f-1a0b-49d8-a72ea9288bb2@arm.com>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-5-maz@kernel.org>
 <e2487f06-3f2f-1a0b-49d8-a72ea9288bb2@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <cd5527f7308f1db09268efd7c83e51c5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-27 14:56, James Morse wrote:
> Hi Marc,
> 
> On 26/10/2020 13:34, Marc Zyngier wrote:
>> Instead of handling the "PC rollback on SError during HVC" at EL1 
>> (which
>> requires disclosing PC to a potentially untrusted kernel), let's move
>> this fixup to ... fixup_guest_exit(), which is where we do all fixups.
> 
>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h 
>> b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> index d687e574cde5..668f02c7b0b3 100644
>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> @@ -411,6 +411,21 @@ static inline bool fixup_guest_exit(struct 
>> kvm_vcpu *vcpu, u64 *exit_code)
>>  	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>>  		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>> 
>> +	if (ARM_SERROR_PENDING(*exit_code)) {
>> +		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
>> +
>> +		/*
>> +		 * HVC already have an adjusted PC, which we need to
>> +		 * correct in order to return to after having injected
>> +		 * the SError.
>> +		 *
>> +		 * SMC, on the other hand, is *trapped*, meaning its
>> +		 * preferred return address is the SMC itself.
>> +		 */
>> +		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
>> +			*vcpu_pc(vcpu) -= 4;
> 
> Isn't *vcpu_pc(vcpu) the PC of the previous entry for this vcpu?....
> its not the PC of the
> exit until __sysreg_save_el2_return_state() saves it, which happens 
> just after
> fixup_guest_exit().

Hmmm. Good point. The move was obviously done in haste, thank you for 
pointing
this blatant bug.

> Mess with ELR_EL2 directly?

Yes, that's the best course of action. We never run this code anyway.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
