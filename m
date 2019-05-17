Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B4F21CD6
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 19:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfEQRuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 13:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15715 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfEQRuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 13:50:24 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD32030ADC7C;
        Fri, 17 May 2019 17:50:23 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F3DC60BE0;
        Fri, 17 May 2019 17:50:21 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id EDB9F105192;
        Fri, 17 May 2019 14:50:00 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x4HHnuRY011263;
        Fri, 17 May 2019 14:49:56 -0300
Date:   Fri, 17 May 2019 14:49:56 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
Message-ID: <20190517174955.GA10659@amt.cnet>
References: <20190507185647.GA29409@amt.cnet>
 <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet>
 <7e390fef-e0df-963f-4e18-e44ac2766be3@oracle.com>
 <20190515204356.GB31128@amt.cnet>
 <ee5656d7-3745-28c6-2021-adda0ed67240@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee5656d7-3745-28c6-2021-adda0ed67240@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 17 May 2019 17:50:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 16, 2019 at 09:32:06PM -0700, Ankur Arora wrote:
> On 2019-05-15 1:43 p.m., Marcelo Tosatti wrote:
> >On Wed, May 15, 2019 at 11:42:56AM -0700, Ankur Arora wrote:
> >>On 5/14/19 6:50 AM, Marcelo Tosatti wrote:
> >>>On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
> >>>>On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >>>>>
> >>>>>
> >>>>>Certain workloads perform poorly on KVM compared to baremetal
> >>>>>due to baremetal's ability to perform mwait on NEED_RESCHED
> >>>>>bit of task flags (therefore skipping the IPI).
> >>>>
> >>>>KVM supports expose mwait to the guest, if it can solve this?
> >>>>
> >>>>Regards,
> >>>>Wanpeng Li
> >>>
> >>>Unfortunately mwait in guest is not feasible (uncompatible with multiple
> >>>guests). Checking whether a paravirt solution is possible.
> >
> >Hi Ankur,
> >
> >>
> >>Hi Marcelo,
> >>
> >>I was also looking at making MWAIT available to guests in a safe manner:
> >>whether through emulation or a PV-MWAIT. My (unsolicited) thoughts
> >
> >What use-case are you interested in?
> Currently Oracle does not make MWAIT available to guests in cloud
> environments. My interest is 1) allow guests to avoid the IPI and
> 2) allow the waiting to be in deeper C-states so that other cores
> could get the benefit of turbo-boost etc.
> 
> 
> >
> >>
> >>We basically want to handle this sequence:
> >>
> >>     monitor(monitor_address);
> >>     if (*monitor_address == base_value)
> >>          mwaitx(max_delay);
> >>
> >>Emulation seems problematic because, AFAICS this would happen:
> >>
> >>     guest                                   hypervisor
> >>     =====                                   ====
> >>
> >>     monitor(monitor_address);
> >>         vmexit  ===>                        monitor(monitor_address)
> >>     if (*monitor_address == base_value)
> >>          mwait();
> >>               vmexit    ====>               mwait()
> >>
> >>There's a context switch back to the guest in this sequence which seems
> >>problematic. Both the AMD and Intel specs list system calls and
> >>far calls as events which would lead to the MWAIT being woken up:
> >>"Voluntary transitions due to fast system call and far calls
> >>(occurring prior to issuing MWAIT but after setting the monitor)".
> >>
> >>
> >>We could do this instead:
> >>
> >>     guest                                   hypervisor
> >>     =====                                   ====
> >>
> >>     monitor(monitor_address);
> >>         vmexit  ===>                        cache monitor_address
> >>     if (*monitor_address == base_value)
> >>          mwait();
> >>               vmexit    ====>              monitor(monitor_address)
> >>                                            mwait()
> >>
> >>But, this would miss the "if (*monitor_address == base_value)" check in
> >>the host which is problematic if *monitor_address changed simultaneously
> >>when monitor was executed.
> >>(Similar problem if we cache both the monitor_address and
> >>*monitor_address.)
> >>
> >>
> >>So, AFAICS, the only thing that would work is the guest offloading the
> >>whole PV-MWAIT operation.
> >>
> >>AFAICS, that could be a paravirt operation which needs three parameters:
> >>(monitor_address, base_value, max_delay.)
> >>
> >>This would allow the guest to offload this whole operation to
> >>the host:
> >>     monitor(monitor_address);
> >>     if (*monitor_address == base_value)
> >>          mwaitx(max_delay);
> >>
> >>I'm guessing you are thinking on similar lines?
> >
> >Sort of: only trying to avoid the IPI to wake a remote vCPU.
> >
> >Problem is that MWAIT works only on a contiguous range
> >of bits in memory (512 bits max on current CPUs).
> >
> >So if you execute mwait on the host on behalf of the guest,
> >the region of memory monitored must include both host
> >and guest bits.
> Yeah, an MWAITv would have come pretty handy here ;).
> 
> My idea of PV-MWAIT didn't include waiting on behalf of the host. I
> was thinking of waiting in the host but exclusively on behalf of the
> guest, until the guest is woken up or when it's time-quanta expires.
> 
> Waiting on behalf of both the guest and the host would clearly be better.
> 
> If we can do mwait for both the guest and host (say they share a 512
> bit region), then the host will need some protection from the guest.
> Maybe the waking guest-thread could just do a hypercall to wake up
> the remote vCPU? Or maybe it could poke the monitored region,
> but that is handled as a special page-fault?
>
> The hypercall-to-wake would also allow us to move guest-threads across
> CPUs. That said, I'm not sure how expensive either of these would be.
> 
> Assuming host/guest can share a monitored region safely, the host's
> idle could monitor some region other than its &thread_info->flags.
> Maybe we could setup a mwait notifier with a percpu waiting area which
> could be registered by idle, guests etc.
> 
> Though on second thoughts, if the remote thread will do a
> hypercall/page-fault then the handling could just as easily be: mark
> the guest's remote thread runnable and set the resched bit.

Yes, arrived at the same conclusion...

However, it seems avoiding the exit in the first via busy spinning
provides the largest performance benefit (avoiding the exit 
on the sender side and receiver sides).

See cpuidle driver just posted. 

mwait instruction that worked on multiple addresses would be ideal
for virtualization.

> >>High level semantics: If the CPU doesn't have any runnable threads, then
> >>we actually do this version of PV-MWAIT -- arming a timer if necessary
> >>so we only sleep until the time-slice expires or the MWAIT max_delay does.
> >
> >That would kill the sched_wake_idle_without_ipi optimization for the
> >host.
> Yeah, I was thinking in terms of the MWAIT being exclusively on behalf
> of the guest so in a sense the guest was still scheduled just waiting.
> 
> Ankur
> 
> >
> >>If the CPU has any runnable threads then this could still finish its
> >>time-quanta or we could just do a schedule-out.
> >>
> >>
> >>So the semantics guaranteed to the host would be that PV-MWAIT
> >>returns after >= max_delay OR with the *monitor_address changed.
> >>
> >>
> >>
> >>Ankur
