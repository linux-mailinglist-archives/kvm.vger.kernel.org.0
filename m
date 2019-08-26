Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502A99D78C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 22:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbfHZUmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 16:42:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfHZUmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 16:42:46 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4532D281D1;
        Mon, 26 Aug 2019 20:42:45 +0000 (UTC)
Received: from amt.cnet (ovpn-112-6.gru2.redhat.com [10.97.112.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 962026092D;
        Mon, 26 Aug 2019 20:42:44 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id DF559105115;
        Mon, 26 Aug 2019 17:40:57 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x7QKeped025832;
        Mon, 26 Aug 2019 17:40:51 -0300
Date:   Mon, 26 Aug 2019 17:40:50 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when
 dedicated physical CPUs are available
Message-ID: <20190826204045.GA24697@amt.cnet>
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com>
 <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
 <20190803202058.GA9316@amt.cnet>
 <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANRm+CwtHBOVWFcn+6Z3Ds7dEcNL2JP+b6hLRS=oeUW98A24MQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Mon, 26 Aug 2019 20:42:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 08:55:29AM +0800, Wanpeng Li wrote:
> On Sun, 4 Aug 2019 at 04:21, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> > > On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > > > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> > > >> From: Wanpeng Li <wanpengli@tencent.com>
> > > >>
> > > >> The downside of guest side polling is that polling is performed even
> > > >> with other runnable tasks in the host. However, even if poll in kvm
> > > >> can aware whether or not other runnable tasks in the same pCPU, it
> > > >> can still incur extra overhead in over-subscribe scenario. Now we can
> > > >> just enable guest polling when dedicated pCPUs are available.
> > > >>
> > > >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > >> Cc: Radim Krčmář <rkrcmar@redhat.com>
> > > >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > >
> > > > Paolo, Marcelo, any comments?
> > >
> > > Yes, it's a good idea.
> > >
> > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > >
> > > Paolo
> >
> 
> Hi Marcelo,
> 
> Sorry for the late response.
> 
> > I think KVM_HINTS_REALTIME is being abused somewhat.
> > It has no clear meaning and used in different locations
> > for different purposes.
> 
> ================== ============ =================================
> KVM_HINTS_REALTIME 0                      guest checks this feature bit to
> 
> determine that vCPUs are never
> 
> preempted for an unlimited time

Unlimited time means infinite time, or unlimited time means 
10s ? 1s ?

The previous definition was much better IMO: HINTS_DEDICATED.


> allowing optimizations
> ================== ============ =================================
> 
> Now it disables pv queued spinlock, 

OK. 

> pv tlb shootdown, 

OK.

> pv sched yield

"The idea is from Xen, when sending a call-function IPI-many to vCPUs,
yield if any of the IPI target vCPUs was preempted. 17% performance
increasement of ebizzy benchmark can be observed in an over-subscribe
environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function
IPI-many since call-function is not easy to be trigged by userspace
workload)."

This can probably hurt if vcpus are rarely preempted. 

> which are not expected present in vCPUs are never preempted for an
> unlimited time scenario.
> 
> >
> > For example, i think that using pv queued spinlocks and
> > haltpoll is a desired scenario, which the patch below disallows.
> 
> So even if dedicated pCPU is available, pv queued spinlocks should
> still be chose if something like vhost-kthreads are used instead of
> DPDK/vhost-user. 

Can't you enable the individual features you need for optimizing 
the overcommitted case? This is how things have been done historically:
If a new feature is available, you enable it to get the desired
performance. x2apic, invariant-tsc, cpuidle haltpoll...

So in your case: enable pv schedyield, enable pv tlb shootdown.

> kvm adaptive halt-polling will compete with
> vhost-kthreads, however, poll in guest unaware other runnable tasks in
> the host which will defeat vhost-kthreads.

It depends on how much work vhost-kthreads needs to do, how successful 
halt-poll in the guest is, and what improvement halt-polling brings.
The amount of polling will be reduced to zero if polling 
is not successful.

