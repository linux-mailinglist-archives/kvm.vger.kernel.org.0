Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492B067AE3F
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 10:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjAYJkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 04:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbjAYJkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 04:40:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC69F30DF;
        Wed, 25 Jan 2023 01:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mAgJz+pic6BVmXYxBN+VWs/MMMnUkDDE/YC6Sdu0ab4=; b=nQunn52byOr6gIM3Gee8jkXqqf
        P6ahezAXaOoJgEZU94N64D+DY4WwzdeoQuN4TSrB2re+n+FRNKB313f7pWE3Axto20QcMUBKawlfC
        V1XlCuQ0HNEXvSEVlc9MCGGDKp9M9zX1BjIEPu/fEx26+EqvosBwmbH9b7QG7nRTmlygLzXEHtwKa
        mJAB4xNAatoGxBX1ofJIpGgNLMwT/i7t85iVTBKKH0Q4JXlZDCPTj6rQBK6UpcUUCjr/3q3NQMTAi
        6qzJSabUvHh49Pf9klLM7hSY7ZwtdmvWkG9b3eRbmn6kPYULi21KJSaokx6M+bIa4JJK6jTNUkaUe
        dH8i0crA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pKcGP-005onB-Pz; Wed, 25 Jan 2023 09:40:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 29E27300137;
        Wed, 25 Jan 2023 10:40:17 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1094A21477E2E; Wed, 25 Jan 2023 10:40:17 +0100 (CET)
Date:   Wed, 25 Jan 2023 10:40:17 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, jgross@suse.com, srivatsa@csail.mit.edu,
        amakhalov@vmware.com, pv-drivers@vmware.com, rostedt@goodmis.org,
        mhiramat@kernel.org, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/6] A few cpuidle vs rcu fixes
Message-ID: <Y9D5AfnOukWNOZ5q@hirez.programming.kicks-ass.net>
References: <20230123205009.790550642@infradead.org>
 <Y9AIj1s5iPPki3dK@FVFF77S0Q05N>
 <Y9AVtUY8bnF3WjQr@FVFF77S0Q05N>
 <Y9Al0PfSsx/VWL31@FVFF77S0Q05N>
 <Y9D31FHOCaSnO5gS@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9D31FHOCaSnO5gS@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 10:35:16AM +0100, Peter Zijlstra wrote:
> tip/sched/core contains the following patch addressing this:
> 
> ---
> commit 9aedeaed6fc6fe8452b9b8225e95cc2b8631ff91
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Thu Jan 12 20:43:49 2023 +0100
> 
>     tracing, hardirq: No moar _rcuidle() tracing
>     
>     Robot reported that trace_hardirqs_{on,off}() tickle the forbidden
>     _rcuidle() tracepoint through local_irq_{en,dis}able().
>     
>     For 'sane' configs, these calls will only happen with RCU enabled and
>     as such can use the regular tracepoint. This also means it's possible
>     to trace them from NMI context again.
>     
>     Reported-by: kernel test robot <lkp@intel.com>
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>     Link: https://lore.kernel.org/r/20230112195541.477416709@infradead.org
> 
> diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
> index 629f2854e12b..f992444a0b1f 100644
> --- a/kernel/trace/trace_preemptirq.c
> +++ b/kernel/trace/trace_preemptirq.c
> @@ -19,6 +19,20 @@
>  /* Per-cpu variable to prevent redundant calls when IRQs already off */
>  static DEFINE_PER_CPU(int, tracing_irq_cpu);
>  
> +/*
> + * Use regular trace points on architectures that implement noinstr
> + * tooling: these calls will only happen with RCU enabled, which can
> + * use a regular tracepoint.
> + *
> + * On older architectures, use the rcuidle tracing methods (which
> + * aren't NMI-safe - so exclude NMI contexts):
> + */
> +#ifdef CONFIG_ARCH_WANTS_NO_INSTR
> +#define trace(point)	trace_##point
> +#else
> +#define trace(point)	if (!in_nmi()) trace_##point##_rcuidle
> +#endif
> +
>  /*
>   * Like trace_hardirqs_on() but without the lockdep invocation. This is
>   * used in the low level entry code where the ordering vs. RCU is important

For some reason I missed the trace_preempt_{on,off} things, so that then
gets the below on top or so.

diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index f992444a0b1f..ea96b41c8838 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -100,15 +100,13 @@ NOKPROBE_SYMBOL(trace_hardirqs_off);
 
 void trace_preempt_on(unsigned long a0, unsigned long a1)
 {
-	if (!in_nmi())
-		trace_preempt_enable_rcuidle(a0, a1);
+	trace(preempt_enable)(a0, a1);
 	tracer_preempt_on(a0, a1);
 }
 
 void trace_preempt_off(unsigned long a0, unsigned long a1)
 {
-	if (!in_nmi())
-		trace_preempt_disable_rcuidle(a0, a1);
+	trace(preempt_disable)(a0, a1);
 	tracer_preempt_off(a0, a1);
 }
 #endif
