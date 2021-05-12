Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73AF37BBDB
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhELLfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:35:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:42744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhELLfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:35:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3F84DAF1F;
        Wed, 12 May 2021 11:34:23 +0000 (UTC)
Date:   Wed, 12 May 2021 12:34:19 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Balbir Singh <bsingharora@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, tglx@linutronix.de,
        mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        pbonzini@redhat.com, maz@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        Paul Wise <pabs3@bonedaddy.net>
Subject: Re: [PATCH 0/6] sched,delayacct: Some cleanups
Message-ID: <20210512113419.GF3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <20210505222940.GA4236@balbir-desktop>
 <YJOzUAg30LZWSHcI@hirez.programming.kicks-ass.net>
 <20210507123810.GB4236@balbir-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210507123810.GB4236@balbir-desktop>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 10:38:10PM +1000, Balbir Singh wrote:
> On Thu, May 06, 2021 at 11:13:52AM +0200, Peter Zijlstra wrote:
> > On Thu, May 06, 2021 at 08:29:40AM +1000, Balbir Singh wrote:
> > > On Wed, May 05, 2021 at 12:59:40PM +0200, Peter Zijlstra wrote:
> > > > Hi,
> > > > 
> > > > Due to:
> > > > 
> > > >   https://lkml.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
> > > > 
> > > > and general principle, delayacct really shouldn't be using ktime (pvclock also
> > > > really shouldn't be doing what it does, but that's another story). This lead me
> > > > to looking at the SCHED_INFO, SCHEDSTATS, DELAYACCT (and PSI) accounting hell.
> > > > 
> > > > The rest of the patches are an attempt at simplifying all that a little. All
> > > > that crud is enabled by default for distros which is leading to a death by a
> > > > thousand cuts.
> > > > 
> > > > The last patch is an attempt at default disabling DELAYACCT, because I don't
> > > > think anybody actually uses that much, but what do I know, there were no ill
> > > > effects on my testbox. Perhaps we should mirror
> > > > /proc/sys/kernel/sched_schedstats and provide a delayacct sysctl for runtime
> > > > frobbing.
> > > >
> > > 
> > > There are tools like iotop that use delayacct to display information. 
> > 
> > Right, but how many actual people use that? Does that justify saddling
> > the whole sodding world with the overhead?
> >
> 
> Not sure I have that data.
>  

It's used occasionally as a debugging tool when looking at IO problems
in general. Like sched_schedstats, it seems unnecesary to incur overhead
unless someone is debugging.

Minimally disabling had a small positive impact -- tbench 0-8% gain
depending on thread count and machine, positive impact in general to
specjbb2005, neutral on hackbench and most of the other workloads checked.

> > > When the
> > > code was checked in, we did run SPEC* back in the day 2006 to find overheads,
> > > nothing significant showed. Do we have any date on the overhead your seeing?
> > 
> > I've not looked, but having it disabled saves that per-task allocation
> > and that spinlock in delayacct_end() for iowait wakeups and a bunch of
> > cache misses ofcourse.
> > 
> > I doubt SPEC is a benchmark that tickles those paths much if at all.
> > 
> > The thing is; we can't just keep growing more and more stats, that'll
> > kill us quite dead.
> 
> 
> I don't disagree, we've had these around for a while and I know of users
> that use these stats to find potential starvation. I am OK with default
> disabled. I suspect distros will have the final say.
> 

I think default disabled should be fine. At worst when dealing with a bug
there would be a need to either reboot or enable at runtime with patch
7 included and add that instruction to the bug report when requesting
iotop data. At worst, a distro could revert the patch if iotop generated
too many bug reports or patch iotop in the distro package.

Alternatively, I've added Paul Wise to the cc who is the latest
committer to iotop.  Maybe he knows who could add/commit a check for
sysctl.sched_delayacct and if it exists then check if it's 1 and display
an error suggesting corrective action (add delayacct to the kernel command
line or sysctl sched.sched_delayacct=1). iotop appears to be in maintenance
mode but gets occasional commits even if it has not had a new version
since 2013 so maybe it could get a 0.7 tag if such a check was added.

-- 
Mel Gorman
SUSE Labs
