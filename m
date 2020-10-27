Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5A29BB97
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 17:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1808751AbgJ0QVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 12:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1808747AbgJ0QVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 12:21:39 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 846AD21556;
        Tue, 27 Oct 2020 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603815698;
        bh=7/rild77xsc5YoD9UYAyYTxObMNYYA88SHHZ2y9TO2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E617OM8BwNypy4FMxmZ23Wyi2/IfQWoiSQrW/J317vQwIFsrIV+z+Do+ophS4mP0U
         2zqTqQsOC0H/f9oLIOhzePfDTOsPqwsagSzDW6yUky7zHHGIdB5gyQNt5NwM59yHNw
         9yqhmsI6UedyfyZ60CDauz++FEuRKFs2vauddgI8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXRj6-004oIO-Kk; Tue, 27 Oct 2020 16:21:36 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 16:21:36 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 07/11] KVM: arm64: Inject AArch64 exceptions from HYP
In-Reply-To: <20201026142201.GH12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-8-maz@kernel.org>
 <20201026142201.GH12454@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <e38ae1cbc11ea00920067b886e1898d5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-26 14:22, Mark Rutland wrote:
> On Mon, Oct 26, 2020 at 01:34:46PM +0000, Marc Zyngier wrote:
>> Move the AArch64 exception injection code from EL1 to HYP, leaving
>> only the ESR_EL1 updates to EL1. In order to come with the differences
>> between VHE and nVHE, two set of system register accessors are 
>> provided.
>> 
>> SPSR, ELR, PC and PSTATE are now completely handled in the hypervisor.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
>>  void kvm_inject_exception(struct kvm_vcpu *vcpu)
>>  {
>> +	switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
>> +	case KVM_ARM64_EXCEPT_AA64_EL1_SYNC:
>> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
>> +		break;
>> +	case KVM_ARM64_EXCEPT_AA64_EL1_IRQ:
>> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_irq);
>> +		break;
>> +	case KVM_ARM64_EXCEPT_AA64_EL1_FIQ:
>> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_fiq);
>> +		break;
>> +	case KVM_ARM64_EXCEPT_AA64_EL1_SERR:
>> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
>> +		break;
>> +	default:
>> +		/* EL2 are unimplemented until we get NV. One day. */
>> +		break;
>> +	}
>>  }
> 
> Huh, we're going to allow EL1 to inject IRQ/FIQ/SERROR *exceptions*
> directly, rather than pending those via HCR_EL2.{VI,VF,VSE}? We never
> used to have code to do that.

True, and I feel like I got carried away while thinking of NV.
Though James had some "interesting" use case [1] lately...

> If we're going to support that we'll need to check against the DAIF 
> bits
> to make sure we don't inject an exception that can't be architecturally
> taken.

Nah, forget it. Unless we really need to implement something like James'
idea, I'd rather drop this altogether.

> I guess we'll tighten that up along with the synchronous exception
> checks, but given those three cases aren't needed today it might be
> worth removing them from the switch for now and/or adding a comment to
> that effect.

Agreed.

         M.

[1] https://lore.kernel.org/r/20201023165108.15061-1-james.morse@arm.com
-- 
Jazz is not dead. It just smells funny...
