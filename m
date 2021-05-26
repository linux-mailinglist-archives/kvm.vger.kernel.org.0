Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EEB391AC2
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhEZOwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbhEZOwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 10:52:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717E4C061574;
        Wed, 26 May 2021 07:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Y2b6LYToSP2jOUuXErFvITeptB1u26Aild4RYzgeNDg=; b=ddgVZpFKUCMUwZTwSHb1GEgpPx
        0gTa9EGy/PW1zblUNZaZc6x4NrqipUEgDumPrPiJltIxAlZmiSdBX6ea9mf8zx/ZOHpJnMhJwLADo
        VLqy4kCgGHbeX9Sg+dF22L/uuLReYH73zo/LX60kPMwXUemH1X+M7K1QK2YFmflieN9YK1hNwXy2V
        kLtlhbD4Gfg76xQMSXP2leIOMioeaH9XYQWb49gL7zvV/EUvXzOHVbRq9vC3L/pnZV0/deLSLVzH2
        0TQ71dInxf5XF+gnsHS5AopBKuSCjgqWr7Fr3d/Ah4Lp0vyqar+Hkeev23gLoZztFgnaI4c+IR60o
        f6a9rQzQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1llur7-004cWX-Ij; Wed, 26 May 2021 14:50:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2CCA930022C;
        Wed, 26 May 2021 16:49:57 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 14E3A2C42F07A; Wed, 26 May 2021 16:49:57 +0200 (CEST)
Date:   Wed, 26 May 2021 16:49:57 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Masanori Misono <m.misono760@gmail.com>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rohit Jain <rohit.k.jain@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] Make vCPUs that are HLT state candidates for
 load balancing
Message-ID: <YK5gFUjh6MX6+vx3@hirez.programming.kicks-ass.net>
References: <20210526133727.42339-1-m.misono760@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526133727.42339-1-m.misono760@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 10:37:26PM +0900, Masanori Misono wrote:
> Hi,
> 
> I observed performance degradation when running some parallel programs on a
> VM that has (1) KVM_FEATURE_PV_UNHALT, (2) KVM_FEATURE_STEAL_TIME, and (3)
> multi-core architecture. The benchmark results are shown at the bottom. An
> example of libvirt XML for creating such VM is
> 
> ```
> [...]
>   <vcpu placement='static'>8</vcpu>
>   <cpu mode='host-model'>
>     <topology sockets='1' cores='8' threads='1'/>
>   </cpu>
>   <qemu:commandline>
>     <qemu:arg value='-cpu'/>
>     <qemu:arg value='host,l3-cache=on,+kvm-pv-unhalt,+kvm-steal-time'/>
>   </qemu:commandline>
> [...]
> ```
> 
> I investigate the cause and found that the problem occurs in the following
> ways:
> 
> - vCPU1 schedules thread A, and vCPU2 schedules thread B. vCPU1 and vCPU2
>   share LLC.
> - Thread A tries to acquire a lock but fails, resulting in a sleep state
>   (via futex.)
> - vCPU1 becomes idle because there are no runnable threads and does HLT,
>   which leads to HLT VMEXIT (if idle=halt, and KVM doesn't disable HLT
>   VMEXIT using KVM_CAP_X86_DISABLE_EXITS).
> - KVM sets vCPU1's st->preempted as 1 in kvm_steal_time_set_preempted().
> - Thread C wakes on vCPU2. vCPU2 tries to do load balancing in
>   select_idle_core(). Although vCPU1 is idle, vCPU1 is not a candidate for
>   load balancing because is_vcpu_preempted(vCPU1) is true, hence
>   available_idle_cpu(vPCU1) is false.
> - As a result, both thread B and thread C stay in the vCPU2's runqueue, and
>   vCPU1 is not utilized.
> 
> The patch changes kvm_arch_cpu_put() so that it does not set st->preempted
> as 1 when a vCPU does HLT VMEXIT. As a result, is_vcpu_preempted(vCPU)
> becomes 0, and the vCPU becomes a candidate for CFS load balancing.

I'm conficted on this; the vcpu stops running, the pcpu can go do
anything, it might start the next task. There is no saying how quickly
the vcpu task can return to running.

I'm guessing your setup doesn't actually overload the system; and when
it doesn't have the vcpu thread to run, the pcpu actually goes idle too.
But for those 1:1 cases we already have knobs to disable much of this
IIRC.

So I'm tempted to say things are working as expected and you're just not
configured right.
