Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF76366AA4
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 14:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbhDUMUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 08:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhDUMUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 08:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E64C76140C;
        Wed, 21 Apr 2021 12:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619007583;
        bh=JOl+aIBSn3499sx+oDjhcxUdwKyEp9O8JzCAmqtJA6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nCXPCTA023tg5fE1cJn77sqHUVnvVESiwVeIugvqbW71yNe0ghv6GI0N86K4281At
         dsxrPPrG3jjhlS/8fGvRVmCuWrb0wLnpJrTRYxDYv5WhljZsD2bnIcC7Ta8vEBBnXI
         U/Qw5fvGEwI4EaO9rWoE3KkdwRqMjA3zknN/P2ZeEVonj4Ae1i7FZSUvPpfz47FPza
         6Ts0uBZ457es2DkuKTBVNp+KiuC7IcXLCSg3QI4ZLFPQf/LNzNBBe3CP5QeukAORbP
         /veCv6otKatgNec9WvgF4JU3PMjtmIiO3fD/2HOykbPhkt2J9TybEREBNVJkgXE09C
         b7zqGFlo441jQ==
Date:   Wed, 21 Apr 2021 14:19:40 +0200
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
Message-ID: <20210421121940.GD16580@lothringen>
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

Ah I see, before 87fa7f3e98a131 the vtime was accounted after interrupts get
processed. So it used to work until then. I see that ARM64 waits for IRQs to
be enabled too.

PPC/book3s_hv, MIPS, s390 do it before IRQs get re-enabled (weird, how does that
work?)

And PPC/book3s_pr calls guest_exit() so I guess it has interrupts enabled.

The point is: does it matter to call vtime_account_guest_exit() before or
after interrupts? If it doesn't matter, we can simply call
vtime_account_guest_exit() once and for all once IRQs are re-enabled.

If it does matter because we don't want to account the host IRQs firing at the
end of vcpu exit, then probably we should standardize that behaviour and have
guest_exit_vtime() called before interrupts get enabled and guest_exit_tick()
called after interrupts get enabled. It's probably then beyond the scope of this
patchset but I would like to poke your opinion on that.

Thanks.
