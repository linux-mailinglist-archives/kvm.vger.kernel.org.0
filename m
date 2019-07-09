Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF2633A0
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 11:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGIJnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 05:43:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36962 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfGIJnY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 05:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YvNdAX19+AlHDeuKAGCP65zmxXubPuWrKB2jZ5bNMIM=; b=GEpzdHRzEtOanWUg28nD/5dbI
        ozMVjRbOv332eCPS6W4HEPH0kQQg2G5Jr1El4puKBeIPhSy3o3J9TtuGb9q9NYZWelH+CzC+33vNA
        57gvyTNQeqbX1OvHo43H9AM3uczhqaDFMDOtWBJYeOtVwrscP79TRTcHZYWc7lpmxjuWGwV4P100p
        NXmNTEvIG4odLZbT8XTrxVEpxdCoEJNAPBlZ/mCfDmM3Aupo849wh6U4WiGIO7DbkXKLb7EGPr9Yq
        ukXJTb8Ztk1yXEsxGbj9fCfl8s205T/Rr/JURabd++/P+N+K05Y/a7CDNjRGaiLth4tVi3MiB6i5l
        QhcfYQGjA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkmeR-0005xB-Rt; Tue, 09 Jul 2019 09:43:08 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7A5C820120CB1; Tue,  9 Jul 2019 11:43:05 +0200 (CEST)
Date:   Tue, 9 Jul 2019 11:43:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 07/12] perf/x86: no counter allocation support
Message-ID: <20190709094305.GT3402@hirez.programming.kicks-ass.net>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-8-git-send-email-wei.w.wang@intel.com>
 <20190708142947.GM3402@hirez.programming.kicks-ass.net>
 <5D2402E6.7060104@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D2402E6.7060104@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 09, 2019 at 10:58:46AM +0800, Wei Wang wrote:
> On 07/08/2019 10:29 PM, Peter Zijlstra wrote:
> 
> Thanks for the comments.
> 
> > 
> > > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > > index 0ab99c7..19e6593 100644
> > > --- a/include/linux/perf_event.h
> > > +++ b/include/linux/perf_event.h
> > > @@ -528,6 +528,7 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *,
> > >    */
> > >   #define PERF_EV_CAP_SOFTWARE		BIT(0)
> > >   #define PERF_EV_CAP_READ_ACTIVE_PKG	BIT(1)
> > > +#define PERF_EV_CAP_NO_COUNTER		BIT(2)
> > >   #define SWEVENT_HLIST_BITS		8
> > >   #define SWEVENT_HLIST_SIZE		(1 << SWEVENT_HLIST_BITS)
> > > @@ -895,6 +896,13 @@ extern int perf_event_refresh(struct perf_event *event, int refresh);
> > >   extern void perf_event_update_userpage(struct perf_event *event);
> > >   extern int perf_event_release_kernel(struct perf_event *event);
> > >   extern struct perf_event *
> > > +perf_event_create(struct perf_event_attr *attr,
> > > +		  int cpu,
> > > +		  struct task_struct *task,
> > > +		  perf_overflow_handler_t overflow_handler,
> > > +		  void *context,
> > > +		  bool counter_assignment);
> > > +extern struct perf_event *
> > >   perf_event_create_kernel_counter(struct perf_event_attr *attr,
> > >   				int cpu,
> > >   				struct task_struct *task,
> > Why the heck are you creating this wrapper nonsense?
> 
> (please see early discussions: https://lkml.org/lkml/2018/9/20/868)
> I thought we agreed that the perf event created here don't need to consume
> an extra counter.

That's almost a year ago; I really can't remember that and you didn't
put any of that in your Changelog to help me remember.

(also please use: https://lkml.kernel.org/r/$msgid style links)

> In the previous version, we added a "no_counter" bit to perf_event_attr, and
> that will be exposed to user ABI, which seems not good.
> (https://lkml.org/lkml/2019/2/14/791)
> So we wrap a new kernel API above to support this.
> 
> Do you have a different suggestion to do this?
> (exclude host/guest just clears the enable bit when on VM-exit/entry,
> still consumes the counter)

Just add an argument to perf_event_create_kernel_counter() ?
