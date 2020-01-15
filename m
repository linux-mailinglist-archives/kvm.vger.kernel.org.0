Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1028213C4DA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 15:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgAOOD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 09:03:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgAOOD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 09:03:27 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B82C5222C3;
        Wed, 15 Jan 2020 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579097006;
        bh=JirmHW6SrM9Hhd8eR0okNq08LwBENG1og0f1buqr/1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fQaWytZ7KsNB89iwcVBDmdEt+rfMqlGGqtUg+R8Ieh2y8PCK5qUynF6pqnwoxIMbT
         kLYBAQ7i9EurH/JL1cvPviuEvCTxl9ZCL9wzODI8sLMvDUbVqUrdV4T4MV9MbsmmmR
         9e1OyDH3nKRPFogqMEy0l+gAhzniSWMYDe4q+wQ0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1irjGW-0000US-UF; Wed, 15 Jan 2020 14:03:25 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Jan 2020 14:03:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 10/18] arm64: KVM/debug: use EL1&0 stage 1 translation
 regime
In-Reply-To: <20200113163138.GP42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-11-andrew.murray@arm.com>
 <86d0cgir74.wl-maz@kernel.org>
 <20200113163138.GP42593@e119886-lin.cambridge.arm.com>
Message-ID: <5f141f153ceec55b4428d9c2d2dd9064@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, catalin.marinas@arm.com, will@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-01-13 16:31, Andrew Murray wrote:
> On Sun, Dec 22, 2019 at 10:34:55AM +0000, Marc Zyngier wrote:
>> On Fri, 20 Dec 2019 14:30:17 +0000,
>> Andrew Murray <andrew.murray@arm.com> wrote:
>> >
>> > From: Sudeep Holla <sudeep.holla@arm.com>
>> >
>> > Now that we have all the save/restore mechanism in place, lets enable
>> > the translation regime used by buffer from EL2 stage 1 to EL1 stage 1
>> > on VHE systems.
>> >
>> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> > [ Reword commit, don't trap to EL2 ]
>> 
>> Not trapping to EL2 for the case where we don't allow SPE in the
>> guest is not acceptable.
>> 
>> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>> > ---
>> >  arch/arm64/kvm/hyp/switch.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> > index 67b7c160f65b..6c153b79829b 100644
>> > --- a/arch/arm64/kvm/hyp/switch.c
>> > +++ b/arch/arm64/kvm/hyp/switch.c
>> > @@ -100,6 +100,7 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>> >
>> >  	write_sysreg(val, cpacr_el1);
>> >
>> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
>> >  	write_sysreg(kvm_get_hyp_vector(), vbar_el1);
>> >  }
>> >  NOKPROBE_SYMBOL(activate_traps_vhe);
>> > @@ -117,6 +118,7 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
>> >  		__activate_traps_fpsimd32(vcpu);
>> >  	}
>> >
>> > +	write_sysreg(vcpu->arch.mdcr_el2 | 3 << MDCR_EL2_E2PB_SHIFT, mdcr_el2);
>> 
>> There is a _MASK macro that can replace this '3', and is in keeping
>> with the rest of the code.
>> 
>> It still remains that it looks like the wrong place to do this, and
>> vcpu_load seems much better. Why should you write to mdcr_el2 on each
>> entry to the guest, since you know whether it has SPE enabled at the
>> point where it gets scheduled?
> 
> For nVHE, the only reason we'd want to change E2PB on entry/exit of 
> guest
> would be if the host is also using SPE. If the host is using SPE whilst
> the vcpu is 'loaded' but we're not in the guest, then host SPE could 
> raise
> an interrupt - we need the E2PB bits to allow access from EL1 (host).

My comment was of course for VHE. nVHE hardly makes use of load/put at 
all,
for obvious reasons.

         M.
-- 
Jazz is not dead. It just smells funny...
