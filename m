Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C2D4C2AF
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 23:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbfFSVEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 17:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfFSVEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 17:04:12 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 175BEC05A1D8;
        Wed, 19 Jun 2019 21:04:12 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 899DE6013D;
        Wed, 19 Jun 2019 21:04:11 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id B80E3105169;
        Wed, 19 Jun 2019 18:03:51 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5JL3lQR013428;
        Wed, 19 Jun 2019 18:03:47 -0300
Date:   Wed, 19 Jun 2019 18:03:47 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by
 posted interrupt
Message-ID: <20190619210346.GA13033@amt.cnet>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com>
 <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 19 Jun 2019 21:04:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Li,

On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Dedicated instances are currently disturbed by unnecessary jitter due
> > > to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> > > There is no hardware virtual timer on Intel for guest like ARM. Both
> > > programming timer in guest and the emulated timer fires incur vmexits.
> > > This patch tries to avoid vmexit which is incurred by the emulated
> > > timer fires in dedicated instance scenario.
> > >
> > > When nohz_full is enabled in dedicated instances scenario, the emulated
> > > timers can be offload to the nearest busy housekeeping cpus since APICv
> > > is really common in recent years. The guest timer interrupt is injected
> > > by posted-interrupt which is delivered by housekeeping cpu once the emulated
> > > timer fires.
> > >
> > > The host admin should fine tuned, e.g. dedicated instances scenario w/
> > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> > > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root
> > > mode, ~3% redis performance benefit can be observed on Skylake server.
> > >
> > > w/o patch:
> > >
> > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time
> > >
> > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )
> > >
> > > w/ patch:
> > >
> > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time
> > >
> > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )
> > >
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++-------
> > >  arch/x86/kvm/lapic.h            |  1 +
> > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > >  arch/x86/kvm/x86.c              |  5 +++++
> > >  arch/x86/kvm/x86.h              |  2 ++
> > >  include/linux/sched/isolation.h |  2 ++
> > >  kernel/sched/isolation.c        |  6 ++++++
> > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 87ecb56..9ceeee5 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> > >       return apic->vcpu->vcpu_id;
> > >  }
> > >
> > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > > +{
> > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > +}
> > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> >
> > Paolo, can you explain the reasoning behind this?
> >
> > Should not be necessary...
> 
> Here some new discussions:
> https://lkml.org/lkml/2019/6/13/1423

Not sure what this has to do with injecting timer
interrupts via posted interrupts ?

> https://lkml.org/lkml/2019/6/13/1420

Two things (unrelated to the above):

1) hrtimer_reprogram is unable to wakeup a remote vCPU, therefore 
i believe execution of apic_timer_expired can be delayed. 
Should wakeup the CPU which hosts apic_timer_expired.


        /*
         * If the timer is not on the current cpu, we cannot reprogram
         * the other cpus clock event device.
         */
        if (base->cpu_base != cpu_base)
                return;

2) Getting an oops when running cyclictest, debugging...
