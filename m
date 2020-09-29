Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E8727CFF3
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 15:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgI2NwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 09:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729569AbgI2NwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 09:52:16 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE014208FE;
        Tue, 29 Sep 2020 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601387535;
        bh=hQplG5p9tGOxcviNNQcl3I0N/iuuu8kEYoGGBZCS7rw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RtOw9CNXbEM1K9LHxZ4EFc3LZJLlrLa7VRb9asVe7RwAf9yoa+M82lCzAExVAvfWe
         5wPJCQNm/Z8o5aKxZtm9zzWX0cwfWugVzP5sRqYc1KF9Pv0iQ744KMw6tl4ZIXxoXx
         3OPTNOgAkrC53rJ0l/GSYrPdu3xSCV71un138CDo=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kNG3A-00FrSs-M2; Tue, 29 Sep 2020 14:52:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Sep 2020 14:52:12 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across
 reset
In-Reply-To: <20200910164243.29253-1-graf@amazon.com>
References: <20200910164243.29253-1-graf@amazon.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <4f33899554e54e3c4485612394898864@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: graf@amazon.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com, drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-09-10 17:42, Alexander Graf wrote:
> We allow user space to set the PMCR register to any value. However,
> when time comes for a vcpu reset (for example on PSCI online), PMCR
> is reset to the hardware capabilities.
> 
> I would like to explicitly expose different PMU capabilities (number
> of supported event counters) to the guest than hardware supports.
> Ideally across vcpu resets.
> 
> So this patch adopts the reset path to only populate the immutable
> PMCR register bits from hardware when they were not initialized
> previously. This effectively means that on a normal reset, only the
> guest settable fields are reset, while on vcpu creation the register
> gets populated from hardware like before.
> 
> With this in place and a change in user space to invoke SET_ONE_REG
> on the PMCR for every vcpu, I can reliably set the PMU event counter
> number to arbitrary values.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 20ab2a7d37ca..28f67550db7f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu,
> const struct sys_reg_desc *r)
>  {
>  	u64 pmcr, val;
> 
> -	pmcr = read_sysreg(pmcr_el0);
> +	/*
> +	 * If we already received PMCR from a previous ONE_REG call,
> +	 * maintain its immutable flags
> +	 */
> +	pmcr = __vcpu_sys_reg(vcpu, r->reg);
> +	if (!__vcpu_sys_reg(vcpu, r->reg))
> +		pmcr = read_sysreg(pmcr_el0);
> +
>  	/*
>  	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to 
> UNKNOWN
>  	 * except PMCR.E resetting to zero.

I'm afraid you may need a bit more than just this hack. At the moment,
although we can write junk into the shadow copy of PMCR_EL0, the reset
will make that behave correctly. With this patch, the junk sticks and
gets exposed to the guest.

You need at least a .set_user callback to the handling of PMCR_EL0
so that the value stored is legal, follows the architectural
behaviour, and matches the host capabilities.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
