Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442D7D97E0
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406457AbfJPQu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbfJPQu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:50:59 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 886C73090FD6;
        Wed, 16 Oct 2019 16:50:58 +0000 (UTC)
Received: from mail (ovpn-124-232.rdu2.redhat.com [10.10.124.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D02660C5D;
        Wed, 16 Oct 2019 16:50:58 +0000 (UTC)
Date:   Wed, 16 Oct 2019 12:50:57 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20191016165057.GJ6487@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
 <20191015164952.GE331@redhat.com>
 <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
 <20191015203516.GF331@redhat.com>
 <f375049a-6a45-c0df-a377-66418c8eb7e8@redhat.com>
 <20191015234229.GC6487@redhat.com>
 <27cc0d6b-6bd7-fcaf-10b4-37bb566871f8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27cc0d6b-6bd7-fcaf-10b4-37bb566871f8@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 16 Oct 2019 16:50:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 09:07:39AM +0200, Paolo Bonzini wrote:
> Yet you would add CPUID to the list even though it is not even there in
> your benchmarks, and is *never* invoked in a hot path by *any* sane

I justified CPUID as a "short term" benchmark gadget, it's one of
those it shouldn't be a problem at all to remove, I couldn't possibly
be against removing it. I only pointed out the fact cpuid on any
modern linux guest is going to run more frequently than any inb/outb
so if I had to pick a benchmark gadget, that remains my favorite one.

> program? Some OSes have never gotten virtio 1.0 drivers.  OpenBSD only
> got it earlier this year.

If the target is an optimization to a cranky OS that can't upgrade
virtio to obtain the full performance benefit from the retpoline
removal too (I don't know the specifics by just reading the above)
then it's a better argument. At least it sounds fair enough not to
unfair penalize the cranky OS forced to run obsolete protocols that
nobody can update or has the time to update.

I mean, until you said there's some OS that cannot upgrade to virtio
1.0, I thought it was perfectly fine to say "if you want to run a
guest with the full benefit of virtio 1.0 on KVM, you should upgrade
to virtio 1.0 and not stick to whatever 3 year old protocol, then also
the inb/outb retpoline will go away if you upgrade the host because
the inb/outb will go away in the first place".

> It still doesn't add up.  0.3ms / 5 is 1/15000th of a second; 43us is
> 1/25000th of a second.  Do you have multiple vCPU perhaps?

Why would I run any test on UP guests? Rather then spending time doing
the math on my results, it's probably quicker that you run it yourself:

https://lkml.kernel.org/r/20190109034941.28759-1-aarcange@redhat.com/

Marcelo should have better reproducers for frequent HLT that is a real
workload we have to pass, I reported the first two random things I had
around that reported fairly frequent HLT. The pipe loop load is
similar to local network I/O.

> The number of vmexits doesn't count (for HLT).  What counts is how long
> they take to be serviced, and as long as it's 1us or more the
> optimization is pointless.
> 
> Consider these pictures
> 
>          w/o optimization                   with optimization
>          ----------------------             -------------------------
> 0us      vmexit                             vmexit
> 500ns    retpoline                          call vmexit handler directly
> 600ns    retpoline                          kvm_vcpu_check_block()
> 700ns    retpoline                          kvm_vcpu_check_block()
> 800ns    kvm_vcpu_check_block()             kvm_vcpu_check_block()
> 900ns    kvm_vcpu_check_block()             kvm_vcpu_check_block()
> ...
> 39900ns  kvm_vcpu_check_block()             kvm_vcpu_check_block()
> 
>                             <interrupt arrives>
> 
> 40000ns  kvm_vcpu_check_block()             kvm_vcpu_check_block()
> 
> 
> Unless the interrupt arrives exactly in the few nanoseconds that it
> takes to execute the retpoline, a direct handling of HLT vmexits makes
> *absolutely no difference*.
> 

You keep focusing on what happens if the host is completely idle (in
which case guest HLT is a slow path) and you keep ignoring the case
that the host isn't completely idle (in which case guest HLT is not a
slow path).

Please note the single_task_running() check which immediately breaks
the kvm_vcpu_check_block() loop if there's even a single other task
that can be scheduled in the runqueue of the host CPU.

What happen when the host is not idle is quoted below:

         w/o optimization                   with optimization
         ----------------------             -------------------------
0us      vmexit                             vmexit
500ns    retpoline                          call vmexit handler directly
600ns    retpoline                          kvm_vcpu_check_block()
700ns    retpoline                          schedule()
800ns    kvm_vcpu_check_block()
900ns    schedule()
...

Disclaimer: the numbers on the left are arbitrary and I just cut and
pasted them from yours, no idea how far off they are.

To be clear, I would find it very reasonable to be requested to proof
the benefit of the HLT optimization with benchmarks specifics for that
single one liner, but until then, the idea that we can drop the
retpoline optimization from the HLT vmexit by just thinking about it,
still doesn't make sense to me, because by thinking about it I come to
the opposite conclusion.

The lack of single_task_running() in the guest driver is also why the
guest cpuidle haltpoll risks to waste some CPU with host overcommit or
with the host loaded at full capacity and why we may not assume it to
be universally enabled.

Thanks,
Andrea
