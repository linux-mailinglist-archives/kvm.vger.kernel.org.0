Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA8F27D353
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgI2QJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 12:09:09 -0400
Received: from foss.arm.com ([217.140.110.172]:47732 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgI2QJJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 12:09:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36DE731B;
        Tue, 29 Sep 2020 09:09:08 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 018973F73B;
        Tue, 29 Sep 2020 09:09:06 -0700 (PDT)
Date:   Tue, 29 Sep 2020 17:09:01 +0100
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 22/23] KVM: arm64: Add a rVIC/rVID in-kernel
 implementation
Message-ID: <20200929160901.GA5517@e121166-lin.cambridge.arm.com>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-23-maz@kernel.org>
 <20200929151354.GA4877@e121166-lin.cambridge.arm.com>
 <136948b6e93db336b8a87e8f16335e7c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <136948b6e93db336b8a87e8f16335e7c@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 04:27:45PM +0100, Marc Zyngier wrote:
> Hi Lorenzo,
> 
> On 2020-09-29 16:13, Lorenzo Pieralisi wrote:
> > On Thu, Sep 03, 2020 at 04:26:09PM +0100, Marc Zyngier wrote:
> > 
> > [...]
> > 
> > > +static void __rvic_sync_hcr(struct kvm_vcpu *vcpu, struct rvic *rvic,
> > > +			    bool was_signaling)
> > > +{
> > > +	struct kvm_vcpu *target = kvm_rvic_to_vcpu(rvic);
> > > +	bool signal = __rvic_can_signal(rvic);
> > > +
> > > +	/* We're hitting our own rVIC: update HCR_VI locally */
> > > +	if (vcpu == target) {
> > > +		if (signal)
> > > +			*vcpu_hcr(vcpu) |= HCR_VI;
> > > +		else
> > > +			*vcpu_hcr(vcpu) &= ~HCR_VI;
> > > +
> > > +		return;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Remote rVIC case:
> > > +	 *
> > > +	 * We kick even if the interrupt disappears, as ISR_EL1.I must
> > > +	 * always reflect the state of the rVIC. This forces a reload
> > > +	 * of the vcpu state, making it consistent.
> > 
> > Forgive me the question but this is unclear to me. IIUC here we do _not_
> > want to change the target_vcpu.hcr and we force a kick to make sure it
> > syncs the hcr (so the rvic) state on its own upon exit. Is that correct
> > ?
> 
> This is indeed correct. Changing the vcpu's hcr is racy as we sometimes
> update it on vcpu exit, so directly updating this field would require
> introducing atomic accesses between El1 and EL2. Not happening.
> 
> Instead, we force the vcpu to reload its own state as it *reenters*
> the guest (and not on exit). This way, no locking, no cmpxchg, everything
> is still single threaded.
> 
> > Furthermore, I think it would be extremely useful to elaborate (ie
> > rework the comment) further on ISR_EL1.I and how it is linked to this
> > code path - I think it is key to understanding it.
> 
> I'm not really sure what to add here, apart from paraphrasing the ARM ARM.
> ISR_EL1 always represents the interrupt input to the CPU, virtual or not,
> and we must honor this requirements by making any change of output of
> the rVIC directly observable (i.e. update HCR_EL2.VI).

Ok got it. Basically we kick the target_vcpu because there is a change
in its IRQ input signal that has to be signalled (by updating the
HCR_EL2.VI that in turns updates the ISR_EL1.I). I read the comment as
if we don't care about the target_vcpu.hcr_el2 update and was struggling
to understand the whole code path.

Back to reading the code (properly :)).

Thanks,
Lorenzo
