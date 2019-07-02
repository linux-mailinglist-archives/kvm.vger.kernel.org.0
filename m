Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF785D9A7
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 02:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfGCAtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 20:49:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbfGCAtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 20:49:22 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04758307CDF0;
        Tue,  2 Jul 2019 22:23:50 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75D565D9DE;
        Tue,  2 Jul 2019 22:23:49 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 0DAED10516E;
        Tue,  2 Jul 2019 19:23:32 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x62MNUrh028441;
        Tue, 2 Jul 2019 19:23:30 -0300
Date:   Tue, 2 Jul 2019 19:23:30 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v5 0/4] KVM: LAPIC: Implement Exitless Timer
Message-ID: <20190702222330.GB26621@amt.cnet>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
 <1fbd236a-f7f9-e66a-e08c-bf2bac901d15@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fbd236a-f7f9-e66a-e08c-bf2bac901d15@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 02 Jul 2019 22:23:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 02, 2019 at 06:38:56PM +0200, Paolo Bonzini wrote:
> On 21/06/19 11:39, Wanpeng Li wrote:
> > Dedicated instances are currently disturbed by unnecessary jitter due 
> > to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> > There is no hardware virtual timer on Intel for guest like ARM. Both 
> > programming timer in guest and the emulated timer fires incur vmexits.
> > This patchset tries to avoid vmexit which is incurred by the emulated 
> > timer fires in dedicated instance scenario. 
> > 
> > When nohz_full is enabled in dedicated instances scenario, the unpinned 
> > timer will be moved to the nearest busy housekeepers after commit
> > 9642d18eee2cd (nohz: Affine unpinned timers to housekeepers) and commit 
> > 444969223c8 ("sched/nohz: Fix affine unpinned timers mess"). However, 
> > KVM always makes lapic timer pinned to the pCPU which vCPU residents, the 
> > reason is explained by commit 61abdbe0 (kvm: x86: make lapic hrtimer 
> > pinned). Actually, these emulated timers can be offload to the housekeeping 
> > cpus since APICv is really common in recent years. The guest timer interrupt 
> > is injected by posted-interrupt which is delivered by housekeeping cpu 
> > once the emulated timer fires. 
> > 
> > The host admin should fine tuned, e.g. dedicated instances scenario w/ 
> > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus 
> > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root  
> > mode, ~3% redis performance benefit can be observed on Skylake server.
> 
> Marcelo,
> 
> does this patch work for you or can you still see the oops?

Hi Paolo,

No more oopses with kvm/queue. Can you include:

Index: kvm/arch/x86/kvm/lapic.c
===================================================================
--- kvm.orig/arch/x86/kvm/lapic.c
+++ kvm/arch/x86/kvm/lapic.c
@@ -124,8 +124,7 @@ static inline u32 kvm_x2apic_id(struct k
 
 bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
-		kvm_hlt_in_guest(vcpu->kvm);
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
 }
 EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
 
However, for some reason (hrtimer subsystems responsability) with cyclictest -i 200
on the guest, the timer runs on the local CPU:

       CPU 1/KVM-9454  [003] d..2   881.674196: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d..2   881.674200: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d.h.   881.674387: apic_timer_fn <-__hrtimer_run_queues
       CPU 1/KVM-9454  [003] d..2   881.674393: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d..2   881.674395: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d..2   881.674399: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d.h.   881.674586: apic_timer_fn <-__hrtimer_run_queues
       CPU 1/KVM-9454  [003] d..2   881.674593: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d..2   881.674595: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d..2   881.674599: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d.h.   881.674787: apic_timer_fn <-__hrtimer_run_queues
       CPU 1/KVM-9454  [003] d..2   881.674793: get_nohz_timer_target: get_nohz_timer_target 3->0
       CPU 1/KVM-9454  [003] d..2   881.674795: get_nohz_timer_target: get_nohz_timer_target 3->0

But on boot:

       CPU 1/KVM-9454  [003] d..2   578.625394: get_nohz_timer_target: get_nohz_timer_target 3->0
          <idle>-0     [000] d.h1   578.626390: apic_timer_fn <-__hrtimer_run_queues
          <idle>-0     [000] d.h1   578.626394: apic_timer_fn<-__hrtimer_run_queues
       CPU 1/KVM-9454  [003] d..2   578.626401: get_nohz_timer_target: get_nohz_timer_target 3->0
          <idle>-0     [000] d.h1   578.628397: apic_timer_fn <-__hrtimer_run_queues
       CPU 1/KVM-9454  [003] d..2   578.628407: get_nohz_timer_target: get_nohz_timer_target 3->0
          <idle>-0     [000] d.h1   578.631403: apic_timer_fn <-__hrtimer_run_queues
       CPU 1/KVM-9454  [003] d..2   578.631413: get_nohz_timer_target: get_nohz_timer_target 3->0
          <idle>-0     [000] d.h1   578.635409: apic_timer_fn <-__hrtimer_run_queues
       CPU 1/KVM-9454  [003] d..2   578.635419: get_nohz_timer_target: get_nohz_timer_target 3->0
          <idle>-0     [000] d.h1   578.640415: apic_timer_fn <-__hrtimer_run_queues

Thanks.


