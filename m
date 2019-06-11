Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C509C3D06D
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 17:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404376AbfFKPKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 11:10:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:52617 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404326AbfFKPKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 11:10:18 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jun 2019 08:10:15 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2019 08:10:14 -0700
Date:   Tue, 11 Jun 2019 08:10:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Optimize timer latency consider world
 switch time
Message-ID: <20190611151014.GA3416@linux.intel.com>
References: <1559284814-20378-1-git-send-email-wanpengli@tencent.com>
 <20190611012118.GC24835@linux.intel.com>
 <CANRm+CxrYJXB1WaBz0w1NpBkz8p5tAsmyoAVwTO0MueqcDkQLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANRm+CxrYJXB1WaBz0w1NpBkz8p5tAsmyoAVwTO0MueqcDkQLQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 09:38:18AM +0800, Wanpeng Li wrote:
> On Tue, 11 Jun 2019 at 09:21, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, May 31, 2019 at 02:40:13PM +0800, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Advance lapic timer tries to hidden the hypervisor overhead between the
> > > host emulated timer fires and the guest awares the timer is fired. However,
> > > even though after more sustaining optimizations, kvm-unit-tests/tscdeadline_latency
> > > still awares ~1000 cycles latency since we lost the time between the end of
> > > wait_lapic_expire and the guest awares the timer is fired. There are
> > > codes between the end of wait_lapic_expire and the world switch, furthermore,
> > > the world switch itself also has overhead. Actually the guest_tsc is equal
> > > to the target deadline time in wait_lapic_expire is too late, guest will
> > > aware the latency between the end of wait_lapic_expire() and after vmentry
> > > to the guest. This patch takes this time into consideration.
> > >
> > > The vmentry_lapic_timer_advance_ns module parameter should be well tuned by
> > > host admin, setting bit 0 to 1 to finally cache parameter in KVM. This patch
> > > can reduce average cyclictest latency from 3us to 2us on Skylake server.
> > > (guest w/ nohz=off, idle=poll, host w/ preemption_timer=N, the cyclictest
> > > latency is not too sensitive when preemption_timer=Y for this optimization in
> > > my testing), kvm-unit-tests/tscdeadline_latency can reach 0.
> > >
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > > NOTE: rebase on https://lkml.org/lkml/2019/5/20/449
> > > v1 -> v2:
> > >  * rename get_vmentry_advance_delta to get_vmentry_advance_cycles
> > >  * cache vmentry_advance_cycles by setting param bit 0
> > >  * add param max limit
> > >
> > >  arch/x86/kvm/lapic.c   | 38 +++++++++++++++++++++++++++++++++++---
> > >  arch/x86/kvm/lapic.h   |  3 +++
> > >  arch/x86/kvm/vmx/vmx.c |  2 +-
> > >  arch/x86/kvm/x86.c     |  9 +++++++++
> > >  arch/x86/kvm/x86.h     |  2 ++
> > >  5 files changed, 50 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index fcf42a3..60587b5 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -1531,6 +1531,38 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
> > >       apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> > >  }
> > >
> > > +#define MAX_VMENTRY_ADVANCE_NS 1000
> > > +
> > > +u64 compute_vmentry_advance_cycles(struct kvm_vcpu *vcpu)
> >
> > This can be static, unless get_vmentry_advance_cycles() is moved to
> > lapic.h, in which case compute_vmentry_advance_cycles() would need to be
> > exported.
> 
> Thanks for the review, Sean. I think Paolo has already drop this one.
> https://lkml.org/lkml/2019/5/31/210

I couldn't tell if Paolo's response was "no, don't do that" or "let's be
careful".  :-)
