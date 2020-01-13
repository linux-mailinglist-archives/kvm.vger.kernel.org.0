Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3751C138F72
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 11:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgAMKn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 05:43:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49794 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgAMKn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 05:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4Ui4G/63QoKUZjvMxF9EJYkI/mkrELqU9EkyXbiVp7c=; b=oNReL/5fHv4q5CIDS90mS2PoL
        0peoh4gfvE2E6UFhJWpnJdDF3Vt1cz25k7qtz8pUHE8r70A45XrE+w7jNrpZyTmfKWEAzkYJq8LLT
        yzgXw7VvGVN1NUR2VVJgXBCA/EzUgS3Q1sNbfHBevMhzU0kspAsYAPOoTvkY7wWtBq3wpCq7wtAXy
        InyWVplaJrC935gDK0uDpIUcyZhD/VBnEKtMc06L1Mb4MQV4RyJLSgPZxHA9XWs5nP8TQAiiKY4Jo
        s0X1mpV/D/j8uMbwIFx6zwtgEChqtGkvOA5n2+JFV2n99HK+UDN2HfOLjljAxmUc52MXKUwv4CD0p
        S57qSrajg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iqxBm-0008LU-0A; Mon, 13 Jan 2020 10:43:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A50DB304123;
        Mon, 13 Jan 2020 11:41:39 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E4E3C2B66D538; Mon, 13 Jan 2020 11:43:14 +0100 (CET)
Date:   Mon, 13 Jan 2020 11:43:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        christopher.s.hall@intel.com, hubert.chrzaniuk@intel.com,
        len.brown@intel.com, thomas.lendacky@amd.com, rjw@rjwysocki.net
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes
 mwait/hlt
Message-ID: <20200113104314.GU2844@hirez.programming.kicks-ass.net>
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
 <20200108155040.GB2827@hirez.programming.kicks-ass.net>
 <00d884a7-d463-74b4-82cf-9deb0aa70971@redhat.com>
 <CANRm+Cx0LMK1b2mJiU7edCDoRfPfGLzY1Zqr5paBEPcWFFALhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cx0LMK1b2mJiU7edCDoRfPfGLzY1Zqr5paBEPcWFFALhQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Preserved most (+- edits) for the people added to Cc.

On Thu, Jan 09, 2020 at 07:53:51PM +0800, Wanpeng Li wrote:
> On Thu, 9 Jan 2020 at 01:15, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 08/01/20 16:50, Peter Zijlstra wrote:
> > > On Wed, Jan 08, 2020 at 09:50:01AM +0800, Wanpeng Li wrote:
> > >> From: Wanpeng Li <wanpengli@tencent.com>
> > >>
> > >> To deliver all of the resources of a server to instances in cloud, there are no
> > >> housekeeping cpus reserved. libvirtd, qemu main loop, kthreads, and other agent/tools
> > >> etc which can't be offloaded to other hardware like smart nic, these stuff will
> > >> contend with vCPUs even if MWAIT/HLT instructions executed in the guest.
> >
> > ^^ this is the problem statement:
> >
> > He has VCPU threads which are being pinned 1:1 to physical CPUs.  He
> > needs to have various housekeeping threads preempting those vCPU
> > threads, but he'd rather preempt vCPU threads that are doing HLT/MWAIT
> > than those that are keeping the CPU busy.
> >
> > >> The is no trap and yield the pCPU after we expose mwait/hlt to the guest [1][2],
> > >> the top command on host still observe 100% cpu utilization since qemu process is
> > >> running even though guest who has the power management capability executes mwait.
> > >> Actually we can observe the physical cpu has already enter deeper cstate by
> > >> powertop on host.
> > >>
> > >> For virtualization, there is a HLT activity state in CPU VMCS field which indicates
> > >> the logical processor is inactive because it executed the HLT instruction, but
> > >> SDM 24.4.2 mentioned that execution of the MWAIT instruction may put a logical
> > >> processor into an inactive state, however, this VMCS field never reflects this
> > >> state.
> > >
> > > So far I think I can follow, however it does not explain who consumes
> > > this VMCS state if it is set and how that helps. Also, this:
> >
> > I think what Wanpeng was saying is: "KVM could gather this information
> > using the activity state field in the VMCS.  However, when the guest
> > does MWAIT the processor can go into an inactive state without updating
> > the VMCS."  Hence looking at the APERFMPERF ratio.
> >
> > >> This patch avoids fine granularity intercept and reschedule vCPU if MWAIT/HLT
> > >> instructions executed, because it can worse the message-passing workloads which
> > >> will switch between idle and running frequently in the guest. Lets penalty the
> > >> vCPU which is long idle through tick-based sampling and preemption.
> > >
> > > is just complete gibberish. And I have no idea what problem you're
> > > trying to solve how.
> >
> > This is just explaining why MWAIT and HLT is not being trapped in his
> > setup.  (Because vmexit on HLT or MWAIT is awfully expensive).
> >
> > > Also, I don't think the TSC/MPERF ratio is architected, we can't assume
> > > this is true for everything that has APERFMPERF.
> >
> > Right, you have to look at APERF/MPERF, not TSC/MPERF.

> Peterz, do you have nicer solution for this?

So as you might've seen, we're going to go read the APERF/MPERF thingies
in the tick anyway:

  https://lkml.kernel.org/r/20191002122926.385-1-ggherdovich@suse.cz

(your proposed patch even copied some naming off of that, so I'm
assuming you've actually seen that)

So the very first thing we need to get sorted is that MPERF/TSC ratio
thing. TurboStat does it, but has 'funny' hacks on like:

  b2b34dfe4d9a ("tools/power turbostat: KNL workaround for %Busy and Avg_MHz")

and I imagine that there's going to be more exceptions there. You're
basically going to have to get both Intel and AMD to commit to this.

IFF we can get concensus on MPERF/TSC, then yes, that is a reasonable
way to detect a VCPU being idle I suppose. I've added a bunch of people
who seem to know about this.

Anyone, what will it take to get MPERF/TSC 'working' ?
