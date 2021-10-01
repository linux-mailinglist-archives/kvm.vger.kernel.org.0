Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3353341ED20
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 14:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354322AbhJAMNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 08:13:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237143AbhJAMNg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 1 Oct 2021 08:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633090312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1WMoHDuRMv8a05PMxxecz9ri+FED1EzVSseeb3CdzN8=;
        b=CMIVTzH2PejuIdbUla4sFhNDkNG8FdzHrRF/aACqBdc+kvxbwVgttKVK9HeC47+Be6JAFe
        fc1KLdwW2q+0K7HJDzrQXMk8ysxLEid4NY3TmEMggntoTc7B0dJEimqSdVWb2WGFT9WBrB
        NBhUNmbPli6jTzYMt9t0NffPJAqirw0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-5p5UB6B6NGWPnU9lOVTNuA-1; Fri, 01 Oct 2021 08:11:51 -0400
X-MC-Unique: 5p5UB6B6NGWPnU9lOVTNuA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27D6519253C4;
        Fri,  1 Oct 2021 12:11:49 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7882160BF1;
        Fri,  1 Oct 2021 12:11:48 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 400A3416CE5D; Fri,  1 Oct 2021 09:10:41 -0300 (-03)
Date:   Fri, 1 Oct 2021 09:10:41 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Message-ID: <20211001121041.GA45897@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
 <20210929185629.GA10933@fuller.cnet>
 <20210930192107.GB19068@fuller.cnet>
 <871r557jls.ffs@tglx>
 <20211001120527.GA43086@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001120527.GA43086@fuller.cnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 09:05:27AM -0300, Marcelo Tosatti wrote:
> On Fri, Oct 01, 2021 at 01:02:23AM +0200, Thomas Gleixner wrote:
> > Marcelo,
> > 
> > On Thu, Sep 30 2021 at 16:21, Marcelo Tosatti wrote:
> > > On Wed, Sep 29, 2021 at 03:56:29PM -0300, Marcelo Tosatti wrote:
> > >> On Thu, Sep 16, 2021 at 06:15:35PM +0000, Oliver Upton wrote:
> > >> 
> > >> Thomas, CC'ed, has deeper understanding of problems with 
> > >> forward time jumps than I do. Thomas, any comments?
> > >
> > > Based on the earlier discussion about the problems of synchronizing
> > > the guests clock via a notification to the NTP/Chrony daemon 
> > > (where there is a window where applications can read the stale
> > > value of the clock), a possible solution would be triggering
> > > an NMI on the destination (so that it runs ASAP, with higher
> > > priority than application/kernel).
> > >
> > > What would this NMI do, exactly?
> > 
> > Nothing. You cannot do anything time related in an NMI.
> > 
> > You might queue irq work which handles that, but that would still not
> > prevent user space or kernel space from observing the stale time stamp
> > depending on the execution state from where it resumes.
> 
> Yes.
> 
> > >> As a note: this makes it not OK to use KVM_CLOCK_REALTIME flag 
> > >> for either vm pause / vm resume (well, if paused for long periods of time) 
> > >> or savevm / restorevm.
> > >
> > > Maybe with the NMI above, it would be possible to use
> > > the realtime clock as a way to know time elapsed between
> > > events and advance guest clock without the current 
> > > problematic window.
> > 
> > As much duct tape you throw at the problem, it cannot be solved ever
> > because it's fundamentally broken. All you can do is to make the
> > observation windows smaller, but that's just curing the symptom.
> 
> Yes.
> 
> > The problem is that the guest is paused/resumed without getting any
> > information about that and the execution of the guest is stopped at an
> > arbitrary instruction boundary from which it resumes after migration or
> > restore. So there is no way to guarantee that after resume all vCPUs are
> > executing in a state which can handle that.
> > 
> > But even if that would be the case, then what prevents the stale time
> > stamps to be visible? Nothing:
> > 
> > T0:    t = now();
> >          -> pause
> >          -> resume
> >          -> magic "fixup"
> > T1:    dostuff(t);
> 
> Yes.
> 
> BTW, you could have a userspace notification (then applications 
> could handle this if desired).
> 
> > But that's not a fundamental problem because every preemptible or
> > interruptible code has the same issue:
> > 
> > T0:    t = now();
> >          -> preemption or interrupt
> > T1:    dostuff(t);
> > 
> > Which is usually not a problem, but It becomes a problem when T1 - T0 is
> > greater than the usual expectations which can obviously be trivially
> > achieved by guest migration or a savevm, restorevm cycle.
> > 
> > But let's go a step back and look at the clocks and their expectations:
> > 
> > CLOCK_MONOTONIC:
> > 
> >   Monotonically increasing clock which counts unless the system
> >   is in suspend. On resume it continues counting without jumping
> >   forward.
> > 
> >   That's the reference clock for everything else and therefore it
> >   is important that it does _not_ jump around.
> > 
> >   The reasons why CLOCK_MONOTONIC stops during suspend is
> >   historical and any attempt to change that breaks the world and
> >   some more because making it jump forward will trigger all sorts
> >   of timeouts, watchdogs and whatever. The last attempt to make
> >   CLOCK_MONOTONIC behave like CLOCK_BOOTTIME was reverted within 3
> >   weeks. It's not going to be attempted again. See a3ed0e4393d6
> >   ("Revert: Unify CLOCK_MONOTONIC and CLOCK_BOOTTIME") for
> >   details.
> > 
> >   Now the proposed change is creating exactly the same problem:
> > 
> >   >> > +	if (data.flags & KVM_CLOCK_REALTIME) {
> >   >> > +		u64 now_real_ns = ktime_get_real_ns();
> >   >> > +
> >   >> > +		/*
> >   >> > +		 * Avoid stepping the kvmclock backwards.
> >   >> > +		 */
> >   >> > +		if (now_real_ns > data.realtime)
> >   >> > +			data.clock += now_real_ns - data.realtime;
> >   >> > +	}
> > 
> >   IOW, it takes the time between pause and resume into account and
> >   forwards the underlying base clock which makes CLOCK_MONOTONIC
> >   jump forward by exactly that amount of time.
> 
> Well, it is assuming that the
> 
>  T0:    t = now();
>  T1:    pause vm()
>  T2:	finish vm migration()
>  T3:    dostuff(t);
> 
> Interval between T1 and T2 is small (and that the guest
> clocks are synchronized up to a given boundary).
> 
> But i suppose adding a limit to the forward clock advance 
> (in the migration case) is useful:
> 
> 	1) If migration (well actually, only the final steps
> 	   to finish migration, the time between when guest is paused
> 	   on source and is resumed on destination) takes too long,
> 	   then too bad: fix it to be shorter if you want the clocks
> 	   to have close to zero change to realtime on migration.
> 
> 	2) Avoid the other bugs in case of large forward advance.
> 
> Maybe having it configurable, with a say, 1 minute maximum by default
> is a good choice?
> 
> An alternative would be to advance only the guests REALTIME clock, from 
> data about how long steps T1-T2 took.
> 
> >   So depending on the size of the delta you are running into exactly the
> >   same problem as the final failed attempt to unify CLOCK_MONOTONIC and
> >   CLOCK_BOOTTIME which btw. would have been a magic cure for virt.
> > 
> >   Too bad, not going to happen ever unless you fix all affected user
> >   space and kernel side issues.
> > 
> > 
> > CLOCK_BOOTTIME:
> > 
> >   CLOCK_MONOTONIC + time spent in suspend
> > 
> > 
> > CLOCK_REALTIME/TAI:
> > 
> >   CLOCK_MONOTONIC + offset
> > 
> >   The offset is established by reading RTC at boot time and can be
> >   changed by clock_settime(2) and adjtimex(2). The latter is used
> >   by NTP/PTP.
> > 
> >   Any user of CLOCK_REALTIME has to be prepared for it to jump in
> >   both directions, but of course NTP/PTP daemons have expectations
> >   vs. such time jumps.
> > 
> >   They rightfully assume on a properly configured and administrated
> >   system that there are only two things which can make CLOCK_REALTIME
> >   jump:
> > 
> >   1) NTP/PTP daemon controlled
> >   2) Suspend/resume related updates by the kernel
> > 
> > 
> > Just for the record, these assumptions predate virtualization.
> > 
> > So now virt came along and created a hard to solve circular dependency
> > problem:
> > 
> >    - If CLOCK_MONOTONIC stops for too long then NTP/PTP gets out of
> >      sync, but everything else is happy.
> >      
> >    - If CLOCK_MONOTONIC jumps too far forward, then all hell breaks
> >      lose, but NTP/PTP is happy.
> 
> One must handle the
> 
>  T0:    t = now();
>           -> pause
>           -> resume
>           -> magic "fixup"
>  T1:    dostuff(t);
> 
> fact if one is going to use savevm/restorevm anyway, so...
> (it is kind of unfixable, unless you modify your application
> to accept notifications to redo any computation based on t, isnt it?).

https://lore.kernel.org/lkml/1289503802-22444-2-git-send-email-virtuoso@slind.org/

