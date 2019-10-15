Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D399AD8124
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 22:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388082AbfJOUfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 16:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbfJOUfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 16:35:17 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 23A7D8E1CE8;
        Tue, 15 Oct 2019 20:35:17 +0000 (UTC)
Received: from mail (ovpn-124-232.rdu2.redhat.com [10.10.124.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5FA95DA8C;
        Tue, 15 Oct 2019 20:35:16 +0000 (UTC)
Date:   Tue, 15 Oct 2019 16:35:16 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20191015203516.GF331@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
 <20191015164952.GE331@redhat.com>
 <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 15 Oct 2019 20:35:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 15, 2019 at 09:46:58PM +0200, Paolo Bonzini wrote:
> On 15/10/19 18:49, Andrea Arcangeli wrote:
> > On Tue, Oct 15, 2019 at 10:28:39AM +0200, Paolo Bonzini wrote:
> >> If you're including EXIT_REASON_EPT_MISCONFIG (MMIO access) then you
> >> should include EXIT_REASON_IO_INSTRUCTION too.  Depending on the devices
> >> that are in the guest, the doorbell register might be MMIO or PIO.
> > 
> > The fact outb/inb devices exists isn't the question here. The question
> > you should clarify is: which of the PIO devices is performance
> > critical as much as MMIO with virtio/vhost?
> 
> virtio 0.9 uses PIO.

0.9 is a 12 years old protocol replaced several years ago. Anybody who
needs high performance won't be running it, the others can't perform
well to begin with, so I'm not sure exactly how it's relevant in this
microoptimization context. We're not optimizing for emulated devices
or other old stuff either.

> On virtual machines they're actually faster than MMIO because they don't
> need to go through page table walks.

And how does it help that they're faster if current virtio stopped
using them and nothing else recent uses PIO?

> HLT is certainly a slow path, the guest only invokes if things such as

Your idea that HLT is a certainly is a slow path is only correct if
you assume the host is IDLE, but the host is never idle if you use
virt for consolidation.

From the point of view of the host, HLT is like every other vmexit.

> NAPI interrupt mitigation have failed.  As long as the guest stays in
> halted state for a microsecond or so, the cost of retpoline will all but
> disappear.

The only thing that matters is the number of HLT vmexit per second and
you just need to measure the number of HLT vmexits to tell it's
needed.

I've several workloads including eBPF tracing, not related to
interrupts (that in turn cannot be mitigated by NAPI) that schedule
frequently and hit 100k+ of HLT vmexits per second and the host is all
but idle. There's no need of hardware interrupt to wake up tasks and
schedule in the guest, scheduler IPIs and timers are more than enough.

The only thing that can mitigate that is the cpuidle haltpoll driver,
but it hit upstream a few months ago, all most recent enterprise
guest OS won't have it yet.

All it matters is how many vmexits per second there are, everything
else including "why" they happen and what those vmexists means for the
guest, is irrelevant, or it would be relevant only if the host was
guaranteed to be idle but there's no such guarantee.

If the host is using all idle CPUs to compute in the background
(i.e. building the kernel) with SCHED_IDLE the HLT retpoline cost will
not be any different than any other vmexit retpoline cost and easy
+100k HLT exit per second certainly puts it in the measurable
territory.

Here's a random example:

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time 

                 HLT     101128    75.33%    99.66%      0.43us 901000.66us    310.88us ( +-   8.46% )
              VMCALL      14089    10.50%     0.10%      1.32us     84.99us      2.14us ( +-   0.90% )
           MSR_WRITE       8246     6.14%     0.03%      0.33us     32.79us      1.05us ( +-   1.51% )
       EPT_VIOLATION       6312     4.70%     0.18%      0.50us  26426.07us      8.90us ( +-  48.58% )
    PREEMPTION_TIMER       1730     1.29%     0.01%      0.55us     26.81us      1.60us ( +-   3.48% )
  EXTERNAL_INTERRUPT       1329     0.99%     0.03%      0.27us    944.88us      6.04us ( +-  20.52% )
       EPT_MISCONFIG        982     0.73%     0.01%      0.42us    137.68us      2.05us ( +-   9.88% )
   PENDING_INTERRUPT        308     0.23%     0.00%      0.44us      4.32us      0.73us ( +-   2.57% )
   PAUSE_INSTRUCTION         58     0.04%     0.00%      0.32us     18.55us      1.48us ( +-  23.12% )
            MSR_READ         35     0.03%     0.00%      0.78us      5.55us      2.07us ( +-  10.74% )
               CPUID         24     0.02%     0.00%      0.27us      2.20us      0.59us ( +-  13.43% )

# careful despite the verifier promise that eBPF shouldn't be kernel
# crashing this may be kernel crashing because there's no verifier at
# all that verifies that the eBPF function calls available depending
# on the hooking point can actually be invoked from the kernel hooking
# points they're invoked from. this is why I tested it in a VM
bpftrace -e 'kprobe:*interrupt* { @ = count() }'

Other example with a pipe loop that just bounces a byte across a pipe
with two processes:

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time 

           MSR_WRITE     498945    80.49%     4.10%      0.33us     42.73us      0.44us ( +-   0.12% )
                 HLT     118474    19.11%    95.88%      0.33us 707693.05us     43.56us ( +-  24.23% )
    PREEMPTION_TIMER       1004     0.16%     0.01%      0.38us     25.47us      0.67us ( +-   5.69% )
   PENDING_INTERRUPT        894     0.14%     0.01%      0.37us     20.98us      0.49us ( +-   4.94% )
  EXTERNAL_INTERRUPT        518     0.08%     0.00%      0.26us     20.59us      0.51us ( +-   8.09% )
            MSR_READ          8     0.00%     0.00%      0.66us      1.37us      0.92us ( +-   9.19% )
       EPT_MISCONFIG          6     0.00%     0.00%      3.18us     32.71us     12.60us ( +-  43.58% )
   PAUSE_INSTRUCTION          3     0.00%     0.00%      0.59us      1.69us      1.07us ( +-  30.38% )

We wouldn't need to apply the cpuidle-haltpoll driver if HLT wasn't
such a frequent vmexit that deserves to have its retpoline cost, not
multiplied by 100000 times per second.

Over time if everything will turn out to use the cpuidle-haltpoll
driver by default (that however can increase the host CPU usage on
laptops) we can consider removing the HLT optimization, we're not
remotely there yet.

> RDMSR again shouldn't be there, guests sometimes read the PMTimer (which
> is an I/O port) or TSC but for example do not really ever read the APIC
> TMCCT.

We can try to drop RDMSR, and see if it's measurable. I already tried
to re-add some of those retpolines but it was slower and this was the
fastest combination that I got, I don't recall if I tried with RDMSR
and PAUSE alone but I can try again.

> > I'm pretty sure HLT/EXTERNAL_INTERRUPT/PENDING_INTERRUPT should be
> > included.
> > I also wonder if VMCALL should be added, certain loads hit on fairly
> > frequent VMCALL, but none of the one I benchmarked.
> 
> I agree for external interrupt and pending interrupt, and VMCALL is fine
> too.  In addition I'd add I/O instructions which are useful for some
> guests and also for benchmarking (e.g. vmexit.flat has both IN and OUT
> tests).

Isn't it faster to use cpuid for benchmarking? I mean we don't want to
pay for more than one branch for benchmarking (even cpuid is
questionable in the long term, but for now it's handy to have), and
unlike inb/outb, cpuid runs occasionally in all real life workloads
(including in guest userland) so between inb/outb, I'd rather prefer
to use cpuid as the benchmark vector because at least it has a chance
to help real workloads a bit too.

Thanks,
Andrea
