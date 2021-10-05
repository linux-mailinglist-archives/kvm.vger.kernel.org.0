Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9CF4227AD
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbhJENYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233910AbhJENYG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633440135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7QiTigWnRE0qebTdUZknIPdi6HRMo3UWM5OiPBiicY=;
        b=CrBFXkjbnrQzuUYqN0vNLMbLHCcTUaYnHJutGP0m/NPbgr9UMetxEdRNifr99eiqsHK1e5
        Gn7bWmI+ISXG4QGPnwFsNteDY4CIsuyr4xaoPZ6Rhi37X6TPv0RcTlNryVdQkSEIFF1jU6
        l1cqfgJRofmwUPNzg2LtHjfja/pH3yk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-emQhK1cwMMKfZRNZNWIIcA-1; Tue, 05 Oct 2021 09:22:14 -0400
X-MC-Unique: emQhK1cwMMKfZRNZNWIIcA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFFA7835DE0;
        Tue,  5 Oct 2021 13:22:12 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B1ECB5F4E7;
        Tue,  5 Oct 2021 13:22:02 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 27BCA416D862; Tue,  5 Oct 2021 10:21:59 -0300 (-03)
Date:   Tue, 5 Oct 2021 10:21:59 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com, tglx@linutronix.de,
        frederic@kernel.org, mingo@kernel.org, nilal@redhat.com,
        Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH v1] KVM: isolation: retain initial mask for kthread VM
 worker
Message-ID: <20211005132159.GA134926@fuller.cnet>
References: <20211004222639.239209-1-nitesh@redhat.com>
 <e734691b-e9e1-10a0-88ee-73d8fceb50f9@redhat.com>
 <20211005105812.GA130626@fuller.cnet>
 <96f38a69-2ff8-a78c-a417-d32f1eb742be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96f38a69-2ff8-a78c-a417-d32f1eb742be@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05, 2021 at 01:25:52PM +0200, Paolo Bonzini wrote:
> On 05/10/21 12:58, Marcelo Tosatti wrote:
> > > There are other effects of cgroups (e.g. memory accounting) than just the
> > > cpumask;
> > 
> > Is kvm-nx-hpage using significant amounts of memory?
> 
> No, that was just an example (and not a good one indeed, because
> kvm-nx-hpage is not using a substantial amount of either memory or CPU).
> But for example vhost also uses cgroup_attach_task_all, so it should have
> the same issue with SCHED_FIFO?

Yes. Would need to fix vhost as well.

> 
> > > Why doesn't the scheduler move the task to a CPU that is not being hogged by
> > > vCPU SCHED_FIFO tasks?
> > Because cpuset placement is enforced:
> 
> Yes, but I would expect the parent cgroup to include both isolated CPUs (for
> the vCPU threads) and non-isolated housekeeping vCPUs (for the QEMU I/O
> thread).  

Yes, the parent, but why would that matter? If you are in a child
cpuset, you are restricted to the child cpuset mask (and not the
parents).

> The QEMU I/O thread is not hogging the CPU 100% of the time, and
> therefore the nx-recovery thread should be able to run on that CPU.

Yes, but:

1) The cpumask of the parent thread is not inherited 

	set_cpus_allowed_ptr(task, housekeeping_cpumask(HK_FLAG_KTHREAD));

On __kthread_create_on_node should fail (because its cgroup, the one
inherited from QEMU, contains only isolated CPUs).

(The QEMU I/O thread runs on an isolated CPU, and is moved by libvirt
to HK-cgroup as mentioned before).

2) What if kernel threads that should be pinned to non-isolated CPUs are created
from vcpus? 



> 
> Thanks,
> 
> Paolo
> 
> > CPUSET(7)                            Linux Programmer's Manual                           CPUSET(7)
> > 
> >         Cpusets are integrated with the sched_setaffinity(2) scheduling affinity mechanism and  the
> >         mbind(2)  and set_mempolicy(2) memory-placement mechanisms in the kernel.  Neither of these
> >         mechanisms let a process make use of a CPU or memory node  that  is  not  allowed  by  that
> >         process's  cpuset.   If  changes  to a process's cpuset placement conflict with these other
> >         mechanisms, then cpuset placement is enforced even if it means overriding these other mech‐
> >         anisms.   The kernel accomplishes this overriding by silently restricting the CPUs and mem‐
> >         ory nodes requested by these other mechanisms to those allowed by  the  invoking  process's
> >         cpuset.   This  can  result in these other calls returning an error, if for example, such a
> >         call ends up requesting an empty set of  CPUs  or  memory  nodes,  after  that  request  is
> >         restricted to the invoking process's cpuset.
> > 
> > 
> 
> 

