Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BC34223FD
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 12:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbhJELAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 07:00:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233672AbhJELAL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 07:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633431500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ut8PpYxDYU3fYKnKki/cVS6jUVTnoqzGtGuHNfj9bQ8=;
        b=FSq/4nM57tvM0tj60vdZ078y/ZZmZjQ7iTaAwbjcNIUpgMC/G83kTWE/pQCC6O0HTAU/Fk
        hbawP+y6fhlC3tfFQcq58VSyo4nOzOjbYQcTeoM9mF+ZJfs+Rm7wtk8rQrRzTbggcCvSLQ
        oN7DB/AQy723Wbp5WxpUHhKb8WpdSF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-3qFPprxJOWCB924yXGoXLg-1; Tue, 05 Oct 2021 06:58:19 -0400
X-MC-Unique: 3qFPprxJOWCB924yXGoXLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45F04362FB;
        Tue,  5 Oct 2021 10:58:18 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF3C460843;
        Tue,  5 Oct 2021 10:58:17 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id C9604416D862; Tue,  5 Oct 2021 07:58:12 -0300 (-03)
Date:   Tue, 5 Oct 2021 07:58:12 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, tglx@linutronix.de,
        frederic@kernel.org, mingo@kernel.org, nilal@redhat.com,
        Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH v1] KVM: isolation: retain initial mask for kthread VM
 worker
Message-ID: <20211005105812.GA130626@fuller.cnet>
References: <20211004222639.239209-1-nitesh@redhat.com>
 <e734691b-e9e1-10a0-88ee-73d8fceb50f9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e734691b-e9e1-10a0-88ee-73d8fceb50f9@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Tue, Oct 05, 2021 at 11:38:29AM +0200, Paolo Bonzini wrote:
> [+Wanpeng]
> 
> On 05/10/21 00:26, Nitesh Narayan Lal wrote:
> > From: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > kvm_vm_worker_thread() creates a kthread VM worker and migrates it
> > to the parent cgroup using cgroup_attach_task_all() based on its
> > effective cpumask.
> > 
> > In an environment that is booted with the nohz_full kernel option, cgroup's
> > effective cpumask can also include CPUs running in nohz_full mode. These
> > CPUs often run SCHED_FIFO tasks which may result in the starvation of the
> > VM worker if it has been migrated to one of these CPUs.
> 
> There are other effects of cgroups (e.g. memory accounting) than just the
> cpumask; for v1 you could just skip the cpuset, but if
> cgroup_attach_task_all is ever ported to v2's cgroup_attach_task, we will
> not be able to separate the cpuset cgroup from the others.

cgroup_attach_task_all does use cgroup_attach_task on linux-2.6.git...
It would be good to have this working on both cgroup-v1 and cgroup-v2.

Is kvm-nx-hpage using significant amounts of memory?

> Why doesn't the scheduler move the task to a CPU that is not being hogged by
> vCPU SCHED_FIFO tasks?  

Because cpuset placement is enforced:

CPUSET(7)                            Linux Programmer's Manual                           CPUSET(7)

       Cpusets are integrated with the sched_setaffinity(2) scheduling affinity mechanism and  the
       mbind(2)  and set_mempolicy(2) memory-placement mechanisms in the kernel.  Neither of these
       mechanisms let a process make use of a CPU or memory node  that  is  not  allowed  by  that
       process's  cpuset.   If  changes  to a process's cpuset placement conflict with these other
       mechanisms, then cpuset placement is enforced even if it means overriding these other mech‐
       anisms.   The kernel accomplishes this overriding by silently restricting the CPUs and mem‐
       ory nodes requested by these other mechanisms to those allowed by  the  invoking  process's
       cpuset.   This  can  result in these other calls returning an error, if for example, such a
       call ends up requesting an empty set of  CPUs  or  memory  nodes,  after  that  request  is
       restricted to the invoking process's cpuset.


> The parent cgroup should always have one for
> userspace's own housekeeping.
> 
> As an aside, if we decide that KVM's worker threads count as housekeeping,
> you'd still want to bind the kthread to the housekeeping CPUs(*).

This is being done automatically by HK_FLAG_KTHREAD (see
kernel/thread.c).

> 
> Paolo
> 
> (*) switching from kthread_run to kthread_create+kthread_bind_mask
> 
> > Since unbounded kernel threads allowed CPU mask already respects nohz_full
> > CPUs at the time of their setup (because of 9cc5b8656892: "isolcpus: Affine
> > unbound kernel threads to housekeeping cpus"), retain the initial CPU mask
> > for the kthread by stopping its migration to the parent cgroup's effective
> > CPUs.
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> > ---
> >   virt/kvm/kvm_main.c | 20 +++++++++++++++-----
> >   1 file changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 7851f3a1b5f7..87bc193fd020 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -56,6 +56,7 @@
> >   #include <asm/processor.h>
> >   #include <asm/ioctl.h>
> >   #include <linux/uaccess.h>
> > +#include <linux/sched/isolation.h>
> >   #include "coalesced_mmio.h"
> >   #include "async_pf.h"
> > @@ -5634,11 +5635,20 @@ static int kvm_vm_worker_thread(void *context)
> >   	if (err)
> >   		goto init_complete;
> > -	err = cgroup_attach_task_all(init_context->parent, current);
> > -	if (err) {
> > -		kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
> > -			__func__, err);
> > -		goto init_complete;
> > +	/*
> > +	 * For nohz_full enabled environments, don't migrate the worker thread
> > +	 * to parent cgroup as its effective mask may have a CPU running in
> > +	 * nohz_full mode. nohz_full CPUs often run SCHED_FIFO task which could
> > +	 * result in starvation of the worker thread if it is pinned on the same
> > +	 * CPU.
> > +	 */

Actually, we don't want the kthread in the isolated CPUs (irrespective
of nohz_full=, starvation, or anything). Its just about
"don't run a kernel thread on isolated CPUs".

> > +	if (!housekeeping_enabled(HK_FLAG_KTHREAD)) {
> > +		err = cgroup_attach_task_all(init_context->parent, current);
> > +		if (err) {
> > +			kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
> > +				__func__, err);
> > +			goto init_complete;
> > +		}
> >   	}
> >   	set_user_nice(current, task_nice(init_context->parent));
> > 
> 
> 

