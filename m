Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C183C249A8B
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgHSKjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 06:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbgHSKj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 06:39:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E0A207BB;
        Wed, 19 Aug 2020 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597833568;
        bh=JgOkHxljjlEWKjxvXyX8OX88anY1gmQPeYvF0aYkVZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ldlYV90L+TJeBv/oCYia0+kUrpDf9tyew8a2EUELuBeF80woiLZndfWQCVUdUyBSS
         N1DTigmOO7l9XxQ2dRmzjPyA+Q05Ra75uXQj9/9WSC4th8n3Yvvh4+tJly3SuzHWWR
         184F36ZpNWf0FzJZwWu5hoSC7VhKdhhGlXTYICOg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k8LV9-004Aa2-By; Wed, 19 Aug 2020 11:39:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 Aug 2020 11:39:27 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Alexander Graf <graf@amazon.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
 sys_regs file
In-Reply-To: <HE1PR0802MB25552F2502B47554C6B53CADF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200805175700.62775-1-maz@kernel.org>
 <20200805175700.62775-48-maz@kernel.org>
 <HE1PR0802MB2555B630F149E07AF11846DEF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <551eac52dcd3b19ae6db45dd6f6e168b@kernel.org>
 <HE1PR0802MB25552F2502B47554C6B53CADF45D0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <5dd5ccf145b366e562782f117f25d880@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, pbonzini@redhat.com, richard.peng@oppo.com, kernel-team@android.com, kvm@vger.kernel.org, will@kernel.org, Catalin.Marinas@arm.com, graf@amazon.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-19 11:18, Jianyong Wu wrote:
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Wednesday, August 19, 2020 6:00 PM
>> To: Jianyong Wu <Jianyong.Wu@arm.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>; Peng Hao
>> <richard.peng@oppo.com>; kernel-team@android.com;
>> kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
>> <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
>> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
>> Subject: Re: [PATCH 47/56] KVM: arm64: timers: Move timer registers to 
>> the
>> sys_regs file
>> 
>> On 2020-08-19 10:24, Jianyong Wu wrote:
>> > Hi Marc,
>> >
>> > -----Original Message-----
>> > From: kvmarm-bounces@lists.cs.columbia.edu
>> > <kvmarm-bounces@lists.cs.columbia.edu> On Behalf Of Marc Zyngier
>> > Sent: Thursday, August 6, 2020 1:57 AM
>> > To: Paolo Bonzini <pbonzini@redhat.com>
>> > Cc: Peng Hao <richard.peng@oppo.com>; kernel-team@android.com;
>> > kvm@vger.kernel.org; Will Deacon <will@kernel.org>; Catalin Marinas
>> > <Catalin.Marinas@arm.com>; Alexander Graf <graf@amazon.com>;
>> > kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org
>> > Subject: [PATCH 47/56] KVM: arm64: timers: Move timer registers to the
>> > sys_regs file
>> >
>> > Move the timer gsisters to the sysreg file. This will further help
>> > when they are directly changed by a nesting hypervisor in the VNCR
>> > page.
>> >
>> > This requires moving the initialisation of the timer struct so that
>> > some of the helpers (such as arch_timer_ctx_index) can work correctly
>> > at an early stage.
>> >
>> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> > ---
>> >  arch/arm64/include/asm/kvm_host.h |   6 ++
>> >  arch/arm64/kvm/arch_timer.c       | 155 +++++++++++++++++++++++-------
>> >  arch/arm64/kvm/trace_arm.h        |   8 +-
>> >  include/kvm/arm_arch_timer.h      |  11 +--
>> >  4 files changed, 136 insertions(+), 44 deletions(-)
>> >
>> > +static u64 timer_get_offset(struct arch_timer_context *ctxt) {
>> > +	struct kvm_vcpu *vcpu = ctxt->vcpu;
>> > +
>> > +	switch(arch_timer_ctx_index(ctxt)) {
>> > +	case TIMER_VTIMER:
>> > +		return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
>> > +	default:
>> > +		return 0;
>> > +	}
>> > +}
>> > +
>> > Can I export this helper? As in my ptp_kvm implementation I need get
>> > VCNT offset value separately not just give me a result of VCNT.
>> 
>> Sorry, you need to give me a bit more context. What do you need the 
>> offset
>> for exactly?
> 
> Yeah,
> In my ptp_kvm implementation, I need acquire wall time and counter
> cycle in the same time in host. After get host counter cycle, I need
> subtract it by VCNT offset to obtain VCNT. See
> https://lkml.org/lkml/2020/6/19/441
> https://lkml.org/lkml/2020/6/19/441
> But now I can't get the VCNT offset easily like before using "
> vcpu_vtimer(vcpu)->cntvoff" and I can't use the helper like
> "kvm_arm_timer_read" as I need acquire the counter cycle in the same
> time with the host wall time.

I must be missing something. CNTVOFF_EL2 is now implemented as
a standard system register, and has the same visibility as any
other vcpu sysreg.

Why doesn't vcpu_read_sys_reg(vcpu, CNTVOFF_EL2) work for you?

         M.
-- 
Jazz is not dead. It just smells funny...
