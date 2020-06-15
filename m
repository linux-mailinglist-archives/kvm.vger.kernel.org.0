Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648CE1F94D7
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgFOKpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgFOKpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 06:45:11 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 440DE20679;
        Mon, 15 Jun 2020 10:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592217910;
        bh=NQzIZ8HPcQkoHR2c+q1ZkigBSIf8XsDf44QYuMwZ1eI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1RtG08G/L03qKYK1oCOce5i21jHfrQ3NbZC8zOJcMgDMZ0czTmcyDD4bt7pC2BB3o
         qecG3/VcX504T1V2WOzpEUg5g2RXJmqv2ter5zGq7x6z+iBfsdH0JfYpj/dt2FmqRm
         v2hCvpW4bzXkjj+JNt21eLWPEaZqZnHxFtfGSm14=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jkmc0-0034QJ-RE; Mon, 15 Jun 2020 11:45:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Jun 2020 11:45:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Scull <ascull@google.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 1/4] KVM: arm64: Enable Pointer Authentication at EL2 if
 available
In-Reply-To: <20200615084857.GD177680@google.com>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-2-maz@kernel.org> <20200615084857.GD177680@google.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8683c038040236e1fefed067649c31d9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 2020-06-15 09:48, Andrew Scull wrote:
> On Mon, Jun 15, 2020 at 09:19:51AM +0100, Marc Zyngier wrote:
>> While initializing EL2, switch Pointer Authentication if detected
> 
>                                 ^ nit: on?

Yes.

> 
>> from EL1. We use the EL1-provided keys though.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/hyp-init.S | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>> 
>> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
>> index 6e6ed5581eed..81732177507d 100644
>> --- a/arch/arm64/kvm/hyp-init.S
>> +++ b/arch/arm64/kvm/hyp-init.S
>> @@ -104,6 +104,17 @@ alternative_else_nop_endif
>>  	 */
>>  	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
>>  CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
>> +alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
>> +	b	1f
>> +alternative_else_nop_endif
>> +alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
>> +	b	2f
>> +alternative_else_nop_endif
>> +1:
>> +	orr	x4, x4, #(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB)
>> +	orr	x4, x4, #SCTLR_ELx_ENDA
>> +	orr	x4, x4, #SCTLR_ELx_ENDB
> 
> mm/proc.S builds the mask with ldr and ors it in one go, would be nice
> to use the same pattern.

Do you actually mean kernel/head.S, or even __ptrauth_keys_init_cpu in 
asm/asm_pointer_auth.h?

If so, I agree that it'd be good to make it look similar by using the 
mov_q macro, at the expense of a spare register (which we definitely can 
afford here).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
