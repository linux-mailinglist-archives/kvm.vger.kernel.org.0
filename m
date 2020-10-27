Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0217F29BB8C
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 17:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1808587AbgJ0QRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 12:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1808576AbgJ0QRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 12:17:34 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11D12074B;
        Tue, 27 Oct 2020 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603815453;
        bh=ts1g+L2Vn0iI0TtNwDUCHfNkNs58hX2yUbH7A6NlHHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ief13jGr2sZv7X1wHpneogJel5IGfAmDhHjELJL9uqxaeXpfImnf904FW6yPw4u2Z
         WmPT4hqdD2J/79dMplhXkW2fNbSjcna+GMBnBlWX9JckSTqse4IQzduSxzsc1sHzzT
         G51zCCdKref2YErCvL19y1+8JS++z05dOg/xdijc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kXRf9-004o74-Ku; Tue, 27 Oct 2020 16:17:31 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 16:17:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private to
 HYP
In-Reply-To: <20201026140435.GE12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-4-maz@kernel.org>
 <20201026140435.GE12454@C02TD0UTHF1T.local>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <bde9a2a8233f3d7e96751ad3640b11b7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-26 14:04, Mark Rutland wrote:
> On Mon, Oct 26, 2020 at 01:34:42PM +0000, Marc Zyngier wrote:
>> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
>> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
>> to increment PC post emulation is now signalled via a flag in the
>> vcpu structure.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> [...]
> 
>> +/*
>> + * Adjust the guest PC on entry, depending on flags provided by EL1
>> + * for the purpose of emulation (MMIO, sysreg).
>> + */
>> +static inline void __adjust_pc(struct kvm_vcpu *vcpu)
>> +{
>> +	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
>> +		kvm_skip_instr(vcpu);
>> +		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
>> +	}
>> +}
> 
> What's your plan for restricting *when* EL1 can ask for the PC to be
> adjusted?
> 
> I'm assuming that either:
> 
> 1. You have EL2 sanity-check all responses from EL1 are permitted for
>    the current state. e.g. if EL1 asks to increment the PC, EL2 must
>    check that that was a sane response for the current state.
> 
> 2. You raise the level of abstraction at the EL2/EL1 boundary, such 
> that
>    EL2 simply knows. e.g. if emulating a memory access, EL1 can either
>    provide the response or signal an abort, but doesn't choose to
>    manipulate the PC as EL2 will infer the right thing to do.
> 
> I know that either are tricky in practice, so I'm curious what your 
> view
> is. Generally option #2 is easier to fortify, but I guess we might have
> to do #1 since we also have to support unprotected VMs?

To be honest, I'm still in two minds about it, which is why I have
gone with this "middle of the road" option (moving the PC update
to EL2, but leave the control at EL1).

I guess the answer is "it depends". MMIO is easy to put in the #2 model,
while things like WFI/WFE really need #1. sysregs are yet another can of
worm.

         M.
-- 
Jazz is not dead. It just smells funny...
