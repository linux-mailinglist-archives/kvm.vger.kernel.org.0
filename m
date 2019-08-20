Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C63952CA
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 02:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfHTAhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 20:37:02 -0400
Received: from mga18.intel.com ([134.134.136.126]:18010 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728580AbfHTAhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 20:37:02 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 17:37:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,406,1559545200"; 
   d="scan'208";a="377602884"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 19 Aug 2019 17:37:00 -0700
Date:   Mon, 19 Aug 2019 17:37:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Matt delco <delco@google.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
Message-ID: <20190820003700.GH1916@linux.intel.com>
References: <20190819230422.244888-1-delco@google.com>
 <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 01:42:37AM +0200, Paolo Bonzini wrote:
> On 20/08/19 01:04, Matt delco wrote:
> > From: Matt Delco <delco@google.com>
> > 
> > Time seems to eventually stop in a Windows VM when using Skype.
> > Instrumentation shows that the OS is frequently switching the APIC
> > timer between one-shot and periodic mode.  The OS is typically writing
> > to both LVTT and TMICT.  When time stops the sequence observed is that
> > the APIC was in one-shot mode, the timer expired, and the OS writes to
> > LVTT (but not TMICT) to change to periodic mode.  No future timer events
> > are received by the OS since the timer is only re-armed on TMICT writes.
> > 
> > With this change time continues to advance in the VM.  TBD if physical
> > hardware will reset the current count if/when the mode is changed to
> > period and the current count is zero.
> > 
> > Signed-off-by: Matt Delco <delco@google.com>
> > ---
> >  arch/x86/kvm/lapic.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 685d17c11461..fddd810eeca5 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> >  
> >  		break;
> >  
> > -	case APIC_LVTT:
> > +	case APIC_LVTT: {
> > +		u32 timer_mode = apic->lapic_timer.timer_mode;
> >  		if (!kvm_apic_sw_enabled(apic))
> >  			val |= APIC_LVT_MASKED;
> >  		val &= (apic_lvt_mask[0] | apic->lapic_timer.timer_mode_mask);
> >  		kvm_lapic_set_reg(apic, APIC_LVTT, val);
> >  		apic_update_lvtt(apic);
> > +		if (timer_mode == APIC_LVT_TIMER_ONESHOT &&
> > +		    apic_lvtt_period(apic) &&
> > +		    !hrtimer_active(&apic->lapic_timer.timer))
> > +			start_apic_timer(apic);
> 
> The manual says "A write to the LVT Timer Register that changes the
> timer mode disarms the local APIC timer", but we already know this is
> not true (commit dedf9c5e216902c6d34b5a0d0c40f4acbb3706d8).

That was a confirmed SDM bug that has been fixed as of the May 2019
version of the SDM.

> 
> Still, this needs some more explanation.  Can you cover this, as well as
> the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
> testcase?  Then we could try running it on bare metal and see what happens.

Only transitions to/from deadline should disable the timer, i.e. this
blurb from the SDM was found to be correct.

  Transitioning between TSC-deadline mode and other timer modes also
  disarms the timer.

But yeah, tests are in order, at least for oneshot->periodic and vice
versa.  I can't find any internal code that tests whether transitioning
between oneshot and periodic actually rearms the timer or if it simply
doesn't disable it, and the SDM doesn't clarify what constitutes
"reprogrammed".

If possible, we should also test what happens if APIC_TMCCT != 0, though
that might be tricky and/or fragile.  If the timer is rearmed on a
transition between oneshot and periodic, then I would expect it to happen
for both APIC_TMCCT==0 and APIC_TMCCT!=0.

> 
> Thanks,
> 
> Paolo
> 
> 
> >  		break;
> > -
> > +	}
> >  	case APIC_TMICT:
> >  		if (apic_lvtt_tscdeadline(apic))
> >  			break;
> > 
> 
