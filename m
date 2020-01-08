Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA41346AA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 16:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgAHPuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 10:50:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43552 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgAHPuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 10:50:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZclNq8Gr7pU/JCTXFFTTfRWQ9njV8jVe1K8Bz3Pzsz0=; b=gzhPPRxbWxKaI0bZ0WbwrbmXR
        xlSTgzecSP6dVTnbBkKg9qkpoHergsjs7+VQhOuVJA5yY18MfdusUj+sC1u2dmzd3fG0V4ncwLsb8
        yLJnCGRrWQ9v5J3QN2xm8R22Kh6EW/NR93PLH/hFGYY2+0PZeb7T1R8Q5QTjZd94Tje8wUD/f+d7l
        ongVbMqAms69fs7UDvXoOHKwVx5qtVYtSE0LsTrLZiF7/V8/wEMAiLMk+mA8ql4KJJoKWHf0D+kd0
        iWreXHPDj0vq8sBh5hYqpY7/ti2FbxBUbBYAspjZmI8w23DD6uxivJ8guinjSEH0/HvTTYnU9Av7C
        dAcyzKaWg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipDbX-0002mT-5L; Wed, 08 Jan 2020 15:50:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 720FD30025A;
        Wed,  8 Jan 2020 16:49:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 754D62B6157AC; Wed,  8 Jan 2020 16:50:40 +0100 (CET)
Date:   Wed, 8 Jan 2020 16:50:40 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes
 mwait/hlt
Message-ID: <20200108155040.GB2827@hirez.programming.kicks-ass.net>
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 08, 2020 at 09:50:01AM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> To deliver all of the resources of a server to instances in cloud, there are no 
> housekeeping cpus reserved. libvirtd, qemu main loop, kthreads, and other agent/tools 
> etc which can't be offloaded to other hardware like smart nic, these stuff will 
> contend with vCPUs even if MWAIT/HLT instructions executed in the guest.
> 
> The is no trap and yield the pCPU after we expose mwait/hlt to the guest [1][2],
> the top command on host still observe 100% cpu utilization since qemu process is 
> running even though guest who has the power management capability executes mwait. 
> Actually we can observe the physical cpu has already enter deeper cstate by 
> powertop on host.
> 
> For virtualization, there is a HLT activity state in CPU VMCS field which indicates 
> the logical processor is inactive because it executed the HLT instruction, but 
> SDM 24.4.2 mentioned that execution of the MWAIT instruction may put a logical 
> processor into an inactive state, however, this VMCS field never reflects this 
> state.

So far I think I can follow, however it does not explain who consumes
this VMCS state if it is set and how that helps. Also, this:

> This patch avoids fine granularity intercept and reschedule vCPU if MWAIT/HLT
> instructions executed, because it can worse the message-passing workloads which 
> will switch between idle and running frequently in the guest. Lets penalty the 
> vCPU which is long idle through tick-based sampling and preemption.

is just complete gibberish. And I have no idea what problem you're
trying to solve how.

Also, I don't think the TSC/MPERF ratio is architected, we can't assume
this is true for everything that has APERFMPERF.

/me tries to reconstruct intent from patch

So what you're doing is, mark the CPU 'idle' when the MPERF/TSC ratio <
1%, and then frob the vruntime such that it will hopefully preempt.
That's pretty disgusting.

Please, write a coherent problem statement and justify the magic
choices. This is unreviewable.
