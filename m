Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88455787
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 21:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbfFYTDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 15:03:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727684AbfFYTDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 15:03:45 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9551E85363;
        Tue, 25 Jun 2019 19:03:44 +0000 (UTC)
Received: from amt.cnet (ovpn-112-13.gru2.redhat.com [10.97.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 126B26012D;
        Tue, 25 Jun 2019 19:03:44 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id D665110517A;
        Tue, 25 Jun 2019 16:00:21 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5PJ0H0G003435;
        Tue, 25 Jun 2019 16:00:17 -0300
Date:   Tue, 25 Jun 2019 16:00:13 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by
 posted interrupt
Message-ID: <20190625190010.GA3377@amt.cnet>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com>
 <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
 <20190619210346.GA13033@amt.cnet>
 <CANRm+Cwxz7rR3o2m1HKg0-0z30B8-O-i4RrVC6EMG1jgBRxWPg@mail.gmail.com>
 <20190621214205.GA4751@amt.cnet>
 <CANRm+CxUgkF7zRmHC_MD2s00waj6qztWdPAm_u9Rhk34_bevfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANRm+CxUgkF7zRmHC_MD2s00waj6qztWdPAm_u9Rhk34_bevfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 25 Jun 2019 19:03:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 24, 2019 at 04:53:53PM +0800, Wanpeng Li wrote:
> On Sat, 22 Jun 2019 at 06:11, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Fri, Jun 21, 2019 at 09:42:39AM +0800, Wanpeng Li wrote:
> > > On Thu, 20 Jun 2019 at 05:04, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > >
> > > > Hi Li,
> > > >
> > > > On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> > > > > On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > > > > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > > > > >
> > > > > > > Dedicated instances are currently disturbed by unnecessary jitter due
> > > > > > > to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> > > > > > > There is no hardware virtual timer on Intel for guest like ARM. Both
> > > > > > > programming timer in guest and the emulated timer fires incur vmexits.
> > > > > > > This patch tries to avoid vmexit which is incurred by the emulated
> > > > > > > timer fires in dedicated instance scenario.
> > > > > > >
> > > > > > > When nohz_full is enabled in dedicated instances scenario, the emulated
> > > > > > > timers can be offload to the nearest busy housekeeping cpus since APICv
> > > > > > > is really common in recent years. The guest timer interrupt is injected
> > > > > > > by posted-interrupt which is delivered by housekeeping cpu once the emulated
> > > > > > > timer fires.
> > > > > > >
> > > > > > > The host admin should fine tuned, e.g. dedicated instances scenario w/
> > > > > > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> > > > > > > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root
> > > > > > > mode, ~3% redis performance benefit can be observed on Skylake server.
> > > > > > >
> > > > > > > w/o patch:
> > > > > > >
> > > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time
> > > > > > >
> > > > > > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )
> > > > > > >
> > > > > > > w/ patch:
> > > > > > >
> > > > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time
> > > > > > >
> > > > > > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )
> > > > > > >
> > > > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > > > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > > > > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > > > ---
> > > > > > >  arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++-------
> > > > > > >  arch/x86/kvm/lapic.h            |  1 +
> > > > > > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > > > > > >  arch/x86/kvm/x86.c              |  5 +++++
> > > > > > >  arch/x86/kvm/x86.h              |  2 ++
> > > > > > >  include/linux/sched/isolation.h |  2 ++
> > > > > > >  kernel/sched/isolation.c        |  6 ++++++
> > > > > > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > > > > index 87ecb56..9ceeee5 100644
> > > > > > > --- a/arch/x86/kvm/lapic.c
> > > > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> > > > > > >       return apic->vcpu->vcpu_id;
> > > > > > >  }
> > > > > > >
> > > > > > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > > > > > > +{
> > > > > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > > > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > > > > > +}
> > > > > > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> > > > > >
> > > > > > Paolo, can you explain the reasoning behind this?
> > > > > >
> > > > > > Should not be necessary...
> > >
> > > https://lkml.org/lkml/2019/6/5/436  "Here you need to check
> > > kvm_halt_in_guest, not kvm_mwait_in_guest, because you need to go
> > > through kvm_apic_expired if the guest needs to be woken up from
> > > kvm_vcpu_block."
> >
> > Ah, i think he means that a sleeping vcpu (in kvm_vcpu_block) must
> > be woken up, if it receives a timer interrupt.
> >
> > But your patch will go through:
> >
> > kvm_apic_inject_pending_timer_irqs
> > __apic_accept_irq ->
> > vmx_deliver_posted_interrupt ->
> > kvm_vcpu_trigger_posted_interrupt returns false
> > (because vcpu->mode != IN_GUEST_MODE) ->
> > kvm_vcpu_kick
> >
> > Which will wakeup the vcpu.
> 
> Hi Marcelo,
> 
> >
> > Apart from this oops, which triggers when running:
> > taskset -c 1 ./cyclictest -D 3600 -p 99 -t 1 -h 30 -m -n  -i 50000 -b 40
> 
> I try both host and guest use latest kvm/queue  w/ CONFIG_PREEMPT
> enabled, and expose mwait as your config, however, there is no oops.
> Can you reproduce steadily or encounter casually? Can you reproduce
> w/o the patchset?

Hi Li,

Steadily.

Do you have this as well:

Index: kvm/arch/x86/kvm/lapic.c
===================================================================
--- kvm.orig/arch/x86/kvm/lapic.c
+++ kvm/arch/x86/kvm/lapic.c
@@ -129,8 +129,7 @@ static inline u32 kvm_x2apic_id(struct k

 bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
 {
-       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
-               kvm_hlt_in_guest(vcpu->kvm);
+       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
 }
 EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
