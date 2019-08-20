Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381D2953E7
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 03:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfHTB4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 21:56:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:62032 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbfHTB4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 21:56:43 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 18:56:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,407,1559545200"; 
   d="scan'208";a="195662061"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 19 Aug 2019 18:56:41 -0700
Date:   Mon, 19 Aug 2019 18:56:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Matt Delco <delco@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH] KVM: lapic: restart counter on change to periodic mode
Message-ID: <20190820015641.GK1916@linux.intel.com>
References: <20190819230422.244888-1-delco@google.com>
 <80390180-93a3-4d6e-b62a-d4194eb13106@redhat.com>
 <20190820003700.GH1916@linux.intel.com>
 <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGX9VrZyPQ8OxnYnOWg-ES3=kghSx1LSyzrX8i3=O+o0JAsig@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Cc Nadav

On Mon, Aug 19, 2019 at 06:07:01PM -0700, Matt Delco wrote:
> On Mon, Aug 19, 2019 at 5:37 PM Sean Christopherson <
> sean.j.christopherson@intel.com> wrote:
> 
> > On Tue, Aug 20, 2019 at 01:42:37AM +0200, Paolo Bonzini wrote:
> > > On 20/08/19 01:04, Matt delco wrote:
> > > > From: Matt Delco <delco@google.com>
> > > >
> > > > Time seems to eventually stop in a Windows VM when using Skype.
> > > > Instrumentation shows that the OS is frequently switching the APIC
> > > > timer between one-shot and periodic mode.  The OS is typically writing
> > > > to both LVTT and TMICT.  When time stops the sequence observed is that
> > > > the APIC was in one-shot mode, the timer expired, and the OS writes to
> > > > LVTT (but not TMICT) to change to periodic mode.  No future timer
> > events
> > > > are received by the OS since the timer is only re-armed on TMICT
> > writes.
> > > >
> > > > With this change time continues to advance in the VM.  TBD if physical
> > > > hardware will reset the current count if/when the mode is changed to
> > > > period and the current count is zero.
> > > >
> > > > Signed-off-by: Matt Delco <delco@google.com>
> > > > ---
> > > >  arch/x86/kvm/lapic.c | 9 +++++++--
> > > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 685d17c11461..fddd810eeca5 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -1935,14 +1935,19 @@ int kvm_lapic_reg_write(struct kvm_lapic
> > *apic, u32 reg, u32 val)
> > > >
> > > >             break;
> > > >
> > > > -   case APIC_LVTT:
> > > > +   case APIC_LVTT: {
> > > > +           u32 timer_mode = apic->lapic_timer.timer_mode;
> > > >             if (!kvm_apic_sw_enabled(apic))
> > > >                     val |= APIC_LVT_MASKED;
> > > >             val &= (apic_lvt_mask[0] |
> > apic->lapic_timer.timer_mode_mask);
> > > >             kvm_lapic_set_reg(apic, APIC_LVTT, val);
> > > >             apic_update_lvtt(apic);
> > > > +           if (timer_mode == APIC_LVT_TIMER_ONESHOT &&
> > > > +               apic_lvtt_period(apic) &&
> > > > +               !hrtimer_active(&apic->lapic_timer.timer))
> > > > +                   start_apic_timer(apic);
> > >
> > > Still, this needs some more explanation.  Can you cover this, as well as
> > > the oneshot->periodic transition, in kvm-unit-tests' x86/apic.c
> > > testcase?  Then we could try running it on bare metal and see what
> > happens.
> >
> 
> I looked at apic.c and test_apic_change_mode() might already be testing
> this.  It sets oneshot & TMICT, waits for the current value to get
> half-way, changes the mode to periodic, and then tries to test that the
> value wraps back to the upper half.  It then waits again for the half-way
> point, changes the mode back to oneshot, and waits for zero.  After
> reaching zero it does:
> 
> /* now tmcct == 0 and tmict != 0 */
> apic_change_mode(APIC_LVT_TIMER_PERIODIC);
> report("TMCCT should stay at zero", !apic_read(APIC_TMCCT));
> 
> which seems to be testing that oneshot->periodic won't reset the timer if
> it's already zero.  A possible caveat is there's hardly any delay between
> the mode change and the timer read.  Emulated hardware will react
> instantaneously (at least as seen from within the VM), but hardware might
> need more time to react (though offhand I'd expect HW to be fast enough for
> this particular timer).
> 
> So, it looks like the code might already be ready to run on physical
> hardware, and if it has (or does already as part of a regular test), then
> that does raise some doubt on what's the appropriate code change to make
> this work.

Nadav has been running tests on bare metal, maybe he can weigh in on
whether or not test_apic_change_mode() passes on bare metal.
