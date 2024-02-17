Return-Path: <kvm+bounces-8966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F51858F27
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 12:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9B0C1F225BE
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 11:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C386A03C;
	Sat, 17 Feb 2024 11:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p3nX9SJ5"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD546A00F
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 11:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708170029; cv=none; b=dZzt9JbBD14iw4Ib4hXzB62vH2rohXnbMubJUhJZhesNNbgPiEogH2AEq4t2jATg0Gs6rWLd1TDynqjDNsvk4autiXqOfr+mgf8VawcFq6yEHg+Eb8ff1UdDUgpF73xl7QATAqovftgz6kcAvZtyVdNH/O8Ru0HRp0ef0heE6Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708170029; c=relaxed/simple;
	bh=xUPK2MjmEnmzNQbdmWvWcsyWK1EMbJbl553VIGGzx7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pOH+zqY4QPQfv6n9pmNqffbMcfwOLto9AqI7EMZVJktQql5y4AsN/vEi+QyyCpAtfOKzrgN99qzSTSDGkn6+wV9X2I9h4Mfax8HXaGDHewfhZg4Y+cSzYsUTdMsvBk9LVfUqZCMp/p57vDlTPGqf5Cq+u3pP0JFrD9/SSBDWoWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p3nX9SJ5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=0RPl/ITPhq1odqGaPpEWntC4wW6tfm4NKhJsQNOd87k=; b=p3nX9SJ5uKcQtzBrQtP8Mt6o7h
	RkuS7SvFAGrQiiVGAEXB4XghL5+LpVtBooOuTE8CBTLMCBdQQdHbVg1SKIQ8gFCB5ppvnNr6u9xal
	SK8VdCZneSryVzCxwcF1TIn8mWqBIpVsp9mR/tQmDvD4v1HsvQuUYbJ7ua3B5Bp3hZIsOtAAhXPeA
	iSYNtJg7mzaj1in3eLY0mikNR2BHOkjLowhpzd74HHsqi7M6j6HGb2tLMr0zDwLTukqXcsmmmS0Aw
	4T3FJgVyaNjH3m47aGFptOPnkAxSSynMQkZH6VMK+YNRqGbYTq54M/gTYHrdEkkFdmqGhp/dVbVoD
	0uGWhQ8Q==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3L-00000007JdV-0BjN;
	Sat, 17 Feb 2024 11:40:25 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3L-00000000346-38gF;
	Sat, 17 Feb 2024 11:40:19 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 1/6] KVM: x86/xen: improve accuracy of Xen timers
Date: Sat, 17 Feb 2024 11:26:59 +0000
Message-ID: <20240217114017.11551-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240217114017.11551-1-dwmw2@infradead.org>
References: <20240217114017.11551-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

A test program such as http://david.woodhou.se/timerlat.c confirms user
reports that timers are increasingly inaccurate as the lifetime of a
guest increases. Reporting the actual delay observed when asking for
100µs of sleep, it starts off OK on a newly-launched guest but gets
worse over time, giving incorrect sleep times:

root@ip-10-0-193-21:~# ./timerlat -c -n 5
00000000 latency 103243/100000 (3.2430%)
00000001 latency 103243/100000 (3.2430%)
00000002 latency 103242/100000 (3.2420%)
00000003 latency 103245/100000 (3.2450%)
00000004 latency 103245/100000 (3.2450%)

The biggest problem is that get_kvmclock_ns() returns inaccurate values
when the guest TSC is scaled. The guest sees a TSC value scaled from the
host TSC by a mul/shift conversion (hopefully done in hardware). The
guest then converts that guest TSC value into nanoseconds using the
mul/shift conversion given to it by the KVM pvclock information.

But get_kvmclock_ns() performs only a single conversion directly from
host TSC to nanoseconds, giving a different result. A test program at
http://david.woodhou.se/tsdrift.c demonstrates the cumulative error
over a day.

It's non-trivial to fix get_kvmclock_ns(), although I'll come back to
that. The actual guest hv_clock is per-CPU, and *theoretically* each
vCPU could be running at a *different* frequency. But this patch is
needed anyway because...

The other issue with Xen timers was that the code would snapshot the
host CLOCK_MONOTONIC at some point in time, and then... after a few
interrupts may have occurred, some preemption perhaps... would also read
the guest's kvmclock. Then it would proceed under the false assumption
that those two happened at the *same* time. Any time which *actually*
elapsed between reading the two clocks was introduced as inaccuracies
in the time at which the timer fired.

Fix it to use a variant of kvm_get_time_and_clockread(), which reads the
host TSC just *once*, then use the returned TSC value to calculate the
kvmclock (making sure to do that the way the guest would instead of
making the same mistake get_kvmclock_ns() does).

Sadly, hrtimers based on CLOCK_MONOTONIC_RAW are not supported, so Xen
timers still have to use CLOCK_MONOTONIC. In practice the difference
between the two won't matter over the timescales involved, as the
*absolute* values don't matter; just the delta.

This does mean a new variant of kvm_get_time_and_clockread() is needed;
called kvm_get_monotonic_and_clockread() because that's what it does.

Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 arch/x86/kvm/x86.c |  61 +++++++++++++++++++++--
 arch/x86/kvm/x86.h |   1 +
 arch/x86/kvm/xen.c | 121 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 149 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f98c5075629..75f46fa3737c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2853,7 +2853,11 @@ static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
 	return v * clock->mult;
 }
 
-static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
+/*
+ * As with get_kvmclock_base_ns(), this counts from boot time, at the
+ * frequency of CLOCK_MONOTONIC_RAW (hence adding gtos->offs_boot).
+ */
+static int do_kvmclock_base(s64 *t, u64 *tsc_timestamp)
 {
 	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
 	unsigned long seq;
@@ -2872,6 +2876,29 @@ static int do_monotonic_raw(s64 *t, u64 *tsc_timestamp)
 	return mode;
 }
 
+/*
+ * This calculates CLOCK_MONOTONIC at the time of the TSC snapshot, with
+ * no boot time offset.
+ */
+static int do_monotonic(s64 *t, u64 *tsc_timestamp)
+{
+	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
+	unsigned long seq;
+	int mode;
+	u64 ns;
+
+	do {
+		seq = read_seqcount_begin(&gtod->seq);
+		ns = gtod->clock.base_cycles;
+		ns += vgettsc(&gtod->clock, tsc_timestamp, &mode);
+		ns >>= gtod->clock.shift;
+		ns += ktime_to_ns(gtod->clock.offset);
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
+	*t = ns;
+
+	return mode;
+}
+
 static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
 {
 	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
@@ -2893,18 +2920,42 @@ static int do_realtime(struct timespec64 *ts, u64 *tsc_timestamp)
 	return mode;
 }
 
-/* returns true if host is using TSC based clocksource */
+/*
+ * Calculates the kvmclock_base_ns (CLOCK_MONOTONIC_RAW + boot time) and
+ * reports the TSC value from which it do so. Returns true if host is
+ * using TSC based clocksource.
+ */
 static bool kvm_get_time_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp)
 {
 	/* checked again under seqlock below */
 	if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode))
 		return false;
 
-	return gtod_is_based_on_tsc(do_monotonic_raw(kernel_ns,
-						      tsc_timestamp));
+	return gtod_is_based_on_tsc(do_kvmclock_base(kernel_ns,
+						     tsc_timestamp));
 }
 
-/* returns true if host is using TSC based clocksource */
+/*
+ * Calculates CLOCK_MONOTONIC and reports the TSC value from which it did
+ * so. Returns true if host is using TSC based clocksource.
+ */
+bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp)
+{
+	/* checked again under seqlock below */
+	if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode))
+		return false;
+
+	return gtod_is_based_on_tsc(do_monotonic(kernel_ns,
+						 tsc_timestamp));
+}
+
+/*
+ * Calculates CLOCK_REALTIME and reports the TSC value from which it did
+ * so. Returns true if host is using TSC based clocksource.
+ *
+ * DO NOT USE this for anything related to migration. You want CLOCK_TAI
+ * for that.
+ */
 static bool kvm_get_walltime_and_clockread(struct timespec64 *ts,
 					   u64 *tsc_timestamp)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2f7e19166658..56b7a78f45bf 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -294,6 +294,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
 uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm);
+bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
 
 int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
 	gva_t addr, void *val, unsigned int bytes,
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 11ab62ca011d..4a24899bbcfa 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -24,6 +24,7 @@
 #include <xen/interface/sched.h>
 
 #include <asm/xen/cpuid.h>
+#include <asm/pvclock.h>
 
 #include "cpuid.h"
 #include "trace.h"
@@ -149,8 +150,93 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 delta_ns)
+static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs,
+				bool linux_wa)
 {
+	uint64_t guest_now;
+	int64_t kernel_now, delta;
+
+	/*
+	 * The guest provides the requested timeout in absolute nanoseconds
+	 * of the KVM clock — as *it* sees it, based on the scaled TSC and
+	 * the pvclock information provided by KVM.
+	 *
+	 * The kernel doesn't support hrtimers based on CLOCK_MONOTONIC_RAW
+	 * so use CLOCK_MONOTONIC. In the timescales covered by timers, the
+	 * difference won't matter much as there is no cumulative effect.
+	 *
+	 * Calculate the time for some arbitrary point in time around "now"
+	 * in terms of both kvmclock and CLOCK_MONOTONIC. Calculate the
+	 * delta between the kvmclock "now" value and the guest's requested
+	 * timeout, apply the "Linux workaround" described below, and add
+	 * the resulting delta to the CLOCK_MONOTONIC "now" value, to get
+	 * the absolute CLOCK_MONOTONIC time at which the timer should
+	 * fire.
+	 */
+	if (vcpu->arch.hv_clock.version && vcpu->kvm->arch.use_master_clock &&
+	    static_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
+		uint64_t host_tsc, guest_tsc;
+
+		if (!IS_ENABLED(CONFIG_64BIT) ||
+		    !kvm_get_monotonic_and_clockread(&kernel_now, &host_tsc)) {
+			/*
+			 * Don't fall back to get_kvmclock_ns() because it's
+			 * broken; it has a systemic error in its results
+			 * because it scales directly from host TSC to
+			 * nanoseconds, and doesn't scale first to guest TSC
+			 * and then* to nanoseconds as the guest does.
+			 *
+			 * There is a small error introduced here because time
+			 * continues to elapse between the ktime_get() and the
+			 * subsequent rdtsc(). But not the systemic drift due
+			 * to get_kvmclock_ns().
+			 */
+			kernel_now = ktime_get(); /* This is CLOCK_MONOTONIC */
+			host_tsc = rdtsc();
+		}
+
+		/* Calculate the guest kvmclock as the guest would do it. */
+		guest_tsc = kvm_read_l1_tsc(vcpu, host_tsc);
+		guest_now = __pvclock_read_cycles(&vcpu->arch.hv_clock,
+						  guest_tsc);
+	} else {
+		/*
+		 * Without CONSTANT_TSC, get_kvmclock_ns() is the only option.
+		 *
+		 * Also if the guest PV clock hasn't been set up yet, as is
+		 * likely to be the case during migration when the vCPU has
+		 * not been run yet. It would be possible to calculate the
+		 * scaling factors properly in that case but there's not much
+		 * point in doing so. The get_kvmclock_ns() drift accumulates
+		 * over time, so it's OK to use it at startup. Besides, on
+		 * migration there's going to be a little bit of skew in the
+		 * precise moment at which timers fire anyway. Often they'll
+		 * be in the "past" by the time the VM is running again after
+		 * migration.
+		 */
+		guest_now = get_kvmclock_ns(vcpu->kvm);
+		kernel_now = ktime_get();
+	}
+
+	delta = guest_abs - guest_now;
+
+	/* Xen has a 'Linux workaround' in do_set_timer_op() which
+	 * checks for negative absolute timeout values (caused by
+	 * integer overflow), and for values about 13 days in the
+	 * future (2^50ns) which would be caused by jiffies
+	 * overflow. For those cases, it sets the timeout 100ms in
+	 * the future (not *too* soon, since if a guest really did
+	 * set a long timeout on purpose we don't want to keep
+	 * churning CPU time by waking it up).
+	 */
+	if (linux_wa) {
+		if ((unlikely((int64_t)guest_abs < 0 ||
+			      (delta > 0 && (uint32_t) (delta >> 50) != 0)))) {
+			delta = 100 * NSEC_PER_MSEC;
+			guest_abs = guest_now + delta;
+		}
+	}
+
 	/*
 	 * Avoid races with the old timer firing. Checking timer_expires
 	 * to avoid calling hrtimer_cancel() will only have false positives
@@ -162,12 +248,11 @@ static void kvm_xen_start_timer(struct kvm_vcpu *vcpu, u64 guest_abs, s64 delta_
 	atomic_set(&vcpu->arch.xen.timer_pending, 0);
 	vcpu->arch.xen.timer_expires = guest_abs;
 
-	if (delta_ns <= 0) {
+	if (delta <= 0) {
 		xen_timer_callback(&vcpu->arch.xen.timer);
 	} else {
-		ktime_t ktime_now = ktime_get();
 		hrtimer_start(&vcpu->arch.xen.timer,
-			      ktime_add_ns(ktime_now, delta_ns),
+			      ktime_add_ns(kernel_now, delta),
 			      HRTIMER_MODE_ABS_HARD);
 	}
 }
@@ -1000,8 +1085,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		/* Start the timer if the new value has a valid vector+expiry. */
 		if (data->u.timer.port && data->u.timer.expires_ns)
 			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
-					    data->u.timer.expires_ns -
-					    get_kvmclock_ns(vcpu->kvm));
+					    false);
 
 		r = 0;
 		break;
@@ -1475,7 +1559,6 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
 {
 	struct vcpu_set_singleshot_timer oneshot;
 	struct x86_exception e;
-	s64 delta;
 
 	if (!kvm_xen_timer_enabled(vcpu))
 		return false;
@@ -1509,9 +1592,7 @@ static bool kvm_xen_hcall_vcpu_op(struct kvm_vcpu *vcpu, bool longmode, int cmd,
 			return true;
 		}
 
-		/* A delta <= 0 results in an immediate callback, which is what we want */
-		delta = oneshot.timeout_abs_ns - get_kvmclock_ns(vcpu->kvm);
-		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, delta);
+		kvm_xen_start_timer(vcpu, oneshot.timeout_abs_ns, false);
 		*r = 0;
 		return true;
 
@@ -1535,25 +1616,7 @@ static bool kvm_xen_hcall_set_timer_op(struct kvm_vcpu *vcpu, uint64_t timeout,
 		return false;
 
 	if (timeout) {
-		uint64_t guest_now = get_kvmclock_ns(vcpu->kvm);
-		int64_t delta = timeout - guest_now;
-
-		/* Xen has a 'Linux workaround' in do_set_timer_op() which
-		 * checks for negative absolute timeout values (caused by
-		 * integer overflow), and for values about 13 days in the
-		 * future (2^50ns) which would be caused by jiffies
-		 * overflow. For those cases, it sets the timeout 100ms in
-		 * the future (not *too* soon, since if a guest really did
-		 * set a long timeout on purpose we don't want to keep
-		 * churning CPU time by waking it up).
-		 */
-		if (unlikely((int64_t)timeout < 0 ||
-			     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
-			delta = 100 * NSEC_PER_MSEC;
-			timeout = guest_now + delta;
-		}
-
-		kvm_xen_start_timer(vcpu, timeout, delta);
+		kvm_xen_start_timer(vcpu, timeout, true);
 	} else {
 		kvm_xen_stop_timer(vcpu);
 	}
-- 
2.43.0


