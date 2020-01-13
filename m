Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 039E2138FEC
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 12:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgAMLSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 06:18:49 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:52459 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAMLSt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 06:18:49 -0500
Received: from 79.184.255.90.ipv4.supernova.orange.pl (79.184.255.90) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.320)
 id 57d6b0aacc5f9bdf; Mon, 13 Jan 2020 12:18:46 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        christopher.s.hall@intel.com, hubert.chrzaniuk@intel.com,
        len.brown@intel.com, thomas.lendacky@amd.com
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes mwait/hlt
Date:   Mon, 13 Jan 2020 12:18:46 +0100
Message-ID: <2579281.NS3xOKR7ft@kreacher>
In-Reply-To: <20200113104314.GU2844@hirez.programming.kicks-ass.net>
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com> <CANRm+Cx0LMK1b2mJiU7edCDoRfPfGLzY1Zqr5paBEPcWFFALhQ@mail.gmail.com> <20200113104314.GU2844@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, January 13, 2020 11:43:14 AM CET Peter Zijlstra wrote:
> 
> Preserved most (+- edits) for the people added to Cc.
> 
> On Thu, Jan 09, 2020 at 07:53:51PM +0800, Wanpeng Li wrote:
> > On Thu, 9 Jan 2020 at 01:15, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > On 08/01/20 16:50, Peter Zijlstra wrote:
> > > > On Wed, Jan 08, 2020 at 09:50:01AM +0800, Wanpeng Li wrote:
> > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > >>
> > > >> To deliver all of the resources of a server to instances in cloud, there are no
> > > >> housekeeping cpus reserved. libvirtd, qemu main loop, kthreads, and other agent/tools
> > > >> etc which can't be offloaded to other hardware like smart nic, these stuff will
> > > >> contend with vCPUs even if MWAIT/HLT instructions executed in the guest.
> > >
> > > ^^ this is the problem statement:
> > >
> > > He has VCPU threads which are being pinned 1:1 to physical CPUs.  He
> > > needs to have various housekeeping threads preempting those vCPU
> > > threads, but he'd rather preempt vCPU threads that are doing HLT/MWAIT
> > > than those that are keeping the CPU busy.
> > >
> > > >> The is no trap and yield the pCPU after we expose mwait/hlt to the guest [1][2],
> > > >> the top command on host still observe 100% cpu utilization since qemu process is
> > > >> running even though guest who has the power management capability executes mwait.
> > > >> Actually we can observe the physical cpu has already enter deeper cstate by
> > > >> powertop on host.
> > > >>
> > > >> For virtualization, there is a HLT activity state in CPU VMCS field which indicates
> > > >> the logical processor is inactive because it executed the HLT instruction, but
> > > >> SDM 24.4.2 mentioned that execution of the MWAIT instruction may put a logical
> > > >> processor into an inactive state, however, this VMCS field never reflects this
> > > >> state.
> > > >
> > > > So far I think I can follow, however it does not explain who consumes
> > > > this VMCS state if it is set and how that helps. Also, this:
> > >
> > > I think what Wanpeng was saying is: "KVM could gather this information
> > > using the activity state field in the VMCS.  However, when the guest
> > > does MWAIT the processor can go into an inactive state without updating
> > > the VMCS."  Hence looking at the APERFMPERF ratio.
> > >
> > > >> This patch avoids fine granularity intercept and reschedule vCPU if MWAIT/HLT
> > > >> instructions executed, because it can worse the message-passing workloads which
> > > >> will switch between idle and running frequently in the guest. Lets penalty the
> > > >> vCPU which is long idle through tick-based sampling and preemption.
> > > >
> > > > is just complete gibberish. And I have no idea what problem you're
> > > > trying to solve how.
> > >
> > > This is just explaining why MWAIT and HLT is not being trapped in his
> > > setup.  (Because vmexit on HLT or MWAIT is awfully expensive).
> > >
> > > > Also, I don't think the TSC/MPERF ratio is architected, we can't assume
> > > > this is true for everything that has APERFMPERF.
> > >
> > > Right, you have to look at APERF/MPERF, not TSC/MPERF.
> 
> > Peterz, do you have nicer solution for this?
> 
> So as you might've seen, we're going to go read the APERF/MPERF thingies
> in the tick anyway:
> 
>   https://lkml.kernel.org/r/20191002122926.385-1-ggherdovich@suse.cz
> 
> (your proposed patch even copied some naming off of that, so I'm
> assuming you've actually seen that)
> 
> So the very first thing we need to get sorted is that MPERF/TSC ratio
> thing. TurboStat does it, but has 'funny' hacks on like:
> 
>   b2b34dfe4d9a ("tools/power turbostat: KNL workaround for %Busy and Avg_MHz")
> 
> and I imagine that there's going to be more exceptions there. You're
> basically going to have to get both Intel and AMD to commit to this.
> 
> IFF we can get concensus on MPERF/TSC, then yes, that is a reasonable
> way to detect a VCPU being idle I suppose. I've added a bunch of people
> who seem to know about this.
> 
> Anyone, what will it take to get MPERF/TSC 'working' ?

The same thing that intel_pstate does.

Generally speaking, it shifts the mperf values by a number of positions
depending on the CPU model, but that is 1 except for KNL.

See get_target_pstate().



