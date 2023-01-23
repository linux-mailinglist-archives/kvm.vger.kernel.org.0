Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076176788F3
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbjAWU66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbjAWU6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:58:46 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F4DEC4D;
        Mon, 23 Jan 2023 12:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=e32s12OZeZPmUAIBV6e3MlO1ukdEIkvaneutSmlGJOw=; b=RFvWmzO5XAXR3iWX6Ms10lg1CS
        0NAWAMH9UZ2o+rnHkFkj4Z9it6hcaRo3UJcQDEuQ8cEMtZHAx4SphwAzl/CiQPeZPpkAHYAYM5Qn5
        f2ykUTICYqjZenTHscGfzcs1sLXklOSBLL13fXfqm3aZn1PS0RnMRU/CleDqzZthaGd7rJuqwG5P/
        oap6vCh2BBTw6kSMN8cAiLaw0oqwvFJIhL2vcflmdZHCDOxK9PmgwHtZxKSVcJGRQNYajNlZi0kjV
        wdzdT4i2XAL9Q2jjPyEowt4jDubGZfAY2GMTdW1Owp3wDRCzvKRWvCZg6VcWwIFEIlDCobi0afqWR
        IPJsciBw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pK3s9-001dtl-3C;
        Mon, 23 Jan 2023 20:57:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5DAEB30008D;
        Mon, 23 Jan 2023 21:57:24 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id D1D702075A6DE; Mon, 23 Jan 2023 21:57:24 +0100 (CET)
Message-ID: <20230123205515.118011340@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 23 Jan 2023 21:50:13 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, rostedt@goodmis.org, mhiramat@kernel.org,
        wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 4/6] x86: Mark sched_clock() noinstr
References: <20230123205009.790550642@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to use sched_clock() from noinstr code, mark it and all it's
implenentations noinstr.

The whole pvclock thing (used by KVM/Xen) is a bit of a pain,
since it calls out to watchdogs, create a
pvclock_clocksource_read_nowd() variant doesn't do that and can be
noinstr.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/kvmclock.h |    2 +-
 arch/x86/include/asm/paravirt.h |    2 +-
 arch/x86/include/asm/pvclock.h  |    3 ++-
 arch/x86/kernel/cpu/vmware.c    |    2 +-
 arch/x86/kernel/kvmclock.c      |    6 +++---
 arch/x86/kernel/pvclock.c       |   19 +++++++++++++++----
 arch/x86/kernel/tsc.c           |    7 +++----
 arch/x86/xen/time.c             |   12 ++++++++++--
 include/linux/math64.h          |    4 ++--
 9 files changed, 38 insertions(+), 19 deletions(-)

--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -8,7 +8,7 @@ extern struct clocksource kvm_clock;
 
 DECLARE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 
-static inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
+static __always_inline struct pvclock_vcpu_time_info *this_cpu_pvti(void)
 {
 	return &this_cpu_read(hv_clock_per_cpu)->pvti;
 }
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -26,7 +26,7 @@ DECLARE_STATIC_CALL(pv_sched_clock, dumm
 
 void paravirt_set_sched_clock(u64 (*func)(void));
 
-static inline u64 paravirt_sched_clock(void)
+static __always_inline u64 paravirt_sched_clock(void)
 {
 	return static_call(pv_sched_clock)();
 }
--- a/arch/x86/include/asm/pvclock.h
+++ b/arch/x86/include/asm/pvclock.h
@@ -7,6 +7,7 @@
 
 /* some helper functions for xen and kvm pv clock sources */
 u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
+u64 pvclock_clocksource_read_nowd(struct pvclock_vcpu_time_info *src);
 u8 pvclock_read_flags(struct pvclock_vcpu_time_info *src);
 void pvclock_set_flags(u8 flags);
 unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src);
@@ -39,7 +40,7 @@ bool pvclock_read_retry(const struct pvc
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
  * yielding a 64-bit result.
  */
-static inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, int shift)
+static __always_inline u64 pvclock_scale_delta(u64 delta, u32 mul_frac, int shift)
 {
 	u64 product;
 #ifdef __i386__
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -143,7 +143,7 @@ static __init int parse_no_stealacc(char
 }
 early_param("no-steal-acc", parse_no_stealacc);
 
-static unsigned long long notrace vmware_sched_clock(void)
+static noinstr u64 vmware_sched_clock(void)
 {
 	unsigned long long ns;
 
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -71,12 +71,12 @@ static int kvm_set_wallclock(const struc
 	return -ENODEV;
 }
 
-static u64 kvm_clock_read(void)
+static noinstr u64 kvm_clock_read(void)
 {
 	u64 ret;
 
 	preempt_disable_notrace();
-	ret = pvclock_clocksource_read(this_cpu_pvti());
+	ret = pvclock_clocksource_read_nowd(this_cpu_pvti());
 	preempt_enable_notrace();
 	return ret;
 }
@@ -86,7 +86,7 @@ static u64 kvm_clock_get_cycles(struct c
 	return kvm_clock_read();
 }
 
-static u64 kvm_sched_clock_read(void)
+static noinstr u64 kvm_sched_clock_read(void)
 {
 	return kvm_clock_read() - kvm_sched_clock_offset;
 }
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -64,7 +64,8 @@ u8 pvclock_read_flags(struct pvclock_vcp
 	return flags & valid_flags;
 }
 
-u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
+static __always_inline
+u64 __pvclock_clocksource_read(struct pvclock_vcpu_time_info *src, bool dowd)
 {
 	unsigned version;
 	u64 ret;
@@ -77,7 +78,7 @@ u64 pvclock_clocksource_read(struct pvcl
 		flags = src->flags;
 	} while (pvclock_read_retry(src, version));
 
-	if (unlikely((flags & PVCLOCK_GUEST_STOPPED) != 0)) {
+	if (dowd && unlikely((flags & PVCLOCK_GUEST_STOPPED) != 0)) {
 		src->flags &= ~PVCLOCK_GUEST_STOPPED;
 		pvclock_touch_watchdogs();
 	}
@@ -100,15 +101,25 @@ u64 pvclock_clocksource_read(struct pvcl
 	 * updating at the same time, and one of them could be slightly behind,
 	 * making the assumption that last_value always go forward fail to hold.
 	 */
-	last = atomic64_read(&last_value);
+	last = arch_atomic64_read(&last_value);
 	do {
 		if (ret <= last)
 			return last;
-	} while (!atomic64_try_cmpxchg(&last_value, &last, ret));
+	} while (!arch_atomic64_try_cmpxchg(&last_value, &last, ret));
 
 	return ret;
 }
 
+u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
+{
+	return __pvclock_clocksource_read(src, true);
+}
+
+noinstr u64 pvclock_clocksource_read_nowd(struct pvclock_vcpu_time_info *src)
+{
+	return __pvclock_clocksource_read(src, false);
+}
+
 void pvclock_read_wallclock(struct pvclock_wall_clock *wall_clock,
 			    struct pvclock_vcpu_time_info *vcpu_time,
 			    struct timespec64 *ts)
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -215,7 +215,7 @@ static void __init cyc2ns_init_secondary
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
-u64 native_sched_clock(void)
+noinstr u64 native_sched_clock(void)
 {
 	if (static_branch_likely(&__use_tsc)) {
 		u64 tsc_now = rdtsc();
@@ -248,7 +248,7 @@ u64 native_sched_clock_from_tsc(u64 tsc)
 /* We need to define a real function for sched_clock, to override the
    weak default version */
 #ifdef CONFIG_PARAVIRT
-unsigned long long sched_clock(void)
+noinstr u64 sched_clock(void)
 {
 	return paravirt_sched_clock();
 }
@@ -258,8 +258,7 @@ bool using_native_sched_clock(void)
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
 #else
-unsigned long long
-sched_clock(void) __attribute__((alias("native_sched_clock")));
+u64 sched_clock(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
 #endif
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -60,9 +60,17 @@ static u64 xen_clocksource_get_cycles(st
 	return xen_clocksource_read();
 }
 
-static u64 xen_sched_clock(void)
+static noinstr u64 xen_sched_clock(void)
 {
-	return xen_clocksource_read() - xen_sched_clock_offset;
+        struct pvclock_vcpu_time_info *src;
+	u64 ret;
+
+	preempt_disable_notrace();
+	src = &__this_cpu_read(xen_vcpu)->time;
+	ret = pvclock_clocksource_read_nowd(src);
+	ret -= xen_sched_clock_offset;
+	preempt_enable_notrace();
+	return ret;
 }
 
 static void xen_read_wallclock(struct timespec64 *ts)
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -161,7 +161,7 @@ static inline u64 mul_u32_u32(u32 a, u32
 #if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
 
 #ifndef mul_u64_u32_shr
-static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+static __always_inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
 {
 	return (u64)(((unsigned __int128)a * mul) >> shift);
 }
@@ -177,7 +177,7 @@ static inline u64 mul_u64_u64_shr(u64 a,
 #else
 
 #ifndef mul_u64_u32_shr
-static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+static __always_inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
 {
 	u32 ah, al;
 	u64 ret;


