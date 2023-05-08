Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C6B6FB9F5
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbjEHVgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbjEHVgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:36:39 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90C59ED0;
        Mon,  8 May 2023 14:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=VYuNexE2e9xbspcsGvZenlIDjWfgw2N2vaQA4HRdjvE=; b=PHoZYCvvmT1hG95taohLWS5MV8
        r4yrd4PaEq7f4WAmF+OTmLvnxZVSfMakDad5wTPn12JXCXWk2GLwT8/dDR82lB8BOQgFZxdza3qHL
        vmxpyGPlEnNdGUt4eFmlC32sPr4sJFcHvhAD2uTDLW/dYr36FMZqntEuhrQa0hheIe5LqniryDfKw
        pwnQ8F7RbF1IuPFFlYQv1mEDAd6PbOe1gq/ETRL7d3PmsKqIw4GTCGhKk+RvisoI9lVQLhXJf7NVE
        XQyDGswjUQDEGh3rXK4Pkdl/fMoSt3pHhzKUVr0swTsjJO5WhI208u84das+E8Ia8JtL5ygbTPqG8
        kTf/vQsQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pw8UY-005J1D-2b;
        Mon, 08 May 2023 21:34:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B286C306141;
        Mon,  8 May 2023 23:33:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 4178324829420; Mon,  8 May 2023 23:33:48 +0200 (CEST)
Message-ID: <20230508213147.786238095@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 08 May 2023 23:19:57 +0200
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
Subject: [RFC][PATCH 6/9] s390/time: Provide sched_clock_noinstr()
References: <20230508211951.901961964@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
@@ -102,12 +102,21 @@ void __init time_early_init(void)
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
 unsigned long long notrace sched_clock(void)
 {
-	return tod_to_ns(get_tod_clock_monotonic());
+	unsigned long long ns;
+	preempt_disable_notrace();
+	ns = tod_to_ns(get_tod_clock_monotonic());
+	preempt_enable_notrace();
+	return ns;
 }
 NOKPROBE_SYMBOL(sched_clock);
 


