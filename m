Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4F709524
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjESKgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjESKeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892BDE5D;
        Fri, 19 May 2023 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=oLBoSaVp3WekjBQYhO4JPOJSW0AQPAtxk0yC89gO6Pg=; b=uKRVJy5sUKL/o6KVz/EzG1JmJV
        6N0e2PK34KDhR9DEbiPEcDZekm3+FqBiihDSGI2x6TVoGMVwa2B516kqhvchhJRm/QJk5aUeaiFyQ
        mPL7arOZl4UTHRUMsv010g5MZlR38lvNUw9GkemBFSyLE3CugKAmxwenAy8/mdKFjP71mhdgvOgrs
        M779+UNhLz8c5b+lCrJXac89jea2V0XiYzreJDyP8YKJo7a7r+v243rhG0vhtMM0u9BO9dW436HFz
        TY9G49ZWNJytbpkd3z2c4+3AXUs7I2kFUCwdDnJQfEHhmELA6sZyusIRBRpWaHgwwf3VJhg2inqGN
        tc7QRuHg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzxPv-006UqS-Mw; Fri, 19 May 2023 10:33:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 18815306128;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id C9892235EF0AA; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.570170436@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:04 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     bigeasy@linutronix.de
Cc:     mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, peterz@infradead.org, longman@redhat.com,
        boqun.feng@gmail.com, pmladek@suse.com, senozhatsky@chromium.org,
        rostedt@goodmis.org, john.ogness@linutronix.de,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, jstultz@google.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v2 06/13] s390/time: Provide sched_clock_noinstr()
References: <20230519102058.581557770@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the intent to provide local_clock_noinstr(), a variant of
local_clock() that's safe to be called from noinstr code (with the
assumption that any such code will already be non-preemptible),
prepare for things by providing a noinstr sched_clock_noinstr()
function.

Specifically, preempt_enable_*() calls out to schedule(), which upsets
noinstr validation efforts.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/s390/include/asm/timex.h |   13 +++++++++----
 arch/s390/kernel/time.c       |   11 ++++++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -63,7 +63,7 @@ static inline int store_tod_clock_ext_cc
 	return cc;
 }
 
-static inline void store_tod_clock_ext(union tod_clock *tod)
+static __always_inline void store_tod_clock_ext(union tod_clock *tod)
 {
 	asm volatile("stcke %0" : "=Q" (*tod) : : "cc");
 }
@@ -177,7 +177,7 @@ static inline void local_tick_enable(uns
 
 typedef unsigned long cycles_t;
 
-static inline unsigned long get_tod_clock(void)
+static __always_inline unsigned long get_tod_clock(void)
 {
 	union tod_clock clk;
 
@@ -204,6 +204,11 @@ void init_cpu_timer(void);
 
 extern union tod_clock tod_clock_base;
 
+static __always_inline unsigned long __get_tod_clock_monotonic(void)
+{
+	return get_tod_clock() - tod_clock_base.tod;
+}
+
 /**
  * get_clock_monotonic - returns current time in clock rate units
  *
@@ -216,7 +221,7 @@ static inline unsigned long get_tod_cloc
 	unsigned long tod;
 
 	preempt_disable_notrace();
-	tod = get_tod_clock() - tod_clock_base.tod;
+	tod = __get_tod_clock_monotonic();
 	preempt_enable_notrace();
 	return tod;
 }
@@ -240,7 +245,7 @@ static inline unsigned long get_tod_cloc
  * -> ns = (th * 125) + ((tl * 125) >> 9);
  *
  */
-static inline unsigned long tod_to_ns(unsigned long todval)
+static __always_inline unsigned long tod_to_ns(unsigned long todval)
 {
 	return ((todval >> 9) * 125) + (((todval & 0x1ff) * 125) >> 9);
 }
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -102,6 +102,11 @@ void __init time_early_init(void)
 			((long) qui.old_leap * 4096000000L);
 }
 
+unsigned long long noinstr sched_clock_noinstr(void)
+{
+	return tod_to_ns(__get_tod_clock_monotonic());
+}
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  */


