Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E653927D2AE
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 17:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgI2P1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 11:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgI2P1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 11:27:49 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3A15207F7;
        Tue, 29 Sep 2020 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601393268;
        bh=i5XygYKUbhjc8E7QHK8mBozTXBb67C6QTVJ1UnIiG+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qebXSOEKVQP7sAM/WeZKDV0h0M+ThqhsZpd2dxoZ5S+QiYYN0W5P1KjkWWawU+Eqm
         92HcIL4waMmBaLPDiYFFgLQSK3SaHjNGukYxY833e/xLElEaMKGabwNonYG/mB2eVu
         i4ERqRrGhRegCe/43k2019Q8aETP7xDt5EyMvisQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kNHXd-00Fsvn-Rl; Tue, 29 Sep 2020 16:27:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Sep 2020 16:27:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 22/23] KVM: arm64: Add a rVIC/rVID in-kernel
 implementation
In-Reply-To: <20200929151354.GA4877@e121166-lin.cambridge.arm.com>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-23-maz@kernel.org>
 <20200929151354.GA4877@e121166-lin.cambridge.arm.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <136948b6e93db336b8a87e8f16335e7c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lorenzo.pieralisi@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Lorenzo,

On 2020-09-29 16:13, Lorenzo Pieralisi wrote:
> On Thu, Sep 03, 2020 at 04:26:09PM +0100, Marc Zyngier wrote:
> 
> [...]
> 
>> +static void __rvic_sync_hcr(struct kvm_vcpu *vcpu, struct rvic *rvic,
>> +			    bool was_signaling)
>> +{
>> +	struct kvm_vcpu *target = kvm_rvic_to_vcpu(rvic);
>> +	bool signal = __rvic_can_signal(rvic);
>> +
>> +	/* We're hitting our own rVIC: update HCR_VI locally */
>> +	if (vcpu == target) {
>> +		if (signal)
>> +			*vcpu_hcr(vcpu) |= HCR_VI;
>> +		else
>> +			*vcpu_hcr(vcpu) &= ~HCR_VI;
>> +
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Remote rVIC case:
>> +	 *
>> +	 * We kick even if the interrupt disappears, as ISR_EL1.I must
>> +	 * always reflect the state of the rVIC. This forces a reload
>> +	 * of the vcpu state, making it consistent.
> 
> Forgive me the question but this is unclear to me. IIUC here we do 
> _not_
> want to change the target_vcpu.hcr and we force a kick to make sure it
> syncs the hcr (so the rvic) state on its own upon exit. Is that correct 
> ?

This is indeed correct. Changing the vcpu's hcr is racy as we sometimes
update it on vcpu exit, so directly updating this field would require
introducing atomic accesses between El1 and EL2. Not happening.

Instead, we force the vcpu to reload its own state as it *reenters*
the guest (and not on exit). This way, no locking, no cmpxchg, 
everything
is still single threaded.

> Furthermore, I think it would be extremely useful to elaborate (ie
> rework the comment) further on ISR_EL1.I and how it is linked to this
> code path - I think it is key to understanding it.

I'm not really sure what to add here, apart from paraphrasing the ARM 
ARM.
ISR_EL1 always represents the interrupt input to the CPU, virtual or 
not,
and we must honor this requirements by making any change of output of
the rVIC directly observable (i.e. update HCR_EL2.VI).

         M.
-- 
Jazz is not dead. It just smells funny...
