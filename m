Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40F4D848A
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 01:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388170AbfJOXma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 19:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387903AbfJOXma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 19:42:30 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9CF8757C2;
        Tue, 15 Oct 2019 23:42:29 +0000 (UTC)
Received: from mail (ovpn-124-232.rdu2.redhat.com [10.10.124.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA8C019C4F;
        Tue, 15 Oct 2019 23:42:29 +0000 (UTC)
Date:   Tue, 15 Oct 2019 19:42:29 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20191015234229.GC6487@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
 <20191015164952.GE331@redhat.com>
 <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
 <20191015203516.GF331@redhat.com>
 <f375049a-6a45-c0df-a377-66418c8eb7e8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f375049a-6a45-c0df-a377-66418c8eb7e8@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 15 Oct 2019 23:42:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 12:22:31AM +0200, Paolo Bonzini wrote:
> Oh come on.  0.9 is not 12-years old.  virtio 1.0 is 3.5 years old
> (March 2016).  Anything older than 2017 is going to use 0.9.

Sorry if I got the date wrong, but still I don't see the point in
optimizing for legacy virtio. I can't justify forcing everyone to
execute that additional branch for inb/outb, in the attempt to make
legacy virtio faster that nobody should use in combination with
bleeding edge KVM in the host.

> Your tables give:
> 
> 	Samples	  Samples%  Time%     Min Time  Max time       Avg time
> HLT     101128    75.33%    99.66%    0.43us    901000.66us    310.88us
> HLT     118474    19.11%    95.88%    0.33us    707693.05us    43.56us
> 
> If "avg time" means the average time to serve an HLT vmexit, I don't
> understand how you can have an average time of 0.3ms (1/3000th of a
> second) and 100000 samples per second.  Can you explain that to me?

I described it wrong, the bpftrace record was a sleep 5, not a sleep
1. The pipe loop was sure a sleep 1.

I just wanted to show how even on things where you wouldn't even
expected to get HLT like the bpftrace that is pure guest CPU load, you
still get 100k of them (over 5 sec).

The issue is that in production you get a flood more of those with
hundred of CPUs, so the exact number doesn't move the needle.

> Anyway, if the average time is indeed 310us and 43us, it is orders of
> magnitude more than the time spent executing a retpoline.  That time
> will be spent in an indirect branch miss (retpoline) instead of doing
> while(!kvm_vcpu_check_block()), but it doesn't change anything.

Doesn't cpuidle haltpoll disable that loop? Ideally there should be
HLT vmexits then but I don't know how much fewer. This just needs to
be frequent enough that the branch cost pay itself off, but the sure
thing is that HLT vmexit will not go away unless you execute mwait in
guest mode by isolating the CPU in the host.

> Again: what is the real workload that does thousands of CPUIDs per second?

None, but there are always background CPUID vmexits while there are
never inb/outb vmexits.

So the cpuid retpoline removal has a slight chance to pay for the cost
of the branch, the inb/outb retpoline removal cannot pay off the cost
of the branch.

This is why I prefer cpuid as benchmark gadget for the short term
unless inb/outb offers other benchmark related benefits.

Thanks,
Andrea
