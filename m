Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872A73DA39D
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 15:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbhG2NAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 09:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbhG2NAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 09:00:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7C2C061765;
        Thu, 29 Jul 2021 06:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h5N7LaoEx0xFRONzbq8/zc8krUwJF4ItQdsTl0gzVm8=; b=DWV6yTn9RHEIKeoT1XxGwkxI89
        TrAXhPIP0ojWhAXolTHhyQ7RVMHiFvg+CoSUfryoxINO2ZrsmzYk/5cTlnkjT6A6voEzvLsb/j51s
        poLcddukpUev/1hOzINAIjWJ4JB3+f81r+6vw+xsMYR10yvkWbs2d8FI+T7CYK6rNKN9uMgUGylT7
        fx6RnbRIwQA819xJp38fq6xTulv7akx/H+d68Mk2B7yVP83j6rQ8fwJIjuIr72Nlql7oMP7XiyW5i
        cwzRw/bDbIxqpLGRpcAH27dMOEl0RifsDpjWgTWUSPRXX7FWmI7L4MdNtOlGat45N3/yeGxVuN/nm
        HBn/dSkQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m95cI-00H4Xv-QC; Thu, 29 Jul 2021 12:58:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4B47C300215;
        Thu, 29 Jul 2021 14:58:23 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 13DA7200DB821; Thu, 29 Jul 2021 14:58:23 +0200 (CEST)
Date:   Thu, 29 Jul 2021 14:58:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/pmu: Introduce pmc->is_paused to reduce the
 call time of perf interfaces
Message-ID: <YQKl7/0I4p0o0TCY@hirez.programming.kicks-ass.net>
References: <20210728120705.6855-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728120705.6855-1-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 28, 2021 at 08:07:05PM +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Based on our observations, after any vm-exit associated with vPMU, there
> are at least two or more perf interfaces to be called for guest counter
> emulation, such as perf_event_{pause, read_value, period}(), and each one
> will {lock, unlock} the same perf_event_ctx. The frequency of calls becomes
> more severe when guest use counters in a multiplexed manner.
> 
> Holding a lock once and completing the KVM request operations in the perf
> context would introduce a set of impractical new interfaces. So we can
> further optimize the vPMU implementation by avoiding repeated calls to
> these interfaces in the KVM context for at least one pattern:
> 
> After we call perf_event_pause() once, the event will be disabled and its
> internal count will be reset to 0. So there is no need to pause it again
> or read its value. Once the event is paused, event period will not be
> updated until the next time it's resumed or reprogrammed. And there is
> also no need to call perf_event_period twice for a non-running counter,
> considering the perf_event for a running counter is never paused.
> 
> Based on this implementation, for the following common usage of
> sampling 4 events using perf on a 4u8g guest:
> 
>   echo 0 > /proc/sys/kernel/watchdog
>   echo 25 > /proc/sys/kernel/perf_cpu_time_max_percent
>   echo 10000 > /proc/sys/kernel/perf_event_max_sample_rate
>   echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
>   for i in `seq 1 1 10`
>   do
>   taskset -c 0 perf record \
>   -e cpu-cycles -e instructions -e branch-instructions -e cache-misses \
>   /root/br_instr a
>   done
> 
> the average latency of the guest NMI handler is reduced from
> 37646.7 ns to 32929.3 ns (~1.14x speed up) on the Intel ICX server.
> Also, in addition to collecting more samples, no loss of sampling
> accuracy was observed compared to before the optimization.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>

Looks sane I suppose.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

What kinds of VM-exits are the most common?
