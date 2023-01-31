Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE4F6827C5
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 09:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjAaI4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 03:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjAaI4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 03:56:00 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615664B764;
        Tue, 31 Jan 2023 00:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dIxm+aCWThEzSn6DIW8FvWBq3c9pv2ibQNS0mHEtmHY=; b=P99yUkPKlFO6Em1noB0wAC0mbH
        VVTyTjchkZs8oTDX6DrLsSDzY4w1iEM7Eq83RPSTC6hbJWvJvsD7eNhZ6CKLRYtCAAjCdFdS+HfI1
        aX4w//t5QEWYp1BLw0UGYf+SnVlyPZDFZr+8ujXvuZH/6C0CnmipvNW6SUlpSmcuGWKGNZMwyJ/C8
        osew0SUGCAOdIAXP1ZD/FUbFzZME+QADr0FIX1E5t0otYJ4Dusdj+9abhDnbB2ZqoTh+qFCJmYY3R
        D1CwEnmecBYG7aaYsUp+dFCskwvnPYeyrAx9mqsIK0clEyzBgdS0EIpPCyxgDKlzHyzLEU+GDj/kH
        qNiRlCmQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMmLe-00BA4r-Iv; Tue, 31 Jan 2023 08:50:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BDED43002BF;
        Tue, 31 Jan 2023 09:50:36 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A1741208358FD; Tue, 31 Jan 2023 09:50:36 +0100 (CET)
Date:   Tue, 31 Jan 2023 09:50:36 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     will@kernel.org, boqun.feng@gmail.com, mark.rutland@arm.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, lpieralisi@kernel.org,
        frederic@kernel.org, paulmck@kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, longman@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2.1 4/9] tracing, preempt: Squash _rcuidle tracing
Message-ID: <Y9jWXKgkxY5EZVwW@hirez.programming.kicks-ass.net>
References: <20230126150829.087606759@infradead.org>
 <20230126151323.526275416@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126151323.526275416@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Extend commit 9aedeaed6fc6 ("tracing, hardirq: No moar _rcuidle()
tracing") to also cover trace_preempt_{on,off}() which were
mysteriously untouched.

Fixes: 9aedeaed6fc6 ("tracing, hardirq: No moar _rcuidle() tracing")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lkml.kernel.org/r/Y9D5AfnOukWNOZ5q@hirez.programming.kicks-ass.net
---
 kernel/trace/trace_preemptirq.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -15,10 +15,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/preemptirq.h>
 
-#ifdef CONFIG_TRACE_IRQFLAGS
-/* Per-cpu variable to prevent redundant calls when IRQs already off */
-static DEFINE_PER_CPU(int, tracing_irq_cpu);
-
 /*
  * Use regular trace points on architectures that implement noinstr
  * tooling: these calls will only happen with RCU enabled, which can
@@ -33,6 +29,10 @@ static DEFINE_PER_CPU(int, tracing_irq_c
 #define trace(point)	if (!in_nmi()) trace_##point##_rcuidle
 #endif
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+/* Per-cpu variable to prevent redundant calls when IRQs already off */
+static DEFINE_PER_CPU(int, tracing_irq_cpu);
+
 /*
  * Like trace_hardirqs_on() but without the lockdep invocation. This is
  * used in the low level entry code where the ordering vs. RCU is important
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
