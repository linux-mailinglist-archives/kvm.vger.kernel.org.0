Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEFA3668EC
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239034AbhDUKMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 06:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238992AbhDUKMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 06:12:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 700BB61442;
        Wed, 21 Apr 2021 10:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618999921;
        bh=pyxw1wvyyf/4Vjj3if7qcZ6LSESn5xcKY8VyD26urek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FXdgDFQxTn1Z5rP27R4O1OcY+E6dMXEHheWXrWAbBg2LL3TWCgwW4F4TbDnt1JLUb
         t3XZ1GRZ6TC01PWGVo25HHcuzXnqdHQ5DvPZMXgVRiN+eZrWeok1N6PKLzM4kA12be
         OXIPBSO97ocNFWVNAGjip8JgVsMYhT30Ui2PEpshEtrlmY4QgcnkV1g15idGLTKtLY
         2h0S3UfuzNlndOSkYYf9uxkp24vPP17wXT3affHy2hc88Klof6KXD//2tIz9q0MnM5
         Im6PLKDns2u8l57eknJM57s4s1yfuRFTFYgzKMownfSFpwXA7ZCJ11DLlQ8XUK6DqU
         NC1nlLDpNPBEg==
Date:   Wed, 21 Apr 2021 12:11:58 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v3 3/9] KVM: x86: Defer tick-based accounting 'til after
 IRQ handling
Message-ID: <20210421101158.GB16580@lothringen>
References: <20210415222106.1643837-1-seanjc@google.com>
 <20210415222106.1643837-4-seanjc@google.com>
 <20210420231402.GA8720@lothringen>
 <YH9jKpeviZtMKxt8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH9jKpeviZtMKxt8@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 11:26:34PM +0000, Sean Christopherson wrote:
> On Wed, Apr 21, 2021, Frederic Weisbecker wrote:
> > On Thu, Apr 15, 2021 at 03:21:00PM -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 16fb39503296..e4d475df1d4a 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -9230,6 +9230,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> > >  	local_irq_disable();
> > >  	kvm_after_interrupt(vcpu);
> > >  
> > > +	/*
> > > +	 * When using tick-based accounting, wait until after servicing IRQs to
> > > +	 * account guest time so that any ticks that occurred while running the
> > > +	 * guest are properly accounted to the guest.
> > > +	 */
> > > +	if (!vtime_accounting_enabled_this_cpu())
> > > +		vtime_account_guest_exit();
> > 
> > Can we rather have instead:
> > 
> > static inline void tick_account_guest_exit(void)
> > {
> > 	if (!vtime_accounting_enabled_this_cpu())
> > 		current->flags &= ~PF_VCPU;
> > }
> > 
> > It duplicates a bit of code but I think this will read less confusing.
> 
> Either way works for me.  I used vtime_account_guest_exit() to try to keep as
> many details as possible inside vtime, e.g. in case the implemenation is tweaked
> in the future.  But I agree that pretending KVM isn't already deeply intertwined
> with the details is a lie.

Ok let's keep it as is then. It reads funny but can we perhaps hope that
other archs have the same issue and in the future we'll need to have this split
generalized outside x86 with:

	* guest_exit_vtime()
	* guest_exit_tick()
