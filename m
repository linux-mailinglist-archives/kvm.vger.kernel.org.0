Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF22470950D
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbjESKep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjESKeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660D710C9;
        Fri, 19 May 2023 03:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=cKpejYmfn/dwgoc8/Ux+H5v1/oKuMUaJW2+Pm10iheA=; b=hHewstjGYkEwmftSKz7hwTlnXO
        XqnHqg3tnw9L6JOIXGSPQBnDGOnhnV82EMWaDAgsbdrN1T8YocHYPCffaa9YgB4Vwgz5Vi5OVc5lp
        krAi7/gqRn7Rkl+eIDbL9JFmrLe6RcyInAFCntZiWVGMoqtF9WGgAtjQQBpY4T/ivHIy4pbJ7FTux
        q2d27w30skvDgoOu34zbjF9h8l3HwTfqFC8xIL2wNc0BcPUmQh+Di3OV+Fka0Gl5YgyBnlO4tagwZ
        Nz+7U1gafXZWgFBYVocD5gvABRX7o4XHRlGJcDbdzNw7TRGAOxz66P6rc+AfluCm/laqHDb3nn+FS
        jUWBtljA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzxPv-006UqH-0F; Fri, 19 May 2023 10:32:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4730030614E;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id EB58B235EF0B0; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.910937674@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:09 +0200
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
Subject: [PATCH v2 11/13] x86/tsc: Provide sched_clock_noinstr()
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

  vmlinux.o: warning: objtool: native_sched_clock+0x96: call to preempt_schedule_notrace_thunk() leaves .noinstr.text section
  vmlinux.o: warning: objtool: kvm_clock_read+0x22: call to preempt_schedule_notrace_thunk() leaves .noinstr.text section

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/hyperv_timer.h |    5 ++++
 arch/x86/kernel/kvmclock.c          |    4 +--
 arch/x86/kernel/tsc.c               |   38 +++++++++++++++++++++++--------
 arch/x86/kvm/x86.c                  |    7 ++---
 arch/x86/xen/time.c                 |    3 --
 drivers/clocksource/hyperv_timer.c  |   44 ++++++++++++++++++++++--------------
 include/clocksource/hyperv_timer.h  |   24 +++++++------------
 7 files changed, 76 insertions(+), 49 deletions(-)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -71,7 +71,7 @@ static int kvm_set_wallclock(const struc
 	return -ENODEV;
 }
 
-static noinstr u64 kvm_clock_read(void)
+static u64 kvm_clock_read(void)
 {
 	u64 ret;
 
@@ -88,7 +88,7 @@ static u64 kvm_clock_get_cycles(struct c
 
 static noinstr u64 kvm_sched_clock_read(void)
 {
-	return kvm_clock_read() - kvm_sched_clock_offset;
+	return pvclock_clocksource_read_nowd(this_cpu_pvti()) - kvm_sched_clock_offset;
 }
 
 static inline void kvm_sched_clock_init(bool stable)
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -69,12 +69,10 @@ static int __init tsc_early_khz_setup(ch
 }
 early_param("tsc_early_khz", tsc_early_khz_setup);
 
-__always_inline void cyc2ns_read_begin(struct cyc2ns_data *data)
+__always_inline void __cyc2ns_read(struct cyc2ns_data *data)
 {
 	int seq, idx;
 
-	preempt_disable_notrace();
-
 	do {
 		seq = this_cpu_read(cyc2ns.seq.seqcount.sequence);
 		idx = seq & 1;
@@ -86,6 +84,12 @@ __always_inline void cyc2ns_read_begin(s
 	} while (unlikely(seq != this_cpu_read(cyc2ns.seq.seqcount.sequence)));
 }
 
+__always_inline void cyc2ns_read_begin(struct cyc2ns_data *data)
+{
+	preempt_disable_notrace();
+	__cyc2ns_read(data);
+}
+
 __always_inline void cyc2ns_read_end(void)
 {
 	preempt_enable_notrace();
@@ -115,18 +119,25 @@ __always_inline void cyc2ns_read_end(voi
  *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
 
-static __always_inline unsigned long long cycles_2_ns(unsigned long long cyc)
+static __always_inline unsigned long long __cycles_2_ns(unsigned long long cyc)
 {
 	struct cyc2ns_data data;
 	unsigned long long ns;
 
-	cyc2ns_read_begin(&data);
+	__cyc2ns_read(&data);
 
 	ns = data.cyc2ns_offset;
 	ns += mul_u64_u32_shr(cyc, data.cyc2ns_mul, data.cyc2ns_shift);
 
-	cyc2ns_read_end();
+	return ns;
+}
 
+static __always_inline unsigned long long cycles_2_ns(unsigned long long cyc)
+{
+	unsigned long long ns;
+	preempt_disable_notrace();
+	ns = __cycles_2_ns(cyc);
+	preempt_enable_notrace();
 	return ns;
 }
 
@@ -223,7 +234,7 @@ noinstr u64 native_sched_clock(void)
 		u64 tsc_now = rdtsc();
 
 		/* return the value in ns */
-		return cycles_2_ns(tsc_now);
+		return __cycles_2_ns(tsc_now);
 	}
 
 	/*
@@ -250,7 +261,7 @@ u64 native_sched_clock_from_tsc(u64 tsc)
 /* We need to define a real function for sched_clock, to override the
    weak default version */
 #ifdef CONFIG_PARAVIRT
-noinstr u64 sched_clock(void)
+noinstr u64 sched_clock_noinstr(void)
 {
 	return paravirt_sched_clock();
 }
@@ -260,11 +271,20 @@ bool using_native_sched_clock(void)
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
 #else
-u64 sched_clock(void) __attribute__((alias("native_sched_clock")));
+u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
 #endif
 
+notrace u64 sched_clock(void)
+{
+	u64 now;
+	preempt_disable_notrace();
+	now = sched_clock_noinstr();
+	preempt_enable_notrace();
+	return now;
+}
+
 int check_tsc_unstable(void)
 {
 	return tsc_unstable;
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -66,11 +66,10 @@ static noinstr u64 xen_sched_clock(void)
         struct pvclock_vcpu_time_info *src;
 	u64 ret;
 
-	preempt_disable_notrace();
 	src = &__this_cpu_read(xen_vcpu)->time;
 	ret = pvclock_clocksource_read_nowd(src);
 	ret -= xen_sched_clock_offset;
-	preempt_enable_notrace();
+
 	return ret;
 }
 


