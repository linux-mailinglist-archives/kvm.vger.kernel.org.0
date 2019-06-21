Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB7124F0A6
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2019 00:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFUWLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 18:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbfFUWLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 18:11:40 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D004A882F2;
        Fri, 21 Jun 2019 22:11:39 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B30F60BFB;
        Fri, 21 Jun 2019 22:11:39 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id F3863105169;
        Fri, 21 Jun 2019 18:42:11 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5LLg7R6005552;
        Fri, 21 Jun 2019 18:42:07 -0300
Date:   Fri, 21 Jun 2019 18:42:06 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by
 posted interrupt
Message-ID: <20190621214205.GA4751@amt.cnet>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-3-git-send-email-wanpengli@tencent.com>
 <20190618133541.GA3932@amt.cnet>
 <CANRm+Cz0v1VfDaCCWX+5RzCusTV7g9Hwr+OLGDRijeyqFx=Kzw@mail.gmail.com>
 <20190619210346.GA13033@amt.cnet>
 <CANRm+Cwxz7rR3o2m1HKg0-0z30B8-O-i4RrVC6EMG1jgBRxWPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANRm+Cwxz7rR3o2m1HKg0-0z30B8-O-i4RrVC6EMG1jgBRxWPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 21 Jun 2019 22:11:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 21, 2019 at 09:42:39AM +0800, Wanpeng Li wrote:
> On Thu, 20 Jun 2019 at 05:04, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > Hi Li,
> >
> > On Wed, Jun 19, 2019 at 08:36:06AM +0800, Wanpeng Li wrote:
> > > On Tue, 18 Jun 2019 at 21:36, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > >
> > > > On Mon, Jun 17, 2019 at 07:24:44PM +0800, Wanpeng Li wrote:
> > > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > > >
> > > > > Dedicated instances are currently disturbed by unnecessary jitter due
> > > > > to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> > > > > There is no hardware virtual timer on Intel for guest like ARM. Both
> > > > > programming timer in guest and the emulated timer fires incur vmexits.
> > > > > This patch tries to avoid vmexit which is incurred by the emulated
> > > > > timer fires in dedicated instance scenario.
> > > > >
> > > > > When nohz_full is enabled in dedicated instances scenario, the emulated
> > > > > timers can be offload to the nearest busy housekeeping cpus since APICv
> > > > > is really common in recent years. The guest timer interrupt is injected
> > > > > by posted-interrupt which is delivered by housekeeping cpu once the emulated
> > > > > timer fires.
> > > > >
> > > > > The host admin should fine tuned, e.g. dedicated instances scenario w/
> > > > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> > > > > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root
> > > > > mode, ~3% redis performance benefit can be observed on Skylake server.
> > > > >
> > > > > w/o patch:
> > > > >
> > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time
> > > > >
> > > > > EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )
> > > > >
> > > > > w/ patch:
> > > > >
> > > > >             VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time
> > > > >
> > > > > EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )
> > > > >
> > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > > > ---
> > > > >  arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++-------
> > > > >  arch/x86/kvm/lapic.h            |  1 +
> > > > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > > > >  arch/x86/kvm/x86.c              |  5 +++++
> > > > >  arch/x86/kvm/x86.h              |  2 ++
> > > > >  include/linux/sched/isolation.h |  2 ++
> > > > >  kernel/sched/isolation.c        |  6 ++++++
> > > > >  7 files changed, 44 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > > index 87ecb56..9ceeee5 100644
> > > > > --- a/arch/x86/kvm/lapic.c
> > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > @@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
> > > > >       return apic->vcpu->vcpu_id;
> > > > >  }
> > > > >
> > > > > +bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +     return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > > > > +             kvm_hlt_in_guest(vcpu->kvm);
> > > > > +}
> > > > > +EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> > > >
> > > > Paolo, can you explain the reasoning behind this?
> > > >
> > > > Should not be necessary...
> 
> https://lkml.org/lkml/2019/6/5/436  "Here you need to check
> kvm_halt_in_guest, not kvm_mwait_in_guest, because you need to go
> through kvm_apic_expired if the guest needs to be woken up from
> kvm_vcpu_block."

Ah, i think he means that a sleeping vcpu (in kvm_vcpu_block) must
be woken up, if it receives a timer interrupt.

But your patch will go through:

kvm_apic_inject_pending_timer_irqs
__apic_accept_irq -> 
vmx_deliver_posted_interrupt ->
kvm_vcpu_trigger_posted_interrupt returns false
(because vcpu->mode != IN_GUEST_MODE) ->
kvm_vcpu_kick

Which will wakeup the vcpu.

Apart from this oops, which triggers when running:
taskset -c 1 ./cyclictest -D 3600 -p 99 -t 1 -h 30 -m -n  -i 50000 -b 40

Timer interruption from housekeeping vcpus is normal to me 
(without requiring kvm_hlt_in_guest).

[ 1145.849646] BUG: kernel NULL pointer dereference, address:
0000000000000000
[ 1145.850481] #PF: supervisor instruction fetch in kernel mode
[ 1145.851161] #PF: error_code(0x0010) - not-present page
[ 1145.851772] PGD 80000002a9fa5067 P4D 80000002a9fa5067 PUD 2abcbb067
PMD 0 
[ 1145.852578] Oops: 0010 [#1] PREEMPT SMP PTI
[ 1145.853066] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.2.0-rc1+ #11
[ 1145.853809] Hardware name: Red Hat KVM, BIOS 1.11.0-2.el7 04/01/2014
[ 1145.854554] RIP: 0010:0x0
[ 1145.854879] Code: Bad RIP value.
[ 1145.855270] RSP: 0018:ffffc90001903e68 EFLAGS: 00010013
[ 1145.855902] RAX: 0000010ac9f60043 RBX: ffff8882b58a8320 RCX:
00000000c526b7c4              
[ 1145.856726] RDX: 0000000000000000 RSI: ffffffff820d9640 RDI:
ffff8882b58a8320              
[ 1145.857560] RBP: ffffffff820d9640 R08: 00000000c526b7c4 R09:
0000000000000832              
[ 1145.858390] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000              
[ 1145.859222] R13: ffffffff820d9658 R14: ffff8881063b2880 R15:
0000000000000002              
[ 1145.860047] FS:  0000000000000000(0000) GS:ffff8882b5880000(0000)
knlGS:0000000000000000   
[ 1145.860994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                              
[ 1145.861692] CR2: ffffffffffffffd6 CR3: 00000002ab1de001 CR4:
0000000000160ee0              
[ 1145.862570] Call Trace:                                                                    
[ 1145.862877]  cpuidle_enter_state+0x7c/0x3e0                                                
[ 1145.863392]  cpuidle_enter+0x29/0x40                                                       


> I think we can still be woken up from kvm_vcpu_block() if pir is set.

Exactly.

